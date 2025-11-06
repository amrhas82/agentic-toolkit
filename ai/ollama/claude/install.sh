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
    print_prompt "Enter your Anthropic API key:"
    echo "(Press Enter to keep existing key or use default)"
    read -s -p "API Key: " api_key
    echo ""

    if [ -z "$api_key" ]; then
        print_info "Using default API key"
        API_KEY="3d21c6037f2c49a4bd6aa74b0083596b.gp7y0fabEpuBbsXX"
    else
        print_success "API key provided"
        API_KEY="$api_key"
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

    cp "$SCRIPT_DIR/switch-model.sh" "$CLAUDE_DIR/"
    cp "$SCRIPT_DIR/aliases.sh" "$CLAUDE_DIR/"

    chmod +x "$CLAUDE_DIR/switch-model.sh"

    print_success "Scripts installed and made executable"
}

# Setup shell aliases
setup_shell_aliases() {
    echo ""
    print_info "Setting up shell aliases for global availability..."

    local configs_added=()

    # Function to add aliases to a config file
    add_to_config() {
        local config_file="$1"
        local config_name="$2"

        if [ -f "$config_file" ]; then
            if grep -q "source ~/.claude/aliases.sh" "$config_file" 2>/dev/null; then
                print_warning "Aliases already configured in $config_name"
            else
                # Add to shell config
                echo "" >> "$config_file"
                echo "# Claude Model Switcher - Added by installer" >> "$config_file"
                echo "source ~/.claude/aliases.sh" >> "$config_file"
                print_success "Aliases added to $config_name"
                configs_added+=("$config_name")
            fi
        else
            # Create config file if it doesn't exist
            echo "# Claude Model Switcher - Added by installer" > "$config_file"
            echo "source ~/.claude/aliases.sh" >> "$config_file"
            print_success "Aliases added to $config_name (file created)"
            configs_added+=("$config_name")
        fi
    }

    # Add to both bashrc and bash_profile for global availability
    add_to_config "$HOME/.bashrc" "~/.bashrc"
    add_to_config "$HOME/.bash_profile" "~/.bash_profile"

    if [ ${#configs_added[@]} -eq 0 ]; then
        print_warning "No config files were modified (aliases already exist)"
    else
        print_success "Aliases configured in: ${configs_added[*]}"
        print_info "This ensures commands work in ALL terminal windows"
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

    if command -v claude-native >/dev/null 2>&1; then
        print_success "Aliases are working!"
    else
        print_warning "Aliases not found in current session"
        print_info "They will be available in new terminal sessions"
    fi

    if [ -f "$CLAUDE_DIR/switch-model.sh" ]; then
        print_success "Scripts installed correctly"
    else
        print_error "Scripts not found"
        return 1
    fi

    # Test the script
    if bash "$CLAUDE_DIR/switch-model.sh" status >/dev/null 2>&1; then
        print_success "Model switcher is working"
    else
        print_warning "Model switcher test failed"
    fi
}

# Show next steps
show_next_steps() {
    echo ""
    print_success "🎉 Installation complete!"
    echo ""
    echo -e "${BOLD}📋 Available Commands:${NC}"
    echo "  claude-native      # Switch to Claude native models"
    echo "  glm-override       # Switch to GLM models"
    echo "  claude-mixed       # Switch to mixed mode"
    echo "  claude-status      # Check current model"
    echo ""
    echo -e "${BOLD}🔄 From Within Claude:${NC}"
    echo "  Just say: \"Switch to Claude native models\""
    echo "  Just say: \"Switch to GLM models\""
    echo "  Just say: \"Check my current model status\""
    echo ""
    echo -e "${BOLD}💡 Notes:${NC}"
    echo "  • Aliases work in new terminal sessions automatically"
    echo "  • Current session: restart terminal or run 'source ~/.bashrc'"
    echo "  • Backups are automatically created when switching models"
    echo ""
    echo -e "${BOLD}🗂️  Files installed:${NC}"
    echo "  • ~/.claude/settings.json      # Your configuration"
    echo "  • ~/.claude/switch-model.sh    # Main switcher script"
    echo "  • ~/.claude/aliases.sh         # Shell aliases"
    echo "  • ~/.claude/backups/           # Auto-generated backups"
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
    print_info "Quick installation (no prompts)..."
    detect_shell
    create_directories
    API_KEY="3d21c6037f2c49a4bd6aa74b0083596b.gp7y0fabEpuBbsXX"
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