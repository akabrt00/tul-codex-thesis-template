[CmdletBinding()]
param(
    [int]$ProbeTimeoutSeconds = 10,
    [ValidateSet('All', 'Semester')][string]$DocumentKind = 'All'
)

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$results = @()

function Add-Result {
    param([string]$Component, [bool]$Available, [string]$Detail, [string]$Remedy, [bool]$Required = $true)
    $script:results += [pscustomobject]@{
        Component = $Component
        Status = if ($Available) { 'OK' } elseif ($Required) { 'MISSING' } else { 'OPTIONAL' }
        Detail = $Detail
        Remedy = if ($Available) { '' } else { $Remedy }
        Required = $Required
    }
}

function Test-CommandProbe {
    param([string]$Name, [string[]]$Arguments)
    $command = Get-Command -Name $Name -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1
    if (-not $command) { return [pscustomobject]@{ ok = $false; detail = 'command not found' } }
    $psi = New-Object Diagnostics.ProcessStartInfo
    $psi.FileName = $command.Source
    $psi.Arguments = ($Arguments | ForEach-Object { if ($_ -match '\s') { '"' + ($_ -replace '"','\"') + '"' } else { $_ } }) -join ' '
    $psi.UseShellExecute = $false
    $psi.CreateNoWindow = $true
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    $process = New-Object Diagnostics.Process
    $process.StartInfo = $psi
    [void]$process.Start()
    $stdoutTask = $process.StandardOutput.ReadToEndAsync()
    $stderrTask = $process.StandardError.ReadToEndAsync()
    if (-not $process.WaitForExit($ProbeTimeoutSeconds * 1000)) {
        try { $process.Kill() } catch {}
        return [pscustomobject]@{ ok = $false; detail = "found at $($command.Source), but probe timed out" }
    }
    $text = (($stdoutTask.Result + "`n" + $stderrTask.Result) -split '\r?\n' | Where-Object { $_ } | Select-Object -First 1) -join ' '
    return [pscustomobject]@{ ok = ($process.ExitCode -eq 0); detail = "$($command.Source) - $text" }
}

if ($DocumentKind -eq 'Semester') {
    foreach ($tool in @('pdflatex','bibtex')) {
        $probe = Test-CommandProbe -Name $tool -Arguments @('--version')
        Add-Result $tool $probe.ok $probe.detail "Provide the $tool executable through your existing TeX distribution."
    }
    foreach ($package in @('babel.sty','lmodern.sty','geometry.sty','fancyhdr.sty','lastpage.sty','amsmath.sty')) {
        $probe = Test-CommandProbe -Name 'kpsewhich' -Arguments @($package)
        Add-Result $package $probe.ok $probe.detail "Provide $package through your existing TeX distribution."
    }
    $style = Join-Path $repoRoot 'templates\community\tul-semestralni-1.1\tul-semestralni.sty'
    Add-Result 'Semester style' (Test-Path -LiteralPath $style) 'Bundled semester 1.1' 'Restore the verified community snapshot.'
    $results | Format-Table -AutoSize -Wrap
    if (@($results | Where-Object { $_.Required -and $_.Status -eq 'MISSING' }).Count -gt 0) { exit 1 }
    Write-Output 'Semester build tools are ready. Use validate-deliverable.ps1 for PDF checks.'
    exit 0
}

$xelatex = Test-CommandProbe -Name 'xelatex' -Arguments @('--version')
Add-Result 'XeLaTeX' $xelatex.ok $xelatex.detail 'Install XeTeX/XeLaTeX through MiKTeX Console or a full TeX Live distribution, then reopen the shell.'

$biber = Test-CommandProbe -Name 'biber' -Arguments @('--version')
Add-Result 'Biber' $biber.ok $biber.detail 'Install or repair the Biber package matching the installed BibLaTeX version (MiKTeX Console > Packages > biber), then run the probe again.'

$makeindexCommand = Get-Command -Name 'makeindex' -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1
Add-Result 'MakeIndex' ([bool]$makeindexCommand) ($(if($makeindexCommand){$makeindexCommand.Source}else{'command not found'})) 'Install the MakeIndex executable through MiKTeX Console or TeX Live.'

$beamerProbe = Test-CommandProbe -Name 'kpsewhich' -Arguments @('beamer.cls')
Add-Result 'Beamer class' $beamerProbe.ok $beamerProbe.detail 'Install the LaTeX Beamer package (MiKTeX Console > Packages > beamer, or TeX Live package collection-latexrecommended).'

$thesisClass = Join-Path $repoRoot 'templates\upstream\TUL\TULthesis\tulthesis.cls'
$tulStyle = Join-Path $repoRoot 'templates\upstream\TUL\TULthesis\tul.sty'
$presentationClass = Join-Path $repoRoot 'templates\upstream\TUL\TULpresentation\tulpresentation.cls'
Add-Result 'TULthesis class' ((Test-Path -LiteralPath $thesisClass) -and (Test-Path -LiteralPath $tulStyle)) "$thesisClass; $tulStyle" 'Restore templates/upstream/TUL/TULthesis from the verified upstream package.'
Add-Result 'TULpresentation class' (Test-Path -LiteralPath $presentationClass) $presentationClass 'Restore templates/upstream/TUL/TULpresentation from the verified upstream package.'

$fontProperties = @()
foreach ($registryPath in @('HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts','HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts')) {
    if (Test-Path $registryPath) {
        $fontProperties += (Get-ItemProperty -Path $registryPath).PSObject.Properties | Where-Object { $_.Name -notmatch '^PS' } | ForEach-Object { "$($_.Name) $($_.Value)" }
    }
}
$fontText = $fontProperties -join "`n"
$interAvailable = $fontText -match '(?im)\bInter\b'
$notoAvailable = $fontText -match '(?im)Noto Sans Mono'
$localTulFonts = @(
    Join-Path $repoRoot 'templates\upstream\TUL\TULpresentation\TULMono-Bold.otf'
    Join-Path $repoRoot 'templates\upstream\TUL\TULthesis\TULMono-Bold.ttf'
)
$tulFontsAvailable = @($localTulFonts | Where-Object { Test-Path -LiteralPath $_ }).Count -eq $localTulFonts.Count
Add-Result 'Inter font' $interAvailable ($(if($interAvailable){'registered system font'}else{'not found in Windows font registry'})) 'Install the Inter font family from its official distribution; TULpresentation requires it through fontspec.'
Add-Result 'Noto Sans Mono font' $notoAvailable ($(if($notoAvailable){'registered system font'}else{'not found in Windows font registry'})) 'Install Noto Sans Mono when using the TUL font option in tul.sty.'
Add-Result 'Bundled TUL Mono fonts' $tulFontsAvailable ($localTulFonts -join '; ') 'Restore the local TULMono font files from the verified upstream packages.'

$pdfInfoProbe = Test-CommandProbe -Name 'pdfinfo' -Arguments @('-v')
$pdfTextProbe = Test-CommandProbe -Name 'pdftotext' -Arguments @('-v')
$pythonPdfProbe = Test-CommandProbe -Name 'python' -Arguments @('-c', 'import pypdf; print(pypdf.__version__)')
$pdfBackendAvailable = ($pdfInfoProbe.ok -and $pdfTextProbe.ok) -or $pythonPdfProbe.ok
Add-Result 'PDF page tools' $pdfBackendAvailable "pdfinfo: $($pdfInfoProbe.detail); pdftotext: $($pdfTextProbe.detail); Python/pypdf: $($pythonPdfProbe.detail)" 'Install Poppler (pdfinfo + pdftotext) and put it on PATH, or install Python and run: python -m pip install pypdf.'

$qpdfProbe = Test-CommandProbe -Name 'qpdf' -Arguments @('--version')
Add-Result 'qpdf PDF validator' $qpdfProbe.ok $qpdfProbe.detail 'Optional: install qpdf for an additional structural PDF check. The deliverable preflight will report this check as unavailable and continue with its fallback.' $false

$pdfFontsProbe = Test-CommandProbe -Name 'pdffonts' -Arguments @('-v')
Add-Result 'pdffonts embedding check' $pdfFontsProbe.ok $pdfFontsProbe.detail 'Optional: install Poppler pdffonts to verify that output fonts are embedded. The deliverable preflight will mark this check unavailable when missing.' $false

$results | Format-Table -AutoSize -Wrap
$missing = @($results | Where-Object { $_.Required -and $_.Status -eq 'MISSING' })
if ($missing.Count -gt 0) {
    Write-Output "`nRemediation required:"
    $missing | ForEach-Object { Write-Output "- $($_.Component): $($_.Remedy)" }
    exit 1
}
Write-Output "`nEnvironment is ready."
