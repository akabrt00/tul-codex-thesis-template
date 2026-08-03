[CmdletBinding()]
param(
    [string[]]$SourceId,
    [string]$OutputDirectory,
    [switch]$Force
)

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$sourceRoot = (Resolve-Path (Join-Path $repoRoot 'zdroje')).Path
$registryPath = Join-Path $sourceRoot 'REJSTRIK_ZDROJU.md'
$extractionRoot = Join-Path $sourceRoot '90_zpracovane\extrahovany-text'
$allowedOutputRoot = Join-Path $sourceRoot '90_zpracovane\index'

if (-not $OutputDirectory) { $OutputDirectory = $allowedOutputRoot }
if (-not (Test-Path -LiteralPath $OutputDirectory)) {
    New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null
}
$outputPath = (Resolve-Path -LiteralPath $OutputDirectory).Path
$allowedOutputPath = if (Test-Path -LiteralPath $allowedOutputRoot) {
    (Resolve-Path -LiteralPath $allowedOutputRoot).Path
} else {
    $allowedOutputRoot
}
if ($outputPath -ne $allowedOutputPath -and -not $outputPath.StartsWith($allowedOutputPath + [IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase)) {
    throw 'Search index output must stay under zdroje/90_zpracovane/index/.'
}

$indexPath = Join-Path $outputPath 'search-index.jsonl'
$indexManifestPath = Join-Path $outputPath 'search-index-manifest.json'
if (((Test-Path -LiteralPath $indexPath) -or (Test-Path -LiteralPath $indexManifestPath)) -and -not $Force) {
    throw 'Search index already exists. Use -Force to rebuild it from registered extractions.'
}

$rows = @()
foreach ($line in Get-Content -Encoding UTF8 -LiteralPath $registryPath) {
    if ($line -match '^\|\s*`(SRC-\d{4})`\s*\|') {
        $cells = @($line.Trim().Trim('|').Split('|') | ForEach-Object { $_.Trim().Trim('`') })
        if ($cells.Count -lt 12) { throw "Malformed registry row: $line" }
        $rows += [pscustomobject]@{
            id = $cells[0]
            citation_key = $cells[1]
            status = $cells[2]
            title = $cells[3]
            local_path = $cells[5]
        }
    }
}

if ($SourceId) {
    foreach ($requestedId in $SourceId) {
        if ($requestedId -notmatch '^SRC-\d{4}$') { throw "Invalid source ID: $requestedId" }
        if ($requestedId -notin $rows.id) { throw "Source ID is not registered: $requestedId" }
    }
    $rows = @($rows | Where-Object id -in $SourceId)
}

$manifestFiles = if (Test-Path -LiteralPath $extractionRoot) {
    @(Get-ChildItem -LiteralPath $extractionRoot -Recurse -File -Filter manifest.json)
} else { @() }
$jsonLines = [System.Collections.Generic.List[string]]::new()
$indexedSources = [System.Collections.Generic.List[object]]::new()

foreach ($row in @($rows | Where-Object { $_.status -eq 'aktivní' -and $_.local_path -ne 'pouze odkaz' })) {
    $localSource = Join-Path $sourceRoot $row.local_path
    if ([IO.Path]::GetExtension($localSource) -ne '.pdf') { continue }
    if (-not (Test-Path -LiteralPath $localSource)) { throw "$($row.id) source path does not exist: $($row.local_path)" }

    $matchingManifests = @()
    foreach ($manifestFile in $manifestFiles) {
        $candidate = Get-Content -Raw -Encoding UTF8 -LiteralPath $manifestFile.FullName | ConvertFrom-Json
        if ($candidate.source_id -eq $row.id) {
            $matchingManifests += [pscustomobject]@{ file = $manifestFile; data = $candidate }
        }
    }
    if ($matchingManifests.Count -ne 1) {
        throw "$($row.id) requires exactly one extraction manifest, found $($matchingManifests.Count)."
    }

    $selected = $matchingManifests[0]
    foreach ($page in $selected.data.pages) {
        $pagePath = (Resolve-Path -LiteralPath (Join-Path $selected.file.DirectoryName $page.text_file)).Path
        if (-not $pagePath.StartsWith($sourceRoot + [IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase)) {
            throw "$($row.id) extraction points outside zdroje/."
        }
        $text = [string](Get-Content -Raw -Encoding UTF8 -LiteralPath $pagePath)
        $record = [ordered]@{
            source_id = $row.id
            citation_key = $row.citation_key
            title = $row.title
            page_number = [int]$page.page_number
            text_path = $pagePath.Substring($sourceRoot.Length + 1).Replace('\', '/')
            text_sha256 = $page.text_sha256
            text = $text
        }
        $jsonLines.Add(($record | ConvertTo-Json -Depth 4 -Compress))
    }

    $indexedSources.Add([ordered]@{
        source_id = $row.id
        citation_key = $row.citation_key
        title = $row.title
        extraction_manifest = $selected.file.FullName.Substring($sourceRoot.Length + 1).Replace('\', '/')
        page_count = [int]$selected.data.page_count
    })
}

$utf8WithoutBom = New-Object System.Text.UTF8Encoding($false)
[IO.File]::WriteAllLines($indexPath, [string[]]$jsonLines.ToArray(), $utf8WithoutBom)
[ordered]@{
    schema_version = 1
    generated_at = (Get-Date).ToString('o')
    registry_sha256 = (Get-FileHash -Algorithm SHA256 -LiteralPath $registryPath).Hash.ToLowerInvariant()
    source_count = $indexedSources.Count
    page_record_count = $jsonLines.Count
    sources = $indexedSources
} | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $indexManifestPath -Encoding UTF8

Write-Output "Indexed $($indexedSources.Count) sources and $($jsonLines.Count) pages into $indexPath."
