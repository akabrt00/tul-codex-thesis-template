[CmdletBinding()]
param([string]$SkillsRoot)

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
if (-not $SkillsRoot) { $SkillsRoot = Join-Path $repoRoot '.agents\skills' }
$skillsPath = (Resolve-Path -LiteralPath $SkillsRoot).Path
$errors = @()
$validated = @()

foreach ($directory in Get-ChildItem -LiteralPath $skillsPath -Force -Directory | Sort-Object Name) {
    $skillFile = Join-Path $directory.FullName 'SKILL.md'
    if (-not (Test-Path -LiteralPath $skillFile)) {
        $errors += "$($directory.Name): missing SKILL.md"
        continue
    }
    $content = Get-Content -LiteralPath $skillFile -Raw
    if ($content -notmatch '(?s)^---\r?\n(.*?)\r?\n---') {
        $errors += "$($directory.Name): invalid YAML frontmatter delimiters"
        continue
    }
    $frontmatter = $Matches[1]
    $nameMatch = [regex]::Match($frontmatter, '(?m)^name:\s*["'']?([^\r\n"'']+)["'']?\s*$')
    $descriptionMatch = [regex]::Match($frontmatter, '(?m)^description:\s*["'']?(.+?)["'']?\s*$')
    if (-not $nameMatch.Success) { $errors += "$($directory.Name): missing name"; continue }
    if (-not $descriptionMatch.Success) { $errors += "$($directory.Name): missing description"; continue }
    $name = $nameMatch.Groups[1].Value.Trim()
    $description = $descriptionMatch.Groups[1].Value.Trim()
    if ($name -ne $directory.Name) { $errors += "$($directory.Name): name '$name' does not match folder" }
    if ($name -notmatch '^[a-z0-9]+(?:-[a-z0-9]+)*$' -or $name.Length -gt 64) { $errors += "$($directory.Name): invalid skill name" }
    if ($description.Length -eq 0 -or $description.Length -gt 1024 -or $description -match '[<>]') { $errors += "$($directory.Name): invalid description" }
    if ($content -match '\[TODO|TODO:') { $errors += "$($directory.Name): template TODO remains" }
    $validated += [pscustomobject]@{ Skill = $name; DescriptionLength = $description.Length; SkillFile = $skillFile }
}

$validated | Format-Table -AutoSize
if ($errors.Count -gt 0) {
    Write-Output "`nSkill validation errors:"
    $errors | ForEach-Object { Write-Output "- $_" }
    exit 1
}
Write-Output "`nValidated $($validated.Count) repository skills."

