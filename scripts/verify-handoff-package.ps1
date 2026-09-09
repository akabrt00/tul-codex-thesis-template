[CmdletBinding()]
param(
    [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$PackagePath,
    [switch]$AllowIncompleteDescription,
    [switch]$CreateZip
)

$ErrorActionPreference = 'Stop'
if ($AllowIncompleteDescription -and $CreateZip) {
    throw 'CreateZip cannot be combined with AllowIncompleteDescription.'
}
$packageItem = Get-Item -LiteralPath (Resolve-Path -LiteralPath $PackagePath).Path -Force
if (-not $packageItem.PSIsContainer) { throw "PackagePath must be a directory: $PackagePath" }
if (($packageItem.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) {
    throw 'PackagePath cannot be a symbolic link or junction.'
}

$packageRoot = $packageItem.FullName.TrimEnd([IO.Path]::DirectorySeparatorChar, [IO.Path]::AltDirectorySeparatorChar)
$packagePrefix = $packageRoot + [IO.Path]::DirectorySeparatorChar
$zipPath = "$packageRoot.zip"
if ($CreateZip -and (Test-Path -LiteralPath $zipPath)) { throw "ZIP already exists: $zipPath" }
$manifestPath = Join-Path $packageRoot 'manifest.json'
$handoffPath = Join-Path $packageRoot 'PREDANI.md'
$contentRoot = Join-Path $packageRoot 'obsah'
$contentPrefix = [IO.Path]::GetFullPath($contentRoot).TrimEnd(
    [IO.Path]::DirectorySeparatorChar,
    [IO.Path]::AltDirectorySeparatorChar
) + [IO.Path]::DirectorySeparatorChar

foreach ($requiredFile in @($manifestPath, $handoffPath)) {
    if (-not (Test-Path -LiteralPath $requiredFile -PathType Leaf)) { throw "Missing required package file: $requiredFile" }
}
if (-not (Test-Path -LiteralPath $contentRoot -PathType Container)) { throw "Missing content directory: $contentRoot" }

$reparsePoints = @(Get-ChildItem -LiteralPath $packageRoot -Recurse -Force | Where-Object {
    ($_.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0
})
if ($reparsePoints.Count -gt 0) { throw "Package contains a symbolic link or junction: $($reparsePoints[0].FullName)" }

try {
    $manifest = Get-Content -Raw -Encoding UTF8 -LiteralPath $manifestPath | ConvertFrom-Json
} catch {
    throw "Invalid manifest.json: $($_.Exception.Message)"
}

if ([int]$manifest.schema_version -ne 1) { throw "Unsupported schema_version: $($manifest.schema_version)" }
if ([string]$manifest.integration_mode -ne 'review-before-apply') { throw 'Manifest integration_mode must be review-before-apply.' }

function Test-PortableRelativePath {
    param([Parameter(Mandatory)][string]$Path)

    if ([string]::IsNullOrWhiteSpace($Path)) { return $false }
    if ($Path.Contains('\') -or $Path.Contains(':') -or $Path.StartsWith('/')) { return $false }
    foreach ($segment in $Path.Split('/')) {
        if ([string]::IsNullOrWhiteSpace($segment) -or $segment -in @('.', '..')) { return $false }
    }
    return $true
}

function Test-BlockedTarget {
    param([Parameter(Mandatory)][string]$Path)

    $patterns = @(
        '(^|/)\.git($|/)',
        '(^|/)predavani($|/)',
        '(^|/)PROJECT_PROFILE\.json$',
        '(^|/)\.env($|\.)',
        '(^|/)(\.npmrc|\.pypirc|\.netrc)$',
        '(^|/)(credentials?|secrets?)\.json$',
        '(^|/)(id_rsa|id_dsa|id_ecdsa|id_ed25519)$',
        '\.(key|pem|pfx|p12|jks|kdbx)$',
        '(^|/)(\.ci-artifacts|\.ci-work|\.build-logs|node_modules|\.venv|venv|tmp)($|/)',
        '^prace/migrace/kompletni-archiv($|/)',
        '\.(aux|bbl|bcf|blg|fdb_latexmk|fls|idx|ilg|ind|lof|log|lot|nav|out|snm|toc|vrb|xdv)$',
        '\.(run\.xml|synctex\.gz)$'
    )
    foreach ($pattern in $patterns) { if ($Path -match $pattern) { return $true } }
    return $false
}

$issues = [Collections.Generic.List[string]]::new()
$expectedFiles = [Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
$null = $expectedFiles.Add('manifest.json')
$null = $expectedFiles.Add('PREDANI.md')
$manifestEntries = @($manifest.files)

foreach ($entry in $manifestEntries) {
    $relative = [string]$entry.relative_path
    $target = [string]$entry.suggested_target
    if (-not (Test-PortableRelativePath -Path $target)) {
        $issues.Add("Unsafe suggested_target: $target")
        continue
    }
    if (Test-BlockedTarget -Path $target) {
        $issues.Add("Blocked sensitive, generated, or unsafe target: $target")
        continue
    }
    $expectedRelative = "obsah/$target"
    if ($relative -cne $expectedRelative) {
        $issues.Add("relative_path must equal '$expectedRelative', found '$relative'")
        continue
    }
    if (-not $expectedFiles.Add($relative)) {
        $issues.Add("Duplicate manifest path: $relative")
        continue
    }

    $fullPath = [IO.Path]::GetFullPath((Join-Path $packageRoot ($relative.Replace('/', [IO.Path]::DirectorySeparatorChar))))
    if (-not $fullPath.StartsWith($contentPrefix, [StringComparison]::OrdinalIgnoreCase)) {
        $issues.Add("Manifest path escapes obsah/: $relative")
        continue
    }
    if (-not (Test-Path -LiteralPath $fullPath -PathType Leaf)) {
        $issues.Add("Missing file: $relative")
        continue
    }
    $file = Get-Item -LiteralPath $fullPath
    $hash = (Get-FileHash -LiteralPath $fullPath -Algorithm SHA256).Hash.ToLowerInvariant()
    if ([long]$entry.bytes -ne $file.Length) { $issues.Add("Size mismatch: $relative") }
    if ([string]$entry.sha256 -notmatch '^[a-fA-F0-9]{64}$' -or [string]$entry.sha256 -cne $hash) {
        $issues.Add("SHA-256 mismatch: $relative")
    }
}

if ([int]$manifest.file_count -ne $manifestEntries.Count) {
    $issues.Add("Manifest file_count is $($manifest.file_count), but $($manifestEntries.Count) entries were found.")
}
if ($manifestEntries.Count -eq 0) { $issues.Add('Manifest contains no files.') }

foreach ($file in @(Get-ChildItem -LiteralPath $packageRoot -Recurse -Force -File)) {
    $relative = $file.FullName.Substring($packagePrefix.Length).Replace('\', '/')
    if (-not $expectedFiles.Contains($relative)) { $issues.Add("Unexpected file not listed in manifest: $relative") }
}

if (-not $AllowIncompleteDescription) {
    $handoff = Get-Content -Raw -Encoding UTF8 -LiteralPath $handoffPath
    if ($handoff -match '<[^>\r\n]+>') {
        $issues.Add('PREDANI.md still contains template placeholders; complete it before verification for transfer.')
    }
}

if ($issues.Count -gt 0) {
    throw "Package verification failed with $($issues.Count) issue(s):`n- $($issues -join "`n- ")"
}

Write-Output "Verified package: $($manifest.package_id)"
Write-Output "Files: $($manifestEntries.Count)"
Write-Output 'Integrity and package safety: OK'
if ($AllowIncompleteDescription) {
    Write-Warning 'PREDANI.md completeness was not enforced. Do not send or integrate this draft package yet.'
} else {
    Write-Output 'Next step: read PREDANI.md and compare every suggested target before integration.'
}

if ($CreateZip) {
    try {
        Compress-Archive -LiteralPath $packageRoot -DestinationPath $zipPath -CompressionLevel Optimal
    } catch {
        if (Test-Path -LiteralPath $zipPath) { Remove-Item -LiteralPath $zipPath -Force }
        throw
    }
    Write-Output "Verified ZIP: $zipPath"
}
