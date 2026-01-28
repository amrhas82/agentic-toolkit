#!/bin/bash

# Clean Hibernation Script
# Disables problematic wakeup sources before hibernating

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
if [ "$EUID" -ne 0 ]; then
    print_error "This script must be run as root (use sudo)"
    exit 1
fi

print_info "Disabling wakeup sources for clean hibernation..."
echo ""

# Disable lid switch wakeup
if grep -q "LID0.*enabled" /proc/acpi/wakeup; then
    print_info "Disabling LID0 (laptop lid) wakeup..."
    echo LID0 > /proc/acpi/wakeup
    print_success "LID0 disabled"
else
    print_info "LID0 already disabled"
fi

# Disable power button wakeup
if grep -q "PBTN.*enabled" /proc/acpi/wakeup; then
    print_info "Disabling PBTN (power button) wakeup..."
    echo PBTN > /proc/acpi/wakeup
    print_success "PBTN disabled"
else
    print_info "PBTN already disabled"
fi

# Disable PCI Express wakeup sources
for device in RP05 RP12 RP13; do
    if grep -q "$device.*enabled" /proc/acpi/wakeup; then
        print_info "Disabling $device wakeup..."
        echo $device > /proc/acpi/wakeup
        print_success "$device disabled"
    fi
done

echo ""
print_info "Current wakeup status:"
grep -E "LID0|PBTN|RP05|RP12|RP13" /proc/acpi/wakeup
echo ""

print_success "Wakeup sources disabled. Initiating hibernation..."
echo ""

# Give a 3 second countdown
for i in 3 2 1; do
    echo "Hibernating in $i..."
    sleep 1
done

# Hibernate
systemctl hibernate
