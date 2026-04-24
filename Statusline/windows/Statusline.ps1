#!/usr/bin/env pwsh
# Claude Code Status Line Script v3
# Pure PowerShell - No external dependencies (no jq needed)
#
# Line 1: RepoName | Branch ±changes | [Model]
# Line 2: Context% | Session% (remaining) | Weekly% | Extended
# Colors: Light blue, lavender, cyan, dynamic green/yellow/red, sky blue

# Read JSON from stdin
$jsonInput = [Console]::In.ReadToEnd()

# Parse JSON (PowerShell has built-in JSON support)
try {
    $data = $jsonInput | ConvertFrom-Json
} catch {
    Write-Host "Error parsing JSON" -NoNewline
    exit
}

# ANSI Color codes (cool palette as requested)
$colors = @{
    Reset      = "`e[0m"
    LightBlue  = "`e[38;5;117m"   # Light blue for repo
    Lavender   = "`e[38;5;183m"   # Light purple/lavender for branch
    Cyan       = "`e[38;5;159m"   # Light cyan for model
    SkyBlue    = "`e[38;5;153m"   # Light sky blue for cost
    Green      = "`e[38;5;120m"   # Light green for low usage
    Yellow     = "`e[38;5;229m"   # Light yellow for medium usage
    Orange     = "`e[38;5;216m"   # Light orange for high usage
    Red        = "`e[38;5;210m"   # Light red for critical usage
    Dim        = "`e[38;5;245m"   # Dim gray for separators
    White      = "`e[38;5;255m"   # White for text
    Magenta    = "`e[38;5;219m"   # Light magenta for session usage
}

# Extract data from JSON
$model = if ($data.model.display_name) { $data.model.display_name } else { "Unknown" }
$currentDir = if ($data.workspace.current_dir) { $data.workspace.current_dir } else { $PWD.Path }
$cost = if ($data.cost.total_cost_usd) { $data.cost.total_cost_usd } else { 0 }

# Calculate context percentage
$contextPercent = 0
if ($data.context_window) {
    if ($data.context_window.used_percentage) {
        $contextPercent = [math]::Round($data.context_window.used_percentage, 0)
    } elseif ($data.context_window.context_window_size -gt 0) {
        $inputTokens = if ($data.context_window.total_input_tokens) { $data.context_window.total_input_tokens } else { 0 }
        $outputTokens = if ($data.context_window.total_output_tokens) { $data.context_window.total_output_tokens } else { 0 }
        $contextSize = $data.context_window.context_window_size
        $contextPercent = [math]::Round(($inputTokens + $outputTokens) * 100 / $contextSize, 0)
    }
}

# Get usage color based on percentage (used for both context and session)
function Get-UsageColor {
    param([int]$percent)
    if ($percent -lt 40) { return $colors.Green }
    elseif ($percent -lt 60) { return $colors.Yellow }
    elseif ($percent -lt 80) { return $colors.Orange }
    else { return $colors.Red }
}

# Get plan usage from cache file (updated by Get-ClaudeUsage.ps1)
function Get-PlanUsage {
    $claudeFolderPath = Join-Path $env:USERPROFILE ".claude"
    $usageScript = Join-Path $claudeFolderPath "Get-ClaudeUsage.ps1"
    $cachePath = Join-Path $claudeFolderPath "usage-cache.json"

    # Refresh cache in background if file is missing or older than 2 minutes
    $needsRefresh = -not (Test-Path $cachePath) -or
        ((Get-Date) - (Get-Item $cachePath).LastWriteTime).TotalMinutes -gt 2

    if ($needsRefresh -and (Test-Path $usageScript)) {
        # -ExecutionPolicy Bypass covers two cases on other machines:
        #   1. Default Restricted execution policy blocking unsigned .ps1 files
        #   2. Mark of the Web (MOTW) tagging from zip downloads
        Start-Process -FilePath "pwsh" -ArgumentList "-NoProfile","-ExecutionPolicy","Bypass","-File",$usageScript,"-Silent" -WindowStyle Hidden
    }

    if (-not (Test-Path $cachePath)) {
        return $null
    }

    try {
        $cache = Get-Content $cachePath -Raw | ConvertFrom-Json

        # Check if cache is too old (more than 5 minutes = stale warning)
        $lastUpdated = if ($cache.last_updated -is [DateTime]) { $cache.last_updated } else {
            [DateTimeOffset]::Parse($cache.last_updated, [System.Globalization.CultureInfo]::InvariantCulture).LocalDateTime
        }
        $age = (Get-Date) - $lastUpdated
        $isStale = $age.TotalMinutes -gt 5

        # Calculate remaining time for 5h reset
        $fiveHourRemaining = $null
        if ($cache.five_hour -and $cache.five_hour.resets_at) {
            try {
                $resetTime = if ($cache.five_hour.resets_at -is [DateTime]) { $cache.five_hour.resets_at } else {
                    [DateTimeOffset]::Parse($cache.five_hour.resets_at, [System.Globalization.CultureInfo]::InvariantCulture).LocalDateTime
                }
                $remaining = $resetTime - (Get-Date)
                if ($remaining.TotalMinutes -gt 0) {
                    $hours = [math]::Floor($remaining.TotalHours)
                    $mins = [math]::Floor($remaining.TotalMinutes % 60)
                    if ($hours -gt 0) {
                        $fiveHourRemaining = "${hours}h${mins}m"
                    } else {
                        $fiveHourRemaining = "${mins}m"
                    }
                }
            } catch { }
        }

        return @{
            FiveHour = if ($cache.five_hour) { $cache.five_hour.utilization_rounded } else { $null }
            SevenDay = if ($cache.seven_day) { $cache.seven_day.utilization_rounded } else { $null }
            FiveHourReset = if ($cache.five_hour) { $cache.five_hour.resets_at_friendly } else { $null }
            FiveHourRemaining = $fiveHourRemaining
            SevenDayReset = if ($cache.seven_day) { $cache.seven_day.resets_at_friendly } else { $null }
            Extended = if ($cache.extended -and $cache.extended.active) { $true } else { $false }
            ExtendedUsage = if ($cache.extended -and $cache.extended.utilization_rounded) { $cache.extended.utilization_rounded } else { $null }
            ExtendedCost = if ($cache.extended -and ($null -ne $cache.extended.cost_usd)) { $cache.extended.cost_usd } else { $null }
            IsStale = $isStale
            LastUpdated = $cache.last_updated_friendly
        }
    } catch {
        return $null
    }
}

# Get git information
function Get-GitInfo {
    param([string]$dir)

    # Check if we're in a git repo
    $gitDir = $null
    $checkDir = $dir
    while ($checkDir -and $checkDir -ne [System.IO.Path]::GetPathRoot($checkDir)) {
        $testPath = Join-Path $checkDir ".git"
        if (Test-Path $testPath) {
            $gitDir = $testPath
            break
        }
        $checkDir = Split-Path $checkDir -Parent
    }

    if (-not $gitDir) {
        $parentPath = Split-Path $dir -Parent
        $parentName = Split-Path $parentPath -Leaf
        $dirLeaf = Split-Path $dir -Leaf
        return @{ RepoName = "$parentName/$dirLeaf"; Branch = $null; Changes = "" }
    }

    # Get repo name (folder containing .git) with parent folder
    $repoPath = Split-Path $gitDir -Parent
    $parentPath = Split-Path $repoPath -Parent
    $parentName = Split-Path $parentPath -Leaf
    $repoLeaf = Split-Path $repoPath -Leaf
    $repoName = "$parentName/$repoLeaf"

    # Get current branch
    $branch = $null
    $headFile = Join-Path $gitDir "HEAD"
    if (Test-Path $headFile) {
        $headContent = Get-Content $headFile -Raw
        if ($headContent -match "ref: refs/heads/(.+)") {
            $branch = $matches[1].Trim()
        } elseif ($headContent -match "^[a-f0-9]{40}") {
            $branch = $headContent.Substring(0, 7) # Detached HEAD, show short hash
        }
    }

    # Get change counts using git commands (fast operations)
    $changes = ""
    try {
        Push-Location $repoPath

        # Staged changes
        $staged = (git diff --cached --numstat 2>$null | Measure-Object).Count
        # Unstaged changes
        $unstaged = (git diff --numstat 2>$null | Measure-Object).Count
        # Untracked files
        $untracked = (git ls-files --others --exclude-standard 2>$null | Measure-Object).Count

        $totalChanges = $staged + $unstaged + $untracked

        if ($totalChanges -gt 0) {
            $parts = @()
            if ($staged -gt 0) { $parts += "+$staged" }
            if ($unstaged -gt 0) { $parts += "~$unstaged" }
            if ($untracked -gt 0) { $parts += "?$untracked" }
            $changes = " " + ($parts -join " ")
        }

        Pop-Location
    } catch {
        # Silently ignore git errors
    }

    return @{ RepoName = $repoName; Branch = $branch; Changes = $changes }
}

# Shorten model name (remove "Claude " prefix as requested)
function Get-ShortModelName {
    param([string]$modelName)
    $short = $modelName -replace "^Claude\s+", ""
    return $short
}

# Build the status line
$sep = "$($colors.Dim) | $($colors.Reset)"

$gitInfo = Get-GitInfo -dir $currentDir
$shortModel = Get-ShortModelName -modelName $model
$contextColor = Get-UsageColor -percent $contextPercent

# Fetch plan usage (with caching to avoid API spam)
$planUsage = Get-PlanUsage

# Build output parts - split into two lines to avoid truncation
$line1 = @()
$line2 = @()

# Line 1: Repo, Branch, Model
$line1 += "$($colors.LightBlue)$($gitInfo.RepoName)$($colors.Reset)"

if ($gitInfo.Branch) {
    $line1 += "$($colors.Lavender)$($gitInfo.Branch)$($gitInfo.Changes)$($colors.Reset)"
}

$line1 += "$($colors.Cyan)[$shortModel]$($colors.Reset)"

# Line 2: Context, Session, Weekly, Extended
$line2 += "$($contextColor)Ctx:$($contextPercent)%$($colors.Reset)"

if ($planUsage -and $null -ne $planUsage.FiveHour) {
    $sessionColor = Get-UsageColor -percent $planUsage.FiveHour
    $staleIndicator = if ($planUsage.IsStale) { "$($colors.Yellow)*" } else { "" }
    $remainingText = if ($planUsage.FiveHourRemaining) { " $($colors.Dim)($($planUsage.FiveHourRemaining) remaining)$($sessionColor)" } else { "" }
    $line2 += "$($sessionColor)5h:$($planUsage.FiveHour)%$remainingText$staleIndicator$($colors.Reset)"
}

if ($planUsage -and $null -ne $planUsage.SevenDay) {
    $weeklyColor = Get-UsageColor -percent $planUsage.SevenDay
    $staleIndicator = if ($planUsage.IsStale) { "$($colors.Yellow)*" } else { "" }
    $line2 += "$($weeklyColor)7d:$($planUsage.SevenDay)%$staleIndicator$($colors.Reset)"
}

if ($planUsage -and $planUsage.Extended) {
    # Prefer percentage over dollar amount — more meaningful
    if ($planUsage.ExtendedUsage) {
        $extColor = Get-UsageColor -percent $planUsage.ExtendedUsage
        $line2 += "$($extColor)EXT:$($planUsage.ExtendedUsage)%$($colors.Reset)"
    } elseif ($null -ne $planUsage.ExtendedCost) {
        $extCost = '$' + ([math]::Round($planUsage.ExtendedCost, 2)).ToString("F2")
        $line2 += "$($colors.Orange)EXT:$extCost$($colors.Reset)"
    } else {
        $line2 += "$($colors.Orange)EXT$($colors.Reset)"
    }
}

# Join each line with separators, output on two lines
$statusLine1 = $line1 -join $sep
$statusLine2 = $line2 -join $sep
Write-Host "$statusLine1`n$statusLine2" -NoNewline
