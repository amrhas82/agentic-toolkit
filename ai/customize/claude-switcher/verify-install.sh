#!/bin/bash
# Claude Model Switcher - Installation Verification
# Tests if all commands are properly installed and working

set -e

CLAUDE_DIR="$HOME/.claude"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_info() {
    echo -e "${BLUE}💡 $1${NC}"
}

echo -e "${BLUE}====================================${NC}"
echo -e "${BLUE}  Claude Switcher - Verification   ${NC}"
echo -e "${BLUE}====================================${NC}"
echo ""

# Check 1: Directory exists
if [ -d "$CLAUDE_DIR" ]; then
    print_success "Claude directory exists: $CLAUDE_DIR"
else
    print_error "Claude directory NOT found: $CLAUDE_DIR"
    exit 1
fi

# Check 2: Scripts exist
if [ -f "$CLAUDE_DIR/switch-model-enhanced.sh" ]; then
    print_success "Enhanced script exists"
else
    print_error "Enhanced script NOT found"
    exit 1
fi

# Check 3: Scripts are executable
if [ -x "$CLAUDE_DIR/switch-model-enhanced.sh" ]; then
    print_success "Enhanced script is executable"
else
    print_warning "Enhanced script is not executable"
    chmod +x "$CLAUDE_DIR/switch-model-enhanced.sh"
    print_success "Made script executable"
fi

# Check 4: Aliases file exists
if [ -f "$CLAUDE_DIR/aliases.sh" ]; then
    print_success "Aliases file exists"
else
    print_error "Aliases file NOT found"
    exit 1
fi

# Check 5: Check if aliases are sourced in bashrc
if grep -q "source.*\.claude/aliases\.sh" "$HOME/.bashrc" 2>/dev/null; then
    print_success "Aliases sourced in ~/.bashrc"
elif grep -q "source.*\.claude/aliases\.sh" "$HOME/.zshrc" 2>/dev/null; then
    print_success "Aliases sourced in ~/.zshrc"
else
    print_warning "Aliases NOT sourced in shell config"
    echo ""
    print_info "Adding to ~/.bashrc..."
    echo "" >> "$HOME/.bashrc"
    echo "# Claude Model Switcher aliases" >> "$HOME/.bashrc"
    echo "source ~/.claude/aliases.sh" >> "$HOME/.bashrc"
    print_success "Added to ~/.bashrc"
fi

# Check 6: Test if new commands exist in aliases
if grep -q "cc-status" "$CLAUDE_DIR/aliases.sh"; then
    print_success "New commands (cc-*) found in aliases"
else
    print_error "New commands NOT found in aliases"
    print_info "Copying updated aliases from project..."
    cp "$PROJECT_DIR/aliases.sh" "$CLAUDE_DIR/aliases.sh"
    print_success "Aliases updated"
fi

# Check 7: Test script execution
echo ""
print_info "Testing script execution..."
if bash "$CLAUDE_DIR/switch-model-enhanced.sh" cc-status >/dev/null 2>&1; then
    print_success "Script executes successfully"
else
    print_error "Script execution failed"
    exit 1
fi

echo ""
echo -e "${GREEN}====================================${NC}"
echo -e "${GREEN}  ✅ Installation Verified!         ${NC}"
echo -e "${GREEN}====================================${NC}"
echo ""
echo -e "${BLUE}To activate the commands in your current shell:${NC}"
echo -e "  ${YELLOW}source ~/.bashrc${NC}"
echo ""
echo -e "${BLUE}Or open a new terminal window.${NC}"
echo ""
echo -e "${BLUE}Available commands:${NC}"
echo "  cc-status       - Show current configuration"
echo "  cc-native       - Switch to native Claude"
echo "  cc-mixed        - Switch to mixed mode"
echo "  cc-glm          - Switch to GLM models"
echo "  fast-cc         - Quick Claude mode"
echo "  fast-glm        - Quick GLM mode"
echo "  claude-switch   - Interactive model switcher"
echo ""
echo -e "${BLUE}Test a command:${NC}"
echo -e "  ${YELLOW}bash ~/.claude/switch-model-enhanced.sh cc-status${NC}"
echo ""
