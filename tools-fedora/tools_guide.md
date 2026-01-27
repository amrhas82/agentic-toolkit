# 🛠️ Agent Dev Suite Tools Guide

Complete guide to all development tools and scripts available in the `/tools` directory. This guide provides practical usage instructions, code examples, and quick start commands for each tool.

## 📋 Table of Contents

- [🎯 Main Tools Menu](#-main-tools-menu)
- [🔧 Individual Setup Scripts](#-individual-setup-scripts)
- [📚 Documentation Guides](#-documentation-guides)
- [✅ Validation Tools](#-validation-tools)
- [🚀 Quick Start Commands](#-quick-start-commands)

---

## 🎯 Main Tools Menu

### `dev_tools_menu.sh` - Interactive Installation Menu

The main entry point for installing all development tools. Provides an interactive menu-driven interface for tool selection and installation.

#### **What it does:**
- Interactive menu system for tool installation
- Installs 10+ development tools and editors
- Handles dependency resolution automatically
- Provides colored output and progress feedback
- Supports individual or bulk installation

#### **Quick Start:**
```bash
cd /path/to/agentic-toolkit/tools
chmod +x dev_tools_menu.sh
./dev_tools_menu.sh
```

#### **Available Installation Options:**
1. **Claude Code** - AI-powered development assistant
2. **Ghostty** - Modern GPU-accelerated terminal
3. **Tmux** - Terminal multiplexer with TPM
4. **Neovim** - Modern Vim-based editor with plugins
5. **AmpCode** - Code editor (if available)
6. **Lazygit** - Git interface for terminal
7. **PyCharm** - Python IDE (via Snap)
8. **Lite XL** - Lightweight text editor
9. **Pass** - Password manager
10. **Cursor** - AI-powered code editor
11. **Sublime Text** - Advanced text editor
12. **Install All** - Bulk installation of all tools

#### **Code Example - Installation Function:**
```bash
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
```

---

## 🔧 Individual Setup Scripts

### `master_neovim_setup.sh` - Complete Neovim Environment

#### **What it does:**
- Installs Neovim from source (latest version)
- Configures nvim-tree file explorer
- Sets up Lazygit integration
- Installs essential plugins and configurations
- Creates complete development environment

#### **Quick Start:**
```bash
chmod +x master_neovim_setup.sh
./master_neovim_setup.sh
```

#### **Key Features:**
- Source-based installation for latest features
- Automatic dependency management
- Plugin configuration with modern Lua setup
- Git integration via Lazygit

#### **Code Example - Installation Check:**
```bash
# Check if running as root
if [ "$EUID" -eq 0 ]; then
    echo "Please do not run this script as root"
    echo "The script will ask for sudo password when needed"
    exit 1
fi

# Installation confirmation
read -p "Continue with installation? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Installation cancelled."
    exit 0
fi
```

### `master_tmux_setup.sh` - Tmux + TPM Complete Setup

#### **What it does:**
- Installs Tmux from source (latest version)
- Sets up TPM (Tmux Plugin Manager)
- Configures Catppuccin theme
- Installs essential plugins
- Creates optimized configuration

#### **Quick Start:**
```bash
chmod +x master_tmux_setup.sh
./master_tmux_setup.sh
```

#### **Key Features:**
- Latest Tmux version with all features
- Plugin management via TPM
- Beautiful Catppuccin theme
- Productivity-optimized configuration

### `master_litexl_setup.sh` - Lite XL with Advanced Features

#### **What it does:**
- Installs Lite XL text editor
- Configures SDL3 support
- Sets up Markdown preview
- Optimizes for development workflow

#### **Quick Start:**
```bash
chmod +x master_litexl_setup.sh
./master_litexl_setup.sh
```

#### **Key Features:**
- Lightweight, fast text editor
- SDL3 for better performance
- Markdown preview capabilities
- Development-optimized configuration

#### **Code Example - Status Functions:**
```bash
print_status() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

print_info() {
    echo -e "${YELLOW}[i]${NC} $1"
}
```

---

## 📚 Documentation Guides

### `git_guide.md` - Comprehensive Git Reference

#### **What it includes:**
- Complete Git command reference
- Branching and merging strategies
- Advanced Git operations
- Troubleshooting and best practices
- Workflow examples

#### **Key Sections:**
```markdown
## Table of Contents
1. Git Basics
2. Repository Management
3. Branching and Merging
4. Committing Changes
5. Remote Operations
6. History and Logging
7. Undoing Changes
8. Stashing
9. Tagging
10. Advanced Operations
```

#### **Usage Example:**
```bash
# From the guide - Basic workflow
git init my-project
cd my-project
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/user/repo.git
git push -u origin main
```

### `manual_setup.md` - Ubuntu Development Environment

#### **What it covers:**
- Terminal emulators (Ghostty, etc.)
- Text editors & IDEs
- AI-powered development tools
- Version control tools
- Password management
- Configuration & integration

#### **Installation Examples:**
```bash
# Ghostty Terminal
sudo dnf install -y ghostty

# Features:
- GPU acceleration for smooth rendering
- Built-in multiplexing capabilities
- Customizable themes and fonts
- Cross-platform support

# Kitty Terminal
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
# Or use automated script:
cd /path/to/agentic-toolkit/tools
./install_kitty.sh

# Features:
- Optimized GPU acceleration (lower resource usage)
- Built-in tabs and splits
- Catppuccin Frappe theme
- Custom Ctrl+S keybindings
- Better stability for heavy workloads
```

### `tmux-install-guide.md` - Tmux Installation Guide

#### **What it provides:**
- Step-by-step Tmux installation
- TPM setup instructions
- Plugin configuration
- Usage examples and shortcuts

### `PASS_INSTALLATION_GUIDE.md` - Password Manager Setup

#### **What it includes:**
- Pass password manager installation
- GPG key setup
- Git integration for password sync
- Usage examples and best practices

### `kitty_guide.md` - Kitty Terminal Quick Reference

#### **What it provides:**
- Complete keybinding reference with Ctrl+S prefix system
- Common workflows for development and Claude usage
- Split and tab management guide
- Visual layout examples and tips
- Troubleshooting section
- Printable cheat sheet

#### **Quick Start:**
```bash
# View guide
cat /path/to/agentic-toolkit/tools/kitty_guide.md

# Install Kitty with automation
./install_kitty.sh

# Manual installation
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
cp kitty.conf ~/.config/kitty/
```

#### **Key Features:**
- **Ctrl+S prefix system** - All keybindings use Ctrl+S prefix (same as Ghostty)
- **Tab management** - Ctrl+S > C (new), Ctrl+S > 1-9 (jump to tab)
- **Split management** - Ctrl+S > | (vertical), Ctrl+S > - (horizontal)
- **Navigation** - Ctrl+S > H/J/K/L (vim-style between splits)
- **Layouts** - Tall (side-by-side) and Fat (stacked) automatic layouts

### `KITTY_MIGRATION_GUIDE.md` - Complete Kitty Setup

#### **What it covers:**
- Full installation instructions
- Configuration file breakdown
- Catppuccin Frappe theme setup
- All keybinding mappings explained
- Troubleshooting and performance tips
- Migration from Ghostty
- Resource optimization for Intel integrated graphics

#### **Migration Checklist:**
- Install Kitty terminal
- Copy configuration files
- Test keybindings and splits
- Verify theme and colors
- Monitor resource usage
- Set as default terminal (optional)

---

## ✅ Validation Tools

### `validate_scripts.sh` - Script Testing Tool

#### **What it does:**
- Tests all master setup scripts
- Validates script structure and syntax
- Checks for common errors
- Provides detailed validation report

#### **Quick Start:**
```bash
chmod +x validate_scripts.sh
./validate_scripts.sh
```

#### **Code Example - Validation Logic:**
```bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PASSED=0
FAILED=0

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'

echo "================================================"
echo "  Script Validation Tool"
echo "================================================"
```

---

## 🚀 Quick Start Commands

### **For Complete Setup:**
```bash
# Clone and run the main menu
git clone <agentic-toolkit-repo>
cd agentic-toolkit/tools
chmod +x dev_tools_menu.sh
./dev_tools_menu.sh

# Choose option 12 for "Install All"
```

### **For Individual Tools:**
```bash
# Neovim setup
./master_neovim_setup.sh

# Tmux setup
./master_tmux_setup.sh

# Lite XL setup
./master_litexl_setup.sh

# Validate all scripts
./validate_scripts.sh
```

### **For Documentation:**
```bash
# Read Git guide
less git_guide.md

# Read manual setup guide
less manual_setup.md

# Read Tmux guide
less tmux-install-guide.md
```

---

## 📁 File Structure

```
tools/
├── dev_tools_menu.sh          # Main interactive installation menu
├── master_litexl_setup.sh     # Lite XL complete setup
├── master_neovim_setup.sh     # Neovim complete setup
├── master_tmux_setup.sh       # Tmux + TPM complete setup
├── validate_scripts.sh        # Script validation tool
├── git_guide.md              # Comprehensive Git reference
├── manual_setup.md           # Ubuntu development environment guide
├── tmux-install-guide.md     # Tmux installation guide
├── PASS_INSTALLATION_GUIDE.md # Password manager setup
├── tmux.conf                 # Tmux configuration file
└── tools_guide.md            # This file
```

---

## 🎯 Best Practices

### **Before Running Scripts:**
1. **Make scripts executable:** `chmod +x *.sh`
2. **Check system requirements:** Ubuntu/Debian-based systems
3. **Backup existing configurations:** Important for Neovim/Tmux
4. **Run validation first:** `./validate_scripts.sh`

### **During Installation:**
1. **Don't run as root:** Scripts will ask for sudo when needed
2. **Read prompts carefully:** Some installations require confirmation
3. **Check internet connection:** Scripts download dependencies
4. **Monitor output:** Watch for errors or warnings

### **After Installation:**
1. **Restart terminal:** Required for some tools
2. **Verify installations:** Check tool versions
3. **Configure as needed:** Customize settings to preference
4. **Test functionality:** Ensure tools work as expected

---

## 🔧 Troubleshooting

### **Common Issues:**

#### **Permission Denied:**
```bash
# Fix: Make scripts executable
chmod +x script_name.sh
```

#### **Network Issues:**
```bash
# Fix: Check internet connection and try again
ping google.com
# Re-run the script
```

#### **Dependency Conflicts:**
```bash
# Fix: Remove conflicting packages
sudo dnf remove -y package-name
# Re-run installation
```

#### **Configuration Conflicts:**
```bash
# Fix: Backup existing configs
mv ~/.config/nvim ~/.config/nvim.backup
mv ~/.tmux.conf ~/.tmux.conf.backup
```

---

## 📞 Support

For issues with specific tools:
1. Check the tool's official documentation
2. Run `./validate_scripts.sh` for script issues
3. Check system logs for error details
4. Ensure all dependencies are installed

---

## 🔄 Updates

To update tools after installation:
```bash
# Update package lists
sudo dnf check-update

# Upgrade installed packages
sudo dnf upgrade -y

# Re-run setup scripts for latest versions
./master_neovim_setup.sh
./master_tmux_setup.sh
```

---

*This guide covers all tools available in the `/tools` directory. For the most up-to-date information, check the individual script files and documentation.*
