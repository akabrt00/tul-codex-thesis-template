[CmdletBinding()]
param(
    [ValidateSet('All', 'Thesis', 'Presentation', 'Document')]
    [string]$Target = 'All',
    [string]$DestinationRoot,
    [string]$DocumentName
)

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
if (-not $DestinationRoot) { $DestinationRoot = $repoRoot }

if (-not (Test-Path -LiteralPath $DestinationRoot)) {
    New-Item -ItemType Directory -Path $DestinationRoot -Force | Out-Null
}
$destinationRootPath = (Resolve-Path -LiteralPath $DestinationRoot).Path
$upstreamRoot = (Resolve-Path (Join-Path $repoRoot 'templates\upstream')).Path

if ($destinationRootPath.StartsWith($upstreamRoot, [StringComparison]::OrdinalIgnoreCase)) {
    throw 'DestinationRoot must not be inside templates/upstream.'
}

function Get-TreeSnapshot {
    param([Parameter(Mandatory)][string]$Path)

    $resolved = (Resolve-Path -LiteralPath $Path).Path
    $entries = @(
        Get-ChildItem -LiteralPath $resolved -Recurse -Force -File |
            Sort-Object FullName |
            ForEach-Object {
                $relative = $_.FullName.Substring($resolved.Length + 1).Replace('\', '/')
                $hash = (Get-FileHash -Algorithm SHA256 -LiteralPath $_.FullName).Hash.ToLowerInvariant()
                [pscustomobject]@{ path = $relative; sha256 = $hash }
            }
    )
    $text = ($entries | ForEach-Object { "$($_.path)`t$($_.sha256)" }) -join "`n"
    $sha = [Security.Cryptography.SHA256]::Create()
    $treeHash = ([BitConverter]::ToString($sha.ComputeHash([Text.Encoding]::UTF8.GetBytes($text)))).Replace('-', '').ToLowerInvariant()
    [pscustomobject]@{ entries = $entries; tree_sha256 = $treeHash }
}

function Assert-TreeUnchanged {
    param($Before, $After, [string]$Label)
    if ($Before.tree_sha256 -ne $After.tree_sha256 -or $Before.entries.Count -ne $After.entries.Count) {
        throw "$Label changed while creating a working copy."
    }
}

function Copy-WorkingTree {
    param(
        [Parameter(Mandatory)][string]$Source,
        [Parameter(Mandatory)][string]$Destination,
        [Parameter(Mandatory)][string]$MainSource
    )

    $before = Get-TreeSnapshot -Path $Source
    if (-not (Test-Path -LiteralPath $Destination)) {
        New-Item -ItemType Directory -Path $Destination -Force | Out-Null
    }

    $unexpected = @(
        Get-ChildItem -LiteralPath $Destination -Force |
            Where-Object { $_.Name -notin @('AGENTS.md', '.gitkeep') }
    )
    if ($unexpected.Count -gt 0) {
        throw "Working directory is not empty: $Destination"
    }

    $sourcePath = (Resolve-Path -LiteralPath $Source).Path
    Get-ChildItem -LiteralPath $sourcePath -Recurse -Force -Directory |
        Sort-Object FullName |
        ForEach-Object {
            $relative = $_.FullName.Substring($sourcePath.Length + 1)
            New-Item -ItemType Directory -Path (Join-Path $Destination $relative) -Force | Out-Null
        }
    Get-ChildItem -LiteralPath $sourcePath -Recurse -Force -File |
        ForEach-Object {
            $relative = $_.FullName.Substring($sourcePath.Length + 1)
            $targetFile = Join-Path $Destination $relative
            $targetParent = Split-Path -Parent $targetFile
            if (-not (Test-Path -LiteralPath $targetParent)) {
                New-Item -ItemType Directory -Path $targetParent -Force | Out-Null
            }
            Copy-Item -LiteralPath $_.FullName -Destination $targetFile
        }

    Copy-Item -LiteralPath (Join-Path $Source $MainSource) -Destination (Join-Path $Destination 'main.tex')
    [ordered]@{
        upstream_path = $Source.Substring($repoRoot.Length + 1).Replace('\', '/')
        upstream_tree_sha256 = $before.tree_sha256
        initialized_at = (Get-Date).ToString('o')
        main_file = 'main.tex'
    } | ConvertTo-Json | Set-Content -LiteralPath (Join-Path $Destination '.upstream-origin.json') -Encoding UTF8

    $after = Get-TreeSnapshot -Path $Source
    Assert-TreeUnchanged -Before $before -After $after -Label $Source
    Write-Output "Initialized $Destination from immutable upstream $($before.tree_sha256)."
}

if ($Target -in @('All', 'Thesis')) {
    Copy-WorkingTree -Source (Join-Path $upstreamRoot 'TUL\TULthesis') -Destination (Join-Path $destinationRootPath 'prace') -MainSource 'manual-tulthesis.tex'
}
if ($Target -in @('All', 'Presentation')) {
    Copy-WorkingTree -Source (Join-Path $upstreamRoot 'TUL\TULpresentation') -Destination (Join-Path $destinationRootPath 'obhajoba') -MainSource 'manual-tulpresentaion.tex'
}

if ($Target -eq 'Document') {
    if ([string]::IsNullOrWhiteSpace($DocumentName)) {
        throw 'DocumentName is required when Target is Document.'
    }
    if ($DocumentName -notmatch '^[a-z0-9][a-z0-9-]*$') {
        throw 'DocumentName must be a lowercase slug containing only a-z, 0-9, and hyphens.'
    }
    if ($DocumentName -eq 'main') {
        throw 'DocumentName main is reserved for the primary thesis.'
    }

    $documentPath = Join-Path $destinationRootPath (Join-Path 'prace\dokumenty' $DocumentName)
    Copy-WorkingTree -Source (Join-Path $upstreamRoot 'TUL\TULthesis') -Destination $documentPath -MainSource 'manual-tulthesis.tex'
}
