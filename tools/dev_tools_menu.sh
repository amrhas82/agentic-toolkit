#!/bin/bash

# Development Tools Installation Menu
# Make executable with: chmod +x menu.sh
# Run with: ./menu.sh

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Function to print colored messages
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install Claude Code
install_claude_code() {
    print_info "Installing Claude Code..."
    if command_exists claude; then
        print_warning "Claude Code is already installed"
        claude --version
    else
        curl -fsSL https://claude.ai/install.sh | bash
        print_success "Claude Code installed successfully"
    fi
}

# Function to install Ghostty Terminal
install_ghostty() {
    print_info "Installing Ghostty Terminal..."
    if command_exists ghostty; then
        print_warning "Ghostty is already installed"
    else
        sudo snap install ghostty --classic
        print_success "Ghostty Terminal installed successfully"
    fi
}

# Function to install Tmux + TPM
install_tmux() {
    print_info "Installing Tmux + TPM..."
    
    if [ -f "$SCRIPT_DIR/master_tmux_setup.sh" ]; then
        bash "$SCRIPT_DIR/master_tmux_setup.sh"
        print_success "Tmux setup completed via master_tmux_setup.sh"
    else
        print_warning "master_tmux_setup.sh not found. Installing manually..."
        
        # Install dependencies
        sudo apt-get update
        sudo apt-get install -y libevent-dev ncurses-dev build-essential bison pkg-config automake
        
        # Clone and build tmux
        if [ ! -d "$HOME/tmux-build" ]; then
            git clone https://github.com/tmux/tmux.git "$HOME/tmux-build"
            cd "$HOME/tmux-build"
            sh autogen.sh
            ./configure
            make
            sudo make install
            cd "$SCRIPT_DIR"
            print_success "Tmux installed successfully"
        else
            print_warning "Tmux source already exists"
        fi
        
        # Install TPM
        if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
            git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
            print_success "TPM installed successfully"
        else
            print_warning "TPM is already installed"
        fi
    fi
}

# Function to install Neovim
install_neovim() {
    print_info "Installing Neovim..."
    
    if [ -f "$SCRIPT_DIR/master_neovim_setup.sh" ]; then
        bash "$SCRIPT_DIR/master_neovim_setup.sh"
        print_success "Neovim setup completed via master_neovim_setup.sh"
    else
        print_warning "master_neovim_setup.sh not found. Installing manually..."
        
        if command_exists nvim; then
            print_warning "Neovim is already installed"
            nvim --version | head -n 1
        else
            sudo snap install nvim --classic
            print_success "Neovim installed successfully"
        fi
        
        # Create config directories
        mkdir -p "$HOME/.config/nvim/lua/custom"
        
        # Create plugins.lua
        cat > "$HOME/.config/nvim/lua/custom/plugins.lua" << 'EOF'
local plugins = {
  {
    "christoomey/vim-tmux-navigator",
    lazy = false
  }
}

return plugins
EOF
        
        # Create mappings.lua
        cat > "$HOME/.config/nvim/lua/custom/mappings.lua" << 'EOF'
local M = {}

M.general = {
  n = {
    ["<C-h>"] = {"<cmd> TmuxNavigateLeft<CR>", "window left"},
    ["<C-l>"] = {"<cmd> TmuxNavigateRight<CR>", "window right"},
    ["<C-j>"] = {"<cmd> TmuxNavigateDown<CR>", "window down"},
    ["<C-k>"] = {"<cmd> TmuxNavigateUp<CR>", "window up"},
  }
}

return M
EOF
        
        print_success "Neovim configuration created"
    fi
}

# Function to install AmpCode
install_ampcode() {
    print_info "Installing AmpCode..."
    if command_exists amp; then
        print_warning "AmpCode is already installed"
    else
        curl -fsSL https://ampcode.com/install.sh | bash
        amp --jetbrains
        print_success "AmpCode installed successfully"
    fi
}

# Function to install Lazygit
install_lazygit() {
    print_info "Installing Lazygit..."
    if command_exists lazygit; then
        print_warning "Lazygit is already installed"
        lazygit --version
    else
        LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": *"v\K[^"]*')
        curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
        tar xf lazygit.tar.gz lazygit
        sudo install lazygit -D -t /usr/local/bin/
        rm lazygit lazygit.tar.gz
        print_success "Lazygit installed successfully"
        lazygit --version
    fi
}

# Function to update Git
update_git() {
    print_info "Updating Git to latest version..."
    GIT_VERSION="2.47.0"
    
    if [ -d "$HOME/git-build" ]; then
        rm -rf "$HOME/git-build"
    fi
    
    wget "https://github.com/git/git/archive/refs/tags/v${GIT_VERSION}.tar.gz" -O "$HOME/git-${GIT_VERSION}.tar.gz"
    tar -zxf "$HOME/git-${GIT_VERSION}.tar.gz" -C "$HOME"
    mv "$HOME/git-${GIT_VERSION}" "$HOME/git-build"
    cd "$HOME/git-build"
    
    sudo apt-get install -y libcurl4-openssl-dev libexpat1-dev gettext libssl-dev
    
    make prefix=/usr/local all
    sudo make prefix=/usr/local install
    
    cd "$SCRIPT_DIR"
    rm "$HOME/git-${GIT_VERSION}.tar.gz"
    
    print_success "Git updated successfully"
    git --version
}

# Function to install PyCharm Community
install_pycharm() {
    print_info "Installing PyCharm Community Edition..."
    
    if command_exists pycharm-community; then
        print_warning "PyCharm Community is already installed"
    else
        sudo snap install pycharm-community --classic
        print_success "PyCharm Community installed successfully"
    fi
}

# Function to install Lite XL
install_litexl() {
    print_info "Installing Lite XL..."
    
    if [ -f "$SCRIPT_DIR/master_litexl_setup.sh" ]; then
        bash "$SCRIPT_DIR/master_litexl_setup.sh"
        print_success "Lite XL setup completed via master_litexl_setup.sh"
    else
        print_warning "master_litexl_setup.sh not found. Installing manually..."
        
        if command_exists lite-xl; then
            print_warning "Lite XL is already installed"
            lite-xl --version
        else
            # Install dependencies
            sudo apt-get update
            sudo apt-get install -y build-essential git ninja-build libsdl2-dev \
                libfreetype6-dev python3-pip cmake
            
            # Install meson
            pip3 install --user --upgrade meson
            export PATH="$HOME/.local/bin:$PATH"
            
            # Build and install SDL3
            cd ~
            if [ -d "SDL" ]; then
                rm -rf SDL
            fi
            git clone https://github.com/libsdl-org/SDL.git
            cd SDL
            git checkout release-3.2.0
            mkdir -p build
            cd build
            cmake .. -DCMAKE_BUILD_TYPE=Release
            make -j$(nproc)
            sudo make install
            sudo ldconfig
            
            # Clone and build Lite XL
            cd ~
            if [ -d "lite-xl" ]; then
                rm -rf lite-xl
            fi
            git clone https://github.com/lite-xl/lite-xl.git
            cd lite-xl
            ~/.local/bin/meson setup build --buildtype=release
            ~/.local/bin/meson compile -C build
            sudo cp build/src/lite-xl /usr/local/bin/
            sudo mkdir -p /usr/local/share/lite-xl
            sudo cp -r data/* /usr/local/share/lite-xl/
            sudo chmod +x /usr/local/bin/lite-xl
            
            print_success "Lite XL installed successfully"
        fi
    fi
}

# Function to install Pass CLI password manager
install_pass() {
    print_info "Installing Pass CLI password manager..."
    
    if command_exists pass; then
        print_warning "Pass is already installed"
        pass version
    else
        sudo apt-get update
        sudo apt-get install -y pass
        print_success "Pass CLI password manager installed successfully"
        print_info "To initialize pass, run: pass init <gpg-key-id>"
        print_info "For more setup instructions, see: manual_setup.md"
    fi
}

# Function to install Cursor AI CLI
install_cursor() {
    print_info "Installing Cursor AI CLI..."
    
    if command_exists cursor; then
        print_warning "Cursor AI CLI is already installed"
        cursor --version
    else
        curl https://cursor.com/install -fsS | bash
        print_success "Cursor AI CLI installed successfully"
        print_info "For more setup instructions, see: manual_setup.md"
    fi
}

# Function to install Sublime Text
install_sublime() {
    print_info "Installing Sublime Text..."
    
    if command_exists subl; then
        print_warning "Sublime Text is already installed"
        subl --version
    else
        # Install GPG key
        print_info "Adding Sublime Text GPG key..."
        wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null
        
        # Add repository
        print_info "Adding Sublime Text repository..."
        echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
        
        # Update and install
        print_info "Installing Sublime Text..."
        sudo apt update
        sudo apt install -y sublime-text
        
        print_success "Sublime Text installed successfully"
        print_info "Launch with: subl"
    fi
}

# Function to install all tools
install_all() {
    print_info "Installing all development tools..."
    echo ""
    
    install_claude_code
    echo ""
    install_ghostty
    echo ""
    install_tmux
    echo ""
    install_neovim
    echo ""
    install_ampcode
    echo ""
    install_lazygit
    echo ""
    update_git
    echo ""
    install_pycharm
    echo ""
    install_litexl
    echo ""
    install_pass
    echo ""
    install_cursor
    echo ""
    install_sublime
    echo ""
    
    print_success "All tools installed successfully!"
}

# Function to display menu
show_menu() {
    clear
    echo -e "${BLUE}╔════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║     Development Tools Installation Menu       ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${GREEN}1)${NC} Install Claude Code"
    echo -e "${GREEN}2)${NC} Install Ghostty Terminal"
    echo -e "${GREEN}3)${NC} Install Tmux + TPM + Config (from source)"
    echo -e "${GREEN}4)${NC} Install Neovim + NvimTree + Plugins (from source)"
    echo -e "${GREEN}5)${NC} Install AmpCode"
    echo -e "${GREEN}6)${NC} Install Lazygit"
    echo -e "${GREEN}7)${NC} Update Git to Latest"
    echo -e "${GREEN}8)${NC} Install PyCharm Community"
    echo -e "${GREEN}9)${NC} Install Lite XL (Markdown Editor)"
    echo -e "${GREEN}10)${NC} Install Pass CLI (Password Manager)"
    echo -e "${GREEN}11)${NC} Install Cursor AI CLI"
    echo -e "${GREEN}12)${NC} Install Sublime Text"
    echo ""
    echo -e "${YELLOW}13)${NC} Install All Tools"
    echo ""
    echo -e "${RED}0)${NC} Exit"
    echo ""
    echo -n "Select an option: "
}

# Main loop
main() {
    while true; do
        show_menu
        read -r choice
        echo ""
        
        case $choice in
            1)
                install_claude_code
                ;;
            2)
                install_ghostty
                ;;
            3)
                install_tmux
                ;;
            4)
                install_neovim
                ;;
            5)
                install_ampcode
                ;;
            6)
                install_lazygit
                ;;
            7)
                update_git
                ;;
            8)
                install_pycharm
                ;;
            9)
                install_litexl
                ;;
            10)
                install_pass
                ;;
            11)
                install_cursor
                ;;
            12)
                install_sublime
                ;;
            13)
                install_all
                ;;
            0)
                print_info "Exiting..."
                exit 0
                ;;
            *)
                print_error "Invalid option. Please try again."
                ;;
        esac
        
        echo ""
        read -p "Press Enter to continue..."
    done
}

# Check if running as root
if [ "$EUID" -eq 0 ]; then 
    print_error "Please do not run this script as root"
    exit 1
fi

# Run main function
main