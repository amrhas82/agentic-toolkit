#!/bin/bash

################################################################################
# Zsh Installation and Configuration Script
# This script automates the installation of Zsh with:
#   - Oh My Zsh framework
#   - Powerlevel10k theme (run: p10k configure)
#   - zsh-syntax-highlighting plugin
#   - zsh-autosuggestions plugin
################################################################################

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored messages
print_message() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

################################################################################
# Main Installation Process
################################################################################

print_message "Starting Zsh installation and configuration..."
echo ""

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    print_error "Please do not run this script as root or with sudo"
    exit 1
fi

################################################################################
# Step 1: Install Zsh
################################################################################

print_message "Step 1: Installing Zsh..."

if command_exists zsh; then
    print_warning "Zsh is already installed: $(zsh --version)"
else
    print_message "Installing Zsh..."
    sudo apt update
    sudo apt install -y zsh
    print_message "Zsh installed successfully: $(zsh --version)"
fi

echo ""

################################################################################
# Step 2: Install Oh My Zsh
################################################################################

print_message "Step 2: Installing Oh My Zsh..."

if [ -d "$HOME/.oh-my-zsh" ]; then
    print_warning "Oh My Zsh is already installed"
else
    print_message "Installing Oh My Zsh..."
    # Install Oh My Zsh in non-interactive mode
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    print_message "Oh My Zsh installed successfully"
fi

echo ""

################################################################################
# Step 3: Install Powerlevel10k Theme
################################################################################

print_message "Step 3: Installing Powerlevel10k theme..."

P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [ -d "$P10K_DIR" ]; then
    print_warning "Powerlevel10k is already installed"
else
    print_message "Cloning Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
    print_message "Powerlevel10k installed successfully"
fi

echo ""

################################################################################
# Step 4: Install Zsh Plugins
################################################################################

print_message "Step 4: Installing Zsh plugins..."

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# zsh-syntax-highlighting
if [ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    print_warning "zsh-syntax-highlighting is already installed"
else
    print_message "Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    print_message "zsh-syntax-highlighting installed"
fi

# zsh-autosuggestions
if [ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    print_warning "zsh-autosuggestions is already installed"
else
    print_message "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    print_message "zsh-autosuggestions installed"
fi

echo ""

################################################################################
# Step 5: Backup existing .zshrc
################################################################################

print_message "Step 5: Backing up existing .zshrc..."

if [ -f "$HOME/.zshrc" ]; then
    BACKUP_FILE="$HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)"
    cp "$HOME/.zshrc" "$BACKUP_FILE"
    print_message "Backup created: $BACKUP_FILE"
else
    print_warning "No existing .zshrc file found"
fi

echo ""

################################################################################
# Step 6: Configure Powerlevel10k Theme and Plugins
################################################################################

print_message "Step 6: Configuring Powerlevel10k theme and plugins..."

# Check if .zshrc exists
if [ ! -f "$HOME/.zshrc" ]; then
    print_error ".zshrc file not found. Oh My Zsh installation may have failed."
    exit 1
fi

# Update theme in .zshrc
if grep -q "^ZSH_THEME=" "$HOME/.zshrc"; then
    sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' "$HOME/.zshrc"
    print_message "Powerlevel10k theme configured in .zshrc"
else
    print_error "Could not find ZSH_THEME line in .zshrc"
    exit 1
fi

# Update plugins in .zshrc
if grep -q "^plugins=" "$HOME/.zshrc"; then
    sed -i 's/^plugins=.*/plugins=(git fzf zsh-syntax-highlighting zsh-autosuggestions)/' "$HOME/.zshrc"
    print_message "Plugins configured in .zshrc"
else
    print_warning "Could not find plugins line in .zshrc"
fi

echo ""

################################################################################
# Step 7: Set Zsh as default shell (optional)
################################################################################

print_message "Step 7: Checking default shell..."

CURRENT_SHELL=$(basename "$SHELL")
if [ "$CURRENT_SHELL" = "zsh" ]; then
    print_message "Zsh is already your default shell"
else
    print_warning "Current shell is: $CURRENT_SHELL"
    echo ""
    read -p "Would you like to set Zsh as your default shell? (y/N): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_message "Setting Zsh as default shell..."
        chsh -s "$(which zsh)"
        print_message "Default shell changed to Zsh"
        print_warning "You need to log out and log back in for the change to take effect"
    else
        print_message "Skipping default shell change"
        print_message "You can manually set Zsh as default later with: chsh -s \$(which zsh)"
    fi
fi

echo ""

################################################################################
# Installation Complete
################################################################################

print_message "=============================================="
print_message "Zsh Installation Complete!"
print_message "=============================================="
echo ""
print_message "Installed components:"
echo "  ✓ Zsh shell"
echo "  ✓ Oh My Zsh framework"
echo "  ✓ Powerlevel10k theme"
echo "  ✓ zsh-syntax-highlighting (colors commands as you type)"
echo "  ✓ zsh-autosuggestions (history suggestions, press → to accept)"
echo ""
print_message "Next steps:"
echo "  1. Start a new Zsh session: zsh"
echo "  2. The Powerlevel10k configuration wizard will start automatically"
echo "  3. Or run manually: p10k configure"
echo ""
print_message "To reconfigure Powerlevel10k later:"
echo "  • Run: p10k configure"
echo ""
print_warning "Note: For best appearance, install a Nerd Font"
echo "      (e.g., MesloLGS NF, FiraCode Nerd Font) and configure your terminal to use it."
echo ""
