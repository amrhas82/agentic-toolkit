# Zorin OS Hibernate & Suspend Setup Guide

## Table of Contents
1. [Check Current Hibernate Status](#check-current-hibernate-status)
2. [Verify System Requirements](#verify-system-requirements)
3. [Enable Hibernate](#enable-hibernate)
4. [Test Hibernate](#test-hibernate)
5. [Troubleshooting](#troubleshooting)
6. [Known Issue: Kernel 6.8+ Bug](#known-issue-kernel-68-bug)
7. [Using Suspend (Recommended)](#using-suspend-recommended)
8. [Cleanup Failed Hibernate Setup](#cleanup-failed-hibernate-setup)

---

## Check Current Hibernate Status

### Step 1: Check if Hibernate Command Exists
```bash
systemctl hibernate
```
**Expected Results:**
- If hibernate works: System will hibernate immediately
- If not enabled: Error message like "Failed to hibernate system via logind"

### Step 2: Check Available Power Management Options
```bash
cat /sys/power/state
```
**Expected Output:** Should show `freeze mem disk`
- `disk` = hibernate is supported by kernel

### Step 3: Check Systemd Hibernate Status
```bash
systemctl status systemd-hibernate.service
```
Shows whether the hibernate service is loaded and available.

---

## Verify System Requirements

### Step 1: Check RAM Size
```bash
free -h
```
**Important:** Your swap partition must be **at least equal to or larger than your RAM** for hibernate to work reliably.

### Step 2: Verify Swap Partition
```bash
swapon --show
```
**Expected Output:** Should show your swap partition is active
```
NAME           TYPE SIZE USED
/dev/nvme0n1p3 partition 8G 0B
```

### Step 3: Get Swap Partition UUID
```bash
sudo blkid | grep swap
```
**Example Output:**
```
/dev/nvme0n1p3: UUID="1234abcd-5678-efgh-90ij-klmnopqrstuv" TYPE="swap"
```
**📝 IMPORTANT: Copy this UUID - you'll need it later!**

### Step 4: Alternative - Use Device Path
```bash
lsblk -f | grep swap
```
This confirms your swap partition location (should be `/dev/nvme0n1p3` based on your layout).

---

## Enable Hibernate

### Step 1: Configure GRUB with Resume Parameter

Edit the GRUB configuration:
```bash
sudo nano /etc/default/grub
```

Find the line that starts with:
```
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"
```

**Option A: Using UUID (Recommended)**
Change it to:
```
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash resume=UUID=YOUR-SWAP-UUID-HERE"
```

**Option B: Using Device Path**
Change it to:
```
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash resume=/dev/nvme0n1p3"
```

**⚠️ CRITICAL NOTE:** 
- Use **nvme0n1p3** (your 8GB swap partition)
- Using the wrong partition will prevent hibernate from working

**Save and exit:** `Ctrl+O`, `Enter`, `Ctrl+X`

### Step 2: Update GRUB
```bash
sudo update-grub
```

### Step 3: Configure Initramfs Resume

Create or edit the resume configuration:
```bash
sudo nano /etc/initramfs-tools/conf.d/resume
```

Add this line (using your swap UUID):
```
RESUME=UUID=YOUR-SWAP-UUID-HERE
```

Or using device path:
```
RESUME=/dev/nvme0n1p3
```

**Save and exit:** `Ctrl+O`, `Enter`, `Ctrl+X`

### Step 4: Update Initramfs
```bash
sudo update-initramfs -u -k all
```

### Step 5: Enable Hibernate in Systemd (Optional but Recommended)

Check if hibernate is blocked:
```bash
cat /etc/polkit-1/localauthority/50-local.d/com.ubuntu.enable-hibernate.pkla
```

If file doesn't exist, create it:
```bash
sudo nano /etc/polkit-1/localauthority/50-local.d/com.ubuntu.enable-hibernate.pkla
```

Add this content:
```ini
[Re-enable hibernate by default in upower]
Identity=unix-user:*
Action=org.freedesktop.upower.hibernate
ResultActive=yes

[Re-enable hibernate by default in logind]
Identity=unix-user:*
Action=org.freedesktop.login1.hibernate;org.freedesktop.login1.handle-hibernate-key;org.freedesktop.login1.hibernate-multiple-sessions;org.freedesktop.login1.hibernate-ignore-inhibit
ResultActive=yes
```

**Save and exit:** `Ctrl+O`, `Enter`, `Ctrl+X`

### Step 6: Reboot
```bash
sudo reboot
```

---

## Test Hibernate

### Method 1: Command Line Test
```bash
systemctl hibernate
```
System should hibernate. Press power button to wake.

### Method 2: Check Hibernate Option in GUI
After reboot, check if hibernate appears in:
- Power menu
- System settings → Power options

### Method 3: Verify Resume Parameter Loaded
```bash
cat /proc/cmdline
```
Should show `resume=/dev/nvme0n1p3` or `resume=UUID=...` in the output.

---

## Troubleshooting

### Issue: Hibernate Command Fails

**Check kernel parameters are loaded:**
```bash
cat /proc/cmdline | grep resume
```
If `resume=` doesn't appear, GRUB wasn't updated properly.

**Solution:** Re-run Step 2 from Enable Hibernate section:
```bash
sudo update-grub
sudo reboot
```

### Issue: System Hibernates but Won't Resume

**Possible Cause:** Wrong resume device specified

**Verify your swap partition:**
```bash
swapon --show
cat /proc/swaps
```

**Check resume configuration:**
```bash
cat /etc/initramfs-tools/conf.d/resume
```

**Solution:** Ensure it points to your actual swap partition (nvme0n1p3), then:
```bash
sudo update-initramfs -u -k all
sudo reboot
```

### Issue: Not Enough Swap Space

**Check if swap is smaller than RAM:**
```bash
free -h
```

**Solution:** If RAM > Swap, you need to either:
1. Increase swap partition size (requires repartitioning)
2. Add a swap file to supplement the partition

### Check System Logs After Failed Hibernate
```bash
journalctl -b -1 | grep -i hibernate
```
Shows hibernate-related messages from last boot.

```bash
journalctl -b -1 | grep -i resume
```
Shows resume-related messages from last boot.

### Verify Hibernate is Not Blocked by BIOS

Some systems have hibernate disabled in BIOS/UEFI:
1. Reboot into BIOS/UEFI settings
2. Look for power management options
3. Ensure "S4 State" or "Hibernate" is enabled

---

## Known Issue: Kernel 6.8+ Bug

**Problem:** On Zorin OS 17 with kernel 6.8+, hibernate may fail on Dell laptops with Intel i915 graphics. The system writes the hibernation image successfully but immediately triggers a wakeup event during the S4 state transition.

**Symptoms:**
- Hibernate appears to work (saves image to disk)
- System immediately resumes instead of powering off
- Logs show: `PM: hibernation: Wakeup event detected during hibernation, rolling back`

**Root Cause:** ACPI wakeup event during console suspension - a known regression in kernel 6.8+ affecting Dell/Intel systems.

**Diagnosis Commands:**
```bash
# Check for wakeup events
sudo dmesg | grep -i "wakeup event"

# See detailed hibernate process
sudo dmesg | grep "PM:" | tail -30
```

**Working Workaround:** Use suspend instead (see next section).

---

## Using Suspend (Recommended)

If hibernate doesn't work due to the kernel bug, regular suspend is a reliable alternative:

### Enable Suspend

Suspend usually works out of the box, but verify:

```bash
systemctl suspend
```

### Suspend from GUI
- Use the power menu → Suspend
- Close laptop lid (if configured in settings)
- Press the suspend key (if available on your keyboard)

### Configure Lid Behavior

To ensure lid close triggers suspend:

```bash
sudo nano /etc/systemd/logind.conf
```

Find and uncomment/modify these lines:
```ini
HandleLidSwitch=suspend
HandleLidSwitchExternalPower=suspend
HandleLidSwitchDocked=ignore
```

**Restart the service:**
```bash
sudo systemctl restart systemd-logind
```

**Log out and back in** for changes to take effect.

### Battery Usage in Suspend

Modern systems use very little power in suspend:
- Typical drain: 1-3% per 24 hours
- Safe for overnight or weekend use
- Much faster to wake than hibernate

### For Extended Periods

If leaving your laptop unused for weeks:
- Save your work
- Close all applications
- Use shutdown instead: `sudo shutdown now`

### Verify Suspend Works
```bash
# Check suspend status
systemctl status systemd-suspend.service

# Check logs after waking from suspend
journalctl -b | grep -i suspend
```

---

## Cleanup Failed Hibernate Setup

If hibernate doesn't work and you want to clean up:

### Step 1: Revert GRUB Changes
```bash
sudo nano /etc/default/grub
```

Remove the resume parameter:
```
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"
```

```bash
sudo update-grub
```

### Step 2: Remove Hibernate Configuration
```bash
# Remove initramfs resume config
sudo rm /etc/initramfs-tools/conf.d/resume

# Update initramfs
sudo update-initramfs -u -k all
```

### Step 3: Remove Polkit Hibernate Policy (if created)
```bash
sudo rm /etc/polkit-1/localauthority/50-local.d/com.ubuntu.enable-hibernate.pkla
```

### Step 4: Reboot
```bash
sudo reboot
```

---

## Quick Reference Commands

```bash
# Check hibernate support
cat /sys/power/state

# Show swap
swapon --show

# Get swap UUID
sudo blkid | grep swap

# Test hibernate
systemctl hibernate

# Test suspend
systemctl suspend

# Check if resume parameter is loaded
cat /proc/cmdline | grep resume

# View hibernate logs
journalctl -b -1 | grep -i hibernate

# View suspend logs
journalctl -b | grep -i suspend
```

---

## Summary

### Working Setup (if hibernate works):
✅ Hibernate enabled with resume parameter
✅ Quick suspend for short breaks
✅ Hibernate for long-term battery savings

### Fallback (if kernel 6.8 bug affects you):
✅ Use suspend for daily power management
✅ Use shutdown for extended periods
✅ Minimal battery drain (1-3% per day in suspend)

---

*Last Updated: October 2025*