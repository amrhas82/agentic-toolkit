#!/bin/bash

# Batch converter for remaining scripts from Debian/Ubuntu to Fedora

set -e

TOOLS_DIR="../tools"
OUTPUT_DIR="."

echo "Converting remaining scripts from $TOOLS_DIR to Fedora..."
echo ""

# List of scripts to convert
SCRIPTS=(
    "dev_tools_menu.sh"
    "master-ghostty.sh"
    "master-lazyvim.sh"
    "master_litexl_setup.sh"
    "master_neovim_setup.sh"
    "master_tmux_setup.sh"
)

convert_script() {
    local input_file="$1"
    local output_file="$2"

    echo "Converting: $(basename $input_file)"

    # Read the file and apply conversions
    sed \
        -e 's/apt update/dnf check-update/g' \
        -e 's/apt install -y/dnf install -y/g' \
        -e 's/apt install/dnf install/g' \
        -e 's/apt remove/dnf remove/g' \
        -e 's/apt-get update/dnf check-update/g' \
        -e 's/apt-get install -y/dnf install -y/g' \
        -e 's/apt-get install/dnf install/g' \
        -e 's/build-essential/@development-tools/g' \
        -e 's/python3-dev/python3-devel/g' \
        -e 's/libssl-dev/openssl-devel/g' \
        -e 's/lib\([a-z0-9]*\)-dev/\1-devel/g' \
        -e 's/# This script is designed for Ubuntu\/Debian/# This script is designed for Fedora/g' \
        -e 's/Ubuntu\/Debian/Fedora/g' \
        -e 's/ubuntu\/debian/fedora/g' \
        "$input_file" > "$output_file"

    # Make executable if original was executable
    if [[ -x "$input_file" ]]; then
        chmod +x "$output_file"
    fi

    echo "  ✓ Created: $output_file"
}

# Convert each script
for script in "${SCRIPTS[@]}"; do
    input="$TOOLS_DIR/$script"
    output="$OUTPUT_DIR/$script"

    if [[ -f "$input" ]]; then
        convert_script "$input" "$output"
    else
        echo "  ⚠ Skipped: $script (not found)"
    fi
done

echo ""
echo "Conversion complete!"
echo ""
echo "Converted scripts:"
ls -lh *.sh | grep -v convert_remaining.sh
echo ""
echo "⚠️  IMPORTANT: Review the converted scripts before running them!"
echo "    Some package names may need manual adjustment."
