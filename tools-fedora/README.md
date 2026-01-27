# Tools for Fedora

This directory contains all scripts from `/tools` converted to work with Fedora.

## Key Changes from Debian/Ubuntu

### Package Manager
- `apt` → `dnf`
- `apt update` → `dnf check-update` (or just skip, dnf auto-updates metadata)
- `apt install -y` → `dnf install -y`
- `apt remove` → `dnf remove`

### Package Names
Common differences:
- `build-essential` → `@development-tools`
- `*-dev` packages → `*-devel` packages
- `python3-dev` → `python3-devel`
- `libssl-dev` → `openssl-devel`

### What Doesn't Change
- ✅ All config files (kitty.conf, .p10k.zsh, tmux.conf, zshrc-config)
- ✅ Git-based installations (Oh My Zsh, Powerlevel10k, plugins)
- ✅ Curl-based installers (Kitty, etc.)
- ✅ Most shell scripting logic

## Converted Scripts

### ✅ Fully Converted
- `master-zsh.sh` - Zsh + Oh My Zsh + Powerlevel10k
- `install_kitty.sh` - Kitty terminal installer
- *(others being converted...)*

### 📋 Config Files (No Changes Needed)
- `kitty.conf` - Kitty configuration
- `.p10k.zsh` - Powerlevel10k theme
- `tmux.conf` - Tmux configuration
- `zshrc-config` - Zsh configuration
- `switch_theme.sh` - Theme switcher script

## Usage

All scripts work the same way as the originals:

```bash
# Install Zsh with Oh My Zsh and Powerlevel10k
./master-zsh.sh

# Install Kitty terminal
./install_kitty.sh

# ... etc
```

## Testing Status

- ⚠️ These scripts have been converted but not tested on Fedora yet
- Test before relying on them in production
- Report issues if you find any package name mismatches

## Notes for Fedora

1. **SELinux**: Some operations may be blocked by SELinux. If you encounter permission issues:
   ```bash
   sudo setenforce 0  # Temporarily disable
   # Or configure SELinux policies properly
   ```

2. **Firewall**: Firewalld is default (not ufw)
   ```bash
   sudo firewall-cmd --list-all
   ```

3. **Flatpak > Snap**: Fedora prefers Flatpak
   ```bash
   flatpak install flathub <package>
   ```

4. **COPR Repos**: Equivalent of PPAs
   ```bash
   sudo dnf copr enable <user>/<project>
   ```
