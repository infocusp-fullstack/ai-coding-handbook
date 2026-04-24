#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Fetches Claude Code plan usage data and caches it locally.

.DESCRIPTION
    This script fetches your Claude Pro/Max plan usage (5-hour session, 7-day weekly, and extended usage)
    from the Anthropic API and stores it in a local JSON cache file. The cache is updated at most once
    per minute unless forced.

.PARAMETER Force
    Forces an update regardless of cache age.

.PARAMETER CachePath
    Custom path for the cache file. Defaults to ~/.claude/usage-cache.json

.PARAMETER OutputPath
    If specified, writes the JSON data to this file path.
    If not specified, prints formatted output to the console.

.PARAMETER Silent
    Suppresses all output (useful when called from statusline).
    Note: If OutputPath is specified, data is still written to the file.

.EXAMPLE
    # Normal usage - prints to console
    .\Get-ClaudeUsage.ps1

.EXAMPLE
    # Force refresh and print to console
    .\Get-ClaudeUsage.ps1 -Force

.EXAMPLE
    # Write JSON to a specific file
    .\Get-ClaudeUsage.ps1 -OutputPath "C:\temp\usage.json"

.EXAMPLE
    # Force refresh and write to file
    .\Get-ClaudeUsage.ps1 -Force -OutputPath ".\my-usage.json"

.EXAMPLE
    # Silent mode for statusline integration (only updates cache)
    .\Get-ClaudeUsage.ps1 -Silent

.NOTES
    Author: Claude Code Statusline
    Requires: Claude Code credentials in ~/.claude/.credentials.json
#>

param(
    [switch]$Force,
    [string]$CachePath = (Join-Path $env:USERPROFILE ".claude\usage-cache.json"),
    [string]$OutputPath,
    [switch]$Silent
)

# Configuration
$CACHE_MAX_AGE_SECONDS = 60  # 1 minute cache

# Helper function to write output (only shows with -Verbose or errors)
function Write-Log {
    param([string]$Message, [string]$Level = "Info")
    if ($Silent) { return }
    
    # Only show errors and warnings by default, info only with -Verbose
    switch ($Level) {
        "Error"   { Write-Host "ERROR: $Message" -ForegroundColor Red }
        "Warning" { Write-Host "WARN: $Message" -ForegroundColor Yellow }
        default   { 
            # Info/Success messages only show if user wants verbose output
            if ($VerbosePreference -eq 'Continue' -or $env:CLAUDE_USAGE_VERBOSE) {
                Write-Host "$Message" -ForegroundColor Gray 
            }
        }
    }
}

# Check if cache is still valid
function Test-CacheValid {
    param([string]$Path)
    
    if (-not (Test-Path $Path)) {
        return $false
    }
    
    try {
        $cache = Get-Content $Path -Raw | ConvertFrom-Json
        $lastUpdated = if ($cache.last_updated -is [DateTime]) { $cache.last_updated } else {
            [DateTimeOffset]::Parse($cache.last_updated, [System.Globalization.CultureInfo]::InvariantCulture).LocalDateTime
        }
        $age = (Get-Date) - $lastUpdated
        
        return $age.TotalSeconds -lt $CACHE_MAX_AGE_SECONDS
    } catch {
        return $false
    }
}

# Read cached data
function Get-CachedUsage {
    param([string]$Path)
    
    if (Test-Path $Path) {
        try {
            return Get-Content $Path -Raw | ConvertFrom-Json
        } catch {
            return $null
        }
    }
    return $null
}

# Fetch usage from Anthropic API
function Get-UsageFromAPI {
    $credentialsPath = Join-Path $env:USERPROFILE ".claude\.credentials.json"
    
    if (-not (Test-Path $credentialsPath)) {
        Write-Log "Credentials file not found. Please run 'claude' and login first." "Error"
        return $null
    }
    
    try {
        $credentials = Get-Content $credentialsPath -Raw | ConvertFrom-Json
        $accessToken = $credentials.claudeAiOauth.accessToken
        
        if (-not $accessToken) {
            Write-Log "No OAuth access token found in credentials." "Error"
            return $null
        }
        
        Write-Log "Fetching usage data from Anthropic API..."
        
        # Make API request
        $headers = @{
            "Accept"          = "application/json"
            "Content-Type"    = "application/json"
            "User-Agent"      = "claude-code/2.1.0"
            "Authorization"   = "Bearer $accessToken"
            "anthropic-beta"  = "oauth-2025-04-20"
        }
        
        $response = Invoke-RestMethod -Uri "https://api.anthropic.com/api/oauth/usage" `
            -Method Get `
            -Headers $headers `
            -TimeoutSec 10 `
            -ErrorAction Stop
        
        return $response
        
    } catch {
        Write-Log "Failed to fetch usage: $($_.Exception.Message)" "Error"
        return $null
    }
}

# Format the usage data for caching
function Format-UsageData {
    param($ApiResponse)
    
    $now = Get-Date
    
    $usageData = @{
        last_updated = $now.ToString("o")  # ISO 8601 format
        last_updated_friendly = $now.ToString("yyyy-MM-dd HH:mm:ss")
        
        five_hour = $null
        seven_day = $null
        extended = $null
    }
    
    # Process 5-hour session data
    if ($ApiResponse.five_hour) {
        $resetTime = $null
        $resetFriendly = $null
        $minutesRemaining = $null
        
        if ($ApiResponse.five_hour.resets_at) {
            try {
                $resetTime = if ($ApiResponse.five_hour.resets_at -is [DateTime]) { $ApiResponse.five_hour.resets_at } else {
                    [DateTimeOffset]::Parse($ApiResponse.five_hour.resets_at, [System.Globalization.CultureInfo]::InvariantCulture).LocalDateTime
                }
                $resetFriendly = if ($resetTime.Kind -eq 'Utc') { $resetTime.ToLocalTime().ToString("HH:mm") } else { $resetTime.ToString("HH:mm") }
                $minutesRemaining = [math]::Max(0, [math]::Round(($resetTime - $now).TotalMinutes, 0))
            } catch { }
        }
        
        $usageData.five_hour = @{
            utilization = $ApiResponse.five_hour.utilization
            utilization_rounded = [math]::Round($ApiResponse.five_hour.utilization, 0)
            resets_at = $ApiResponse.five_hour.resets_at
            resets_at_friendly = $resetFriendly
            minutes_remaining = $minutesRemaining
        }
    }
    
    # Process 7-day weekly data
    if ($ApiResponse.seven_day) {
        $resetTime = $null
        $resetFriendly = $null
        $hoursRemaining = $null
        
        if ($ApiResponse.seven_day.resets_at) {
            try {
                $resetTime = if ($ApiResponse.seven_day.resets_at -is [DateTime]) { $ApiResponse.seven_day.resets_at } else {
                    [DateTimeOffset]::Parse($ApiResponse.seven_day.resets_at, [System.Globalization.CultureInfo]::InvariantCulture).LocalDateTime
                }
                $resetFriendly = if ($resetTime.Kind -eq 'Utc') { $resetTime.ToLocalTime().ToString("ddd HH:mm") } else { $resetTime.ToString("ddd HH:mm") }
                $hoursRemaining = [math]::Max(0, [math]::Round(($resetTime - $now).TotalHours, 1))
            } catch { }
        }
        
        $usageData.seven_day = @{
            utilization = $ApiResponse.seven_day.utilization
            utilization_rounded = [math]::Round($ApiResponse.seven_day.utilization, 0)
            resets_at = $ApiResponse.seven_day.resets_at
            resets_at_friendly = $resetFriendly
            hours_remaining = $hoursRemaining
        }
    }
    
    # Process extended/extra usage (check multiple possible field names)
    # Anthropic uses "iguana_necktie" internally for extended usage
    $extendedData = $null
    if ($ApiResponse.iguana_necktie) {
        $extendedData = $ApiResponse.iguana_necktie
    } elseif ($ApiResponse.extended) {
        $extendedData = $ApiResponse.extended
    } elseif ($ApiResponse.extra_usage) {
        $extendedData = $ApiResponse.extra_usage
    }
    
    if ($extendedData) {
        $usageData.extended = @{
            active = $true
            utilization = if ($extendedData.utilization) { $extendedData.utilization } else { $null }
            utilization_rounded = if ($extendedData.utilization) { [math]::Round($extendedData.utilization, 0) } else { $null }
            cost_usd = if ($null -ne $extendedData.cost_usd) { $extendedData.cost_usd } elseif ($null -ne $extendedData.used_credits) { $extendedData.used_credits } else { $null }
            raw_data = $extendedData
        }
    } else {
        $usageData.extended = @{
            active = $false
            utilization = $null
            utilization_rounded = $null
            cost_usd = $null
            raw_data = $null
        }
    }
    
    # Include raw response for debugging
    $usageData.raw_response = $ApiResponse
    
    return $usageData
}

# Save cache to file
function Save-Cache {
    param($Data, [string]$Path)
    
    try {
        # Ensure directory exists
        $dir = Split-Path $Path -Parent
        if (-not (Test-Path $dir)) {
            New-Item -ItemType Directory -Path $dir -Force | Out-Null
        }
        
        $json = $Data | ConvertTo-Json -Depth 10
        Set-Content -Path $Path -Value $json -Encoding UTF8
        
        Write-Log "Cache saved to: $Path"
        return $true
    } catch {
        Write-Log "Failed to save cache: $($_.Exception.Message)" "Error"
        return $false
    }
}

# Write data to output file
function Write-OutputFile {
    param($Data, [string]$Path)
    
    try {
        # Ensure directory exists
        $dir = Split-Path $Path -Parent
        if ($dir -and -not (Test-Path $dir)) {
            New-Item -ItemType Directory -Path $dir -Force | Out-Null
        }
        
        $json = $Data | ConvertTo-Json -Depth 10
        Set-Content -Path $Path -Value $json -Encoding UTF8
        
        Write-Log "Output written to: $Path"
        return $true
    } catch {
        Write-Log "Failed to write output: $($_.Exception.Message)" "Error"
        return $false
    }
}

# Print formatted usage to console
function Write-UsageToConsole {
    param($Data)
    
    Write-Host ""
    Write-Host "Current Usage:" -ForegroundColor White
    
    if ($Data.five_hour) {
        $color = if ($Data.five_hour.utilization_rounded -lt 40) { "Green" } 
                 elseif ($Data.five_hour.utilization_rounded -lt 60) { "Yellow" }
                 elseif ($Data.five_hour.utilization_rounded -lt 80) { "DarkYellow" }
                 else { "Red" }
        
        $resetInfo = if ($Data.five_hour.resets_at_friendly) { " (resets at $($Data.five_hour.resets_at_friendly))" } else { "" }
        $minRemaining = if ($Data.five_hour.minutes_remaining) { " [$($Data.five_hour.minutes_remaining) min remaining]" } else { "" }
        
        Write-Host "  5-hour session: " -NoNewline
        Write-Host "$($Data.five_hour.utilization_rounded)%" -ForegroundColor $color -NoNewline
        Write-Host "$resetInfo$minRemaining" -ForegroundColor Gray
    }
    
    if ($Data.seven_day) {
        $color = if ($Data.seven_day.utilization_rounded -lt 40) { "Green" } 
                 elseif ($Data.seven_day.utilization_rounded -lt 60) { "Yellow" }
                 elseif ($Data.seven_day.utilization_rounded -lt 80) { "DarkYellow" }
                 else { "Red" }
        
        $resetInfo = if ($Data.seven_day.resets_at_friendly) { " (resets $($Data.seven_day.resets_at_friendly))" } else { "" }
        $hoursRemaining = if ($Data.seven_day.hours_remaining) { " [$($Data.seven_day.hours_remaining) hrs remaining]" } else { "" }
        
        Write-Host "  7-day weekly:   " -NoNewline
        Write-Host "$($Data.seven_day.utilization_rounded)%" -ForegroundColor $color -NoNewline
        Write-Host "$resetInfo$hoursRemaining" -ForegroundColor Gray
    }
    
    if ($Data.extended -and $Data.extended.active) {
        Write-Host ""
        Write-Host "  Extended Usage: " -NoNewline
        Write-Host "ACTIVE" -ForegroundColor Yellow -NoNewline
        Write-Host " (extra credits enabled)" -ForegroundColor Gray
        
        if ($Data.extended.utilization_rounded) {
            Write-Host "    Usage:        " -NoNewline
            Write-Host "$($Data.extended.utilization_rounded)%" -ForegroundColor Cyan
        }
        if ($Data.extended.cost_usd) {
            Write-Host "    Cost:         " -NoNewline
            Write-Host "`$$($Data.extended.cost_usd)" -ForegroundColor Cyan
        }
    }
    
    Write-Host ""
    Write-Host "Last updated: $($Data.last_updated_friendly)" -ForegroundColor DarkGray
}

# Main execution
function Main {
    Write-Log "Claude Usage Cache Script"
    Write-Log "Cache path: $CachePath"
    
    # Check if we need to update
    $needsUpdate = $Force -or (-not (Test-CacheValid -Path $CachePath))
    
    if (-not $needsUpdate) {
        $cache = Get-CachedUsage -Path $CachePath
        Write-Log "Cache is still valid (updated: $($cache.last_updated_friendly))"
        
        # Handle output
        if ($OutputPath) {
            Write-OutputFile -Data $cache -Path $OutputPath
        } elseif (-not $Silent) {
            Write-UsageToConsole -Data $cache
        }
        
        return $cache
    }
    
    if ($Force) {
        Write-Log "Force update requested"
    } else {
        Write-Log "Cache expired or missing, fetching new data..."
    }
    
    # Fetch from API
    $apiResponse = Get-UsageFromAPI
    
    if (-not $apiResponse) {
        # Error already logged in Get-UsageFromAPI
        
        # Return stale cache if available
        $staleCache = Get-CachedUsage -Path $CachePath
        if ($staleCache) {
            Write-Log "Returning stale cache data" "Warning"
            
            # Handle output with stale data
            if ($OutputPath) {
                Write-OutputFile -Data $staleCache -Path $OutputPath
            } elseif (-not $Silent) {
                Write-UsageToConsole -Data $staleCache
                Write-Host "  (Data may be stale)" -ForegroundColor DarkYellow
            }
            
            return $staleCache
        }
        return $null
    }
    
    # Format and save to cache
    $usageData = Format-UsageData -ApiResponse $apiResponse
    Save-Cache -Data $usageData -Path $CachePath | Out-Null
    
    # Handle output
    if ($OutputPath) {
        Write-OutputFile -Data $usageData -Path $OutputPath
    } elseif (-not $Silent) {
        Write-UsageToConsole -Data $usageData
    }
    
    return $usageData
}

# Run main and return result
$result = Main
return $result
