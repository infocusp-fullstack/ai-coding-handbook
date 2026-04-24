#!/usr/bin/env bash
# Fetch Claude Code plan usage (5-hour / 7-day / extended) from Anthropic's
# OAuth usage endpoint and cache it locally. Mirrors Get-ClaudeUsage.ps1.
#
# Usage:
#   ./get-claude-usage.sh                # print usage, refresh cache if stale
#   ./get-claude-usage.sh --force        # ignore cache, refetch
#   ./get-claude-usage.sh --silent       # no stdout (used by statusline)
#   ./get-claude-usage.sh --output PATH  # write JSON to PATH
#
# Requires: jq, curl. Credentials from ~/.claude/.credentials.json.

set -o pipefail

FORCE=0
SILENT=0
OUTPUT_PATH=""
CACHE_PATH="${HOME}/.claude/usage-cache.json"
CACHE_MAX_AGE=60   # seconds — matches the PowerShell version

while [ $# -gt 0 ]; do
    case "$1" in
        --force|-f)   FORCE=1; shift ;;
        --silent|-s)  SILENT=1; shift ;;
        --output|-o)  OUTPUT_PATH="$2"; shift 2 ;;
        --cache)      CACHE_PATH="$2"; shift 2 ;;
        -h|--help)
            sed -n '2,13p' "$0"
            exit 0
            ;;
        *) shift ;;
    esac
done

OS=$(uname -s)

log() {
    local level="${2:-info}"
    [ "$SILENT" -eq 1 ] && return
    case "$level" in
        error) printf 'ERROR: %s\n' "$1" >&2 ;;
        warn)  printf 'WARN: %s\n'  "$1" >&2 ;;
        *)     [ -n "${CLAUDE_USAGE_VERBOSE:-}" ] && printf '%s\n' "$1" >&2 ;;
    esac
}

# --- Portable date helpers ---
parse_iso_to_epoch() {
    local iso=$1
    [ -z "$iso" ] && return 1
    if [ "$OS" = "Darwin" ]; then
        local clean
        clean=$(printf '%s' "$iso" \
            | sed -E 's/\.[0-9]+//' \
            | sed -E 's/Z$/+0000/' \
            | sed -E 's/([+-][0-9]{2}):([0-9]{2})$/\1\2/')
        date -j -f "%Y-%m-%dT%H:%M:%S%z" "$clean" +%s 2>/dev/null
    else
        date -d "$iso" +%s 2>/dev/null
    fi
}

format_epoch() {
    # Format an epoch in local time using a strftime pattern.
    local ts=$1 fmt=$2
    if [ "$OS" = "Darwin" ]; then
        date -r "$ts" "+$fmt"
    else
        date -d "@$ts" "+$fmt"
    fi
}

# --- Cache validity ---
cache_is_fresh() {
    [ ! -f "$CACHE_PATH" ] && return 1
    local last
    last=$(jq -r '.last_updated // empty' < "$CACHE_PATH" 2>/dev/null) || return 1
    [ -z "$last" ] && return 1
    local ts
    ts=$(parse_iso_to_epoch "$last") || return 1
    [ -z "$ts" ] && return 1
    local age=$(( $(date +%s) - ts ))
    [ "$age" -lt "$CACHE_MAX_AGE" ]
}

# --- Fetch from Anthropic's OAuth usage API ---
fetch_usage() {
    local creds="${HOME}/.claude/.credentials.json"
    if [ ! -f "$creds" ]; then
        log "Credentials file not found. Please run 'claude' and login first." error
        return 1
    fi

    local token
    token=$(jq -r '.claudeAiOauth.accessToken // empty' < "$creds")
    if [ -z "$token" ] || [ "$token" = "null" ]; then
        log "No OAuth access token found in credentials." error
        return 1
    fi

    log "Fetching usage data from Anthropic API..."

    # anthropic-beta: oauth-2025-04-20 is required for OAuth access.
    # User-Agent claude-code/2.1.0 mirrors the PowerShell version.
    local response http_code body
    response=$(curl -sS --max-time 10 \
        -w '\n%{http_code}' \
        -H 'Accept: application/json' \
        -H 'Content-Type: application/json' \
        -H 'User-Agent: claude-code/2.1.0' \
        -H "Authorization: Bearer $token" \
        -H 'anthropic-beta: oauth-2025-04-20' \
        'https://api.anthropic.com/api/oauth/usage' 2>/dev/null)

    if [ -z "$response" ]; then
        log "No response from Anthropic API" error
        return 1
    fi

    http_code=$(printf '%s' "$response" | tail -n1)
    body=$(printf '%s' "$response" | sed '$d')

    if [ "$http_code" != "200" ]; then
        log "API returned HTTP $http_code" error
        return 1
    fi

    printf '%s' "$body"
}

# --- Shape API response into the cache schema (matches PowerShell output) ---
format_usage() {
    local api="$1"
    local now_epoch now_iso now_friendly
    now_epoch=$(date +%s)
    now_iso=$(format_epoch "$now_epoch" "%Y-%m-%dT%H:%M:%SZ")
    # Override: ISO timestamp should be UTC. `format_epoch` uses local TZ; do it explicitly.
    if [ "$OS" = "Darwin" ]; then
        now_iso=$(date -u -r "$now_epoch" "+%Y-%m-%dT%H:%M:%SZ")
    else
        now_iso=$(date -u -d "@$now_epoch" "+%Y-%m-%dT%H:%M:%SZ")
    fi
    now_friendly=$(format_epoch "$now_epoch" "%Y-%m-%d %H:%M:%S")

    # Friendly/remaining for 5h and 7d are computed here (not in jq) because
    # jq has no time-zone aware strftime for arbitrary ISO strings.
    local fh_resets sd_resets
    fh_resets=$(printf '%s' "$api" | jq -r '.five_hour.resets_at // empty')
    sd_resets=$(printf '%s' "$api" | jq -r '.seven_day.resets_at // empty')

    local fh_friendly="" fh_minutes_rem=""
    if [ -n "$fh_resets" ]; then
        local ts
        ts=$(parse_iso_to_epoch "$fh_resets")
        if [ -n "$ts" ]; then
            fh_friendly=$(format_epoch "$ts" "%H:%M")
            local diff=$(( ts - now_epoch ))
            [ "$diff" -lt 0 ] && diff=0
            fh_minutes_rem=$(( diff / 60 ))
        fi
    fi

    local sd_friendly="" sd_hours_rem=""
    if [ -n "$sd_resets" ]; then
        local ts
        ts=$(parse_iso_to_epoch "$sd_resets")
        if [ -n "$ts" ]; then
            sd_friendly=$(format_epoch "$ts" "%a %H:%M")
            local diff=$(( ts - now_epoch ))
            [ "$diff" -lt 0 ] && diff=0
            sd_hours_rem=$(awk -v d="$diff" 'BEGIN{printf "%.1f", d/3600}')
        fi
    fi

    # Assemble the shape. Extended usage may appear under any of three keys
    # (Anthropic uses "iguana_necktie" internally).
    printf '%s' "$api" | jq \
        --arg last_updated          "$now_iso" \
        --arg last_updated_friendly "$now_friendly" \
        --arg fh_friendly           "$fh_friendly" \
        --arg fh_minutes_rem        "$fh_minutes_rem" \
        --arg sd_friendly           "$sd_friendly" \
        --arg sd_hours_rem          "$sd_hours_rem" \
        '
        . as $api |
        {
          last_updated:          $last_updated,
          last_updated_friendly: $last_updated_friendly,
          five_hour: (
            if .five_hour then {
              utilization:         .five_hour.utilization,
              utilization_rounded: (.five_hour.utilization | round),
              resets_at:           .five_hour.resets_at,
              resets_at_friendly:  (if $fh_friendly    == "" then null else $fh_friendly end),
              minutes_remaining:   (if $fh_minutes_rem == "" then null else ($fh_minutes_rem | tonumber) end)
            } else null end
          ),
          seven_day: (
            if .seven_day then {
              utilization:         .seven_day.utilization,
              utilization_rounded: (.seven_day.utilization | round),
              resets_at:           .seven_day.resets_at,
              resets_at_friendly:  (if $sd_friendly   == "" then null else $sd_friendly end),
              hours_remaining:     (if $sd_hours_rem  == "" then null else ($sd_hours_rem | tonumber) end)
            } else null end
          ),
          extended: (
            (.iguana_necktie // .extended // .extra_usage) as $ext |
            if $ext then {
              active: true,
              utilization:         $ext.utilization,
              utilization_rounded: (if $ext.utilization then ($ext.utilization | round) else null end),
              cost_usd:            ($ext.cost_usd // $ext.used_credits),
              raw_data:            $ext
            } else {
              active: false,
              utilization: null,
              utilization_rounded: null,
              cost_usd: null,
              raw_data: null
            } end
          ),
          raw_response: $api
        }
        '
}

save_cache() {
    local data="$1"
    local dir
    dir=$(dirname "$CACHE_PATH")
    mkdir -p "$dir"
    printf '%s' "$data" > "$CACHE_PATH"
    log "Cache saved to: $CACHE_PATH"
}

write_output_file() {
    local data="$1"
    local dir
    dir=$(dirname "$OUTPUT_PATH")
    [ -n "$dir" ] && mkdir -p "$dir"
    printf '%s' "$data" > "$OUTPUT_PATH"
    log "Output written to: $OUTPUT_PATH"
}

# Colored terminal output for interactive runs
print_usage_to_console() {
    local data="$1"

    local C_RESET=$'\e[0m' C_WHITE=$'\e[37m' C_GRAY=$'\e[90m'
    local C_GREEN=$'\e[32m' C_YELLOW=$'\e[33m' C_ORANGE=$'\e[38;5;208m'
    local C_RED=$'\e[31m' C_CYAN=$'\e[36m'

    pct_color() {
        local p=$1
        if   [ "$p" -lt 40 ]; then printf '%s' "$C_GREEN"
        elif [ "$p" -lt 60 ]; then printf '%s' "$C_YELLOW"
        elif [ "$p" -lt 80 ]; then printf '%s' "$C_ORANGE"
        else                       printf '%s' "$C_RED"
        fi
    }

    printf '\n%sCurrent Usage:%s\n' "$C_WHITE" "$C_RESET"

    local fh_pct fh_friendly fh_min_rem
    fh_pct=$(printf '%s' "$data" | jq -r '.five_hour.utilization_rounded // empty')
    if [ -n "$fh_pct" ]; then
        fh_friendly=$(printf '%s' "$data" | jq -r '.five_hour.resets_at_friendly // empty')
        fh_min_rem=$(printf '%s' "$data" | jq -r '.five_hour.minutes_remaining // empty')
        local reset_info="" min_info=""
        [ -n "$fh_friendly" ] && reset_info=" (resets at $fh_friendly)"
        [ -n "$fh_min_rem" ] && min_info=" [${fh_min_rem} min remaining]"
        printf '  5-hour session: %s%s%%%s%s%s%s\n' \
            "$(pct_color "$fh_pct")" "$fh_pct" "$C_RESET" "$C_GRAY" "${reset_info}${min_info}" "$C_RESET"
    fi

    local sd_pct sd_friendly sd_hr_rem
    sd_pct=$(printf '%s' "$data" | jq -r '.seven_day.utilization_rounded // empty')
    if [ -n "$sd_pct" ]; then
        sd_friendly=$(printf '%s' "$data" | jq -r '.seven_day.resets_at_friendly // empty')
        sd_hr_rem=$(printf '%s' "$data" | jq -r '.seven_day.hours_remaining // empty')
        local reset_info="" hr_info=""
        [ -n "$sd_friendly" ] && reset_info=" (resets $sd_friendly)"
        [ -n "$sd_hr_rem" ] && hr_info=" [${sd_hr_rem} hrs remaining]"
        printf '  7-day weekly:   %s%s%%%s%s%s%s\n' \
            "$(pct_color "$sd_pct")" "$sd_pct" "$C_RESET" "$C_GRAY" "${reset_info}${hr_info}" "$C_RESET"
    fi

    local ext_active
    ext_active=$(printf '%s' "$data" | jq -r '.extended.active // false')
    if [ "$ext_active" = "true" ]; then
        printf '\n  Extended Usage: %sACTIVE%s %s(extra credits enabled)%s\n' \
            "$C_YELLOW" "$C_RESET" "$C_GRAY" "$C_RESET"
        local ext_pct ext_cost
        ext_pct=$(printf '%s' "$data" | jq -r '.extended.utilization_rounded // empty')
        [ -n "$ext_pct" ] && printf '    Usage:        %s%s%%%s\n' "$C_CYAN" "$ext_pct" "$C_RESET"
        ext_cost=$(printf '%s' "$data" | jq -r '.extended.cost_usd // empty')
        [ -n "$ext_cost" ] && printf '    Cost:         %s$%s%s\n' "$C_CYAN" "$ext_cost" "$C_RESET"
    fi

    local updated
    updated=$(printf '%s' "$data" | jq -r '.last_updated_friendly // empty')
    printf '\n%sLast updated: %s%s\n' "$C_GRAY" "$updated" "$C_RESET"
}

handle_output() {
    local data="$1"
    if [ -n "$OUTPUT_PATH" ]; then
        write_output_file "$data"
    elif [ "$SILENT" -ne 1 ]; then
        print_usage_to_console "$data"
    fi
}

main() {
    log "Claude Usage Cache Script"
    log "Cache path: $CACHE_PATH"

    if [ "$FORCE" -ne 1 ] && cache_is_fresh; then
        local cached
        cached=$(cat "$CACHE_PATH")
        log "Cache is still valid"
        handle_output "$cached"
        return 0
    fi

    [ "$FORCE" -eq 1 ] && log "Force update requested" || log "Cache expired or missing, fetching new data..."

    local api_response
    api_response=$(fetch_usage)

    if [ -z "$api_response" ]; then
        # API failed — fall back to stale cache if any
        if [ -f "$CACHE_PATH" ]; then
            log "Returning stale cache data" warn
            handle_output "$(cat "$CACHE_PATH")"
            return 0
        fi
        return 1
    fi

    local formatted
    formatted=$(format_usage "$api_response")
    if [ -z "$formatted" ]; then
        log "Failed to format API response" error
        return 1
    fi

    save_cache "$formatted"
    handle_output "$formatted"
}

main
