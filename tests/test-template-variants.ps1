[CmdletBinding()]
param()
$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$testRoot = Join-Path ([IO.Path]::GetTempPath()) ('tul-variants-' + [guid]::NewGuid().ToString('N'))
function Assert([bool]$Condition, [string]$Message) { if (-not $Condition) { throw $Message } }
try {
    foreach ($faculty in @('FS','FT','FP','EF','FA','FM','FZS')) {
        $destination = Join-Path $testRoot $faculty
        & "$repoRoot/scripts/setup-profile.ps1" -DestinationRoot $destination -FullName 'Synthetic Student' -Faculty $faculty -WorkType SP -Language CZ -Year 2026 -TitleCs 'Synthetic semester' -Course 'Test course' -WorkDate '10. 10. 2026' -AssignmentVersion '1' -Software 'Test software'
        & "$repoRoot/scripts/init-project.ps1" -DestinationRoot $destination -Target Thesis
        $mainPath = Join-Path $destination 'prace/main.tex'
        $text = Get-Content -Raw -Encoding UTF8 -LiteralPath $mainPath
        $expectedFaculty = if ($faculty -eq 'FA') { 'FUA' } else { $faculty }
        Assert ($text.Contains("\Fakulta{$expectedFaculty}")) 'Faculty mapping failed.'
        Assert ($text.Contains('Synthetic Student') -and $text.Contains('Test course')) 'Semester profile metadata missing.'
        Assert ($text.Contains('\TitulniStrana') -and -not $text.Contains('\ThesisStart')) 'Wrong semester title-page workflow.'
        Assert ($text -notmatch 'Adam Kábrt|Creo|cite\{ukazka\}|sigma') 'Public example data must not enter the starter.'
        Assert ((Get-Content -Raw (Join-Path $destination 'prace/.upstream-origin.json') | ConvertFrom-Json).template_variant -eq 'Semester') 'Wrong recorded template variant.'
        $hashBefore = (Get-FileHash -LiteralPath $mainPath).Hash
        $rejected = $false
        try { & "$repoRoot/scripts/init-project.ps1" -DestinationRoot $destination -Target Thesis } catch { $rejected = $true }
        Assert ($rejected -and (Get-FileHash -LiteralPath $mainPath).Hash -eq $hashBefore) 'Existing work was overwritten.'
    }
    $original = Join-Path $testRoot 'original'
    & "$repoRoot/scripts/setup-profile.ps1" -DestinationRoot $original -FullName 'Synthetic Student' -Faculty FM -WorkType BP -FrontMatterVariant female
    & "$repoRoot/scripts/init-project.ps1" -DestinationRoot $original -Target Thesis -TemplateVariant Original
    Assert (Test-Path (Join-Path $original 'prace/references.bib')) 'Original layout bibliography missing.'
    Assert ((Get-Content -Raw (Join-Path $original 'prace/main.tex')).Contains('\ThesisStart{female}')) 'Original title variant lost.'
    & "$repoRoot/scripts/init-project.ps1" -DestinationRoot $original -Target Document -DocumentName protokol -TemplateVariant Semester
    Assert (Test-Path (Join-Path $original 'prace/dokumenty/protokol/main.tex')) 'Independent semester document missing.'
    foreach ($case in @(@{name='english';faculty='FM';language='EN'},@{name='cxi';faculty='CXI';language='CZ'})) {
        $destination = Join-Path $testRoot $case.name
        & "$repoRoot/scripts/setup-profile.ps1" -DestinationRoot $destination -FullName 'Synthetic Student' -Faculty $case.faculty -WorkType SP -Language $case.language -FrontMatterVariant male
        & "$repoRoot/scripts/init-project.ps1" -DestinationRoot $destination -Target Thesis
        Assert (Test-Path (Join-Path $destination 'prace/nastaveni/udaje.tex')) 'Unsupported semester language/unit must use organized TULthesis.'
        $rejected = $false
        try { & "$repoRoot/scripts/init-project.ps1" -DestinationRoot $destination -Target Document -DocumentName unsupported -TemplateVariant Semester } catch { $rejected = $true }
        Assert $rejected 'Unsupported explicit semester request must fail.'
        Assert (-not (Test-Path (Join-Path $destination 'prace/dokumenty/unsupported'))) 'Rejected selection left a partial document.'
    }
    foreach ($manifestFile in Get-ChildItem "$repoRoot/templates/manifests" -Filter '*.json') {
        $manifest = Get-Content -Raw -Encoding UTF8 -LiteralPath $manifestFile.FullName | ConvertFrom-Json
        $source = Join-Path $repoRoot $manifest.root
        Assert (@(Get-ChildItem -LiteralPath $source -Recurse -File).Count -eq $manifest.files.Count) 'Vendor file count changed.'
        foreach ($entry in $manifest.files) {
            Assert ((Get-FileHash -LiteralPath (Join-Path $source $entry.path)).Hash.ToLowerInvariant() -eq $entry.sha256) 'Vendor content changed.'
        }
    }
    Write-Output 'Template variants passed: seven faculties, original layout, supporting document, unsupported selections, no overwrite, and import hashes.'
} finally {
    if (Test-Path -LiteralPath $testRoot) {
        $resolved = (Resolve-Path -LiteralPath $testRoot).Path
        $tempPrefix = (Resolve-Path -LiteralPath ([IO.Path]::GetTempPath())).Path.TrimEnd('\') + '\'
        if (-not $resolved.StartsWith($tempPrefix, [StringComparison]::OrdinalIgnoreCase)) { throw 'Unexpected test cleanup path.' }
        Remove-Item -LiteralPath $resolved -Recurse -Force
    }
}
