[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$testRoot = Join-Path ([IO.Path]::GetTempPath()) ("tul-template-test-" + [guid]::NewGuid().ToString('N'))
$upstreamRoot = (Resolve-Path (Join-Path $repoRoot 'templates\upstream')).Path

function Get-UpstreamHash {
    $records = Get-ChildItem -LiteralPath $upstreamRoot -Recurse -File -Force | Sort-Object FullName | ForEach-Object {
        "$($_.FullName.Substring($upstreamRoot.Length + 1).Replace('\', '/'))`t$((Get-FileHash -Algorithm SHA256 -LiteralPath $_.FullName).Hash)"
    }
    $sha = [Security.Cryptography.SHA256]::Create()
    ([BitConverter]::ToString($sha.ComputeHash([Text.Encoding]::UTF8.GetBytes(($records -join "`n"))))).Replace('-', '')
}

$beforeHash = Get-UpstreamHash
try {
    New-Item -ItemType Directory -Path $testRoot -Force | Out-Null
    & (Join-Path $repoRoot 'scripts\setup-profile.ps1') `
        -DestinationRoot $testRoot `
        -FullName 'Test Student' `
        -PreferredName 'Test' `
        -Faculty FM `
        -WorkType BP `
        -Language CZ `
        -Year 2026 `
        -FrontMatterVariant male `
        -TitleCs 'Testovaci prace' `
        -TitleEn 'Test thesis' `
        -Supervisor 'Test Supervisor'

    & (Join-Path $repoRoot 'scripts\init-project.ps1') -DestinationRoot $testRoot -Target Thesis
    & (Join-Path $repoRoot 'scripts\init-project.ps1') -DestinationRoot $testRoot -Target Presentation

    $thesisMain = Join-Path $testRoot 'prace\main.tex'
    $presentationMain = Join-Path $testRoot 'obhajoba\main.tex'
    if (-not (Test-Path -LiteralPath $thesisMain -PathType Leaf)) { throw 'Thesis main.tex was not initialized.' }
    if (-not (Test-Path -LiteralPath $presentationMain -PathType Leaf)) { throw 'Presentation main.tex was not initialized.' }

    $thesis = Get-Content -Raw -Encoding UTF8 -LiteralPath $thesisMain
    $activeStarts = @([regex]::Matches($thesis, '(?m)^\s*\\ThesisStart\{.*\}\s*$'))
    if ($activeStarts.Count -ne 1) { throw "Expected exactly one active ThesisStart, found $($activeStarts.Count)." }
    if ($activeStarts[0].Value -notmatch '\{male\}') { throw 'Fictional profile title-page variant was not applied.' }
    $thesisMetadata = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $testRoot 'prace\nastaveni\udaje.tex')
    if ($thesisMetadata -notmatch 'Test Student') { throw 'Fictional profile metadata was not applied.' }
    if ($thesis -notmatch 'input\{nastaveni/balicky\}' -or -not (Test-Path (Join-Path $testRoot 'prace\sablona\loga\FM'))) { throw 'Default thesis must use the organized layout.' }
    $presentation = Get-Content -Raw -Encoding UTF8 -LiteralPath $presentationMain
    if ($presentation -notmatch 'Test Student' -or $presentation -notmatch 'Testovaci prace') { throw 'Presentation profile metadata was not applied.' }
    if ($presentation -notmatch 'Path=./fonts/' -or -not (Test-Path -LiteralPath (Join-Path $testRoot 'obhajoba\fonts\LICENSE.txt'))) { throw 'Presentation must bundle the portable Inter fonts with their license.' }
    if ($presentation -match 'Šablona prezentace') { throw 'Presentation main.tex must be a minimal starter, not the upstream manual.' }
    if ($presentation -notmatch '\\documentclass\[FM,aspect169\]' -or $presentation -notmatch 'FM TUL') { throw 'Presentation faculty must come from study.faculty_code.' }

    $afterHash = Get-UpstreamHash
    if ($afterHash -ne $beforeHash) { throw 'templates/upstream changed during initialization test.' }
    Write-Output 'Template initialization test passed.'
}
finally {
    if (Test-Path -LiteralPath $testRoot) {
        $resolvedTestRoot = (Resolve-Path -LiteralPath $testRoot).Path
        $resolvedTemp = (Resolve-Path -LiteralPath ([IO.Path]::GetTempPath())).Path.TrimEnd([IO.Path]::DirectorySeparatorChar, [IO.Path]::AltDirectorySeparatorChar)
        if (-not $resolvedTestRoot.StartsWith($resolvedTemp + [IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase)) {
            throw "Refusing to remove unexpected test path: $resolvedTestRoot"
        }
        Remove-Item -LiteralPath $resolvedTestRoot -Recurse -Force
    }
}
