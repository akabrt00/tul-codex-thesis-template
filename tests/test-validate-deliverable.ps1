[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$validator = Join-Path $repoRoot 'scripts\validate-deliverable.ps1'
$fixturePdf = Join-Path $repoRoot 'templates\upstream\TUL\TULpresentation\priklad-pouziti-sablony-tulpresentation.pdf'
$testRoot = Join-Path $repoRoot '.tmp-preflight-tests'
$powershellExe = (Get-Command powershell -CommandType Application -ErrorAction Stop | Select-Object -First 1).Source
$passed = 0
$failed = 0

function Invoke-ValidatorCase {
    param([string]$Directory, [string[]]$ExtraArguments, [string]$Kind = 'Presentation')
    $arguments = @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', $validator, '-ProjectDir', $Directory, '-DocumentKind', $Kind, '-Json') + $ExtraArguments
    $output = @(& $powershellExe @arguments 2>&1)
    [pscustomobject]@{ ExitCode = $LASTEXITCODE; Output = ($output -join "`n") }
}

function Assert-Case {
    param([string]$Name, [int]$ExpectedExitCode, $Actual, [string]$OutputPattern)
    if ($Actual.ExitCode -eq $ExpectedExitCode -and (-not $OutputPattern -or $Actual.Output -match $OutputPattern)) {
        Write-Output "[PASS] $Name"
        $script:passed++
    } else {
        Write-Output "[FAIL] $Name - expected exit $ExpectedExitCode/pattern '$OutputPattern', got exit $($Actual.ExitCode): $($Actual.Output)"
        $script:failed++
    }
}

function New-CaseDirectory {
    param([string]$Name, [string]$MainText = '\documentclass{article}\begin{document}Complete document text for an automated preflight test.\end{document}')
    $path = Join-Path $testRoot $Name
    New-Item -ItemType Directory -Path $path -Force | Out-Null
    Set-Content -LiteralPath (Join-Path $path 'main.tex') -Value $MainText -Encoding UTF8
    return $path
}

try {
    if (Test-Path -LiteralPath $testRoot) { Remove-Item -LiteralPath $testRoot -Recurse -Force }
    New-Item -ItemType Directory -Path $testRoot | Out-Null

    $missing = New-CaseDirectory 'missing-pdf'
    Assert-Case 'missing PDF fails' 1 (Invoke-ValidatorCase $missing @()) 'PDF exists'

    $zero = New-CaseDirectory 'zero-pdf'
    New-Item -ItemType File -Path (Join-Path $zero 'main.pdf') | Out-Null
    Assert-Case 'zero-byte PDF fails' 1 (Invoke-ValidatorCase $zero @()) 'PDF size'

    $broken = New-CaseDirectory 'broken-pdf'
    Set-Content -LiteralPath (Join-Path $broken 'main.pdf') -Value 'not a PDF' -Encoding ASCII
    Assert-Case 'broken PDF fails with available parser' 1 (Invoke-ValidatorCase $broken @()) 'PDF readable'

    $valid = New-CaseDirectory 'valid-pdf'
    Copy-Item -LiteralPath $fixturePdf -Destination (Join-Path $valid 'main.pdf')
    Assert-Case 'valid PDF passes without critical findings' 0 (Invoke-ValidatorCase $valid @()) '"fail":0'

    $placeholder = New-CaseDirectory 'placeholder' '\documentclass{article}\begin{document}TODO: complete this section.\end{document}'
    Copy-Item -LiteralPath $fixturePdf -Destination (Join-Path $placeholder 'main.pdf')
    Assert-Case 'placeholder fails' 1 (Invoke-ValidatorCase $placeholder @()) 'Placeholders'

    $czechPrompt = '\documentclass{article}\begin{document}Dopl' + [char]0x0148 + 'te starter text.\end{document}'
    $czechPlaceholder = New-CaseDirectory 'czech-placeholder' $czechPrompt
    Copy-Item -LiteralPath $fixturePdf -Destination (Join-Path $czechPlaceholder 'main.pdf')
    Assert-Case 'Czech starter placeholder fails' 1 (Invoke-ValidatorCase $czechPlaceholder @()) 'Placeholders'

    $legitimateEnglish = New-CaseDirectory 'legitimate-add-the' '\documentclass{article}\begin{document}Add the measured values only after review.\end{document}'
    Copy-Item -LiteralPath $fixturePdf -Destination (Join-Path $legitimateEnglish 'main.pdf')
    Assert-Case 'legitimate Add the prose passes' 0 (Invoke-ValidatorCase $legitimateEnglish @()) '"fail":0'

    $citation = New-CaseDirectory 'undefined-citation'
    Copy-Item -LiteralPath $fixturePdf -Destination (Join-Path $citation 'main.pdf')
    Set-Content -LiteralPath (Join-Path $citation 'main.log') -Value "LaTeX Warning: Citation 'missing' on page 1 undefined." -Encoding UTF8
    Assert-Case 'undefined citation fails' 1 (Invoke-ValidatorCase $citation @()) 'Citations resolved'

    $reference = New-CaseDirectory 'undefined-reference'
    Copy-Item -LiteralPath $fixturePdf -Destination (Join-Path $reference 'main.pdf')
    Set-Content -LiteralPath (Join-Path $reference 'main.log') -Value "LaTeX Warning: Reference 'missing' on page 1 undefined." -Encoding UTF8
    Assert-Case 'undefined reference fails' 1 (Invoke-ValidatorCase $reference @()) 'Cross-references resolved'

    $earlyReference = New-CaseDirectory 'early-reference-resolved'
    Copy-Item -LiteralPath $fixturePdf -Destination (Join-Path $earlyReference 'main.pdf')
    New-Item -ItemType Directory -Path (Join-Path $earlyReference '.build-logs') | Out-Null
    Set-Content -LiteralPath (Join-Path $earlyReference '.build-logs\01-xelatex.stdout.log') -Value "LaTeX Warning: Reference 'early' undefined." -Encoding UTF8
    Set-Content -LiteralPath (Join-Path $earlyReference 'main.log') -Value 'Final XeLaTeX pass completed without unresolved references.' -Encoding UTF8
    Assert-Case 'resolved early-pass reference does not fail final preflight' 0 (Invoke-ValidatorCase $earlyReference @()) '"fail":0'

    $duplicate = New-CaseDirectory 'duplicate-label'
    Copy-Item -LiteralPath $fixturePdf -Destination (Join-Path $duplicate 'main.pdf')
    Set-Content -LiteralPath (Join-Path $duplicate 'main.log') -Value "LaTeX Warning: Label 'x' multiply defined." -Encoding UTF8
    Assert-Case 'duplicate label fails' 1 (Invoke-ValidatorCase $duplicate @()) 'Duplicate labels'

    $overfull = New-CaseDirectory 'overfull-only'
    Copy-Item -LiteralPath $fixturePdf -Destination (Join-Path $overfull 'main.pdf')
    Set-Content -LiteralPath (Join-Path $overfull 'main.log') -Value 'Overfull \hbox (3.0pt too wide) in paragraph at lines 1--2' -Encoding UTF8
    Assert-Case 'overfull box is warning only' 0 (Invoke-ValidatorCase $overfull @()) 'Overfull boxes'

    $emptyBib = New-CaseDirectory 'empty-bibliography' '\documentclass{article}\begin{document}Complete text.\printbibliography\end{document}'
    Copy-Item -LiteralPath $fixturePdf -Destination (Join-Path $emptyBib 'main.pdf')
    New-Item -ItemType File -Path (Join-Path $emptyBib 'main.bbl') | Out-Null
    Assert-Case 'empty bibliography fails' 1 (Invoke-ValidatorCase $emptyBib @()) 'Bibliography'

    $nonemptyBib = New-CaseDirectory 'nonempty-bibliography' '\documentclass{article}\begin{document}Complete text.\printbibliography\end{document}'
    Copy-Item -LiteralPath $fixturePdf -Destination (Join-Path $nonemptyBib 'main.pdf')
    Set-Content -LiteralPath (Join-Path $nonemptyBib 'main.bbl') -Value '\entry{verified}{book}{}' -Encoding UTF8
    Assert-Case 'nonempty bibliography passes' 0 (Invoke-ValidatorCase $nonemptyBib @()) '"fail":0'

    $generatedText = "\documentclass{article}`n\begin{document}`n\ThesisStart{male}`nComplete thesis text.`n\end{document}"
    $generatedFrontMatter = New-CaseDirectory 'generated-front-matter' $generatedText
    Copy-Item -LiteralPath $fixturePdf -Destination (Join-Path $generatedFrontMatter 'main.pdf')
    Assert-Case 'generated primary-thesis front matter blocks submission' 1 (Invoke-ValidatorCase $generatedFrontMatter @('-ExpectedPageSize','Any') 'Thesis') 'Official introductory pages'
    Assert-Case 'generated front matter can be allowed for a working test' 0 (Invoke-ValidatorCase $generatedFrontMatter @('-ExpectedPageSize','Any','-AllowGeneratedFrontMatter') 'Thesis') '"fail":0'

    $noFrontMatter = New-CaseDirectory 'missing-front-matter' '\documentclass{article}\begin{document}Complete thesis text.\end{document}'
    Copy-Item -LiteralPath $fixturePdf -Destination (Join-Path $noFrontMatter 'main.pdf')
    Assert-Case 'missing ThesisStart fails' 1 (Invoke-ValidatorCase $noFrontMatter @('-ExpectedPageSize','Any') 'Thesis') 'ThesisStart'

    $duplicateText = "\documentclass{article}`n\begin{document}`n\ThesisStart{male}`n\ThesisStart{female}`nComplete thesis text.`n\end{document}"
    $duplicateFrontMatter = New-CaseDirectory 'duplicate-front-matter' $duplicateText
    Copy-Item -LiteralPath $fixturePdf -Destination (Join-Path $duplicateFrontMatter 'main.pdf')
    Assert-Case 'duplicate ThesisStart fails' 1 (Invoke-ValidatorCase $duplicateFrontMatter @('-ExpectedPageSize','Any') 'Thesis') 'ThesisStart'

    $noTools = New-CaseDirectory 'missing-utilities'
    Copy-Item -LiteralPath $fixturePdf -Destination (Join-Path $noTools 'main.pdf')
    $missingTool = Join-Path $noTools 'not-installed.exe'
    $toolArgs = @('-QpdfPath',$missingTool,'-PdfInfoPath',$missingTool,'-PdfToTextPath',$missingTool,'-PdfFontsPath',$missingTool,'-PythonPath',$missingTool)
    Assert-Case 'missing optional PDF utilities warn but do not crash' 0 (Invoke-ValidatorCase $noTools $toolArgs) 'unavailable'
} finally {
    if (Test-Path -LiteralPath $testRoot) { Remove-Item -LiteralPath $testRoot -Recurse -Force }
}

Write-Output "Focused preflight tests: $passed passed, $failed failed."
if ($failed -gt 0) { exit 1 }
