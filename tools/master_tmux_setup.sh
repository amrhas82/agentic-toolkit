#!/bin/bash

# Tmux + TPM Complete Setup Script
# Installs and configures: Tmux (from source) + TPM + plugins + config

set -e

echo "================================================"
echo "  Tmux + TPM Setup"
echo "================================================"
echo ""
echo "This script will install and configure:"
echo "  • Tmux (latest from source)"
echo "  • TPM (Tmux Plugin Manager)"
echo "  • Catppuccin theme with plugins"
echo "  • Complete tmux configuration"
echo ""
read -p "Continue with installation? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Installation cancelled."
    exit 0
fi

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    echo "Please do not run this script as root"
    echo "The script will ask for sudo password when needed"
    exit 1
fi

# ==========================================
# TMUX SETUP
# ==========================================

echo ""
echo "================================================"
echo "Setting up Tmux"
echo "================================================"
echo ""

echo "Installing Tmux build dependencies..."
sudo apt update
sudo apt install -y \
    libevent-dev \
    ncurses-dev \
    bison \
    pkg-config \
    automake \
    autoconf \
    build-essential \
    git

# Create temporary directory
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

echo ""
echo "Cloning Tmux repository..."
git clone https://github.com/tmux/tmux.git
cd tmux

echo ""
echo "Building Tmux from source..."
sh autogen.sh
./configure
make
sudo make install

echo ""
echo "Cleaning up old tmux socket files..."
tmux kill-server 2>/dev/null || true
rm -rf /tmp/tmux-* 2>/dev/null || true

cd ~
rm -rf "$TEMP_DIR"

echo ""
echo "Installing Tmux Plugin Manager (TPM)..."
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [ -d "$TPM_DIR" ]; then
    cd "$TPM_DIR"
    git pull
else
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

cd ~

echo ""
echo "Creating Tmux configuration..."
cat > ~/.tmux.conf << 'TMUX_EOF'
set-option -sa terminal-overrides ",xterm*:Tc"
set -g default-terminal "xterm-256color"
set -g mouse on

unbind C-b
set-option -g prefix C-a
bind-key C-a send-prefix

bind r source-file ~/.tmux.conf\; display "Reloaded!"

bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

set -g base-index 1
set -g pane-base-index 1
set-window-option -g pane-base-index 1
set-option -g renumber-windows on

bind -n M-Left select-pane -L
bind -n M-Right select-pane -R
bind -n M-Up select-pane -U
bind -n M-Down select-pane -D

bind -n S-Left  previous-window
bind -n S-Right next-window

bind -n M-H previous-window
bind -n M-L next-window

set -g @catppuccin_flavour 'mocha'
set -g @catppuccin_flavor "mocha"
set -g @catppuccin_window_status_style "rounded"

set -g status-right-length 100
set -g status-left-length 100
set -g status-left ""
set -g status-right "#{E:@catppuccin_status_application}"
set -agF status-right "#{E:@catppuccin_status_cpu}"
set -ag status-right "#{E:@catppuccin_status_session}"
set -ag status-right "#{E:@catppuccin_status_uptime}"
set -agF status-right "#{E:@catppuccin_status_battery}"

set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'christoomey/vim-tmux-navigator'
set -g @plugin 'dreamsofcode-io/catppuccin-tmux'
set -g @plugin 'tmux-plugins/tmux-yank'
set -g @plugin 'tmux-plugins/tmux-copycat'

set-window-option -g mode-keys vi

bind-key -T copy-mode-vi v send-keys -X begin-selection
bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

bind '"' split-window -v -c "#{pane_current_path}"
bind % split-window -h -c "#{pane_current_path}"

run '~/.tmux/plugins/tpm/tpm'
TMUX_EOF

echo ""
echo "Installing Tmux plugins..."
export TERM=xterm-256color
tmux start-server
tmux new-session -d -s setup
sleep 2
"$TPM_DIR/bin/install_plugins"
tmux kill-session -t setup 2>/dev/null || true

echo "✓ Tmux setup complete"

# ==========================================
# COMPLETION SUMMARY
# ==========================================

echo ""
echo "================================================"
echo "  ✓ Tmux Setup Finished!"
echo "================================================"
echo ""
echo "Installed Software:"
echo "  • Tmux: $(tmux -V)"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "TMUX KEYBINDINGS (Prefix = Ctrl+a)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Ctrl+a c        - New window"
echo "  Ctrl+a %        - Split horizontal"
echo "  Ctrl+a \"        - Split vertical"
echo "  Ctrl+a h/j/k/l  - Navigate panes (vim style)"
echo "  Shift+Left/Right- Switch windows"
echo "  Ctrl+a d        - Detach session"
echo "  Ctrl+a r        - Reload config"
echo ""
echo "Quick Start:"
echo "  1. Start tmux: tmux"
echo "  2. Use prefix (Ctrl+a) + commands above"
echo ""
echo "Configuration File:"
echo "  • Tmux: ~/.tmux.conf"
echo ""
echo "Installed Plugins:"
echo "  • TPM (Plugin Manager)"
echo "  • tmux-sensible (sensible defaults)"
echo "  • vim-tmux-navigator (seamless vim/tmux navigation)"
echo "  • catppuccin-tmux (Mocha theme)"
echo "  • tmux-yank (clipboard integration)"
echo "  • tmux-copycat (search enhancement)"
echo ""
echo "Enjoy your new tmux setup! 🚀"
echo ""
