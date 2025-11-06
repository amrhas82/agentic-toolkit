# TMUX Quick Guide

## Basic Key Bindings
**Prefix Key:** `Ctrl-a` (changed from default Ctrl-b)

### Window Management
- `Ctrl-a c` - Create new window
- `Ctrl-a n` - Next window
- `Ctrl-a p` - Previous window
- `Ctrl-a 0-9` - Switch to window 0-9
- `Ctrl-a w` - Show window tree (select with arrow keys)
- `Ctrl-a ,` - Rename current window

### Pane Management
- `Ctrl-a "` - Split pane horizontally
- `Ctrl-a %` - Split pane vertically
- `Ctrl-a arrow keys` - Switch between panes
- `Ctrl-a h/j/k/l` - Vim-style pane navigation
- `Ctrl-a x` - Close current pane
- `Ctrl-a z` - Zoom/Unzoom current pane

### Mouse Operations
- **Click pane** - Activate/focus pane
- **Drag-select text** - Copy to clipboard automatically
- **Middle-click** - Paste from clipboard
- **Scroll wheel** - Navigate through pane history

### Copy/Paste
**Mouse Method:**
1. Drag-select text with mouse (automatically copies)
2. Middle-click to paste

**Keyboard Method:**
1. `Ctrl-a [` - Enter copy mode
2. Use `v` to start selection, navigate with arrow keys
3. Press `y` to copy
4. `Ctrl-a ]` to paste

### Navigation & Search
- `Ctrl-a [` then `Shift+g` - Go to bottom of pane history
- `Ctrl-a [` then `g` - Go to top of pane history
- `Ctrl-d` - Scroll down half page
- `Ctrl-u` - Scroll up half page
- `Ctrl-a f` - Search for text in windows (tmux-copycat)

### Useful Commands
- `Ctrl-a r` - Reload tmux config
- `Ctrl-a d` - Detach from tmux session
- `tmux attach` - Reattach to session
- `tmux kill-server` - Restart tmux completely

### Current Features (Based on your config)
- Catppuccin mocha theme with colorful window tabs
- Mouse support: click panes, copy/paste with drag-select
- Vim-style navigation (h,j,k,l for panes)
- Window numbering starts from 1 (not 0)
- Panes split with current working directory preserved

### Quick Start Commands
```bash
# Start tmux
tmux

# Reload config after changes
tmux source-file ~/.tmux.conf

# Detach and reattach
Ctrl-a d  # detach
tmux attach  # reattach
```
