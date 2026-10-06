[CmdletBinding()]
param(
    [string]$WorkDir = '.ci-work',
    [string]$ArtifactDir = '.ci-artifacts',
    [switch]$KeepWork
)

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path

function Resolve-InRepo {
    param([string]$Path)
    $full = [IO.Path]::GetFullPath($(if ([IO.Path]::IsPathRooted($Path)) { $Path } else { Join-Path $repoRoot $Path }))
    if (-not $full.StartsWith($repoRoot + [IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase)) { throw "Path must resolve inside the repository: $Path" }
    return $full
}

$workPath = Resolve-InRepo $WorkDir
$artifactPath = Resolve-InRepo $ArtifactDir
$required = @('xelatex', 'biber', 'makeindex')
$missing = @($required | Where-Object { -not (Get-Command $_ -CommandType Application -ErrorAction SilentlyContinue) })
if ($missing.Count -gt 0) {
    Write-Output "[SKIP] TUL build smoke test: missing $($missing -join ', '). No software was installed."
    exit 0
}

try {
    if (Test-Path -LiteralPath $workPath) { Remove-Item -LiteralPath $workPath -Recurse -Force }
    if (Test-Path -LiteralPath $artifactPath) { Remove-Item -LiteralPath $artifactPath -Recurse -Force }
    New-Item -ItemType Directory -Path $workPath -Force | Out-Null
    New-Item -ItemType Directory -Path $artifactPath -Force | Out-Null

    & (Join-Path $repoRoot 'scripts\setup-profile.ps1') `
        -DestinationRoot $workPath -FullName 'Test Student' -PreferredName 'Test' -Faculty FM -WorkType BP -Language CZ -Year 2026 `
        -FrontMatterVariant male -ProgrammeCode 'N0000' -ProgrammeNameCs 'Testovaci program' -ProgrammeNameEn 'Test programme' `
        -BranchCode 'S0000' -BranchNameCs 'Testovaci specializace' -BranchNameEn 'Test specialization' `
        -TitleCs 'Testovaci prace' -TitleEn 'Test thesis' -Supervisor 'Test Supervisor' -Consultant 'Test Consultant'
    & (Join-Path $repoRoot 'scripts\init-project.ps1') -DestinationRoot $workPath -Target All

    $main = Join-Path $workPath 'prace\main.tex'
    $text = Get-Content -Raw -Encoding UTF8 -LiteralPath $main
    $text = [regex]::Replace($text, '(?s)(\\begin\{abstractCZ\}).*?(\\end\{abstractCZ\})', '$1CI test abstract.$2')
    $text = [regex]::Replace($text, '(?s)(\\begin\{keywordsCZ\}).*?(\\end\{keywordsCZ\})', '$1test, build, template$2')
    $text = $text.Replace('Add the English abstract.', 'English abstract used only for the CI build test.')
    $text = $text.Replace('Add English keywords.', 'test, build, template')
    $text = [regex]::Replace($text, '(?s)(\\begin\{acknowledgement\}).*?(\\end\{acknowledgement\})', '$1CI test acknowledgement.$2')
    foreach ($starterPattern in @(
        'Popi\u0161te motivaci, c\u00edl pr\u00e1ce a jej\u00ed strukturu\.',
        'Zpracujte odborn\u00e1 v\u00fdchodiska a citujte zdroje evidovan\u00e9 ve slo\u017ece \\texttt\{zdroje/\}\.',
        'Popi\u0161te n\u00e1vrh, realizaci, experimenty nebo m\u011b\u0159en\u00ed\.',
        'Vyhodno\u0165te v\u00fdsledky, omezen\u00ed a vztah k c\u00edli pr\u00e1ce\.',
        'Shr\u0148te dosa\u017een\u00e9 v\u00fdsledky a doporu\u010den\u00ed pro dal\u0161\u00ed pr\u00e1ci\.',
        'Uve\u010fte vlo\u017een\u00e9 p\u0159\u00edlohy nebo odkazy na samostatn\u00e9 dokumenty registrovan\u00e9 v \\texttt\{PROJECT\\_CONTEXT\.md\}\.'
    )) {
        $text = [regex]::Replace($text, $starterPattern, 'CI test content.')
    }
    $text = $text.Replace('\printbibliography', '\nocite{ci-source}' + [Environment]::NewLine + '\printbibliography')
    $declaration = 'Ukázkový text a technické skripty tohoto cvičení byly připraveny s pomocí nástroje Codex; verze nebyla zaznamenána. Jde pouze o syntetický test šablony, nikoli skutečnou školní práci. Samostatná kontrola autora není tímto testem potvrzena.'
    $text = $text.Replace('\chapter{Úvod}', ('\chapter*{Použití AI v cvičení}' + [Environment]::NewLine + $declaration + [Environment]::NewLine + '\chapter{Úvod}'))
    Set-Content -LiteralPath (Join-Path $workPath 'declaration.txt') -Value $declaration -Encoding UTF8
    $today = (Get-Date).ToString('yyyy-MM-dd')
    "| $today | main: prace/main.tex, syntetické cvičení a skripty | Codex, verze nezaznamenána | Technický test vytvoření PDF | Čistý build a preflight | Čeká na autora |" | Set-Content -LiteralPath (Join-Path $workPath 'POUZITI_AI.md') -Encoding UTF8
    Set-Content -LiteralPath $main -Value $text -Encoding UTF8
    '@book{ci-source,author={Student, Test},title={CI fixture},year={2026},publisher={Test Publisher}}' | Set-Content -LiteralPath (Join-Path $workPath 'prace\references.bib') -Encoding UTF8

    & (Join-Path $repoRoot 'scripts\compile-thesis.ps1') -ProjectDir (Join-Path $workPath 'prace') -MainTex main.tex -Clean
    & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $repoRoot 'scripts\validate-deliverable.ps1') -ProjectDir (Join-Path $workPath 'prace') -DocumentKind Thesis -AllowGeneratedFrontMatter -ReportJson (Join-Path $artifactPath 'thesis-preflight.json')
    if ($LASTEXITCODE -ne 0) { throw 'Thesis deliverable preflight failed.' }

    & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $repoRoot 'scripts\check-ai-evidence.ps1') -ProjectRoot $workPath -Submission -DeclarationPath declaration.txt -PdfPath prace/main.pdf -ReportJson (Join-Path $artifactPath 'ai-evidence.json')
    if ($LASTEXITCODE -ne 0) { throw 'Actual PDF must contain the full synthetic AI declaration.' }
    $aiEvidence = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $artifactPath 'ai-evidence.json') | ConvertFrom-Json
    if (-not @($aiEvidence.checks | Where-Object { $_.id -eq 'declaration-pdf' -and $_.status -eq 'PASS' }).Count) { throw 'AI declaration extraction was not verified; smoke test cannot claim a pass.' }
    $falseDeclaration = Join-Path $workPath 'absent-declaration.txt'
    'This deliberately different declaration is absent from the generated PDF.' | Set-Content -LiteralPath $falseDeclaration -Encoding UTF8
    $negativeReport = & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $repoRoot 'scripts\check-ai-evidence.ps1') -ProjectRoot $workPath -Submission -DeclarationPath absent-declaration.txt -PdfPath prace/main.pdf -Json
    if ($LASTEXITCODE -ne 1) { throw 'A declaration absent from PDF must fail.' }
    $negativeEvidence = $negativeReport -join "`n" | ConvertFrom-Json
    if (-not @($negativeEvidence.checks | Where-Object { $_.id -eq 'declaration-pdf' -and $_.status -eq 'FAIL' }).Count) { throw 'Missing declaration must fail for the intended reason.' }

    Copy-Item -LiteralPath (Join-Path $workPath 'prace\main.pdf') -Destination (Join-Path $artifactPath 'thesis.pdf')
    $presentationStatus = 'skipped'
    $kpsewhich = Get-Command 'kpsewhich' -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($kpsewhich) {
        $previousPreference = $ErrorActionPreference
        $ErrorActionPreference = 'Continue'
        $beamerOutput = @(& $kpsewhich.Source beamer.cls 2>$null)
        $kpseExitCode = $LASTEXITCODE
        $beamerPath = $beamerOutput | Select-Object -First 1
        $ErrorActionPreference = $previousPreference
        if ($kpseExitCode -eq 0 -and $beamerPath) {
            $presentationMain = Join-Path $workPath 'obhajoba\main.tex'
            $presentationText = Get-Content -Raw -Encoding UTF8 -LiteralPath $presentationMain
            $presentationText = $presentationText.Replace('Doplňte cíl práce.', 'Synthetic build fixture, not an academic result.')
            $presentationText = $presentationText.Replace('Doplňte hlavní postup a ověřený výsledek.', 'The purpose is to verify the template build.')
            Set-Content -LiteralPath $presentationMain -Value $presentationText -Encoding UTF8
            & (Join-Path $repoRoot 'scripts\compile-presentation.ps1') -ProjectDir (Join-Path $workPath 'obhajoba') -MainTex main.tex -Clean
            & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $repoRoot 'scripts\validate-deliverable.ps1') -ProjectDir (Join-Path $workPath 'obhajoba') -DocumentKind Presentation -ReportJson (Join-Path $artifactPath 'presentation-preflight.json')
            if ($LASTEXITCODE -ne 0) { throw 'Presentation deliverable preflight failed.' }
            Copy-Item -LiteralPath (Join-Path $workPath 'obhajoba\main.pdf') -Destination (Join-Path $artifactPath 'presentation.pdf')
            $presentationStatus = 'pass'
        }
    }

    [ordered]@{
        status = 'pass'
        thesis_status = 'pass'
        thesis_pdf = 'thesis.pdf'
        presentation_status = $presentationStatus
        presentation_pdf = if ($presentationStatus -eq 'pass') { 'presentation.pdf' } else { $null }
    } | ConvertTo-Json | Set-Content -LiteralPath (Join-Path $artifactPath 'build-summary.json') -Encoding UTF8
    if ($presentationStatus -eq 'pass') {
        Write-Output '[PASS] Thesis and presentation compiled and passed deliverable preflight.'
    } else {
        Write-Output '[PASS] Thesis compiled and passed preflight. [SKIP] Presentation: Beamer is unavailable; no package was installed.'
    }
}
finally {
    if (-not $KeepWork -and (Test-Path -LiteralPath $workPath)) { Remove-Item -LiteralPath $workPath -Recurse -Force }
}
