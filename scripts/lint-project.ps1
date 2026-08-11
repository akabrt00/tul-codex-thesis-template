[CmdletBinding()]
param(
    [ValidateSet('Text', 'Json')][string]$OutputFormat = 'Text',
    [string]$ReportPath
)

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$issues = [Collections.Generic.List[object]]::new()

function Add-Issue {
    param(
        [ValidateSet('WARN', 'FAIL')][string]$Status,
        [string]$Id,
        [string]$Path,
        [int]$Line = 0,
        [string]$Detail
    )
    $script:issues.Add([pscustomobject]@{
        status = $Status
        id = $Id
        path = $Path.Replace('\', '/')
        line = $Line
        detail = $Detail
    })
}

$files = @(
    Get-ChildItem -LiteralPath $repoRoot -Recurse -Force -File |
        Where-Object {
            $relative = $_.FullName.Substring($repoRoot.Length + 1).Replace('\', '/')
            $relative -notmatch '^(templates/upstream|\.git|\.skill-staging|\.ci-work|\.ci-artifacts|node_modules|\.venv|venv|dist|build|coverage|tmp|\.tmp-|reviews)(/|$)' -and
            $relative -notmatch '(^|/)(\.build-logs)(/|$)' -and
            $_.Extension -in @('.md', '.json', '.yaml', '.yml', '.ps1', '.psm1', '.tex', '.bib')
        }
)

foreach ($file in $files) {
    $relative = $file.FullName.Substring($repoRoot.Length + 1)
    $lines = @(Get-Content -LiteralPath $file.FullName -Encoding UTF8)
    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -match '^(<<<<<<<|=======|>>>>>>>)') {
            Add-Issue FAIL merge-conflict $relative ($i + 1) 'Unresolved Git conflict marker.'
        }
        if ($lines[$i] -match '[ \t]+$') {
            Add-Issue WARN trailing-whitespace $relative ($i + 1) 'Trailing whitespace.'
        }
    }

    switch ($file.Extension.ToLowerInvariant()) {
        '.json' {
            try { Get-Content -Raw -Encoding UTF8 -LiteralPath $file.FullName | ConvertFrom-Json | Out-Null }
            catch { Add-Issue FAIL invalid-json $relative 0 $_.Exception.Message }
        }
        { $_ -in @('.ps1', '.psm1') } {
            $tokens = $null
            $parseErrors = $null
            [Management.Automation.Language.Parser]::ParseFile($file.FullName, [ref]$tokens, [ref]$parseErrors) | Out-Null
            foreach ($parseError in @($parseErrors)) {
                Add-Issue FAIL powershell-syntax $relative $parseError.Extent.StartLineNumber $parseError.Message
            }
        }
        { $_ -in @('.yaml', '.yml') } {
            $nonEmpty = @($lines | Where-Object { $_ -match '\S' -and $_ -notmatch '^\s*#' })
            if ($nonEmpty.Count -eq 0) { Add-Issue WARN empty-yaml $relative 0 'YAML file contains no data.' }
            foreach ($line in $nonEmpty) {
                if ($line -match '^\t+') { Add-Issue FAIL yaml-tab-indentation $relative 0 'YAML indentation must not use tabs.'; break }
            }
        }
    }
}

$failCount = @($issues | Where-Object status -eq 'FAIL').Count
$warnCount = @($issues | Where-Object status -eq 'WARN').Count
$report = [ordered]@{
    schema_version = 1
    status = if ($failCount -gt 0) { 'fail' } elseif ($warnCount -gt 0) { 'warn' } else { 'pass' }
    scanned_files = $files.Count
    fail_count = $failCount
    warn_count = $warnCount
    issues = @($issues)
}
$json = $report | ConvertTo-Json -Depth 6

if ($ReportPath) {
    $reportFullPath = [IO.Path]::GetFullPath((Join-Path $repoRoot $ReportPath))
    if (-not $reportFullPath.StartsWith($repoRoot + [IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase)) {
        throw 'ReportPath must resolve inside the repository.'
    }
    $parent = Split-Path -Parent $reportFullPath
    if (-not (Test-Path -LiteralPath $parent)) { New-Item -ItemType Directory -Path $parent -Force | Out-Null }
    $json | Set-Content -LiteralPath $reportFullPath -Encoding UTF8
}

if ($OutputFormat -eq 'Json') {
    $json
} else {
    Write-Output 'Project lint'
    Write-Output '============'
    Write-Output "Scanned files: $($files.Count)"
    foreach ($issue in $issues) {
        $location = if ($issue.line -gt 0) { "$($issue.path):$($issue.line)" } else { $issue.path }
        Write-Output "[$($issue.status)] $($issue.id) - $location - $($issue.detail)"
    }
    if ($issues.Count -eq 0) { Write-Output '[PASS] No structural issues found.' }
    Write-Output "Summary: $failCount FAIL, $warnCount WARN"
}

if ($failCount -gt 0) { exit 1 }
