# Fedora Development Tools Setup Guide

## Table of Contents
- [Terminal Emulators](#terminal-emulators)
- [Shell Environment (Zsh)](#shell-environment-zsh)
- [Text Editors & IDEs](#text-editors--ides)
- [AI-Powered Development Tools](#ai-powered-development-tools)
- [Version Control Tools](#version-control-tools)
- [Email Client](#email-client)
- [Password Management](#password-management)
- [Terminal Multiplexer (Tmux)](#terminal-multiplexer-tmux)
- [Configuration & Integration](#configuration--integration)
- [Installation Checklist](#installation-checklist)

---

## Terminal Emulators

### Ghostty Terminal
Modern, GPU-accelerated terminal emulator with excellent performance.

```bash
# Ghostty may not be in Fedora repos yet
# Install via Flatpak
flatpak install flathub com.mitchellh.ghostty

# Or build from source
git clone https://github.com/mitchellh/ghostty
cd ghostty
# Follow build instructions
```

**Features:**
- GPU acceleration for smooth rendering
- Built-in multiplexing capabilities
- Customizable themes and fonts
- Cross-platform support

### Kitty Terminal
Fast, feature-rich, GPU-accelerated terminal emulator optimized for performance and stability.

```bash
# Use the automated installation script (recommended)
cd /path/to/agentic-toolkit/tools-fedora
chmod +x install_kitty.sh
./install_kitty.sh

# Or install manually from official installer
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
```

**Features:**
- GPU-accelerated with lower resource usage than Ghostty
- Built-in tabs and splits (no tmux needed)
- Catppuccin Frappe theme pre-configured
- Custom Ctrl+S keybindings (same as Ghostty)
- Optimized for Intel integrated graphics
- Better stability for running multiple heavy processes (Claude, etc.)

**Configuration Files:**
- `kitty.conf` - Ready-to-use configuration
- `kitty_guide.md` - Complete keybinding reference
- `KITTY_MIGRATION_GUIDE.md` - Full setup guide
- `install_kitty.sh` - Automated installation script

**Quick Setup:**
```bash
# Copy config
mkdir -p ~/.config/kitty
cp kitty.conf ~/.config/kitty/

# Launch
kitty
```

**Common Keybindings:**
- `Ctrl+S > C` - New tab
- `Ctrl+S > |` - Vertical split (side-by-side)
- `Ctrl+S > -` - Horizontal split (top/bottom)
- `Ctrl+S > H/J/K/L` - Navigate between splits
- `Ctrl+S > 1-9` - Jump to tab
- `Ctrl+S > R` - Reload config

---

## Shell Environment (Zsh)

### Zsh Installation
Modern shell with powerful features and extensive customization options.

```bash
# Install Zsh
sudo dnf install -y zsh

# Optional: Set as default shell
chsh -s $(which zsh)

# Optional: to know where zsh looks for executables
echo $PATH
```

### Oh My Zsh
Framework for managing Zsh configuration with themes and plugins.

```bash
# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

**Features:**
- 300+ built-in plugins
- 150+ themes
- Auto-update system
- Plugin and theme management

**For detailed customization:** See [Zsh Configuration Guide](zsh-guide.md) for:
- Theme setup (Agnoster, Powerlevel10k)
- Plugin installation (syntax highlighting, auto-suggestions)
- ColorLS integration
- Complete configuration examples

### FZF (Fuzzy Finder)
Command-line fuzzy finder for files, command history, and processes.

```bash
# Install via dnf
sudo dnf install -y fzf

# Or clone and install from source
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

**Features:**
- Fuzzy file searching
- Command history search (Ctrl+R)
- Directory navigation
- Process list filtering
- Integration with Vim/Neovim and shell

---

## Text Editors & IDEs

### Neovim
Modern Vim-based text editor with Lua configuration and LSP support.

```bash
# Install from Fedora repos
sudo dnf install -y neovim

# Or via Flatpak
flatpak install flathub io.neovim.nvim
```

**Features:**
- Built-in LSP support
- Lua-based configuration
- Tree-sitter syntax highlighting
- Telescope fuzzy finder

### Sublime Text
Lightweight, fast text editor with extensive plugin ecosystem.

```bash
# Add RPM repository
sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
sudo dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo

# Install
sudo dnf install -y sublime-text
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
sudo dnf install -y @development-tools SDL2-devel freetype-devel

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
# Download PyCharm Community from https://www.jetbrains.com/pycharm/download/
# Save the .tar.gz file to ~/Downloads/

# Extract
cd ~/Downloads
tar -xzf pycharm-2025.3.2.tar.gz

# Run PyCharm
~/Downloads/pycharm-2025.3.2/bin/pycharm

# install python3 pip
sudo dnf install python3 python3-pip
# Create desktop entry (so it appears in app menu)
mkdir -p ~/.local/share/applications
cat > ~/.local/share/applications/pycharm.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=PyCharm
Comment=Python IDE for Professional Developers
Exec=$HOME/Downloads/pycharm-2025.3.2/bin/pycharm %f
Icon=$HOME/Downloads/pycharm-2025.3.2/bin/pycharm.png
Terminal=false
StartupNotify=true
StartupWMClass=jetbrains-pycharm
Categories=Development;IDE;
EOF
update-desktop-database ~/.local/share/applications/
```

**Features:**
- Intelligent code completion
- Built-in debugger and profiler
- Version control integration
- Database tools

### Thunderbird
Full-featured email client with calendar and contact management.

```bash
sudo dnf install -y thunderbird
```

**Features:**
- Email, calendar, and contacts
- Built-in RSS reader
- PGP/GPG encryption support
- Extensive add-on ecosystem

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
### Factory - Droid CLI
Open-source AI-powered CLI development environment.

```bash
curl -fsSL https://app.factory.ai/cli | sh
droid
```
**Features:**
- Monthly plan $20 with generous 20M token then usage based $2.70/1M Tokens
- Free plan BYOK - can work with Syntheic.new key [BYOK doc](https://docs.factory.ai/cli/byok/overview)
- Supports subagents/droids
- Extremely customizable (caches, mcp, autonomy, reasoning, CI/CD, integrations with Slack, Linear, Jira)


```bash

# ~/.factory/config.json
# provider one of: anthropic, openai, or generic-chat-completion-api
sudo nano ~/.factory/config.json
{
  "custom_models": [
    {
      "model_display_name": "GLM 4.6",
      "model": "glm-4.6",
      "base_url": "https://api.z.ai/api/anthropic",
      "api_key": "YOUR_API_KEY",
      "provider": "anthropic",
      "max_tokens": 16384
    },
    {
      "model_display_name": "Openrouter",
      "model": "anthropic/claude-sonnet-4.5",
      "base_url": "https://openrouter.ai/api/v1",
      "api_key": "YOUR_API_KEY",
      "provider": "generic-chat-completion-api",
      "max_tokens": 20480
    },
    {
      "model_display_name": "DeepSeek [Fireworks]",
      "model": "accounts/fireworks/models/deepseek-v3p1-terminus",
      "base_url": "https://api.fireworks.ai/inference/v1",
      "api_key": "YOUR_API_KEY",
      "provider": "generic-chat-completion-api",
      "max_tokens": 20480
    },
   {
      "model_display_name": "Qwen [Synthetic]",
      "model": "hf:Qwen/Qwen3-235B-A22B-Instruct-2507",
      "base_url": "https://api.synthetic.new/anthropic",
      "api_key": "YOUR_API_KEY",
      "provider": "anthropic",
      "max_tokens": 20480
    }
  ]
}
```
**Features:**
- CLI AI-powered code suggestions
- Supports subagents
- Context-aware assistance
- Multiple language support

### Cursor CLI
AI-powered code editor with advanced features.

```bash
curl https://cursor.com/install -fsS | bash
```

**Features:**
- AI code completion and generation
- Chat-based development assistance
- Multi-file context understanding
- Integrated terminal and debugging

### AmpCode CLI
AI-powered development environment with JetBrains integration.

```bash
curl -fsSL https://ampcode.com/install.sh | bash
amp
```

**Features:**
- JetBrains IDE integration
- AI-powered code suggestions
- Project management tools
- Team collaboration features


### Opencode CLI
Open-source AI-powered CLI development environment.

```bash
curl -fsSL https://opencode.ai/install | bash
opencode
# add new key BYOK
opencode auth login
```

**Features:**
- Preloaded with free tiers through openrouter
- Supports droids
- Works with BYOK 70+ models
- Team collaboration features
---

### Synthetic Web
Open-source AI-powered CLI development environment.

```bash
https://synthetic.new
```

**Features:**
- Monthly plan $20 with 5 hours reset windows 3x regular
- You can use API key with BYOK CLI (Opencode, Droid) or BYOK Plugin (Kilocode, Clime)
- Multi-models including Z.ai, GLM, MiniMax, Qwen, DeepSeek , Llama, Moonshoot
---


## Version Control Tools

### Git (Latest Version)
Distributed version control system.

```bash
# Install from Fedora repos (usually latest)
sudo dnf install -y git
git --version

# Or build from source for absolute latest
wget https://github.com/git/git/archive/refs/tags/v2.40.0.tar.gz
tar -zxf v2.40.0.tar.gz
cd git-2.40.0
make prefix=/usr/local all
sudo make prefix=/usr/local install
```

### Lazygit
Simple terminal UI for Git commands.

```bash
# Install via dnf (may be available)
sudo dnf install -y lazygit

# Or install from releases
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
sudo dnf install -y gh
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
sudo dnf install -y pass
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
# Install from Fedora repos
sudo dnf install -y tmux

# Or build from source for latest version
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

## Fedora-Specific Notes

### Enable RPM Fusion (Recommended)
For additional software not in default repos:

```bash
sudo dnf install -y \
    https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
```

### Flatpak Setup
Fedora ships with Flatpak by default, but you may need to enable Flathub:

```bash
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
```

### COPR Repositories
Fedora's equivalent to Ubuntu PPAs:

```bash
# Enable a COPR repo
sudo dnf copr enable user/project-name

# Install from COPR
sudo dnf install package-name
```

### Development Tools Group
Install common development tools at once:

```bash
sudo dnf groupinstall -y "Development Tools"
# Or
sudo dnf install -y @development-tools
```

---

## Installation Checklist

### Core Terminal Environment
- [ ] Install Kitty terminal (recommended for stability)
- [ ] Install Ghostty terminal (optional)
- [ ] Install Zsh shell
- [ ] Install Oh My Zsh framework
- [ ] Configure Zsh (see zsh-guide.md for customization)
- [ ] Install Tmux and TPM
- [ ] Configure Tmux with provided config
- [ ] Test Tmux navigation and keybindings

### Text Editors & IDEs
- [ ] Install Neovim
- [ ] Install Sublime Text
- [ ] Install Lite XL (optional)
- [ ] Install PyCharm Community (from tarball)

### AI Development Tools
- [ ] Install Claude Code
- [ ] Install Cursor AI CLI
- [ ] Install AmpCode (optional)
- [ ] Install Opencode CLI
- [ ] Install Factory Droid CLI

### Version Control
- [ ] Install/Update Git
- [ ] Install Lazygit
- [ ] Install GitHub CLI

### Email Client
- [ ] Install Thunderbird

### Password Management
- [ ] Install Pass CLI
- [ ] Set up GPG key
- [ ] Initialize password store

### Integration & Configuration
- [ ] Set up Neovim with Tmux navigator
- [ ] Test seamless navigation between tools
- [ ] Verify all keybindings work correctly

### Fedora-Specific Setup
- [ ] Enable RPM Fusion repositories
- [ ] Set up Flatpak/Flathub
- [ ] Install Development Tools group
- [ ] Configure any COPR repos needed

---

## Performance Tuning for Your Hardware

**Your system: Intel i7-8665U + 32GB RAM + Intel UHD 620**

### Fix Intel GPU Freezing

Add kernel parameters to `/etc/default/grub`:

```bash
sudo nano /etc/default/grub

# Add to GRUB_CMDLINE_LINUX_DEFAULT:
i915.enable_psr=0 i915.enable_fbc=0 intel_idle.max_cstate=1

# Update grub
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
sudo reboot
```

### Optimize Swap Usage

```bash
# Reduce swappiness for better responsiveness
echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```

### Enable SSD Trim

```bash
sudo systemctl enable fstrim.timer
sudo systemctl start fstrim.timer
```

---

**After completing this setup, you'll have a comprehensive Fedora development environment with seamless navigation between Neovim and Tmux, AI-powered development tools, and a beautiful Catppuccin theme for enhanced productivity.**
