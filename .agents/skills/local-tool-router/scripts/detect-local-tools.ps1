[CmdletBinding()]
param(
    [switch]$Compact
)

$candidates = @(
    @{ Name = 'MATLAB'; Commands = @('matlab') },
    @{ Name = 'Python launcher'; Commands = @('py') },
    @{ Name = 'Python'; Commands = @('python', 'python3') },
    @{ Name = 'Git'; Commands = @('git') },
    @{ Name = 'Node.js'; Commands = @('node') },
    @{ Name = 'npm'; Commands = @('npm') },
    @{ Name = '.NET'; Commands = @('dotnet') },
    @{ Name = 'R'; Commands = @('Rscript') },
    @{ Name = 'Julia'; Commands = @('julia') },
    @{ Name = 'Java'; Commands = @('java') },
    @{ Name = 'CMake'; Commands = @('cmake') },
    @{ Name = 'C/C++ compiler'; Commands = @('clang', 'gcc', 'cl') },
    @{ Name = 'Pandoc'; Commands = @('pandoc') },
    @{ Name = 'LaTeX'; Commands = @('latexmk', 'pdflatex', 'xelatex') },
    @{ Name = 'FFmpeg'; Commands = @('ffmpeg') },
    @{ Name = 'Docker'; Commands = @('docker') }
)

$results = foreach ($candidate in $candidates) {
    $resolved = $null
    foreach ($commandName in $candidate.Commands) {
        $resolved = Get-Command -Name $commandName -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($resolved) { break }
    }

    [pscustomobject]@{
        name      = $candidate.Name
        available = [bool]$resolved
        command   = if ($resolved) { $resolved.Name } else { $null }
        path      = if ($resolved) { $resolved.Source } else { $null }
    }
}

$report = [ordered]@{
    scanned_at = (Get-Date).ToString('o')
    host       = [ordered]@{
        os         = [System.Environment]::OSVersion.VersionString
        powershell = $PSVersionTable.PSVersion.ToString()
    }
    tools      = $results
}

if ($Compact) {
    $report | ConvertTo-Json -Depth 4 -Compress
} else {
    $report | ConvertTo-Json -Depth 4
}
