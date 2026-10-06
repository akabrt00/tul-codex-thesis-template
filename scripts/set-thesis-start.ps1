[CmdletBinding(DefaultParameterSetName = 'Generated')]
param(
    [Parameter(Mandatory)]
    [string]$ProjectDir,

    [Parameter(Mandatory, ParameterSetName = 'Generated')]
    [ValidateSet('male', 'female')]
    [string]$Variant,

    [Parameter(Mandatory, ParameterSetName = 'Stag')]
    [ValidateNotNullOrEmpty()]
    [string]$StagPdf
)

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$allowedRoot = (Resolve-Path (Join-Path $repoRoot 'prace')).Path
$projectPath = (Resolve-Path -LiteralPath $ProjectDir).Path

if (-not ($projectPath -eq $allowedRoot -or $projectPath.StartsWith($allowedRoot + [IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase))) {
    throw 'ProjectDir must resolve inside the project prace/ directory.'
}
$mainPath = Join-Path $projectPath 'main.tex'
if (-not (Test-Path -LiteralPath $mainPath -PathType Leaf)) {
    throw 'ProjectDir must contain main.tex.'
}

$maleLine = '% \ThesisStart{male}'
$femaleLine = '% \ThesisStart{female}'
$stagLine = '% \ThesisStart{front-matter/stag-intro.pdf}'
$contextPath = Join-Path $repoRoot 'PROJECT_CONTEXT.md'
$profilePath = Join-Path $repoRoot 'PROJECT_PROFILE.json'
$contextText = $null

if ($PSCmdlet.ParameterSetName -eq 'Generated') {
    if ($Variant -eq 'male') { $maleLine = '\ThesisStart{male}' }
    if ($Variant -eq 'female') { $femaleLine = '\ThesisStart{female}' }
} else {
    if (-not [string]::Equals($projectPath, $allowedRoot, [StringComparison]::OrdinalIgnoreCase)) {
        throw 'Official IS STAG introductory pages can be activated only for the primary document in prace/.'
    }
    $contextText = Get-Content -LiteralPath $contextPath -Raw -Encoding UTF8
    if ($contextText -notmatch '(?m)^- IS STAG introductory-pages PDF:.*$') {
        throw 'PROJECT_CONTEXT.md does not contain the IS STAG introductory-pages PDF field.'
    }
    $sourcePdf = (Resolve-Path -LiteralPath $StagPdf).Path
    if ([IO.Path]::GetExtension($sourcePdf) -ne '.pdf') {
        throw 'StagPdf must point to a PDF file.'
    }
    $frontMatterDir = Join-Path $projectPath 'front-matter'
    if (-not (Test-Path -LiteralPath $frontMatterDir)) {
        New-Item -ItemType Directory -Path $frontMatterDir | Out-Null
    }
    $targetPdf = Join-Path $frontMatterDir 'stag-intro.pdf'
    if (-not [string]::Equals($sourcePdf, $targetPdf, [StringComparison]::OrdinalIgnoreCase)) {
        Copy-Item -LiteralPath $sourcePdf -Destination $targetPdf -Force
    }
    $stagLine = '\ThesisStart{front-matter/stag-intro.pdf}'
}

$block = @(
    '% TUL-FRONT-MATTER-BEGIN'
    '% Exactly one ThesisStart command must remain active.'
    $maleLine
    $femaleLine
    $stagLine
    '% TUL-FRONT-MATTER-END'
)
$lines = @(Get-Content -LiteralPath $mainPath -Encoding UTF8)
$beginIndex = [Array]::IndexOf($lines, '% TUL-FRONT-MATTER-BEGIN')
$endIndex = [Array]::IndexOf($lines, '% TUL-FRONT-MATTER-END')

if ($beginIndex -ge 0 -or $endIndex -ge 0) {
    if ($beginIndex -lt 0 -or $endIndex -le $beginIndex) {
        throw 'The front-matter marker block in main.tex is incomplete.'
    }
    $before = if ($beginIndex -gt 0) { @($lines[0..($beginIndex - 1)]) } else { @() }
    $after = if ($endIndex -lt $lines.Count - 1) { @($lines[($endIndex + 1)..($lines.Count - 1)]) } else { @() }
    $lines = @($before + $block + $after)
} else {
    $thesisStartIndexes = @(
        for ($i = 0; $i -lt $lines.Count; $i++) {
            if ($lines[$i] -match '^\s*%?\s*\\ThesisStart\{') { $i }
        }
    )
    if ($thesisStartIndexes.Count -lt 1) {
        throw 'No ThesisStart location was found in main.tex.'
    }
    $insertAt = $thesisStartIndexes[0]
    $remove = @{}; $thesisStartIndexes | ForEach-Object { $remove[$_] = $true }
    $rebuilt = @()
    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($i -eq $insertAt) { $rebuilt += $block }
        if (-not $remove.ContainsKey($i)) { $rebuilt += $lines[$i] }
    }
    $lines = $rebuilt
}

$result = $lines -join "`r`n"
$activeCommands = @([regex]::Matches($result, '(?m)^\s*\\ThesisStart\{.*\}\s*$'))
if ($activeCommands.Count -ne 1) {
    throw "Exactly one active ThesisStart command is required; found $($activeCommands.Count)."
}
Set-Content -LiteralPath $mainPath -Value $result -Encoding UTF8

if ($PSCmdlet.ParameterSetName -eq 'Stag') {
    $contextText = [regex]::Replace(
        $contextText,
        '(?m)^- IS STAG introductory-pages PDF:.*$',
        '- IS STAG introductory-pages PDF: `prace/front-matter/stag-intro.pdf`'
    )
    Set-Content -LiteralPath $contextPath -Value $contextText -Encoding UTF8

    if (Test-Path -LiteralPath $profilePath -PathType Leaf) {
        $profile = Get-Content -LiteralPath $profilePath -Raw -Encoding UTF8 | ConvertFrom-Json
        $profile.document_defaults.stag_intro_pdf = 'front-matter/stag-intro.pdf'
        $profile | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $profilePath -Encoding UTF8
    }
}

[pscustomobject]@{
    Project = $projectPath
    MainTex = $mainPath
    Mode = if ($PSCmdlet.ParameterSetName -eq 'Stag') { 'stag-pdf' } else { $Variant }
    ActiveCommand = $activeCommands[0].Value.Trim()
}
