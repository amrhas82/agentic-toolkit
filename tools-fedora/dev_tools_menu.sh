#!/bin/bash

# Development Tools Installation Menu
# Make executable with: chmod +x menu.sh
# Run with: ./menu.sh
#
# Features CLI Tools, Editors, and Development Environment Setup

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

# Function to install Claude Code CLI
install_claude_code() {
    print_info "Installing Claude Code CLI - AI-powered code assistant and editor..."
    if command_exists claude; then
        print_warning "Claude Code CLI is already installed"
        claude --version
    else
        curl -fsSL https://claude.ai/install.sh | bash
        if [ $? -eq 0 ]; then
            print_success "Claude Code CLI installed successfully"
            claude --version 2>/dev/null || print_info "Please restart your terminal to use claude command"
        else
            print_error "Failed to install Claude Code CLI"
        fi
    fi
}

# Function to install Opencode CLI
install_opencode() {
    print_info "Installing Opencode CLI - Open-source AI-powered CLI development environment..."
    if command_exists opencode; then
        print_warning "Opencode CLI is already installed"
        opencode --version 2>/dev/null || print_info "Opencode CLI is installed"
    else
        curl -fsSL https://opencode.ai/install | bash
        if [ $? -eq 0 ]; then
            print_success "Opencode CLI installed successfully"
            print_info "To authenticate, run: opencode auth login"
        else
            print_error "Failed to install Opencode CLI"
        fi
    fi
}

# Function to install AmpCode CLI
install_ampcode() {
    print_info "Installing AmpCode CLI - AI-powered development environment with JetBrains integration..."
    if command_exists amp; then
        print_warning "AmpCode CLI is already installed"
        amp --version 2>/dev/null || print_info "AmpCode CLI is installed"
    else
        curl -fsSL https://ampcode.com/install.sh | bash
        if [ $? -eq 0 ]; then
            print_success "AmpCode CLI installed successfully"
            print_info "To enable JetBrains integration, run: amp --jetbrains"
        else
            print_error "Failed to install AmpCode CLI"
        fi
    fi
}

# Function to install Droid CLI
install_droid() {
    print_info "Installing Droid CLI - Open-source AI-powered CLI development environment..."
    if command_exists droid; then
        print_warning "Droid CLI is already installed"
        droid --version 2>/dev/null || print_info "Droid CLI is installed"
    else
        curl -fsSL https://app.factory.ai/cli | sh
        if [ $? -eq 0 ]; then
            print_success "Droid CLI installed successfully"
            print_info "To start using Droid, run: droid"
        else
            print_error "Failed to install Droid CLI"
        fi
    fi
}

# Function to install Zsh + Oh My Zsh + Agnoster
install_zsh() {
    print_info "Installing Zsh + Oh My Zsh + Agnoster theme..."

    if [ -f "$SCRIPT_DIR/master-zsh.sh" ]; then
        # Check if script is executable
        if [ ! -x "$SCRIPT_DIR/master-zsh.sh" ]; then
            print_info "Making master-zsh.sh executable..."
            chmod +x "$SCRIPT_DIR/master-zsh.sh"
        fi

        # Prompt user for confirmation
        echo -e "${YELLOW}This will install Zsh shell with Oh My Zsh and Agnoster theme.${NC}"
        echo -e "${YELLOW}Features: Modern shell, Oh My Zsh framework, Agnoster powerline theme${NC}"
        echo -e "${YELLOW}Note: For more customizations (plugins, themes), see zsh-guide.md${NC}"
        read -p "Do you want to continue? (y/N): " -n 1 -r
        echo ""

        if [[ $REPLY =~ ^[Yy]$ ]]; then
            bash "$SCRIPT_DIR/master-zsh.sh"
            print_success "Zsh setup completed via master-zsh.sh"
            print_info "For additional customizations, see: zsh-guide.md"
        else
            print_info "Installation cancelled."
        fi
    else
        print_error "master-zsh.sh not found in $SCRIPT_DIR"
        print_info "Please ensure the master-zsh.sh script exists in the tools directory."
    fi
}

# Function to install Ghostty Terminal
install_ghostty() {
    print_info "Installing Ghostty Terminal (GPU-accelerated terminal with Catppuccin theme)..."

    if [ -f "$SCRIPT_DIR/master-ghostty.sh" ]; then
        # Check if script is executable
        if [ ! -x "$SCRIPT_DIR/master-ghostty.sh" ]; then
            print_info "Making master-ghostty.sh executable..."
            chmod +x "$SCRIPT_DIR/master-ghostty.sh"
        fi

        # Prompt user for confirmation
        echo -e "${YELLOW}This will install Ghostty Terminal with custom configuration.${NC}"
        echo -e "${YELLOW}Features: GPU acceleration, Catppuccin theme, custom keybindings${NC}"
        read -p "Do you want to continue? (y/N): " -n 1 -r
        echo ""

        if [[ $REPLY =~ ^[Yy]$ ]]; then
            bash "$SCRIPT_DIR/master-ghostty.sh"
            print_success "Ghostty Terminal setup completed via master-ghostty.sh"
        else
            print_info "Installation cancelled."
        fi
    else
        print_error "master-ghostty.sh not found in $SCRIPT_DIR"
        print_info "Please ensure the master-ghostty.sh script exists in the tools directory."
    fi
}

# Function to install Kitty Terminal
install_kitty() {
    print_info "Installing Kitty Terminal (GPU-accelerated terminal with Catppuccin theme)..."

    if [ -f "$SCRIPT_DIR/install_kitty.sh" ]; then
        # Check if script is executable
        if [ ! -x "$SCRIPT_DIR/install_kitty.sh" ]; then
            print_info "Making install_kitty.sh executable..."
            chmod +x "$SCRIPT_DIR/install_kitty.sh"
        fi

        # Prompt user for confirmation
        echo -e "${YELLOW}This will install Kitty Terminal with custom configuration.${NC}"
        echo -e "${YELLOW}Features: GPU acceleration, Catppuccin Frappe theme, Ctrl+S keybindings${NC}"
        echo -e "${YELLOW}Note: Optimized for lower GPU usage to prevent system freezes${NC}"
        read -p "Do you want to continue? (y/N): " -n 1 -r
        echo ""

        if [[ $REPLY =~ ^[Yy]$ ]]; then
            bash "$SCRIPT_DIR/install_kitty.sh"
            print_success "Kitty Terminal setup completed via install_kitty.sh"
            print_info "For keybindings reference, see: kitty_guide.md"
        else
            print_info "Installation cancelled."
        fi
    else
        print_error "install_kitty.sh not found in $SCRIPT_DIR"
        print_info "Please ensure the install_kitty.sh script exists in the tools directory."
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
        sudo dnf check-update
        sudo dnf install -y libevent-devel ncurses-devel @development-tools bison pkg-config automake
        
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
            sudo dnf install -y neovim
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

# Function to install LazyVim
install_lazyvim() {
    print_info "Installing LazyVim (modern Neovim configuration with LSP support)..."

    if [ -f "$SCRIPT_DIR/master-lazyvim.sh" ]; then
        # Check if script is executable
        if [ ! -x "$SCRIPT_DIR/master-lazyvim.sh" ]; then
            print_info "Making master-lazyvim.sh executable..."
            chmod +x "$SCRIPT_DIR/master-lazyvim.sh"
        fi

        # Prompt user for confirmation
        echo -e "${YELLOW}This will install LazyVim with full development environment.${NC}"
        echo -e "${YELLOW}Features: Modern Neovim config, LSP, autocomplete, Git integration, themes${NC}"
        echo -e "${YELLOW}Note: This will backup existing Neovim configuration to ~/.config/nvim.bak${NC}"
        read -p "Do you want to continue? (y/N): " -n 1 -r
        echo ""

        if [[ $REPLY =~ ^[Yy]$ ]]; then
            bash "$SCRIPT_DIR/master-lazyvim.sh"
            print_success "LazyVim setup completed via master-lazyvim.sh"
            print_info "Your Neovim is now configured with LazyVim!"
            print_info "Start Neovim with 'nvim' to begin the setup process."
        else
            print_info "Installation cancelled."
        fi
    else
        print_error "master-lazyvim.sh not found in $SCRIPT_DIR"
        print_info "Please ensure the master-lazyvim.sh script exists in the tools directory."
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
    
    sudo dnf install -y libcurl-devel expat-devel gettext openssl-devel
    
    make prefix=/usr/local all
    sudo make prefix=/usr/local install
    
    cd "$SCRIPT_DIR"
    rm "$HOME/git-${GIT_VERSION}.tar.gz"
    
    print_success "Git updated successfully"
    git --version
}

# Function to install Thunderbird
install_thunderbird() {
    print_info "Installing Thunderbird email client..."

    if command_exists thunderbird; then
        print_warning "Thunderbird is already installed"
        thunderbird --version 2>/dev/null || true
    else
        sudo dnf install -y thunderbird
        if [ $? -eq 0 ]; then
            print_success "Thunderbird installed successfully"
        else
            print_error "Failed to install Thunderbird"
        fi
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
            sudo dnf check-update
            sudo dnf install -y @development-tools git ninja-build sdl2-devel \
                freetype-devel python3-pip cmake
            
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
        pass --version
    else
        sudo dnf install -y pass gnupg2
        if [ $? -eq 0 ]; then
            print_success "Pass CLI password manager installed successfully"
            print_info "To set up Pass, run the following:"
            print_info "  1. Generate a GPG key:  gpg --gen-key"
            print_info "  2. Get your key ID:     gpg --list-keys"
            print_info "  3. Initialize pass:     pass init <your-gpg-key-id>"
        else
            print_error "Failed to install Pass CLI"
        fi
    fi
}

# Function to install GitHub CLI
install_github_cli() {
    print_info "Installing GitHub CLI..."

    if command_exists gh; then
        print_warning "GitHub CLI is already installed"
        gh --version
    else
        sudo dnf install -y gh
        if [ $? -eq 0 ]; then
            print_success "GitHub CLI installed successfully"
            print_info "Run 'gh auth login' to authenticate (one-time setup)"
            print_info "Select: GitHub.com → HTTPS → Login with a web browser"
            read -p "Do you want to authenticate now? (y/N): " -n 1 -r
            echo ""
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                gh auth login
            fi
        else
            print_error "Failed to install GitHub CLI"
        fi
    fi
}

# Function to install FZF (Fuzzy Finder)
install_fzf() {
    print_info "Installing FZF (Fuzzy Finder)..."

    if [ -d "$HOME/.fzf" ]; then
        print_warning "FZF is already installed at ~/.fzf"
        print_info "To reinstall, remove ~/.fzf directory first"
    else
        git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
        if [ $? -eq 0 ]; then
            print_success "FZF cloned successfully"
            print_info "Running FZF installation script..."
            "$HOME/.fzf/install"
            if [ $? -eq 0 ]; then
                print_success "FZF installed successfully"
                print_info "Features: Fuzzy file search, command history (Ctrl+R), directory navigation"
                print_info "Please restart your terminal or source your shell config to use FZF"
            else
                print_error "FZF installation script failed"
            fi
        else
            print_error "Failed to clone FZF repository"
        fi
    fi
}

# Function to install Cursor CLI
install_cursor() {
    print_info "Installing Cursor CLI - AI-powered code editor with advanced features..."

    if command_exists cursor; then
        print_warning "Cursor CLI is already installed"
        cursor --version 2>/dev/null || print_info "Cursor CLI is installed"
    else
        curl https://cursor.com/install -fsS | bash
        if [ $? -eq 0 ]; then
            print_success "Cursor CLI installed successfully"
        else
            print_error "Failed to install Cursor CLI"
        fi
    fi
}

# Function to install Sublime Text
install_sublime() {
    print_info "Installing Sublime Text..."
    
    if command_exists subl; then
        print_warning "Sublime Text is already installed"
        subl --version
    else
        # Import GPG key and add repo for Fedora
        print_info "Adding Sublime Text repository..."
        sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
        sudo dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo

        # Install
        print_info "Installing Sublime Text..."
        sudo dnf install -y sublime-text
        
        print_success "Sublime Text installed successfully"
        print_info "Launch with: subl"
    fi
}

# Function to install all tools
install_all() {
    print_info "Installing all development tools in the specified order..."
    echo ""

    # CLI Tools
    print_info "=== Installing CLI Tools ==="
    install_claude_code
    echo ""
    install_opencode
    echo ""
    install_ampcode
    echo ""
    install_droid
    echo ""
    install_cursor
    echo ""

    # Core Development Tools
    print_info "=== Installing Core Development Tools ==="
    update_git
    echo ""
    install_neovim
    echo ""
    install_zsh
    echo ""
    install_ghostty
    echo ""
    install_kitty
    echo ""
    install_lazyvim
    echo ""
    install_lazygit
    echo ""
    install_sublime
    echo ""
    install_tmux
    echo ""
    install_litexl
    echo ""
    install_pass
    echo ""
    install_fzf
    echo ""
    install_thunderbird
    echo ""
    install_github_cli
    echo ""

    print_success "All development tools installed successfully!"
    print_info "Please restart your terminal to ensure all commands are available."
}

# Function to display menu
show_menu() {
    clear
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║        Development Tools Installation Menu              ║${NC}"
    echo -e "${BLUE}║           CLI Tools, Editors & Environment              ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}=== AI-Powered CLI Tools ===${NC}"
    echo -e "${GREEN}1)${NC} Install Claude Code CLI"
    echo -e "${GREEN}2)${NC} Install Opencode CLI"
    echo -e "${GREEN}3)${NC} Install AmpCode CLI"
    echo -e "${GREEN}4)${NC} Install Droid CLI"
    echo -e "${GREEN}5)${NC} Install Cursor CLI"
    echo ""
    echo -e "${YELLOW}=== Core Development Tools ===${NC}"
    echo -e "${GREEN}6)${NC} Update Git to Latest"
    echo -e "${GREEN}7)${NC} Install Neovim + NvimTree + Plugins (from source)"
    echo -e "${GREEN}8)${NC} Install Zsh + Oh My Zsh + Agnoster Theme"
    echo -e "${GREEN}9)${NC} Install Ghostty Terminal"
    echo -e "${GREEN}10)${NC} Install Kitty Terminal"
    echo -e "${GREEN}11)${NC} Install LazyVim (Requires Neovim + Ghostty/Kitty)"
    echo -e "${GREEN}12)${NC} Install Lazygit"
    echo -e "${GREEN}13)${NC} Install Sublime Text"
    echo -e "${GREEN}14)${NC} Install Tmux + TPM + Config (from source)"
    echo -e "${GREEN}15)${NC} Install Lite XL (Markdown Editor)"
    echo -e "${GREEN}16)${NC} Install Pass CLI (Password Manager)"
    echo -e "${GREEN}17)${NC} Install FZF (Fuzzy Finder)"
    echo -e "${GREEN}18)${NC} Install Thunderbird (Email Client)"
    echo -e "${GREEN}19)${NC} Install GitHub CLI (gh auth login)"
    echo ""
    echo -e "${YELLOW}20)${NC} Install All Tools"
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
                install_opencode
                ;;
            3)
                install_ampcode
                ;;
            4)
                install_droid
                ;;
            5)
                install_cursor
                ;;
            6)
                update_git
                ;;
            7)
                install_neovim
                ;;
            8)
                install_zsh
                ;;
            9)
                install_ghostty
                ;;
            10)
                install_kitty
                ;;
            11)
                install_lazyvim
                ;;
            12)
                install_lazygit
                ;;
            13)
                install_sublime
                ;;
            14)
                install_tmux
                ;;
            15)
                install_litexl
                ;;
            16)
                install_pass
                ;;
            17)
                install_fzf
                ;;
            18)
                install_thunderbird
                ;;
            19)
                install_github_cli
                ;;
            20)
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