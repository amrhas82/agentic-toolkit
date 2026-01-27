# 🚀 Ghostty Terminal: Complete Configuration & Usage Guide

## Table of Contents
1. [Introduction to Ghostty](#introduction-to-ghostty)
2. [Installation & Setup](#installation--setup)
3. [Configuration Overview](#configuration-overview)
4. [Complete Keyboard Shortcuts Reference](#complete-keyboard-shortcuts-reference)
5. [Theme & Appearance Settings](#theme--appearance-settings)
6. [Performance & Productivity Features](#performance--productivity-features)
7. [Troubleshooting & Tips](#troubleshooting--tips)
8. [Advanced Configuration Options](#advanced-configuration-options)

---

## Introduction to Ghostty 🎯

**Ghostty** is a modern, fast, and feature-rich terminal emulator designed for developers and power users. Built with performance and customization in mind, Ghostty offers a seamless terminal experience with advanced features like:

- ✨ **Modern GPU-accelerated rendering**
- 🎨 **Extensive theming support**
- ⚡ **Blazing fast performance**
- 🔧 **Highly configurable keybindings**
- 📱 **Cross-platform compatibility**
- 🪟 **Advanced window management**
- 🔀 **Powerful split and tab management**

### Why Choose Ghostty?

| Feature | Ghostty | Traditional Terminals |
|---------|---------|----------------------|
| **Performance** | GPU-accelerated | CPU-based rendering |
| **Customization** | Extensive config options | Limited customization |
| **Keybindings** | Fully customizable | Fixed keybindings |
| **Split Management** | Built-in splits | Requires tmux/screen |
| **Modern Design** | Contemporary UI | Traditional appearance |

---

## Installation & Setup 📦

### System Requirements
- **Linux**: Most modern distributions (Ubuntu 20.04+, Fedora 35+, Arch, etc.)
- **macOS**: macOS 10.15+ (Catalina and later)
- **Windows**: Windows 10+ (via WSL or native builds)

### Installation Methods

#### 🐧 Linux Installation

**Ubuntu/Debian:**
```bash
# Add Ghostty repository
sudo dnf install -y ghostty
```

**Fedora/CentOS:**
```bash
# Using dnf
sudo dnf copr enable atim/ghostty
sudo dnf install ghostty
```

**Arch Linux:**
```bash
# Using AUR
yay -S ghostty
# or
paru -S ghostty
```

**From Source:**
```bash
git clone https://github.com/mitchellh/ghostty.git
cd ghostty
make build
sudo make install
```

#### 🍎 macOS Installation

**Using Homebrew:**
```bash
# Install
brew install --cask ghostty

# Or tap for nightly builds
brew tap mitchellh/ghostty
brew install --cask ghostty-nightly
```

#### 🪟 Windows Installation

**Using Winget:**
```powershell
winget install MitchellH.Ghostty
```

### Initial Setup

After installation, Ghostty creates a default configuration at:
- **Linux/Unix**: `~/.config/ghostty/config`
- **macOS**: `~/Library/Application Support/Ghostty/config`

**Initial configuration backup:**
```bash
# Create backup directory
mkdir -p ~/Documents/ghostty-backup

# Backup default config (if it exists)
cp ~/.config/ghostty/config ~/Documents/ghostty-backup/config.bak
```

---

## Configuration Overview ⚙️

### Configuration File Structure

Ghostty uses a simple key-value syntax for configuration:

```ini
# Basic syntax
key = value

# Comments start with #
key = value # This is NOT a comment (everything after = is part of value)

# Multiple values for some options
theme = dark:Catppuccin Frappe,light:Catppuccin Latte

# Time-based values
resize-overlay-duration = 4s 200ms
```

### Configuration Locations

Ghostty looks for configuration files in this order:
1. **Command line flags** (highest priority)
2. **Environment variables**
3. **User config file**: `~/.config/ghostty/config`
4. **System config**: `/etc/ghostty/config`
5. **Default built-in configuration** (lowest priority)

### Basic Configuration Template

```ini
# =============================================================================
# Ghostty Terminal Configuration
# =============================================================================
# Comprehensive configuration optimized for development workflows
# =============================================================================

# Font Configuration
# ==================
font-size = 12
font-family = Iosevka Nerd Font

# Theme Configuration
# ===================
# Dark theme for better eye comfort during long coding sessions
theme = Catppuccin Frappe

# Shell Integration
# =================
shell-integration-features = no-cursor,sudo,no-title

# Cursor Configuration
# ====================
cursor-style = block

# Window Configuration
# ====================
window-padding-balance = true
window-save-state = always

# Mouse Configuration
# ===================
mouse-hide-while-typing = true
mouse-scroll-multiplier = 2
```

### Reloading Configuration

**Hot Reload:**
- **Linux/Windows**: `Ctrl + Shift + ,`
- **macOS**: `Cmd + Shift + ,`

**Manual Reload:**
```bash
# Using Ghostty command
ghostty +reload-config

# Or via custom keybinding (if configured)
Ctrl + S > R  # From our example configuration
```

---

## Complete Keyboard Shortcuts Reference ⌨️

### System & Window Management

| Shortcut | Action | Description |
|----------|--------|-------------|
| `Ctrl + S > R` | Reload Configuration | Reload Ghostty configuration |
| `Ctrl + S > X` | Close Surface | Close current window/tab |
| `Ctrl + S > N` | New Window | Create new Ghostty window |
| `Ctrl + Shift + ,` | Hot Reload | Reload configuration (Linux/Windows) |
| `Cmd + Shift + ,` | Hot Reload | Reload configuration (macOS) |
| `Ctrl + Shift + N` | New Window | Create new window (default) |
| `Ctrl + Shift + T` | New Tab | Create new tab (default) |
| `Ctrl + Shift + W` | Close | Close current tab/window (default) |
| `F11` | Fullscreen | Toggle fullscreen mode |

### Tab Management 📑

| Shortcut | Action | Description |
|----------|--------|-------------|
| `Ctrl + S > C` | New Tab | Create new tab |
| `Ctrl + S > Shift + L` | Next Tab | Switch to next tab |
| `Ctrl + S > Shift + H` | Previous Tab | Switch to previous tab |
| `Ctrl + S > ,` | Move Tab Left | Move current tab left |
| `Ctrl + S > .` | Move Tab Right | Move current tab right |
| `Ctrl + S > 1-9` | Goto Tab | Switch to tab 1-9 directly |
| `Ctrl + Tab` | Next Tab | Cycle through tabs (default) |
| `Ctrl + Shift + Tab` | Previous Tab | Cycle backwards (default) |

**Quick Tab Switching Examples:**
```bash
# Switch to tab 3 instantly
Ctrl + S > 3

# Move current tab one position to the left
Ctrl + S > ,

# Move current tab one position to the right
Ctrl + S > .
```

### Split Management 🔀

| Shortcut | Action | Description |
|----------|--------|-------------|
| `Ctrl + S > \` | Split Right | Create vertical split (right) |
| `Ctrl + S > -` | Split Down | Create horizontal split (down) |
| `Ctrl + S > J` | Goto Split Bottom | Navigate to split below |
| `Ctrl + S > K` | Goto Split Top | Navigate to split above |
| `Ctrl + S > H` | Goto Split Left | Navigate to left split |
| `Ctrl + S > L` | Goto Split Right | Navigate to right split |
| `Ctrl + S > Z` | Toggle Split Zoom | Maximize/restore current split |
| `Ctrl + S > E` | Equalize Splits | Make all splits equal size |

**Split Navigation Pattern (Vim-style):**
```
┌─────────────┬─────────────┐
│    Split A  │    Split B  │
│  Ctrl+S>H   │  Ctrl+S>L   │
│  Ctrl+S>K   │  Ctrl+S>K   │
├─────────────┼─────────────┤
│    Split C  │    Split D  │
│  Ctrl+S>H   │  Ctrl+S>L   │
│  Ctrl+S+J   │  Ctrl+S+J   │
└─────────────┴─────────────┘
```

### Navigation & Selection

| Shortcut | Action | Description |
|----------|--------|-------------|
| `Ctrl + Shift + C` | Copy | Copy selected text |
| `Ctrl + Shift + V` | Paste | Paste clipboard content |
| `Ctrl + Shift + Insert` | Paste | Alternative paste |
| `Ctrl + Mouse Wheel` | Zoom | Adjust font size |
| `Ctrl + 0` | Reset Zoom | Reset font size to default |
| `Shift + Mouse Select` | Rectangle Select | Select text in rectangle mode |

### Configuration Management

| Shortcut | Action | Description |
|----------|--------|-------------|
| `Ctrl + S > R` | Reload Config | Apply configuration changes |
| `Ctrl + Shift + ,` | Open Config | Open config file in default editor |
| `Ctrl + Shift + O` | Open Config Directory | Open config directory in file manager |

### Additional Default Shortcuts

| Shortcut | Action | Description |
|----------|--------|-------------|
| `Ctrl + C` | Interrupt | Send interrupt signal (SIGINT) |
| `Ctrl + Z` | Suspend | Suspend current process |
| `Ctrl + D` | EOF | Send end-of-file |
| `Ctrl + L` | Clear Screen | Clear terminal screen |
| `Ctrl + A` | Beginning of Line | Move cursor to line start |
| `Ctrl + E` | End of Line | Move cursor to line end |

---

## Theme & Appearance Settings 🎨

### Available Themes

Ghostty supports multiple built-in themes:

#### 🌙 Dark Themes
```ini
# Catppuccin Frappe (Default in our config)
theme = Catppuccin Frappe

# Other popular dark themes
theme = Catppuccin Mocha
theme = Dracula
theme = Gruvbox Dark
theme = One Dark
theme = Monokai
theme = Nord
```

#### ☀️ Light Themes
```ini
# Catppuccin Latte
theme = Catppuccin Latte

# Other light themes
theme = GitHub Light
theme = Gruvbox Light
theme = Solarized Light
```

#### 🌓 Auto-switching Themes
```ini
# Automatic theme switching based on system preference
theme = dark:Catppuccin Frappe,light:Catppuccin Latte
```

### Custom Theme Configuration

```ini
# Custom color overrides
background = #1e1e2e
foreground = #cdd6f4
selection-background = #585b70
selection-foreground = #cdd6f4

# Cursor colors
cursor-color = #f5e0dc
cursor-text-color = #1e1e2e

# ANSI color palette
color-0 = #45475a   # Black
color-1 = #f38ba8   # Red
color-2 = #a6e3a1   # Green
color-3 = #f9e2af   # Yellow
color-4 = #89b4fa   # Blue
color-5 = #f5c2e7   # Magenta
color-6 = #94e2d5   # Cyan
color-7 = #a6adc8   # White
```

### Font Configuration

```ini
# Font family and size
font-family = Iosevka Nerd Font
font-size = 12

# Font style variants
font-style = Regular
font-weight = 400
font-stretch = Normal

# Line height and spacing
adjust-cell-height = 120%
adjust-cell-width = 100%

# Font ligatures
font-ligatures = true
```

### Window Appearance

```ini
# Window opacity (0.0 - 1.0)
background-opacity = 0.95

# Window padding
window-padding-x = 8
window-padding-y = 8

# Balanced padding (maintains aspect ratio)
window-padding-balance = true

# Window decorations
window-decoration = true
window-border-width = 1
window-border-color = #585b70

# Resize overlay
resize-overlay = true
resize-overlay-duration = 2s
```

### Cursor Customization

```ini
# Cursor style: block, underline, or bar
cursor-style = block

# Cursor blinking
cursor-blink = true
cursor-blink-rate = 500ms

# Cursor color
cursor-color = #f5c2e7
cursor-text-color = #1e1e2e

# Cursor shape in different modes
cursor-style-text = block
cursor-style-command = underline
```

---

## Performance & Productivity Features 🚀

### Shell Integration

Enhance your shell experience with Ghostty's integration features:

```ini
# Enable shell integration features
shell-integration = true
shell-integration-features = no-cursor,sudo,no-title

# Available features:
# - cursor: Better cursor positioning
# - sudo: Proper sudo prompt handling
# - title: Dynamic window titles
# - detect: Auto-detect shell capabilities
```

**Supported Shells:**
- Bash (4.4+)
- Zsh (5.0+)
- Fish (3.0+)
- PowerShell (7.0+)

### Mouse Configuration

```ini
# Hide mouse while typing
mouse-hide-while-typing = true

# Scroll speed multiplier
mouse-scroll-multiplier = 2.0

# Mouse selection behavior
mouse-selection-rectangle = true
mouse-autohide = true

# Click actions
mouse-middle-click-paste = true
mouse-right-click-action = menu
```

### Performance Optimization

```ini
# GPU acceleration
gpu-acceleration = true

# Framerate (30, 60, 120, 144, 240)
fps = 60

# Buffer size optimization
buffer-size = 100000

# Render quality
font-thinning = auto
antialiasing = grayscale

# Performance vs quality trade-offs
fast-blit = true
```

### Productivity Features

```ini
# Auto-save window state
window-save-state = always

# Copy on selection
copy-on-select = false

# Bell configuration
audible-bell = false
visual-bell = true

# URL detection and linking
url-launcher = xdg-open
url-click-launcher = true

# Quick open settings
open-url-with-mouse = true
open-url-modifiers = ctrl
```

---

## Troubleshooting & Tips 🔧

### Common Issues & Solutions

#### 🐛 Configuration Not Loading

**Problem:** Configuration changes aren't applying
**Solution:**
```bash
# Check configuration syntax
ghostty +show-config --validate

# Reload configuration manually
ghostty +reload-config

# Check config file location
ls -la ~/.config/ghostty/config
```

#### 🐛 Font Rendering Issues

**Problem:** Fonts look blurry or incorrect
**Solution:**
```ini
# Ensure Nerd Font is installed and used
font-family = "JetBrains Mono Nerd Font"

# Adjust rendering settings
font-thinning = auto
antialiasing = grayscale
adjust-cell-height = 110%
```

#### 🐛 Performance Issues

**Problem:** Terminal feels slow or laggy
**Solution:**
```ini
# Optimize for performance
fps = 60
gpu-acceleration = true
buffer-size = 50000
fast-blit = true

# Disable expensive features if needed
background-opacity = 1.0
blur = false
```

#### 🐛 Keybindings Not Working

**Problem:** Custom keybindings don't respond
**Solution:**
```bash
# Check for conflicting keybindings
ghostty +show-config | grep keybind

# Test keybinding recognition
# Use simple keybinds first to test
keybind = ctrl+shift+t=new_tab
```

### Performance Tips

1. **Use appropriate buffer sizes:**
   ```ini
   # For general use
   buffer-size = 100000

   # For memory-constrained systems
   buffer-size = 10000
   ```

2. **Optimize frame rate:**
   ```ini
   # Smooth scrolling (more CPU)
   fps = 120

   # Balanced performance
   fps = 60

   # Maximum performance
   fps = 30
   ```

3. **Font rendering optimization:**
   ```ini
   # Use monospace fonts for better performance
   font-family = "Source Code Pro"

   # Disable ligatures if not needed
   font-ligatures = false
   ```

### Debug Mode

Enable debug mode to troubleshoot issues:

```bash
# Run Ghostty with debug output
ghostty --debug

# Enable logging
ghostty --log-level=debug

# Check configuration loading
ghostty +show-config --verbose
```

### Useful Commands

```bash
# Show current configuration
ghostty +show-config

# Show default configuration
ghostty +show-config --default

# Show configuration with documentation
ghostty +show-config --docs

# Validate configuration file
ghostty +validate-config

# Open configuration in editor
ghostty +open-config
```

---

## Advanced Configuration Options 🎛️

### Multi-Profile Configuration

```ini
# Create different profiles for different tasks
profile = development, personal, gaming

# Development profile
[development]
theme = Catppuccin Frappe
font-size = 14
shell-integration-features = cursor,sudo

# Personal profile
[personal]
theme = Catppuccin Latte
font-size = 12
background-opacity = 0.9
```

### Conditional Configuration

```ini
# Platform-specific settings
if-macos = true
  keybind = cmd+q=quit
  font-family = "SF Mono"
endif

if-linux = true
  keybind = ctrl+alt+backspace=quit
  font-family = "JetBrains Mono"
endif

# Host-specific configuration
if-host = development-server
  theme = One Dark
  font-size = 16
endif
```

### Advanced Window Management

```ini
# Window positioning
window-width = 1200
window-height = 800
window-x = 100
window-y = 100

# Window behavior
window-inherit-working-directory = true
window-theme = auto
window-state = normal

# Multi-monitor support
window-monitor = primary
window-dpi-awareness = auto
```

### Advanced Shell Integration

```ini
# Full shell integration
shell-integration = true
shell-integration-features = cursor,sudo,title,detect

# Custom shell command
shell = /usr/bin/fish
shell-args = --login

# Terminal title format
title-format = "{host}:{directory} - {shell}"

# Working directory behavior
working-directory = inherit
```

### Networking and Remote Features

```ini
# SSH integration
ssh-auth-sock = inherit
ssh-config-file = ~/.ssh/config

# URL handling
url-launcher = firefox
url-regex = (https?|ftp)://[^\s<>"]+|www\.[^\s<>"]+

# Email handling
email-launcher = thunderbird
email-regex = [a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}
```

### Advanced Keybinding Syntax

```ini
# Complex keybindings with multiple keys
keybind = ctrl+shift+>alt+f=fullscreen

# Keybindings with arguments
keybind = ctrl+shift+n=new_window:profile=development

# Conditional keybindings
keybind = ctrl+shift+t=toggle_split:direction=horizontal

# Command keybindings
keybind = ctrl+shift+r=run_command:htop
```

### Performance Monitoring

```ini
# Enable performance metrics
show-performance-overlay = false
performance-update-rate = 1000ms

# Memory optimization
cache-size = 100MB
texture-cache-size = 50MB
```

---

## Quick Reference Card 📋

### Essential Shortcuts (Most Used)

```bash
# Window Management
Ctrl+S>N    # New window
Ctrl+S>X    # Close window

# Tab Management
Ctrl+S>C    # New tab
Ctrl+S>1-9  # Goto tab 1-9
Ctrl+S>Shift+L  # Next tab
Ctrl+S>Shift+H  # Previous tab

# Split Management
Ctrl+S>\    # Vertical split
Ctrl+S>-    # Horizontal split
Ctrl+S>J/K/H/L  # Navigate splits
Ctrl+S>Z    # Zoom/unzoom split

# Configuration
Ctrl+S>R    # Reload config
Ctrl+Shift+,  # Open config
```

### Configuration File Locations

| Platform | Configuration Path |
|----------|-------------------|
| Linux | `~/.config/ghostty/config` |
| macOS | `~/Library/Application Support/Ghostty/config` |
| Windows | `%APPDATA%\Ghostty\config` |

### Common Configuration Values

```ini
# Font sizes (adjust based on screen resolution)
font-size = 10  # Small screens
font-size = 12  # Standard
font-size = 14  # Large screens
font-size = 16  # 4K displays

# Opacity values
background-opacity = 1.0    # Solid
background-opacity = 0.95   # Slight transparency
background-opacity = 0.8    # Noticeable transparency
background-opacity = 0.6    # High transparency
```

---

## Conclusion 🎉

Ghostty offers a powerful, modern terminal experience with extensive customization options. This guide covers the essential features and configurations you need to get started and become productive.

**Next Steps:**
1. ✅ Install Ghostty using your preferred method
2. ✅ Set up your basic configuration
3. ✅ Customize themes and fonts to your liking
4. ✅ Learn the essential keyboard shortcuts
5. ✅ Explore advanced features as needed

**Additional Resources:**
- 📖 [Official Ghostty Documentation](https://ghostty.org/docs)
- 🐙 [Ghostty GitHub Repository](https://github.com/mitchellh/ghostty)
- 🎨 [Community Themes](https://github.com/ghostty-themes)
- 💬 [Community Discord](https://discord.gg/ghostty)

Happy coding with Ghostty! 🚀

---

*Last Updated: November 2025*
*Version: 1.0*