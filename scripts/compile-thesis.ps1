[CmdletBinding()]
param(
    [string]$ProjectDir,
    [string]$MainTex = 'main.tex',
    [switch]$Clean,
    [int]$StepTimeoutSeconds = 120,
    [ValidateSet('Auto', 'Thesis', 'Semester')]
    [string]$DocumentKind = 'Auto'
)

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
if (-not $ProjectDir) { $ProjectDir = Join-Path $repoRoot 'prace' }
$projectPath = (Resolve-Path -LiteralPath $ProjectDir).Path
$upstreamPath = (Resolve-Path (Join-Path $repoRoot 'templates\upstream')).Path
if ($projectPath.StartsWith($upstreamPath, [StringComparison]::OrdinalIgnoreCase)) {
    throw 'Refusing to compile inside templates/upstream.'
}
$communityPath = [IO.Path]::GetFullPath((Join-Path $repoRoot 'templates\community'))
if ($projectPath.StartsWith($communityPath, [StringComparison]::OrdinalIgnoreCase)) { throw 'Refusing to compile inside templates/community.' }

$mainPath = (Resolve-Path -LiteralPath (Join-Path $projectPath $MainTex)).Path
if (-not $mainPath.StartsWith($projectPath + [IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase)) {
    throw 'MainTex must resolve inside ProjectDir.'
}
$jobName = [IO.Path]::GetFileNameWithoutExtension($mainPath)
$mainText = Get-Content -Raw -Encoding UTF8 -LiteralPath $mainPath
if ($DocumentKind -eq 'Auto') {
    $DocumentKind = if ($mainText -match '\\usepackage(?:\[[^\]]*\])?\{tul-semestralni\}') { 'Semester' } else { 'Thesis' }
}

$auxiliarySuffixes = @('aux','bbl','bcf','blg','idx','ilg','ind','lof','log','lot','out','run.xml','toc','synctex.gz','fls','fdb_latexmk','xdv')
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
    param([string]$Name, [string]$Command, [string[]]$Arguments)
    $commandInfo = Get-Command -Name $Command -CommandType Application -ErrorAction Stop | Select-Object -First 1
    if ($Command -in @('xelatex','pdflatex','bibtex') -and $commandInfo.Source -match '(?i)miktex') {
        $Arguments = @('--disable-installer') + $Arguments
    }
    $stdout = Join-Path $logDir "$Name.stdout.log"
    $stderr = Join-Path $logDir "$Name.stderr.log"
    $psi = New-Object Diagnostics.ProcessStartInfo
    $psi.FileName = $commandInfo.Source
    $psi.Arguments = ($Arguments | ForEach-Object { if ($_ -match '\s') { '"' + ($_ -replace '"','\"') + '"' } else { $_ } }) -join ' '
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
    if ($process.ExitCode -ne 0) {
        throw "$Name failed with exit code $($process.ExitCode). See $logDir."
    }
    Write-Output "$Name passed."
}

$xelatexArgs = @('-interaction=nonstopmode','-halt-on-error','-file-line-error',[IO.Path]::GetFileName($mainPath))
if ($DocumentKind -eq 'Semester') {
    $titleCount = @([regex]::Matches(($mainText -replace '(?m)%.*$', ''), '\\TitulniStrana\b')).Count
    if ($titleCount -ne 1) { throw 'Semester document must contain exactly one active TitulniStrana command.' }
    Invoke-BuildStep -Name '01-pdflatex' -Command 'pdflatex' -Arguments $xelatexArgs
    $auxText = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $projectPath "$jobName.aux")
    if ($auxText -match '\\bibdata\{' -and $auxText -match '\\citation\{') {
        Invoke-BuildStep -Name '02-bibtex' -Command 'bibtex' -Arguments @($jobName)
    } else {
        Write-Output 'BibTeX skipped: no active bibliography with citations. A starter without sources is not submission-ready.'
    }
    Invoke-BuildStep -Name '03-pdflatex' -Command 'pdflatex' -Arguments $xelatexArgs
    Invoke-BuildStep -Name '04-pdflatex' -Command 'pdflatex' -Arguments $xelatexArgs
    $semesterPdf = Join-Path $projectPath "$jobName.pdf"
    if (-not (Test-Path -LiteralPath $semesterPdf)) { throw 'Semester build did not produce a PDF.' }
    Write-Output "Semester build completed: $semesterPdf"
    return
}
Invoke-BuildStep -Name '01-xelatex' -Command 'xelatex' -Arguments $xelatexArgs

$bcf = Join-Path $projectPath "$jobName.bcf"
if (-not (Test-Path -LiteralPath $bcf)) { throw 'XeLaTeX did not create a .bcf file required by the mandated Biber stage.' }
Invoke-BuildStep -Name '02-biber' -Command 'biber' -Arguments @($jobName)

$idx = Join-Path $projectPath "$jobName.idx"
if (-not (Test-Path -LiteralPath $idx)) { New-Item -ItemType File -Path $idx | Out-Null }
Invoke-BuildStep -Name '03-makeindex' -Command 'makeindex' -Arguments @("$jobName.idx")
Invoke-BuildStep -Name '04-xelatex' -Command 'xelatex' -Arguments $xelatexArgs
Invoke-BuildStep -Name '05-xelatex' -Command 'xelatex' -Arguments $xelatexArgs

$outputPdf = Join-Path $projectPath "$jobName.pdf"
if (-not (Test-Path -LiteralPath $outputPdf)) { throw 'Build sequence completed without producing the expected PDF.' }
Write-Output "Thesis build completed: $outputPdf"
