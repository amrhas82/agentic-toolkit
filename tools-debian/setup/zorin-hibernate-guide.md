# Zorin OS Hibernate & Suspend Setup Guide

## Table of Contents
1. [Check Current Hibernate Status](#check-current-hibernate-status)
2. [Verify System Requirements](#verify-system-requirements)
3. [Enable Hibernate](#enable-hibernate)
4. [Test Hibernate](#test-hibernate)
5. [Troubleshooting](#troubleshooting)
6. [Known Issue: Kernel 6.8+ Bug](#known-issue-kernel-68-bug)
7. [Zorin OS 17.3/18 Hibernate Fix (Kernel 6.8+)](#zorin-os-17318-hibernate-fix-kernel-68)
8. [Using Suspend (Recommended)](#using-suspend-recommended)
9. [Cleanup Failed Hibernate Setup](#cleanup-failed-hibernate-setup)

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

## Zorin OS 17.3/18 Hibernate Fix (Kernel 6.8+)

**Note:** Zorin OS 16.3 used kernel 5.15 LTS where hibernate worked without issues. Zorin OS 17/18 upgraded to kernel 6.8+ HWE which introduced the `intel_hid` driver regression. **This bug is NOT fixed in Zorin 18 (kernel 6.14)** - the same fix applies.

### The Problem Explained

#### What Happens (The Bug Symptoms)

On Zorin OS 17.3/18 with kernel 6.8+ (tested up to 6.14), hibernate appears to work but fails in two ways:

**Scenario 1: Immediate Wakeup During Hibernation**
1. You run `systemctl hibernate`
2. System saves hibernate image to swap (100% complete - this works)
3. System attempts to enter S4 (hibernate/suspend-to-disk) state
4. **Instead of powering off**, system immediately wakes back up
5. Log shows: `PM: hibernation: Wakeup event detected during hibernation, rolling back`
6. You're back at your desktop - hibernate failed

**Scenario 2: Resume Failure (Less Common)**
1. Hibernate completes successfully and system powers off
2. Press power button to resume
3. System shows "resuming from /dev/nvme0n1p3"
4. **Black screen** - system hangs during resume
5. Requires hard reset (hold power button)

#### The Root Cause (Technical Explanation)

The hibernate process on Linux involves several stages:

1. **Freeze processes** - Stop all running applications
2. **Create snapshot** - Save RAM contents to swap partition
3. **Write image to disk** - Compress and write snapshot (this works fine)
4. **Enter S4 state** - Tell ACPI firmware to power off the system

**The bug occurs at step 4:**

The `intel_hid` (Intel HID Event & 5 Button Array) driver, which handles special hardware buttons on Intel laptops, has a regression in kernel 6.8+. During the S4 state transition:

1. Kernel calls ACPI platform methods to suspend devices
2. The `intel_hid` driver's ACPI suspend handler is invoked
3. **BUG:** Driver incorrectly generates a **0xCF event** (power button "up" event)
4. Kernel's power management system sees this as a **wakeup event**
5. Hibernate is aborted with "Wakeup event detected during hibernation, rolling back"
6. System resumes instead of powering off

This is **NOT** a user-triggered wakeup - it's a spurious event generated by buggy driver code.

#### Why It Worked in Zorin 16.3

- **Zorin 16.3:** Used kernel **5.15 LTS** (from Ubuntu 20.04 base)
  - `intel_hid` driver didn't have this regression
  - Hibernate worked perfectly

- **Zorin 17/18:** Upgraded to kernel **6.8/6.14 HWE** (from Ubuntu 22.04/24.04)
  - Regression introduced in `intel_hid` driver code
  - Affects ACPI S4 state transition
  - Hibernate broken on Intel systems

#### Affected Systems

- **Operating Systems:**
  - Zorin OS 17/17.3/18 with kernel 6.8+
  - Ubuntu 24.04 LTS and derivatives
  - Any Linux distro using kernel 6.8-6.14 (possibly higher)

- **Hardware:**
  - Intel-based laptops (especially Dell, HP, Lenovo)
  - Systems with Intel i915 graphics (UHD Graphics 620, Iris Xe, etc.)
  - Laptops with Intel HID 5-button array devices

- **Specific examples:**
  - Dell XPS, Latitude, Inspiron series
  - HP EliteBook, ProBook series
  - Lenovo ThinkPad T/X/L series with Intel CPUs

#### Bug Tracking Status

- **Kernel Bugzilla:** [Bug #218634](https://bugzilla.kernel.org/show_bug.cgi?id=218634)
  - **Status:** OPEN (as of 2025)
  - **First reported:** Kernel 6.8.1
  - **Still present in:** Kernel 6.14+
  - **Upstream fix:** None available

- **Workaround:** Blacklist the `intel_hid` kernel module
  - Recommended by upstream developers
  - Prevents driver from loading
  - Eliminates spurious wakeup events
  - **Side effect:** Lose some vendor-specific button handling (minimal impact)

### Prerequisites

Before starting, identify your swap partition:

```bash
# Find your swap partition
swapon --show

# Example output:
# NAME           TYPE      SIZE
# /dev/nvme0n1p3 partition 8G

# Get the device path - you'll need this for the steps below
# In this example: /dev/nvme0n1p3
```

**IMPORTANT:** Write down your swap device path - you'll use it in multiple steps below.

### The Complete Fix (Step-by-Step)

Follow these steps in order to enable working hibernate:

#### Step 1: Blacklist the intel_hid Module

The `intel_hid` driver causes spurious wakeup events during hibernation. Blacklist it:

```bash
# Create blacklist configuration file
sudo nano /etc/modprobe.d/blacklist-intel-hid.conf
```

Add this content (copy-paste these 3 lines):
```
# Blacklist intel_hid to prevent spurious wakeup events during hibernate
# This fixes kernel 6.8+ regression causing "Wakeup event detected" errors
# Bug: https://bugzilla.kernel.org/show_bug.cgi?id=218634
blacklist intel_hid
```

**Save and exit:** Press `Ctrl+O`, `Enter`, `Ctrl+X`

Update initramfs to apply the blacklist:
```bash
sudo update-initramfs -u -k all
```

This will take 30-60 seconds. You should see output like:
```
update-initramfs: Generating /boot/initrd.img-6.8.0-87-generic
```

#### Step 2: Configure GRUB Resume Parameter

**CRITICAL:** Use device path (like `/dev/nvme0n1p3`), NOT UUID. UUID method doesn't work reliably with the initramfs resume script.

Edit GRUB configuration:
```bash
sudo nano /etc/default/grub
```

Find the line that starts with:
```
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"
```

Change it to (replace `/dev/nvme0n1p3` with YOUR swap device from Prerequisites):
```
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash resume=/dev/nvme0n1p3"
```

**IMPORTANT NOTES:**
- **DO NOT add** `no_console_suspend` - this causes black screen on resume with Intel i915 graphics
- **DO NOT add** `mem_sleep_default=deep` - not needed for hibernate, only for suspend
- **ONLY add** the `resume=/dev/nvme0n1p3` parameter

**Save and exit:** Press `Ctrl+O`, `Enter`, `Ctrl+X`

Update GRUB:
```bash
sudo update-grub
```

You should see output like:
```
Generating grub configuration file ...
Found linux image: /boot/vmlinuz-6.8.0-87-generic
done
```

#### Step 3: Configure Initramfs Resume

Create/edit the resume configuration file:
```bash
sudo nano /etc/initramfs-tools/conf.d/resume
```

Add this single line (replace `/dev/nvme0n1p3` with YOUR swap device):
```
RESUME=/dev/nvme0n1p3
```

**IMPORTANT:**
- Use the SAME device path as in Step 2
- Do NOT use UUID here
- Make sure there are no extra blank lines

**Save and exit:** Press `Ctrl+O`, `Enter`, `Ctrl+X`

Update initramfs:
```bash
sudo update-initramfs -u -k all
```

#### Step 4: Reboot System

```bash
sudo reboot
```

#### Step 5: Verify and Test

After reboot, verify the configuration:

```bash
# 1. Verify intel_hid is NOT loaded
lsmod | grep intel_hid
# Expected: No output (empty result)

# 2. Check resume parameter is loaded in kernel
cat /proc/cmdline | grep resume
# Expected: Should show "resume=/dev/nvme0n1p3"

# 3. Verify swap is active
swapon --show
# Expected: Should list your swap partition
```

If all verifications pass, test hibernate:

```bash
sudo systemctl hibernate
```

**Expected behavior:**
1. Screen shows hibernate progress (saving image)
2. System completely powers off (fans stop, screen goes black)
3. Press power button to resume
4. System boots and shows "resuming from /dev/nvme0n1p3"
5. Desktop appears with all your applications restored

**If you see a black screen during resume:**
- Wait 30 seconds
- If still black, you may need to hard reset (hold power button)
- Check the Troubleshooting section below

### Optional: Configure Power Button for Hibernate

Once hibernate is working, you can optionally make the power button trigger hibernate instead of shutdown:

```bash
sudo nano /etc/systemd/logind.conf
```

Find the line:
```ini
#HandlePowerKey=poweroff
```

Change it to (uncomment and change value):
```ini
HandlePowerKey=hibernate
```

**Save and exit:** Press `Ctrl+O`, `Enter`, `Ctrl+X`

**Apply changes:**
- Log out and log back in, OR
- Reboot the system

Now pressing the power button will hibernate instead of shutting down.

### What Gets Fixed

✅ **Hibernate works** - System saves image and powers off completely
✅ **No spurious wakeups** - intel_hid driver no longer causes "Wakeup event detected" errors
✅ **Resume works** - System successfully restores from hibernate on boot
✅ **Reliable operation** - No black screens or crashes during resume

### What You Lose (Minimal Impact)

By blacklisting `intel_hid`, you lose:
- Some vendor-specific hardware button handling (most functions still work via other drivers)
- Intel 5-button array event processing

**What still works:**
- All regular keyboard keys
- Function keys (brightness, volume - handled by desktop environment)
- Power button (handled by ACPI)
- All other hardware components

### Troubleshooting

#### Problem: Hibernate still shows "Wakeup event detected"

**Cause:** intel_hid module is still loading

**Solution:**
```bash
# Check if intel_hid is loaded
lsmod | grep intel_hid

# If it shows output, the blacklist didn't work
# Verify blacklist file exists
cat /etc/modprobe.d/blacklist-intel-hid.conf

# Regenerate initramfs
sudo update-initramfs -u -k all

# Reboot
sudo reboot
```

#### Problem: Black screen during resume

**Cause:** Extra kernel parameters interfering with Intel i915 graphics driver

**Solution:**
```bash
# Check your GRUB configuration
cat /etc/default/grub | grep GRUB_CMDLINE_LINUX_DEFAULT

# Should ONLY have: "quiet splash resume=/dev/nvme0n1p3"
# If you see no_console_suspend or mem_sleep_default=deep, remove them

sudo nano /etc/default/grub
# Edit to remove extra parameters
# Should look like: GRUB_CMDLINE_LINUX_DEFAULT="quiet splash resume=/dev/nvme0n1p3"

sudo update-grub
sudo reboot
```

#### Problem: System does fresh boot instead of resuming

**Cause:** Resume parameter not set correctly or using UUID instead of device path

**Solution:**
```bash
# Check if resume parameter is loaded
cat /proc/cmdline | grep resume

# If empty or showing UUID, fix it:
# 1. Edit GRUB
sudo nano /etc/default/grub
# Change to: GRUB_CMDLINE_LINUX_DEFAULT="quiet splash resume=/dev/nvme0n1p3"

# 2. Edit initramfs resume
sudo nano /etc/initramfs-tools/conf.d/resume
# Change to: RESUME=/dev/nvme0n1p3
# (no UUID, just device path)

# 3. Update both
sudo update-grub
sudo update-initramfs -u -k all
sudo reboot
```

#### Problem: Swap space too small

**Symptoms:** Hibernate fails with "not enough swap space" errors

**Solution:**
```bash
# Check RAM vs swap
free -h

# If RAM > Swap, you need more swap space
# Option 1: Add a swapfile
sudo fallocate -l 8G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# Make permanent
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
```

#### Checking logs after failed hibernate

```bash
# View hibernate attempt logs
journalctl -b | grep -i hibernate | tail -50

# Check for resume errors
sudo dmesg | grep -i "PM:\|resume\|hibernate"

# Check system logs from previous boot
journalctl -b -1 | grep -i hibernate
```

### Why UUID Doesn't Work

The initramfs resume script (`/usr/share/initramfs-tools/scripts/local-premount/resume`) only writes to `/sys/power/resume` for legacy hibernate types (swsuspend, tuxonice, etc.). Modern Linux uses type "swap" which the script doesn't recognize when using UUID method.

**Device path works** because:
- It's available earlier in the boot process
- The kernel can directly resolve it without waiting for udev
- No dependency on filesystem scanning or UUID lookup

**Always use device path** (`/dev/nvme0n1p3`) instead of UUID for hibernate resume.

### Summary of Working Configuration for Zorin 17.3/18

**For a fresh Zorin 17.3/18 installation, you need exactly:**

1. **Blacklist file:** `/etc/modprobe.d/blacklist-intel-hid.conf`
   ```
   blacklist intel_hid
   ```

2. **GRUB config:** `/etc/default/grub`
   ```
   GRUB_CMDLINE_LINUX_DEFAULT="quiet splash resume=/dev/nvme0n1p3"
   ```

3. **Initramfs resume:** `/etc/initramfs-tools/conf.d/resume`
   ```
   RESUME=/dev/nvme0n1p3
   ```

4. **Commands to apply:**
   ```bash
   sudo update-initramfs -u -k all
   sudo update-grub
   sudo reboot
   ```

That's it! Nothing more, nothing less. Extra parameters like `no_console_suspend` will break resume.

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