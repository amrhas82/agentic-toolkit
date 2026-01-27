# Migration Guide: Zorin OS → Fedora

Complete guide for migrating your setup from Zorin OS to Fedora.

## Your Current Setup

- **Terminal**: Kitty
- **Shell**: Zsh + Oh My Zsh + Powerlevel10k
- **Apps**: Thunderbird, Firefox, PyCharm, Kitty, Sublime Text, Steam
- **Workflow**: 3 tabs × 2 splits (6 concurrent terminals)

## Pre-Migration Checklist

### 1. Backup Your Dotfiles

```bash
# Create backup archive
tar -czf ~/dotfiles-backup-$(date +%Y%m%d).tar.gz \
    ~/.config/kitty \
    ~/.config/nvim \
    ~/.zshrc \
    ~/.p10k.zsh \
    ~/.tmux.conf \
    ~/.gitconfig \
    ~/Documents/PycharmProjects/agentic-toolkit
```

### 2. Document Installed Packages

```bash
# List manually installed packages
apt list --installed > ~/zorin-packages-$(date +%Y%m%d).txt

# List PPAs
grep -r --include '*.list' '^deb ' /etc/apt/ > ~/zorin-ppas.txt
```

### 3. Export Browser Data

- **Firefox**: Sync account or export bookmarks
- **Thunderbird**: Backup profile (`~/.thunderbird`)

### 4. Copy SSH Keys & Git Config

```bash
# Backup SSH keys
tar -czf ~/ssh-backup.tar.gz ~/.ssh

# Git is already in dotfiles backup
```

## Post-Installation: Fedora Setup

### Step 1: Update System

```bash
sudo dnf update -y
sudo dnf upgrade -y
```

### Step 2: Enable RPM Fusion (for proprietary software)

```bash
sudo dnf install -y \
    https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
```

### Step 3: Install Your Core Apps

```bash
# Install from Fedora repos
sudo dnf install -y \
    thunderbird \
    firefox \
    sublime-text \
    steam \
    git \
    neovim \
    ripgrep \
    fd-find \
    fzf \
    htop \
    curl \
    wget

# PyCharm (via JetBrains Toolbox or Flatpak)
flatpak install flathub com.jetbrains.PyCharm-Community
```

### Step 4: Restore Your Dotfiles

```bash
# Extract backup
cd ~
tar -xzf dotfiles-backup-*.tar.gz

# Verify
ls -la ~/.config/kitty
ls -la ~/.zshrc
```

### Step 5: Run Setup Scripts

```bash
cd ~/Documents/PycharmProjects/agentic-toolkit/tools-fedora

# Install Zsh + Oh My Zsh + Powerlevel10k
./master-zsh.sh

# Install Kitty
./install_kitty.sh

# Install Neovim/LazyVim (if needed)
./master-lazyvim.sh

# Install Tmux (optional)
./master_tmux_setup.sh
```

### Step 6: Install Development Tools

```bash
# Python development
sudo dnf install -y \
    python3 \
    python3-pip \
    python3-devel \
    @development-tools

# Additional tools
sudo dnf install -y \
    nodejs \
    npm \
    gcc \
    g++ \
    make \
    cmake \
    openssl-devel
```

### Step 7: Fix Intel GPU Freezing (IMPORTANT!)

Add kernel parameters to fix your Intel UHD 620 GPU issues:

```bash
sudo nano /etc/default/grub
```

Find the line starting with `GRUB_CMDLINE_LINUX_DEFAULT` and add:
```
i915.enable_psr=0 i915.enable_fbc=0 intel_idle.max_cstate=1
```

Then update grub:
```bash
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
sudo reboot
```

## Package Name Conversions

Your common packages on Fedora:

| Zorin/Ubuntu | Fedora |
|--------------|--------|
| `build-essential` | `@development-tools` |
| `python3-dev` | `python3-devel` |
| `libssl-dev` | `openssl-devel` |
| `sublime-text` | Install via repo or Flatpak |
| `kitty` | Use official installer (in scripts) |

## Fedora-Specific Tips

### 1. Flatpak (Preferred over Snap)

```bash
# Enable Flathub
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Search and install
flatpak search pycharm
flatpak install flathub com.jetbrains.PyCharm-Community
```

### 2. COPR Repos (Fedora's PPAs)

```bash
# Example: Enable a COPR repo
sudo dnf copr enable user/project-name

# Install from COPR
sudo dnf install package-name
```

### 3. SELinux

If you encounter permission issues:

```bash
# Check SELinux status
getenforce

# Temporarily disable (for testing)
sudo setenforce 0

# Permanently disable (not recommended)
sudo nano /etc/selinux/config
# Change SELINUX=enforcing to SELINUX=permissive
```

### 4. Firewall

Fedora uses firewalld (not ufw):

```bash
# Check firewall status
sudo firewall-cmd --state

# List zones and services
sudo firewall-cmd --get-active-zones
sudo firewall-cmd --list-all
```

## Performance Tuning

Your setup: Intel i7-8665U + 32GB RAM + Intel UHD 620

### 1. Reduce Swap Usage

```bash
# Check current swappiness
cat /proc/sys/vm/swappiness

# Set to 10 (default is 60)
echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```

### 2. Enable Trim for SSD

```bash
sudo systemctl enable fstrim.timer
sudo systemctl start fstrim.timer
```

### 3. Install Intel Microcode

```bash
sudo dnf install -y microcode_ctl
sudo dracut --force
```

## Troubleshooting

### Kitty Not Found After Install

```bash
export PATH="$HOME/.local/kitty.app/bin:$PATH"
source ~/.zshrc
```

### Zsh Not Default Shell

```bash
chsh -s $(which zsh)
# Log out and back in
```

### Git Credentials Missing

```bash
# Restore SSH keys
tar -xzf ~/ssh-backup.tar.gz -C ~
chmod 600 ~/.ssh/id_*
chmod 644 ~/.ssh/id_*.pub
```

### Steam Not Launching

```bash
# Install additional libraries
sudo dnf install -y steam-devices
```

## What You'll Gain

✅ **Performance**:
- Newer kernel (better hardware support)
- Faster package updates
- Less bloat

✅ **Stability** (with kernel params):
- No more Intel GPU freezes
- Better Wayland support
- Improved power management

✅ **Developer Experience**:
- Latest packages
- Better RHEL/CentOS compatibility
- Modern toolchain

## What You'll Lose

⚠️ **LTS Support**:
- Fedora releases every 6 months
- Support for 13 months only
- Need to upgrade regularly

⚠️ **Some Convenience**:
- PPAs → COPR (less common)
- Snap → Flatpak (learning curve)
- Some packages may lag behind Ubuntu

## Post-Migration Checklist

After migrating, verify:

- [ ] Kitty works with Ctrl+S bindings
- [ ] Zsh + Powerlevel10k theme loads
- [ ] PyCharm opens and runs
- [ ] Firefox synced bookmarks
- [ ] Thunderbird email works
- [ ] Steam launches
- [ ] Git credentials work
- [ ] Python environments work
- [ ] No GPU freezes after 24h

## Getting Help

If you encounter issues:

1. Check Fedora docs: https://docs.fedoraproject.org/
2. Fedora forums: https://ask.fedoraproject.org/
3. Reddit: r/Fedora
4. Your scripts: All have error handling and logs

## Final Note

**Before switching distros, try fixing your Zorin freezing first!**

The issues you're experiencing are likely:
1. Failing USB drive (Family Backup)
2. Intel GPU driver issues

Both can be fixed on Zorin with the kernel parameters I showed you.

Switching distros is a big time investment. Make sure it's worth it!
