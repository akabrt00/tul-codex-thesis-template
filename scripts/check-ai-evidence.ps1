[CmdletBinding()]
param(
    [string]$ProjectRoot,
    [ValidatePattern('^[a-z][a-z0-9-]*$')][string]$DocumentKey = 'main',
    [switch]$Submission,
    [string]$DeclarationPath,
    [string]$PdfPath,
    [string]$PdfToTextPath,
    [string]$ReportJson,
    [switch]$Json
)

# Checks evidence completeness, never institutional approval or academic correctness.
$ErrorActionPreference = 'Stop'
if (-not $ProjectRoot) { $ProjectRoot = Join-Path $PSScriptRoot '..' }
$root = (Resolve-Path -LiteralPath $ProjectRoot).Path
$checks = [Collections.Generic.List[object]]::new()
function Add-Check([string]$Status, [string]$Id, [string]$Detail) {
    $checks.Add([pscustomobject]@{ status = $Status; id = $Id; detail = $Detail })
}
function Resolve-Input([string]$Path) {
    if ([IO.Path]::IsPathRooted($Path)) { return $Path }
    return Join-Path $root $Path
}
function Normalize-Text([string]$Text) {
    return ([regex]::Replace($Text.Normalize([Text.NormalizationForm]::FormC), '\s+', ' ')).Trim()
}

try {
    $ledgerPath = Join-Path $root 'POUZITI_AI.md'
    $entries = [Collections.Generic.List[object]]::new()
    if (-not (Test-Path -LiteralPath $ledgerPath -PathType Leaf)) {
        Add-Check FAIL ledger 'POUZITI_AI.md is missing.'
    } else {
        $lineNumber = 0
        foreach ($line in Get-Content -LiteralPath $ledgerPath -Encoding UTF8) {
            $lineNumber++
            if ($line -notmatch '^\s*\|') { continue }
            if ($line -match '^\s*\|\s*Datum\s*\|' -or $line -match '^\s*\|\s*:?-{3,}') { continue }
            $cells = @($line.Trim().Trim('|').Split('|') | ForEach-Object { $_.Trim() })
            if ($cells.Count -ne 6) {
                Add-Check FAIL "row-$lineNumber" 'Expected six cells; replace a literal pipe inside a cell with &#124;.'
                continue
            }
            $date = [datetime]::MinValue
            if (-not [datetime]::TryParseExact($cells[0], 'yyyy-MM-dd', [Globalization.CultureInfo]::InvariantCulture, [Globalization.DateTimeStyles]::None, [ref]$date)) {
                Add-Check FAIL "date-$lineNumber" 'Invalid ISO date.'
            }
            if (@($cells | Where-Object { [string]::IsNullOrWhiteSpace($_) }).Count -gt 0) {
                Add-Check FAIL "incomplete-$lineNumber" 'Required evidence cell is empty; explicitly mark unavailable version or pending author verification.'
            }
            if ($cells[1] -notmatch '^[a-z][a-z0-9-]*:\s*\S') {
                Add-Check FAIL "document-$lineNumber" 'Affected part must start with the registered document key followed by a colon and a concrete part or path.'
                continue
            }
            if ($cells[1] -notmatch ('^' + [regex]::Escape($DocumentKey) + ':')) { continue }
            $entries.Add([pscustomobject]@{ line = $lineNumber; cells = $cells })
            if ($cells[2] -match '^\[|^doplnit$' -or $cells[3] -match '^\[|^doplnit$') {
                Add-Check FAIL "placeholder-$lineNumber" 'Tool or manner of use is still a placeholder.'
            }
            # Do not reproduce evidence contents in the report: it may contain personal context.
            Add-Check PASS "record-$lineNumber" 'Six evidence cells and a registered document-key format are present; their truthfulness still requires review.'
        }
        if ($entries.Count -eq 0) {
            Add-Check WARN records 'No substantive-use records for this document. An empty ledger is not evidence that AI was not used; resolve actual use manually.'
        }
    }

    if ($Submission) {
        Add-Check WARN 'human-verification' 'Author verification, declaration completeness, teacher/publisher restrictions and system approval must be confirmed by the responsible person; this script cannot approve them.'
        if ($entries.Count -gt 0) {
            if (-not $DeclarationPath -or -not (Test-Path -LiteralPath (Resolve-Input $DeclarationPath) -PathType Leaf)) {
                Add-Check FAIL declaration 'Substantive use is recorded but a UTF-8 plain-text declaration file was not supplied.'
            } else {
                $declaration = Normalize-Text (Get-Content -Raw -Encoding UTF8 -LiteralPath (Resolve-Input $DeclarationPath))
                if ($declaration.Length -lt 20 -or $declaration -match '\[[^\]]+\]') {
                    Add-Check FAIL declaration 'Declaration is empty, too short or contains square-bracket placeholders.'
                } elseif (-not $PdfPath -or -not (Test-Path -LiteralPath (Resolve-Input $PdfPath) -PathType Leaf)) {
                    Add-Check FAIL 'declaration-pdf' 'The final PDF must be supplied to check that the declaration reaches the assessed output.'
                } else {
                    $tool = if ($PdfToTextPath) { Get-Item -LiteralPath $PdfToTextPath } else { Get-Command pdftotext -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1 }
                    if (-not $tool) {
                        Add-Check WARN 'declaration-pdf' 'pdftotext unavailable; declaration in final PDF must be checked manually. No software was installed.'
                    } else {
                        $executable = if ($tool -is [IO.FileInfo]) { $tool.FullName } else { $tool.Source }
                        $previousPreference = $ErrorActionPreference
                        try {
                            $ErrorActionPreference = 'Continue'
                            $output = @(& $executable '-enc' 'UTF-8' (Resolve-Input $PdfPath) '-' 2>$null)
                            $extractExit = $LASTEXITCODE
                        } finally { $ErrorActionPreference = $previousPreference }
                        if ($extractExit -ne 0) { Add-Check FAIL 'declaration-pdf' 'PDF text extraction failed.' }
                        elseif ((Normalize-Text ($output -join "`n")).Contains($declaration)) {
                            Add-Check PASS 'declaration-pdf' 'The full normalized declaration text is present in the extracted PDF. This proves presence only, not completeness, truthfulness or the required institutional form.'
                        } else { Add-Check FAIL 'declaration-pdf' 'The full declaration text was not found in final PDF; check a stale build, missing insertion or extraction differences manually.' }
                    }
                }
            }
        }
    } else {
        Add-Check WARN 'working-only' 'Working evidence check only; no submission readiness or human approval is asserted.'
    }

    $failures = @($checks | Where-Object status -eq FAIL).Count
    $report = [ordered]@{
        document_key = $DocumentKey
        mode = if ($Submission) { 'submission-evidence' } else { 'working' }
        status = if ($failures -gt 0) { 'FAIL' } else { 'WARN' }
        institutional_compliance = 'not-established'
        author_verification = 'requires-human-confirmation'
        records = $entries.Count
        checks = @($checks.ToArray())
    }
    $serialized = $report | ConvertTo-Json -Depth 5
    if ($ReportJson) {
        $reportPath = Resolve-Input $ReportJson
        $parent = Split-Path -Parent $reportPath
        if (-not (Test-Path -LiteralPath $parent)) { New-Item -ItemType Directory -Path $parent -Force | Out-Null }
        Set-Content -LiteralPath $reportPath -Value $serialized -Encoding UTF8
    }
    if ($Json) { Write-Output $serialized }
    else { $checks | Format-Table -AutoSize -Wrap; Write-Output "AI evidence: $($report.status); records: $($entries.Count). Human review remains required." }
    if ($failures -gt 0) { exit 1 }
    exit 0
} catch {
    # Avoid echoing confidential input or native-tool output on error.
    if ($Json) { Write-Output '{"status":"ERROR","error":"AI evidence check could not run; verify paths, file format and tool availability."}' }
    else { Write-Output 'AI evidence check could not run; verify paths, file format and tool availability.' }
    exit 2
}
