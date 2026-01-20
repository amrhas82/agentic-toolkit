#!/bin/bash
# Simple theme switcher for Kitty (works without themes kitten)

THEME_DIR="$HOME/.config/kitty/themes"
CONFIG="$HOME/.config/kitty/kitty.conf"

# List available themes
echo "Available themes:"
echo "================="
ls -1 "$THEME_DIR" | nl
echo ""
echo "Current: Catppuccin Frappe (built-in)"
echo ""
read -p "Enter theme number (or 0 for built-in Catppuccin): " choice

if [ "$choice" = "0" ]; then
    echo "Keeping Catppuccin Frappe theme"
    exit 0
fi

theme_file=$(ls -1 "$THEME_DIR" | sed -n "${choice}p")

if [ -z "$theme_file" ]; then
    echo "Invalid selection"
    exit 1
fi

echo "To apply theme '$theme_file', add this line after the theme section in kitty.conf:"
echo ""
echo "include themes/$theme_file"
echo ""
echo "Then reload with: Ctrl+S > R or press F5"
