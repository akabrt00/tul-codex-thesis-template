[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$sourceRoot = (Resolve-Path (Join-Path $repoRoot 'zdroje')).Path
$registryPath = Join-Path $sourceRoot 'REJSTRIK_ZDROJU.md'
$registryText = Get-Content -LiteralPath $registryPath -Raw
$registryLines = Get-Content -LiteralPath $registryPath
$issues = @()
$rows = @()

foreach ($line in $registryLines) {
    if ($line -match '^\|\s*`(SRC-\d{4})`\s*\|') {
        $cells = @($line.Trim().Trim('|').Split('|') | ForEach-Object { $_.Trim().Trim('`') })
        if ($cells.Count -lt 12) { $issues += "Malformed registry row: $line"; continue }
        $rows += [pscustomobject]@{
            id = $cells[0]
            citation_key = $cells[1]
            status = $cells[2]
            local_path = $cells[5]
            raw = $line
        }
    }
}

foreach ($group in $rows | Group-Object id | Where-Object Count -gt 1) { $issues += "Duplicate source ID: $($group.Name)" }
foreach ($group in $rows | Where-Object citation_key | Group-Object citation_key | Where-Object Count -gt 1) { $issues += "Duplicate citation key: $($group.Name)" }

foreach ($row in $rows) {
    if ($row.id -notmatch '^SRC-\d{4}$') { $issues += "Malformed source ID: $($row.id)" }
    if (-not $row.citation_key) { $issues += "$($row.id) has no citacni_klic" }
    if ($row.raw -match '(?i)templates[/\\]') { $issues += "$($row.id) points into templates/" }
    if ($row.local_path -and $row.local_path -ne 'pouze odkaz') {
        $candidate = Join-Path $sourceRoot $row.local_path
        if (-not (Test-Path -LiteralPath $candidate)) { $issues += "$($row.id) path does not exist: $($row.local_path)" }
        elseif ((Get-Item -LiteralPath $candidate).PSIsContainer -eq $false) {
            $expectedKey = [IO.Path]::GetFileNameWithoutExtension($candidate)
            if ($row.citation_key -ne $expectedKey) { $issues += "$($row.id) citation key '$($row.citation_key)' differs from default filename stem '$expectedKey'" }
        }
    }
}

$controlNames = @('AGENTS.md','README.md','REJSTRIK_ZDROJU.md','.gitkeep')
$originalFiles = @(
    Get-ChildItem -LiteralPath $sourceRoot -Recurse -Force -File |
        Where-Object {
            $_.Name -notin $controlNames -and
            $_.FullName -notlike (Join-Path $sourceRoot '90_zpracovane\*')
        }
)
foreach ($file in $originalFiles) {
    $relative = $file.FullName.Substring($sourceRoot.Length + 1).Replace('\', '/')
    if ($registryText -notmatch [regex]::Escape($relative)) { $issues += "Unregistered expert source file: $relative" }
}

$derivatives = @(Get-ChildItem -LiteralPath (Join-Path $sourceRoot '90_zpracovane') -Recurse -Force -File | Where-Object Name -ne '.gitkeep')
foreach ($file in $derivatives) {
    $relative = $file.FullName.Substring($sourceRoot.Length + 1)
    if ($relative -notmatch 'SRC-\d{4}') { $issues += "Derivative path is not associated with an SRC ID: $relative" }
}

$manifests = @($derivatives | Where-Object Name -eq 'manifest.json')
foreach ($manifestFile in $manifests) {
    try { $manifest = Get-Content -Raw -LiteralPath $manifestFile.FullName | ConvertFrom-Json }
    catch { $issues += "Invalid extraction manifest: $($manifestFile.FullName.Substring($sourceRoot.Length + 1))"; continue }
    if ($manifest.source_id -notmatch '^SRC-\d{4}$') { $issues += "Extraction manifest has invalid source_id: $($manifestFile.FullName.Substring($sourceRoot.Length + 1))" }
    $numbers = @($manifest.pages | ForEach-Object { [int]$_.page_number })
    if ($numbers.Count -ne [int]$manifest.page_count -or ($numbers -join ',') -ne ((1..[int]$manifest.page_count) -join ',')) {
        $issues += "Extraction manifest does not preserve a complete sequential page map: $($manifestFile.FullName.Substring($sourceRoot.Length + 1))"
    }
    foreach ($page in $manifest.pages) {
        if (-not (Test-Path -LiteralPath (Join-Path $manifestFile.DirectoryName $page.text_file))) {
            $issues += "Extraction manifest references a missing page file: $($page.text_file)"
        }
    }
}

Write-Output "Registered expert sources: $($rows.Count)"
Write-Output "Original expert-source files: $($originalFiles.Count)"
Write-Output "Derived files: $($derivatives.Count)"
Write-Output 'templates/ was not scanned.'
if ($issues.Count -gt 0) {
    Write-Output "`nSource audit issues:"
    $issues | Sort-Object -Unique | ForEach-Object { Write-Output "- $_" }
    exit 1
}
Write-Output "`nSource audit passed."
