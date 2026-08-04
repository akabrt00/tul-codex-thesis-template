[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$FullName,

    [string]$PreferredName,

    [Parameter(Mandatory)]
    [ValidateSet('FS', 'FT', 'FP', 'EF', 'FA', 'FM', 'FZS', 'CXI')]
    [string]$Faculty,

    [Parameter(Mandatory)]
    [ValidateSet('BP', 'DP', 'Dis', 'Teze', 'Autoref', 'Hab', 'SP', 'Proj')]
    [string]$WorkType,

    [ValidateSet('CZ', 'EN')]
    [string]$Language = 'CZ',

    [ValidateRange(2000, 2100)]
    [int]$Year = (Get-Date).Year,

    [Parameter(Mandatory)]
    [ValidateSet('male', 'female')]
    [string]$FrontMatterVariant,

    [string]$ProgrammeCode = '',
    [string]$ProgrammeNameCs = '',
    [string]$ProgrammeNameEn = '',
    [string]$BranchCode = '',
    [string]$BranchNameCs = '',
    [string]$BranchNameEn = '',
    [string]$TitleCs = '',
    [string]$TitleEn = '',
    [string]$Supervisor = '',
    [string]$Consultant = '',
    [string]$StagIntroPdf = '',
    [switch]$Force,
    [string]$DestinationRoot
)

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
if (-not $DestinationRoot) { $DestinationRoot = $repoRoot }
if (-not (Test-Path -LiteralPath $DestinationRoot)) {
    New-Item -ItemType Directory -Path $DestinationRoot -Force | Out-Null
}
$destinationRootPath = (Resolve-Path -LiteralPath $DestinationRoot).Path
$upstreamRoot = (Resolve-Path (Join-Path $repoRoot 'templates\upstream')).Path
if ($destinationRootPath.StartsWith($upstreamRoot, [StringComparison]::OrdinalIgnoreCase)) {
    throw 'DestinationRoot must not be inside templates/upstream.'
}
$profilePath = Join-Path $destinationRootPath 'PROJECT_PROFILE.json'

if ((Test-Path -LiteralPath $profilePath) -and -not $Force) {
    throw 'PROJECT_PROFILE.json already exists. Review it first or pass -Force to replace it explicitly.'
}

if ([string]::IsNullOrWhiteSpace($PreferredName)) {
    $PreferredName = $FullName
}

$profile = [ordered]@{
    schema_version = 2
    setup_state = 'profile_created'
    author = [ordered]@{
        full_name = $FullName
        preferred_name = $PreferredName
    }
    study = [ordered]@{
        faculty_code = $Faculty
        programme_code = $ProgrammeCode
        programme_name_cs = $ProgrammeNameCs
        programme_name_en = $ProgrammeNameEn
        branch_code = $BranchCode
        branch_name_cs = $BranchNameCs
        branch_name_en = $BranchNameEn
    }
    document_defaults = [ordered]@{
        work_type = $WorkType
        language = $Language
        year = $Year
        title_cs = $TitleCs
        title_en = $TitleEn
        supervisor = $Supervisor
        consultant = $Consultant
        front_matter_variant = $FrontMatterVariant
        stag_intro_pdf = $StagIntroPdf
    }
    privacy = [ordered]@{
        git_ignored = $true
    }
}

$profile | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $profilePath -Encoding UTF8

$parsed = Get-Content -Raw -Encoding UTF8 -LiteralPath $profilePath | ConvertFrom-Json
if ($parsed.schema_version -ne 2 -or $parsed.study.faculty_code -ne $Faculty -or $parsed.document_defaults.front_matter_variant -ne $FrontMatterVariant) {
    throw 'Profile verification failed.'
}

Write-Output "Created local Git-ignored profile: $profilePath"
