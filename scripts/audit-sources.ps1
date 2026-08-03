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
            title = $cells[3]
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

$controlNames = @('AGENTS.md','README.md','REJSTRIK_ZDROJU.md','INDEX_ZDROJU.md','.gitkeep')
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
$globalIndexNames = @('search-index.jsonl', 'search-index-manifest.json')
foreach ($file in $derivatives) {
    $relative = $file.FullName.Substring($sourceRoot.Length + 1)
    $isGlobalIndex = $relative -like '90_zpracovane\index\*' -and $file.Name -in $globalIndexNames
    if (-not $isGlobalIndex -and $relative -notmatch 'SRC-\d{4}') { $issues += "Derivative path is not associated with an SRC ID: $relative" }
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

$contentMapPath = Join-Path $sourceRoot 'INDEX_ZDROJU.md'
$contentMapText = Get-Content -Raw -LiteralPath $contentMapPath
$activeLocalPdfs = @($rows | Where-Object {
    $_.status -eq 'aktivní' -and
    $_.local_path -and
    $_.local_path -ne 'pouze odkaz' -and
    [IO.Path]::GetExtension($_.local_path) -eq '.pdf'
})
foreach ($row in $activeLocalPdfs) {
    $matchingManifests = @($manifests | Where-Object {
        try { (Get-Content -Raw -LiteralPath $_.FullName | ConvertFrom-Json).source_id -eq $row.id }
        catch { $false }
    })
    if ($matchingManifests.Count -ne 1) { $issues += "$($row.id) active PDF requires exactly one extraction manifest, found $($matchingManifests.Count)" }
    $matchingMaps = @($derivatives | Where-Object { $_.Name -match ('^' + [regex]::Escape($row.id) + '.*_mapa-obsahu\.md$') })
    if ($matchingMaps.Count -lt 1) { $issues += "$($row.id) active PDF has no content map" }
    if ($contentMapText -notmatch [regex]::Escape($row.id)) { $issues += "$($row.id) active PDF is missing from INDEX_ZDROJU.md" }
}

$searchIndexPath = Join-Path $sourceRoot '90_zpracovane\index\search-index.jsonl'
$searchManifestPath = Join-Path $sourceRoot '90_zpracovane\index\search-index-manifest.json'
if ((Test-Path -LiteralPath $searchIndexPath) -xor (Test-Path -LiteralPath $searchManifestPath)) {
    $issues += 'Global search index requires both search-index.jsonl and search-index-manifest.json'
}
if ($activeLocalPdfs.Count -gt 0 -and -not (Test-Path -LiteralPath $searchIndexPath)) {
    $issues += 'Active local PDFs exist but the global page-level search index is missing'
}
if ((Test-Path -LiteralPath $searchIndexPath) -and (Test-Path -LiteralPath $searchManifestPath)) {
    try { $searchManifest = Get-Content -Raw -LiteralPath $searchManifestPath | ConvertFrom-Json }
    catch { $issues += 'Invalid search-index-manifest.json'; $searchManifest = $null }
    $indexRecords = @()
    $lineNumber = 0
    foreach ($line in Get-Content -Encoding UTF8 -LiteralPath $searchIndexPath) {
        $lineNumber++
        if ([string]::IsNullOrWhiteSpace($line)) { continue }
        try { $record = $line | ConvertFrom-Json }
        catch { $issues += "Invalid JSONL record at search-index.jsonl line $lineNumber"; continue }
        $indexRecords += $record
        if ($record.source_id -notin $rows.id) { $issues += "Search index references unregistered source: $($record.source_id)" }
        if ([int]$record.page_number -lt 1) { $issues += "Search index has invalid page number for $($record.source_id)" }
        if ([string]$record.text_path -match '(?i)templates[/\\]') { $issues += "Search index points into templates/: $($record.text_path)" }
        $indexedTextPath = Join-Path $sourceRoot ([string]$record.text_path)
        if (-not (Test-Path -LiteralPath $indexedTextPath)) {
            $issues += "Search index points to missing text page: $($record.text_path)"
        } else {
            $resolvedTextPath = (Resolve-Path -LiteralPath $indexedTextPath).Path
            if (-not $resolvedTextPath.StartsWith($sourceRoot + [IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase)) {
                $issues += "Search index text path escapes zdroje/: $($record.text_path)"
            } else {
                $currentTextHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $resolvedTextPath).Hash.ToLowerInvariant()
                if ([string]$record.text_sha256 -ne $currentTextHash) { $issues += "Search index has stale text hash for $($record.source_id) page $($record.page_number)" }
                $currentText = [string](Get-Content -Raw -Encoding UTF8 -LiteralPath $resolvedTextPath)
                if ([string]$record.text -ne $currentText) { $issues += "Search index has stale text content for $($record.source_id) page $($record.page_number)" }
            }
        }
    }
    if ($searchManifest) {
        if ([int]$searchManifest.schema_version -ne 1) { $issues += 'Unsupported search index schema version' }
        if ([int]$searchManifest.page_record_count -ne $indexRecords.Count) { $issues += 'Search index record count differs from its manifest' }
        $currentRegistryHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $registryPath).Hash.ToLowerInvariant()
        if ([string]$searchManifest.registry_sha256 -ne $currentRegistryHash) { $issues += 'Search index is stale because the source registry changed' }
        $indexedSourceCount = @($indexRecords | Select-Object -ExpandProperty source_id -Unique).Count
        if ([int]$searchManifest.source_count -ne $indexedSourceCount) { $issues += 'Search index source count differs from its manifest' }
    }
    foreach ($row in $activeLocalPdfs) {
        $sourceRecords = @($indexRecords | Where-Object source_id -eq $row.id)
        if ($sourceRecords.Count -lt 1) { $issues += "$($row.id) active PDF has no page records in the global search index" }
        $sourceManifestFile = $manifests | Where-Object {
            try { (Get-Content -Raw -LiteralPath $_.FullName | ConvertFrom-Json).source_id -eq $row.id }
            catch { $false }
        } | Select-Object -First 1
        if ($sourceManifestFile) {
            $expectedPages = [int](Get-Content -Raw -LiteralPath $sourceManifestFile.FullName | ConvertFrom-Json).page_count
            if ($sourceRecords.Count -ne $expectedPages) { $issues += "$($row.id) search index page count differs from its extraction manifest" }
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
