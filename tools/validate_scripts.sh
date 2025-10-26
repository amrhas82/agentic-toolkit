#!/bin/bash

# Script Validation Tool
# Tests that both master scripts work independently and have correct structure

set -e

echo "================================================"
echo "  Script Validation Tool"
echo "================================================"
echo ""

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PASSED=0
FAILED=0

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_test() {
    echo -e "${BLUE}TEST:${NC} $1"
}

print_pass() {
    echo -e "${GREEN}✓ PASS:${NC} $1"
    ((PASSED++))
}

print_fail() {
    echo -e "${RED}✗ FAIL:${NC} $1"
    ((FAILED++))
}

# Test 1: Check if scripts exist
print_test "Checking if master scripts exist..."
if [ -f "$SCRIPT_DIR/master_tmux_setup.sh" ]; then
    print_pass "master_tmux_setup.sh exists"
else
    print_fail "master_tmux_setup.sh not found"
fi

if [ -f "$SCRIPT_DIR/master_neovim_setup.sh" ]; then
    print_pass "master_neovim_setup.sh exists"
else
    print_fail "master_neovim_setup.sh not found"
fi

# Test 2: Check if scripts are executable
print_test "Checking if scripts are executable..."
if [ -x "$SCRIPT_DIR/master_tmux_setup.sh" ]; then
    print_pass "master_tmux_setup.sh is executable"
else
    print_fail "master_tmux_setup.sh is not executable"
fi

if [ -x "$SCRIPT_DIR/master_neovim_setup.sh" ]; then
    print_pass "master_neovim_setup.sh is executable"
else
    print_fail "master_neovim_setup.sh is not executable"
fi

# Test 3: Check bash syntax
print_test "Validating bash syntax..."
if bash -n "$SCRIPT_DIR/master_tmux_setup.sh" 2>/dev/null; then
    print_pass "master_tmux_setup.sh syntax is valid"
else
    print_fail "master_tmux_setup.sh has syntax errors"
fi

if bash -n "$SCRIPT_DIR/master_neovim_setup.sh" 2>/dev/null; then
    print_pass "master_neovim_setup.sh syntax is valid"
else
    print_fail "master_neovim_setup.sh has syntax errors"
fi

# Test 4: Check script headers
print_test "Checking script headers and descriptions..."
if grep -q "Tmux + TPM Complete Setup Script" "$SCRIPT_DIR/master_tmux_setup.sh"; then
    print_pass "master_tmux_setup.sh has correct header"
else
    print_fail "master_tmux_setup.sh header incorrect"
fi

if grep -q "Neovim + NvimTree Complete Setup Script" "$SCRIPT_DIR/master_neovim_setup.sh"; then
    print_pass "master_neovim_setup.sh has correct header"
else
    print_fail "master_neovim_setup.sh header incorrect"
fi

# Test 5: Check for key components in Tmux script
print_test "Checking Tmux script components..."
TMUX_COMPONENTS=(
    "libevent-dev"
    "tmux.git"
    "autogen.sh"
    "tpm"
    "~/.tmux.conf"
    "catppuccin"
    "vim-tmux-navigator"
)

for component in "${TMUX_COMPONENTS[@]}"; do
    if grep -q "$component" "$SCRIPT_DIR/master_tmux_setup.sh"; then
        print_pass "Tmux script contains: $component"
    else
        print_fail "Tmux script missing: $component"
    fi
done

# Test 6: Check for key components in Neovim script
print_test "Checking Neovim script components..."
NVIM_COMPONENTS=(
    "neovim.git"
    "nvim-tree"
    "lazygit"
    "vim-plug"
    "init.vim"
    "tokyonight"
    "telescope"
    "treesitter"
)

for component in "${NVIM_COMPONENTS[@]}"; do
    if grep -q "$component" "$SCRIPT_DIR/master_neovim_setup.sh"; then
        print_pass "Neovim script contains: $component"
    else
        print_fail "Neovim script missing: $component"
    fi
done

# Test 7: Verify scripts are independent (no cross-references)
print_test "Checking script independence..."
if ! grep -q "PART 1" "$SCRIPT_DIR/master_tmux_setup.sh" && ! grep -q "PART 2" "$SCRIPT_DIR/master_tmux_setup.sh"; then
    if grep -q "Tmux" "$SCRIPT_DIR/master_tmux_setup.sh" && ! grep -q "PART 1: Setting up Neovim" "$SCRIPT_DIR/master_tmux_setup.sh"; then
        print_pass "master_tmux_setup.sh is standalone (no Neovim code)"
    else
        print_fail "master_tmux_setup.sh contains Neovim code"
    fi
else
    print_fail "master_tmux_setup.sh still has PART 1/2 structure"
fi

if ! grep -q "PART 2: Setting up Tmux" "$SCRIPT_DIR/master_neovim_setup.sh"; then
    if grep -q "Neovim" "$SCRIPT_DIR/master_neovim_setup.sh"; then
        print_pass "master_neovim_setup.sh is standalone (no Tmux code)"
    else
        print_fail "master_neovim_setup.sh contains Tmux code"
    fi
else
    print_fail "master_neovim_setup.sh still has PART 2 (Tmux) code"
fi

# Test 8: Check menu integration
print_test "Checking menu script integration..."
if [ -f "$SCRIPT_DIR/dev_tools_menu.sh" ]; then
    print_pass "dev_tools_menu.sh exists"

    if grep -q "master_tmux_setup.sh" "$SCRIPT_DIR/dev_tools_menu.sh"; then
        print_pass "Menu references master_tmux_setup.sh"
    else
        print_fail "Menu doesn't reference master_tmux_setup.sh"
    fi

    if grep -q "master_neovim_setup.sh" "$SCRIPT_DIR/dev_tools_menu.sh"; then
        print_pass "Menu references master_neovim_setup.sh"
    else
        print_fail "Menu doesn't reference master_neovim_setup.sh"
    fi
else
    print_fail "dev_tools_menu.sh not found"
fi

# Summary
echo ""
echo "================================================"
echo "  Validation Summary"
echo "================================================"
echo -e "${GREEN}Passed: $PASSED${NC}"
echo -e "${RED}Failed: $FAILED${NC}"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✓ All validations passed!${NC}"
    echo ""
    echo "Scripts are ready to use:"
    echo "  • Option #3 (Tmux + TPM): master_tmux_setup.sh"
    echo "  • Option #4 (Neovim + NvimTree): master_neovim_setup.sh"
    echo ""
    exit 0
else
    echo -e "${RED}✗ Some validations failed. Please review.${NC}"
    echo ""
    exit 1
fi
