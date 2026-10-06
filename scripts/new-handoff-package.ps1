[CmdletBinding()]
param(
    [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$Name,
    [Parameter(Mandatory, ValueFromRemainingArguments = $true)][ValidateNotNullOrEmpty()][string[]]$SourcePaths,
    [string]$Recipient = '',
    [string]$Purpose = '',
    [string]$OutputRoot
)

$ErrorActionPreference = 'Stop'
$repoRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..')).TrimEnd(
    [IO.Path]::DirectorySeparatorChar,
    [IO.Path]::AltDirectorySeparatorChar
)
$repoPrefix = $repoRoot + [IO.Path]::DirectorySeparatorChar
$handoffRoot = [IO.Path]::GetFullPath((Join-Path $repoRoot 'predavani')).TrimEnd(
    [IO.Path]::DirectorySeparatorChar,
    [IO.Path]::AltDirectorySeparatorChar
)
$handoffPrefix = $handoffRoot + [IO.Path]::DirectorySeparatorChar

if ([string]::IsNullOrWhiteSpace($OutputRoot)) {
    $OutputRoot = Join-Path $handoffRoot 'odchozi'
}
$outputCandidate = if ([IO.Path]::IsPathRooted($OutputRoot)) { $OutputRoot } else { Join-Path $repoRoot $OutputRoot }
$outputRootFull = [IO.Path]::GetFullPath($outputCandidate).TrimEnd(
    [IO.Path]::DirectorySeparatorChar,
    [IO.Path]::AltDirectorySeparatorChar
)
if (-not ($outputRootFull -eq $handoffRoot -or $outputRootFull.StartsWith($handoffPrefix, [StringComparison]::OrdinalIgnoreCase))) {
    throw "OutputRoot must be inside $handoffRoot"
}

function Get-RepositoryRelativePath {
    param([Parameter(Mandatory)][string]$FullPath)

    $full = [IO.Path]::GetFullPath($FullPath)
    if (-not $full.StartsWith($repoPrefix, [StringComparison]::OrdinalIgnoreCase)) {
        throw "Source must be a file or directory inside the repository: $FullPath"
    }
    return $full.Substring($repoPrefix.Length).Replace('\', '/')
}

function Assert-OrdinaryItem {
    param([Parameter(Mandatory)][IO.FileSystemInfo]$Item)

    if (($Item.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) {
        throw "Symbolic links and junctions cannot be added to a handoff package: $($Item.FullName)"
    }
}

function Assert-AllowedRelativePath {
    param([Parameter(Mandatory)][string]$RelativePath)

    $path = $RelativePath.Replace('\', '/')
    $blockedPatterns = @(
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
    foreach ($pattern in $blockedPatterns) {
        if ($path -match $pattern) {
            throw "Blocked sensitive, generated, or unsafe source path: $RelativePath"
        }
    }
}

$normalized = $Name.Normalize([Text.NormalizationForm]::FormD)
$slug = -join ($normalized.ToCharArray() | Where-Object {
    [Globalization.CharUnicodeInfo]::GetUnicodeCategory($_) -ne [Globalization.UnicodeCategory]::NonSpacingMark
})
$slug = ($slug.ToLowerInvariant() -replace '[^a-z0-9]+', '-').Trim('-')
if ([string]::IsNullOrWhiteSpace($slug)) { throw 'Name must contain at least one letter or number.' }

$sourceFiles = [Collections.Generic.List[IO.FileInfo]]::new()
foreach ($sourcePath in $SourcePaths) {
    $candidate = if ([IO.Path]::IsPathRooted($sourcePath)) { $sourcePath } else { Join-Path $repoRoot $sourcePath }
    $resolved = Resolve-Path -LiteralPath $candidate -ErrorAction Stop
    $item = Get-Item -LiteralPath $resolved.Path -Force
    Assert-OrdinaryItem -Item $item
    $relativeItem = Get-RepositoryRelativePath -FullPath $item.FullName
    Assert-AllowedRelativePath -RelativePath $relativeItem

    if ($item.PSIsContainer) {
        $descendants = @(Get-ChildItem -LiteralPath $item.FullName -Recurse -Force)
        foreach ($descendant in $descendants) { Assert-OrdinaryItem -Item $descendant }
        foreach ($file in @($descendants | Where-Object { -not $_.PSIsContainer })) {
            $relativeFile = Get-RepositoryRelativePath -FullPath $file.FullName
            Assert-AllowedRelativePath -RelativePath $relativeFile
            $sourceFiles.Add($file)
        }
    } else {
        $sourceFiles.Add($item)
    }
}

$uniqueByPath = @{}
foreach ($file in $sourceFiles) { $uniqueByPath[$file.FullName.ToLowerInvariant()] = $file }
$uniqueFiles = @($uniqueByPath.Values | Sort-Object FullName)
if ($uniqueFiles.Count -eq 0) { throw 'No files were selected for the package.' }

$packageId = "$(Get-Date -Format 'yyyy-MM-dd')_$slug"
$packageRoot = Join-Path $outputRootFull $packageId
if (Test-Path -LiteralPath $packageRoot) { throw "Package already exists: $packageRoot" }

$packageCreated = $false
try {
    $contentRoot = Join-Path $packageRoot 'obsah'
    New-Item -ItemType Directory -Path $contentRoot -Force | Out-Null
    $packageCreated = $true
    $manifestFiles = [Collections.Generic.List[object]]::new()

    foreach ($sourceFile in $uniqueFiles) {
        $relative = Get-RepositoryRelativePath -FullPath $sourceFile.FullName
        $destination = Join-Path $contentRoot ($relative.Replace('/', [IO.Path]::DirectorySeparatorChar))
        New-Item -ItemType Directory -Path (Split-Path -Parent $destination) -Force | Out-Null
        Copy-Item -LiteralPath $sourceFile.FullName -Destination $destination
        $copied = Get-Item -LiteralPath $destination
        $hash = (Get-FileHash -LiteralPath $destination -Algorithm SHA256).Hash.ToLowerInvariant()
        $manifestFiles.Add([ordered]@{
            relative_path = "obsah/$relative"
            suggested_target = $relative
            bytes = $copied.Length
            sha256 = $hash
        })
    }

    $manifest = [ordered]@{
        schema_version = 1
        package_id = $packageId
        created_at = (Get-Date).ToString('o')
        sender_project = (Split-Path -Leaf $repoRoot)
        recipient = $Recipient
        purpose = $Purpose
        integration_mode = 'review-before-apply'
        file_count = $manifestFiles.Count
        files = @($manifestFiles)
    }
    $manifest | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath (Join-Path $packageRoot 'manifest.json') -Encoding UTF8

    $handoff = @"
# Předání: $Name

## Komu a proč

- Odesílatel: <doplňte jméno nebo roli>
- Příjemce: $Recipient
- Účel: $Purpose
- Datum: $(Get-Date -Format 'yyyy-MM-dd')

## Co balíček obsahuje

<Doplňte stručný seznam výstupů. Manifest eviduje $($manifestFiles.Count) souborů.>

## Stav práce

<Co je dokončené, co je návrh a co nebylo ověřeno.>

## Důležitá rozhodnutí a předpoklady

<Doplňte rozhodnutí, jednotky, metodiku, verze vstupů a omezení.>

## Ověření

<Doplňte provedené testy, kompilace nebo kontroly a jejich výsledky.>

## Otevřené body a známá rizika

<Co musí příjemce zkontrolovat, doplnit nebo rozhodnout.>

## Požadovaný krok příjemce

Nejdřív ověřte `manifest.json`, porovnejte soubory s cílovým projektem a teprve potom je začleňte. Nic nepřepisujte bez kontroly konfliktů.

## Omezení sdílení

<Doplňte licence, osobní údaje, důvěrnost nebo „bez zvláštních omezení“.>
"@
    $handoff | Set-Content -LiteralPath (Join-Path $packageRoot 'PREDANI.md') -Encoding UTF8

    Write-Output "Package: $packageRoot"
    Write-Output "Files: $($manifestFiles.Count)"
    Write-Output 'Complete PREDANI.md, then verify the package with -CreateZip before sending it.'
} catch {
    if ($packageCreated -and (Test-Path -LiteralPath $packageRoot)) {
        $resolvedPackage = [IO.Path]::GetFullPath($packageRoot)
        $outputPrefix = $outputRootFull + [IO.Path]::DirectorySeparatorChar
        if ($resolvedPackage.StartsWith($outputPrefix, [StringComparison]::OrdinalIgnoreCase)) {
            Remove-Item -LiteralPath $resolvedPackage -Recurse -Force
        }
    }
    throw
}
