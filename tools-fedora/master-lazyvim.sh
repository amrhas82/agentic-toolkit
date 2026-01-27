#!/bin/bash

# ==============================================================================
# Master LazyVim Setup Script
# ==============================================================================
# Author: Claude Code Assistant
# Description: Comprehensive setup script for LazyVim Neovim configuration
# Version: 1.0
# Date: $(date +%Y-%m-%d)
#
# This script:
# 1. Checks for existing Neovim installation (required)
# 2. Installs all prerequisites for LazyVim
# 3. Backs up existing Neovim configurations
# 4. Installs LazyVim starter configuration
# 5. Provides comprehensive error handling and logging
#
# Usage: ./master-lazygit.sh
# ==============================================================================

# Color codes for output formatting
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly PURPLE='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly WHITE='\033[1;37m'
readonly NC='\033[0m' # No Color

# Log file setup
readonly LOG_FILE="/tmp/lazyvim_setup_$(date +%Y%m%d_%H%M%S).log"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Function to print colored output with timestamps
log() {
    local level="$1"
    local message="$2"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    case "$level" in
        "INFO")
            echo -e "${GREEN}[INFO]${NC} ${timestamp} - $message" | tee -a "$LOG_FILE"
            ;;
        "WARN")
            echo -e "${YELLOW}[WARN]${NC} ${timestamp} - $message" | tee -a "$LOG_FILE"
            ;;
        "ERROR")
            echo -e "${RED}[ERROR]${NC} ${timestamp} - $message" | tee -a "$LOG_FILE"
            ;;
        "SUCCESS")
            echo -e "${GREEN}[SUCCESS]${NC} ${timestamp} - $message" | tee -a "$LOG_FILE"
            ;;
        "STEP")
            echo -e "${BLUE}[STEP]${NC} ${timestamp} - $message" | tee -a "$LOG_FILE"
            ;;
        *)
            echo -e "${WHITE}[LOG]${NC} ${timestamp} - $message" | tee -a "$LOG_FILE"
            ;;
    esac
}

# Function to handle errors
handle_error() {
    local line_number=$1
    local command="$2"
    log "ERROR" "Script failed at line $line_number: $command"
    log "ERROR" "Setup aborted. Check log file: $LOG_FILE"
    exit 1
}

# Set up error trapping
trap 'handle_error $LINENO "$BASH_COMMAND"' ERR

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to prompt user for confirmation
prompt_user() {
    local message="$1"
    local default="${2:-n}"

    while true; do
        echo -n -e "${YELLOW}$message (y/n) [default: $default]: ${NC}"
        read -r response
        response=${response:-$default}

        case "$response" in
            [Yy]|[Yy][Ee][Ss])
                return 0
                ;;
            [Nn]|[Nn][Oo])
                return 1
                ;;
            *)
                echo -e "${RED}Invalid response. Please enter y/yes or n/no.${NC}"
                ;;
        esac
    done
}

# Function to backup existing configuration
backup_config() {
    local src="$1"
    local dst="$2"

    if [[ -e "$src" ]]; then
        if [[ -e "$dst" ]]; then
            log "WARN" "Backup already exists at $dst. Removing old backup..."
            rm -rf "$dst"
        fi
        log "INFO" "Backing up $src to $dst"
        mv "$src" "$dst"
    else
        log "INFO" "No existing $src to backup"
    fi
}

# Function to install package with error handling
install_package() {
    local package="$1"
    local install_cmd="$2"
    local verify_cmd="$3"
    local description="$4"

    log "STEP" "Installing $description: $package"

    if eval "$verify_cmd" >/dev/null 2>&1; then
        log "INFO" "$package is already installed"
        return 0
    fi

    log "INFO" "Installing $package..."
    if eval "$install_cmd" 2>&1 | tee -a "$LOG_FILE"; then
        log "SUCCESS" "$package installed successfully"
        return 0
    else
        log "ERROR" "Failed to install $package"
        return 1
    fi
}

# Function to display script header
display_header() {
    echo -e "${PURPLE}"
    echo "=============================================================================="
    echo "                    Master LazyVim Setup Script"
    echo "=============================================================================="
    echo "This script will set up LazyVim with all required dependencies."
    echo "Log file: $LOG_FILE"
    echo "=============================================================================="
    echo -e "${NC}"
}

# Function to display completion message
display_completion() {
    echo -e "${GREEN}"
    echo "=============================================================================="
    echo "                        Setup Completed Successfully!"
    echo "=============================================================================="
    echo "LazyVim has been installed and configured."
    echo ""
    echo "Next steps:"
    echo "1. Run: nvim"
    echo "2. Wait for LazyVim to initialize (first run may take longer)"
    echo "3. Press <leader> + l to open Lazy menu"
    echo "4. Configure plugins as needed"
    echo ""
    echo "For optimal colors, icons, and rendering experience:"
    echo "┌─────────────────────────────────────────────────────────────────┐"
    echo "│  🎨  Install Ghostty terminal for:                            │"
    echo "│    • True color rendering with Catppuccin themes              │"
    echo "│    • Nerd Font icons and special characters                 │"
    echo "│    • GPU acceleration for smooth performance                   │"
    echo "│    • Advanced terminal features and customization             │"
    echo "└─────────────────────────────────────────────────────────────────┘"
    echo ""
    echo "To install Ghostty:"
    echo "  cd /home/hamr/Documents/PycharmProjects/agentic-toolkit/tools"
    echo "  ./master-ghostty.sh"
    echo ""
    echo "Log file: $LOG_FILE"
    echo "=============================================================================="
    echo -e "${NC}"
}

# Main installation function
main() {
    # Initialize log file
    {
        echo "LazyVim Setup Log - Started at $(date)"
        echo "Script location: $SCRIPT_DIR"
        echo "User: $(whoami)"
        echo "System: $(uname -a)"
        echo "=============================================================================="
    } > "$LOG_FILE"

    display_header

    log "STEP" "Starting LazyVim setup process..."

    # Step 1: Check for Neovim installation
    log "STEP" "Checking for existing Neovim installation..."
    if command_exists nvim; then
        local nvim_version=$(nvim --version | head -n1)
        log "INFO" "Neovim found: $nvim_version"
    else
        log "ERROR" "Neovim is not installed! This script requires Neovim to be present."
        log "ERROR" "Please install Neovim first using one of these methods:"
        log "ERROR" "  - npm install -g neovim"
        log "ERROR" "  - sudo dnf install neovim"
        log "ERROR" "  - Or download from https://neovim.io/"
        exit 1
    fi

    # Step 1.5: Check for Ghostty (recommended for optimal colors and icons)
    log "STEP" "Checking for Ghostty terminal (recommended for optimal colors and icons)..."
    if command_exists ghostty; then
        local ghostty_version=$(ghostty --version 2>/dev/null | head -n1 || echo "Version unknown")
        log "INFO" "Ghostty found: $ghostty_version"
        log "SUCCESS" "Ghostty detected - Optimal rendering environment ready!"
    else
        log "WARN" "Ghostty is not installed. For optimal colors, icons, and rendering:"
        log "WARN" "  - Colors and icons may not display correctly in default terminal"
        log "WARN" "  - Nerd Font support will be limited"
        log "WARN" "  - GPU acceleration will not be available"
        log "INFO" "To install Ghostty for optimal experience:"
        log "INFO" "  cd /home/hamr/Documents/PycharmProjects/agentic-toolkit/tools"
        log "INFO" "  ./master-ghostty.sh"
        log "INFO"
        log "INFO" "Continuing with LazyVim installation (recommended: install Ghostty after setup)"
    fi

    # Step 2: Update package lists
    log "STEP" "Updating package lists..."
    if prompt_user "Update system package lists?"; then
        if sudo dnf check-update 2>&1 | tee -a "$LOG_FILE"; then
            log "SUCCESS" "Package lists updated successfully"
        else
            log "ERROR" "Failed to update package lists"
            exit 1
        fi
    fi

    # Step 3: Install prerequisites
    log "STEP" "Installing prerequisites..."

    # Install lua5.1
    install_package "lua5.1" "sudo dnf install -y lua5.1" "lua5.1 -v" "Lua 5.1"

    # Install luarocks
    install_package "luarocks" "sudo dnf install -y luarocks" "luarocks --version" "LuaRocks"

    # Check for Node.js and npm
    if ! command_exists npm; then
        log "ERROR" "npm is not installed. Please install Node.js first:"
        log "ERROR" "curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -"
        log "ERROR" "sudo dnf install -y nodejs"
        exit 1
    fi

    # Install tree-sitter-cli
    install_package "tree-sitter-cli" "npm install -g tree-sitter-cli" "tree-sitter --version" "Tree-sitter CLI"

    # Install mermaid-cli
    install_package "@mermaid-js/mermaid-cli" "npm install -g @mermaid-js/mermaid-cli" "mmdc --version" "Mermaid CLI"

    # Install LaTeX packages
    install_package "texlive-latex-base" "sudo dnf install -y texlive-latex-base" "dpkg -l | grep texlive-latex-base" "TeX Live Base"
    install_package "texlive-latex-extra" "sudo dnf install -y texlive-latex-extra" "dpkg -l | grep texlive-latex-extra" "TeX Live Extra"

    # Step 4: Backup existing configurations
    log "STEP" "Backing up existing Neovim configurations..."

    if prompt_user "Backup existing Neovim configurations?"; then
        backup_config "$HOME/.config/nvim" "$HOME/.config/nvim.bak"
        backup_config "$HOME/.local/share/nvim" "$HOME/.local/share/nvim.bak"
        backup_config "$HOME/.local/state/nvim" "$HOME/.local/state/nvim.bak"
        backup_config "$HOME/.cache/nvim" "$HOME/.cache/nvim.bak"

        log "SUCCESS" "Configuration backup completed"
    else
        log "WARN" "Skipping configuration backup (user choice)"
    fi

    # Step 5: Install LazyVim starter
    log "STEP" "Installing LazyVim starter configuration..."

    # Check if git is available
    if ! command_exists git; then
        log "ERROR" "git is not installed. Please install git first: sudo dnf install git"
        exit 1
    fi

    # Clone LazyVim starter
    local nvim_config_dir="$HOME/.config/nvim"

    if [[ -d "$nvim_config_dir" ]]; then
        log "WARN" "Neovim config directory already exists. Removing it first..."
        rm -rf "$nvim_config_dir"
    fi

    log "INFO" "Cloning LazyVim starter..."
    if git clone https://github.com/LazyVim/starter "$nvim_config_dir" 2>&1 | tee -a "$LOG_FILE"; then
        log "SUCCESS" "LazyVim starter cloned successfully"

        # Remove .git folder
        log "INFO" "Removing .git folder for personal customization..."
        if rm -rf "$nvim_config_dir/.git"; then
            log "SUCCESS" ".git folder removed successfully"
        else
            log "ERROR" "Failed to remove .git folder"
            exit 1
        fi
    else
        log "ERROR" "Failed to clone LazyVim starter"
        exit 1
    fi

    # Step 6: Verify installation
    log "STEP" "Verifying installation..."

    # Check if config directory exists
    if [[ ! -d "$nvim_config_dir" ]]; then
        log "ERROR" "Neovim config directory was not created"
        exit 1
    fi

    # Check if init.lua exists
    if [[ ! -f "$nvim_config_dir/init.lua" ]]; then
        log "ERROR" "init.lua not found in Neovim config directory"
        exit 1
    fi

    log "SUCCESS" "Installation verification passed"

    # Step 7: Display final instructions
    display_completion

    log "SUCCESS" "LazyVim setup completed successfully!"
}

# Script entry point
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # Check if running with appropriate permissions
    if [[ $EUID -eq 0 ]]; then
        log "WARN" "This script is running as root. It's recommended to run as a regular user."
        if ! prompt_user "Continue running as root?"; then
            exit 1
        fi
    fi

    main "$@"
fi