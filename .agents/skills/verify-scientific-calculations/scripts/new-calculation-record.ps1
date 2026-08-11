[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$DocumentDir,
    [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$Title
)

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..\..')).Path
$allowedRoot = (Resolve-Path (Join-Path $repoRoot 'prace')).Path
$documentPath = (Resolve-Path -LiteralPath $DocumentDir).Path
if (-not ($documentPath -eq $allowedRoot -or $documentPath.StartsWith($allowedRoot + [IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase))) {
    throw 'DocumentDir must resolve inside the project prace/ directory.'
}
if (-not (Test-Path -LiteralPath (Join-Path $documentPath 'main.tex') -PathType Leaf)) {
    throw 'DocumentDir must contain an initialized main.tex.'
}

$calculationsDir = Join-Path $documentPath 'calculations'
New-Item -ItemType Directory -Path $calculationsDir -Force | Out-Null
$existingNumbers = Get-ChildItem -LiteralPath $calculationsDir -Directory -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -match '^CALC-(\d{4})$' } |
    ForEach-Object { [int]$Matches[1] }
$nextNumber = if ($existingNumbers) { [int](($existingNumbers | Measure-Object -Maximum).Maximum) + 1 } else { 1 }
if ($nextNumber -gt 9999) { throw 'Calculation identifier space is exhausted.' }
$calculationId = 'CALC-{0:D4}' -f $nextNumber
$calculationDir = Join-Path $calculationsDir $calculationId
New-Item -ItemType Directory -Path $calculationDir | Out-Null
foreach ($child in @('data', 'scripts', 'figures')) {
    New-Item -ItemType Directory -Path (Join-Path $calculationDir $child) | Out-Null
}

$recordPath = Join-Path $calculationDir 'record.md'
@(
    "# $calculationId - $Title"
    ''
    '## Purpose'
    ''
    'Unknown.'
    ''
    '## Inputs, symbols, and units'
    ''
    'Unknown.'
    ''
    '## Assumptions and domain'
    ''
    'Unknown.'
    ''
    '## Primary method'
    ''
    'Not run.'
    ''
    '## Independent verification'
    ''
    'Not run.'
    ''
    '## Result, precision, and uncertainty'
    ''
    'Not established.'
    ''
    '## Differences, limitations, and open questions'
    ''
    'Unknown.'
    ''
    '## Human review'
    ''
    'Awaiting a linked REV-NNNN record before use in a formal document.'
) | Set-Content -LiteralPath $recordPath -Encoding UTF8

$createdAt = (Get-Date).ToString('o')
$metadata = [ordered]@{
    schema_version = 1
    calculation_id = $calculationId
    title = $Title
    status = 'incomplete'
    created_at = $createdAt
    updated_at = $createdAt
    record_file = "calculations/$calculationId/record.md"
    input_files = @()
    code_files = @()
    output_files = @()
    primary_method = ''
    independent_method = ''
    external_tools = @()
    assumptions = @()
    units = @()
    review_ids = @()
    open_questions = @()
}
$metadataPath = Join-Path $calculationDir 'metadata.json'
$metadata | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $metadataPath -Encoding UTF8

$indexPath = Join-Path $calculationsDir 'CALCULATION_INDEX.md'
if (-not (Test-Path -LiteralPath $indexPath)) {
    @(
        '# Calculation index'
        ''
        '| ID | Title | Status | Human review | Record |'
        '|---|---|---|---|---|'
    ) | Set-Content -LiteralPath $indexPath -Encoding UTF8
}
$safeTitle = $Title.Replace('|', '\|').Replace("`r", ' ').Replace("`n", ' ')
Add-Content -LiteralPath $indexPath -Encoding UTF8 -Value "| $calculationId | $safeTitle | incomplete | awaiting | [$calculationId](./$calculationId/record.md) |"

[pscustomobject]@{
    CalculationId = $calculationId
    Directory = $calculationDir
    Record = $recordPath
    Metadata = $metadataPath
    Index = $indexPath
}
