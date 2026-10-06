[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$testRoot = Join-Path ([IO.Path]::GetTempPath()) ("tul-handoff-test-" + [guid]::NewGuid().ToString('N'))

function Assert-Throws {
    param(
        [Parameter(Mandatory)][scriptblock]$Action,
        [Parameter(Mandatory)][string]$ExpectedMessage
    )

    $threw = $false
    try {
        & $Action | Out-Null
    } catch {
        $threw = $true
        if ($_.Exception.Message -notmatch [regex]::Escape($ExpectedMessage)) {
            throw "Expected error containing '$ExpectedMessage', got: $($_.Exception.Message)"
        }
    }
    if (-not $threw) { throw "Expected action to fail with: $ExpectedMessage" }
}

try {
    $scriptsDir = Join-Path $testRoot 'scripts'
    $outgoingDir = Join-Path $testRoot 'predavani\odchozi'
    $sourceDir = Join-Path $testRoot 'prace\kapitoly'
    New-Item -ItemType Directory -Path $scriptsDir, $outgoingDir, $sourceDir -Force | Out-Null
    Copy-Item -LiteralPath (Join-Path $repoRoot 'scripts\new-handoff-package.ps1') -Destination $scriptsDir
    Copy-Item -LiteralPath (Join-Path $repoRoot 'scripts\verify-handoff-package.ps1') -Destination $scriptsDir

    $sourcePath = Join-Path $sourceDir 'metodika.tex'
    '\section{Metodika}' | Set-Content -LiteralPath $sourcePath -Encoding UTF8
    $notePath = Join-Path $testRoot 'prace\poznamka.txt'
    'Demonstrační poznámka.' | Set-Content -LiteralPath $notePath -Encoding UTF8

    $createScript = Join-Path $scriptsDir 'new-handoff-package.ps1'
    $verifyScript = Join-Path $scriptsDir 'verify-handoff-package.ps1'
    & $createScript `
        -Name 'Kapitola metodika' `
        -Recipient 'vedoucí práce' `
        -Purpose 'Kontrola a začlenění' `
        -SourcePaths @('prace\kapitoly\metodika.tex', 'prace\poznamka.txt') | Out-Null

    $packages = @(Get-ChildItem -LiteralPath $outgoingDir -Directory)
    if ($packages.Count -ne 1) { throw "Expected one package, found $($packages.Count)." }
    $packageRoot = $packages[0].FullName
    $manifestPath = Join-Path $packageRoot 'manifest.json'
    $handoffPath = Join-Path $packageRoot 'PREDANI.md'
    $copiedSource = Join-Path $packageRoot 'obsah\prace\kapitoly\metodika.tex'

    Assert-Throws -Action { & $verifyScript -PackagePath $packageRoot } -ExpectedMessage 'template placeholders'
    & $verifyScript -PackagePath $packageRoot -AllowIncompleteDescription | Out-Null
    Assert-Throws -Action {
        & $verifyScript -PackagePath $packageRoot -AllowIncompleteDescription -CreateZip
    } -ExpectedMessage 'cannot be combined'

    @'
# Předání: Kapitola metodika

## Komu a proč

- Odesílatel: autor práce
- Příjemce: vedoucí práce
- Účel: kontrola a začlenění
- Datum: 2026-09-02

## Co balíček obsahuje

Kapitolu metodiky a doprovodnou textovou poznámku.

## Stav práce

Agent draft po technické kontrole.

## Důležitá rozhodnutí a předpoklady

Relativní cesty se mají v cílovém projektu zachovat.

## Ověření

Kontrola manifestu a automatický test.

## Otevřené body a známá rizika

Příjemce musí posoudit odborný význam.

## Požadovaný krok příjemce

Porovnat změny a navrhnout cílené začlenění.

## Omezení sdílení

Bez zvláštních omezení pro tento syntetický test.
'@ | Set-Content -LiteralPath $handoffPath -Encoding UTF8

    & $verifyScript -PackagePath $packageRoot | Out-Null
    $manifest = Get-Content -Raw -Encoding UTF8 -LiteralPath $manifestPath | ConvertFrom-Json
    if ([int]$manifest.file_count -ne 2) { throw 'Manifest must contain two files.' }
    if (@($manifest.files.suggested_target) -notcontains 'prace/kapitoly/metodika.tex') {
        throw 'Manifest did not preserve the project-relative target path.'
    }

    'poškozený obsah' | Set-Content -LiteralPath $copiedSource -Encoding UTF8
    Assert-Throws -Action { & $verifyScript -PackagePath $packageRoot } -ExpectedMessage 'mismatch'
    Copy-Item -LiteralPath $sourcePath -Destination $copiedSource -Force

    $unexpectedPath = Join-Path $packageRoot 'obsah\neocekavany.txt'
    'neočekávaný obsah' | Set-Content -LiteralPath $unexpectedPath -Encoding UTF8
    Assert-Throws -Action { & $verifyScript -PackagePath $packageRoot } -ExpectedMessage 'Unexpected file'
    Remove-Item -LiteralPath $unexpectedPath -Force

    $manifestOriginal = Get-Content -Raw -Encoding UTF8 -LiteralPath $manifestPath
    $unsafeManifest = $manifestOriginal | ConvertFrom-Json
    $unsafeManifest.files[0].suggested_target = '../mimo-projekt.txt'
    $unsafeManifest | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $manifestPath -Encoding UTF8
    Assert-Throws -Action { & $verifyScript -PackagePath $packageRoot } -ExpectedMessage 'Unsafe suggested_target'
    $manifestOriginal | Set-Content -LiteralPath $manifestPath -Encoding UTF8

    $profilePath = Join-Path $testRoot 'PROJECT_PROFILE.json'
    '{"private":true}' | Set-Content -LiteralPath $profilePath -Encoding UTF8
    Assert-Throws -Action {
        & $createScript -Name 'Citlivy profil' -SourcePaths @('PROJECT_PROFILE.json')
    } -ExpectedMessage 'Blocked sensitive'

    $envPath = Join-Path $testRoot 'prace\.env.local'
    'TOKEN=test' | Set-Content -LiteralPath $envPath -Encoding UTF8
    Assert-Throws -Action {
        & $createScript -Name 'Citlive prostredi' -SourcePaths @('prace\.env.local')
    } -ExpectedMessage 'Blocked sensitive'

    $outsideOutput = Join-Path $testRoot 'mimo-predavani'
    Assert-Throws -Action {
        & $createScript -Name 'Spatny vystup' -SourcePaths @('prace\poznamka.txt') -OutputRoot $outsideOutput
    } -ExpectedMessage 'OutputRoot must be inside'

    & $verifyScript -PackagePath $packageRoot -CreateZip | Out-Null
    $zipPath = "$packageRoot.zip"
    if (-not (Test-Path -LiteralPath $zipPath -PathType Leaf)) { throw 'Verified ZIP was not created.' }

    $extractRoot = Join-Path $testRoot 'rozbaleno'
    Expand-Archive -LiteralPath $zipPath -DestinationPath $extractRoot
    $extractedPackage = Join-Path $extractRoot (Split-Path -Leaf $packageRoot)
    & $verifyScript -PackagePath $extractedPackage | Out-Null

    $demoPackage = Join-Path $repoRoot 'ukazky\spoluprace\balicek'
    & (Join-Path $repoRoot 'scripts\verify-handoff-package.ps1') -PackagePath $demoPackage | Out-Null

    # Verify the published fixture after a real Git checkout on both line-ending policies.
    foreach ($autoCrlf in @('true', 'false')) {
        $gitRoot = Join-Path $testRoot "git-$autoCrlf"
        $checkoutRoot = Join-Path $testRoot "checkout-$autoCrlf"
        $fixtureParent = Join-Path $gitRoot 'ukazky\spoluprace'
        New-Item -ItemType Directory -Path $fixtureParent, $checkoutRoot -Force | Out-Null
        Copy-Item -LiteralPath (Join-Path $repoRoot '.gitattributes') -Destination $gitRoot
        Copy-Item -LiteralPath $demoPackage -Destination $fixtureParent -Recurse
        & git -C $gitRoot init --quiet
        if ($LASTEXITCODE -ne 0) { throw 'Could not initialize checkout regression repository.' }
        & git -C $gitRoot -c "core.autocrlf=$autoCrlf" add -- .gitattributes ukazky/spoluprace/balicek
        if ($LASTEXITCODE -ne 0) { throw 'Could not stage checkout regression fixture.' }
        $checkoutPrefix = $checkoutRoot.Replace('\', '/') + '/'
        & git -C $gitRoot -c "core.autocrlf=$autoCrlf" checkout-index --all "--prefix=$checkoutPrefix"
        if ($LASTEXITCODE -ne 0) { throw 'Could not export checkout regression fixture.' }
        & (Join-Path $repoRoot 'scripts\verify-handoff-package.ps1') `
            -PackagePath (Join-Path $checkoutRoot 'ukazky\spoluprace\balicek') | Out-Null
    }

    Write-Output 'Handoff package tests passed.'
} finally {
    if (Test-Path -LiteralPath $testRoot) {
        $resolved = (Resolve-Path -LiteralPath $testRoot).Path
        $temp = (Resolve-Path -LiteralPath ([IO.Path]::GetTempPath())).Path.TrimEnd(
            [IO.Path]::DirectorySeparatorChar,
            [IO.Path]::AltDirectorySeparatorChar
        )
        if (-not $resolved.StartsWith($temp + [IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase)) {
            throw "Refusing to remove unexpected test path: $resolved"
        }
        Remove-Item -LiteralPath $resolved -Recurse -Force
    }
}
