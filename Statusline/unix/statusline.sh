#!/usr/bin/env bash
# Claude Code Status Line Script — Bash port (Linux/macOS)
# Pure Bash + jq/curl/git. No external runtime deps beyond standard tools.
#
# Line 1: RepoName | Branch ±changes | [Model]
# Line 2: Context% | Session% (remaining) | Weekly% | Extended
# Colors: light blue, lavender, cyan, dynamic green/yellow/orange/red

set -o pipefail

# --- Read JSON from stdin (Claude Code passes its session payload here) ---
json=$(cat)
if [ -z "$json" ]; then
    printf 'Error: no JSON on stdin' >&2
    exit 1
fi

# --- ANSI color codes (256-color palette, cool tones) ---
RESET=$'\e[0m'
LIGHT_BLUE=$'\e[38;5;117m'
LAVENDER=$'\e[38;5;183m'
CYAN=$'\e[38;5;159m'
GREEN=$'\e[38;5;120m'
YELLOW=$'\e[38;5;229m'
ORANGE=$'\e[38;5;216m'
RED=$'\e[38;5;210m'
DIM=$'\e[38;5;245m'

OS=$(uname -s)

# --- Date helpers (GNU vs BSD difference) ---
# Parse ISO-8601 string to epoch seconds
parse_iso_to_epoch() {
    local iso=$1
    [ -z "$iso" ] && return 1
    if [ "$OS" = "Darwin" ]; then
        # BSD date needs a fixed format. Normalize: strip fractional seconds,
        # turn "Z" into "+0000", and drop the colon in "+00:00" offsets.
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

# --- Pull values out of the JSON with jq ---
model=$(printf '%s' "$json" | jq -r '.model.display_name // "Unknown"')
current_dir=$(printf '%s' "$json" | jq -r '.workspace.current_dir // empty')
[ -z "$current_dir" ] && current_dir="$PWD"

# Context percent: prefer used_percentage, else compute from tokens / window size
context_percent=$(printf '%s' "$json" | jq -r '
    if (.context_window.used_percentage // null) != null then
        (.context_window.used_percentage | round)
    elif ((.context_window.context_window_size // 0) > 0) then
        ((((.context_window.total_input_tokens // 0)
          + (.context_window.total_output_tokens // 0)) * 100)
         / .context_window.context_window_size) | round
    else 0 end
')
# Guard against non-numeric (jq should always return a number here, but be safe)
case "$context_percent" in
    ''|*[!0-9]*) context_percent=0 ;;
esac

# --- Color threshold helper (<40 green, <60 yellow, <80 orange, else red) ---
usage_color() {
    local pct=$1
    if   [ "$pct" -lt 40 ]; then printf '%s' "$GREEN"
    elif [ "$pct" -lt 60 ]; then printf '%s' "$YELLOW"
    elif [ "$pct" -lt 80 ]; then printf '%s' "$ORANGE"
    else                         printf '%s' "$RED"
    fi
}

# --- Plan usage (5h / 7d / extended) from cache, with background refresh ---
# Mirrors the PowerShell version: statusline must be fast, so we read a cache file
# and fire off the fetcher in the background if the cache is >2 min old.
read_plan_usage() {
    FIVE_HOUR=""
    SEVEN_DAY=""
    FIVE_HOUR_REMAINING=""
    EXTENDED_ACTIVE="false"
    EXTENDED_USAGE=""
    EXTENDED_COST=""
    IS_STALE=0

    local claude_dir="$HOME/.claude"
    local cache_path="$claude_dir/usage-cache.json"
    local usage_script="$claude_dir/get-claude-usage.sh"

    # Decide whether to kick off a background refresh (>2 min old, or missing)
    local needs_refresh=0
    if [ ! -f "$cache_path" ]; then
        needs_refresh=1
    else
        local mtime
        if [ "$OS" = "Darwin" ]; then
            mtime=$(stat -f %m "$cache_path" 2>/dev/null)
        else
            mtime=$(stat -c %Y "$cache_path" 2>/dev/null)
        fi
        if [ -n "$mtime" ]; then
            local age=$(( $(date +%s) - mtime ))
            [ "$age" -gt 120 ] && needs_refresh=1
        fi
    fi

    if [ "$needs_refresh" -eq 1 ] && [ -x "$usage_script" ]; then
        # Detach fully: nohup + background + redirect both streams
        nohup "$usage_script" --silent >/dev/null 2>&1 &
        disown 2>/dev/null || true
    fi

    [ ! -f "$cache_path" ] && return

    local cache
    cache=$(cat "$cache_path" 2>/dev/null) || return
    [ -z "$cache" ] && return

    # Staleness: >5 min since cache last_updated
    local last_updated
    last_updated=$(printf '%s' "$cache" | jq -r '.last_updated // empty')
    if [ -n "$last_updated" ]; then
        local ts
        ts=$(parse_iso_to_epoch "$last_updated")
        if [ -n "$ts" ]; then
            local age=$(( $(date +%s) - ts ))
            [ "$age" -gt 300 ] && IS_STALE=1
        fi
    fi

    FIVE_HOUR=$(printf '%s' "$cache" | jq -r '.five_hour.utilization_rounded // empty')
    SEVEN_DAY=$(printf '%s' "$cache" | jq -r '.seven_day.utilization_rounded // empty')
    EXTENDED_ACTIVE=$(printf '%s' "$cache" | jq -r '.extended.active // false')
    EXTENDED_USAGE=$(printf '%s' "$cache" | jq -r '.extended.utilization_rounded // empty')
    EXTENDED_COST=$(printf '%s' "$cache" | jq -r '.extended.cost_usd // empty')

    # PowerShell writes [math]::Round(...) as a Double (e.g. "13.0"). bash -lt
    # can't compare floats, so strip anything after a decimal point. Works for
    # ints ("13" -> "13"), floats ("13.0" -> "13"), empty ("" -> "").
    FIVE_HOUR=${FIVE_HOUR%%.*}
    SEVEN_DAY=${SEVEN_DAY%%.*}
    EXTENDED_USAGE=${EXTENDED_USAGE%%.*}

    # Compute remaining time until 5h reset (e.g. "2h13m" or "47m")
    local resets_at
    resets_at=$(printf '%s' "$cache" | jq -r '.five_hour.resets_at // empty')
    if [ -n "$resets_at" ]; then
        local reset_ts
        reset_ts=$(parse_iso_to_epoch "$resets_at")
        if [ -n "$reset_ts" ]; then
            local rem=$(( reset_ts - $(date +%s) ))
            if [ "$rem" -gt 0 ]; then
                local hours=$(( rem / 3600 ))
                local mins=$(( (rem % 3600) / 60 ))
                if [ "$hours" -gt 0 ]; then
                    FIVE_HOUR_REMAINING="${hours}h${mins}m"
                else
                    FIVE_HOUR_REMAINING="${mins}m"
                fi
            fi
        fi
    fi
}

# --- Git info: repo name (parent/leaf), branch, change counts ---
read_git_info() {
    local dir=$1
    REPO_NAME=""
    BRANCH=""
    CHANGES=""

    local repo_root
    repo_root=$(git -C "$dir" rev-parse --show-toplevel 2>/dev/null)

    if [ -z "$repo_root" ]; then
        # Not a git repo — fall back to "parent/leaf" of the current dir
        local parent leaf
        parent=$(basename "$(dirname "$dir")")
        leaf=$(basename "$dir")
        REPO_NAME="$parent/$leaf"
        return
    fi

    local parent leaf
    parent=$(basename "$(dirname "$repo_root")")
    leaf=$(basename "$repo_root")
    REPO_NAME="$parent/$leaf"

    # Branch: symbolic-ref for normal HEAD, short hash for detached
    BRANCH=$(git -C "$repo_root" symbolic-ref --short HEAD 2>/dev/null)
    if [ -z "$BRANCH" ]; then
        BRANCH=$(git -C "$repo_root" rev-parse --short HEAD 2>/dev/null)
    fi

    # Change counts — numstat gives one line per file, no porcelain parsing needed
    local staged unstaged untracked
    staged=$(git -C "$repo_root" diff --cached --numstat 2>/dev/null | wc -l | tr -d ' ')
    unstaged=$(git -C "$repo_root" diff --numstat 2>/dev/null | wc -l | tr -d ' ')
    untracked=$(git -C "$repo_root" ls-files --others --exclude-standard 2>/dev/null | wc -l | tr -d ' ')

    local parts=""
    [ "$staged" -gt 0 ]    && parts="+$staged"
    [ "$unstaged" -gt 0 ]  && parts="${parts:+$parts }~$unstaged"
    [ "$untracked" -gt 0 ] && parts="${parts:+$parts }?$untracked"
    [ -n "$parts" ] && CHANGES=" $parts"
}

# --- Strip "Claude " prefix from model name ---
short_model=${model#Claude }
short_model=${short_model# }  # trim a leading space if any

read_git_info "$current_dir"
read_plan_usage

ctx_color=$(usage_color "$context_percent")
sep="${DIM} | ${RESET}"

# --- Line 1: repo | branch+changes | [model] ---
line1="${LIGHT_BLUE}${REPO_NAME}${RESET}"
if [ -n "$BRANCH" ]; then
    line1="${line1}${sep}${LAVENDER}${BRANCH}${CHANGES}${RESET}"
fi
line1="${line1}${sep}${CYAN}[${short_model}]${RESET}"

# --- Line 2: Ctx | 5h (remaining) | 7d | EXT ---
line2="${ctx_color}Ctx:${context_percent}%${RESET}"

if [ -n "$FIVE_HOUR" ]; then
    sess_color=$(usage_color "$FIVE_HOUR")
    stale=""
    [ "$IS_STALE" -eq 1 ] && stale="${YELLOW}*"
    remaining=""
    if [ -n "$FIVE_HOUR_REMAINING" ]; then
        remaining=" ${DIM}(${FIVE_HOUR_REMAINING} remaining)${sess_color}"
    fi
    line2="${line2}${sep}${sess_color}5h:${FIVE_HOUR}%${remaining}${stale}${RESET}"
fi

if [ -n "$SEVEN_DAY" ]; then
    wk_color=$(usage_color "$SEVEN_DAY")
    stale=""
    [ "$IS_STALE" -eq 1 ] && stale="${YELLOW}*"
    line2="${line2}${sep}${wk_color}7d:${SEVEN_DAY}%${stale}${RESET}"
fi

if [ "$EXTENDED_ACTIVE" = "true" ]; then
    if [ -n "$EXTENDED_USAGE" ]; then
        ext_color=$(usage_color "$EXTENDED_USAGE")
        line2="${line2}${sep}${ext_color}EXT:${EXTENDED_USAGE}%${RESET}"
    elif [ -n "$EXTENDED_COST" ]; then
        ext_cost=$(awk -v c="$EXTENDED_COST" 'BEGIN{printf "$%.2f", c}')
        line2="${line2}${sep}${ORANGE}EXT:${ext_cost}${RESET}"
    else
        line2="${line2}${sep}${ORANGE}EXT${RESET}"
    fi
fi

# Two lines, no trailing newline (Claude Code handles spacing itself)
printf '%s\n%s' "$line1" "$line2"
