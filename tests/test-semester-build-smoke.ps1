[CmdletBinding()]
param()
$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
if ((Get-Command pdflatex,bibtex -ErrorAction SilentlyContinue | Measure-Object).Count -ne 2) {
    Write-Output 'Semester build smoke test skipped: pdfLaTeX and BibTeX are required.'
    exit 0
}
$workRoot = Join-Path $repoRoot '.ci-work/semester'
$artifacts = Join-Path $repoRoot '.ci-artifacts/semester'
foreach ($ownedPath in @($workRoot, $artifacts)) {
    $resolved = [IO.Path]::GetFullPath($ownedPath)
    if ($resolved -notin @((Join-Path $repoRoot '.ci-work\semester'), (Join-Path $repoRoot '.ci-artifacts\semester'))) { throw 'Unexpected semester cleanup path.' }
    if (Test-Path -LiteralPath $resolved) { Remove-Item -LiteralPath $resolved -Recurse -Force }
}
New-Item -ItemType Directory -Path $artifacts -Force | Out-Null
$summary = @()
foreach ($faculty in @('FS','FT','FP','EF','FA','FM','FZS')) {
    $destination = Join-Path $workRoot $faculty
    & "$repoRoot/scripts/setup-profile.ps1" -DestinationRoot $destination -FullName 'Synthetic Student' -Faculty $faculty -WorkType SP -Language CZ -Year 2026 -TitleCs 'Syntetické ověření šablony' -Course 'Test předmětu' -WorkDate '10. 10. 2026' -AssignmentVersion '1' -Software 'Testovací nástroj'
    & "$repoRoot/scripts/init-project.ps1" -DestinationRoot $destination -Target Thesis
    $document = Join-Path $destination 'prace'
    $mainPath = Join-Path $document 'main.tex'
    $main = Get-Content -Raw -Encoding UTF8 -LiteralPath $mainPath
    $body = @'
\begin{document}
\TitulniStrana
\section{Ověření šablony}
Toto je výhradně syntetický technický test připravený nástrojem Codex.
Nejde o měření ani o skutečnou školní práci. Kontrola autora není tímto testem potvrzena.
\label{sec:test}
\section{Test citace a sazby}
Smyšlený zdroj slouží pouze k ověření BibTeXu~\cite{synthetic}.
České znaky: příliš žluťoučký kůň úpěl ďábelské ódy.
\newpage
\section{Závěr testu}
Odkaz na část~\ref{sec:test} ověřuje víceprůchodový překlad.
\bibliographystyle{unsrt}
\bibliography{literatura}
\end{document}
'@
    $main = $main.Substring(0, $main.IndexOf('\begin{document}')) + $body
    Set-Content -LiteralPath $mainPath -Value $main -Encoding UTF8
    Set-Content -LiteralPath (Join-Path $document 'literatura.bib') -Value '@book{synthetic,author={Student, Synthetic},title={Synthetic test fixture},year={2026},publisher={Test}}' -Encoding UTF8
    & "$repoRoot/scripts/compile-thesis.ps1" -ProjectDir $document -Clean
    & powershell -NoProfile -ExecutionPolicy Bypass -File "$repoRoot/scripts/validate-deliverable.ps1" -ProjectDir $document -DocumentKind Semester -ReportJson "$artifacts/$faculty.json" -Json | Out-Null
    if ($LASTEXITCODE -ne 0) { throw "Semester preflight failed for $faculty." }
    Copy-Item -LiteralPath (Join-Path $document 'main.pdf') -Destination (Join-Path $artifacts "$faculty.pdf")
    $summary += @{faculty=$faculty;status='pass';pdf=".ci-artifacts/semester/$faculty.pdf"}
    Write-Output "[PASS] ${faculty}: full semester build and PDF preflight."
}
$summary | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath (Join-Path $artifacts 'summary.json') -Encoding UTF8
Write-Output 'Semester build and preflight passed for all seven faculties. PDFs contain synthetic test content.'
