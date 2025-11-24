# Clonezilla & Zorin OS Partitioning Guide

## Table of Contents
1. [Recommended Partition Layout](#recommended-partition-layout)
2. [Essential Disk Commands](#essential-disk-commands)
3. [Cloning a Partition (Backup)](#cloning-a-partition-backup)
4. [Restoring a Partition](#restoring-a-partition)
5. [Data Recovery](#data-recovery)

---

## Recommended Partition Layout

### For 1TB Drive (NVMe)

| Partition | Size | Type | Mount Point | Device |
|-----------|------|------|-------------|---------|
| EFI System | 512 MB | Primary | /boot/EFI | nvme0n1p1 |
| Boot | 1024 MB | Primary | /boot | nvme0n1p2 |
| Swap | 8 GB | Primary | swap | nvme0n1p3 |
| Root | 250 GB | Primary | / | nvme0n1p4 |
| Home | 150 GB | Primary | /home | nvme0n1p5 |
| Extra Storage | ~587 GB | Primary | /stuff | nvme0n1p6 |

*Note: The /stuff partition can grow as needed with remaining space*

---

## Essential Disk Commands

### View All Drives
```bash
sudo fdisk -l
```
Displays all physical drives and their partitions.

### View Mounted Drives
```bash
df -h
```
Shows all currently mounted drives with human-readable sizes.

### View Drive Tree Structure
```bash
lsblk
```
Displays disk drives in a tree format showing partition relationships.

### View All Mounted Drives with UUID
```bash
cat /etc/fstab
```
Shows all mounted drives along with their UUID identifiers.

### Find Media Drives
```bash
find /media
```
Lists all mounted media drives (useful for finding USB drives).

---

## Cloning a Partition (Backup)

### Prerequisites
- Bootable Clonezilla USB drive
- Destination drive for backup image (e.g., external USB)

### Step-by-Step Process

1. **Boot from Clonezilla USB**
   - Select `Clonezilla live`
   - Choose language (English)
   - Select keyboard layout
   - Click `Start Clonezilla`

2. **Initial Setup**
   - Choose `device_image`
   - Choose `local_dev`
   - Select destination drive for saving image (e.g., sda3)
   - Skip checking file system (saves time)

3. **Configure Backup Location**
   - Navigate to and select the desired folder (e.g., `/backup`)
   - Choose `Expert mode`

4. **Select Clone Type**
   - Choose `save_parts` (for partition cloning)

5. **Name Your Image**
   - Enter descriptive name for the partition:
     - EFI: `/dev/nvme0n1p1`
     - Boot: `/dev/nvme0n1p2`
     - Root: `/dev/nvme0n1p4`
     - Home: `/dev/nvme0n1p5`

6. **Source Selection**
   - Choose `disk_or_part`
   - Select source partition to clone (e.g., nvme0n1p1)

7. **Compression Settings**
   - Choose `partclone` (recommended)
   - Select compression type:
     - **z1 (gzip)**: Reliable, suitable for most scenarios
     - **Parallel compression**: Faster, ideal for large files
   - Choose `0` to not split image into parts
   - Skip checking available disk space

8. **Verification & Encryption**
   - Choose `Yes` to check saved image (recommended)
   - Choose not to encrypt (unless needed)

9. **Complete**
   - Select action after cloning (shutdown, reboot, etc.)

---

## Restoring a Partition

### Prerequisites
- Bootable Clonezilla USB drive
- Previously created backup image

### Step-by-Step Process

1. **Boot from Clonezilla USB**
   - Select `Clonezilla live`
   - Choose language (English)
   - Select keyboard layout
   - Click `Start Clonezilla`

2. **Initial Setup**
   - Choose `device_image`
   - Choose `local_dev`
   - Select drive where backup image is stored (e.g., sda3)
   - Skip checking file system (saves time)

3. **Locate Backup**
   - Navigate to and select the backup folder (e.g., `/backup`)
   - Choose `Expert mode`

4. **Select Restore Type**
   - Choose `restore_parts` (for partition restoring)

5. **Select Image**
   - Select the image to restore:
     - EFI: `/dev/nvme0n1p1`
     - Boot: `/dev/nvme0n1p2`
     - Root: `/dev/nvme0n1p4`
     - Home: `/dev/nvme0n1p5`

6. **Destination Selection**
   - Choose `disk or partition` to restore to
   - Select destination partition (e.g., nvme0n1p1)

7. **Restore Settings**
   - Leave/choose parameters (use defaults)
   - Choose `do not create partition table` (default)
   - Choose `Yes` to check saved image

8. **Complete**
   - Select action after restoration (shutdown, reboot, etc.)

---

## Data Recovery

If you need to recover deleted data from a partition:

### Install TestDisk
```bash
sudo apt install testdisk
```

### Run TestDisk
```bash
sudo testdisk
```

Follow the on-screen prompts to scan for and recover deleted files.

---

## Additional Tips

### Before Partitioning
- Always backup important data
- Write down your partition scheme
- Have a live USB of Zorin OS ready

### After Fresh Install
- Update GRUB if dual-booting:
  ```bash
  sudo update-grub
  ```
- Check mounted partitions:
  ```bash
  df -h
  ```
- Verify boot configuration:
  ```bash
  sudo gedit /etc/default/grub
  ```

### Best Practices
- Clone critical partitions (EFI, Boot, Root) before major changes
- Keep backups on external drives, not the same disk
- Test restore process to ensure backups are valid
- Document your partition UUIDs for troubleshooting

---

*Last Updated: October 2025*