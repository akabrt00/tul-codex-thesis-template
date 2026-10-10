[CmdletBinding()]
param(
    [switch]$Compact,
    [switch]$ProbeVersions,
    [switch]$ProbeMatlab,
    [switch]$IncludeMatlabToolboxes,
    [string[]]$Tool,
    [ValidateRange(1, 120)]
    [int]$ProbeTimeoutSeconds = 20,
    [string]$OutputPath
)

$ErrorActionPreference = 'Stop'

if ($IncludeMatlabToolboxes -and -not $ProbeMatlab) {
    throw '-IncludeMatlabToolboxes requires -ProbeMatlab.'
}

if ($Tool) {
    $Tool = @($Tool | ForEach-Object { $_ -split ',' } | ForEach-Object { $_.Trim().ToLowerInvariant() } | Where-Object { $_ })
}

$candidates = @(
    @{ Id = 'matlab'; Name = 'MATLAB'; Commands = @('matlab'); ProbeArguments = $null },
    @{ Id = 'octave'; Name = 'GNU Octave'; Commands = @('octave-cli', 'octave'); ProbeArguments = @{ default = @('--version') } },
    @{ Id = 'wolframscript'; Name = 'Wolfram Script'; Commands = @('wolframscript'); ProbeArguments = $null },
    @{ Id = 'mathematica'; Name = 'Mathematica or Wolfram Kernel'; Commands = @('WolframKernel', 'math', 'Mathematica'); ProbeArguments = $null },
    @{ Id = 'python-launcher'; Name = 'Python launcher'; Commands = @('py'); ProbeArguments = @{ default = @('--version') } },
    @{ Id = 'python'; Name = 'Python'; Commands = @('python3', 'python'); ProbeArguments = @{ default = @('--version') } },
    @{ Id = 'git'; Name = 'Git'; Commands = @('git'); ProbeArguments = @{ default = @('--version') } },
    @{ Id = 'node'; Name = 'Node.js'; Commands = @('node'); ProbeArguments = @{ default = @('--version') } },
    @{ Id = 'npm'; Name = 'npm'; Commands = @('npm.cmd', 'npm'); ProbeArguments = @{ default = @('--version') } },
    @{ Id = 'dotnet'; Name = '.NET'; Commands = @('dotnet'); ProbeArguments = @{ default = @('--version') } },
    @{ Id = 'r'; Name = 'R'; Commands = @('Rscript'); ProbeArguments = @{ default = @('--version') } },
    @{ Id = 'julia'; Name = 'Julia'; Commands = @('julia'); ProbeArguments = @{ default = @('--version') } },
    @{ Id = 'java'; Name = 'Java'; Commands = @('java'); ProbeArguments = @{ default = @('--version') } },
    @{ Id = 'cmake'; Name = 'CMake'; Commands = @('cmake'); ProbeArguments = @{ default = @('--version') } },
    @{ Id = 'cpp-compiler'; Name = 'C/C++ compiler'; Commands = @('clang', 'gcc', 'cl'); ProbeArguments = @{ clang = @('--version'); gcc = @('--version') } },
    @{ Id = 'pandoc'; Name = 'Pandoc'; Commands = @('pandoc'); ProbeArguments = @{ default = @('--version') } },
    @{ Id = 'latexmk'; Name = 'LaTeXmk'; Commands = @('latexmk'); ProbeArguments = @{ default = @('-v') } },
    @{ Id = 'xelatex'; Name = 'XeLaTeX'; Commands = @('xelatex'); ProbeArguments = @{ default = @('--version') } },
    @{ Id = 'pdflatex'; Name = 'pdfLaTeX'; Commands = @('pdflatex'); ProbeArguments = @{ default = @('--version') } },
    @{ Id = 'bibtex'; Name = 'BibTeX'; Commands = @('bibtex'); ProbeArguments = @{ default = @('--version') } },
    @{ Id = 'biber'; Name = 'Biber'; Commands = @('biber'); ProbeArguments = @{ default = @('--version') } },
    @{ Id = 'makeindex'; Name = 'MakeIndex'; Commands = @('makeindex'); ProbeArguments = @{ default = @('--version') } },
    @{ Id = 'ffmpeg'; Name = 'FFmpeg'; Commands = @('ffmpeg'); ProbeArguments = @{ default = @('-version') } },
    @{ Id = 'ffprobe'; Name = 'FFprobe'; Commands = @('ffprobe'); ProbeArguments = @{ default = @('-version') } },
    @{ Id = 'imagemagick'; Name = 'ImageMagick'; Commands = @('magick'); ProbeArguments = @{ default = @('-version') } },
    @{ Id = 'graphviz'; Name = 'Graphviz'; Commands = @('dot'); ProbeArguments = @{ default = @('-V') } },
    @{ Id = 'docker'; Name = 'Docker CLI'; Commands = @('docker'); ProbeArguments = @{ default = @('--version') } }
)

if ($Tool) {
    $knownIds = @($candidates | ForEach-Object { $_.Id })
    $unknownIds = @($Tool | Where-Object { $knownIds -notcontains $_ })
    if ($unknownIds.Count -gt 0) { throw "Unknown tool id: $($unknownIds -join ', ')" }
    $candidates = @($candidates | Where-Object { $Tool -contains $_.Id })
}

function Resolve-ToolCommand {
    param([string[]]$Names)

    foreach ($commandName in $Names) {
        $resolved = Get-Command -Name $commandName -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($resolved) { return $resolved }
    }
    return $null
}

function ConvertTo-ProcessArgumentString {
    param([string[]]$Arguments)

    return (($Arguments | ForEach-Object {
        if ($_ -notmatch '[\s"]') { $_ }
        else { '"' + ($_ -replace '([\\]*)"', '$1$1\"' -replace '(\\+)$', '$1$1') + '"' }
    }) -join ' ')
}

function Invoke-BoundedProbe {
    param(
        [string]$FilePath,
        [string[]]$Arguments,
        [int]$TimeoutSeconds,
        [int]$MaxOutputCharacters = 500
    )

    $stopwatch = [Diagnostics.Stopwatch]::StartNew()
    $psi = New-Object Diagnostics.ProcessStartInfo
    $psi.FileName = $FilePath
    $psi.Arguments = ConvertTo-ProcessArgumentString -Arguments $Arguments
    $psi.UseShellExecute = $false
    $psi.CreateNoWindow = $true
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true

    $process = New-Object Diagnostics.Process
    $process.StartInfo = $psi
    try {
        [void]$process.Start()
        $stdoutTask = $process.StandardOutput.ReadToEndAsync()
        $stderrTask = $process.StandardError.ReadToEndAsync()
        if (-not $process.WaitForExit($TimeoutSeconds * 1000)) {
            try { $process.Kill() } catch {}
            $stopwatch.Stop()
            return [pscustomobject]@{
                status = 'timeout'; exit_code = $null; duration_ms = $stopwatch.ElapsedMilliseconds
                output = "probe timed out after $TimeoutSeconds seconds"
            }
        }
        $stopwatch.Stop()
        $combined = (($stdoutTask.Result + "`n" + $stderrTask.Result) -split '\r?\n' | Where-Object { $_ } | Select-Object -First 4) -join ' | '
        if ($combined.Length -gt $MaxOutputCharacters) { $combined = $combined.Substring(0, $MaxOutputCharacters) }
        return [pscustomobject]@{
            status = if ($process.ExitCode -eq 0) { 'success' } else { 'failed' }
            exit_code = $process.ExitCode
            duration_ms = $stopwatch.ElapsedMilliseconds
            output = $combined
        }
    } catch {
        $stopwatch.Stop()
        return [pscustomobject]@{
            status = 'failed'; exit_code = $null; duration_ms = $stopwatch.ElapsedMilliseconds
            output = $_.Exception.Message
        }
    } finally {
        $process.Dispose()
    }
}

function Get-ProbeArguments {
    param($Candidate, [string]$ResolvedName)

    if (-not $Candidate.ProbeArguments) { return $null }
    $baseName = [IO.Path]::GetFileNameWithoutExtension($ResolvedName).ToLowerInvariant()
    if ($Candidate.ProbeArguments.ContainsKey($baseName)) { return [string[]]$Candidate.ProbeArguments[$baseName] }
    if ($Candidate.ProbeArguments.ContainsKey('default')) { return [string[]]$Candidate.ProbeArguments.default }
    return $null
}

$results = foreach ($candidate in $candidates) {
    $resolved = Resolve-ToolCommand -Names $candidate.Commands
    $status = if ($resolved) { 'unverified' } else { 'unavailable' }
    $probe = $null
    $details = $null

    if ($resolved -and $candidate.Id -eq 'matlab' -and $ProbeMatlab) {
        $matlabExpression = if ($IncludeMatlabToolboxes) {
            "s=ver; fprintf('CODEX_CAPABILITY_JSON=%s\n', jsonencode(struct('version',version,'release',version('-release'),'toolboxes',{string({s.Name})})));"
        } else {
            "fprintf('CODEX_CAPABILITY_JSON=%s\n', jsonencode(struct('version',version,'release',version('-release'))));"
        }
        $probe = Invoke-BoundedProbe -FilePath $resolved.Source -Arguments @('-batch', $matlabExpression) -TimeoutSeconds $ProbeTimeoutSeconds -MaxOutputCharacters 20000
        if ($probe.status -eq 'success') {
            $status = 'available'
            $marker = (($probe.output -split ' \| ') | Where-Object { $_ -like 'CODEX_CAPABILITY_JSON=*' } | Select-Object -First 1)
            if ($marker) {
                try { $details = $marker.Substring('CODEX_CAPABILITY_JSON='.Length) | ConvertFrom-Json } catch {}
            }
            if (-not $details) { $details = [ordered]@{ license_session_usable = $true } }
            else { $details | Add-Member -NotePropertyName license_session_usable -NotePropertyValue $true -Force }
        }
    } elseif ($resolved -and $ProbeVersions) {
        $probeArguments = Get-ProbeArguments -Candidate $candidate -ResolvedName $resolved.Name
        if ($null -ne $probeArguments) {
            $probe = Invoke-BoundedProbe -FilePath $resolved.Source -Arguments $probeArguments -TimeoutSeconds $ProbeTimeoutSeconds
            if ($probe.status -eq 'success') { $status = 'available' }
        }
    }

    [pscustomobject]@{
        id        = $candidate.Id
        name      = $candidate.Name
        status    = $status
        available = [bool]$resolved
        command   = if ($resolved) { $resolved.Name } else { $null }
        path      = if ($resolved) { $resolved.Source } else { $null }
        probe     = $probe
        details   = $details
    }
}

$report = [ordered]@{
    schema_version = 1
    scanned_at = (Get-Date).ToString('o')
    scan_mode = if ($ProbeMatlab -or $ProbeVersions) { 'bounded-probe' } else { 'discovery' }
    host = [ordered]@{
        os = [System.Environment]::OSVersion.VersionString
        architecture = [System.Environment]::GetEnvironmentVariable('PROCESSOR_ARCHITECTURE')
        powershell = $PSVersionTable.PSVersion.ToString()
    }
    tools = @($results)
}

$json = if ($Compact) { $report | ConvertTo-Json -Depth 8 -Compress } else { $report | ConvertTo-Json -Depth 8 }

if ($OutputPath) {
    $fullOutputPath = if ([IO.Path]::IsPathRooted($OutputPath)) {
        [IO.Path]::GetFullPath($OutputPath)
    } else {
        [IO.Path]::GetFullPath((Join-Path (Get-Location) $OutputPath))
    }
    $parentDirectory = Split-Path -Parent $fullOutputPath
    if (-not (Test-Path -LiteralPath $parentDirectory)) {
        [void](New-Item -ItemType Directory -Path $parentDirectory -Force)
    }
    $utf8NoBom = New-Object Text.UTF8Encoding($false)
    [IO.File]::WriteAllText($fullOutputPath, $json + [Environment]::NewLine, $utf8NoBom)
}

Write-Output $json
