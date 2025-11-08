#!/bin/bash

# Enhanced Claude Model Switcher
# Handles both native Claude (web auth) and API-based models
# Usage: ./switch-model-enhanced.sh [profile]

set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Configuration
SETTINGS_FILE="$HOME/.claude/settings.json"
BACKUP_DIR="$HOME/.claude/backups"
AUTH_TOKEN_FILE="$HOME/.claude/.auth-token"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# Print functions
print_success() { echo -e "${GREEN}✅ $1${NC}"; }
print_error() { echo -e "${RED}❌ $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
print_info() { echo -e "${BLUE}💡 $1${NC}"; }
print_current() { echo -e "${CYAN}${BOLD}📍 $1${NC}"; }
print_header() { echo -e "${BOLD}${BLUE}$1${NC}"; }

# Ensure directories exist
ensure_dirs() {
    mkdir -p "$BACKUP_DIR"
    mkdir -p "$(dirname "$SETTINGS_FILE")"
}

# Validate dependencies
check_dependencies() {
    if ! command -v jq &> /dev/null; then
        print_warning "jq not found. JSON parsing will be less robust."
    fi
}

# Create backup of settings
backup_settings() {
    if [ -f "$SETTINGS_FILE" ]; then
        local timestamp=$(date +"%Y%m%d_%H%M%S")
        local backup_file="$BACKUP_DIR/settings_${timestamp}.json"
        cp "$SETTINGS_FILE" "$backup_file"
        print_success "Settings backed up to: $(basename "$backup_file")"
    fi
}

# Get stored auth token
get_auth_token() {
    # Try to get from existing settings first
    if [ -f "$SETTINGS_FILE" ] && command -v jq &> /dev/null; then
        jq -r '.env.ANTHROPIC_AUTH_TOKEN // empty' "$SETTINGS_FILE" 2>/dev/null
    elif [ -f "$SETTINGS_FILE" ]; then
        grep "ANTHROPIC_AUTH_TOKEN" "$SETTINGS_FILE" 2>/dev/null | cut -d'"' -f4 | head -1
    elif [ -f "$AUTH_TOKEN_FILE" ]; then
        cat "$AUTH_TOKEN_FILE"
    else
        echo "3d21c6037f2c49a4bd6aa74b0083596b.gp7y0fabEpuBbsXX"
    fi
}

# Store auth token for later use
store_auth_token() {
    local token="$1"
    if [ -n "$token" ] && [ "$token" != "null" ]; then
        echo "$token" > "$AUTH_TOKEN_FILE"
        chmod 600 "$AUTH_TOKEN_FILE"
    fi
}

# Create API settings configuration
create_api_settings() {
    local base_url="$1"
    local sonnet_model="$2"
    local haiku_model="$3"
    local opus_model="$4"
    local auth_token="$5"

    ensure_dirs
    backup_settings

    # Store auth token for future use
    store_auth_token "$auth_token"

    # Create new settings with proper JSON formatting
    if command -v jq &> /dev/null; then
        jq -n --arg token "$auth_token" \
           --arg url "$base_url" \
           --arg sonnet "$sonnet_model" \
           --arg haiku "$haiku_model" \
           --arg opus "$opus_model" '{
            "env": {
                "ANTHROPIC_AUTH_TOKEN": $token,
                "ANTHROPIC_BASE_URL": $url,
                "API_TIMEOUT_MS": "3000000",
                "ANTHROPIC_DEFAULT_HAIKU_MODEL": $haiku,
                "ANTHROPIC_DEFAULT_SONNET_MODEL": $sonnet,
                "ANTHROPIC_DEFAULT_OPUS_MODEL": $opus
            }
        }' > "$SETTINGS_FILE"
    else
        # Fallback without jq
        cat > "$SETTINGS_FILE" << EOF
{
    "env": {
        "ANTHROPIC_AUTH_TOKEN": "$auth_token",
        "ANTHROPIC_BASE_URL": "$base_url",
        "API_TIMEOUT_MS": "3000000",
        "ANTHROPIC_DEFAULT_HAIKU_MODEL": "$haiku_model",
        "ANTHROPIC_DEFAULT_SONNET_MODEL": "$sonnet_model",
        "ANTHROPIC_DEFAULT_OPUS_MODEL": "$opus_model"
    }
}
EOF
    fi

    chmod 600 "$SETTINGS_FILE"
    print_success "API settings configured successfully"
}

# Switch to native Claude (remove settings.json for web auth)
switch_to_native() {
    print_header "🔗 Switching to Claude Native (Web Authentication)"

    if [ -f "$SETTINGS_FILE" ]; then
        # Extract and store auth token before deleting
        local current_token=$(get_auth_token)
        store_auth_token "$current_token"

        backup_settings
        rm "$SETTINGS_FILE"
        print_success "Removed settings.json - Claude will use web authentication"
    else
        print_info "No settings.json found - already using native web authentication"
    fi

    print_current "Mode: Claude Native (Web Auth)"
    echo "   • Authentication: Web-based (run '/login' in Claude if prompted)"
    echo "   • Models: Default Claude models"
    echo "   • Configuration: No custom settings applied"
}

# API-based switch functions
switch_to_glm_override() {
    print_header "🤖 Switching to GLM Override"
    local auth_token=$(get_auth_token)
    create_api_settings \
        "https://api.z.ai/api/anthropic" \
        "glm-4.6" \
        "glm-4.5-air" \
        "glm-4.6" \
        "$auth_token"
    print_current "Mode: GLM Override"
    echo "   • Sonnet: glm-4.6"
    echo "   • Haiku: glm-4.5-air"
    echo "   • Opus: glm-4.6"
}

switch_to_mixed() {
    print_header "🔀 Switching to Mixed Mode"
    local auth_token=$(get_auth_token)
    create_api_settings \
        "https://api.z.ai/api/anthropic" \
        "claude-sonnet-4-5-20250929" \
        "glm-4.5-air" \
        "glm-4.6" \
        "$auth_token"
    print_current "Mode: Mixed (Claude Sonnet + GLM Haiku)"
    echo "   • Sonnet: claude-sonnet-4-5-20250929"
    echo "   • Haiku: glm-4.5-air"
    echo "   • Opus: glm-4.6"
}

switch_to_claude_fast() {
    print_header "⚡ Switching to Claude Fast Mode"
    local auth_token=$(get_auth_token)
    create_api_settings \
        "https://api.anthropic.com" \
        "claude-haiku-3-5-20241022" \
        "claude-haiku-3-5-20241022" \
        "claude-haiku-3-5-20241022" \
        "$auth_token"
    print_current "Mode: Claude Fast (Haiku for everything)"
    echo "   • All models: claude-haiku-3-5-20241022"
}

switch_to_glm_fast() {
    print_header "🚀 Switching to GLM Fast Mode"
    local auth_token=$(get_auth_token)
    create_api_settings \
        "https://api.z.ai/api/anthropic" \
        "glm-4.5-air" \
        "glm-4.5-air" \
        "glm-4.5-air" \
        "$auth_token"
    print_current "Mode: GLM Fast (GLM-4.5-air for everything)"
    echo "   • All models: glm-4.5-air"
}

# Enhanced status display
show_status() {
    print_header "📊 Current Claude Configuration"

    if [ -f "$SETTINGS_FILE" ]; then
        echo "🔧 Authentication Mode: API-based (settings.json exists)"
        echo "📁 Settings File: $SETTINGS_FILE"

        # Parse settings safely
        if command -v jq &> /dev/null && jq empty "$SETTINGS_FILE" 2>/dev/null; then
            local base_url=$(jq -r '.env.ANTHROPIC_BASE_URL // "Unknown"' "$SETTINGS_FILE")
            local sonnet=$(jq -r '.env.ANTHROPIC_DEFAULT_SONNET_MODEL // "Unknown"' "$SETTINGS_FILE")
            local haiku=$(jq -r '.env.ANTHROPIC_DEFAULT_HAIKU_MODEL // "Unknown"' "$SETTINGS_FILE")
            local opus=$(jq -r '.env.ANTHROPIC_DEFAULT_OPUS_MODEL // "Unknown"' "$SETTINGS_FILE")
            local token_present=$(jq -r '.env.ANTHROPIC_AUTH_TOKEN // empty' "$SETTINGS_FILE")

            echo "🔗 Base URL: $base_url"
            echo "🤖 Sonnet: $sonnet"
            echo "⚡ Haiku: $haiku"
            echo "🎯 Opus: $opus"
            echo "🔑 Auth Token: ${token_present:+Configured}${token_present:-Missing}"

            # Determine profile
            case "$base_url" in
                *"api.anthropic.com"*)
                    if [[ "$sonnet" == *"haiku"* ]]; then
                        print_current "Profile: Claude Fast Mode"
                    else
                        print_current "Profile: Claude API (Custom)"
                    fi
                    ;;
                *"api.z.ai"*)
                    if [[ "$sonnet" == *"claude-sonnet"* ]]; then
                        print_current "Profile: Mixed Mode"
                    elif [[ "$sonnet" == *"glm-4.5-air"* ]]; then
                        print_current "Profile: GLM Fast Mode"
                    else
                        print_current "Profile: GLM Override"
                    fi
                    ;;
                *)
                    print_current "Profile: Custom API Configuration"
                    ;;
            esac
        else
            # Fallback parsing without jq
            print_warning "Could not parse settings.json (invalid JSON or jq missing)"
            local base_url=$(grep "ANTHROPIC_BASE_URL" "$SETTINGS_FILE" 2>/dev/null | cut -d'"' -f4)
            echo "🔗 Base URL: ${base_url:-Unknown}"
        fi

        # Show backup info
        local backup_count=$(find "$BACKUP_DIR" -name "settings_*.json" 2>/dev/null | wc -l)
        if [ "$backup_count" -gt 0 ]; then
            echo "💾 Backups Available: $backup_count files"
        fi

    else
        print_current "Mode: Claude Native (Web Authentication)"
        echo "🔗 Authentication: Web-based (no settings.json)"
        echo "🤖 Models: Default Claude models"
        echo "📁 Settings File: Not found (native mode)"

        # Check for stored auth token
        if [ -f "$AUTH_TOKEN_FILE" ]; then
            echo "💾 Stored auth token available for API mode switching"
        fi
    fi

    # Show last backup info
    local last_backup=$(ls -t "$BACKUP_DIR"/settings_*.json 2>/dev/null | head -1)
    if [ -n "$last_backup" ]; then
        local backup_time=$(stat -c %y "$last_backup" 2>/dev/null | cut -d' ' -f1,2 | cut -d'.' -f1)
        echo "📅 Last Backup: $backup_time"
    fi
}

# Restore from backup
restore_backup() {
    local backup_pattern="$1"
    print_header "🔄 Restoring from Backup"

    if [ -z "$backup_pattern" ]; then
        # List available backups
        echo "Available backups:"
        ls -la "$BACKUP_DIR"/settings_*.json 2>/dev/null | tail -10 || {
            print_error "No backups found"
            return 1
        }
        echo ""
        echo "Usage: $0 restore [pattern]"
        echo "Example: $0 restore 20241108_15"
        return 1
    fi

    local backup_file=$(find "$BACKUP_DIR" -name "settings_${backup_pattern}*.json" | head -1)
    if [ -z "$backup_file" ]; then
        print_error "No backup found matching pattern: $backup_pattern"
        return 1
    fi

    backup_settings  # Backup current settings first
    cp "$backup_file" "$SETTINGS_FILE"
    print_success "Restored from: $(basename "$backup_file")"
    show_status
}

# List all available profiles
list_profiles() {
    print_header "🎭 Available Profiles"
    echo ""
    echo "🔗 Native/Web Mode:"
    echo "  cc-native          - Claude native models with web authentication"
    echo ""
    echo "🤖 API-Based Modes:"
    echo "  cc-glm             - GLM-4.6 for Sonnet/Opus, GLM-4.5-air for Haiku"
    echo "  cc-mixed           - Claude Sonnet + GLM Haiku"
    echo "  fast-cc            - Claude Haiku for all models (fastest Claude)"
    echo "  fast-glm           - GLM-4.5-air for all models (fastest GLM)"
    echo ""
    echo "🔧 Management:"
    echo "  cc-status          - Show current configuration"
    echo "  restore [pattern]  - Restore from backup"
    echo "  profiles           - List all available profiles"
    echo "  help               - Show this help"
    echo ""
    echo "💡 Examples:"
    echo "  $0 cc-native"
    echo "  $0 cc-mixed"
    echo "  $0 restore 20241108_15"
}

# Show help
show_help() {
    list_profiles
}

# Validate environment
validate_environment() {
    ensure_dirs
    check_dependencies

    # Warn if settings.json has invalid JSON
    if [ -f "$SETTINGS_FILE" ] && command -v jq &> /dev/null; then
        if ! jq empty "$SETTINGS_FILE" 2>/dev/null; then
            print_warning "settings.json contains invalid JSON - consider fixing or restoring from backup"
        fi
    fi
}

# Main execution with error handling
main() {
    validate_environment

    # Ensure script is executable
    if [ ! -x "$0" ]; then
        chmod +x "$0"
        print_info "Made script executable"
    fi

    case "${1:-help}" in
        "cc-native"|"claude-native"|"native"|"web")
            switch_to_native
            ;;
        "cc-glm"|"glm-override"|"glm"|"override")
            switch_to_glm_override
            ;;
        "cc-mixed"|"mixed")
            switch_to_mixed
            ;;
        "fast-cc"|"claude-fast"|"fast-claude")
            switch_to_claude_fast
            ;;
        "fast-glm"|"glm-fast")
            switch_to_glm_fast
            ;;
        "cc-status"|"status"|"current"|"show")
            show_status
            ;;
        "restore")
            restore_backup "${2:-}"
            ;;
        "profiles"|"list")
            list_profiles
            ;;
        "help"|*)
            show_help
            ;;
    esac

    echo ""
    print_success "Operation completed successfully!"
}

# Run main function with all arguments
main "$@"