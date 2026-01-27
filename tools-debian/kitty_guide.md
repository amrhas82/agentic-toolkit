# Kitty Terminal - Quick Reference Guide

Your complete guide to using Kitty terminal with custom Ctrl+S keybindings.

---

## Table of Contents

- [Core Concepts](#core-concepts)
- [All Keybindings](#all-keybindings)
- [Common Workflows](#common-workflows)
- [Tab Management](#tab-management)
- [Split Management](#split-management)
- [Text Operations](#text-operations)
- [Visual Customization](#visual-customization)
- [Advanced Features](#advanced-features)
- [Tips & Tricks](#tips--tricks)
- [Quick Reference Card](#quick-reference-card)

---

## Core Concepts

### What is Kitty?
- **GPU-accelerated terminal** optimized for performance
- **Built-in tabs and splits** - no need for tmux
- **Highly configurable** with simple config file
- **True color support** for beautiful themes

### Prefix Key System
Most commands use a **prefix key** (Ctrl+S):
1. Press `Ctrl+S` (nothing happens yet)
2. Release both keys
3. Press the action key (like `C` for new tab)

Example: `Ctrl+S > C` means:
- Hold Ctrl+S → Release → Press C

---

## All Keybindings

### System & Window Management

| Keybinding | Action | What it Does |
|------------|--------|--------------|
| `Ctrl+S > R` | Reload config | Apply config changes without restarting |
| `Ctrl+S > X` | Close window | Close current split/tab |
| `Ctrl+S > N` | New OS window | Open new Kitty window (separate process) |
| `Ctrl+S > Shift+E` | Edit config | Open config file in overlay editor |
| `Ctrl+S > T` | Theme browser | Browse/apply themes (requires Kitty 0.23+) |

### Tab Management

| Keybinding | Action | What it Does |
|------------|--------|--------------|
| `Ctrl+S > C` | New tab | Create new tab in current window |
| `Ctrl+S > Shift+L` | Next tab | Switch to tab on the right |
| `Ctrl+S > Shift+H` | Previous tab | Switch to tab on the left |
| `Ctrl+S > ,` | Move tab left | Reorder tab backward |
| `Ctrl+S > .` | Move tab right | Reorder tab forward |
| `Ctrl+S > 1` | Go to tab 1 | Jump to first tab |
| `Ctrl+S > 2` | Go to tab 2 | Jump to second tab |
| `Ctrl+S > 3` | Go to tab 3 | Jump to third tab |
| `Ctrl+S > 4` | Go to tab 4 | Jump to fourth tab |
| `Ctrl+S > 5` | Go to tab 5 | Jump to fifth tab |
| `Ctrl+S > 6` | Go to tab 6 | Jump to sixth tab |
| `Ctrl+S > 7` | Go to tab 7 | Jump to seventh tab |
| `Ctrl+S > 8` | Go to tab 8 | Jump to eighth tab |
| `Ctrl+S > 9` | Go to tab 9 | Jump to ninth tab |

### Split Management

| Keybinding | Action | What it Does |
|------------|--------|--------------|
| `Ctrl+S > \` | Vertical split | Split window vertically (new pane on right) |
| `Ctrl+S > -` | Horizontal split | Split window horizontally (new pane below) |
| `Ctrl+S > H` | Move left | Switch to left split |
| `Ctrl+S > J` | Move down | Switch to split below |
| `Ctrl+S > K` | Move up | Switch to split above |
| `Ctrl+S > L` | Move right | Switch to right split |
| `Ctrl+S > Z` | Toggle zoom | Maximize/restore current split |
| `Ctrl+S > E` | Equalize splits | Reset all splits to equal sizes |

### Text Operations (No Prefix)

| Keybinding | Action | What it Does |
|------------|--------|--------------|
| `Ctrl+Shift+C` | Copy | Copy selected text to clipboard |
| `Ctrl+Shift+V` | Paste | Paste from clipboard |
| `Ctrl+Shift+=` | Increase font | Make text bigger |
| `Ctrl+Shift+-` | Decrease font | Make text smaller |
| `Ctrl+Shift+0` | Reset font size | Return to default font size (14) |

### Quick Access Keys (No Prefix)

| Keybinding | Action | What it Does |
|------------|--------|--------------|
| `F1` | New window | Create new window in current directory |
| `F2` | Launch editor | Open $EDITOR in current directory |
| `F3` | Theme switcher | Browse and switch themes (manual selector) |

### Mouse Operations

| Action | What it Does |
|--------|--------------|
| **Left click + drag** | Select text |
| **Double click** | Select word |
| **Triple click** | Select line |
| **Right click** | Paste from clipboard |
| **Ctrl + Left click** | Open URL under cursor |
| **Scroll wheel** | Scroll terminal output (2x speed) |
| **Shift + Scroll** | Scroll by page |

---

## Common Workflows

### Starting Your Day

```bash
# 1. Open Kitty
kitty

# 2. Create tabs for different projects
Ctrl+S > C  # New tab for project 1
Ctrl+S > C  # New tab for project 2
Ctrl+S > C  # New tab for monitoring

# 3. Name your tabs (via shell prompt or rename in Kitty)
# 4. Jump between them with Ctrl+S > [1-9]
```

### Working with Multiple Claude Instances

**⚠️ Important:** To prevent system freezes, avoid running intensive operations simultaneously.

#### Method 1: Separate Tabs (Recommended)
```
Tab 1: Claude for task processing
Tab 2: Claude for PRD generation (keep idle until Tab 1 finishes)
Tab 3: Regular terminal work

Switch: Ctrl+S > 1/2/3
```

#### Method 2: Separate Windows
```bash
# Open new Kitty window
Ctrl+S > N

# Run Claude in each window
# Better resource isolation
```

#### Method 3: Splits (Use with Caution)
```
# Split horizontally
Ctrl+S > -

# Run different tasks in each split
# Navigate: Ctrl+S > [H/J/K/L]
# Zoom one: Ctrl+S > Z
```

**Best Practice:** Let one Claude finish intensive work before starting another.

### Code Review Workflow

```bash
# Tab 1: Main development
cd ~/project
nvim

# Tab 2: Git operations (Ctrl+S > C to create)
git status
git diff

# Tab 3: Running tests (Ctrl+S > C to create)
npm test --watch

# Quick switching: Ctrl+S > 1/2/3
```

### Monitoring Workflow

```bash
# Create splits in one tab:
# Top: main work
# Bottom left: system monitor
# Bottom right: logs

# 1. Start in full view
cd ~/project

# 2. Split horizontally
Ctrl+S > -

# 3. In bottom pane, split vertically
Ctrl+S > \

# 4. Navigate and set up each pane
Ctrl+S > J  # Go to bottom
htop        # System monitor

Ctrl+S > L  # Go to right pane
tail -f /var/log/app.log

# 5. Return to top pane
Ctrl+S > K

# 6. Maximize when needed
Ctrl+S > Z  # Toggle zoom
```

---

## Tab Management

### Creating Tabs
```bash
Ctrl+S > C  # Creates new tab with your default shell (zsh)
```

### Navigating Tabs

**By Number (Fastest):**
```
Ctrl+S > 1  # Jump to tab 1
Ctrl+S > 2  # Jump to tab 2
# ... etc
```

**Sequential:**
```
Ctrl+S > Shift+L  # Next tab (right)
Ctrl+S > Shift+H  # Previous tab (left)
```

### Organizing Tabs

**Reorder tabs:**
```
Ctrl+S > ,  # Move current tab left
Ctrl+S > .  # Move current tab right
```

**Example workflow:**
```
# You have: [3:logs] [1:code] [2:tests]
# Want: [code] [tests] [logs]

# In tab 3 (logs):
Ctrl+S > .  # Now: [1:code] [2:tests] [3:logs] ✓
```

### Tab Tips

1. **Tab titles** automatically show your current directory or running command
2. **Maximum 9 quick-access tabs** (use Ctrl+S > 1-9)
3. **Unlimited total tabs** (navigate with Shift+L/H)
4. **Close tab**: `Ctrl+S > X` or just exit the shell (`exit` or `Ctrl+D`)

---

## Split Management

### Understanding Splits

- **Splits** divide a single tab into multiple panes
- Each pane runs independently
- Great for monitoring multiple things at once
- All panes close when you close the tab

### Creating Splits

```
Ctrl+S > \  # Vertical split (│ divider)
            # New pane appears on RIGHT

Ctrl+S > -  # Horizontal split (─ divider)
            # New pane appears BELOW
```

### Split Layouts

**Two panes side-by-side:**
```
┌──────────┬──────────┐
│          │          │
│  Editor  │  Shell   │
│          │          │
└──────────┴──────────┘

Ctrl+S > \
```

**Two panes stacked:**
```
┌─────────────────────┐
│       Editor        │
├─────────────────────┤
│       Tests         │
└─────────────────────┘

Ctrl+S > -
```

**Complex layout:**
```
┌───────────┬─────────┐
│           │         │
│   Code    │  Logs   │
│           │         │
├───────────┴─────────┤
│    Terminal         │
└─────────────────────┘

Steps:
1. Ctrl+S > \  (vertical split)
2. Ctrl+S > J  (go to left pane)
3. Ctrl+S > -  (horizontal split)
```

### Navigating Splits (Vim-style)

```
Ctrl+S > H  # ← Left
Ctrl+S > J  # ↓ Down
Ctrl+S > K  # ↑ Up
Ctrl+S > L  # → Right
```

**Memory aid:** Same as Vim navigation (HJKL)

### Split Operations

**Maximize/Restore:**
```
Ctrl+S > Z  # Toggle zoom on current split
            # Makes current split fullscreen
            # Press again to restore layout
```

**Equalize sizes:**
```
Ctrl+S > E  # Reset all splits to equal sizes
            # Useful after resizing manually
```

**Close split:**
```
Ctrl+S > X  # Close current split
            # or just: exit / Ctrl+D
```

### Split Best Practices

1. **Don't overdo it** - 2-3 splits max for readability
2. **Use zoom often** - Focus on one pane when needed
3. **Tabs > Splits** - Use tabs for unrelated tasks
4. **Splits for monitoring** - Great for logs, tests, system info

---

## Text Operations

### Selecting Text

**With mouse:**
- **Click + drag**: Select arbitrary text
- **Double-click**: Select word
- **Triple-click**: Select entire line
- **Hold Shift + click**: Extend selection

**With keyboard:**
- Selection must be done with mouse in Kitty
- After selection, use keyboard shortcuts to copy

### Copying & Pasting

```
1. Select text with mouse
2. Ctrl+Shift+C     # Copy
3. Ctrl+Shift+V     # Paste

Or:
1. Select text with mouse
2. Right-click anywhere  # Automatically pastes
```

**System clipboard integration:**
- Copies go to system clipboard (works across all apps)
- Can paste into browser, editor, etc.

### Scrolling

```
Scroll wheel        # Scroll 2 lines at a time (2x speed)
Shift + Scroll      # Scroll by page
Page Up/Down        # Scroll by page
Shift+Page Up/Down  # Scroll to top/bottom
```

**Scrollback buffer:** Kitty stores last 10,000 lines

### URLs & Links

```
# URLs are automatically detected
# Ctrl + Left-click: Open URL in default browser

Example:
https://github.com/user/repo  ← Ctrl+Click to open
```

### Font Size Control

```
Ctrl+Shift+=  # Bigger text (great for presentations)
Ctrl+Shift+-  # Smaller text
Ctrl+Shift+0  # Reset to default (12pt)
```

**Use case:** Temporarily zoom in for pair programming or demos

---

## Visual Customization

### Theme: Catppuccin Frappe

Your current theme provides:
- **Dark background**: #303446 (easy on eyes)
- **Purple highlights**: #CA9EE6 (active tab)
- **Soft contrast**: Great for long coding sessions
- **Consistent colors**: Matches popular editor themes

### Tab Bar

Location: **Top of window**
Style: **Powerline with slanted separators**

```
┌─╱ 1: ~/project ╲───╱ 2: ~/tests ╲───╱ 3: logs ╲─────┐
│ [Active in purple]  [Inactive in gray]               │
└──────────────────────────────────────────────────────┘
```

### Window Padding

**4 pixels** on all sides for comfortable reading

### Cursor

**Block style** - solid rectangle, no blinking

---

## Advanced Features

### Configuration Live Reload

```bash
# Quick edit (opens in overlay)
F2  # or Ctrl+S > Shift+E

# Save changes in your editor

# Reload in Kitty
Ctrl+S > R

# Changes applied immediately! ✓
```

### Theme Management

**Current Version (Kitty 0.21.2):**
```bash
# Press F3 to open theme switcher
# Available themes:
# - Catppuccin Frappe (current/built-in)
# - Dracula
# - Gruvbox Dark
# - Monokai
# - Nord
# - Solarized Dark
```

**With Updated Kitty (0.23+):**
```bash
# Interactive theme browser
Ctrl+S > T  # Browse hundreds of themes
            # Live preview with arrow keys
            # Press Enter to apply
```

### Font Management

**View available fonts:**
```bash
kitty +list-fonts          # All fonts
kitty +list-fonts | grep -i fira  # Search specific font
```

**Change font:**
```bash
# 1. Edit config (F2)
# 2. Find line: font_family FiraCode Nerd Font Mono
# 3. Change to any font from list above
# 4. Reload (Ctrl+S > R)
```

### Shell Integration

Kitty integrates with your zsh shell:
- **Automatic prompt marking**: Kitty knows where commands start/end
- **Smart scrolling**: Jump to previous command output
- **Better clipboard**: Understand shell context

### Multiple Windows

```bash
# Open new independent Kitty window
Ctrl+S > N

# Each window is a separate process
# Useful for:
# - Completely different projects
# - Better resource isolation
# - Moving to different monitors
```

### Layouts

Kitty supports two layouts:
1. **Splits layout** (default) - Manual control
2. **Stack layout** (zoom mode) - One pane fills screen

```bash
# Toggle between them
Ctrl+S > Z  # Current split becomes fullscreen
Ctrl+S > Z  # Return to splits view
```

---

## Tips & Tricks

### Productivity Tips

1. **Use tabs for projects, splits for views**
   ```
   Tab 1: Project A (split: code | tests)
   Tab 2: Project B (split: code | logs)
   Tab 3: Monitoring (split: htop | docker logs)
   ```

2. **Number your tabs meaningfully**
   ```
   1: Main work
   2: Testing
   3: Git operations
   4: Monitoring
   5-9: Ad-hoc tasks
   ```

3. **Quick context switching**
   ```
   # Working on code (Tab 1)
   Ctrl+S > 2  # Jump to tests
   # Check test output
   Ctrl+S > 1  # Back to code
   ```

4. **Zoom for focus**
   ```
   # In a split layout
   Ctrl+S > Z  # Hide other splits
   # Do focused work
   Ctrl+S > Z  # Restore context
   ```

### Performance Tips

1. **Avoid too many splits** - Use tabs instead
2. **Close unused tabs** - Free up memory
3. **Let intensive tasks finish** - Don't run multiple Claude operations
4. **Use separate windows** - Better isolation for heavy tasks

### Workflow Patterns

**Development workflow:**
```
Tab 1: Editor (nvim/code)
Tab 2: Test runner (split: unit | integration)
Tab 3: Git & commands
Tab 4: Server logs
```

**DevOps workflow:**
```
Tab 1: Main terminal
Tab 2: Docker (split: logs | commands)
Tab 3: Kubernetes (split: pods | services)
Tab 4: Monitoring (split: htop | netdata)
```

**Data Science workflow:**
```
Tab 1: Jupyter notebook
Tab 2: Python REPL (split: code | data)
Tab 3: Data processing scripts
Tab 4: System monitoring
```

### Keyboard Efficiency

**Muscle memory order:**
1. Learn tabs first: `Ctrl+S > C`, `Ctrl+S > 1-9`
2. Then navigation: `Ctrl+S > Shift+L/H`
3. Add splits: `Ctrl+S > \/-`
4. Master split nav: `Ctrl+S > HJKL`
5. Finally zoom: `Ctrl+S > Z`

**Common sequences:**
```
Ctrl+S C 1  # New tab, jump to first tab
Ctrl+S \ J  # Split, go to bottom pane
Ctrl+S Z Z  # Double-zoom (zoom, unzoom)
```

---

## Quick Reference Card

### Essential Shortcuts (Learn These First)

```
┌─────────────────────────────────────────┐
│           MUST KNOW                     │
├─────────────────────────────────────────┤
│ Ctrl+S > C        New tab               │
│ Ctrl+S > 1-9      Go to tab N           │
│ Ctrl+S > X        Close tab/split       │
│ Ctrl+S > \        Vertical split        │
│ Ctrl+S > -        Horizontal split      │
│ Ctrl+S > HJKL     Navigate splits       │
│ Ctrl+S > Z        Zoom toggle           │
│ Ctrl+Shift+C      Copy                  │
│ Ctrl+Shift+V      Paste                 │
│ F1                New window (cwd)      │
│ F2                Edit config           │
│ F3                Switch themes         │
└─────────────────────────────────────────┘
```

### Full Shortcut Matrix

```
┌──────────────────────────────────────────────────────┐
│                 ALL KEYBINDINGS                      │
├──────────────────┬───────────────────────────────────┤
│ SYSTEM           │                                   │
├──────────────────┼───────────────────────────────────┤
│ Ctrl+S > R       │ Reload config                     │
│ Ctrl+S > X       │ Close window/tab                  │
│ Ctrl+S > N       │ New OS window                     │
│ Ctrl+S > Shift+E │ Edit config (overlay)             │
│ Ctrl+S > T       │ Theme browser (0.23+)             │
├──────────────────┼───────────────────────────────────┤
│ TABS             │                                   │
├──────────────────┼───────────────────────────────────┤
│ Ctrl+S > C       │ New tab                           │
│ Ctrl+S > Shift+L │ Next tab                          │
│ Ctrl+S > Shift+H │ Previous tab                      │
│ Ctrl+S > ,       │ Move tab left                     │
│ Ctrl+S > .       │ Move tab right                    │
│ Ctrl+S > 1-9     │ Go to tab 1-9                     │
├──────────────────┼───────────────────────────────────┤
│ SPLITS           │                                   │
├──────────────────┼───────────────────────────────────┤
│ Ctrl+S > \       │ Vertical split                    │
│ Ctrl+S > -       │ Horizontal split                  │
│ Ctrl+S > H       │ Go to left split                  │
│ Ctrl+S > J       │ Go to bottom split                │
│ Ctrl+S > K       │ Go to top split                   │
│ Ctrl+S > L       │ Go to right split                 │
│ Ctrl+S > Z       │ Toggle zoom                       │
│ Ctrl+S > E       │ Equalize splits                   │
├──────────────────┼───────────────────────────────────┤
│ TEXT             │                                   │
├──────────────────┼───────────────────────────────────┤
│ Ctrl+Shift+C     │ Copy                              │
│ Ctrl+Shift+V     │ Paste                             │
│ Ctrl+Shift+=     │ Increase font                     │
│ Ctrl+Shift+-     │ Decrease font                     │
│ Ctrl+Shift+0     │ Reset font                        │
├──────────────────┼───────────────────────────────────┤
│ QUICK ACCESS     │                                   │
├──────────────────┼───────────────────────────────────┤
│ F1               │ New window (current dir)          │
│ F2               │ Launch editor (current dir)       │
│ F3               │ Theme switcher                    │
└──────────────────┴───────────────────────────────────┘
```

---

## Troubleshooting Quick Fixes

### Keybindings not working?

```bash
# Reload config
Ctrl+S > R

# Or restart Kitty
exit
kitty
```

### Colors look wrong?

```bash
# Check TERM variable
echo $TERM  # Should be: xterm-kitty

# If not, add to ~/.zshrc:
export TERM=xterm-kitty
```

### Text too small/large?

```
Ctrl+Shift+0  # Reset to default (12pt)
```

### Lost in splits?

```
Ctrl+S > Z  # Zoom current split
Ctrl+S > E  # Or equalize all
```

### Too many tabs open?

```
Ctrl+S > X  # Close current tab
# Or: exit
# Or: Ctrl+D
```

---

## Getting Help

### Built-in Help

```bash
# List all keybindings
kitty +list-keybinds

# Show current config
kitty +show-config

# Debug config issues
kitty --debug-config
```

### Config File Location

```bash
~/.config/kitty/kitty.conf
```

### Useful Commands

```bash
# Edit config (quickest way)
# Press F2 in Kitty

# Or manually:
nano ~/.config/kitty/kitty.conf

# Switch themes
# Press F3 in Kitty

# List available fonts
kitty +list-fonts

# View this guide
cat ~/Documents/PycharmProjects/agentic-toolkit/tools/kitty_guide.md
```

---

## Cheat Sheet (Print This!)

```
╔═══════════════════════════════════════════════════════╗
║              KITTY CHEAT SHEET                        ║
╠═══════════════════════════════════════════════════════╣
║  TABS                        SPLITS                   ║
║  ─────────────────────────  ───────────────────────   ║
║  Ctrl+S > C    New         │ Ctrl+S > \    Vertical  ║
║  Ctrl+S > 1-9  Jump        │ Ctrl+S > -    Horizont. ║
║  Ctrl+S > X    Close       │ Ctrl+S > HJKL Navigate  ║
║  Ctrl+S > ,.   Reorder     │ Ctrl+S > Z    Zoom      ║
║                             │ Ctrl+S > E    Equalize  ║
╠═══════════════════════════════════════════════════════╣
║  SYSTEM                      TEXT                     ║
║  ─────────────────────────  ───────────────────────   ║
║  Ctrl+S > R    Reload      │ Ctrl+Shift+C  Copy      ║
║  Ctrl+S > N    New Window  │ Ctrl+Shift+V  Paste     ║
║  F2/Ctrl+S>E   Edit Config │ Ctrl+Shift+= Zoom in    ║
║  F3            Themes      │ Ctrl+Shift+0 Reset      ║
║  F1            New Win+cwd │ F2           Editor     ║
╚═══════════════════════════════════════════════════════╝

Prefix Key: Press Ctrl+S, release, then action key
Example: Ctrl+S > C = Hold Ctrl+S → Release → Press C
```

---

**Pro Tip:** Print the cheat sheet and keep it visible until keybindings become muscle memory (usually 1-2 weeks of daily use).

**Remember:** Your Ghostty config is still at `~/.config/ghostty/config` if you ever need to switch back!
