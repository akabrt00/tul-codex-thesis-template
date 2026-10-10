[CmdletBinding()]
param(
    [ValidateSet('All', 'Thesis', 'Presentation', 'Document')]
    [string]$Target = 'All',
    [string]$DestinationRoot,
    [string]$DocumentName,
    [ValidateSet('Auto', 'Original', 'Organized', 'Semester')]
    [string]$TemplateVariant = 'Auto'
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
$communityRoot = [IO.Path]::GetFullPath((Join-Path $repoRoot 'templates\community'))
if ($destinationRootPath.StartsWith($communityRoot, [StringComparison]::OrdinalIgnoreCase)) { throw 'DestinationRoot must not be inside templates/community.' }
if ($Target -in @('All', 'Thesis', 'Document') -and -not (Test-Path -LiteralPath $profilePath -PathType Leaf)) {
    throw 'PROJECT_PROFILE.json is required before initializing a formal document. Run setup-profile.ps1 with confirmed metadata first.'
}
if ($Target -in @('All', 'Thesis', 'Document')) {
    $initialProfile = Get-Content -Raw -Encoding UTF8 -LiteralPath $profilePath | ConvertFrom-Json
    if ($TemplateVariant -eq 'Auto') {
        if ($initialProfile.document_defaults.template_variant -and $initialProfile.document_defaults.template_variant -ne 'Auto') {
            $TemplateVariant = [string]$initialProfile.document_defaults.template_variant
        } elseif ($initialProfile.document_defaults.work_type -eq 'SP' -and $initialProfile.document_defaults.language -eq 'CZ' -and $initialProfile.study.faculty_code -in @('FS','FT','FP','EF','FA','FM','FZS')) {
            $TemplateVariant = 'Semester'
        } else { $TemplateVariant = 'Organized' }
    }
    if ($TemplateVariant -notin @('Original', 'Organized', 'Semester')) { throw 'Unknown template variant in profile.' }
    if ($TemplateVariant -eq 'Semester' -and ($initialProfile.document_defaults.language -ne 'CZ' -or $initialProfile.study.faculty_code -notin @('FS','FT','FP','EF','FA','FM','FZS'))) {
        throw 'Semester 1.1 supports Czech and the seven faculties only. Use Original or Organized for other units/languages.'
    }
    if ($initialProfile.schema_version -lt 2 -or ($TemplateVariant -ne 'Semester' -and [string]$initialProfile.document_defaults.front_matter_variant -notin @('male', 'female'))) {
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
    if ($TemplateVariant -eq 'Organized') {
        $metadataStart = $content.IndexOf('\TULtitle')
        $documentStart = $content.IndexOf('\begin{document}')
        $metadata = $content.Substring($metadataStart, $documentStart - $metadataStart).Trim()
        $packagesStart = $content.IndexOf('\usepackage')
        $packages = $content.Substring($packagesStart, $metadataStart - $packagesStart).Trim().Replace('references.bib', 'literatura/zdroje.bib')
        Set-Content -LiteralPath (Join-Path $Destination 'nastaveni\udaje.tex') -Value $metadata -Encoding UTF8
        Set-Content -LiteralPath (Join-Path $Destination 'nastaveni\balicky.tex') -Value $packages -Encoding UTF8
        $content = $content.Substring(0, $packagesStart) + "\input{nastaveni/balicky}`n\input{nastaveni/udaje}`n`n" + $content.Substring($documentStart)
        Copy-Item -LiteralPath $referencesPath -Destination (Join-Path $Destination 'literatura\zdroje.bib') -Force
    } else {
        Copy-Item -LiteralPath $referencesPath -Destination (Join-Path $Destination 'references.bib') -Force
    }
    Set-Content -LiteralPath (Join-Path $Destination 'main.tex') -Value $content -Encoding UTF8
}

function Write-SemesterStarter {
    param([string]$Destination, [string]$ProfileRoot)
    $profile = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $ProfileRoot 'PROJECT_PROFILE.json') | ConvertFrom-Json
    $faculty = [string]$profile.study.faculty_code
    if ($faculty -eq 'FA') { $faculty = 'FUA' }
    $values = @{
        FACULTY = $faculty; AUTHOR = ConvertTo-LaTeXText $profile.author.full_name
        TITLE_CS = ConvertTo-LaTeXText $profile.document_defaults.title_cs
        YEAR = [string]$profile.document_defaults.year
        COURSE = ConvertTo-LaTeXText $profile.document_defaults.course
        WORK_DATE = ConvertTo-LaTeXText $profile.document_defaults.work_date
        ASSIGNMENT_VERSION = ConvertTo-LaTeXText $profile.document_defaults.assignment_version
        SOFTWARE = ConvertTo-LaTeXText $profile.document_defaults.software
    }
    foreach ($key in @('TITLE_CS','COURSE','WORK_DATE','ASSIGNMENT_VERSION','SOFTWARE')) {
        if ([string]::IsNullOrWhiteSpace($values[$key])) { $values[$key] = 'Doplnit' }
    }
    $content = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $repoRoot 'templates\starters\tul-semestralni-main.tex')
    foreach ($entry in $values.GetEnumerator()) { $content = $content.Replace(('{{' + $entry.Key + '}}'), [string]$entry.Value) }
    Set-Content -LiteralPath (Join-Path $Destination 'main.tex') -Value $content -Encoding UTF8
    # No fabricated source/example measurement is promoted into the student's document.
    Copy-Item -LiteralPath (Join-Path $repoRoot 'templates\starters\references.bib') -Destination (Join-Path $Destination 'literatura.bib') -Force
}

function Initialize-FormalDocument {
    param([string]$Destination)
    switch ($TemplateVariant) {
        Original { $source = Join-Path $upstreamRoot 'TUL\TULthesis'; $mainSource = 'manual-tulthesis.tex' }
        Organized { $source = Join-Path $repoRoot 'templates\community\tulthesis-0.8-loga'; $mainSource = 'main.tex' }
        Semester { $source = Join-Path $repoRoot 'templates\community\tul-semestralni-1.1'; $mainSource = 'semestralni-prace.tex' }
    }
    if ($TemplateVariant -ne 'Original') {
        $manifest = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $repoRoot ('templates\manifests\' + (Split-Path -Leaf $source) + '.json')) | ConvertFrom-Json
        if (@(Get-ChildItem -LiteralPath $source -Recurse -File -Force).Count -ne $manifest.files.Count) { throw 'Community snapshot file count differs from its manifest.' }
        foreach ($entry in $manifest.files) {
            $vendorFile = Join-Path $source $entry.path
            if (-not (Test-Path -LiteralPath $vendorFile -PathType Leaf) -or (Get-FileHash -Algorithm SHA256 -LiteralPath $vendorFile).Hash.ToLowerInvariant() -ne $entry.sha256) {
                throw "Community snapshot integrity check failed: $($entry.path)"
            }
        }
    }
    Copy-WorkingTree -Source $source -Destination $Destination -MainSource $mainSource
    if ($TemplateVariant -eq 'Semester') { Write-SemesterStarter -Destination $Destination -ProfileRoot $destinationRootPath }
    else { Write-ThesisStarter -Destination $Destination -ProfileRoot $destinationRootPath }
    Write-Output "Template variant: $TemplateVariant."
}

function Write-PresentationStarter {
    param([string]$Destination, [string]$ProfileRoot)
    $values = [ordered]@{
        CLASS_OPTIONS = 'TUL'; DEFAULT_LANGUAGE = 'czech'
        TITLE = 'Doplnit název prezentace'; AUTHOR = 'Doplnit autora'
        INSTITUTE = 'Doplnit pracoviště'; YEAR = (Get-Date).Year.ToString()
    }
    $presentationProfile = Join-Path $ProfileRoot 'PROJECT_PROFILE.json'
    if (Test-Path -LiteralPath $presentationProfile -PathType Leaf) {
        $profile = Get-Content -Raw -Encoding UTF8 -LiteralPath $presentationProfile | ConvertFrom-Json
        if ($profile.study.faculty_code) { $values.CLASS_OPTIONS = [string]$profile.study.faculty_code }
        if ($profile.document_defaults.language -eq 'EN') {
            $values.CLASS_OPTIONS += ',EN'; $values.DEFAULT_LANGUAGE = 'english'
            if ($profile.document_defaults.title_en) { $values.TITLE = ConvertTo-LaTeXText $profile.document_defaults.title_en }
        } elseif ($profile.document_defaults.title_cs) { $values.TITLE = ConvertTo-LaTeXText $profile.document_defaults.title_cs }
        if ($profile.author.full_name) { $values.AUTHOR = ConvertTo-LaTeXText $profile.author.full_name }
        if ($profile.study.faculty_code) { $values.INSTITUTE = ConvertTo-LaTeXText ($profile.study.faculty_code + ' TUL') }
        if ($profile.document_defaults.year) { $values.YEAR = [string]$profile.document_defaults.year }
    }
    $content = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $repoRoot 'templates\starters\tulpresentation-main.tex')
    foreach ($entry in $values.GetEnumerator()) { $content = $content.Replace(('{{' + $entry.Key + '}}'), [string]$entry.Value) }
    Set-Content -LiteralPath (Join-Path $Destination 'main.tex') -Value $content -Encoding UTF8
    $fontDestination = Join-Path $Destination 'fonts'
    New-Item -ItemType Directory -Path $fontDestination -Force | Out-Null
    Get-ChildItem -LiteralPath (Join-Path $repoRoot 'templates\starters\presentation-fonts') -File | ForEach-Object {
        Copy-Item -LiteralPath $_.FullName -Destination $fontDestination
    }
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
        template_variant = if ($Destination -eq (Join-Path $destinationRootPath 'obhajoba')) { 'Presentation' } else { $TemplateVariant }
    } | ConvertTo-Json | Set-Content -LiteralPath (Join-Path $Destination '.upstream-origin.json') -Encoding UTF8

    $after = Get-TreeSnapshot -Path $Source
    Assert-TreeUnchanged -Before $before -After $after -Label $Source
    Write-Output "Initialized $Destination from immutable upstream $($before.tree_sha256)."
}

if ($Target -in @('All', 'Thesis')) {
    $thesisPath = Join-Path $destinationRootPath 'prace'
    Initialize-FormalDocument -Destination $thesisPath
}
if ($Target -in @('All', 'Presentation')) {
    $presentationPath = Join-Path $destinationRootPath 'obhajoba'
    Copy-WorkingTree -Source (Join-Path $upstreamRoot 'TUL\TULpresentation') -Destination $presentationPath -MainSource 'manual-tulpresentaion.tex'
    Write-PresentationStarter -Destination $presentationPath -ProfileRoot $destinationRootPath
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
    Initialize-FormalDocument -Destination $documentPath
}
