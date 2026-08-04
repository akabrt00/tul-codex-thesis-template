[CmdletBinding()]
param(
    [ValidateSet('All', 'Thesis', 'Presentation', 'Document')]
    [string]$Target = 'All',
    [string]$DestinationRoot,
    [string]$DocumentName
)

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
if (-not $DestinationRoot) { $DestinationRoot = $repoRoot }

if (-not (Test-Path -LiteralPath $DestinationRoot)) {
    New-Item -ItemType Directory -Path $DestinationRoot -Force | Out-Null
}
$destinationRootPath = (Resolve-Path -LiteralPath $DestinationRoot).Path
$upstreamRoot = (Resolve-Path (Join-Path $repoRoot 'templates\upstream')).Path
$profilePath = Join-Path $destinationRootPath 'PROJECT_PROFILE.json'

if ($destinationRootPath.StartsWith($upstreamRoot, [StringComparison]::OrdinalIgnoreCase)) {
    throw 'DestinationRoot must not be inside templates/upstream.'
}
if ($Target -in @('All', 'Thesis', 'Document') -and -not (Test-Path -LiteralPath $profilePath -PathType Leaf)) {
    throw 'PROJECT_PROFILE.json is required before initializing a formal document. Run setup-profile.ps1 and confirm the male or female generated title-page variant first.'
}
if ($Target -in @('All', 'Thesis', 'Document')) {
    $initialProfile = Get-Content -Raw -Encoding UTF8 -LiteralPath $profilePath | ConvertFrom-Json
    if ($initialProfile.schema_version -lt 2 -or [string]$initialProfile.document_defaults.front_matter_variant -notin @('male', 'female')) {
        throw 'PROJECT_PROFILE.json must use schema version 2 and contain document_defaults.front_matter_variant set to male or female. Update the local profile before initialization.'
    }
}

function Get-TreeSnapshot {
    param([Parameter(Mandatory)][string]$Path)

    $resolved = (Resolve-Path -LiteralPath $Path).Path
    $entries = @(
        Get-ChildItem -LiteralPath $resolved -Recurse -Force -File |
            Sort-Object FullName |
            ForEach-Object {
                $relative = $_.FullName.Substring($resolved.Length + 1).Replace('\', '/')
                $hash = (Get-FileHash -Algorithm SHA256 -LiteralPath $_.FullName).Hash.ToLowerInvariant()
                [pscustomobject]@{ path = $relative; sha256 = $hash }
            }
    )
    $text = ($entries | ForEach-Object { "$($_.path)`t$($_.sha256)" }) -join "`n"
    $sha = [Security.Cryptography.SHA256]::Create()
    $treeHash = ([BitConverter]::ToString($sha.ComputeHash([Text.Encoding]::UTF8.GetBytes($text)))).Replace('-', '').ToLowerInvariant()
    [pscustomobject]@{ entries = $entries; tree_sha256 = $treeHash }
}

function Assert-TreeUnchanged {
    param($Before, $After, [string]$Label)
    if ($Before.tree_sha256 -ne $After.tree_sha256 -or $Before.entries.Count -ne $After.entries.Count) {
        throw "$Label changed while creating a working copy."
    }
}

function ConvertTo-LaTeXText {
    param([AllowEmptyString()][string]$Value)

    if ($null -eq $Value) { return '' }
    $result = $Value.Replace('\', '@@TUL_BACKSLASH@@')
    $result = $result.Replace('&', '\&').Replace('%', '\%').Replace('$', '\$')
    $result = $result.Replace('#', '\#').Replace('_', '\_')
    $result = $result.Replace('{', '\{').Replace('}', '\}')
    $result = $result.Replace('~', '\textasciitilde{}').Replace('^', '\textasciicircum{}')
    $result.Replace('@@TUL_BACKSLASH@@', '\textbackslash{}')
}

function Write-ThesisStarter {
    param(
        [Parameter(Mandatory)][string]$Destination,
        [Parameter(Mandatory)][string]$ProfileRoot
    )

    $starterPath = Join-Path $repoRoot 'templates\starters\tulthesis-main.tex'
    $referencesPath = Join-Path $repoRoot 'templates\starters\references.bib'
    $profilePath = Join-Path $ProfileRoot 'PROJECT_PROFILE.json'

    $values = [ordered]@{
        CLASS_OPTIONS = 'TUL,BP'
        DEFAULT_LANGUAGE = 'czech'
        TITLE_CS = 'Doplnit český název'
        TITLE_EN = 'Add the English title'
        AUTHOR = 'Doplnit autora'
        PROGRAMME_CODE = ''
        PROGRAMME_CS = 'Doplnit studijní program'
        PROGRAMME_EN = 'Add the study programme'
        BRANCH_CODE = ''
        BRANCH_CS = 'Doplnit obor nebo specializaci'
        BRANCH_EN = 'Add the branch or specialization'
        SUPERVISOR = 'Doplnit vedoucího práce'
        CONSULTANT_COMMAND = '% \TULconsultant{Doplnit konzultanta}'
        YEAR = (Get-Date).Year.ToString()
        FRONT_MATTER = ''
    }

    $profile = Get-Content -Raw -Encoding UTF8 -LiteralPath $profilePath | ConvertFrom-Json
    $variant = [string]$profile.document_defaults.front_matter_variant
    if ($variant -notin @('male', 'female')) {
        throw 'PROJECT_PROFILE.json must contain document_defaults.front_matter_variant set to male or female. Ask the user which generated title-page variant to use.'
    }
    $options = @($profile.study.faculty_code, $profile.document_defaults.work_type)
    if ($profile.document_defaults.language -eq 'EN') {
        $options += 'EN'
        $values.DEFAULT_LANGUAGE = 'english'
    }
    $values.CLASS_OPTIONS = ($options | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }) -join ','
    $values.TITLE_CS = ConvertTo-LaTeXText $profile.document_defaults.title_cs
    $values.TITLE_EN = ConvertTo-LaTeXText $profile.document_defaults.title_en
    $values.AUTHOR = ConvertTo-LaTeXText $profile.author.full_name
    $values.PROGRAMME_CODE = ConvertTo-LaTeXText $profile.study.programme_code
    $values.PROGRAMME_CS = ConvertTo-LaTeXText $profile.study.programme_name_cs
    $values.PROGRAMME_EN = ConvertTo-LaTeXText $profile.study.programme_name_en
    $values.BRANCH_CODE = ConvertTo-LaTeXText $profile.study.branch_code
    $values.BRANCH_CS = ConvertTo-LaTeXText $profile.study.branch_name_cs
    $values.BRANCH_EN = ConvertTo-LaTeXText $profile.study.branch_name_en
    $values.SUPERVISOR = ConvertTo-LaTeXText $profile.document_defaults.supervisor
    $values.YEAR = $profile.document_defaults.year.ToString()

    if (-not [string]::IsNullOrWhiteSpace($profile.document_defaults.consultant)) {
        $consultant = ConvertTo-LaTeXText $profile.document_defaults.consultant
        $values.CONSULTANT_COMMAND = "\TULconsultant{$consultant}"
    }

    $maleLine = if ($variant -eq 'male') { '\ThesisStart{male}' } else { '% \ThesisStart{male}' }
    $femaleLine = if ($variant -eq 'female') { '\ThesisStart{female}' } else { '% \ThesisStart{female}' }
    $stagLine = '% \ThesisStart{front-matter/stag-intro.pdf}'
    $values.FRONT_MATTER = "% TUL-FRONT-MATTER-BEGIN`n% Exactly one ThesisStart command must remain active.`n$maleLine`n$femaleLine`n$stagLine`n% TUL-FRONT-MATTER-END"

    foreach ($key in @('TITLE_CS', 'TITLE_EN', 'AUTHOR', 'PROGRAMME_CODE', 'PROGRAMME_CS', 'PROGRAMME_EN', 'BRANCH_CODE', 'BRANCH_CS', 'BRANCH_EN', 'SUPERVISOR')) {
        if ([string]::IsNullOrWhiteSpace($values[$key])) {
            $values[$key] = 'Doplnit'
        }
    }

    $content = Get-Content -Raw -Encoding UTF8 -LiteralPath $starterPath
    foreach ($entry in $values.GetEnumerator()) {
        $token = '{{' + $entry.Key + '}}'
        $content = $content.Replace($token, [string]$entry.Value)
    }
    $activeFrontMatter = @([regex]::Matches($content, '(?m)^\s*\\ThesisStart\{.*\}\s*$'))
    if ($activeFrontMatter.Count -ne 1) {
        throw "Starter generation must produce exactly one active ThesisStart command; found $($activeFrontMatter.Count)."
    }
    Set-Content -LiteralPath (Join-Path $Destination 'main.tex') -Value $content -Encoding UTF8
    Copy-Item -LiteralPath $referencesPath -Destination (Join-Path $Destination 'references.bib') -Force
}

function Copy-WorkingTree {
    param(
        [Parameter(Mandatory)][string]$Source,
        [Parameter(Mandatory)][string]$Destination,
        [Parameter(Mandatory)][string]$MainSource
    )

    $before = Get-TreeSnapshot -Path $Source
    if (-not (Test-Path -LiteralPath $Destination)) {
        New-Item -ItemType Directory -Path $Destination -Force | Out-Null
    }

    $unexpected = @(
        Get-ChildItem -LiteralPath $Destination -Force |
            Where-Object { $_.Name -notin @('AGENTS.md', '.gitkeep') }
    )
    if ($unexpected.Count -gt 0) {
        throw "Working directory is not empty: $Destination"
    }

    $sourcePath = (Resolve-Path -LiteralPath $Source).Path
    Get-ChildItem -LiteralPath $sourcePath -Recurse -Force -Directory |
        Sort-Object FullName |
        ForEach-Object {
            $relative = $_.FullName.Substring($sourcePath.Length + 1)
            New-Item -ItemType Directory -Path (Join-Path $Destination $relative) -Force | Out-Null
        }
    Get-ChildItem -LiteralPath $sourcePath -Recurse -Force -File |
        ForEach-Object {
            $relative = $_.FullName.Substring($sourcePath.Length + 1)
            $targetFile = Join-Path $Destination $relative
            $targetParent = Split-Path -Parent $targetFile
            if (-not (Test-Path -LiteralPath $targetParent)) {
                New-Item -ItemType Directory -Path $targetParent -Force | Out-Null
            }
            Copy-Item -LiteralPath $_.FullName -Destination $targetFile
        }

    Copy-Item -LiteralPath (Join-Path $Source $MainSource) -Destination (Join-Path $Destination 'main.tex')
    [ordered]@{
        upstream_path = $Source.Substring($repoRoot.Length + 1).Replace('\', '/')
        upstream_tree_sha256 = $before.tree_sha256
        initialized_at = (Get-Date).ToString('o')
        main_file = 'main.tex'
    } | ConvertTo-Json | Set-Content -LiteralPath (Join-Path $Destination '.upstream-origin.json') -Encoding UTF8

    $after = Get-TreeSnapshot -Path $Source
    Assert-TreeUnchanged -Before $before -After $after -Label $Source
    Write-Output "Initialized $Destination from immutable upstream $($before.tree_sha256)."
}

if ($Target -in @('All', 'Thesis')) {
    $thesisPath = Join-Path $destinationRootPath 'prace'
    Copy-WorkingTree -Source (Join-Path $upstreamRoot 'TUL\TULthesis') -Destination $thesisPath -MainSource 'manual-tulthesis.tex'
    Write-ThesisStarter -Destination $thesisPath -ProfileRoot $destinationRootPath
}
if ($Target -in @('All', 'Presentation')) {
    Copy-WorkingTree -Source (Join-Path $upstreamRoot 'TUL\TULpresentation') -Destination (Join-Path $destinationRootPath 'obhajoba') -MainSource 'manual-tulpresentaion.tex'
}

if ($Target -eq 'Document') {
    if ([string]::IsNullOrWhiteSpace($DocumentName)) {
        throw 'DocumentName is required when Target is Document.'
    }
    if ($DocumentName -notmatch '^[a-z0-9][a-z0-9-]*$') {
        throw 'DocumentName must be a lowercase slug containing only a-z, 0-9, and hyphens.'
    }
    if ($DocumentName -eq 'main') {
        throw 'DocumentName main is reserved for the primary thesis.'
    }

    $documentPath = Join-Path $destinationRootPath (Join-Path 'prace\dokumenty' $DocumentName)
    Copy-WorkingTree -Source (Join-Path $upstreamRoot 'TUL\TULthesis') -Destination $documentPath -MainSource 'manual-tulthesis.tex'
    Write-ThesisStarter -Destination $documentPath -ProfileRoot $destinationRootPath
}
