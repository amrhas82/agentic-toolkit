#!/bin/bash

# Hibernation Setup Script for Fedora
# Configures GRUB and dracut to enable hibernation/resume from swap partition

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    print_error "Please do not run this script as root. It will use sudo when needed."
    exit 1
fi

# Detect swap partition
print_info "Detecting swap partition..."
SWAP_DEVICE=$(swapon --show --noheadings | grep nvme | awk '{print $1}' | head -n 1)

if [ -z "$SWAP_DEVICE" ]; then
    print_error "No swap partition found on NVMe device"
    print_info "Current swap devices:"
    swapon --show
    exit 1
fi

print_success "Found swap partition: $SWAP_DEVICE"
echo ""

# Display current GRUB config
print_info "Current GRUB configuration:"
grep "GRUB_CMDLINE_LINUX=" /etc/default/grub
echo ""

# Check if resume parameter already exists
if grep -q "resume=" /etc/default/grub; then
    print_warning "Resume parameter already exists in GRUB config"
    read -p "Do you want to continue and update it? (y/N): " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "Exiting..."
        exit 0
    fi
fi

# Ask for confirmation
echo ""
print_warning "This script will:"
echo "  1. Add 'resume=$SWAP_DEVICE' to GRUB configuration"
echo "  2. Configure dracut to include resume module"
echo "  3. Rebuild initramfs"
echo "  4. Update GRUB configuration"
echo ""
read -p "Do you want to continue? (y/N): " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_info "Installation cancelled."
    exit 0
fi

echo ""
print_info "Starting hibernation setup..."
echo ""

# Step 1: Backup GRUB config
print_info "Backing up GRUB configuration..."
sudo cp /etc/default/grub /etc/default/grub.backup
print_success "Backup created: /etc/default/grub.backup"

# Step 2: Update GRUB config
print_info "Updating GRUB configuration..."

# Check if resume parameter exists
if grep -q "resume=" /etc/default/grub; then
    # Update existing resume parameter
    sudo sed -i "s|resume=[^ \"]*|resume=$SWAP_DEVICE|g" /etc/default/grub
else
    # Add new resume parameter
    sudo sed -i "/^GRUB_CMDLINE_LINUX=/ s/\"\(.*\)\"/\"resume=$SWAP_DEVICE \1\"/" /etc/default/grub
fi

print_success "GRUB configuration updated"
print_info "New GRUB configuration:"
grep "GRUB_CMDLINE_LINUX=" /etc/default/grub
echo ""

# Step 3: Configure dracut
print_info "Configuring dracut to include resume module..."
echo 'add_dracutmodules+=" resume "' | sudo tee /etc/dracut.conf.d/resume.conf > /dev/null
print_success "Dracut configuration created: /etc/dracut.conf.d/resume.conf"

# Step 4: Rebuild initramfs
print_info "Rebuilding initramfs (this may take a minute)..."
sudo dracut -f
print_success "Initramfs rebuilt successfully"

# Step 5: Update GRUB
print_info "Updating GRUB bootloader configuration..."
sudo grub2-mkconfig -o /boot/grub2/grub.cfg > /dev/null 2>&1
print_success "GRUB configuration updated"

echo ""
print_success "Hibernation setup completed successfully!"
echo ""
print_warning "Next steps:"
echo "  1. Reboot your system: sudo reboot"
echo "  2. After reboot, test hibernation: sudo systemctl hibernate"
echo "  3. Your system should hibernate and resume from $SWAP_DEVICE"
echo ""
print_info "To verify after reboot, check kernel parameters:"
echo "  cat /proc/cmdline | grep resume"
echo ""
