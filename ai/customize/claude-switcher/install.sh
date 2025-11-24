#!/bin/bash

# Claude Model Switcher - Smart Installer
# Automated setup with API key handling and shell configuration

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

print_header() {
    echo -e "${BLUE}====================================${NC}"
    echo -e "${BLUE}    Claude Model Switcher Installer  ${NC}"
    echo -e "${BLUE}====================================${NC}"
    echo ""
}

print_success() { echo -e "${GREEN}✅ $1${NC}"; }
print_error() { echo -e "${RED}❌ $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
print_info() { echo -e "${BLUE}💡 $1${NC}"; }
print_prompt() { echo -e "${CYAN}❓ $1${NC}"; }

# Check shell and config file
detect_shell() {
    echo ""
    print_info "Detecting your shell configuration..."

    if [[ "$SHELL" == *"bash"* ]]; then
        SHELL_CONFIG="$HOME/.bashrc"
        SHELL_NAME="Bash"
    elif [[ "$SHELL" == *"zsh"* ]]; then
        SHELL_CONFIG="$HOME/.zshrc"
        SHELL_NAME="Zsh"
    else
        SHELL_CONFIG="$HOME/.bashrc"  # fallback
        SHELL_NAME="Bash (fallback)"
        print_warning "Unknown shell $SHELL, using .bashrc as fallback"
    fi

    print_success "Detected $SHELL_NAME → $SHELL_CONFIG"
}

# Create directories
create_directories() {
    print_info "Creating necessary directories..."
    mkdir -p "$CLAUDE_DIR"
    mkdir -p "$CLAUDE_DIR/backups"
    print_success "Directories created"
}

# Prompt for API key
prompt_api_key() {
    echo ""
    print_header "API Key Configuration"
    echo ""

    # Check if auth token file exists
    local auth_token_file="$CLAUDE_DIR/.auth-token"
    local existing_token=""

    if [ -f "$auth_token_file" ]; then
        existing_token=$(cat "$auth_token_file" 2>/dev/null)
        if [ -n "$existing_token" ]; then
            print_info "Existing API key found (stored securely)"
            echo "First 8 characters: ${existing_token:0:8}..."
            echo ""
        fi
    fi

    print_prompt "Enter your ANTHROPIC_AUTH_TOKEN:"
    echo "This is your API key from https://console.anthropic.com"
    echo "(Press Enter to keep existing key or skip)"
    echo ""
    read -s -p "API Key: " api_key
    echo ""

    if [ -z "$api_key" ]; then
        if [ -n "$existing_token" ]; then
            print_info "Keeping existing API key"
            API_KEY="$existing_token"
        else
            print_warning "No API key provided - using placeholder"
            print_warning "You can update it later by re-running the installer"
            API_KEY="your-api-key-here"
        fi
    else
        print_success "API key provided and will be stored securely"
        API_KEY="$api_key"
    fi

    # ALWAYS update the auth token file (even with placeholder)
    echo "$API_KEY" > "$auth_token_file"
    chmod 600 "$auth_token_file"
    print_success "API key saved to $auth_token_file (600 permissions)"
}

# Check/preserve settings.json
create_settings() {
    print_info "Checking settings configuration..."

    if [ -f "$CLAUDE_DIR/settings.json" ]; then
        # Settings file exists - DO NOT OVERWRITE
        # The user's native Claude Code settings must be preserved
        print_success "Existing settings.json preserved (native Claude settings kept)"
        print_info "Use cc-change to switch modes and manage env configuration"
        return 0
    else
        # No settings file - create minimal default
        # This allows Claude Code to work, switch-mode.sh will handle env injection
        cat > "$CLAUDE_DIR/settings.json" << 'EOF'
{
  "model": "sonnet",
  "alwaysThinkingEnabled": false
}
EOF
        print_success "Created default settings.json (use cc-change to configure)"
    fi
}

# Setup logging for install operations
# Purpose: Initialize logging infrastructure for tracking installation events
# Parameters: None
# Returns: 0 on success
# Creates: Log file in ~/.claude/switcher/logs/ with timestamp
setup_install_logging() {
    local logs_dir="$CLAUDE_DIR/switcher/logs"
    mkdir -p "$logs_dir"

    local timestamp
    timestamp=$(date +%Y%m%d-%H%M%S)
    INSTALL_LOG="$logs_dir/install-${timestamp}.log"

    # Log installation start
    {
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Installation started"
    } >> "$INSTALL_LOG"
}

# Log message to install log file
# Purpose: Write timestamped log messages to installation log file
# Parameters:
#   $1 = level: Log level (INFO, WARN, ERROR, SUCCESS)
#   $2 = message: Message to log
# Returns: 0 on success
log_install() {
    local level="$1"
    local message="$2"

    if [ -n "$INSTALL_LOG" ]; then
        {
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$level] $message"
        } >> "$INSTALL_LOG"
    fi
}

# Add MCP server with retry logic (3 attempts, 2-second delays)
# Purpose: Install an MCP server with automatic retry on failure
# Parameters:
#   $1 = server_name: Human-readable name of the server (for display)
#   $2 = command: Full command to execute for installation
# Returns: 0 on success, 1 on failure after all retries
# Behavior:
#   - Attempts installation up to 3 times
#   - Waits 2 seconds between failed attempts
#   - Logs each attempt with timestamp
#   - Returns immediately on first success
add_mcp_with_retry() {
    local server_name="$1"
    local command="$2"
    local max_attempts=3
    local attempt=1
    local delay=2

    while [ $attempt -le $max_attempts ]; do
        print_info "Installing $server_name (attempt $attempt/$max_attempts)..."
        log_install "INFO" "Installing $server_name - attempt $attempt/$max_attempts"

        # Execute the command
        if eval "$command" &>/dev/null; then
            print_success "Successfully installed $server_name"
            log_install "SUCCESS" "Installed $server_name"
            return 0
        fi

        if [ $attempt -lt $max_attempts ]; then
            print_warning "$server_name installation failed, retrying in ${delay}s..."
            log_install "WARN" "$server_name failed, retrying"
            sleep "$delay"
        fi

        ((attempt++))
    done

    print_error "Failed to install $server_name after $max_attempts attempts"
    log_install "ERROR" "Failed to install $server_name after $max_attempts attempts"
    return 1
}

# Check if MCP servers are installed with matching API key (Option C approach)
# Purpose: Detect existing MCP servers and verify API key matches expected key
# Parameters:
#   $1 - expected_api_key (from ~/.claude/.auth-token)
# Returns:
#   0 - Both servers installed with matching API key (perfect match)
#   1 - Neither server installed
#   2 - Unexpected error (servers exist but in wrong state)
#   3 - ~/.claude.json file missing (shouldn't happen if servers exist)
#   4 - API key mismatch (servers exist but with different key)
#   5 - Partial installation (one server exists, one missing)
# Behavior:
#   - Checks 'claude mcp list' for server names
#   - Parses ~/.claude.json to extract actual API keys
#   - Compares expected vs actual keys
#   - Returns status code indicating exact situation
check_mcp_installation() {
    local expected_api_key="$1"

    if [ -z "$expected_api_key" ]; then
        return 3  # Invalid input
    fi

    # Check if servers exist via claude mcp list
    local mcp_list
    mcp_list=$(claude mcp list 2>&1 || echo "")

    local has_vision=0
    local has_search=0

    if echo "$mcp_list" | grep -q "zai-mcp-server"; then
        has_vision=1
    fi

    if echo "$mcp_list" | grep -q "web-search-prime"; then
        has_search=1
    fi

    # Handle case where neither server is installed
    if [ $has_vision -eq 0 ] && [ $has_search -eq 0 ]; then
        return 1  # Neither installed - safe to proceed
    fi

    # Handle partial installation
    if [ $has_vision -eq 0 ] || [ $has_search -eq 0 ]; then
        return 5  # Partial installation - one exists, one missing
    fi

    # Both servers exist - check API keys in ~/.claude.json
    if [ ! -f "$HOME/.claude.json" ]; then
        return 3  # Config file missing (shouldn't happen if servers exist)
    fi

    # Extract API keys from installed servers using jq
    local vision_key
    local search_key

    # Extract vision server API key from Z_AI_API_KEY env variable
    vision_key=$(jq -r '.mcpServers."zai-mcp-server".env.Z_AI_API_KEY // empty' "$HOME/.claude.json" 2>/dev/null)

    # Extract search server API key from Authorization header (remove "Bearer " prefix)
    search_key=$(jq -r '.mcpServers."web-search-prime".headers.Authorization // empty' "$HOME/.claude.json" 2>/dev/null | sed 's/^Bearer //')

    # Compare with expected key
    if [ "$vision_key" = "$expected_api_key" ] && [ "$search_key" = "$expected_api_key" ]; then
        return 0  # Perfect match - both servers with correct API key
    else
        return 4  # API key mismatch - servers exist but wrong key
    fi
}

# Remove existing MCP servers (vision and web search)
# Purpose: Clean removal of zai-mcp-server and web-search-prime before reinstalling
# Parameters: None
# Returns: 0 on success, 1 if removal fails
# Behavior:
#   - Lists servers to be removed with color-coded output
#   - Executes 'claude mcp remove' for each server
#   - Shows success/failure message for each removal
#   - Logs all operations with timestamps
#   - Gracefully handles if servers don't exist
remove_existing_mcp_servers() {
    echo ""
    print_info "Removing existing MCP servers..."
    log_install "INFO" "Removing existing MCP servers"

    # Remove vision server
    if claude mcp remove zai-mcp-server &>/dev/null; then
        print_success "Removed zai-mcp-server"
        log_install "SUCCESS" "Removed zai-mcp-server"
    else
        print_warning "Could not remove zai-mcp-server (may not exist)"
        log_install "WARN" "Could not remove zai-mcp-server"
    fi

    echo ""

    # Remove search server
    if claude mcp remove web-search-prime &>/dev/null; then
        print_success "Removed web-search-prime"
        log_install "SUCCESS" "Removed web-search-prime"
    else
        print_warning "Could not remove web-search-prime (may not exist)"
        log_install "WARN" "Could not remove web-search-prime"
    fi

    echo ""
    return 0
}

# Install GLM MCP servers (vision and web search)
# Purpose: Install both zai-mcp-server (vision) and web-search-prime servers
# Parameters: None (uses AUTH_TOKEN environment variable)
# Returns: 0 on success, 1 on failure
# Behavior:
#   - Requires AUTH_TOKEN to be set via check_auth_token()
#   - Builds and executes two MCP add commands with retry logic
#   - Logs all installation attempts with timestamps
#   - Stops if vision server fails (requires both to succeed)
# Environment variables required:
#   AUTH_TOKEN: API key for GLM servers (set securely in ~/.claude/.auth-token)
add_mcp_servers() {
    # Ensure API token is available
    if [ -z "$AUTH_TOKEN" ]; then
        print_error "API token not set - cannot install MCP servers"
        return 1
    fi

    echo ""
    print_info "Checking for existing MCP servers..."
    log_install "INFO" "Checking for existing MCP installations"

    # Check installation status using Option C approach
    check_mcp_installation "$AUTH_TOKEN"
    local status=$?

    case $status in
        0)
            # Both installed with matching API key - perfect match
            echo ""
            print_success "MCP servers already installed with current API key"
            echo ""
            print_info "Current installation:"
            claude mcp list 2>/dev/null | grep -E "zai-mcp-server|web-search-prime" || true
            echo ""
            print_info "No changes needed"
            log_install "INFO" "MCP servers already installed with current API key"
            return 0
            ;;
        1)
            # Neither installed - proceed normally
            echo ""
            print_info "No MCP servers found, proceeding with installation..."
            log_install "INFO" "No existing MCP servers found"
            ;;
        4)
            # API key mismatch - servers exist with different key
            echo ""
            print_warning "MCP servers found with DIFFERENT API key"
            log_install "WARN" "MCP servers found with different API key"
            echo ""
            print_info "Current installation:"
            claude mcp list 2>/dev/null | grep -E "zai-mcp-server|web-search-prime" || true
            echo ""
            echo "Options:"
            echo "  1) Keep existing installation (no changes)"
            echo "  2) Remove and reinstall with new API key"
            echo ""
            read -p "Choice [1-2]: " reinstall_choice

            if [ "$reinstall_choice" != "2" ]; then
                print_info "Keeping existing MCP installation"
                log_install "INFO" "User chose to keep existing MCP servers"
                return 0
            fi

            # User chose to reinstall
            echo ""
            print_warning "Removing existing servers for reinstallation..."
            remove_existing_mcp_servers
            ;;
        5)
            # Partial installation - one server exists, one missing
            echo ""
            print_warning "Partial MCP installation detected"
            log_install "WARN" "Partial MCP installation detected"
            echo ""
            print_info "Current installation:"
            claude mcp list 2>/dev/null | grep -E "zai-mcp-server|web-search-prime" || true
            echo ""
            print_info "Will complete the installation"
            ;;
        *)
            # Other errors (invalid input, config file missing, etc.)
            echo ""
            print_warning "Could not determine MCP status, proceeding with installation..."
            log_install "WARN" "Could not determine MCP installation status (error code: $status)"
            ;;
    esac

    # Continue with installation (existing code below)
    echo ""
    print_info "Installing GLM MCP servers..."
    log_install "INFO" "Starting MCP server installation"

    # Build vision server command
    local vision_cmd="claude mcp add -s user zai-mcp-server --env Z_AI_API_KEY=${AUTH_TOKEN} Z_AI_MODE=ZAI -- npx -y \"@z_ai/mcp-server\""

    # Build search server command
    local search_cmd="claude mcp add -s user -t http web-search-prime https://api.z.ai/api/mcp/web_search_prime/mcp --header \"Authorization: Bearer ${AUTH_TOKEN}\""

    # Install vision server
    if ! add_mcp_with_retry "zai-mcp-server (vision)" "$vision_cmd"; then
        print_error "Vision server installation failed"
        log_install "ERROR" "Vision server installation failed"
        return 1
    fi

    echo ""

    # Install search server
    if ! add_mcp_with_retry "web-search-prime (search)" "$search_cmd"; then
        print_error "Search server installation failed"
        log_install "ERROR" "Search server installation failed"
        # Note: partial success - vision is installed but search failed
        return 1
    fi

    echo ""
    print_success "All MCP servers installed successfully!"
    log_install "SUCCESS" "All MCP servers installed successfully"
    return 0
}

# Check if AUTH_TOKEN exists and is non-empty
# Purpose: Verify API key file exists and contains valid non-empty content
# Parameters: None
# Returns: 0 if valid token found and loaded, 1 if missing or empty
# Behavior:
#   - Reads from ~/.claude/.auth-token (600 permissions)
#   - Strips all whitespace (spaces, tabs, newlines, carriage returns)
#   - Sets global AUTH_TOKEN variable if valid
# Note: Never logs the token value for security purposes
check_auth_token() {
    local auth_token_file="$CLAUDE_DIR/.auth-token"

    if [ ! -f "$auth_token_file" ]; then
        return 1
    fi

    # Read token and trim whitespace
    local token
    token=$(cat "$auth_token_file" 2>/dev/null | tr -d ' \t\n\r')

    if [ -z "$token" ]; then
        return 1
    fi

    # Set global AUTH_TOKEN variable
    AUTH_TOKEN="$token"
    return 0
}

# Validate and display API key status with user interaction
# Purpose: Check if API key exists and prompt user to proceed or update
# Parameters: None
# Returns: 0 if user confirms proceeding or successfully sets key, 1 if cancelled
# Behavior:
#   - If key exists: Display first 8 characters, ask user to confirm
#   - If key missing: Show instructions and offer to set up now
#   - Never displays full API key (security measure)
#   - Offers guidance for retrieving key from console.anthropic.com
validate_api_key() {
    local auth_token_file="$CLAUDE_DIR/.auth-token"

    echo ""
    print_info "Checking API key configuration..."
    echo ""

    if check_auth_token; then
        print_success "API key found"
        echo "First 8 characters: ${AUTH_TOKEN:0:8}..."
        echo ""
        print_prompt "Proceed with this key? (y/n): "
        read -r response

        if [[ $response =~ ^[Yy]$ ]]; then
            return 0
        else
            return 1
        fi
    else
        print_warning "API key not found or is empty"
        echo "Location: $auth_token_file"
        echo ""
        print_info "To set up your API key:"
        echo "  1. Get your API key from https://console.anthropic.com"
        echo "  2. Create/update ~/.claude/.auth-token with your key"
        echo "  3. Or select option 1 from the MCP menu to set it up now"
        echo ""
        print_prompt "Would you like to set up your API key now? (y/n): "
        read -r response

        if [[ $response =~ ^[Yy]$ ]]; then
            prompt_for_mcp_api_key
            return 0
        else
            return 1
        fi
    fi
}

# Prompt user to enter and save API key for MCP setup
# Purpose: Interactive prompt to collect and securely store API key
# Parameters: None
# Returns: 0 on success, 1 if user provides empty input
# Behavior:
#   - Uses read -s (silent input) to hide key from terminal display
#   - Saves to ~/.claude/.auth-token with 600 permissions (owner read/write only)
#   - Creates ~/.claude directory if it doesn't exist
#   - Sets global AUTH_TOKEN variable for use in current session
#   - Shows success message with file path and permissions
prompt_for_mcp_api_key() {
    echo ""
    print_info "Setting up GLM API Key"
    echo ""
    print_prompt "Enter your GLM API key (hidden input):"
    read -s -r api_key
    echo ""

    if [ -z "$api_key" ]; then
        print_warning "No API key provided"
        return 1
    fi

    # Create directory if it doesn't exist
    mkdir -p "$CLAUDE_DIR"

    # Save to auth token file
    local auth_token_file="$CLAUDE_DIR/.auth-token"
    echo "$api_key" > "$auth_token_file"
    chmod 600 "$auth_token_file"

    # Update AUTH_TOKEN variable
    AUTH_TOKEN="$api_key"

    print_success "API key saved securely to $auth_token_file (600 permissions)"
    return 0
}

# Check if Claude CLI is installed and available
# Purpose: Verify Claude CLI is installed in system PATH
# Parameters: None
# Returns: 0 if claude command found, 1 if missing
# Behavior:
#   - Uses command -v to check PATH for claude executable
#   - Shows success message if found
#   - Provides installation instructions if missing
#   - Blocks MCP menu flow if Claude CLI not available
check_claude_cli() {
    if command -v claude &>/dev/null; then
        print_success "Claude CLI found"
        return 0
    else
        echo ""
        print_error "Claude CLI is required for MCP server setup"
        echo ""
        print_info "To install Claude CLI, run:"
        echo ""
        echo -e "  ${CYAN}curl -fsSL https://claude.ai/install.sh | bash${NC}"
        echo ""
        print_info "After installation, you can re-run this installer to set up MCP servers"
        return 1
    fi
}

# Display MCP setup menu with three options
# Purpose: Show interactive menu for MCP server configuration
# Parameters: None
# Returns: None (display only)
# Menu options:
#   1) Setup/Update GLM API Key - Interactive API key entry
#   2) Install GLM MCP Servers - Install vision and search servers
#   3) Exit Setup - Exit the menu and continue
# Formatting: Uses color codes for visual clarity (BLUE header, CYAN options)
show_mcp_menu() {
    echo ""
    echo -e "${BLUE}═════════════════════════════════════${NC}"
    echo -e "${BLUE}  MCP Server Setup Menu${NC}"
    echo -e "${BLUE}═════════════════════════════════════${NC}"
    echo ""
    echo -e "  ${CYAN}1${NC}) Setup/Update GLM API Key"
    echo -e "     Configure your API key for MCP servers"
    echo ""
    echo -e "  ${CYAN}2${NC}) Install GLM MCP Servers"
    echo -e "     Install vision and web search capabilities"
    echo ""
    echo -e "  ${CYAN}3${NC}) Exit Setup"
    echo -e "     Finish and close this menu"
    echo ""
}

# Read and validate MCP menu input from user
# Purpose: Get and validate user's menu choice (1-3)
# Parameters: None
# Returns: 0 always (echoes valid choice to stdout)
# Behavior:
#   - Loops until user enters 1, 2, or 3
#   - Shows error message for invalid input
#   - Echoes valid choice for caller to capture
# Validation:
#   - Only accepts 1, 2, or 3
#   - Rejects letters, special chars, or out-of-range numbers
read_mcp_menu_input() {
    local choice

    while true; do
        read -p "Choice [1-3]: " choice

        case "$choice" in
            1|2|3)
                echo "$choice"
                return 0
                ;;
            *)
                print_error "Invalid choice. Please enter 1, 2, or 3"
                echo ""
                ;;
        esac
    done
}

# MCP setup menu loop with routing logic
# Purpose: Main interactive loop for MCP server configuration
# Parameters: None
# Returns: 0 on exit (option 3), 1 if Claude CLI missing
# Behavior:
#   - Verifies Claude CLI availability before showing menu
#   - Loops until user selects Exit (option 3)
#   - Routes menu choices to appropriate handler functions
#   - Prompts for user input between operations
# Menu routing:
#   1) API Key setup → prompt_for_mcp_api_key()
#   2) Install servers → add_mcp_servers() (requires valid API key)
#   3) Exit → return 0
mcp_setup_menu() {
    # Check if Claude CLI is available before showing menu
    if ! check_claude_cli; then
        echo ""
        print_warning "MCP setup cannot continue without Claude CLI"
        read -p "Press Enter to continue..."
        return 1
    fi

    echo ""

    while true; do
        show_mcp_menu
        local choice
        choice=$(read_mcp_menu_input)

        case "$choice" in
            1)
                # API Key setup
                prompt_for_mcp_api_key
                echo ""
                read -p "Press Enter to continue..."
                ;;
            2)
                # MCP Server Installation
                if ! check_auth_token; then
                    echo ""
                    print_warning "API key not configured"
                    print_info "Please select option 1 to set up your API key first"
                    read -p "Press Enter to continue..."
                    continue
                fi
                add_mcp_servers
                echo ""
                read -p "Press Enter to continue..."
                ;;
            3)
                print_success "Exiting MCP setup menu"
                echo ""
                return 0
                ;;
        esac
    done
}

# Copy preset JSON files for mode switching and MCP configuration
# Purpose: Copy all preset files from project to installation directory
# Parameters: None
# Returns: 0 on success, 1 if source directory missing or copy fails
# Behavior:
#   - Copies all .json files from presets/glm/ to ~/.claude/switcher/presets/glm/
#   - Creates destination directory if it doesn't exist
#   - Sets file permissions to 644 (readable by all, writable by owner only)
#   - Verifies MCP template files (glm_vision_mcp.json, glm_search_mcp.json)
#   - Shows count of files copied
# Files copied:
#   - cc-native.json, cc-glm.json, cc-mixed.json, fast-glm.json (mode presets)
#   - glm_vision_mcp.json, glm_search_mcp.json (MCP server templates)
copy_presets() {
    print_info "Copying preset files..."

    local source_dir="$SCRIPT_DIR/presets/glm"
    local dest_dir="$CLAUDE_DIR/switcher/presets/glm"

    # Verify source directory exists
    if [ ! -d "$source_dir" ]; then
        print_error "Preset source directory not found: $source_dir"
        return 1
    fi

    # Create destination directory
    mkdir -p "$dest_dir"

    # Count files to copy
    local count=0

    # Copy all JSON preset files
    if cp "$source_dir"/*.json "$dest_dir/" 2>/dev/null; then
        count=$(ls "$dest_dir"/*.json 2>/dev/null | wc -l)
        print_success "Copied $count preset files to ~/.claude/switcher/presets/glm/"

        # Ensure all files are readable
        chmod 644 "$dest_dir"/*.json 2>/dev/null || true
    else
        print_error "Failed to copy preset files"
        return 1
    fi

    # Verify the new MCP template files are present
    if [ -f "$dest_dir/glm_vision_mcp.json" ] && [ -f "$dest_dir/glm_search_mcp.json" ]; then
        print_success "MCP template files verified in destination"
    else
        print_warning "MCP template files not found (they will be needed for MCP setup)"
    fi
}

# Copy scripts
copy_scripts() {
    print_info "Installing scripts..."

    # Copy the enhanced script
    if [ -f "$SCRIPT_DIR/switch-model-enhanced.sh" ]; then
        cp "$SCRIPT_DIR/switch-model-enhanced.sh" "$CLAUDE_DIR/"
        chmod +x "$CLAUDE_DIR/switch-model-enhanced.sh"
        print_success "Enhanced model switcher installed"
    fi

    # Copy legacy script if it exists
    if [ -f "$SCRIPT_DIR/switch-model.sh" ]; then
        cp "$SCRIPT_DIR/switch-model.sh" "$CLAUDE_DIR/"
        chmod +x "$CLAUDE_DIR/switch-model.sh"
        print_success "Legacy model switcher installed"
    fi

    # Copy aliases
    cp "$SCRIPT_DIR/aliases.sh" "$CLAUDE_DIR/"

    print_success "Scripts installed and made executable"
}

# Setup shell aliases
setup_shell_aliases() {
    echo ""
    print_info "Setting up shell aliases for global availability..."

    local configs_added=()
    local alias_source_line="[ -f ~/.claude/aliases.sh ] && source ~/.claude/aliases.sh"

    # Function to add aliases to a config file
    add_to_config() {
        local config_file="$1"
        local config_name="$2"

        if [ -f "$config_file" ]; then
            # Check if aliases are already configured
            if grep -q "source ~/.claude/aliases.sh" "$config_file" 2>/dev/null || \
               grep -q "source \$HOME/.claude/aliases.sh" "$config_file" 2>/dev/null; then
                print_warning "Aliases already configured in $config_name"
                return 0
            else
                # Add to shell config with conditional check
                echo "" >> "$config_file"
                echo "# Claude Model Switcher - Added by installer $(date +%Y-%m-%d)" >> "$config_file"
                echo "$alias_source_line" >> "$config_file"
                print_success "Aliases added to $config_name"
                configs_added+=("$config_name")
            fi
        else
            # Create config file if it doesn't exist
            echo "# Claude Model Switcher - Added by installer $(date +%Y-%m-%d)" > "$config_file"
            echo "$alias_source_line" >> "$config_file"
            print_success "Created $config_name with aliases"
            configs_added+=("$config_name")
        fi
    }

    # Add to bashrc (interactive shells)
    add_to_config "$HOME/.bashrc" "~/.bashrc"

    # Add to bash_profile if it exists or user uses it (login shells)
    if [ -f "$HOME/.bash_profile" ] || [ -f "$HOME/.profile" ]; then
        # If bash_profile exists, add there
        if [ -f "$HOME/.bash_profile" ]; then
            # Check if bash_profile sources bashrc
            if ! grep -q "source.*bashrc" "$HOME/.bash_profile" 2>/dev/null && \
               ! grep -q "\..*bashrc" "$HOME/.bash_profile" 2>/dev/null; then
                # Add sourcing of bashrc to bash_profile
                echo "" >> "$HOME/.bash_profile"
                echo "# Source bashrc for interactive shell features" >> "$HOME/.bash_profile"
                echo "[ -f ~/.bashrc ] && source ~/.bashrc" >> "$HOME/.bash_profile"
                print_info "Added bashrc sourcing to ~/.bash_profile"
            fi
        fi
        add_to_config "$HOME/.bash_profile" "~/.bash_profile"
    fi

    # Also check for bash_aliases (common on Ubuntu/Debian)
    if [ -f "$HOME/.bash_aliases" ]; then
        add_to_config "$HOME/.bash_aliases" "~/.bash_aliases"
    fi

    if [ ${#configs_added[@]} -eq 0 ]; then
        print_warning "No config files were modified (aliases already exist)"
    else
        print_success "Aliases configured in: ${configs_added[*]}"
        print_info "Commands will work in ALL new terminal sessions"
        print_info "For current session: source ~/.bashrc"
    fi
}

# Reload shell configuration
reload_shell() {
    print_info "Reloading shell configuration..."

    # Source the config
    if [ -f "$SHELL_CONFIG" ]; then
        # shellcheck source=/dev/null
        source "$SHELL_CONFIG" 2>/dev/null || print_warning "Could not reload shell config"
    fi

    print_success "Shell configuration reloaded"
}

# Test installation
test_installation() {
    echo ""
    print_info "Testing installation..."

    # Test new command names
    if command -v cc-native >/dev/null 2>&1; then
        print_success "New aliases (cc-*) are working in current session!"
    else
        print_warning "Aliases not available in current session"
        print_info "They will be available after running: source ~/.bashrc"
        print_info "Or open a new terminal session"
    fi

    # Check if enhanced script exists
    if [ -f "$CLAUDE_DIR/switch-model-enhanced.sh" ]; then
        print_success "Enhanced model switcher installed"

        # Test the script directly
        if bash "$CLAUDE_DIR/switch-model-enhanced.sh" cc-status >/dev/null 2>&1; then
            print_success "Model switcher is working correctly"
        else
            print_warning "Model switcher test had issues (may be normal)"
        fi
    else
        print_error "Enhanced script not found"
        return 1
    fi

    # Check for API key
    if [ -f "$CLAUDE_DIR/.auth-token" ]; then
        print_success "API key stored securely"
    else
        print_warning "No API key stored yet"
    fi
}

# Show next steps
show_next_steps() {
    echo ""
    print_success "🎉 Installation complete!"
    echo ""
    echo -e "${BOLD}📋 Main Command:${NC}"
    echo -e "  ${CYAN}cc-change${NC}          # Interactive menu (recommended)"
    echo ""
    echo -e "${BOLD}📋 Quick Mode Switching:${NC}"
    echo "  cc-native          # Switch to Claude native (web auth)"
    echo "  cc-glm             # Switch to GLM-4.6 mode"
    echo "  cc-mixed           # Switch to mixed (Claude Sonnet + GLM Haiku)"
    echo "  fast-glm           # Switch to fast GLM mode"
    echo ""
    echo -e "${BOLD}📋 Information Commands:${NC}"
    echo "  cc-status          # Show current configuration"
    echo "  cc-list            # List all modes with details"
    echo "  cc-help            # Show help"
    echo ""
    echo -e "${BOLD}💡 To Use Commands in Current Session:${NC}"
    echo -e "  Run: ${CYAN}source ~/.bashrc${NC}"
    echo "  Or: Open a new terminal window"
    echo ""
    echo -e "${BOLD}🔑 API Key Management:${NC}"
    if [ -f "$CLAUDE_DIR/.auth-token" ]; then
        echo "  ✅ API key stored securely in ~/.claude/.auth-token (600 permissions)"
        echo "  • The key persists across mode switches"
        echo "  • Re-run installer to update the key"
    else
        echo "  ⚠️  No API key configured yet"
        echo "  • Re-run installer to add your key"
    fi
    echo ""
    echo -e "${BOLD}🗂️  Files Installed:${NC}"
    echo "  • ~/.claude/settings.json              # Current configuration"
    echo "  • ~/.claude/switcher/switch-mode.sh    # Mode switcher script"
    echo "  • ~/.local/bin/cc-change               # Main command"
    echo "  • ~/.claude/aliases.sh                 # Shell aliases"
    echo "  • ~/.claude/.auth-token                # API key (secure)"
    echo "  • ~/.claude/switcher/presets/          # Mode presets"
    echo "  • ~/.claude/switcher/logs/             # Switch logs"
    echo ""
    echo -e "${BOLD}🚀 Quick Start:${NC}"
    echo -e "  1. Run: ${CYAN}source ~/.bashrc${NC}"
    echo -e "  2. Try: ${CYAN}cc-change${NC} for interactive menu"
    echo -e "  3. Or: ${CYAN}cc-status${NC} to see current configuration"
}

# Uninstall function
uninstall() {
    echo ""
    print_warning "╔════════════════════════════════════════════════════╗"
    print_warning "║  UNINSTALLING CLAUDE MODEL SWITCHER                ║"
    print_warning "╚════════════════════════════════════════════════════╝"
    echo ""

    print_info "This will remove:"
    echo "  ✓ Mode switching scripts (~/.claude/switcher/)"
    echo "  ✓ Shell aliases (~/.bashrc entries)"
    echo "  ✓ Preset configurations"
    echo "  ✓ API key (~/.claude/.auth-token)"
    echo "  ✓ Switcher settings (~/.claude/settings.json)"
    echo ""

    print_success "This will KEEP (safe):"
    echo "  ✓ ~/.claude.json (Claude Code's main config)"
    echo "  ✓ MCP servers (web-search-prime, zai-mcp-server)"
    echo "  ✓ Claude Code preferences and history"
    echo ""

    print_info "To remove MCP servers after uninstall, use:"
    echo "  → cc-change nomcp (before uninstalling)"
    echo "  → claude mcp remove <server-name> (after uninstalling)"
    echo ""

    read -p "Continue with uninstall? (y/N): " confirm_uninstall
    if [[ ! $confirm_uninstall =~ ^[Yy]$ ]]; then
        print_info "Uninstall cancelled"
        return 0
    fi

    echo ""
    print_info "Proceeding with uninstall..."
    echo ""

    # Remove from shell config
    if [ -f "$SHELL_CONFIG" ]; then
        # Create backup
        cp "$SHELL_CONFIG" "$SHELL_CONFIG.backup.$(date +%Y%m%d_%H%M%S)"

        # Remove the line
        sed -i '/# Claude Model Switcher - Added by installer/d' "$SHELL_CONFIG"
        sed -i '/source \~\/\.claude\/aliases\.sh/d' "$SHELL_CONFIG"
        print_success "Removed aliases from $SHELL_CONFIG"
    fi

    # Ask about removing files
    read -p "Remove switcher files from ~/.claude? (y/N): " remove_files
    if [[ $remove_files =~ ^[Yy]$ ]]; then
        print_info "Removing switcher-specific files only..."
        echo ""

        # Remove switcher directory
        if [ -d "$CLAUDE_DIR/switcher" ]; then
            rm -rf "$CLAUDE_DIR/switcher"
            print_success "Removed ~/.claude/switcher/"
        fi

        # Backup settings.json (NOT remove, in case user wants it)
        if [ -f "$CLAUDE_DIR/settings.json" ]; then
            mv "$CLAUDE_DIR/settings.json" "$CLAUDE_DIR/settings.json.uninstall-backup.$(date +%Y%m%d_%H%M%S)"
            print_success "Backed up settings.json"
        fi

        # Remove auth token
        if [ -f "$CLAUDE_DIR/.auth-token" ]; then
            rm "$CLAUDE_DIR/.auth-token"
            print_success "Removed .auth-token"
        fi

        # Remove aliases
        if [ -f "$CLAUDE_DIR/aliases.sh" ]; then
            rm "$CLAUDE_DIR/aliases.sh"
            print_success "Removed aliases.sh"
        fi

        # Remove backups directory
        if [ -d "$CLAUDE_DIR/backups" ]; then
            rm -rf "$CLAUDE_DIR/backups"
            print_success "Removed backups directory"
        fi

        echo ""
        print_warning "⚠️  IMPORTANT: ~/.claude.json was NOT removed"
        print_info "This file contains Claude Code settings and MCP servers"
        print_info "To remove MCP servers, use: cc-change nomcp"
        echo ""
    fi

    print_success "Uninstallation complete"
}

# Show help
show_help() {
    echo "Claude Model Switcher Installer"
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  install   - Full installation with prompts (recommended)"
    echo "  quick     - Quick install (no prompts, uses defaults)"
    echo "  test      - Test current installation"
    echo "  status    - Show installation status"
    echo "  uninstall - Remove the switcher"
    echo "  help      - Show this help"
    echo ""
    echo "Examples:"
    echo "  $0 install    # Interactive installation"
    echo "  $0 quick      # Quick installation"
    echo "  $0 status     # Check if installed"
}

# Check installation status
check_status() {
    echo ""
    print_info "Checking installation status..."
    echo ""

    # Check directories
    if [ -d "$CLAUDE_DIR" ]; then
        print_success "✅ Directory exists: ~/.claude"
    else
        print_error "❌ Directory missing: ~/.claude"
    fi

    # Check files
    for file in "settings.json" "switch-model.sh" "aliases.sh"; do
        if [ -f "$CLAUDE_DIR/$file" ]; then
            print_success "✅ File exists: ~/.claude/$file"
        else
            print_error "❌ File missing: ~/.claude/$file"
        fi
    done

    # Check aliases
    if grep -q "source ~/.claude/aliases.sh" "$HOME/.bashrc" 2>/dev/null || \
       grep -q "source ~/.claude/aliases.sh" "$HOME/.zshrc" 2>/dev/null; then
        print_success "✅ Aliases configured in shell"
    else
        print_warning "⚠️  Aliases not configured in shell"
    fi

    # Check if commands work
    if command -v claude-native >/dev/null 2>&1; then
        print_success "✅ Commands available in current session"
    else
        print_warning "⚠️  Commands not available (restart terminal)"
    fi
}

# Quick install (no prompts)
quick_install() {
    print_header
    print_warning "Quick installation mode (skipping API key prompt)"
    echo ""
    detect_shell
    create_directories

    # Check for existing API key
    local auth_token_file="$CLAUDE_DIR/.auth-token"
    if [ -f "$auth_token_file" ]; then
        API_KEY=$(cat "$auth_token_file" 2>/dev/null)
        print_info "Using existing API key"
    else
        print_warning "No API key - using placeholder"
        print_info "Run 'bash install.sh install' to configure your API key"
        API_KEY="your-api-key-here"
    fi

    create_settings
    copy_presets
    copy_scripts
    setup_shell_aliases
    reload_shell
    test_installation
    show_next_steps
}

# Full interactive installation
full_install() {
    print_header
    detect_shell
    create_directories
    setup_install_logging
    log_install "INFO" "Full installation started"
    create_settings
    copy_presets
    copy_scripts
    setup_shell_aliases

    # Show MCP setup menu directly (no y/n prompt)
    mcp_setup_menu

    reload_shell
    test_installation
    show_next_steps
}

# Main execution
main() {
    case "${1:-install}" in
        "install"|"--install"|"-i")
            full_install
            ;;
        "quick"|"--quick"|"-q")
            quick_install
            ;;
        "test"|"--test"|"-t")
            test_installation
            ;;
        "status"|"--status"|"-s")
            check_status
            ;;
        "uninstall"|"--uninstall"|"-u")
            detect_shell
            uninstall
            ;;
        "help"|"--help"|"-h")
            show_help
            ;;
        *)
            print_error "Unknown command: $1"
            show_help
            exit 1
            ;;
    esac
}

# Check if script is run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi