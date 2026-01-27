# Ghostty Terminal Setup Guide

This directory contains the **master-ghostty.sh** script - a comprehensive installation and configuration utility for Ghostty Terminal.

## Quick Start

```bash
# Make the script executable
chmod +x master-ghostty.sh

# Run full installation (installs Ghostty + configuration)
./master-ghostty.sh

# Or just install the configuration (if Ghostty is already installed)
./master-ghostty.sh --config-only
```

## Features

### 🚀 Installation Features
- **Automatic Ghostty Installation** via Snap package manager
- **System Requirements Check** before installation
- **Installation Verification** and testing
- **Permission Handling** with sudo prompts when needed

### ⚙️ Configuration Features
- **Catppuccin Frappe Theme** - Beautiful dark theme optimized for coding
- **Custom Keybindings** with Ctrl+S prefix for productivity
- **Development-Optimized Settings** for enhanced workflow
- **Shell Integration** features (no-cursor, sudo, no-title)
- **Mouse and Window Management** settings

### 🛡️ Safety Features
- **Backup Existing Configuration** before making changes
- **Error Handling** with detailed error messages
- **User Prompts** for confirmation before making changes
- **Rollback Capability** by restoring from backup

### 🎨 User Experience
- **Colored Output** for better readability
- **Progress Logging** with step-by-step information
- **Keybinding Reference** after installation
- **Comprehensive Help** system

## Command Line Options

```bash
./master-ghostty.sh [OPTIONS]

Options:
    --help, -h      Show help message and usage information
    --version       Show script version information
    --config-only   Only install configuration (skip Ghostty installation)
```

## Configuration Details

### Theme and Appearance
- **Theme**: Catppuccin Frappe (dark theme)
- **Font Size**: 12pt
- **Cursor Style**: Block
- **Window Padding**: Balanced for visual comfort

### Keybindings (Ctrl+S Prefix)

#### System & Window Management
- `Ctrl+S+R` → Reload configuration
- `Ctrl+S+X` → Close current window
- `Ctrl+S+N` → New window

#### Tab Management
- `Ctrl+S+C` → New tab
- `Ctrl+S+Shift+L` → Next tab
- `Ctrl+S+Shift+H` → Previous tab
- `Ctrl+S+Comma` → Move tab left
- `Ctrl+S+Period` → Move tab right
- `Ctrl+S+1-9` → Go to tab 1-9

#### Split Management
- `Ctrl+S+\` → New split (right)
- `Ctrl+S+-` → New split (down)
- `Ctrl+S+J/K/H/L` → Navigate splits (bottom/top/left/right)
- `Ctrl+S+Z` → Toggle split zoom
- `Ctrl+S+E` → Equalize all splits

### Mouse Settings
- **Hide cursor while typing**: Enabled
- **Scroll multiplier**: 2x for faster scrolling

### Window Settings
- **Save state**: Always (remembers window positions/sizes)
- **Padding balance**: True (even distribution)

## File Locations

After installation, files are located at:

- **Configuration File**: `~/.config/ghostty/config`
- **Backup Directory**: `~/.config/ghostty/backup/`
- **Backup Naming**: `config_backup_YYYYMMDD_HHMMSS`

## Usage Examples

### Complete Installation
```bash
# Full installation with Ghostty and configuration
./master-ghostty.sh

# You'll be prompted to confirm before installation starts
# The script will handle everything automatically
```

### Configuration Only
```bash
# If Ghostty is already installed, just configure it
./master-ghostty.sh --config-only
```

### Getting Help
```bash
# Show usage information
./master-ghostty.sh --help

# Show script version
./master-ghostty.sh --version
```

## Manual Configuration

If you prefer to configure Ghostty manually, the configuration file is located at:
```bash
~/.config/ghostty/config
```

You can edit it with any text editor:
```bash
nano ~/.config/ghostty/config
# or
vim ~/.config/ghostty/config
```

## Reloading Configuration

After making changes to the configuration file:

1. **Inside Ghostty**: Press `Ctrl+S+R` to reload configuration
2. **From terminal**: Restart Ghostty completely

## Troubleshooting

### Installation Issues
```bash
# If Snap installation fails, try updating Snap first
sudo snap refresh

# Or install Ghostty manually
sudo dnf install -y ghostty
```

### Permission Issues
```bash
# Ensure the script is executable
chmod +x master-ghostty.sh

# Run as regular user (script will ask for sudo when needed)
./master-ghostty.sh
```

### Configuration Issues
```bash
# Check if configuration file exists
ls -la ~/.config/ghostty/config

# Restore from backup if needed
cp ~/.config/ghostty/backup/config_backup_* ~/.config/ghostty/config
```

## Verification

To verify Ghostty is working correctly:

```bash
# Check if command works
ghostty --version

# Start Ghostty
ghostty

# Test configuration reload inside Ghostty
# Press Ctrl+S+R
```

## System Requirements

- **Operating System**: Ubuntu 20.04+ or other Snap-compatible Linux distribution
- **Package Manager**: Snap (`snapd`) must be installed and configured
- **Permissions**: Sudo access for package installation

## Script Structure

The script follows this structure:

1. **Initialization** - Color definitions and logging functions
2. **Requirements Check** - Verify system compatibility
3. **Installation Phase** - Install Ghostty if needed
4. **Configuration Phase** - Setup directory, backup, and config
5. **Verification Phase** - Test installation and configuration
6. **Completion** - Display usage information and keybindings

## Safety Notes

- ✅ **Backups**: Automatically backs up existing configurations
- ✅ **Prompts**: Asks for confirmation before making changes
- ✅ **Verification**: Tests installation before completion
- ✅ **Error Handling**: Provides clear error messages
- ✅ **Rollback**: Easy restoration from backup files

## Integration with Development Workflow

Ghostty with this configuration is optimized for:

- **Multi-window development** with split support
- **Quick tab switching** for project management
- **Efficient navigation** with custom keybindings
- **Dark theme** for reduced eye strain during long sessions
- **Shell integration** for seamless terminal workflow

## Additional Resources

- **Ghostty Official Documentation**: https://ghostty.org/docs
- **Catppuccin Theme**: https://github.com/catppuccin/catppuccin
- **Snap Documentation**: https://snapcraft.io/docs

---

**Note**: This script is part of the Ubuntu Development Tools setup and is designed to work seamlessly with the complete development environment configuration.