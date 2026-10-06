[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$testRoot = Join-Path ([IO.Path]::GetTempPath()) ("tul-record-test-" + [guid]::NewGuid().ToString('N'))
try {
    $reviewScripts = Join-Path $testRoot '.agents\skills\review-agent-output\scripts'
    $calculationScripts = Join-Path $testRoot '.agents\skills\verify-scientific-calculations\scripts'
    New-Item -ItemType Directory -Path $reviewScripts -Force | Out-Null
    New-Item -ItemType Directory -Path $calculationScripts -Force | Out-Null
    Copy-Item -LiteralPath (Join-Path $repoRoot '.agents\skills\review-agent-output\scripts\new-review-record.ps1') -Destination $reviewScripts
    Copy-Item -LiteralPath (Join-Path $repoRoot '.agents\skills\review-agent-output\scripts\set-review-decision.ps1') -Destination $reviewScripts
    Copy-Item -LiteralPath (Join-Path $repoRoot '.agents\skills\verify-scientific-calculations\scripts\new-calculation-record.ps1') -Destination $calculationScripts

    $review = & (Join-Path $reviewScripts 'new-review-record.ps1') `
        -Scope 'Test chapter and table' `
        -DocumentKey main `
        -TechnicalStatus passed `
        -ArtifactPaths @('prace/main.tex') `
        -HumanChecks @('Meaning and evidence are correct.')
    if ($review.ReviewId -ne 'REV-0001') { throw 'Expected the first review ID to be REV-0001.' }
    $reviewJson = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $testRoot 'reviews\REV-0001.json') | ConvertFrom-Json
    if ($reviewJson.status -ne 'awaiting-human-review') { throw 'New review must await human review.' }

    & (Join-Path $reviewScripts 'set-review-decision.ps1') `
        -ReviewId REV-0001 `
        -Decision approved `
        -UserStatement 'I reviewed this exact test scope.' | Out-Null
    $approved = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $testRoot 'reviews\REV-0001.json') | ConvertFrom-Json
    if ($approved.status -ne 'human-approved') { throw 'Explicit approval was not recorded.' }
    $queue = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $testRoot 'reviews\REVIEW_QUEUE.md')
    if ($queue -notmatch 'human-approved') { throw 'Review queue was not updated.' }

    $documentDir = Join-Path $testRoot 'prace\dokumenty\test-document'
    New-Item -ItemType Directory -Path $documentDir -Force | Out-Null
    '\documentclass{article}' | Set-Content -LiteralPath (Join-Path $documentDir 'main.tex') -Encoding UTF8
    $calculation = & (Join-Path $calculationScripts 'new-calculation-record.ps1') -DocumentDir $documentDir -Title 'Test calculation'
    if ($calculation.CalculationId -ne 'CALC-0001') { throw 'Expected the first calculation ID to be CALC-0001.' }
    $metadata = Get-Content -Raw -Encoding UTF8 -LiteralPath $calculation.Metadata | ConvertFrom-Json
    if ($metadata.status -ne 'incomplete' -or $metadata.review_ids.Count -ne 0) { throw 'New calculation record has an invalid initial state.' }

    Write-Output 'Review and calculation record tests passed.'
}
finally {
    if (Test-Path -LiteralPath $testRoot) {
        $resolved = (Resolve-Path -LiteralPath $testRoot).Path
        $temp = (Resolve-Path -LiteralPath ([IO.Path]::GetTempPath())).Path.TrimEnd([IO.Path]::DirectorySeparatorChar, [IO.Path]::AltDirectorySeparatorChar)
        if (-not $resolved.StartsWith($temp + [IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase)) { throw 'Unsafe test cleanup path.' }
        Remove-Item -LiteralPath $resolved -Recurse -Force
    }
}
