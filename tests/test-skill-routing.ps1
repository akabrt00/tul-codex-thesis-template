[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path

function Read-RepoFile {
    param([Parameter(Mandatory)][string]$Path)
    Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $repoRoot $Path)
}

function Assert-Match {
    param(
        [Parameter(Mandatory)][string]$Text,
        [Parameter(Mandatory)][string]$Pattern,
        [Parameter(Mandatory)][string]$Scenario
    )
    if ($Text -notmatch $Pattern) { throw "Routing scenario failed: $Scenario" }
}

function Assert-NotMatch {
    param(
        [Parameter(Mandatory)][string]$Text,
        [Parameter(Mandatory)][string]$Pattern,
        [Parameter(Mandatory)][string]$Scenario
    )
    if ($Text -match $Pattern) { throw "Over-triggering regression: $Scenario" }
}

$rootRules = Read-RepoFile 'AGENTS.md'
$calculationSkill = Read-RepoFile '.agents\skills\verify-scientific-calculations\SKILL.md'
$reviewSkill = Read-RepoFile '.agents\skills\review-agent-output\SKILL.md'
$matlabFigureSkill = Read-RepoFile '.agents\skills\matlab-to-tikz\SKILL.md'
$visualSkill = Read-RepoFile '.agents\skills\create-project-visuals\SKILL.md'
$localRouter = Read-RepoFile '.agents\skills\local-tool-router\SKILL.md'
$externalRouter = Read-RepoFile '.agents\skills\external-tool-router\SKILL.md'

# Lightweight arithmetic remains deterministic but does not create a durable calculation workflow.
Assert-Match $calculationSkill 'trivial unit conversions[\s\S]+Do not create a calculation record' 'A simple unit conversion must not create CALC-NNNN.'
Assert-Match $calculationSkill 'fitted parameters' 'A material fitted parameter must activate calculation verification.'
Assert-Match $calculationSkill 'independently cross-check material scientific results' 'Material results require an independent cross-check.'

# Human review is grouped at meaningful boundaries instead of recording every draft edit.
Assert-Match $reviewSkill 'Do not create a `REV-NNNN` merely because' 'A small draft edit must not create a new REV record.'
Assert-Match $reviewSkill 'names? a version or scope as a review checkpoint' 'An explicit review checkpoint must create a REV scope.'
Assert-Match $reviewSkill 'Group closely related changes' 'Related changes must be groupable into one review scope.'

# Plot conversion depends on a graph deliverable, not the mere presence of MATLAB data.
Assert-Match $matlabFigureSkill 'reading or analysing `\.mat` data without a graph deliverable does not activate' 'Reading .mat data alone must not activate matlab-to-tikz.'
Assert-Match $matlabFigureSkill 'create, convert, restyle, repair, or insert a MATLAB or numerical graph' 'A publication-quality MATLAB graph request must activate matlab-to-tikz.'
Assert-Match $visualSkill 'routine planning or prose-review task may recommend[\s\S]+without loading this skill' 'A routine content review may recommend a visual without activating visual production.'

# Local and external capabilities retain one non-overlapping router each.
Assert-Match $localRouter 'installed executables' 'A local MATLAB executable task must route through local-tool-router.'
Assert-Match $localRouter 'MCP, plugins, connectors, and external APIs belong to external-tool-router' 'The local router must exclude remote capabilities.'
Assert-Match $externalRouter 'explicitly involves Wolfram, an external scientific API, MCP' 'A Wolfram MCP or API task must route through external-tool-router.'
Assert-Match $externalRouter 'installed local executables alone belong to local-tool-router' 'The external router must exclude installed executables alone.'

# Ordinary thesis work loads one primary workflow and only necessary support.
Assert-Match $rootRules 'one primary workflow skill and add at most two supporting skills only when the current phase requires them' 'Routine thesis work must prefer one primary skill plus only necessary support.'
Assert-Match $rootRules 'do not preload every potentially related skill' 'Routine thesis work must not preload unrelated skills.'
Assert-Match $rootRules 'Prefer the smallest sufficient context' 'Context budget guardrail must remain explicit.'
Assert-NotMatch $rootRules 'Automatically use `\$matlab-to-tikz`[^\r\n]*`\.mat`' 'The root router must not activate matlab-to-tikz for every .mat file.'
Assert-NotMatch $rootRules 'Automatically use `\$create-project-visuals` while planning' 'The root router must not activate visual production during all planning.'
Assert-NotMatch $rootRules 'Use `\$verify-scientific-calculations` for every derived' 'The root router must not create CALC records for every derived number.'

Write-Output 'Skill routing policy tests passed for 9 requested scenarios.'
