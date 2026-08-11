[CmdletBinding()]
param(
    [Parameter(Mandatory)][ValidatePattern('^REV-\d{4}$')][string]$ReviewId,
    [Parameter(Mandatory)][ValidateSet('approved', 'changes-requested', 'needs-supervisor-review', 'superseded')][string]$Decision,
    [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$UserStatement
)

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..\..')).Path
$reviewsDir = Join-Path $repoRoot 'reviews'
$recordPath = Join-Path $reviewsDir "$ReviewId.json"
$indexPath = Join-Path $reviewsDir 'REVIEW_QUEUE.md'
if (-not (Test-Path -LiteralPath $recordPath -PathType Leaf)) { throw "Review record not found: $ReviewId" }
if (-not (Test-Path -LiteralPath $indexPath -PathType Leaf)) { throw 'Review queue index is missing.' }

$statusMap = @{
    approved = 'human-approved'
    'changes-requested' = 'changes-requested'
    'needs-supervisor-review' = 'needs-supervisor-review'
    superseded = 'superseded'
}
$status = $statusMap[$Decision]
$record = Get-Content -LiteralPath $recordPath -Raw -Encoding UTF8 | ConvertFrom-Json
if ($record.review_id -ne $ReviewId) { throw 'Review record ID does not match its filename.' }
$record.status = $status
$record.updated_at = (Get-Date).ToString('o')
$record.human_decision = [pscustomobject]@{
    decision = $Decision
    statement = $UserStatement
    recorded_at = (Get-Date).ToString('o')
}
$record | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $recordPath -Encoding UTF8

$lines = @(Get-Content -LiteralPath $indexPath -Encoding UTF8)
$matched = $false
for ($i = 0; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -match "^\|\s*$([regex]::Escape($ReviewId))\s*\|") {
        $documentKey = ([string]$record.document_key).Replace('|', '\|')
        $scope = ([string]$record.scope).Replace('|', '\|')
        $technicalStatus = [string]$record.technical_status
        $lines[$i] = "| $ReviewId | $documentKey | $scope | $technicalStatus | $status | [$ReviewId](./$ReviewId.json) |"
        $matched = $true
        break
    }
}
if (-not $matched) { throw "Review queue row not found: $ReviewId" }
$lines | Set-Content -LiteralPath $indexPath -Encoding UTF8

[pscustomobject]@{
    ReviewId = $ReviewId
    Status = $status
    Record = $recordPath
}
