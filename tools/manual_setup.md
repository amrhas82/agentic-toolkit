# Ubuntu Development Tools Setup Guide

## Table of Contents
- [Terminal Emulators](#terminal-emulators)
- [Text Editors & IDEs](#text-editors--ides)
- [AI-Powered Development Tools](#ai-powered-development-tools)
- [Version Control Tools](#version-control-tools)
- [Password Management](#password-management)
- [Terminal Multiplexer (Tmux)](#terminal-multiplexer-tmux)
- [Configuration & Integration](#configuration--integration)
- [Installation Checklist](#installation-checklist)

---

## Terminal Emulators

### Ghostty Terminal
Modern, GPU-accelerated terminal emulator with excellent performance.

```bash
sudo snap install ghostty --classic
```

**Features:**
- GPU acceleration for smooth rendering
- Built-in multiplexing capabilities
- Customizable themes and fonts
- Cross-platform support

---

## Text Editors & IDEs

### Neovim
Modern Vim-based text editor with Lua configuration and LSP support.

```bash
sudo snap install nvim --classic
```

**Features:**
- Built-in LSP support
- Lua-based configuration
- Tree-sitter syntax highlighting
- Telescope fuzzy finder

### Sublime Text
Lightweight, fast text editor with extensive plugin ecosystem.

```bash
# Install GPG key
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null

# Add repository
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

# Update and install
sudo apt update
sudo apt install sublime-text
```

**Features:**
- Lightning-fast performance
- Multiple cursors and selections
- Extensive plugin ecosystem
- Cross-platform support


### BMAD Method - Universal AI Agent Framework
#### [Github Repo]((https://github.com/bmad-code-org/BMAD-METHOD)) | [YouTube Setup](https://www.youtube.com/watch?v=fD8NLPU0WYU&t=445s)
- Two-Phase Process: Uses distinct planning and execution phases to structure development.
- Collaborative Planning: AI agents partner with humans to create detailed specifications.
- Context-Rich Execution: Plans are transformed into development stories with full context and guidance.
- Eliminates Key Flaws: Solves the core problems of planning inconsistency and context loss in AI development.

```bash
 sudo npx bmad-method install
 # BMad Agile Core System (v4.44.1) .bmad-core
 # Will the PRD (Product Requirements Document) be sharded into multiple files? (Y/n) 
 Yes
 # Will the architecture documentation be sharded into multiple files? (Y/n) 
 Yes
 # select your AI Agents
 Claude Code
 Cursor
 Kilocode
 # Would you like to include pre-built web bundles? (standalone files for ChatGPT, Claude, Gemini) (y/N)
 Yes
 ❯ All available bundles (agents, teams, expansion packs)
```

**Features:**
- Multi-role for any IDE AI Agent
- Less context consumption and detailed instructions
- Focused and guard-railed development
- Helps you refine your product ideas

### Lite XL
Lightweight, extensible text editor with Lua scripting.

```bash
# Install dependencies
sudo apt update
sudo apt install build-essential libsdl2-dev libfreetype6-dev

# Build from source (see master_litexl_setup.sh for complete setup)
```

**Features:**
- Lightweight and fast
- Lua-based plugin system
- Markdown preview support
- Cross-platform compatibility

### PyCharm Community
Full-featured Python IDE with debugging and testing tools.

```bash
sudo snap install pycharm-community --classic
```

**Features:**
- Intelligent code completion
- Built-in debugger and profiler
- Version control integration
- Database tools

---

## AI-Powered Development Tools

### Claude Code
AI-powered code assistant and editor.

```bash
# Install via npm (alternative)
npm install -g @anthropic-ai/claude-code

# Install stable version (recommended)
curl -fsSL https://claude.ai/install.sh | bash
```

**Features:**
- CLI AI-powered code suggestions
- Supports subagents
- Context-aware assistance
- Multiple language support

### Cursor AI CLI
AI-powered code editor with advanced features.

```bash
curl https://cursor.com/install -fsS | bash
```

**Features:**
- AI code completion and generation
- Chat-based development assistance
- Multi-file context understanding
- Integrated terminal and debugging

### AmpCode
AI-powered development environment with JetBrains integration.

```bash
curl -fsSL https://ampcode.com/install.sh | bash
amp --jetbrains
```

**Features:**
- JetBrains IDE integration
- AI-powered code suggestions
- Project management tools
- Team collaboration features


### Opencode
Open-source AI-powered CLI development environment.

```bash
curl -fsSL https://opencode.ai/install | bash
```

**Features:**
- Preloaded with free tiers through openrouter
- Supports subagents
- Works with BYOK 70+ models
- Team collaboration features
---

## Version Control Tools

### Git (Latest Version)
Distributed version control system.

```bash
# Method 1: Build from source (latest version)
wget https://github.com/git/git/archive/refs/tags/v2.40.0.tar.gz
tar -zxf v2.40.0.tar.gz
cd git-2.40.0
make prefix=/usr/local all
sudo make prefix=/usr/local install

# Method 2: Install from package manager
sudo apt install git
git --version
```

### Lazygit
Simple terminal UI for Git commands.

```bash
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/
lazygit --version
```

**Features:**
- Intuitive Git workflow
- Visual diff and merge tools
- Branch management
- Commit history browsing

### GitHub CLI
Command-line interface for GitHub.

```bash
sudo apt install gh
```

**Features:**
- Pull request and issue management
- Repository creation and cloning
- Authentication and authorization
- GitHub Actions integration

---

## Password Management

### Pass CLI
Unix password manager using GPG encryption.

```bash
sudo apt install pass
```

**Setup Instructions:**
1. Generate a GPG key: `gpg --gen-key`
2. Initialize pass: `pass init <your-gpg-key-id>`
3. Add passwords: `pass insert <path>`

**Features:**
- GPG-encrypted password storage
- Command-line interface
- Git integration for syncing
- Browser integration available

**For detailed setup:** See [Pass Installation Guide](PASS_INSTALLATION_GUIDE.md)

---

## Terminal Multiplexer (Tmux)

### Tmux Installation
Terminal multiplexer for managing multiple terminal sessions.

```bash
# Clone and build from source
git clone https://github.com/tmux/tmux.git
cd tmux
sh autogen.sh
./configure
make
sudo make install
```

**For complete setup:** See [Tmux Installation Guide](tmux-install-guide.md)

### Tmux Plugin Manager (TPM)
Plugin manager for extending Tmux functionality.

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

---

## Configuration & Integration

### Tmux Configuration Setup

1. **Install Tmux Plugin Manager:**
```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Verify installation
ls ~/.tmux/plugins/tpm
cd ~/.tmux/plugins/tpm
git status
```

2. **Create Tmux Configuration:**
```bash
# Check for existing config
ls -a ~ | grep .tmux.conf

# Create configuration file
nano ~/.tmux.conf
# OR
mkdir -p ~/.config/tmux
nano ~/.config/tmux/tmux.conf
```

3. **Reload Configuration:**
```bash
# For ~/.tmux.conf
tmux source-file ~/.tmux.conf

# For ~/.config/tmux/tmux.conf
tmux source-file ~/.config/tmux/tmux.conf
```

4. **Install Plugins:**
Inside tmux, press `Prefix + I` (Ctrl + Space + I) to install all plugins.

### Neovim with Tmux Navigator

1. **Create Neovim Config Directory:**
```bash
mkdir -p ~/.config/nvim/lua/custom
cd ~/.config/nvim
```

2. **Configure Plugins** (`lua/custom/plugins.lua`):
```lua
local plugins = {
  {
    "christoomey/vim-tmux-navigator",
    lazy = false
  }
}

return plugins
```

3. **Configure Key Mappings** (`lua/custom/mappings.lua`):
```lua
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
```

### Key Binding Reference

**Tmux Prefix:** `Ctrl + Space` (instead of default `Ctrl + b`)

**Pane Navigation:**
- `Prefix + h/j/k/l` - Navigate panes with prefix
- `Alt + Arrow Keys` - Navigate panes without prefix
- `Alt + H/L` - Switch windows without prefix

**Window Management:**
- `Shift + Left/Right` - Switch between windows
- `"` - Split window vertically
- `%` - Split window horizontally
- `Prefix + c` - Create new window
- `Prefix + 1` - Window selection

**Session Management:**
- `tmux ls` - List all sessions
- `tmux new -s session_name` - Create named session
- `tmux rename-window "Window Name"` - Rename current window
- `tmux kill-session -t session_name` - Kill specific session
- `tmux kill-session -a` - Kill all sessions except current

**Copy Mode (Vi-style):**
- `Prefix + [` - Enter copy mode
- `v` - Begin selection
- `Ctrl + v` - Rectangle toggle
- `y` - Copy selection

**Configuration Management:**
- `tmux source ~/.tmux.conf` - Reload configuration
- `Prefix + R` - Search commands
- `tmux kill server` - Exit all terminals

---

## Installation Checklist

### Core Terminal Environment
- [ ] Install Ghostty terminal
- [ ] Install Tmux and TPM
- [ ] Configure Tmux with provided config
- [ ] Test Tmux navigation and keybindings

### Text Editors & IDEs
- [ ] Install Neovim
- [ ] Install Sublime Text
- [ ] Install Lite XL (optional)
- [ ] Install PyCharm Community (optional)

### AI Development Tools
- [ ] Install Claude Code
- [ ] Install Cursor AI CLI
- [ ] Install AmpCode (optional)

### Version Control
- [ ] Update Git to latest version
- [ ] Install Lazygit
- [ ] Install GitHub CLI

### Password Management
- [ ] Install Pass CLI
- [ ] Set up GPG key
- [ ] Initialize password store

### Integration & Configuration
- [ ] Set up Neovim with Tmux navigator
- [ ] Test seamless navigation between tools
- [ ] Verify all keybindings work correctly

---

**After completing this setup, you'll have a comprehensive development environment with seamless navigation between Neovim and Tmux, AI-powered development tools, and a beautiful Catppuccin theme for enhanced productivity.**