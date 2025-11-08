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

        # Store in auth token file with secure permissions
        echo "$API_KEY" > "$auth_token_file"
        chmod 600 "$auth_token_file"
        print_success "API key saved to $auth_token_file (600 permissions)"
    fi
}

# Create settings.json with API key
create_settings() {
    print_info "Creating settings configuration..."

    if [ -f "$CLAUDE_DIR/settings.json" ]; then
        print_warning "Settings file already exists"
        read -p "Overwrite? (y/N): " overwrite
        if [[ ! $overwrite =~ ^[Yy]$ ]]; then
            print_info "Keeping existing settings"
            return 0
        fi
    fi

    cat > "$CLAUDE_DIR/settings.json" << EOF
{
    "env": {
        "ANTHROPIC_AUTH_TOKEN": "$API_KEY",
        "ANTHROPIC_BASE_URL": "https://api.z.ai/api/anthropic",
        "API_TIMEOUT_MS": "3000000",
        "ANTHROPIC_DEFAULT_HAIKU_MODEL": "glm-4.5-air",
        "ANTHROPIC_DEFAULT_SONNET_MODEL": "glm-4.6",
        "ANTHROPIC_DEFAULT_OPUS_MODEL": "glm-4.6"
    }
}
EOF
    print_success "Settings configuration created"
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
    echo -e "${BOLD}📋 Available Commands (New Naming Scheme):${NC}"
    echo "  cc-native          # Switch to Claude native (web auth)"
    echo "  cc-mixed           # Switch to mixed mode (Claude Sonnet + GLM Haiku)"
    echo "  cc-glm             # Switch to GLM override"
    echo "  cc-status          # Show current configuration"
    echo "  fast-cc            # Switch to Claude fast mode (Haiku)"
    echo "  fast-glm           # Switch to GLM fast mode"
    echo ""
    echo -e "${BOLD}🔄 Legacy Commands (Still Work):${NC}"
    echo "  claude-native, claude-mixed, glm-override, claude-status"
    echo ""
    echo -e "${BOLD}💡 To Use Commands in Current Session:${NC}"
    echo "  Run: ${CYAN}source ~/.bashrc${NC}"
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
    echo "  • ~/.claude/switch-model-enhanced.sh   # Enhanced switcher script"
    echo "  • ~/.claude/aliases.sh                 # Shell aliases"
    echo "  • ~/.claude/.auth-token                # API key (secure)"
    echo "  • ~/.claude/backups/                   # Auto-generated backups"
    echo ""
    echo -e "${BOLD}🚀 Quick Start:${NC}"
    echo "  1. Run: ${CYAN}source ~/.bashrc${NC}"
    echo "  2. Try: ${CYAN}cc-status${NC} to see current configuration"
    echo "  3. Switch: ${CYAN}cc-mixed${NC} for Claude Sonnet + GLM Haiku"
}

# Uninstall function
uninstall() {
    print_warning "Uninstalling Claude Model Switcher..."

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
    read -p "Remove ~/.claude directory? (y/N): " remove_files
    if [[ $remove_files =~ ^[Yy]$ ]]; then
        mv "$CLAUDE_DIR" "$CLAUDE_DIR.backup.$(date +%Y%m%d_%H%M%S)"
        print_success "Moved ~/.claude to backup"
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
    prompt_api_key
    create_settings
    copy_scripts
    setup_shell_aliases
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