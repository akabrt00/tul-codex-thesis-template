[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string]$DocumentDir,
    [Parameter(Mandatory = $true)][string]$Title,
    [string]$Date = (Get-Date).ToString('yyyy-MM-dd')
)

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..\..')).Path
$documentPath = (Resolve-Path -LiteralPath $DocumentDir).Path
$allowedRoot = Join-Path $repoRoot 'prace'

if (-not ($documentPath -eq $allowedRoot -or $documentPath.StartsWith($allowedRoot + [IO.Path]::DirectorySeparatorChar))) {
    throw "DocumentDir must resolve inside the project's prace/ directory."
}
if (-not (Test-Path -LiteralPath (Join-Path $documentPath 'main.tex') -PathType Leaf)) {
    throw "DocumentDir must contain an initialized main.tex."
}
if ($Date -notmatch '^\d{4}-\d{2}-\d{2}$') {
    throw 'Date must use YYYY-MM-DD.'
}

function Escape-Latex([string]$Value) {
    $escaped = $Value.Replace('\', '\textbackslash{}')
    foreach ($pair in @(@('&', '\&'), @('%', '\%'), @('$', '\$'), @('#', '\#'), @('_', '\_'), @('{', '\{'), @('}', '\}'))) {
        $escaped = $escaped.Replace($pair[0], $pair[1])
    }
    return $escaped
}

$experimentsDir = Join-Path $documentPath 'experiments'
New-Item -ItemType Directory -Force -Path $experimentsDir | Out-Null
$existingIds = Get-ChildItem -LiteralPath $experimentsDir -Directory -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -match '^EXP-(\d{4})$' } |
    ForEach-Object { [int]$Matches[1] }
$nextNumber = if ($existingIds) { [int](($existingIds | Measure-Object -Maximum).Maximum) + 1 } else { 1 }
if ($nextNumber -gt 9999) { throw 'EXP identifier space is exhausted.' }
$experimentId = 'EXP-{0:D4}' -f $nextNumber
$experimentDir = Join-Path $experimentsDir $experimentId
if (Test-Path -LiteralPath $experimentDir) { throw "Experiment directory already exists: $experimentDir" }

New-Item -ItemType Directory -Path $experimentDir | Out-Null
foreach ($child in @('data', 'figures', 'notes')) {
    New-Item -ItemType Directory -Path (Join-Path $experimentDir $child) | Out-Null
}

$safeTitle = Escape-Latex $Title
$record = @"
% $experimentId — complete experimental record. Do not remove failures or deviations.
\section{$experimentId -- $safeTitle}
\label{exp:$($experimentId.ToLowerInvariant())}

\subsection*{Datum}
$Date

\subsection*{Cíl}
\textit{Nezadáno.}

\subsection*{Vzorek a příprava}
\textit{Nezadáno.}

\subsection*{Zařízení, snímače a nastavení}
\textit{Nezadáno.}

\subsection*{Postup}
\textit{Nezadáno.}

\subsection*{Data a soubory}
\textit{Nezadáno.}

\subsection*{Pozorování}
\textit{Nezadáno.}

\subsection*{Odchylky, chyby a neúspěšné pokusy}
\textit{Nezadáno.}

\subsection*{Průběžné vyhodnocení a otevřené otázky}
\textit{Nezadáno; nejde o finální závěr hlavní práce.}
"@
$recordPath = Join-Path $experimentDir 'record.tex'
Set-Content -LiteralPath $recordPath -Value $record -Encoding UTF8

$metadata = [ordered]@{
    experiment_id = $experimentId
    title = $Title
    date = $Date
    status = 'incomplete'
    candidate_for_main = $false
    record_file = "experiments/$experimentId/record.tex"
    data_files = @()
    figure_files = @()
    note_files = @()
    external_source_ids = @()
    promotions = @()
    open_questions = @()
}
$metadata | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath (Join-Path $experimentDir 'metadata.json') -Encoding UTF8

$texIndexPath = Join-Path $experimentsDir 'index.tex'
if (-not (Test-Path -LiteralPath $texIndexPath)) {
    Set-Content -LiteralPath $texIndexPath -Value "% Generated experiment include list. Keep chronological order.`r`n" -Encoding UTF8
}
Add-Content -LiteralPath $texIndexPath -Value "\input{experiments/$experimentId/record.tex}" -Encoding UTF8

$markdownIndexPath = Join-Path $experimentsDir 'EXPERIMENT_INDEX.md'
if (-not (Test-Path -LiteralPath $markdownIndexPath)) {
    $header = "# Experiment index`r`n`r`n| ID | Date | Title | Status | Candidate for main | Record |`r`n|---|---|---|---|---|---|"
    Set-Content -LiteralPath $markdownIndexPath -Value $header -Encoding UTF8
}
$indexTitle = $Title.Replace('|', '\|')
Add-Content -LiteralPath $markdownIndexPath -Value "| $experimentId | $Date | $indexTitle | incomplete | no | [$experimentId](./$experimentId/record.tex) |" -Encoding UTF8

[pscustomobject]@{
    ExperimentId = $experimentId
    Directory = $experimentDir
    Record = $recordPath
    Metadata = (Join-Path $experimentDir 'metadata.json')
    LatexIndex = $texIndexPath
    Registry = $markdownIndexPath
}
