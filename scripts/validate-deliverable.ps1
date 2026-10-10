[CmdletBinding()]
param(
    [string]$ProjectDir,
    [string]$MainTex = 'main.tex',
    [ValidateSet('Thesis', 'Document', 'Presentation', 'Semester')]
    [string]$DocumentKind = 'Thesis',
    [string]$PdfPath,
    [ValidateSet('Auto', 'A4', 'Any')]
    [string]$ExpectedPageSize = 'Auto',
    [string]$ReportJson,
    [switch]$Json,
    [string]$QpdfPath,
    [string]$PdfInfoPath,
    [string]$PdfToTextPath,
    [string]$PdfFontsPath,
    [string]$PythonPath,
    [switch]$AllowGeneratedFrontMatter
)

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$results = @()

trap {
    $message = $_.Exception.Message
    if ($Json) {
        [ordered]@{ status = 'ERROR'; exit_code = 2; error = $message } | ConvertTo-Json -Compress
    } else {
        Write-Output "Preflight could not run: $message"
    }
    exit 2
}

function Test-PathInside {
    param([Parameter(Mandatory)][string]$Child, [Parameter(Mandatory)][string]$Parent)
    $parentPrefix = $Parent.TrimEnd([IO.Path]::DirectorySeparatorChar, [IO.Path]::AltDirectorySeparatorChar) + [IO.Path]::DirectorySeparatorChar
    return $Child.Equals($Parent, [StringComparison]::OrdinalIgnoreCase) -or
        $Child.StartsWith($parentPrefix, [StringComparison]::OrdinalIgnoreCase)
}

function Add-Check {
    param(
        [Parameter(Mandatory)][ValidateSet('PASS', 'WARN', 'FAIL')][string]$Status,
        [Parameter(Mandatory)][string]$Id,
        [Parameter(Mandatory)][string]$Detail
    )
    $script:results += [pscustomobject][ordered]@{ id = $Id; status = $Status; detail = $Detail }
}

function Resolve-Tool {
    param([string]$RequestedPath, [bool]$WasSpecified, [string[]]$Names)
    if ($WasSpecified) {
        if ($RequestedPath -and (Test-Path -LiteralPath $RequestedPath -PathType Leaf)) {
            return (Get-Item -LiteralPath $RequestedPath).FullName
        }
        return $null
    }
    $command = Get-Command -Name $Names -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1
    if (-not $command) { return $null }
    if ($command.Source) { return $command.Source }
    return $command.Path
}

function Invoke-NativeCapture {
    param([Parameter(Mandatory)][string]$Path, [string[]]$Arguments = @())
    $previousPreference = $ErrorActionPreference
    try {
        $ErrorActionPreference = 'Continue'
        $output = @(& $Path @Arguments 2>&1)
        $nativeExitCode = if ($null -eq $LASTEXITCODE) { 0 } else { [int]$LASTEXITCODE }
        return [pscustomobject]@{ ExitCode = $nativeExitCode; Lines = $output }
    } catch {
        return [pscustomobject]@{ ExitCode = 127; Lines = @($_.Exception.Message) }
    } finally {
        $ErrorActionPreference = $previousPreference
    }
}

function Get-DocumentSourceFiles {
    param([string]$Root, [string]$MainPath)
    $originRoot = $null
    $originFile = Join-Path $Root '.upstream-origin.json'
    if (Test-Path -LiteralPath $originFile -PathType Leaf) {
        try {
            $origin = Get-Content -Raw -Encoding UTF8 -LiteralPath $originFile | ConvertFrom-Json
            $candidate = Join-Path $repoRoot ([string]$origin.upstream_path)
            if (Test-Path -LiteralPath $candidate -PathType Container) { $originRoot = (Resolve-Path -LiteralPath $candidate).Path }
        } catch {}
    }

    $selected = @()
    foreach ($file in Get-ChildItem -LiteralPath $Root -Recurse -File -Filter '*.tex') {
        if ($file.FullName -eq $MainPath) { $selected += $file; continue }
        if ($originRoot) {
            $relative = $file.FullName.Substring($Root.Length + 1)
            $vendorCopy = Join-Path $originRoot $relative
            if (Test-Path -LiteralPath $vendorCopy -PathType Leaf) {
                $workingHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $file.FullName).Hash
                $vendorHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $vendorCopy).Hash
                if ($workingHash -eq $vendorHash) { continue }
            }
        }
        $selected += $file
    }
    return @($selected | Sort-Object FullName -Unique)
}

function Publish-Report {
    $passCount = @($script:results | Where-Object status -eq 'PASS').Count
    $warnCount = @($script:results | Where-Object status -eq 'WARN').Count
    $failCount = @($script:results | Where-Object status -eq 'FAIL').Count
    $exitCode = if ($failCount -gt 0) { 1 } else { 0 }
    $report = [ordered]@{
        schema_version = 1
        generated_at = (Get-Date).ToString('o')
        document_kind = $DocumentKind
        project_dir = $projectPath.Substring($repoRoot.Length).TrimStart('\', '/').Replace('\', '/')
        main_tex = $MainTex.Replace('\', '/')
        pdf = $resolvedPdf.Substring($repoRoot.Length).TrimStart('\', '/').Replace('\', '/')
        summary = [ordered]@{ pass = $passCount; warn = $warnCount; fail = $failCount }
        checks = $script:results
        exit_code = $exitCode
    }
    $jsonText = $report | ConvertTo-Json -Depth 6
    if ($ReportJson) {
        $reportFullPath = [IO.Path]::GetFullPath($(if ([IO.Path]::IsPathRooted($ReportJson)) { $ReportJson } else { Join-Path $repoRoot $ReportJson }))
        if (-not (Test-PathInside -Child $reportFullPath -Parent $repoRoot)) { throw 'ReportJson must resolve inside the repository.' }
        $reportParent = Split-Path -Parent $reportFullPath
        if (-not (Test-Path -LiteralPath $reportParent)) { New-Item -ItemType Directory -Path $reportParent -Force | Out-Null }
        $jsonText | Set-Content -LiteralPath $reportFullPath -Encoding UTF8
    }
    if ($Json) {
        Write-Output ($report | ConvertTo-Json -Depth 6 -Compress)
    } else {
        Write-Output 'Preflight'
        Write-Output '========='
        Write-Output ''
        foreach ($check in $script:results) { Write-Output "[$($check.status)] $($check.id): $($check.detail)" }
        Write-Output ''
        Write-Output "Summary: $passCount PASS, $warnCount WARN, $failCount FAIL"
    }
    exit $exitCode
}

if (-not $ProjectDir) { $ProjectDir = Join-Path $repoRoot 'prace' }
$projectPath = (Resolve-Path -LiteralPath $ProjectDir).Path
if (-not (Test-PathInside -Child $projectPath -Parent $repoRoot)) { throw 'ProjectDir must resolve inside the repository.' }
$upstreamPath = (Resolve-Path (Join-Path $repoRoot 'templates\upstream')).Path
if (Test-PathInside -Child $projectPath -Parent $upstreamPath) { throw 'Refusing to validate inside templates/upstream.' }

$mainFullPath = [IO.Path]::GetFullPath($(if ([IO.Path]::IsPathRooted($MainTex)) { $MainTex } else { Join-Path $projectPath $MainTex }))
if (-not (Test-PathInside -Child $mainFullPath -Parent $projectPath)) { throw 'MainTex must resolve inside ProjectDir.' }
if (-not (Test-Path -LiteralPath $mainFullPath -PathType Leaf)) { throw "MainTeX does not exist: $mainFullPath" }
$jobName = [IO.Path]::GetFileNameWithoutExtension($mainFullPath)

if (-not $PdfPath) { $PdfPath = "$jobName.pdf" }
$resolvedPdf = [IO.Path]::GetFullPath($(if ([IO.Path]::IsPathRooted($PdfPath)) { $PdfPath } else { Join-Path $projectPath $PdfPath }))
if (-not (Test-PathInside -Child $resolvedPdf -Parent $projectPath)) { throw 'PdfPath must resolve inside ProjectDir.' }

$qpdf = Resolve-Tool -RequestedPath $QpdfPath -WasSpecified $PSBoundParameters.ContainsKey('QpdfPath') -Names @('qpdf')
$pdfinfo = Resolve-Tool -RequestedPath $PdfInfoPath -WasSpecified $PSBoundParameters.ContainsKey('PdfInfoPath') -Names @('pdfinfo')
$pdftotext = Resolve-Tool -RequestedPath $PdfToTextPath -WasSpecified $PSBoundParameters.ContainsKey('PdfToTextPath') -Names @('pdftotext')
$pdffonts = Resolve-Tool -RequestedPath $PdfFontsPath -WasSpecified $PSBoundParameters.ContainsKey('PdfFontsPath') -Names @('pdffonts')
$python = Resolve-Tool -RequestedPath $PythonPath -WasSpecified $PSBoundParameters.ContainsKey('PythonPath') -Names @('py', 'python', 'python3')

if (-not (Test-Path -LiteralPath $resolvedPdf -PathType Leaf)) {
    Add-Check FAIL 'PDF exists' "Expected output is missing: $([IO.Path]::GetFileName($resolvedPdf))"
    Publish-Report
}
$pdfLength = (Get-Item -LiteralPath $resolvedPdf).Length
if ($pdfLength -gt 0) { Add-Check PASS 'PDF size' "$pdfLength bytes" } else { Add-Check FAIL 'PDF size' 'The PDF is empty (0 bytes).' }
if ($pdfLength -eq 0) { Publish-Report }

$basicPdfValid = $false
$readCheckAdded = $false
$parserWasAvailable = $false
$parserErrors = @()
$pdfInfoText = $null
$pythonInfo = $null
if ($qpdf) {
    $qpdfResult = Invoke-NativeCapture -Path $qpdf -Arguments @('--check', $resolvedPdf)
    if ($qpdfResult.ExitCode -eq 0) { $basicPdfValid = $true; Add-Check PASS 'PDF structure (qpdf)' 'qpdf accepted the file.' }
    else { Add-Check FAIL 'PDF structure (qpdf)' (($qpdfResult.Lines | Select-Object -First 3) -join ' ') }
} else {
    Add-Check WARN 'PDF structure (qpdf)' 'qpdf is unavailable; this optional check was skipped.'
}

if ($pdfinfo) {
    $parserWasAvailable = $true
    $pdfInfoResult = Invoke-NativeCapture -Path $pdfinfo -Arguments @($resolvedPdf)
    $pdfInfoLines = @($pdfInfoResult.Lines)
    if ($pdfInfoResult.ExitCode -eq 0) {
        $pdfInfoText = $pdfInfoLines -join "`n"
        $basicPdfValid = $true
        $readCheckAdded = $true
        Add-Check PASS 'PDF readable' 'pdfinfo parsed the file.'
    } else {
        $parserErrors += (($pdfInfoLines | Select-Object -First 3) -join ' ')
    }
}
if (-not $pdfInfoText -and $python) {
    $parserWasAvailable = $true
    $pythonCode = 'import json,sys; from pypdf import PdfReader; r=PdfReader(sys.argv[1]); texts=[p.extract_text() or "" for p in r.pages]; print(json.dumps({"pages":len(r.pages),"sizes":[[float(p.mediabox.width),float(p.mediabox.height)] for p in r.pages],"text_chars":sum(len(t.strip()) for t in texts),"question_marks":sum(t.count("??") for t in texts)}))'
    $pythonResult = Invoke-NativeCapture -Path $python -Arguments @('-c', $pythonCode, $resolvedPdf)
    $pythonOutput = @($pythonResult.Lines)
    if ($pythonResult.ExitCode -eq 0) {
        try { $pythonInfo = ($pythonOutput -join "`n") | ConvertFrom-Json; $basicPdfValid = $true; $readCheckAdded = $true; Add-Check PASS 'PDF readable' 'Python/pypdf parsed the file.' }
        catch { $parserErrors += 'Python/pypdf returned invalid metadata.' }
    } else {
        $parserErrors += (($pythonOutput | Select-Object -First 3) -join ' ')
    }
}

if ($pdfInfoText -and $pdfInfoText -match '(?m)^Pages:\s+(\d+)') {
    $pageCount = [int]$Matches[1]
    if ($pageCount -gt 0) { Add-Check PASS 'Page count' "$pageCount pages" } else { Add-Check FAIL 'Page count' 'The PDF has no pages.' }
} elseif ($pythonInfo) {
    $pageCount = [int]$pythonInfo.pages
    if ($pageCount -gt 0) { Add-Check PASS 'Page count' "$pageCount pages" } else { Add-Check FAIL 'Page count' 'The PDF has no pages.' }
} elseif ($basicPdfValid) {
    Add-Check WARN 'Page count' 'The selected parser did not expose a page count.'
} else {
    Add-Check WARN 'Page count' 'No PDF parser is available.'
}

if ($ExpectedPageSize -eq 'Auto') { $ExpectedPageSize = if ($DocumentKind -eq 'Presentation') { 'Any' } else { 'A4' } }
if ($ExpectedPageSize -eq 'Any') {
    Add-Check PASS 'Page size' 'No fixed page size is required for this document kind.'
} else {
    $sizes = @()
    if ($pythonInfo -and $pythonInfo.sizes) {
        $sizes = @($pythonInfo.sizes)
    } elseif ($pdfInfoText -and $pdfInfoText -match '(?m)^Page size:\s+([0-9.]+)\s+x\s+([0-9.]+)\s+pts') {
        $sizes = ,@([double]$Matches[1], [double]$Matches[2])
    }
    if ($sizes.Count -eq 0) {
        Add-Check WARN 'Page size' 'Page dimensions are unavailable.'
    } else {
        $badSizes = @()
        foreach ($size in $sizes) {
            $width = [double]$size[0]; $height = [double]$size[1]
            $portraitA4 = ([Math]::Abs($width - 595.28) -le 3 -and [Math]::Abs($height - 841.89) -le 3)
            $landscapeA4 = ([Math]::Abs($height - 595.28) -le 3 -and [Math]::Abs($width - 841.89) -le 3)
            if (-not ($portraitA4 -or $landscapeA4)) { $badSizes += ('{0:N1} x {1:N1} pt' -f $width, $height) }
        }
        if ($badSizes.Count -eq 0) { Add-Check PASS 'Page size' 'All inspected pages are A4.' }
        else { Add-Check FAIL 'Page size' ("Expected A4; found " + (($badSizes | Select-Object -Unique) -join ', ')) }
    }
}

$extractedText = $null
if ($pdftotext) {
    $tempText = Join-Path $projectPath ('.preflight-text-' + [guid]::NewGuid().ToString('N') + '.txt')
    try {
        $textResult = Invoke-NativeCapture -Path $pdftotext -Arguments @('-enc', 'UTF-8', $resolvedPdf, $tempText)
        $textOutput = @($textResult.Lines)
        if ($textResult.ExitCode -eq 0 -and (Test-Path -LiteralPath $tempText)) {
            $extractedText = Get-Content -Raw -Encoding UTF8 -LiteralPath $tempText
            if (-not $basicPdfValid) { $basicPdfValid = $true }
            if (-not $readCheckAdded) { Add-Check PASS 'PDF readable' 'pdftotext parsed the file.'; $readCheckAdded = $true }
        } else {
            Add-Check FAIL 'Extractable text' (($textOutput | Select-Object -First 3) -join ' ')
            if (-not $readCheckAdded) {
                $detail = (($parserErrors + (($textOutput | Select-Object -First 3) -join ' ')) | Where-Object { $_ } | Select-Object -First 2) -join ' '
                Add-Check FAIL 'PDF readable' $detail
                $readCheckAdded = $true
            }
        }
    } finally {
        if (Test-Path -LiteralPath $tempText) { Remove-Item -LiteralPath $tempText -Force }
    }
} elseif ($pythonInfo) {
    $extractedText = 'x' * [int]$pythonInfo.text_chars
} else {
    Add-Check WARN 'Extractable text' 'pdftotext and Python/pypdf are unavailable; text extraction was skipped.'
}
if (-not $readCheckAdded) {
    if ($basicPdfValid) { Add-Check PASS 'PDF readable' 'An available PDF structure checker accepted the file.' }
    elseif ($parserWasAvailable) { Add-Check FAIL 'PDF readable' (($parserErrors | Where-Object { $_ } | Select-Object -First 2) -join ' ') }
    else { Add-Check WARN 'PDF readable' 'pdfinfo and Python/pypdf are unavailable; parsing was skipped.' }
    $readCheckAdded = $true
}
if ($null -ne $extractedText) {
    $textLength = ($extractedText -replace '\s', '').Length
    if ($textLength -eq 0) { Add-Check FAIL 'Extractable text' 'No text could be extracted.' }
    elseif ($textLength -lt 50) { Add-Check WARN 'Extractable text' "Only $textLength non-whitespace characters were extracted." }
    else { Add-Check PASS 'Extractable text' "$textLength non-whitespace characters extracted." }
    $questionMarks = if (-not $pdftotext -and $pythonInfo -and $null -ne $pythonInfo.question_marks) {
        [int]$pythonInfo.question_marks
    } else {
        @([regex]::Matches($extractedText, '\?\?')).Count
    }
    if ($questionMarks -gt 0) { Add-Check FAIL 'Unresolved question marks' "Found $questionMarks occurrence(s) of ?? in extracted PDF text." }
    else { Add-Check PASS 'Unresolved question marks' 'No ?? markers found in extracted PDF text.' }
}

if ($pdffonts) {
    $fontResult = Invoke-NativeCapture -Path $pdffonts -Arguments @($resolvedPdf)
    $fontLines = @($fontResult.Lines)
    if ($fontResult.ExitCode -ne 0) {
        Add-Check FAIL 'Embedded fonts' (($fontLines | Select-Object -First 3) -join ' ')
    } else {
        $fontRows = @($fontLines | Where-Object {
            $tokens = @(([string]$_).Trim() -split '\s+')
            $tokens.Count -ge 8 -and $tokens[$tokens.Count - 5] -in @('yes', 'no')
        })
        $notEmbedded = @()
        foreach ($row in $fontRows) {
            $tokens = @($row.Trim() -split '\s+')
            if ($tokens.Count -ge 8 -and $tokens[$tokens.Count - 5] -eq 'no') { $notEmbedded += $tokens[0] }
        }
        if ($notEmbedded.Count -gt 0) { Add-Check FAIL 'Embedded fonts' ("Not embedded: " + ($notEmbedded -join ', ')) }
        elseif ($fontRows.Count -eq 0) { Add-Check WARN 'Embedded fonts' 'pdffonts found no fonts.' }
        else { Add-Check PASS 'Embedded fonts' "All $($fontRows.Count) reported fonts are embedded." }
    }
} else {
    Add-Check WARN 'Embedded fonts' 'pdffonts is unavailable; this optional check was skipped.'
}

$sourceFiles = @(Get-DocumentSourceFiles -Root $projectPath -MainPath $mainFullPath)
$sourceText = ($sourceFiles | ForEach-Object { Get-Content -Raw -Encoding UTF8 -LiteralPath $_.FullName }) -join "`n"
$placeholderPattern = '(?i)\[(?:doplnit|not\s+configured)\]|\b(?:TODO|FIXME)\b|\bDoplnit\b|\bDopl\u0148te\b|\bAdd the English abstract\b|\bAdd English keywords\b|Popi\u0161te motivaci, c\u00edl pr\u00e1ce a jej\u00ed strukturu|Zpracujte odborn\u00e1 v\u00fdchodiska a citujte zdroje evidovan\u00e9 ve slo\u017ece|Popi\u0161te n\u00e1vrh, realizaci, experimenty nebo m\u011b\u0159en\u00ed|Vyhodno\u0165te v\u00fdsledky, omezen\u00ed a vztah k c\u00edli pr\u00e1ce|Shr\u0148te dosa\u017een\u00e9 v\u00fdsledky a doporu\u010den\u00ed pro dal\u0161\u00ed pr\u00e1ci|Uve\u010fte vlo\u017een\u00e9 p\u0159\u00edlohy'
$placeholderHits = @()
foreach ($file in $sourceFiles) {
    $lineNumber = 0
    foreach ($line in Get-Content -Encoding UTF8 -LiteralPath $file.FullName) {
        $lineNumber++
        if ($line -match $placeholderPattern) {
            $relative = $file.FullName.Substring($projectPath.Length + 1).Replace('\', '/')
            $placeholderHits += "${relative}:$lineNumber"
        }
    }
}
if ($placeholderHits.Count -gt 0) { Add-Check FAIL 'Placeholders' ("Found placeholder text at " + (($placeholderHits | Select-Object -First 10) -join ', ')) }
else { Add-Check PASS 'Placeholders' "No known placeholders in $($sourceFiles.Count) document source file(s)." }

if ($DocumentKind -eq 'Semester') {
    $mainText = Get-Content -Raw -Encoding UTF8 -LiteralPath $mainFullPath
    $activeText = $mainText -replace '(?m)%.*$', ''
    $titleCount = @([regex]::Matches($activeText, '\\TitulniStrana\b')).Count
    if ($titleCount -eq 1 -and $activeText -notmatch '\\ThesisStart\b') { Add-Check PASS 'Semester title page' 'Exactly one TitulniStrana and no ThesisStart command.' }
    else { Add-Check FAIL 'Semester title page' 'Expected one TitulniStrana command and no ThesisStart command.' }
} elseif ($DocumentKind -ne 'Presentation') {
    $mainText = Get-Content -Raw -Encoding UTF8 -LiteralPath $mainFullPath
    $activeStartMatches = @([regex]::Matches($mainText, '(?m)^\s*\\ThesisStart\{.*\}\s*$'))
    if ($activeStartMatches.Count -eq 1) {
        Add-Check PASS 'ThesisStart' 'Exactly one introductory-page command is active.'
        $usesGeneratedFrontMatter = $activeStartMatches[0].Value -match '\{(?:male|female)\}'
        if ($DocumentKind -eq 'Thesis' -and $usesGeneratedFrontMatter -and -not $AllowGeneratedFrontMatter) {
            Add-Check FAIL 'Official introductory pages' 'The primary thesis still uses generated male/female pages. Replace them with the official IS STAG PDF before submission.'
        } elseif ($DocumentKind -eq 'Thesis' -and $usesGeneratedFrontMatter) {
            Add-Check WARN 'Official introductory pages' 'Generated introductory pages are allowed only for this test or working build.'
        } else {
            Add-Check PASS 'Official introductory pages' 'The active ThesisStart does not use the generated male/female variant.'
        }
    } else {
        Add-Check FAIL 'ThesisStart' "Expected exactly one active ThesisStart command; found $($activeStartMatches.Count)."
    }
}

$logFiles = @()
$finalLogPath = Join-Path $projectPath "$jobName.log"
$biberLogPath = Join-Path $projectPath "$jobName.blg"
if (Test-Path -LiteralPath $finalLogPath -PathType Leaf) { $logFiles += Get-Item -LiteralPath $finalLogPath }
if (Test-Path -LiteralPath $biberLogPath -PathType Leaf) { $logFiles += Get-Item -LiteralPath $biberLogPath }
$buildLogDir = Join-Path $projectPath '.build-logs'
if (Test-Path -LiteralPath $buildLogDir -PathType Container) { $logFiles += Get-ChildItem -LiteralPath $buildLogDir -File -Filter '*.log' }
$latexLogText = if (Test-Path -LiteralPath $finalLogPath -PathType Leaf) {
    Get-Content -Raw -Encoding UTF8 -LiteralPath $finalLogPath
} elseif (Test-Path -LiteralPath $buildLogDir -PathType Container) {
    $lastXeLaTeX = Get-ChildItem -LiteralPath $buildLogDir -File -Filter '*xelatex*.stdout.log' | Sort-Object Name | Select-Object -Last 1
    if ($lastXeLaTeX) { Get-Content -Raw -Encoding UTF8 -LiteralPath $lastXeLaTeX.FullName } else { '' }
} else { '' }
$biberLogText = if (Test-Path -LiteralPath $biberLogPath -PathType Leaf) { Get-Content -Raw -Encoding UTF8 -LiteralPath $biberLogPath } else { '' }
if ($logFiles.Count -eq 0) { Add-Check WARN 'Build logs' 'No LaTeX/Biber build logs were found.' }
else { Add-Check PASS 'Build logs' "Inspected $($logFiles.Count) log file(s)." }

$undefinedCitations = @([regex]::Matches(($latexLogText + "`n" + $biberLogText), '(?im)(citation[^\r\n]*(?:undefined|not found)|undefined citations|didn.t find a database entry)')).Count
if ($undefinedCitations -gt 0) { Add-Check FAIL 'Citations resolved' "Found $undefinedCitations unresolved-citation warning(s)." }
else { Add-Check PASS 'Citations resolved' 'No unresolved citations found in build logs.' }
$undefinedReferences = @([regex]::Matches($latexLogText, '(?im)(reference[^\r\n]*undefined|undefined references)')).Count
if ($undefinedReferences -gt 0) { Add-Check FAIL 'Cross-references resolved' "Found $undefinedReferences unresolved-reference warning(s)." }
else { Add-Check PASS 'Cross-references resolved' 'No unresolved references found in build logs.' }
$duplicateLabels = @([regex]::Matches($latexLogText, '(?im)(multiply[- ]defined labels?|label[^\r\n]*multiply defined)')).Count
if ($duplicateLabels -gt 0) { Add-Check FAIL 'Duplicate labels' "Found $duplicateLabels duplicate-label warning(s)." }
else { Add-Check PASS 'Duplicate labels' 'No duplicate labels found in build logs.' }
$overfull = @([regex]::Matches($latexLogText, '(?im)^Overfull \\hbox')).Count
if ($overfull -gt 0) { Add-Check WARN 'Overfull boxes' "Found $overfull overfull hbox warning(s)." }
else { Add-Check PASS 'Overfull boxes' 'No overfull hbox warnings found.' }
$fontSubstitutions = @([regex]::Matches($latexLogText, '(?im)(Font shape[^\r\n]*undefined|font shapes were not available[^\r\n]*substituted)')).Count
if ($fontSubstitutions -gt 0) { Add-Check FAIL 'Font substitutions' "Found $fontSubstitutions font-substitution warning(s)." }
else { Add-Check PASS 'Font substitutions' 'No font substitutions found in build logs.' }
$allWarnings = @([regex]::Matches($latexLogText, '(?im)^(?:LaTeX|Package\s+\S+) Warning:')).Count
$knownWarnings = $undefinedCitations + $undefinedReferences + $duplicateLabels
$otherWarnings = [Math]::Max(0, $allWarnings - $knownWarnings)
if ($otherWarnings -gt 0) { Add-Check WARN 'Other LaTeX warnings' "Found approximately $otherWarnings additional warning(s); inspect the final log." }
else { Add-Check PASS 'Other LaTeX warnings' 'No additional LaTeX/package warnings found.' }

if (($sourceText -replace '(?m)%.*$', '') -match '\\(?:printbibliography\b|bibliography\{)') {
    $bblPath = Join-Path $projectPath "$jobName.bbl"
    if (-not (Test-Path -LiteralPath $bblPath -PathType Leaf) -or (Get-Item -LiteralPath $bblPath).Length -eq 0) {
        Add-Check FAIL 'Bibliography' 'The document prints a bibliography, but the .bbl file is missing or empty.'
    } else {
        $bblText = Get-Content -Raw -Encoding UTF8 -LiteralPath $bblPath
        $entryCount = @([regex]::Matches($bblText, '\\(?:entry\{|bibitem(?:\[[^\]]*\])?\{)')).Count
        if ($entryCount -eq 0) { Add-Check FAIL 'Bibliography' 'The generated bibliography contains no entries.' }
        else { Add-Check PASS 'Bibliography' "$entryCount generated bibliography entry/entries." }
    }
} else {
    Add-Check WARN 'Bibliography' 'No printbibliography command was found in document-owned TeX sources.'
}

Publish-Report
