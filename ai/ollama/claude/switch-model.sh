#!/bin/bash

# Claude Model Switcher - Simplified version
# Usage: ./switch-model.sh [profile]

SETTINGS_FILE="$HOME/.claude/settings.json"
BACKUP_DIR="$HOME/.claude/backups"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

print_success() { echo -e "${GREEN}✅ $1${NC}"; }
print_error() { echo -e "${RED}❌ $1${NC}"; }
print_info() { echo -e "${BLUE}💡 $1${NC}"; }
print_current() { echo -e "${CYAN}📍 $1${NC}"; }

# Create backup
backup_settings() {
    if [ -f "$SETTINGS_FILE" ]; then
        local timestamp=$(date +"%Y%m%d_%H%M%S")
        mkdir -p "$BACKUP_DIR"
        cp "$SETTINGS_FILE" "$BACKUP_DIR/settings_${timestamp}.json"
        print_success "Settings backed up to: settings_${timestamp}.json"
    fi
}

# Update settings.json with specific configuration
update_settings() {
    local base_url="$1"
    local sonnet_model="$2"
    local haiku_model="$3"
    local opus_model="$4"

    backup_settings

    # Get existing auth token or use default
    local auth_token="3d21c6037f2c49a4bd6aa74b0083596b.gp7y0fabEpuBbsXX"
    if [ -f "$SETTINGS_FILE" ]; then
        auth_token=$(grep "ANTHROPIC_AUTH_TOKEN" "$SETTINGS_FILE" 2>/dev/null | cut -d'"' -f4)
        if [ -z "$auth_token" ]; then
            auth_token="3d21c6037f2c49a4bd6aa74b0083596b.gp7y0fabEpuBbsXX"
        fi
    fi

    # Create new settings with dynamic values
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

    print_success "Settings updated successfully"
}

# Switch functions
switch_to_claude_native() {
    print_info "Switching to Claude Native models..."

    # Backup existing settings before deleting
    backup_settings

    # Delete settings.json to use Claude's native configuration
    if [ -f "$SETTINGS_FILE" ]; then
        rm "$SETTINGS_FILE"
        print_success "Removed settings.json - using Claude native configuration"
    fi

    print_current "Using Claude native models (no custom configuration)"
}

switch_to_glm_override() {
    print_info "Switching to GLM Override models..."
    update_settings \
        "https://api.z.ai/api/anthropic" \
        "glm-4.6" \
        "glm-4.5-air" \
        "glm-4.6"
    print_current "Sonnet: glm-4.6, Haiku: glm-4.5-air"
}

switch_to_mixed() {
    print_info "Switching to Mixed mode (Claude Sonnet + GLM Haiku)..."
    update_settings \
        "https://api.z.ai/api/anthropic" \
        "claude-sonnet-4-5-20250929" \
        "glm-4.5-air" \
        "glm-4.6"
    print_current "Sonnet: claude-sonnet-4-5-20250929, Haiku: glm-4.5-air"
}

switch_to_claude_fast() {
    print_info "Switching to Claude Fast mode (Haiku for everything)..."
    update_settings \
        "https://api.anthropic.com" \
        "claude-haiku-3-5-20241022" \
        "claude-haiku-3-5-20241022" \
        "claude-haiku-3-5-20241022"
    print_current "All models: claude-haiku-3-5-20241022"
}

switch_to_glm_fast() {
    print_info "Switching to GLM Fast mode (GLM-4.5-air for everything)..."
    update_settings \
        "https://api.z.ai/api/anthropic" \
        "glm-4.5-air" \
        "glm-4.5-air" \
        "glm-4.5-air"
    print_current "All models: glm-4.5-air"
}

show_status() {
    echo "📊 Current Configuration:"
    if [ -f "$SETTINGS_FILE" ]; then
        local sonnet=$(grep "ANTHROPIC_DEFAULT_SONNET_MODEL" "$SETTINGS_FILE" 2>/dev/null | cut -d'"' -f4)
        local haiku=$(grep "ANTHROPIC_DEFAULT_HAIKU_MODEL" "$SETTINGS_FILE" 2>/dev/null | cut -d'"' -f4)
        local base_url=$(grep "ANTHROPIC_BASE_URL" "$SETTINGS_FILE" 2>/dev/null | cut -d'"' -f4)
        echo "🔗 URL: $base_url"
        echo "🤖 Sonnet: $sonnet"
        echo "⚡ Haiku: $haiku"

        if [[ "$base_url" == *"api.anthropic.com"* ]]; then
            if [[ "$sonnet" == *"claude-haiku"* ]]; then
                print_current "Profile: Claude Fast Mode"
            else
                print_current "Profile: Claude Native (custom config)"
            fi
        elif [[ "$base_url" == *"api.z.ai"* ]]; then
            if [[ "$sonnet" == *"claude-sonnet"* ]]; then
                print_current "Profile: Mixed Mode"
            elif [[ "$sonnet" == *"glm-4.5-air"* ]]; then
                print_current "Profile: GLM Fast Mode"
            else
                print_current "Profile: GLM Override"
            fi
        fi
    else
        print_current "Profile: Claude Native (no custom configuration)"
        echo "🔗 URL: Default Anthropic API"
        echo "🤖 Sonnet: Default Claude Sonnet"
        echo "⚡ Haiku: Default Claude Haiku"
    fi
}

show_help() {
    echo "Claude Model Switcher"
    echo "Usage: $0 [profile]"
    echo ""
    echo "Available profiles:"
    echo "  claude-native    - Claude Sonnet 4.5, Haiku, Opus (official)"
    echo "  glm-override     - GLM-4.6, GLM-4.5-air (your current config)"
    echo "  mixed            - Claude Sonnet + GLM Haiku"
    echo "  claude-fast      - Claude Haiku for everything"
    echo "  glm-fast         - GLM-4.5-air for everything"
    echo "  status           - Show current configuration"
    echo "  help             - Show this help"
    echo ""
    echo "Examples:"
    echo "  $0 claude-native"
    echo "  $0 glm-override"
    echo "  $0 mixed"
    echo "  $0 status"
}

# Main execution
case "${1:-help}" in
    "claude-native"|"claude"|"native")
        switch_to_claude_native
        ;;
    "glm-override"|"glm"|"override")
        switch_to_glm_override
        ;;
    "mixed")
        switch_to_mixed
        ;;
    "claude-fast"|"fast-claude")
        switch_to_claude_fast
        ;;
    "glm-fast"|"fast-glm")
        switch_to_glm_fast
        ;;
    "status"|"current"|"show")
        show_status
        ;;
    "help"|*)
        show_help
        ;;
esac