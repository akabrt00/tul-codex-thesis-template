[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$testRoot = Join-Path ([IO.Path]::GetTempPath()) ("tul-skill-test-" + [guid]::NewGuid().ToString('N'))
try {
    $skillRoot = Join-Path $testRoot 'skills'
    $badSkill = Join-Path $skillRoot 'broken-skill'
    New-Item -ItemType Directory -Path (Join-Path $badSkill 'agents') -Force | Out-Null
    @'
---
name: wrong-name
description: Broken fixture used by the validator test.
---

# Broken fixture
'@ | Set-Content -LiteralPath (Join-Path $badSkill 'SKILL.md') -Encoding UTF8
    @'
interface:
  display_name: "Broken"
'@ | Set-Content -LiteralPath (Join-Path $badSkill 'agents\openai.yaml') -Encoding UTF8

    $output = (& powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $repoRoot 'scripts\validate-skills.ps1') -SkillsRoot $skillRoot 2>&1 | Out-String)
    if ($LASTEXITCODE -eq 0) { throw 'Invalid skill fixture unexpectedly passed validation.' }
    if ($output -notmatch 'does not match folder' -or $output -notmatch 'missing interface.short_description') {
        throw "Validator did not report the expected failures.`n$output"
    }
    Write-Output 'Negative skill validation test passed.'
}
finally {
    if (Test-Path -LiteralPath $testRoot) {
        $resolved = (Resolve-Path -LiteralPath $testRoot).Path
        $temp = (Resolve-Path -LiteralPath ([IO.Path]::GetTempPath())).Path.TrimEnd([IO.Path]::DirectorySeparatorChar, [IO.Path]::AltDirectorySeparatorChar)
        if (-not $resolved.StartsWith($temp + [IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase)) { throw 'Unsafe test cleanup path.' }
        Remove-Item -LiteralPath $resolved -Recurse -Force
    }
}
