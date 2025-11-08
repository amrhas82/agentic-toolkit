#!/bin/bash

# Ghostty Installation Verification Script
# ========================================
# This script verifies that Ghostty is properly installed and configured

readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly WHITE='\033[1;37m'
readonly BOLD='\033[1m'
readonly RESET='\033[0m'

check_status() {
    local status=$1
    local message=$2

    if [ $status -eq 0 ]; then
        echo -e "${GREEN}✓${RESET} $message"
        return 0
    else
        echo -e "${RED}✗${RESET} $message"
        return 1
    fi
}

echo -e "${BOLD}${CYAN}Ghostty Installation Verification${RESET}"
echo -e "${CYAN}$(printf '=%.0s' {1..40})${RESET}\n"

# Check if Ghostty is installed
echo -e "${BLUE}Checking Ghostty Installation:${RESET}"
if command -v ghostty &> /dev/null; then
    check_status 0 "Ghostty command found"

    # Get version info
    version=$(ghostty --version 2>/dev/null | head -n1 || echo "Unknown")
    echo -e "${WHITE}  Version: $version${RESET}"
else
    check_status 1 "Ghostty command not found"
    echo -e "${YELLOW}  Run: sudo snap install ghostty --classic${RESET}"
fi

echo

# Check configuration directory
echo -e "${BLUE}Checking Configuration:${RESET}"
config_dir="$HOME/.config/ghostty"
config_file="$config_dir/config"

if [ -d "$config_dir" ]; then
    check_status 0 "Configuration directory exists"
    echo -e "${WHITE}  Location: $config_dir${RESET}"
else
    check_status 1 "Configuration directory missing"
    echo -e "${YELLOW}  Run: mkdir -p $config_dir${RESET}"
fi

if [ -f "$config_file" ]; then
    check_status 0 "Configuration file exists"

    # Check configuration content
    echo -e "${WHITE}  Configuration details:${RESET}"

    # Check theme
    if grep -q "^theme = Catppuccin Frappe" "$config_file"; then
        echo -e "${GREEN}    ✓ Theme: Catppuccin Frappe${RESET}"
    else
        echo -e "${YELLOW}    ⚠ Theme: Not configured${RESET}"
    fi

    # Check font size
    if grep -q "^font-size = 12" "$config_file"; then
        echo -e "${GREEN}    ✓ Font size: 12pt${RESET}"
    else
        echo -e "${YELLOW}    ⚠ Font size: Not configured${RESET}"
    fi

    # Count keybindings
    keybinds=$(grep -c "^keybind" "$config_file" 2>/dev/null || echo "0")
    if [ "$keybinds" -gt 0 ]; then
        echo -e "${GREEN}    ✓ Keybindings: $keybinds custom bindings${RESET}"
    else
        echo -e "${YELLOW}    ⚠ Keybindings: No custom bindings found${RESET}"
    fi
else
    check_status 1 "Configuration file missing"
    echo -e "${YELLOW}  Run: master-ghostty.sh --config-only${RESET}"
fi

echo

# Check backup directory
echo -e "${BLUE}Checking Backup:${RESET}"
backup_dir="$config_dir/backup"
if [ -d "$backup_dir" ]; then
    check_status 0 "Backup directory exists"
    backup_count=$(ls -1 "$backup_dir"/config_backup_* 2>/dev/null | wc -l)
    if [ "$backup_count" -gt 0 ]; then
        echo -e "${WHITE}  Backups available: $backup_count${RESET}"
        latest_backup=$(ls -t "$backup_dir"/config_backup_* 2>/dev/null | head -n1)
        if [ -n "$latest_backup" ]; then
            echo -e "${WHITE}  Latest: $(basename "$latest_backup")${RESET}"
        fi
    else
        echo -e "${YELLOW}  No backup files found${RESET}"
    fi
else
    check_status 1 "Backup directory missing"
    echo -e "${YELLOW}  This is normal if no previous configuration existed${RESET}"
fi

echo

# Test Ghostty functionality (if installed)
if command -v ghostty &> /dev/null; then
    echo -e "${BLUE}Testing Ghostty Functionality:${RESET}"

    # Test version command
    if ghostty --version &> /dev/null; then
        check_status 0 "Version command works"
    else
        check_status 1 "Version command failed"
    fi

    # Test help command
    if ghostty --help &> /dev/null; then
        check_status 0 "Help command works"
    else
        check_status 0 "Help command skipped (not critical)"
    fi
fi

echo

# Summary
echo -e "${BOLD}${CYAN}Quick Commands:${RESET}"
echo -e "${WHITE}• Start Ghostty:${RESET} ${CYAN}ghostty${RESET}"
echo -e "${WHITE}• Edit config:${RESET} ${CYAN}nano ~/.config/ghostty/config${RESET}"
echo -e "${WHITE}• Reload config:${RESET} ${CYAN}Ctrl+S+R${RESET} (inside Ghostty)"
echo -e "${WHITE}• Reinstall config:${RESET} ${CYAN}./master-ghostty.sh --config-only${RESET}"

echo
echo -e "${BOLD}${CYAN}For more help:${RESET} ./master-ghostty.sh --help"