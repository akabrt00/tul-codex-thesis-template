[CmdletBinding()]
param(
    [string]$ScannerPath = '.agents/skills/local-tool-router/scripts/detect-local-tools.ps1',
    [switch]$ProbeVersions,
    [ValidateRange(1, 120)]
    [int]$ProbeTimeoutSeconds = 5
)

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$resolvedScanner = if ([IO.Path]::IsPathRooted($ScannerPath)) {
    (Resolve-Path -LiteralPath $ScannerPath).Path
} else {
    (Resolve-Path -LiteralPath (Join-Path $repoRoot $ScannerPath)).Path
}

$json = if ($ProbeVersions) {
    & $resolvedScanner -Compact -ProbeVersions -ProbeTimeoutSeconds $ProbeTimeoutSeconds
} else {
    & $resolvedScanner -Compact -ProbeTimeoutSeconds $ProbeTimeoutSeconds
}
$report = $json | ConvertFrom-Json

if ($report.schema_version -ne 1) { throw 'Expected schema_version 1.' }
if (-not $report.scanned_at) { throw 'Missing scanned_at timestamp.' }
if ($report.scan_mode -notin @('discovery', 'bounded-probe')) { throw "Invalid scan_mode: $($report.scan_mode)" }
if (-not $report.host.os) { throw 'Missing host.os.' }
if (@($report.tools).Count -lt 20) { throw 'Capability report contains too few tool candidates.' }

$validStatuses = @('available', 'unavailable', 'unverified')
$ids = @{}
foreach ($tool in $report.tools) {
    if (-not $tool.id -or -not $tool.name) { throw 'Every tool requires id and name.' }
    if ($validStatuses -notcontains $tool.status) { throw "Invalid status '$($tool.status)' for $($tool.id)." }
    if ($ids.ContainsKey($tool.id)) { throw "Duplicate tool id: $($tool.id)" }
    $ids[$tool.id] = $true
    if ($tool.status -eq 'unavailable' -and $tool.available) {
        throw "Unavailable tool has legacy available=true: $($tool.id)"
    }
}

foreach ($requiredId in @('matlab', 'octave', 'wolframscript', 'python', 'git', 'xelatex', 'biber', 'makeindex', 'ffmpeg', 'imagemagick', 'graphviz', 'docker')) {
    if (-not $ids.ContainsKey($requiredId)) { throw "Missing required tool candidate: $requiredId" }
}

$serialized = $report | ConvertTo-Json -Depth 10
if ($serialized -match '(?i)(api[_-]?key|access[_-]?token|client[_-]?secret|password)') {
    throw 'Capability report appears to contain a secret-bearing field.'
}

$cachePath = [IO.Path]::GetTempFileName()
try {
    $cacheOutput = & $resolvedScanner -Compact -Tool git -OutputPath $cachePath -ProbeTimeoutSeconds $ProbeTimeoutSeconds
    $cacheReport = Get-Content -Raw -LiteralPath $cachePath | ConvertFrom-Json
    if ($cacheReport.schema_version -ne 1 -or $cacheReport.tools[0].id -ne 'git') {
        throw 'Cache output does not match the capability schema.'
    }
    if (($cacheOutput | ConvertFrom-Json).scanned_at -ne $cacheReport.scanned_at) {
        throw 'Cache file and standard output differ.'
    }
} finally {
    if (Test-Path -LiteralPath $cachePath) { [IO.File]::Delete($cachePath) }
}

$gitignorePath = Join-Path $repoRoot '.gitignore'
if (-not (Select-String -LiteralPath $gitignorePath -SimpleMatch '.tool-capabilities.json' -Quiet)) {
    throw '.tool-capabilities.json is not ignored by Git.'
}

Write-Output "Capability schema and cache tests passed for $(@($report.tools).Count) tools in $($report.scan_mode) mode."
