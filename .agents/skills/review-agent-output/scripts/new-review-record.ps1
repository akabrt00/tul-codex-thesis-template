[CmdletBinding()]
param(
    [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$Scope,
    [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$DocumentKey,
    [Parameter(Mandatory)][ValidateSet('not-checked', 'passed', 'passed-with-warnings', 'failed')][string]$TechnicalStatus,
    [string[]]$ArtifactPaths = @(),
    [string[]]$TechnicalChecks = @(),
    [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string[]]$HumanChecks,
    [string[]]$RiskFlags = @()
)

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..\..')).Path
$reviewsDir = Join-Path $repoRoot 'reviews'
New-Item -ItemType Directory -Path $reviewsDir -Force | Out-Null

foreach ($artifactPath in $ArtifactPaths) {
    if ([IO.Path]::IsPathRooted($artifactPath)) {
        throw "Artifact paths must be portable and relative to the repository: $artifactPath"
    }
}

$existingNumbers = Get-ChildItem -LiteralPath $reviewsDir -Filter 'REV-*.json' -File -ErrorAction SilentlyContinue |
    Where-Object { $_.BaseName -match '^REV-(\d{4})$' } |
    ForEach-Object { [int]$Matches[1] }
$nextNumber = if ($existingNumbers) { [int](($existingNumbers | Measure-Object -Maximum).Maximum) + 1 } else { 1 }
if ($nextNumber -gt 9999) { throw 'Review identifier space is exhausted.' }
$reviewId = 'REV-{0:D4}' -f $nextNumber
$recordPath = Join-Path $reviewsDir "$reviewId.json"
$createdAt = (Get-Date).ToString('o')

$record = [ordered]@{
    schema_version = 1
    review_id = $reviewId
    status = 'awaiting-human-review'
    created_at = $createdAt
    updated_at = $createdAt
    document_key = $DocumentKey
    scope = $Scope
    artifact_paths = @($ArtifactPaths)
    technical_status = $TechnicalStatus
    technical_checks = @($TechnicalChecks)
    human_checks = @($HumanChecks)
    risk_flags = @($RiskFlags)
    human_decision = $null
}
$record | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $recordPath -Encoding UTF8

$indexPath = Join-Path $reviewsDir 'REVIEW_QUEUE.md'
if (-not (Test-Path -LiteralPath $indexPath)) {
    @(
        '# Human review queue'
        ''
        'Agent-created material remains unapproved until a person explicitly reviews the stated scope.'
        ''
        '| ID | Document | Scope | Technical status | Human status | Record |'
        '|---|---|---|---|---|---|'
    ) | Set-Content -LiteralPath $indexPath -Encoding UTF8
}
$safeScope = $Scope.Replace('|', '\|').Replace("`r", ' ').Replace("`n", ' ')
$safeDocument = $DocumentKey.Replace('|', '\|')
Add-Content -LiteralPath $indexPath -Encoding UTF8 -Value "| $reviewId | $safeDocument | $safeScope | $TechnicalStatus | awaiting-human-review | [$reviewId](./$reviewId.json) |"

[pscustomobject]@{
    ReviewId = $reviewId
    Status = 'awaiting-human-review'
    Record = $recordPath
    Queue = $indexPath
}
