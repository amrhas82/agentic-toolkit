#!/bin/bash

################################################################################
# Claude Mode Switcher - Simplified and Clean
#
# Purpose:
#   Switch between Claude Code configuration modes with clean backup strategy
#   and API key management via .auth-token
#
# Usage:
#   cc-change                    # Interactive menu
#   cc-change <mode>             # Switch to mode
#   cc-change --status           # Show current mode
#   cc-change --list             # List available modes
#   cc-change --help             # Show help
#
# Modes:
#   cc-native      - Claude Code native (no API injection)
#   cc-glm         - GLM override
#   cc-mixed       - Claude Sonnet + GLM Haiku
#   fast-claude    - All Claude Haiku
#   fast-glm       - All GLM-4.5-air
#
################################################################################

set -euo pipefail

################################################################################
# Color and Icon Definitions
################################################################################

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
NC='\033[0m'

# Icons
SUCCESS='✅'
ERROR='❌'
INFO='ℹ️'
WARN='⚠️'
ARROW='→'
BULLET='•'
SPINNER='⟳'

################################################################################
# Global Variables
################################################################################

HOME_DIR="${HOME:?HOME env var not set}"
SETTINGS_FILE="$HOME_DIR/.claude/settings.json"
SETTINGS_LAST="$HOME_DIR/.claude/settings.json.last"
AUTH_TOKEN_FILE="$HOME_DIR/.claude/.auth-token"
SETTINGS_BACKUP_FILE="$HOME_DIR/.claude/settings.json.backup"
SWITCHER_DIR="$HOME_DIR/.claude/switcher"
PRESETS_DIR="$SWITCHER_DIR/presets/glm"
LOGS_DIR="$SWITCHER_DIR/logs"

TIMESTAMP=$(date +%Y%m%d-%H%M%S)
LOG_FILE="$LOGS_DIR/switch-${TIMESTAMP}.log"

declare -a MODES=("cc-native" "cc-glm" "cc-mixed" "fast-glm" "nomcp")

################################################################################
# Display Functions
################################################################################

print_success() {
  echo -e "${GREEN}${SUCCESS} $1${NC}"
}

print_error() {
  echo -e "${RED}${ERROR} $1${NC}"
}

print_info() {
  echo -e "${BLUE}${INFO} $1${NC}"
}

print_warning() {
  echo -e "${YELLOW}${WARN} $1${NC}"
}

print_prompt() {
  echo -e -n "${CYAN}❓ $1${NC}"
}

print_header() {
  echo ""
  echo -e "${BOLD}${CYAN}╔════════════════════════════════════════╗${NC}"
  echo -e "${BOLD}${CYAN}║  Claude Code Mode Switcher             ║${NC}"
  echo -e "${BOLD}${CYAN}╚════════════════════════════════════════╝${NC}"
  echo ""
}

print_mode_header() {
  local mode=$1
  echo -e "${BOLD}${MAGENTA}${ARROW} Switching to: ${CYAN}$mode${NC}"
  echo ""
}

################################################################################
# Logging Functions
################################################################################

log_message() {
  local message="$1"
  local level="${2:-INFO}"
  mkdir -p "$LOGS_DIR"
  local ts=$(date '+%Y-%m-%d %H:%M:%S')
  echo "[$ts] [$level] $message" >> "$LOG_FILE"
}

log_error() {
  log_message "$1" "ERROR"
}

################################################################################
# API Token Management
################################################################################

# Read API token from .auth-token file
read_api_token() {
  if [[ ! -f "$AUTH_TOKEN_FILE" ]]; then
    print_error "API token file not found: $AUTH_TOKEN_FILE"
    print_info "Run: bash install.sh install"
    return 1
  fi
  cat "$AUTH_TOKEN_FILE"
}

################################################################################
# Backup Functions
################################################################################

# Backup current settings.json (only overwrite when switching FROM native)
backup_if_from_native() {
  local last_mode=$(cat "$SETTINGS_LAST" 2>/dev/null || echo "")

  if [[ -f "$SETTINGS_FILE" ]] && [[ "$last_mode" == "cc-native" ]]; then
    cp "$SETTINGS_FILE" "$SETTINGS_BACKUP_FILE"
    chmod 644 "$SETTINGS_BACKUP_FILE"
    log_message "Updated emergency backup from native config"
  fi
}

# Restore from backup
restore_backup() {
  if [[ ! -f "$SETTINGS_BACKUP_FILE" ]]; then
    print_error "No backup file available"
    return 1
  fi

  cp "$SETTINGS_BACKUP_FILE" "$SETTINGS_FILE"
  chmod 644 "$SETTINGS_FILE"
  print_success "Restored from backup"
  return 0
}

################################################################################
# JSON Functions
################################################################################

validate_json() {
  local file="$1"
  if [[ ! -f "$file" ]]; then
    return 0
  fi
  jq empty < "$file" 2>/dev/null || return 1
}

# Remove env key from current settings
remove_env_key() {
  local settings="$1"
  echo "$settings" | jq 'del(.env)'
}

# Create env object with API token and mode config
create_env_object() {
  local api_token="$1"
  local mode="$2"

  # Read preset to get model config
  local preset_file="$PRESETS_DIR/${mode}.json"
  if [[ ! -f "$preset_file" ]]; then
    print_error "Preset not found: $preset_file"
    return 1
  fi

  local preset_env=$(jq '.env' "$preset_file")

  # Merge API token with preset env
  echo "$preset_env" | jq --arg token "$api_token" '.ANTHROPIC_AUTH_TOKEN = $token'
}

# Merge env into settings
inject_env() {
  local settings="$1"
  local env_object="$2"

  echo "$settings" | jq --argjson env "$env_object" '.env = $env'
}

################################################################################
# Mode Switching
################################################################################

switch_mode() {
  local target_mode="$1"

  # Validate mode
  local valid=0
  for mode in "${MODES[@]}"; do
    if [[ "$mode" == "$target_mode" ]]; then
      valid=1
      break
    fi
  done

  if [[ $valid -eq 0 ]]; then
    print_error "Invalid mode: $target_mode"
    return 1
  fi

  print_mode_header "$target_mode"
  log_message "Mode switch initiated: $target_mode"

  mkdir -p "$(dirname "$SETTINGS_FILE")"

  # Read current settings (or empty object if none exist)
  local current_settings="{}"
  if [[ -f "$SETTINGS_FILE" ]]; then
    current_settings=$(cat "$SETTINGS_FILE")
    if ! validate_json "$SETTINGS_FILE"; then
      print_error "Current settings.json is corrupted"
      return 1
    fi
  fi

  # Check if settings are empty (only {} or only contains env)
  local has_native_settings=$(echo "$current_settings" | jq 'del(.env) | keys | length')
  if [[ "$has_native_settings" == "0" ]]; then
    # Settings are empty or only have env - try to restore from backup
    if [[ -f "$SETTINGS_BACKUP_FILE" ]]; then
      local backup_settings=$(cat "$SETTINGS_BACKUP_FILE")
      local backup_has_native=$(echo "$backup_settings" | jq 'del(.env) | keys | length')
      if [[ "$backup_has_native" != "0" ]]; then
        print_warning "Detected empty settings, restoring native settings from backup"
        log_message "Restored native settings from backup"
        current_settings=$(echo "$backup_settings" | jq 'del(.env)')
      else
        # Backup is also empty, use minimal defaults
        print_warning "No valid settings found, using minimal defaults"
        log_message "Initialized with minimal default settings"
        current_settings='{"model":"sonnet","alwaysThinkingEnabled":false}'
      fi
    else
      # No backup, use minimal defaults
      print_warning "No settings found, using minimal defaults"
      log_message "Initialized with minimal default settings"
      current_settings='{"model":"sonnet","alwaysThinkingEnabled":false}'
    fi
  fi

  # Backup if switching FROM native
  backup_if_from_native

  # Remove old env key (in case it was restored from backup with env)
  current_settings=$(remove_env_key "$current_settings")
  log_message "Removed old env configuration"

  # If switching to cc-native, just save and done
  if [[ "$target_mode" == "cc-native" ]]; then
    echo "$current_settings" | jq '.' > "$SETTINGS_FILE"
    chmod 644 "$SETTINGS_FILE"
    echo "$target_mode" > "$SETTINGS_LAST"
    log_message "Switched to cc-native (no env injection)"
    print_success "Switched to ${CYAN}cc-native${GREEN} mode"
    return 0
  fi

  # For other modes, read API token and inject env
  local api_token
  api_token=$(read_api_token) || return 1

  # Create new env object
  local new_env
  new_env=$(create_env_object "$api_token" "$target_mode") || return 1
  log_message "Created env for mode: $target_mode"

  # Inject env into settings
  current_settings=$(inject_env "$current_settings" "$new_env")

  # Validate result
  if ! validate_json <(echo "$current_settings"); then
    print_error "Configuration validation failed"
    log_error "Invalid JSON after merge"
    return 1
  fi

  # Write to file
  echo "$current_settings" | jq '.' > "$SETTINGS_FILE"
  chmod 644 "$SETTINGS_FILE"
  echo "$target_mode" > "$SETTINGS_LAST"

  log_message "Successfully switched to: $target_mode"
  print_success "Switched to ${CYAN}$target_mode${GREEN} mode"
  echo ""

  return 0
}

# Handle nomcp mode - disable MCP servers
# Purpose: Remove installed MCP servers (vision and search) with user confirmation
# Parameters: None
# Returns: 0 always (success or user-cancelled)
# Behavior:
#   - Displays list of servers to be removed
#   - Prompts user for confirmation (y/n)
#   - If confirmed: Removes both zai-mcp-server and web-search-prime
#   - If cancelled: Returns without making changes
#   - Handles gracefully if servers not installed
#   - Logs all operations with timestamps
# Exit route: cc-change nomcp (called from main switch routing)
handle_nomcp_mode() {
  echo ""
  echo -e "${BOLD}${MAGENTA}${ARROW} Disabling MCP Servers${NC}"
  echo ""

  echo "The following MCP servers will be removed:"
  echo -e "  ${BULLET} zai-mcp-server (GLM vision)"
  echo -e "  ${BULLET} web-search-prime (GLM web search)"
  echo ""

  print_prompt "Continue with removal? (y/n): "
  read -r confirm

  if [[ ! $confirm =~ ^[Yy]$ ]]; then
    echo ""
    print_info "Removal cancelled"
    return 0
  fi

  echo ""
  log_message "Starting MCP server removal"

  # Remove vision server
  if claude mcp remove zai-mcp-server &>/dev/null; then
    print_success "Removed zai-mcp-server"
    log_message "Removed zai-mcp-server"
  else
    print_warning "zai-mcp-server not found or already removed"
    log_message "zai-mcp-server not found (already removed or never installed)"
  fi

  echo ""

  # Remove search server
  if claude mcp remove web-search-prime &>/dev/null; then
    print_success "Removed web-search-prime"
    log_message "Removed web-search-prime"
  else
    print_warning "web-search-prime not found or already removed"
    log_message "web-search-prime not found (already removed or never installed)"
  fi

  echo ""
  print_success "MCP servers disabled"
  log_message "MCP servers disabled successfully"
  echo ""
  return 0
}

################################################################################
# Display Functions
################################################################################

# Display MCP server status and management information
# Purpose: Show active MCP servers, API key status, and management options
# Parameters: None
# Returns: None (display only)
# Behavior:
#   - Checks if Claude CLI is installed
#   - Lists active MCP servers (if any configured)
#   - Displays API key configuration status
#   - Shows management commands and options
#   - Uses color coding for visual clarity (GREEN for success, YELLOW for warnings)
# Output sections:
#   1. MCP Server Status (from 'claude mcp list' output)
#   2. MCP Management options (nomcp command, mcp command in Claude)
#   3. API Key Status (configured or not)
show_mcp_status() {
  echo ""
  echo -e "${BOLD}${CYAN}MCP Server Status:${NC}"
  echo ""

  # Check if Claude CLI is available
  if ! command -v claude &>/dev/null; then
    echo -e "${YELLOW}${WARN} Claude CLI not found${NC}"
    return
  fi

  # Try to list MCP servers
  local mcp_output
  mcp_output=$(claude mcp list 2>/dev/null)

  if [ $? -eq 0 ] && [ -n "$mcp_output" ]; then
    echo -e "${GREEN}${SUCCESS} MCP servers configured:${NC}"
    echo "$mcp_output" | head -20
  else
    echo -e "${BLUE}${INFO} No MCP servers configured${NC}"
  fi

  echo ""
  echo -e "${BOLD}${CYAN}MCP Management:${NC}"
  echo -e "  ${BULLET} Disable MCP: ${CYAN}cc-change nomcp${NC}"
  echo -e "  ${BULLET} View full status: ${CYAN}claude mcp list${NC}"
  echo -e "  ${BULLET} Configure in Claude Code: ${CYAN}/mcp${NC} command"

  # Check API key status
  echo ""
  echo -e "${BOLD}${CYAN}API Key Status:${NC}"
  if [ -f "$AUTH_TOKEN_FILE" ] && [ -s "$AUTH_TOKEN_FILE" ]; then
    echo -e "${GREEN}${SUCCESS} API key is configured${NC}"
  else
    echo -e "${YELLOW}${WARN} API key not configured${NC}"
  fi

  echo ""
}

show_status() {
  echo ""
  echo -e "${BOLD}${CYAN}Current Configuration:${NC}"
  echo ""

  local current_mode=$(cat "$SETTINGS_LAST" 2>/dev/null || echo "unknown")
  echo -e "${BULLET} Current Mode: ${CYAN}${BOLD}$current_mode${NC}"

  if [[ -f "$SETTINGS_FILE" ]]; then
    local base_url=$(jq -r '.env.ANTHROPIC_BASE_URL // "none"' "$SETTINGS_FILE" 2>/dev/null || echo "none")
    local sonnet=$(jq -r '.env.ANTHROPIC_DEFAULT_SONNET_MODEL // "none"' "$SETTINGS_FILE" 2>/dev/null || echo "none")
    local haiku=$(jq -r '.env.ANTHROPIC_DEFAULT_HAIKU_MODEL // "none"' "$SETTINGS_FILE" 2>/dev/null || echo "none")

    if [[ "$current_mode" == "cc-native" ]]; then
      echo -e "${BULLET} Type: ${GREEN}Native${NC} (no API injection)"
    else
      echo -e "${BULLET} Base URL: ${YELLOW}$base_url${NC}"
      echo -e "${BULLET} Sonnet: ${YELLOW}$sonnet${NC}"
      echo -e "${BULLET} Haiku: ${YELLOW}$haiku${NC}"
    fi
  fi

  # Show MCP status
  show_mcp_status

  echo ""
}

show_list() {
  echo ""
  echo -e "${BOLD}${CYAN}Available Modes with Model Mappings:${NC}"
  echo ""
  echo -e "${BOLD}${YELLOW}1. cc-native${NC}"
  echo -e "   ${BULLET} Type: ${GREEN}Claude Code defaults${NC}"
  echo -e "   ${BULLET} Authentication: ${GREEN}Web-based${NC} (no API key injection)"
  echo -e "   ${BULLET} Use case: ${BLUE}Official Claude Code experience${NC}"
  echo ""
  echo -e "${BOLD}${YELLOW}2. cc-glm${NC}"
  echo -e "   ${BULLET} Sonnet: ${YELLOW}GLM-4.6${NC}"
  echo -e "   ${BULLET} Opus: ${YELLOW}GLM-4.6${NC}"
  echo -e "   ${BULLET} Haiku: ${YELLOW}GLM-4.5-air${NC}"
  echo -e "   ${BULLET} Base URL: ${CYAN}https://api.z.ai/api/anthropic${NC}"
  echo -e "   ${BULLET} Use case: ${BLUE}Full GLM experience${NC}"
  echo ""
  echo -e "${BOLD}${YELLOW}3. cc-mixed${NC} (RECOMMENDED)"
  echo -e "   ${BULLET} Sonnet: ${YELLOW}Claude Sonnet${NC}"
  echo -e "   ${BULLET} Opus: ${YELLOW}Claude Opus${NC}"
  echo -e "   ${BULLET} Haiku: ${YELLOW}GLM-4.5-air${NC}"
  echo -e "   ${BULLET} Base URL: ${CYAN}https://api.z.ai/api/anthropic${NC}"
  echo -e "   ${BULLET} Use case: ${BLUE}Best of both worlds${NC} - Claude for complex tasks, GLM for speed"
  echo ""
  echo -e "${BOLD}${YELLOW}4. fast-glm${NC}"
  echo -e "   ${BULLET} Sonnet: ${YELLOW}GLM-4.5-air${NC}"
  echo -e "   ${BULLET} Opus: ${YELLOW}GLM-4.6${NC}"
  echo -e "   ${BULLET} Haiku: ${YELLOW}GLM-4.5-air${NC}"
  echo -e "   ${BULLET} Base URL: ${CYAN}https://api.z.ai/api/anthropic${NC}"
  echo -e "   ${BULLET} Use case: ${BLUE}Maximum speed${NC} with GLM performance"
  echo ""
}

show_menu() {
  while true; do
    print_header
    echo -e "${BOLD}Select a mode:${NC}"
    echo ""
    echo -e "  ${CYAN}1${NC}) cc-native"
    echo -e "     Sonnet: Default | Opus: Default | Haiku: Default"
    echo ""
    echo -e "  ${CYAN}2${NC}) cc-glm"
    echo -e "     Sonnet: ${YELLOW}GLM-4.6${NC} | Opus: ${YELLOW}GLM-4.6${NC} | Haiku: ${YELLOW}GLM-4.5-air${NC}"
    echo ""
    echo -e "  ${CYAN}3${NC}) cc-mixed ${GREEN}(recommended)${NC}"
    echo -e "     Sonnet: ${YELLOW}Claude Sonnet${NC} | Opus: ${YELLOW}Claude Opus${NC} | Haiku: ${YELLOW}GLM-4.5-air${NC}"
    echo ""
    echo -e "  ${CYAN}4${NC}) fast-glm"
    echo -e "     Sonnet: ${YELLOW}GLM-4.5-air${NC} | Opus: ${YELLOW}GLM-4.6${NC} | Haiku: ${YELLOW}GLM-4.5-air${NC}"
    echo ""
    echo -e "  ${CYAN}h${NC}) Help - Show all available commands"
    echo ""

    read -p "Choice [1-4 or h]: " choice

    case "$choice" in
      1)
        switch_mode "cc-native"
        return 0
        ;;
      2)
        switch_mode "cc-glm"
        return 0
        ;;
      3)
        switch_mode "cc-mixed"
        return 0
        ;;
      4)
        switch_mode "fast-glm"
        return 0
        ;;
      h|H)
        show_help
        echo ""
        read -p "Press Enter to continue..."
        continue
        ;;
      q|Q)
        echo ""
        echo "Goodbye!"
        exit 0
        ;;
      *)
        echo ""
        echo "Invalid choice. Please select 1-4 or h for help."
        echo ""
        read -p "Press Enter to continue..."
        continue
        ;;
    esac
  done
}

show_help() {
  echo ""
  echo -e "${BOLD}${CYAN}═══════════════════════════════════════════════════${NC}"
  echo -e "${BOLD}${CYAN}  Claude Mode Switcher - Help & Commands${NC}"
  echo -e "${BOLD}${CYAN}═══════════════════════════════════════════════════${NC}"
  echo ""

  echo -e "${BOLD}${YELLOW}Interactive Menu:${NC}"
  echo "  cc-change                    # Launch interactive menu"
  echo ""

  echo -e "${BOLD}${YELLOW}Direct Mode Switching:${NC}"
  echo "  cc-change cc-native          # Switch to native Claude Code"
  echo "  cc-change cc-glm             # Switch to GLM-4.6 mode"
  echo "  cc-change cc-mixed           # Switch to mixed mode (recommended)"
  echo "  cc-change fast-glm           # Switch to fast GLM mode"
  echo ""

  echo -e "${BOLD}${YELLOW}Information Commands:${NC}"
  echo "  cc-change --status           # Show current mode configuration"
  echo "  cc-change --list             # List all modes with model mappings"
  echo "  cc-change --help             # Show this help"
  echo ""

  echo -e "${BOLD}${YELLOW}MCP Management:${NC}"
  echo "  cc-change nomcp              # Disable MCP servers"
  echo ""

  echo -e "${BOLD}${YELLOW}Available Modes:${NC}"
  echo -e "  ${CYAN}cc-native${NC}     - Claude Code defaults (web auth)"
  echo -e "  ${CYAN}cc-glm${NC}        - GLM-4.6 (Sonnet/Opus), GLM-4.5-air (Haiku)"
  echo -e "  ${CYAN}cc-mixed${NC}      - Claude Sonnet + GLM-4.5-air Haiku ${GREEN}(recommended)${NC}"
  echo -e "  ${CYAN}fast-glm${NC}      - GLM-4.5-air for all models"
  echo ""
}

################################################################################
# Main
################################################################################

main() {
  case "${1:-}" in
    --status|status)
      show_status
      ;;
    --list|list)
      show_list
      ;;
    --help|help)
      show_help
      ;;
    nomcp)
      handle_nomcp_mode
      ;;
    cc-native|cc-glm|cc-mixed|fast-glm)
      switch_mode "$1"
      ;;
    "")
      show_menu
      ;;
    *)
      print_error "Unknown option: $1"
      show_help
      exit 1
      ;;
  esac
}

main "$@"
