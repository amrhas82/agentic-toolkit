# Kitty Terminal - Quick Start

Fast, GPU-accelerated terminal emulator optimized for stability and performance.

## Files in This Directory

1. **kitty.conf** (6.4K) - Working configuration file
   - Catppuccin Frappe theme
   - Ctrl+S keybindings
   - Tall/Fat layouts for reliable splits
   - Optimized for Intel integrated graphics

2. **kitty_guide.md** (21K) - Daily reference guide
   - Complete keybinding reference
   - Common workflows
   - Split/tab management
   - Printable cheat sheet

3. **KITTY_MIGRATION_GUIDE.md** (16K) - Full setup documentation
   - Installation instructions
   - Configuration breakdown
   - Troubleshooting guide
   - Migration from Ghostty

4. **install_kitty.sh** (15K) - Automated installation script
   - One-command setup
   - Config backup
   - Validation checks
   - Interactive prompts

## Quick Installation

### Option 1: Automated (Recommended)
```bash
cd /home/hamr/Documents/PycharmProjects/agentic-toolkit/tools
./install_kitty.sh
```

### Option 2: Manual
```bash
# Install Kitty
sudo apt update && sudo apt install kitty -y

# Copy config
mkdir -p ~/.config/kitty
cp kitty.conf ~/.config/kitty/

# Launch
kitty
```

## Why Kitty Over Ghostty?

✅ **Better stability** - No system freezes with Intel integrated graphics
✅ **Lower GPU usage** - Optimized rendering with tall/fat layouts
✅ **Same keybindings** - All Ctrl+S shortcuts work identically
✅ **Reliable splits** - Vertical (|) and horizontal (-) splits work correctly
✅ **Safe for Claude** - Run multiple intensive operations without crashes

## Essential Keybindings

All commands use **Ctrl+S prefix** (press Ctrl+S, release, then action key):

### Tabs
- `Ctrl+S > C` - New tab
- `Ctrl+S > 1-9` - Jump to tab 1-9
- `Ctrl+S > Shift+L` - Next tab
- `Ctrl+S > Shift+H` - Previous tab

### Splits
- `Ctrl+S > |` or `\` - Vertical split (side-by-side)
- `Ctrl+S > -` - Horizontal split (top/bottom)
- `Ctrl+S > H/J/K/L` - Navigate splits (vim-style)
- `Ctrl+S > Z` - Toggle zoom (maximize current split)
- `Ctrl+S > E` - Equalize split sizes

### System
- `Ctrl+S > R` - Reload config
- `Ctrl+S > X` - Close window/tab
- `Ctrl+S > N` - New OS window

### Text (No Prefix)
- `Ctrl+Shift+C` - Copy
- `Ctrl+Shift+V` - Paste
- `Ctrl+Shift+=` - Increase font
- `Ctrl+Shift+-` - Decrease font

## Configuration Highlights

### Layouts (The Fix That Made Splits Work!)
```conf
# tall = side-by-side panes (LEFT | RIGHT)
# fat = stacked panes (TOP / BOTTOM)
enabled_layouts tall:bias=50;full_size=1,fat:bias=50;full_size=1,stack
```

### Split Commands
```conf
# Vertical split: switches to tall layout, creates new window
map ctrl+s>backslash combine : goto_layout tall : new_window_with_cwd

# Horizontal split: switches to fat layout, creates new window
map ctrl+s>minus combine : goto_layout fat : new_window_with_cwd
```

This approach bypasses Kitty's automatic split placement and forces the desired layout.

## Theme: Catppuccin Frappe

- **Background**: #303446 (dark blue-grey)
- **Foreground**: #C6D0F5 (light blue-grey)
- **Active Tab**: #CA9EE6 (purple)
- **Cursor**: #F2D5CF (light pink)

## Performance Optimization

### GPU Settings
```conf
sync_to_monitor no       # Reduce GPU sync overhead
repaint_delay 10         # Fast repaints
input_delay 3            # Responsive input
```

### For Multiple Claude Instances
- Use **tabs** instead of splits for different Claude sessions
- Avoid running intensive operations (task processing, PRD generation) simultaneously
- Let one Claude finish before starting another in a different tab

## Documentation Structure

```
tools/
├── kitty.conf                    ← Install this to ~/.config/kitty/
├── install_kitty.sh              ← Run for automated setup
├── kitty_guide.md                ← Read for daily reference
├── KITTY_MIGRATION_GUIDE.md      ← Read for full setup guide
└── KITTY_README.md (this file)   ← Quick overview
```

## Troubleshooting

### Splits not working correctly?
- Reload config: `Ctrl+S > R`
- Make sure you're using the config with tall/fat layouts
- Check: `grep "enabled_layouts" ~/.config/kitty/kitty.conf`

### Theme colors wrong?
```bash
# Inside Kitty:
echo $TERM  # Should output: xterm-kitty
```

### Still getting system freezes?
1. Monitor resource usage: `htop`
2. Check GPU load: `intel_gpu_top`
3. Don't run multiple intensive Claude operations in parallel
4. Use tabs for separation instead of splits

## Getting Help

```bash
# View quick reference
cat kitty_guide.md

# View full migration guide
cat KITTY_MIGRATION_GUIDE.md

# View current config
cat ~/.config/kitty/kitty.conf

# Test keybindings
kitty +list-keybinds | grep "ctrl+s"
```

## Next Steps

1. ✅ Install Kitty (manual or automated)
2. ✅ Copy kitty.conf to ~/.config/kitty/
3. ✅ Launch Kitty and test splits
4. ✅ Read kitty_guide.md for all keybindings
5. ✅ Keep KITTY_MIGRATION_GUIDE.md for reference
6. ✅ Enjoy stable terminal with no crashes! 🎉

---

**Last Updated**: January 20, 2026
**Tested On**: Ubuntu 22.04, Intel UHD Graphics 620
**Status**: ✅ Working - Splits reliable, no system freezes
