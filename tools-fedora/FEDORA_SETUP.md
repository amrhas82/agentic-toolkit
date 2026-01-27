# Fedora Installation & Setup Guide

Complete guide for partitioning and post-installation setup on Fedora.

---

## Partition Layout (931.5GB NVMe SSD)

### Recommended Scheme

```
┌────────────────────────────────────────────────────────────┐
│                    931.5GB NVMe SSD                        │
├────────────────────────────────────────────────────────────┤
│  Partition    Size      Mount         Filesystem  Notes    │
├────────────────────────────────────────────────────────────┤
│  1. EFI       512MB     /boot/efi     vfat        UEFI     │
│  2. Swap      20GB      [SWAP]        swap        Hibernate│
│  3. Root      150GB     /             ext4        System   │
│  4. Home      220GB     /home         ext4        User     │
│  5. Storage   541GB     /stuff        ext4        Data     │
└────────────────────────────────────────────────────────────┘

Total: 931.5GB
```

### Partition Details

#### 1. EFI Partition (512MB)
- **Mount:** `/boot/efi`
- **Filesystem:** vfat (FAT32)
- **Purpose:** UEFI bootloader
- **Flags:** boot, esp

#### 2. Swap Partition (20GB)
- **Mount:** [SWAP]
- **Filesystem:** swap
- **Purpose:** Hibernate support (32GB RAM)
- **Notes:**
  - 20GB tested working for hibernate
  - Can use 24GB for extra safety
  - Must be ≥ RAM usage at hibernate time

#### 3. Root Partition (150GB)
- **Mount:** `/`
- **Filesystem:** ext4 (or btrfs)
- **Purpose:** System files, packages, Docker

**Root Space Allocation:**
```
Fedora base system:     15GB
Installed packages:     30GB
Docker images/data:     40GB
Flatpak applications:   20GB
Logs & cache (/var):    15GB
Free buffer:            30GB
─────────────────────────────
Total:                 150GB
```

#### 4. Home Partition (220GB)
- **Mount:** `/home`
- **Filesystem:** ext4 (or btrfs)
- **Purpose:** User data, projects, configs

**Home Space Allocation:**
```
Projects (PycharmProjects):  30GB
Dotfiles & configs:           5GB
Steam games (~/.steam):      50GB
Documents & downloads:       20GB
Development environments:    30GB
Free space:                  85GB
─────────────────────────────────
Total:                      220GB
```

#### 5. Storage Partition (541GB)
- **Mount:** `/stuff`
- **Filesystem:** ext4
- **Purpose:** Large files, media, backups, extra Steam library
- **Notes:** Keep from current setup, don't format

### Why This Layout

| Decision | Reasoning |
|----------|-----------|
| **No separate /boot** | Modern systems don't need it; simplifies layout |
| **150GB root** | Handles Docker, Flatpak, package experiments safely |
| **220GB home** | Plenty for projects + configs; big files go to /stuff |
| **20GB swap** | Hibernate works; tested on 32GB RAM system |
| **Keep /stuff** | Already has 241GB of data; don't lose it |

### Distro Hopping Strategy

```
To switch distros:
1. Backup /home configs: ~/.config, ~/.zshrc, ~/.p10k.zsh
2. Install new distro to root (150GB) - FORMAT THIS
3. Mount existing /home (220GB) - DON'T FORMAT
4. Mount existing /stuff (541GB) - DON'T FORMAT
5. Restore configs if needed
6. Done - all your data intact!
```

---

## Fedora Installer Steps

### During Installation

1. **Select "Custom" partitioning** (not automatic)

2. **Delete old partitions** (except /stuff if keeping data):
   - Delete old EFI, /boot, swap, root, home
   - Keep /stuff partition intact

3. **Create new partitions:**

   ```
   Click "+" to add each partition:

   [+] Mount Point: /boot/efi
       Size: 512 MiB
       Filesystem: EFI System Partition

   [+] Mount Point: (none - select swap)
       Size: 20 GiB
       Filesystem: swap

   [+] Mount Point: /
       Size: 150 GiB
       Filesystem: ext4

   [+] Mount Point: /home
       Size: 220 GiB
       Filesystem: ext4

   [+] Mount Point: /stuff (if reformatting)
       Size: (remaining)
       Filesystem: ext4
   ```

4. **If keeping /stuff data:**
   - Select existing /stuff partition
   - Set mount point to `/stuff`
   - **UNCHECK "Format"** ⚠️

5. **Review and confirm**

---

## Post-Installation Setup

### 1. Update System

```bash
sudo dnf update -y
sudo dnf upgrade -y
```

### 2. DNF Performance Tweaks

Edit `/etc/dnf/dnf.conf`:

```bash
sudo nano /etc/dnf/dnf.conf
```

Add these lines:

```ini
# Performance optimizations
fastestmirror=True
max_parallel_downloads=10
defaultyes=True
keepcache=True
```

**What these do:**
- `fastestmirror=True` - Automatically selects fastest mirror
- `max_parallel_downloads=10` - Downloads 10 packages simultaneously
- `defaultyes=True` - Default to "yes" for prompts (like apt -y)
- `keepcache=True` - Keeps downloaded packages (useful for reinstalls)

### 3. Enable RPM Fusion Repositories

```bash
# Free repository (open source extras)
sudo dnf install -y \
  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm

# Non-free repository (proprietary drivers, codecs)
sudo dnf install -y \
  https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
```

### 4. Install Multimedia Codecs

```bash
# Install codecs for media playback
sudo dnf install -y gstreamer1-plugins-{bad-\*,good-\*,base} \
  gstreamer1-plugin-openh264 gstreamer1-libav \
  --exclude=gstreamer1-plugins-bad-free-devel

# Install FFmpeg
sudo dnf install -y ffmpeg ffmpeg-libs
```

### 5. Intel GPU Freeze Fix

**Critical for Intel UHD 620 users:**

```bash
sudo nano /etc/default/grub
```

Find `GRUB_CMDLINE_LINUX_DEFAULT` and add:

```
i915.enable_psr=0 i915.enable_fbc=0 intel_idle.max_cstate=1
```

Example:
```
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash i915.enable_psr=0 i915.enable_fbc=0 intel_idle.max_cstate=1"
```

Update GRUB:

```bash
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
```

### 6. Enable Flatpak & Flathub

```bash
# Fedora has Flatpak by default, add Flathub
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
```

### 7. Install Development Tools

```bash
# Core development tools
sudo dnf groupinstall -y "Development Tools"

# Additional essentials
sudo dnf install -y \
  git \
  curl \
  wget \
  vim \
  neovim \
  htop \
  ripgrep \
  fd-find \
  fzf \
  zsh \
  tmux
```

### 8. Enable SSD Trim

```bash
sudo systemctl enable fstrim.timer
sudo systemctl start fstrim.timer
```

### 9. Optimize Swap Usage

```bash
# Reduce swappiness (default 60, lower = less swap use)
echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```

### 10. Set Hostname

```bash
sudo hostnamectl set-hostname your-hostname
```

---

## Essential Apps Installation

### Terminal & Shell

```bash
# Run the setup script
cd ~/path/to/tools-fedora
./master-zsh.sh      # Zsh + Oh My Zsh + Powerlevel10k
./install_kitty.sh   # Kitty terminal
```

### Development

```bash
# PyCharm (via Flatpak)
flatpak install -y flathub com.jetbrains.PyCharm-Community

# Sublime Text
sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
sudo dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
sudo dnf install -y sublime-text

# Docker
sudo dnf install -y dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf install -y docker-ce docker-ce-cli containerd.io
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER
```

### Browsers & Communication

```bash
# Firefox (pre-installed)
# Thunderbird
sudo dnf install -y thunderbird

# Chrome (optional)
sudo dnf install -y fedora-workstation-repositories
sudo dnf config-manager --set-enabled google-chrome
sudo dnf install -y google-chrome-stable
```

### Gaming (Steam)

```bash
# Enable Steam (from RPM Fusion)
sudo dnf install -y steam

# Steam will install to ~/.steam (in /home)
# Add /stuff as extra library if needed
```

---

## Directory Structure After Setup

```
/                           (150GB - system)
├── /boot/efi               (512MB - UEFI)
├── /var/lib/docker         (Docker data)
├── /var/lib/flatpak        (Flatpak apps)
└── /usr, /etc, /var...     (System files)

/home                       (220GB - your data)
├── ~/PycharmProjects       (Your projects)
├── ~/.config               (App configs)
├── ~/.steam                (Steam client + games)
├── ~/.local                (Local apps, data)
├── ~/.zshrc, ~/.p10k.zsh   (Shell configs)
└── ~/Documents, ~/Downloads

/stuff                      (541GB - storage)
├── Large files
├── Backups
├── Media
└── Extra Steam library (optional)
```

---

## Quick Reference

### Partition Summary

```
EFI:     512MB   /boot/efi   (vfat)
Swap:    20GB    [SWAP]      (swap)
Root:    150GB   /           (ext4)
Home:    220GB   /home       (ext4)
Storage: 541GB   /stuff      (ext4)
```

### Key Commands

```bash
# Check disk usage
df -h

# Check partition layout
lsblk

# DNF package management
sudo dnf install <package>
sudo dnf remove <package>
sudo dnf search <keyword>
sudo dnf update

# Flatpak
flatpak install flathub <app>
flatpak list
flatpak uninstall <app>

# Docker
docker ps
docker images
docker system prune  # Clean up space
```

### Hibernate Test

```bash
# Test hibernate after setup
sudo systemctl hibernate

# If it fails, check swap size
free -h
swapon --show
```

---

## Troubleshooting

### Root Running Out of Space

```bash
# Check what's using space
sudo du -sh /* 2>/dev/null | sort -rh | head -10

# Clean package cache
sudo dnf clean all

# Clean Docker
docker system prune -a

# Clean Flatpak unused
flatpak uninstall --unused
```

### Hibernate Not Working

```bash
# Verify swap size >= RAM usage
free -h

# Check resume parameter in GRUB
cat /etc/default/grub | grep resume

# May need to add resume=UUID=<swap-uuid>
```

### GPU Freezes

```bash
# Verify kernel parameters applied
cat /proc/cmdline | grep i915

# Should show: i915.enable_psr=0 i915.enable_fbc=0
```

---

**Created:** 2026-01-27
**Target:** Fedora 39/40
**Hardware:** Intel i7-8665U, 32GB RAM, Intel UHD 620
