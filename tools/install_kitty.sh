#!/bin/bash

# =============================================================================
# Kitty Terminal Installation and Configuration Script
# =============================================================================
# This script will:
# 1. Install Kitty terminal emulator
# 2. Configure it with your custom settings
# 3. Set up Catppuccin Frappe theme
# 4. Configure all Ctrl+S keybindings
# =============================================================================

set -e  # Exit on any error

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
print_header() {
    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# Check if running with sudo (we don't want that for the whole script)
if [[ $EUID -eq 0 ]]; then
   print_error "This script should NOT be run as root or with sudo"
   print_info "The script will prompt for sudo password when needed"
   exit 1
fi

# Main installation
print_header "Kitty Terminal Installation Script"

echo "This script will install and configure Kitty terminal emulator."
echo "Your Ghostty configuration will be preserved as backup."
echo ""

read -p "Continue with installation? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_warning "Installation cancelled"
    exit 0
fi

# =============================================================================
# Step 1: Check Prerequisites
# =============================================================================
print_header "Step 1: Checking Prerequisites"

# Check if apt is available
if ! command -v apt &> /dev/null; then
    print_error "apt package manager not found"
    print_info "This script is designed for Ubuntu/Debian systems"
    exit 1
fi
print_success "Package manager found (apt)"

# Check if kitty.conf exists in script directory
if [[ ! -f "$SCRIPT_DIR/kitty.conf" ]]; then
    print_error "Configuration file not found: $SCRIPT_DIR/kitty.conf"
    print_info "Please ensure kitty.conf is in the same directory as this script"
    exit 1
fi
print_success "Configuration file found: $SCRIPT_DIR/kitty.conf"

# =============================================================================
# Step 2: Check if Kitty is Already Installed
# =============================================================================
print_header "Step 2: Checking Kitty Installation Status"

if command -v kitty &> /dev/null; then
    KITTY_VERSION=$(kitty --version | head -n1)
    print_warning "Kitty is already installed: $KITTY_VERSION"

    read -p "Reinstall/update Kitty? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        INSTALL_KITTY=true
    else
        INSTALL_KITTY=false
        print_info "Skipping Kitty installation"
    fi
else
    print_info "Kitty is not installed"
    INSTALL_KITTY=true
fi

# =============================================================================
# Step 3: Install Kitty
# =============================================================================
if [[ $INSTALL_KITTY == true ]]; then
    print_header "Step 3: Installing Kitty"

    print_info "Updating package list..."
    sudo apt update
    print_success "Package list updated"

    print_info "Installing Kitty terminal emulator..."
    sudo apt install -y kitty
    print_success "Kitty installed successfully"

    # Verify installation
    if command -v kitty &> /dev/null; then
        KITTY_VERSION=$(kitty --version | head -n1)
        print_success "Verified: $KITTY_VERSION"
    else
        print_error "Kitty installation failed"
        exit 1
    fi
else
    print_header "Step 3: Kitty Installation (Skipped)"
fi

# =============================================================================
# Step 4: Create Configuration Directory
# =============================================================================
print_header "Step 4: Setting Up Configuration Directory"

KITTY_CONFIG_DIR="$HOME/.config/kitty"

if [[ -d "$KITTY_CONFIG_DIR" ]]; then
    print_info "Configuration directory already exists: $KITTY_CONFIG_DIR"
else
    print_info "Creating configuration directory: $KITTY_CONFIG_DIR"
    mkdir -p "$KITTY_CONFIG_DIR"
    print_success "Configuration directory created"
fi

# =============================================================================
# Step 5: Backup Existing Configuration
# =============================================================================
print_header "Step 5: Backing Up Existing Configuration"

KITTY_CONFIG_FILE="$KITTY_CONFIG_DIR/kitty.conf"
BACKUP_DIR="$HOME/.config/kitty/backups"

if [[ -f "$KITTY_CONFIG_FILE" ]]; then
    print_warning "Existing configuration found"

    # Create backup directory
    mkdir -p "$BACKUP_DIR"

    # Create timestamped backup
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    BACKUP_FILE="$BACKUP_DIR/kitty.conf.backup.$TIMESTAMP"

    cp "$KITTY_CONFIG_FILE" "$BACKUP_FILE"
    print_success "Backup created: $BACKUP_FILE"
else
    print_info "No existing configuration to backup"
fi

# =============================================================================
# Step 6: Install Configuration
# =============================================================================
print_header "Step 6: Installing Configuration"

print_info "Copying configuration file..."
cp "$SCRIPT_DIR/kitty.conf" "$KITTY_CONFIG_FILE"
print_success "Configuration installed: $KITTY_CONFIG_FILE"

# Verify configuration syntax
print_info "Verifying configuration syntax..."
if kitty --debug-config 2>&1 | grep -qi "error"; then
    print_error "Configuration has errors"
    kitty --debug-config 2>&1 | grep -i "error"

    # Restore backup if it exists
    if [[ -f "$BACKUP_FILE" ]]; then
        print_warning "Restoring previous configuration..."
        cp "$BACKUP_FILE" "$KITTY_CONFIG_FILE"
        print_info "Previous configuration restored"
    fi
    exit 1
else
    print_success "Configuration is valid"
fi

# =============================================================================
# Step 7: Optional - Set Kitty as Default Terminal
# =============================================================================
print_header "Step 7: Set as Default Terminal (Optional)"

read -p "Set Kitty as your default terminal emulator? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_info "Setting Kitty as default terminal..."

    # Check if update-alternatives is available
    if command -v update-alternatives &> /dev/null; then
        sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator $(which kitty) 50
        sudo update-alternatives --set x-terminal-emulator $(which kitty)
        print_success "Kitty set as default terminal"
    else
        print_warning "update-alternatives not available, skipping"
    fi
else
    print_info "Keeping current default terminal"
fi

# =============================================================================
# Step 8: Create Desktop Entry (if needed)
# =============================================================================
print_header "Step 8: Verifying Desktop Integration"

DESKTOP_FILE="$HOME/.local/share/applications/kitty.desktop"

if [[ -f "$DESKTOP_FILE" ]] || [[ -f "/usr/share/applications/kitty.desktop" ]]; then
    print_success "Desktop entry exists"
else
    print_info "Creating desktop entry..."
    mkdir -p "$HOME/.local/share/applications"

    cat > "$DESKTOP_FILE" << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Kitty
GenericName=Terminal emulator
Comment=Fast, feature-rich, GPU based terminal
TryExec=kitty
Exec=kitty
Icon=kitty
Categories=System;TerminalEmulator;
EOF

    print_success "Desktop entry created"
fi

# =============================================================================
# Step 9: Install Additional Dependencies (Optional)
# =============================================================================
print_header "Step 9: Additional Dependencies (Optional)"

print_info "Checking for clipboard tools..."

if ! command -v xclip &> /dev/null && ! command -v xsel &> /dev/null; then
    read -p "Install xclip for better clipboard support? (Y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        print_info "Installing xclip..."
        sudo apt install -y xclip
        print_success "xclip installed"
    fi
else
    print_success "Clipboard tools already available"
fi

# =============================================================================
# Step 10: Backup Ghostty Configuration
# =============================================================================
print_header "Step 10: Preserving Ghostty Configuration"

GHOSTTY_CONFIG="$HOME/.config/ghostty/config"
GHOSTTY_BACKUP_DIR="$HOME/.config/ghostty/backups"

if [[ -f "$GHOSTTY_CONFIG" ]]; then
    print_info "Ghostty configuration found"

    mkdir -p "$GHOSTTY_BACKUP_DIR"
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    cp "$GHOSTTY_CONFIG" "$GHOSTTY_BACKUP_DIR/config.backup.$TIMESTAMP"

    print_success "Ghostty config backed up to: $GHOSTTY_BACKUP_DIR"
    print_info "You can switch back to Ghostty anytime"
else
    print_info "No Ghostty configuration found (this is fine)"
fi

# =============================================================================
# Installation Complete
# =============================================================================
print_header "Installation Complete!"

echo ""
print_success "Kitty terminal has been successfully installed and configured"
echo ""

# Show summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  INSTALLATION SUMMARY"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "✓ Kitty version:      $(kitty --version | head -n1)"
echo "✓ Configuration:      $KITTY_CONFIG_FILE"
echo "✓ Theme:              Catppuccin Frappe"
echo "✓ Keybindings:        Ctrl+S prefix (same as Ghostty)"
echo ""

if [[ -f "$BACKUP_FILE" ]]; then
    echo "✓ Previous config:    $BACKUP_FILE"
fi

if [[ -f "$GHOSTTY_CONFIG" ]]; then
    echo "✓ Ghostty backup:     $GHOSTTY_BACKUP_DIR"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Show next steps
print_header "Next Steps"

echo "1. Launch Kitty:"
echo "   ${GREEN}kitty${NC}"
echo ""
echo "2. Test keybindings:"
echo "   • New tab:        ${GREEN}Ctrl+S > C${NC}"
echo "   • Vertical split: ${GREEN}Ctrl+S > \\${NC}"
echo "   • Reload config:  ${GREEN}Ctrl+S > R${NC}"
echo ""
echo "3. Read the guides:"
echo "   • Quick reference: ${GREEN}cat ~/kitty_guide.md${NC}"
echo "   • Full migration:  ${GREEN}cat ~/KITTY_MIGRATION_GUIDE.md${NC}"
echo ""
echo "4. Important for Claude usage:"
echo "   • Use tabs instead of splits for multiple Claude instances"
echo "   • Avoid running intensive operations simultaneously"
echo "   • Let one Claude finish before starting another"
echo ""

# Offer to launch Kitty
read -p "Launch Kitty now? (Y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Nn]$ ]]; then
    print_info "Launching Kitty..."
    echo ""

    # Launch Kitty in background and detach from script
    nohup kitty > /dev/null 2>&1 &

    sleep 2
    print_success "Kitty launched!"
    print_info "Try: Ctrl+S > C to create a new tab"
else
    print_info "You can launch Kitty anytime by typing: kitty"
fi

echo ""
print_header "Installation Script Complete"
echo ""
echo "Enjoy your new terminal! 🚀"
echo ""

# Optional: Show keybinding cheatsheet
read -p "Display quick keybinding cheatsheet? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo "╔═══════════════════════════════════════════════════════╗"
    echo "║              KITTY CHEAT SHEET                        ║"
    echo "╠═══════════════════════════════════════════════════════╣"
    echo "║  TABS                        SPLITS                   ║"
    echo "║  ─────────────────────────  ───────────────────────   ║"
    echo "║  Ctrl+S > C    New         │ Ctrl+S > \\    Vertical  ║"
    echo "║  Ctrl+S > 1-9  Jump        │ Ctrl+S > -    Horizont. ║"
    echo "║  Ctrl+S > X    Close       │ Ctrl+S > HJKL Navigate  ║"
    echo "║  Ctrl+S > ,.   Reorder     │ Ctrl+S > Z    Zoom      ║"
    echo "║                             │ Ctrl+S > E    Equalize  ║"
    echo "╠═══════════════════════════════════════════════════════╣"
    echo "║  SYSTEM                      TEXT                     ║"
    echo "║  ─────────────────────────  ───────────────────────   ║"
    echo "║  Ctrl+S > R    Reload      │ Ctrl+Shift+C  Copy      ║"
    echo "║  Ctrl+S > N    New Window  │ Ctrl+Shift+V  Paste     ║"
    echo "║                             │ Ctrl+Shift+= Zoom in    ║"
    echo "║                             │ Ctrl+Shift+0 Reset      ║"
    echo "╚═══════════════════════════════════════════════════════╝"
    echo ""
fi

exit 0
