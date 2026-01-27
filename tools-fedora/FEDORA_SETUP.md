# Fedora Setup Guide

**Hardware:** Intel i7-8665U, 32GB RAM, Intel UHD 620, 931.5GB NVMe SSD

---

## 1. Bootable USB

```bash
lsblk                        # find USB device (e.g. /dev/sda)
sudo umount /media/$USER/Fedora*
sudo dd if=~/Downloads/Fedora-KDE-Desktop-Live-43-1.6.x86_64.iso of=/dev/sda bs=4M status=progress oflag=sync
sync
```

Use `/dev/sda` (whole device), NOT `/dev/sda1` (partition). Wrong device = data loss.

---

## 2. Partition Scheme

```
┌─────────────────────────────────────────────────────────────────────────────┐
│  Partition    Size      Mount         Filesystem  Flags    Notes           │
├─────────────────────────────────────────────────────────────────────────────┤
│  1. Root      148GB     /             ext4        -        System          │
│  2. EFI       512MB     /boot/efi     fat32       boot,esp UEFI boot      │
│  3. Boot      2GB       /boot         ext4        -        Kernels        │
│  4. Home      220GB     /home         ext4        -        User data      │
│  5. Swap      20GB      swap          swap        swap     Hibernation    │
│  6. Storage   539GB     /stuff        ext4        -        Data storage   │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 3. KDE Installer Steps

### BEFORE installer:
1. Open KDE Partition Manager
2. Format 512MB EFI partition as FAT32
3. Set boot flag on EFI partition

### IN installer:
1. Select "Custom" partitioning
2. Delete old partitions (keep /stuff if preserving data)
3. Set mount points for ALL partitions:

```
Root (148GB)    → /            ext4
EFI (512MB)     → /boot/efi    fat32 (toggle reformat ON)
Boot (2GB)      → /boot        ext4
Home (220GB)    → /home        ext4
Swap (20GB)     → swap         (use "Custom" field)
Storage (539GB) → /stuff       (use "Custom" field)
```

If keeping /stuff data: set mount point to `/stuff`, **UNCHECK "Format"**

---

## 4. Post-Install

### System update
```bash
sudo dnf update -y && sudo dnf upgrade -y
```

### DNF config (`/etc/dnf/dnf.conf`)
```ini
fastestmirror=True
max_parallel_downloads=10
defaultyes=True
keepcache=True
```

### RPM Fusion
```bash
sudo dnf install -y \
  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
  https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
```

### Multimedia codecs
```bash
sudo dnf install -y gstreamer1-plugins-{bad-\*,good-\*,base} \
  gstreamer1-plugin-openh264 gstreamer1-libav \
  --exclude=gstreamer1-plugins-bad-free-devel
sudo dnf install -y ffmpeg ffmpeg-libs
```

### Intel GPU freeze fix
```bash
# Add to GRUB_CMDLINE_LINUX_DEFAULT in /etc/default/grub:
i915.enable_psr=0 i915.enable_fbc=0 intel_idle.max_cstate=1

sudo grub2-mkconfig -o /boot/grub2/grub.cfg
```

### Flatpak
```bash
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
```

### Dev tools
```bash
sudo dnf groupinstall -y "Development Tools"
sudo dnf install -y git curl wget vim neovim htop ripgrep fd-find fzf zsh tmux
```

### SSD trim + swap tuning
```bash
sudo systemctl enable --now fstrim.timer
echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.conf && sudo sysctl -p
```

### Hostname
```bash
sudo hostnamectl set-hostname your-hostname
```

---

## 5. Apps

```bash
# PyCharm
cd ~/Downloads && tar -xzf pycharm-2025.3.2.tar.gz
~/Downloads/pycharm-2025.3.2/bin/pycharm

# Sublime Text
sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
sudo dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
sudo dnf install -y sublime-text

# Thunderbird
sudo dnf install -y thunderbird

# Docker
sudo dnf install -y dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf install -y docker-ce docker-ce-cli containerd.io
sudo systemctl enable --now docker
sudo usermod -aG docker $USER

# Chrome (optional)
sudo dnf install -y fedora-workstation-repositories
sudo dnf config-manager --set-enabled google-chrome
sudo dnf install -y google-chrome-stable

# Steam (requires RPM Fusion)
sudo dnf install -y steam
```

---

## 6. Distro Hopping

```
FORMAT:     / (148GB), /boot (2GB)
DON'T FORMAT: /home (220GB), /stuff (539GB)
BACKUP:     ~/.config, ~/.zshrc, ~/.p10k.zsh
```

---

## Troubleshooting

```bash
# Disk usage
sudo du -sh /* 2>/dev/null | sort -rh | head -10

# Clean space
sudo dnf clean all
docker system prune -a
flatpak uninstall --unused

# Hibernate test
sudo systemctl hibernate
free -h && swapon --show

# GPU freeze check
cat /proc/cmdline | grep i915
```
