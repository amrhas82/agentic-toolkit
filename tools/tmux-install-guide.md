# Installing tmux from Source

This guide covers installing the latest version of tmux from the GitHub repository.

## Prerequisites

Install all required build dependencies before compiling:

```bash
sudo apt update
sudo apt install -y libevent-dev ncurses-dev build-essential bison pkg-config automake autoconf
```

## Installation Steps

### 1. Clone the Repository

```bash
git clone https://github.com/tmux/tmux.git
cd tmux
```

### 2. Build and Install

```bash
sh autogen.sh
./configure
make
sudo make install
```

### 3. Verify Installation

```bash
tmux -V
```

You should see something like `tmux next-3.6` or similar.

### 4. Clean Up Old Sessions (If Needed)

If you encounter errors like "server exited unexpectedly", clean up old socket files:

```bash
tmux kill-server
rm -rf /tmp/tmux-*
```

### 5. Start tmux

```bash
tmux
```

## Troubleshooting

### "open terminal failed: not a terminal"

Check your TERM variable:

```bash
echo $TERM
```

If empty or unusual, set it:

```bash
export TERM=xterm-256color
tmux
```

### "server exited unexpectedly"

This usually means old socket files are causing conflicts:

```bash
rm -rf /tmp/tmux-*
tmux
```

### Verify Compilation Success

Check that dependencies were found during configuration:

```bash
./configure 2>&1 | grep -i term
./configure 2>&1 | grep -i event
```

You should see:
- `checking for LIBEVENT_CORE... yes`
- `checking for LIBTINFO... yes`

## Updating tmux

To update to the latest version:

```bash
cd ~/tmux
git pull
make clean
sh autogen.sh
./configure
make
sudo make install
rm -rf /tmp/tmux-*  # Clean old sockets
```

## Setting Up tmux Plugin Manager (TPM)

### 1. Install TPM

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

### 2. Create or Edit tmux Configuration

Create/edit `~/.tmux.conf`:

```bash
nano ~/.tmux.conf
```

### 3. Add TPM Configuration

Add this line at the **bottom** of your `~/.tmux.conf`:

```bash
# Initialize TPM (keep this line at the very bottom of tmux.conf)
run '~/.tmux/plugins/tpm/tpm'
```

### 4. Reload tmux Configuration

If tmux is already running:

```bash
tmux source ~/.tmux.conf
```

Or press `Ctrl+a` then type `:source ~/.tmux.conf` inside tmux.

### 5. Install Plugins

Inside tmux, press:
- `Ctrl+a` + `I` (capital i) to fetch and install plugins

### 6. Additional Plugin Commands

- `Ctrl+a` + `U` - Update plugins
- `Ctrl+a` + `alt+u` - Uninstall plugins not in the list

## Sample tmux.conf

Here's a complete configuration with plugins and customizations:

```bash
set-option -sa terminal-overrides ",xterm*:Tc"

# Turn mouse on
set -g mouse on

# Change Prefix from Ctrl+b to Ctrl+a
unbind C-b
set-option -g prefix C-a
bind-key C-a send-prefix

# tmux.conf hot reload
bind r source-file ~/.tmux.conf\; display "Reloaded!"

# Fix backspace issue
set -g default-terminal "xterm-256color"

# Vim style pane selection
bind h select-pane -L
bind j select-pane -D 
bind k select-pane -U
bind l select-pane -R

# Start windows and panes at 1, not 0
set -g base-index 1
set -g pane-base-index 1
set-window-option -g pane-base-index 1
set-option -g renumber-windows on

# Use Alt-arrow keys without prefix key to switch panes
bind -n M-Left select-pane -L
bind -n M-Right select-pane -R
bind -n M-Up select-pane -U
bind -n M-Down select-pane -D

# Shift arrow to switch windows
bind -n S-Left  previous-window
bind -n S-Right next-window

# Shift Alt vim keys to switch windows
bind -n M-H previous-window
bind -n M-L next-window

# Set catppuccin color theme
set -g @catppuccin_flavour 'mocha'
set -g @catppuccin_flavor "mocha"
set -g @catppuccin_window_status_style "rounded"

# Make the status line pretty and add some modules
set -g status-right-length 100
set -g status-left-length 100
set -g status-left ""
set -g status-right "#{E:@catppuccin_status_application}"
set -agF status-right "#{E:@catppuccin_status_cpu}"
set -ag status-right "#{E:@catppuccin_status_session}"
set -ag status-right "#{E:@catppuccin_status_uptime}"
set -agF status-right "#{E:@catppuccin_status_battery}"

# Set all plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'christoomey/vim-tmux-navigator'
set -g @plugin 'dreamsofcode-io/catppuccin-tmux'
set -g @plugin 'tmux-plugins/tmux-yank'
set -g @plugin 'tmux-plugins/tmux-copycat'

# Set vi-mode
set-window-option -g mode-keys vi

# Keybindings for copy mode
bind-key -T copy-mode-vi v send-keys -X begin-selection
bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

# Split windows with current path
bind '"' split-window -v -c "#{pane_current_path}"
bind % split-window -h -c "#{pane_current_path}"

# Initialize TPM (keep this line at the very bottom)
run '~/.tmux/plugins/tpm/tpm'
```

### Applying the Configuration

1. Save the file
2. If tmux is running: `tmux source ~/.tmux.conf`
3. Press `Ctrl+a` + `I` to install plugins
4. Restart tmux or press `Ctrl+a` + `r` to reload

## Notes

- tmux installs to `/usr/local/bin/tmux` by default
- Old socket files in `/tmp/tmux-*` can cause issues after upgrades
- Always install dependencies before running `./configure`
- The prefix key is changed to `Ctrl+a` in the sample config (default is `Ctrl+b`)
- TPM initialization must be at the bottom of your config file
