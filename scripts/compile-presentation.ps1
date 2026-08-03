[CmdletBinding()]
param(
    [string]$ProjectDir,
    [string]$MainTex = 'main.tex',
    [switch]$Clean,
    [int]$StepTimeoutSeconds = 120
)

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
if (-not $ProjectDir) { $ProjectDir = Join-Path $repoRoot 'obhajoba' }
$projectPath = (Resolve-Path -LiteralPath $ProjectDir).Path
$upstreamPath = (Resolve-Path (Join-Path $repoRoot 'templates\upstream')).Path
if ($projectPath.StartsWith($upstreamPath, [StringComparison]::OrdinalIgnoreCase)) {
    throw 'Refusing to compile inside templates/upstream.'
}
$mainPath = (Resolve-Path -LiteralPath (Join-Path $projectPath $MainTex)).Path
if (-not $mainPath.StartsWith($projectPath + [IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase)) {
    throw 'MainTex must resolve inside ProjectDir.'
}
$jobName = [IO.Path]::GetFileNameWithoutExtension($mainPath)

$auxiliarySuffixes = @('aux','log','nav','out','snm','toc','vrb','synctex.gz','fls','fdb_latexmk','xdv')
if ($Clean) {
    foreach ($suffix in $auxiliarySuffixes) {
        $candidate = Join-Path $projectPath "$jobName.$suffix"
        if (Test-Path -LiteralPath $candidate) { Remove-Item -LiteralPath $candidate -Force }
    }
    $pdf = Join-Path $projectPath "$jobName.pdf"
    if (Test-Path -LiteralPath $pdf) { Remove-Item -LiteralPath $pdf -Force }
    $oldLogs = Join-Path $projectPath '.build-logs'
    if (Test-Path -LiteralPath $oldLogs) { Remove-Item -LiteralPath $oldLogs -Recurse -Force }
}

$logDir = Join-Path $projectPath '.build-logs'
New-Item -ItemType Directory -Path $logDir -Force | Out-Null

function Invoke-BuildStep {
    param([string]$Name)
    $commandInfo = Get-Command -Name 'xelatex' -CommandType Application -ErrorAction Stop | Select-Object -First 1
    $stdout = Join-Path $logDir "$Name.stdout.log"
    $stderr = Join-Path $logDir "$Name.stderr.log"
    $arguments = @('-interaction=nonstopmode','-halt-on-error','-file-line-error',[IO.Path]::GetFileName($mainPath))
    $psi = New-Object Diagnostics.ProcessStartInfo
    $psi.FileName = $commandInfo.Source
    $psi.Arguments = ($arguments | ForEach-Object { if ($_ -match '\s') { '"' + ($_ -replace '"','\"') + '"' } else { $_ } }) -join ' '
    $psi.WorkingDirectory = $projectPath
    $psi.UseShellExecute = $false
    $psi.CreateNoWindow = $true
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    $process = New-Object Diagnostics.Process
    $process.StartInfo = $psi
    [void]$process.Start()
    $stdoutTask = $process.StandardOutput.ReadToEndAsync()
    $stderrTask = $process.StandardError.ReadToEndAsync()
    if (-not $process.WaitForExit($StepTimeoutSeconds * 1000)) {
        try { $process.Kill() } catch {}
        $stdoutTask.Result | Set-Content -LiteralPath $stdout -Encoding UTF8
        $stderrTask.Result | Set-Content -LiteralPath $stderr -Encoding UTF8
        throw "$Name timed out after $StepTimeoutSeconds seconds. See $logDir."
    }
    $stdoutTask.Result | Set-Content -LiteralPath $stdout -Encoding UTF8
    $stderrTask.Result | Set-Content -LiteralPath $stderr -Encoding UTF8
    if ($process.ExitCode -ne 0) { throw "$Name failed with exit code $($process.ExitCode). See $logDir." }
    Write-Output "$Name passed."
}

Invoke-BuildStep -Name '01-xelatex'
Invoke-BuildStep -Name '02-xelatex'
$outputPdf = Join-Path $projectPath "$jobName.pdf"
if (-not (Test-Path -LiteralPath $outputPdf)) { throw 'Build sequence completed without producing the expected PDF.' }
Write-Output "Presentation build completed: $outputPdf"
