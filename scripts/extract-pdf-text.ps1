[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$InputPdf,
    [string]$OutputDirectory,
    [string]$SourceId,
    [string]$CitationKey,
    [string]$PdfInfoPath,
    [string]$PdfToTextPath,
    [string]$PythonPath,
    [switch]$Force
)

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$sourceRoot = (Resolve-Path (Join-Path $repoRoot 'zdroje')).Path
$inputPath = (Resolve-Path -LiteralPath $InputPdf).Path
if ([IO.Path]::GetExtension($inputPath) -ne '.pdf') { throw 'InputPdf must be a PDF file.' }
if (-not $inputPath.StartsWith($sourceRoot + [IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase)) {
    throw 'Expert PDF extraction accepts input only from zdroje/.'
}

if (-not $CitationKey) { $CitationKey = [IO.Path]::GetFileNameWithoutExtension($inputPath) }
if (-not $OutputDirectory) {
    $OutputDirectory = Join-Path $sourceRoot (Join-Path '90_zpracovane\extrahovany-text' $CitationKey)
}
$templatesRoot = (Resolve-Path (Join-Path $repoRoot 'templates')).Path
if (Test-Path -LiteralPath $OutputDirectory) {
    $outputPath = (Resolve-Path -LiteralPath $OutputDirectory).Path
} else {
    New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null
    $outputPath = (Resolve-Path -LiteralPath $OutputDirectory).Path
}
if ($outputPath.StartsWith($templatesRoot, [StringComparison]::OrdinalIgnoreCase)) { throw 'OutputDirectory must not be inside templates/.' }
$existing = @(Get-ChildItem -LiteralPath $outputPath -Force -File)
if ($existing.Count -gt 0 -and -not $Force) { throw 'OutputDirectory contains files. Use -Force only to overwrite matching extraction outputs.' }

$pdfInfoCommand = if ($PdfInfoPath) { Get-Item -LiteralPath $PdfInfoPath -ErrorAction Stop } else { Get-Command pdfinfo -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1 }
$pdfToTextCommand = if ($PdfToTextPath) { Get-Item -LiteralPath $PdfToTextPath -ErrorAction Stop } else { Get-Command pdftotext -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1 }
$pythonCommand = if ($PythonPath) { Get-Item -LiteralPath $PythonPath -ErrorAction Stop } else { Get-Command python,py -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1 }

if ($PythonPath -and $pythonCommand) {
    $pythonExecutable = $pythonCommand.Source
    if (-not $pythonExecutable) { $pythonExecutable = $pythonCommand.FullName }
    & $pythonExecutable -c 'import pypdf' 2>$null
    if ($LASTEXITCODE -ne 0) { throw 'Python was found, but pypdf is unavailable. Install it with: python -m pip install pypdf' }
    $helper = Join-Path $PSScriptRoot 'extract-pdf-pages.py'
    $pageCountText = & $pythonExecutable $helper $inputPath $outputPath
    if ($LASTEXITCODE -ne 0 -or $pageCountText -notmatch '^\d+$') { throw 'Python/pypdf extraction failed.' }
    $pageCount = [int]$pageCountText
    $extractionEngine = "$pythonExecutable + pypdf"
} elseif ($pdfInfoCommand -and $pdfToTextCommand) {
    $pdfInfoExecutable = $pdfInfoCommand.Source
    if (-not $pdfInfoExecutable) { $pdfInfoExecutable = $pdfInfoCommand.FullName }
    $pdfToTextExecutable = $pdfToTextCommand.Source
    if (-not $pdfToTextExecutable) { $pdfToTextExecutable = $pdfToTextCommand.FullName }
    $info = & $pdfInfoExecutable $inputPath
    if ($LASTEXITCODE -ne 0) { throw 'pdfinfo failed.' }
    $pagesLine = $info | Where-Object { $_ -match '^Pages:\s+(\d+)' } | Select-Object -First 1
    if (-not $pagesLine -or $pagesLine -notmatch '^Pages:\s+(\d+)') { throw 'Unable to determine PDF page count.' }
    $pageCount = [int]$Matches[1]
    for ($page = 1; $page -le $pageCount; $page++) {
        $pageFile = Join-Path $outputPath ('page-{0:D4}.txt' -f $page)
        & $pdfToTextExecutable -f $page -l $page -layout -enc UTF-8 $inputPath $pageFile
        if ($LASTEXITCODE -ne 0 -or -not (Test-Path -LiteralPath $pageFile)) { throw "pdftotext failed on page $page." }
    }
    $extractionEngine = $pdfToTextExecutable
} elseif ($pythonCommand) {
    $pythonExecutable = $pythonCommand.Source
    if (-not $pythonExecutable) { $pythonExecutable = $pythonCommand.FullName }
    & $pythonExecutable -c 'import pypdf' 2>$null
    if ($LASTEXITCODE -ne 0) { throw 'Python was found, but pypdf is unavailable. Install it with: python -m pip install pypdf' }
    $helper = Join-Path $PSScriptRoot 'extract-pdf-pages.py'
    $pageCountText = & $pythonExecutable $helper $inputPath $outputPath
    if ($LASTEXITCODE -ne 0 -or $pageCountText -notmatch '^\d+$') { throw 'Python/pypdf extraction failed.' }
    $pageCount = [int]$pageCountText
    $extractionEngine = "$pythonExecutable + pypdf"
} else {
    throw 'No complete PDF text backend found. Install Poppler (pdfinfo + pdftotext) or Python with pypdf.'
}

$pageRecords = @()
for ($page = 1; $page -le $pageCount; $page++) {
    $pageFileName = 'page-{0:D4}.txt' -f $page
    $pageFile = Join-Path $outputPath $pageFileName
    if (-not (Test-Path -LiteralPath $pageFile)) { throw "Missing extracted page $page." }
    $pageRecords += [ordered]@{
        page_number = $page
        text_file = $pageFileName
        text_sha256 = (Get-FileHash -Algorithm SHA256 -LiteralPath $pageFile).Hash.ToLowerInvariant()
    }
}

[ordered]@{
    source_id = $SourceId
    citacni_klic = $CitationKey
    source_pdf = $inputPath.Substring($repoRoot.Length + 1).Replace('\', '/')
    source_sha256 = (Get-FileHash -Algorithm SHA256 -LiteralPath $inputPath).Hash.ToLowerInvariant()
    page_count = $pageCount
    extraction_engine = $extractionEngine
    extracted_at = (Get-Date).ToString('o')
    pages = $pageRecords
} | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath (Join-Path $outputPath 'manifest.json') -Encoding UTF8

Write-Output "Extracted $pageCount pages with one-to-one page mapping into $outputPath."
