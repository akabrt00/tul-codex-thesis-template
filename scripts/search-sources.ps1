[CmdletBinding()]
param(
    [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$Query,
    [string[]]$SourceId,
    [ValidateSet('All', 'Any', 'Phrase')][string]$Mode = 'All',
    [ValidateRange(1, 200)][int]$MaxResults = 20,
    [string]$IndexPath,
    [switch]$AsJson
)

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$sourceRoot = (Resolve-Path (Join-Path $repoRoot 'zdroje')).Path
if (-not $IndexPath) { $IndexPath = Join-Path $sourceRoot '90_zpracovane\index\search-index.jsonl' }
if (-not (Test-Path -LiteralPath $IndexPath)) {
    throw 'The page-level source index does not exist. Process registered PDFs and run scripts/build-source-search-index.ps1 first.'
}
$resolvedIndex = (Resolve-Path -LiteralPath $IndexPath -ErrorAction Stop).Path
if (-not $resolvedIndex.StartsWith($sourceRoot + [IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase)) {
    throw 'Source search accepts indexes only from zdroje/.'
}

$terms = @($Query -split '\s+' | Where-Object { $_ })
$results = [System.Collections.Generic.List[object]]::new()
foreach ($line in Get-Content -Encoding UTF8 -LiteralPath $resolvedIndex) {
    if ([string]::IsNullOrWhiteSpace($line)) { continue }
    $record = $line | ConvertFrom-Json
    if ($SourceId -and $record.source_id -notin $SourceId) { continue }
    $haystack = "$($record.title) $($record.text)"

    if ($Mode -eq 'Phrase') {
        $matchedTerms = @($Query)
        $isMatch = $haystack.IndexOf($Query, [StringComparison]::InvariantCultureIgnoreCase) -ge 0
    } else {
        $matchedTerms = @($terms | Where-Object { $haystack.IndexOf($_, [StringComparison]::InvariantCultureIgnoreCase) -ge 0 })
        $isMatch = if ($Mode -eq 'All') { $matchedTerms.Count -eq $terms.Count } else { $matchedTerms.Count -gt 0 }
    }
    if (-not $isMatch) { continue }

    $score = 0
    foreach ($term in $matchedTerms) {
        $score += [regex]::Matches($haystack, [regex]::Escape($term), [Text.RegularExpressions.RegexOptions]::IgnoreCase).Count
    }
    $normalized = [regex]::Replace([string]$record.text, '\s+', ' ').Trim()
    $firstTerm = $matchedTerms | Select-Object -First 1
    $position = if ($firstTerm) { $normalized.IndexOf($firstTerm, [StringComparison]::InvariantCultureIgnoreCase) } else { 0 }
    if ($position -lt 0) { $position = 0 }
    $start = [Math]::Max(0, $position - 120)
    $length = [Math]::Min(360, $normalized.Length - $start)
    $snippet = if ($length -gt 0) { $normalized.Substring($start, $length) } else { '' }

    $results.Add([pscustomobject]@{
        source_id = $record.source_id
        citation_key = $record.citation_key
        page = [int]$record.page_number
        score = $score
        text_path = $record.text_path
        snippet = $snippet
    })
}

$selected = @($results | Sort-Object @{Expression='score';Descending=$true}, source_id, page | Select-Object -First $MaxResults)
if ($AsJson) {
    ConvertTo-Json -Depth 4 -InputObject @($selected)
} elseif ($selected.Count -gt 0) {
    $selected | Format-Table source_id, page, score, citation_key, snippet -Wrap
} else {
    Write-Output "No local evidence matched '$Query' in the selected source index."
}
