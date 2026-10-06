[CmdletBinding()]
param()
$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$testRoot = Join-Path ([IO.Path]::GetTempPath()) ('tul-ai-evidence-' + [guid]::NewGuid().ToString('N'))
$checker = Join-Path $repoRoot 'scripts\check-ai-evidence.ps1'
New-Item -ItemType Directory -Path $testRoot | Out-Null
function Run-Check([string[]]$Arguments, [int]$ExpectedExit) {
    $output = & powershell -NoProfile -ExecutionPolicy Bypass -File $checker -ProjectRoot $testRoot -Json @Arguments
    if ($LASTEXITCODE -ne $ExpectedExit) { throw "Expected exit $ExpectedExit, got $LASTEXITCODE : $output" }
    return ($output -join "`n" | ConvertFrom-Json)
}
try {
    $missing = Run-Check @() 1
    '| Datum | Dokument | Nastroj | Pouziti | Agent | Autor |' | Set-Content -LiteralPath (Join-Path $testRoot 'POUZITI_AI.md') -Encoding UTF8
    $empty = Run-Check @() 0
    if ($empty.records -ne 0 -or $empty.status -ne 'WARN') { throw 'Empty ledger must not assert no AI use.' }
    '| 2026-10-06 | main: prace/main.tex, chapter 1 | Codex, version unavailable | Synthetic starter text | Build test | Pending author |' | Add-Content -LiteralPath (Join-Path $testRoot 'POUZITI_AI.md') -Encoding UTF8
    $working = Run-Check @() 0
    if ($working.records -ne 1 -or $working.author_verification -ne 'requires-human-confirmation') { throw 'Agent must not approve author verification.' }
    $submission = Run-Check @('-Submission') 1
    if (-not @($submission.checks | Where-Object { $_.id -eq 'declaration' -and $_.status -eq 'FAIL' }).Count) { throw 'Missing required declaration must fail.' }
    $different = Run-Check @('-DocumentKey', 'defense', '-Submission') 0
    if ($different.records -ne 0) { throw 'Evidence from another deliverable must not be reused.' }
    'A specific declaration of substantive AI use in this synthetic document.' | Set-Content -LiteralPath (Join-Path $testRoot 'declaration.txt') -Encoding UTF8
    $noPdf = Run-Check @('-Submission', '-DeclarationPath', 'declaration.txt') 1
    if (-not @($noPdf.checks | Where-Object { $_.id -eq 'declaration-pdf' -and $_.status -eq 'FAIL' }).Count) { throw 'Declaration file alone must not pass PDF presence check.' }
    '| 2026-02-31 | main: chapter 2 | Codex | Draft | Build | Pending |' | Set-Content -LiteralPath (Join-Path $testRoot 'POUZITI_AI.md') -Encoding UTF8
    $badDate = Run-Check @() 1
    if (-not @($badDate.checks | Where-Object id -like 'date-*').Count) { throw 'Invalid date must fail.' }
    '| 2026-10-06 | main: chapter 2 | Codex | Draft | | Pending |' | Set-Content -LiteralPath (Join-Path $testRoot 'POUZITI_AI.md') -Encoding UTF8
    $incomplete = Run-Check @() 1
    '| 2026-10-06 | prace/main.tex | Codex | Draft | Build | Pending |' | Set-Content -LiteralPath (Join-Path $testRoot 'POUZITI_AI.md') -Encoding UTF8
    $ambiguous = Run-Check @() 1
    Write-Output 'AI evidence negative and working-state tests passed.'
} finally {
    $resolved = (Resolve-Path -LiteralPath $testRoot).Path
    $tempRoot = [IO.Path]::GetFullPath([IO.Path]::GetTempPath()).TrimEnd('\', '/')
    if (-not $resolved.StartsWith($tempRoot + [IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase)) { throw 'Unsafe test cleanup path.' }
    Remove-Item -LiteralPath $resolved -Recurse -Force
}
