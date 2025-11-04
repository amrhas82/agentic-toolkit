# Complete Linux ext4 Partition Recovery Guide

**A comprehensive guide to recovering deleted or corrupted partitions**

## ⚠️ CRITICAL: Read This First

**THE GOLDEN RULE: NEVER run fsck on a drive with deleted partitions until you've attempted recovery!**

What went wrong in this case:
1. ✅ Partition accidentally deleted during LVM setup
2. ✅ TestDisk found the partition structure  
3. ❌ **MISTAKE**: Ran `fsck` to "fix structure needs cleaning"
4. ❌ **FATAL**: fsck created a NEW empty filesystem, destroying all metadata
5. ❌ **RESULT**: Directory structure and filenames permanently lost

**If you run fsck before recovery, you'll destroy what you're trying to save.**

---

## Phase 0: Emergency Stop & Assessment (BEFORE doing anything)

### Immediate Actions

```bash
# 1. STOP using the drive immediately
# Don't write anything, don't mount, don't run fsck

# 2. Check if drive is still physically healthy
sudo smartctl -a /dev/sdX
# Look for: "SMART overall-health: PASSED"
# Check: "Media and Data Integrity Errors: 0"

# 3. Document current state
lsblk -f
sudo fdisk -l /dev/sdX
sudo parted /dev/sdX print

# 4. If unknown error mounting drive
sudo ntfsfix /dev/sda1

```

**RED FLAGS - Stop if you see:**
- SMART health: FAILED
- Reallocated sectors > 0
- Current pending sectors > 0
- Hardware errors in dmesg

### Assessment Questions

Before proceeding, answer:
1. **What happened?** (Accidental deletion, corruption, formatting?)
2. **When?** (5 minutes ago vs 5 days ago matters)
3. **What filesystem?** (ext4, NTFS, FAT32?)
4. **How critical is the data?** (If critical, consider professional recovery)
5. **Do you have space for a backup image?** (Minimum = partition size)

---

## Phase 1: Create Backup Image (MANDATORY)

**Never work on the original drive. Always work on a copy.**

### Create Full Disk Image

```bash
# Create backup of entire disk (safest, but slowest)
sudo dd if=/dev/sdX of=/path/to/external/backup.img bs=4M status=progress conv=noerror,sync

# OR backup just the affected partition
sudo dd if=/dev/sdX1 of=/path/to/external/partition_backup.img bs=4M status=progress conv=noerror,sync

# Verify backup was created
ls -lh /path/to/external/backup.img

# Create a loop device from backup for testing
sudo losetup -f --show /path/to/external/backup.img
# Note the loop device number (e.g., /dev/loop0)
```

**Why this matters:**
- You can try aggressive methods without fear
- If something fails, restore from backup
- Multiple recovery attempts possible

### If Space is Limited

```bash
# Compress on-the-fly (slower but saves space)
sudo dd if=/dev/sdX bs=4M status=progress | gzip > /path/backup.img.gz

# Or use ddrescue for damaged drives
sudo apt install gddrescue
sudo ddrescue -f /dev/sdX /path/backup.img /path/backup.log
```

---

## Phase 2: Diagnostic Commands

### Check Partition Table

```bash
# View current partition layout
lsblk -f
sudo fdisk -l /dev/sdX
sudo parted /dev/sdX print

# Check for GPT partition table
sudo gdisk -l /dev/sdX

# Look for partition signatures with hexdump
sudo hexdump -C /dev/sdX | grep "EFI PART" | head -5
sudo hexdump -C /dev/sdX | grep "55 aa" | head -5
```

**What to look for:**
- Missing partitions in lsblk output
- "Partition table entries are not in disk order"
- GPT header present but partitions missing

### Check for Filesystem Signatures

```bash
# Look for ext4 magic number (53 ef at offset 0x438)
sudo grep -abo $'\x53\xef' /dev/sdX | head -20

# Search for file signatures (proves data exists)
# ZIP files: 50 4b
# JPEG files: ff d8
# PDF files: 25 50 44 46
sudo hexdump -C /dev/sdX | grep "50 4b\|ff d8\|25 50 44 46" | head -20
```

**What this tells you:**
- If you find `53 ef`: ext4 filesystem exists
- If you find file signatures: Data blocks are intact
- If you find nothing: Might need deeper scan or data is overwritten

### Check Filesystem Health (ONLY if partition is visible)

```bash
# Check if superblock is readable (read-only check)
sudo dumpe2fs -h /dev/sdX1 | head -20

# Find alternate superblocks
sudo mke2fs -n /dev/sdX1

# List without modifying
sudo debugfs -R "ls -l" /dev/sdX1
```

**⚠️ WARNING: Do NOT run fsck yet!**

---

## Phase 3: TestDisk Recovery (Primary Method)

### Installing TestDisk

```bash
sudo apt update
sudo apt install testdisk
```

### Using TestDisk - Step by Step

```bash
# Run TestDisk on the BACKUP image (or original if no backup)
sudo testdisk /path/to/backup.img
# OR
sudo testdisk /dev/sdX
```

**TestDisk Workflow:**

1. **Create log file?**
   - Choose "Create" (useful for troubleshooting)

2. **Select disk type:**
   - Modern systems: "EFI GPT"
   - Older systems: "Intel/PC partition"
   - If unsure: "EFI GPT" for disks > 2TB, "Intel" for smaller

3. **Choose "Analyse"**
   - TestDisk will analyze current partition structure

4. **Choose "Quick Search"**
   - Scans for common partition locations (fast: 5-10 minutes)
   - Look for your missing partition in the list
   - Status indicators:
     - `*` = Bootable partition
     - `P` = Primary partition
     - `L` = Logical partition
     - `E` = Extended partition

5. **If Quick Search finds your partition:**
   - Use arrow keys to select it
   - Press `P` to preview files (VERY IMPORTANT - verify data!)
   - If files look correct, press `Enter` to continue
   - Choose "Write" to save partition table
   - Confirm with `Y`
   - Reboot or run `sudo partprobe /dev/sdX`

6. **If Quick Search doesn't find it:**
   - Choose "Deeper Search"
   - This scans the entire disk (slow: 30-60 minutes per 100GB)
   - More thorough, finds older deleted partitions

### TestDisk Advanced Options

```bash
# Within TestDisk, press 'A' for:
# - Advanced menu
# - List files
# - Undelete files
# - Copy files

# Geometry options (if TestDisk can't detect):
# - Usually auto-detect is correct
# - Only change if you know the exact CHS values
```

### Common TestDisk Results

**Scenario 1: Partition Found**
```
Disk /dev/sdX - 1000 GB
   Partition               Start        End      Size in sectors
>  Linux                  2048    195313663    195311616 [/data]
```
✅ Found! Preview files with `P`, then Write partition table

**Scenario 2: Multiple Partitions Found**
```
   Partition               Start        End      Size in sectors
   Linux                  2048    100000000     99997952 [old]
>  Linux              100000000    195313663     95313664 [/data]
```
✅ Select the correct one (check size, preview files)

**Scenario 3: No Partitions Found**
```
No partition found or selected for recovery
```
❌ Filesystem metadata likely destroyed - skip to Phase 6

---

## Phase 4: Manual Partition Table Reconstruction

**Use this if TestDisk fails but you know the partition layout.**

### Using fdisk

```bash
sudo fdisk /dev/sdX

# Commands within fdisk:
# n = new partition
# p = primary partition
# [partition number] = usually 1
# [first sector] = start location (if you know it)
# [last sector] = end location or size (+700G)
# w = write changes

# Example:
n
p
1
2048
+700G
w
```

### Using parted

```bash
sudo parted /dev/sdX

# Commands within parted:
(parted) mklabel gpt              # Create new GPT table (ONLY if needed)
(parted) mkpart primary ext4 0% 100%    # Create partition
(parted) print                    # Verify
(parted) quit
```

**⚠️ WARNING:**
- Only do this if you know EXACT partition boundaries
- Wrong boundaries = data misalignment = corruption
- TestDisk is safer

---

## Phase 5: Attempting Filesystem Recovery

**ONLY proceed here if:**
- Partition is visible in lsblk
- You can't mount it
- TestDisk didn't help

### Try Alternate Superblocks

```bash
# Find backup superblock locations
sudo mke2fs -n /dev/sdX1

# Example output:
# Superblock backups stored on blocks:
# 32768, 98304, 163840, 229376, 294912, ...

# Try mounting with alternate superblock (READ-ONLY first)
sudo mount -o ro,sb=32768 /dev/sdX1 /mnt/recovery
ls -la /mnt/recovery

# If that works, try repair with that superblock
sudo e2fsck -y -b 32768 /dev/sdX1

# Try each backup superblock until one works
sudo e2fsck -y -b 98304 /dev/sdX1
sudo e2fsck -y -b 163840 /dev/sdX1
```

### Using debugfs (Low-Level Exploration)

```bash
# Open filesystem in read-only mode
sudo debugfs -R "stats" /dev/sdX1

# List root directory
sudo debugfs -R "ls -l /" /dev/sdX1

# Navigate and explore
sudo debugfs /dev/sdX1
debugfs> ls
debugfs> cd /home
debugfs> ls -l
debugfs> quit
```

### Check for Journal

```bash
# Dump journal information
sudo dumpe2fs /dev/sdX1 | grep -i journal

# If journal exists, try journal-based recovery
sudo tune2fs -f -O ^has_journal /dev/sdX1  # Remove journal
sudo e2fsck -fy /dev/sdX1                   # Repair
sudo tune2fs -j /dev/sdX1                   # Re-add journal
```

---

## Phase 6: Advanced Recovery Tools

### extundelete (For Recently Deleted Files)

```bash
# Install
sudo apt install extundelete

# Restore all deleted files from last 24 hours
sudo extundelete /dev/sdX1 --restore-all

# Restore files after specific date
sudo extundelete /dev/sdX1 --restore-all --after $(date -d "2 days ago" +%s)

# Restore specific directory
sudo extundelete /dev/sdX1 --restore-directory /home/user/Documents
```

**When to use:**
- Partition is visible and mountable
- Files were deleted recently (within days/weeks)
- Filesystem structure is mostly intact

### ext4magic (For Corrupted Metadata)

```bash
# Install
sudo apt install ext4magic

# List recoverable files
sudo ext4magic /dev/sdX1 -f / -l

# Recover with structure
sudo ext4magic /dev/sdX1 -r -f / -a $(date -d "3 days ago" +%s) -d /mnt/recovery/
```

**When to use:**
- Filesystem metadata partially corrupted
- Need to recover directory structure
- Recent filesystem changes

### Sleuth Kit (Forensic Analysis)

```bash
# Install
sudo apt install sleuthkit

# Check filesystem type
sudo fsstat /dev/sdX1

# List files
sudo fls -r /dev/sdX1

# List inodes
sudo ils /dev/sdX1

# Extract specific inode
sudo icat /dev/sdX1 [inode_number] > recovered_file
```

**When to use:**
- Deep forensic analysis needed
- Other tools failed
- Need low-level inode access

---

## Phase 7: Last Resort - PhotoRec (File Carving)

**Use when filesystem structure is completely destroyed.**

### When to Use PhotoRec

Use PhotoRec if:
- ❌ TestDisk can't find partitions
- ❌ All superblocks are corrupted
- ❌ extundelete/ext4magic show "Bad magic number"
- ❌ Sleuth Kit shows "Cannot determine file system type"
- ✅ You found file signatures with hexdump

### Using PhotoRec

```bash
# Install (comes with testdisk)
sudo apt install testdisk

# Run PhotoRec
sudo photorec /dev/sdX

# PhotoRec Workflow:
# 1. Select the disk
# 2. Select partition or "Whole disk"
# 3. Select file system type (usually "Other" for ext4)
# 4. Choose where to save recovered files
# 5. Let it run (2-4 hours per 500GB)
```

**PhotoRec Output:**
- Files recovered to `recup_dir.1/`, `recup_dir.2/`, etc.
- Files named generically: `f0001234.jpg`, `f0005678.pdf`
- Organized by file type
- No original filenames or folder structure

### Post-PhotoRec Organization

```bash
# Count recovered files by type
cd /path/to/recovery/
find . -name "*.jpg" | wc -l
find . -name "*.pdf" | wc -l

# Organize by file type
mkdir -p sorted/{images,documents,archives,videos}
find . -name "*.jpg" -o -name "*.png" | xargs -I {} mv {} sorted/images/
find . -name "*.pdf" -o -name "*.docx" | xargs -I {} mv {} sorted/documents/
find . -name "*.zip" -o -name "*.tar" | xargs -I {} mv {} sorted/archives/
```

---

## Phase 8: What NOT To Do (Common Mistakes)

### ❌ NEVER Do These

1. **Running fsck on a deleted partition**
   ```bash
   # DON'T DO THIS:
   sudo fsck.ext4 -fy /dev/sdX1  # This will destroy metadata!
   ```
   - fsck assumes you want to FIX corruption
   - It will create a NEW filesystem if superblock is bad
   - This overwrites directory structure, filenames, inodes
   - **Always try TestDisk first**

2. **Writing to the drive**
   ```bash
   # DON'T DO THIS:
   sudo mkfs.ext4 /dev/sdX1      # Formats the partition
   sudo mount /dev/sdX1 /mnt     # Might trigger journal replay
   ```
   - Any write operation can overwrite recoverable data
   - Mount read-only if you must mount: `-o ro`

3. **Using the wrong offset**
   ```bash
   # DON'T DO THIS without verification:
   sudo losetup --offset 999999999 /dev/sdX  # Random offset
   ```
   - Wrong offset = wrong data interpretation
   - Always calculate or use TestDisk to find correct boundaries

4. **Skipping the backup**
   - "I'll just try one command" → disaster
   - Murphy's Law: If something can go wrong, it will
   - **Always backup first**

### ⚠️ Proceed with Caution

1. **Using alternate superblocks**
   - Test read-only first
   - Not all backup superblocks are guaranteed valid
   - Check multiple before committing

2. **Manual partition recreation**
   - One byte off = entire partition misaligned
   - Use TestDisk's calculations when possible

3. **Multiple recovery tools simultaneously**
   - Can cause conflicts
   - Finish with one tool before trying another

---

## Phase 9: Decision Tree (What To Do When)

```
START
  │
  ├─→ Can you see partition in lsblk?
  │   ├─→ YES: Go to Phase 5 (Filesystem Recovery)
  │   └─→ NO: Continue below
  │
  ├─→ Did you create a backup image?
  │   ├─→ YES: Continue on backup
  │   └─→ NO: Go to Phase 1 (Create Backup)
  │
  ├─→ Run TestDisk Quick Search (Phase 3)
  │   ├─→ Found partition?
  │   │   ├─→ YES: Preview files with 'P'
  │   │   │   ├─→ Files look good? Write partition table
  │   │   │   └─→ Files wrong/corrupt? Try Deeper Search
  │   │   └─→ NO: Continue below
  │   │
  │   └─→ Run TestDisk Deeper Search
  │       ├─→ Found partition? Write partition table
  │       └─→ NO: Continue below
  │
  ├─→ Check for filesystem signatures (Phase 2)
  │   ├─→ Found ext4 magic (53 ef)?
  │   │   ├─→ YES: Try Phase 5 (Alternate superblocks)
  │   │   └─→ NO: Continue below
  │   │
  │   └─→ Found file signatures (50 4b, ff d8)?
  │       ├─→ YES: Data exists, try Phase 6 tools
  │       └─→ NO: Data likely overwritten
  │
  ├─→ Try Advanced Recovery (Phase 6)
  │   ├─→ extundelete (if recent deletion)
  │   ├─→ ext4magic (if metadata corrupt)
  │   └─→ Sleuth Kit (forensic analysis)
  │
  ├─→ All tools show "Cannot determine filesystem"?
  │   ├─→ YES: Filesystem metadata destroyed
  │   │   └─→ Last resort: PhotoRec (Phase 7)
  │   └─→ NO: Keep trying Phase 6 tools
  │
  └─→ PhotoRec recovers files but no structure
      └─→ Manually organize recovered files
```

---

## Phase 10: Troubleshooting Common Errors

### "Bad magic number in super-block"

```bash
# What it means: Primary superblock is corrupted

# Solution 1: Try alternate superblocks
sudo mke2fs -n /dev/sdX1  # Find backup locations
sudo e2fsck -b 32768 /dev/sdX1

# Solution 2: Check if partition boundaries are wrong
sudo hexdump -C /dev/sdX1 | grep "53 ef" | head -5
```

### "Cannot determine file system type"

```bash
# What it means: No recognizable filesystem structure

# Solution 1: Verify you're accessing the right device
lsblk
sudo fdisk -l

# Solution 2: Check with hexdump if data exists
sudo dd if=/dev/sdX1 bs=1M count=100 | hexdump -C | grep "50 4b"

# Solution 3: If data exists but no filesystem, use PhotoRec
```

### "Structure needs cleaning"

```bash
# What it means: Filesystem journal has pending operations

# ⚠️ WRONG APPROACH (destroys data if partition was deleted):
# sudo fsck.ext4 -fy /dev/sdX1  # DON'T DO THIS

# ✅ CORRECT APPROACH:
# 1. First check if partition is actually correct
sudo dumpe2fs /dev/sdX1 | head -20

# 2. If it looks right, try read-only mount
sudo mount -o ro /dev/sdX1 /mnt

# 3. If mount works, data is safe - backup immediately
sudo rsync -av /mnt/ /backup/

# 4. Only then run fsck if needed
```

### "Input/output error"

```bash
# What it means: Hardware problem or severe corruption

# Solution 1: Check SMART status
sudo smartctl -a /dev/sdX

# Solution 2: Try ddrescue instead of dd
sudo ddrescue -f /dev/sdX /path/backup.img /path/backup.log

# Solution 3: If hardware is failing, consider professional recovery
```

### TestDisk shows wrong partition size

```bash
# What it means: Partition boundaries detected incorrectly

# Solution 1: Use "Deeper Search" instead of "Quick Search"

# Solution 2: Manually specify geometry (Advanced)
# - In TestDisk: Advanced > Geometry
# - Only change if you know exact values

# Solution 3: Check if multiple old partitions are being detected
# - Look for overlapping partition entries
# - Choose the most recent one
```

---

## Phase 11: Prevention & Best Practices

### Regular Backups

```bash
# Automated backup script
#!/bin/bash
DATE=$(date +%Y-%m-%d)
rsync -av --delete /home/user/ /backup/home-$DATE/

# Or use dedicated backup tools
sudo apt install timeshift        # System snapshots
sudo apt install duplicity        # Encrypted backups
sudo apt install rsnapshot        # Incremental backups
```

### Before Risky Operations

```bash
# Always backup before:
# - Resizing partitions
# - Installing new OS
# - Disk encryption
# - RAID operations
# - LVM setup

# Quick partition backup
sudo dd if=/dev/sdX1 of=/backup/sdX1.img bs=4M status=progress
```

### Monitoring Disk Health

```bash
# Install smartmontools
sudo apt install smartmontools

# Enable SMART monitoring
sudo systemctl enable smartd

# Regular checks
sudo smartctl -H /dev/sdX         # Quick health check
sudo smartctl -a /dev/sdX         # Full report
```

### Use Filesystem Features

```bash
# Enable ext4 metadata checksums (detects corruption)
sudo tune2fs -O metadata_csum /dev/sdX1

# Enable dir_index for faster recovery
sudo tune2fs -O dir_index /dev/sdX1

# Set reserved blocks for root (helps recovery)
sudo tune2fs -m 5 /dev/sdX1       # Reserve 5%
```

---

## Phase 12: When to Give Up / Seek Professional Help

### Consider Professional Recovery If:

1. **Data is mission-critical**
   - Business data
   - Irreplaceable personal files
   - Legal evidence

2. **Hardware failure**
   - SMART errors
   - Clicking sounds
   - Drive not detected

3. **Multiple failed recovery attempts**
   - Increased risk of further damage
   - Need specialized equipment

4. **Encrypted volumes**
   - LUKS/dm-crypt damaged
   - Lost encryption keys
   - Needs forensic analysis

### Professional Recovery Services

- **Ontrack**: Enterprise-grade recovery
- **DriveSavers**: High success rate
- **Kroll Ontrack**: Forensic subagents
- **Local data recovery labs**: Often cheaper

**Cost range:** $300 - $3000+ depending on complexity

---

## Quick Reference Command Cheat Sheet

```bash
# === ASSESSMENT ===
lsblk -f                          # View partition layout
sudo fdisk -l /dev/sdX            # Detailed partition info
sudo smartctl -a /dev/sdX         # Check disk health

# === BACKUP ===
sudo dd if=/dev/sdX of=backup.img bs=4M status=progress conv=noerror,sync

# === TESTDISK ===
sudo testdisk /dev/sdX            # Main recovery tool
# Navigate: Arrows, Enter, P=preview, Q=quit

# === FILESYSTEM CHECK ===
sudo dumpe2fs -h /dev/sdX1        # Check superblock
sudo mke2fs -n /dev/sdX1          # Find backup superblocks
sudo debugfs -R "ls" /dev/sdX1    # Explore filesystem

# === RECOVERY TOOLS ===
sudo extundelete /dev/sdX1 --restore-all
sudo ext4magic /dev/sdX1 -r -f /
sudo photorec /dev/sdX            # Last resort file carving

# === LOOP DEVICE (for images) ===
sudo losetup -f --show backup.img  # Mount image
sudo losetup -d /dev/loop0         # Unmount

# === MOUNT OPTIONS ===
sudo mount -o ro /dev/sdX1 /mnt   # Read-only (safe)
sudo mount -o ro,sb=32768 /dev/sdX1 /mnt  # Alt superblock
```

---

## Lessons Learned from This Case

### What Went Wrong

1. **Initial deletion**: LVM setup overwrote partition table
2. **TestDisk found the partition**: Data was recoverable
3. **Critical mistake**: Ran fsck to "fix structure needs cleaning"
4. **fsck destroyed metadata**: Created new empty filesystem on top
5. **Result**: Lost all filenames, folder structure, organization

### What Should Have Been Done

1. ✅ Stop immediately after LVM installation
2. ✅ Create full disk backup before ANY recovery attempts
3. ✅ Run TestDisk and preview files before writing
4. ✅ If "structure needs cleaning" → Mount read-only first
5. ✅ NEVER run fsck on a drive with missing partitions
6. ✅ Only after confirming partition structure → Consider filesystem repair

### Key Takeaways

- **Backup before recovery attempts** (cannot be emphasized enough)
- **TestDisk first, fsck NEVER (on deleted partitions)**
- **Preview before writing** (TestDisk's 'P' command)
- **Mount read-only to verify** before any repairs
- **One mistake can destroy everything** that was recoverable

---

## Conclusion

Partition recovery is possible if you:
1. Act quickly (before data is overwritten)
2. Don't panic and make things worse
3. Follow the correct order (TestDisk → Advanced tools → PhotoRec)
4. Never skip backups
5. Understand when to stop and seek professional help

**Remember: The worst thing you can do is rush and run destructive commands. Take your time, backup first, and follow this guide step by step.**

---

*This guide was created based on real recovery attempts. Always adapt to your specific situation and test on backups when possible.*
