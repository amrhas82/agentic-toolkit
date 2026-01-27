#!/bin/bash

# =============================================================================
# Ghostty Terminal Installation & Configuration Script
# =============================================================================
# This script installs Ghostty Terminal and configures it with a comprehensive
# configuration file that includes Catppuccin Frappe theme, custom keybindings,
# and optimized settings for development workflows.
#
# Features:
# - Installs Ghostty via Snap package manager
# - Creates backup of existing configuration
# - Installs complete configuration with theme and keybindings
# - Error handling and user prompts
# - Colored output and progress logging
# - Verification of installation and configuration
# =============================================================================

set -e  # Exit on any error

# Color definitions for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly PURPLE='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly WHITE='\033[1;37m'
readonly BOLD='\033[1m'
readonly RESET='\033[0m'

# Script constants
readonly SCRIPT_NAME="master-ghostty.sh"
readonly GHOSTTY_VERSION="latest"
readonly CONFIG_DIR="$HOME/.config/ghostty"
readonly CONFIG_FILE="$CONFIG_DIR/config"
readonly BACKUP_DIR="$HOME/.config/ghostty/backup"
readonly TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${RESET} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${RESET} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${RESET} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${RESET} $1"
}

log_step() {
    echo -e "${PURPLE}[STEP]${RESET} $1"
}

log_header() {
    echo -e "\n${BOLD}${CYAN}$1${RESET}"
    echo -e "${CYAN}$(printf '=%.0s' {1..50})${RESET}"
}

# Progress bar function
show_progress() {
    local duration=$1
    local message=$2
    local steps=20
    local step_duration=$((duration / steps))

    echo -ne "${BLUE}$message [${RESET}"
    for i in $(seq 1 $steps); do
        echo -ne "${GREEN}#${RESET}"
        sleep $step_duration
    done
    echo -e "] ${GREEN}Done!${RESET}"
}

# Check if running as root for snap operations
check_sudo() {
    if [ "$EUID" -eq 0 ]; then
        log_error "This script should not be run as root. Please run as a regular user."
        exit 1
    fi

    # Check if sudo is available
    if ! sudo -n true 2>/dev/null; then
        log_warning "This script requires sudo privileges for package installation."
        echo -e "${YELLOW}Please enter your password if prompted.${RESET}"
    fi
}

# Check system requirements
check_requirements() {
    log_step "Checking system requirements..."

    # Check if we're on Fedora-based system
    if ! command -v snap &> /dev/null; then
        log_error "Snap package manager is not installed or not available."
        log_info "Please install snap first: sudo dnf check-update && sudo dnf install snapd"
        exit 1
    fi

    # Check if system is compatible with Snap
    if ! snap list &> /dev/null; then
        log_error "Snap is not properly configured on this system."
        exit 1
    fi

    log_success "System requirements met"
}

# Check if Ghostty is already installed
check_ghostty_installed() {
    if command -v ghostty &> /dev/null; then
        local version=$(ghostty --version 2>/dev/null | head -n1 || echo "unknown")
        log_success "Ghostty is already installed (version: $version)"
        return 0
    else
        log_info "Ghostty is not installed"
        return 1
    fi
}

# Install Ghostty via Snap
install_ghostty() {
    log_step "Installing Ghostty Terminal via Snap..."

    # Check if already installed
    if check_ghostty_installed; then
        log_warning "Ghostty is already installed. Skipping installation."
        return 0
    fi

    # Install Ghostty
    log_info "Running: sudo snap install ghostty --classic"

    if sudo snap install ghostty --classic; then
        log_success "Ghostty installed successfully"

        # Verify installation
        if ghostty --version &> /dev/null; then
            local installed_version=$(ghostty --version | head -n1)
            log_success "Installation verified: $installed_version"
        else
            log_error "Installation verification failed"
            exit 1
        fi
    else
        log_error "Failed to install Ghostty"
        log_info "Please check your internet connection and try again."
        log_info "You can also try installing manually: sudo snap install ghostty --classic"
        exit 1
    fi
}

# Create configuration directory
create_config_directory() {
    log_step "Creating configuration directory..."

    if [ -d "$CONFIG_DIR" ]; then
        log_info "Configuration directory already exists: $CONFIG_DIR"
    else
        if mkdir -p "$CONFIG_DIR"; then
            log_success "Created configuration directory: $CONFIG_DIR"
        else
            log_error "Failed to create configuration directory"
            exit 1
        fi
    fi
}

# Backup existing configuration
backup_existing_config() {
    if [ -f "$CONFIG_FILE" ]; then
        log_step "Backing up existing configuration..."

        # Create backup directory
        mkdir -p "$BACKUP_DIR"

        # Create backup with timestamp
        local backup_file="$BACKUP_DIR/config_backup_$TIMESTAMP"

        if cp "$CONFIG_FILE" "$backup_file"; then
            log_success "Existing configuration backed up to: $backup_file"
            log_info "You can restore it later if needed"
        else
            log_error "Failed to backup existing configuration"
            exit 1
        fi
    else
        log_info "No existing configuration found - no backup needed"
    fi
}

# Create Ghostty configuration file
create_configuration() {
    log_step "Creating Ghostty configuration..."

    cat > "$CONFIG_FILE" << 'EOF'
# =============================================================================
# Ghostty Terminal Configuration
# =============================================================================
# Comprehensive configuration optimized for development workflows
# Features: Catppuccin Frappe theme, custom keybindings, and productivity settings
# =============================================================================

# Font Configuration
# ==================
font-size = 12

# Theme Configuration
# ===================
# Dark theme for better eye comfort during long coding sessions
theme = Catppuccin Frappe

# Shell Integration
# =================
# Enhanced shell integration features
shell-integration-features = no-cursor,sudo,no-title
#load zsh by default
shell-integration = zsh

# Cursor Configuration
# ====================
cursor-style = block

# Window Configuration
# ====================
# Balanced window padding for better visual comfort
window-padding-balance = true

# Always save window state for seamless workflow
window-save-state = always

# Mouse Configuration
# ===================
# Hide mouse cursor while typing for better focus
mouse-hide-while-typing = true

# Enhanced scrolling speed
mouse-scroll-multiplier = 2

# Custom Keybindings with Ctrl+S Prefix
# =====================================
# System and window management
keybind = ctrl+s>r=reload_config
keybind = ctrl+s>x=close_surface
keybind = ctrl+s>n=new_window

# Tab Management
# ==============
keybind = ctrl+s>c=new_tab
keybind = ctrl+s>shift+l=next_tab
keybind = ctrl+s>shift+h=previous_tab
keybind = ctrl+s>comma=move_tab:-1
keybind = ctrl+s>period=move_tab:1

# Quick tab switching (1-9)
keybind = ctrl+s>1=goto_tab:1
keybind = ctrl+s>2=goto_tab:2
keybind = ctrl+s>3=goto_tab:3
keybind = ctrl+s>4=goto_tab:4
keybind = ctrl+s>5=goto_tab:5
keybind = ctrl+s>6=goto_tab:6
keybind = ctrl+s>7=goto_tab:7
keybind = ctrl+s>8=goto_tab:8
keybind = ctrl+s>9=goto_tab:9

# Split Management
# ================
keybind = ctrl+s>\=new_split:right
keybind = ctrl+s>-=new_split:down

# Navigation between splits
keybind = ctrl+s>j=goto_split:bottom
keybind = ctrl+s>k=goto_split:top
keybind = ctrl+s>h=goto_split:left
keybind = ctrl+s>l=goto_split:right

# Split operations
keybind = ctrl+s>z=toggle_split_zoom
keybind = ctrl+s>e=equalize_splits
EOF

    if [ -f "$CONFIG_FILE" ]; then
        log_success "Configuration file created successfully"
        log_info "Configuration location: $CONFIG_FILE"
    else
        log_error "Failed to create configuration file"
        exit 1
    fi
}

# Verify configuration
verify_configuration() {
    log_step "Verifying Ghostty configuration..."

    # Check if config file exists and is readable
    if [ ! -f "$CONFIG_FILE" ]; then
        log_error "Configuration file not found"
        return 1
    fi

    # Check if config file has content
    if [ ! -s "$CONFIG_FILE" ]; then
        log_error "Configuration file is empty"
        return 1
    fi

    # Count keybindings in config
    local keybindings_count=$(grep -c "^keybind" "$CONFIG_FILE" 2>/dev/null || echo "0")

    if [ "$keybindings_count" -gt 0 ]; then
        log_success "Configuration verified with $keybindings_count custom keybindings"
    else
        log_warning "No custom keybindings found in configuration"
    fi

    # Check for theme configuration
    if grep -q "^theme = Catppuccin Frappe" "$CONFIG_FILE"; then
        log_success "Catppuccin Frappe theme configured"
    else
        log_warning "Theme configuration not found"
    fi

    return 0
}

# Display keybinding reference
display_keybinding_reference() {
    log_header "Ghostty Keybinding Reference"

    cat << 'EOF'

Main Keybindings (Ctrl+S prefix):
=================================

System & Windows:
-----------------
Ctrl+S + R  → Reload configuration
Ctrl+S + X  → Close current window
Ctrl+S + N  → New window

Tab Management:
---------------
Ctrl+S + C    → New tab
Ctrl+S + Shift+L → Next tab
Ctrl+S + Shift+H → Previous tab
Ctrl+S + ,    → Move tab left
Ctrl+S + .    → Move tab right
Ctrl+S + 1-9  → Go to tab 1-9

Split Management:
-----------------
Ctrl+S + \    → New split (right)
Ctrl+S + -    → New split (down)
Ctrl+S + J    → Navigate to bottom split
Ctrl+S + K    → Navigate to top split
Ctrl+S + H    → Navigate to left split
Ctrl+S + L    → Navigate to right split
Ctrl+S + Z    → Toggle split zoom
Ctrl+S + E    → Equalize all splits

Configuration Reload:
=====================
Use Ctrl+S+R to reload the configuration without restarting Ghostty.

EOF
}

# Test Ghostty installation
test_ghostty() {
    log_step "Testing Ghostty installation..."

    # Test if ghostty command works
    if ! command -v ghostty &> /dev/null; then
        log_error "Ghostty command not found"
        return 1
    fi

    # Test version command
    if ghostty --version &> /dev/null; then
        local version=$(ghostty --version | head -n1)
        log_success "Ghostty is working correctly ($version)"
    else
        log_error "Ghostty version command failed"
        return 1
    fi

    # Test help command
    if ghostty --help &> /dev/null; then
        log_success "Ghostty help command works"
    else
        log_warning "Ghostty help command failed (this is not critical)"
    fi

    return 0
}

# Display completion information
display_completion_info() {
    log_header "Installation Complete!"

    echo -e "${GREEN}✓ Ghostty Terminal has been successfully installed and configured${RESET}"
    echo -e "${GREEN}✓ Catppuccin Frappe dark theme is active${RESET}"
    echo -e "${GREEN}✓ Custom keybindings with Ctrl+S prefix are configured${RESET}"
    echo -e "${GREEN}✓ Configuration file: ${WHITE}$CONFIG_FILE${RESET}"

    if [ -f "$BACKUP_DIR/config_backup_$TIMESTAMP" ]; then
        echo -e "${GREEN}✓ Previous configuration backed up to: ${WHITE}$BACKUP_DIR/config_backup_$TIMESTAMP${RESET}"
    fi

    echo
    echo -e "${CYAN}To start Ghostty Terminal:${RESET}"
    echo -e "  ${WHITE}ghostty${RESET}"
    echo
    echo -e "${CYAN}To edit configuration:${RESET}"
    echo -e "  ${WHITE}nano $CONFIG_FILE${RESET}"
    echo
    echo -e "${CYAN}To reload configuration:${RESET}"
    echo -e "  ${WHITE}Ctrl+S+R${RESET} inside Ghostty"
    echo

    display_keybinding_reference
}

# Cleanup function
cleanup() {
    # Remove any temporary files if they exist
    log_info "Cleaning up temporary files..."
}

# Main installation function
main_installation() {
    log_header "Ghostty Terminal Installation Script"

    echo -e "${BLUE}This script will:${RESET}"
    echo -e "${WHITE}• Check system requirements${RESET}"
    echo -e "${WHITE}• Install Ghostty Terminal via Snap${RESET}"
    echo -e "${WHITE}• Create configuration directory${RESET}"
    echo -e "${WHITE}• Backup existing configuration (if any)${RESET}"
    echo -e "${WHITE}• Install comprehensive configuration${RESET}"
    echo -e "${WHITE}• Verify installation and configuration${RESET}"
    echo

    # Ask for confirmation
    read -p "Do you want to proceed? (y/N): " -n 1 -r
    echo

    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Installation cancelled by user"
        exit 0
    fi

    # Execute installation steps
    check_sudo
    check_requirements

    if ! check_ghostty_installed; then
        install_ghostty
    fi

    create_config_directory
    backup_existing_config
    create_configuration
    verify_configuration
    test_ghostty

    # Set trap for cleanup
    trap cleanup EXIT

    display_completion_info
}

# Script information
show_script_info() {
    log_header "Ghostty Terminal Installation Script"
    cat << 'EOF'
Version: 1.0.0
Author: AI Assistant
Description: Comprehensive Ghostty Terminal installation and configuration script

Features:
• Installs Ghostty via Snap package manager
• Configures Catppuccin Frappe dark theme
• Sets up custom keybindings with Ctrl+S prefix
• Includes development-optimized settings
• Provides backup and rollback capabilities
• Offers verification and testing

For more information about Ghostty:
https://ghostty.org

EOF
}

# Command line argument handling
case "${1:-}" in
    --help|-h)
        show_script_info
        cat << 'EOF'
Usage: ./master-ghostty.sh [OPTIONS]

Options:
    --help, -h      Show this help message
    --version       Show script version
    --config-only   Only install configuration (skip Ghostty installation)

Examples:
    ./master-ghostty.sh          # Full installation
    ./master-ghostty.sh --help   # Show help
    ./master-ghostty.sh --config-only  # Configuration only
EOF
        exit 0
        ;;
    --version)
        echo "master-ghostty.sh version 1.0.0"
        exit 0
        ;;
    --config-only)
        log_info "Configuration-only mode selected"
        create_config_directory
        backup_existing_config
        create_configuration
        verify_configuration
        display_completion_info
        exit 0
        ;;
    "")
        main_installation
        ;;
    *)
        log_error "Unknown option: $1"
        echo "Use --help for available options"
        exit 1
        ;;
esac