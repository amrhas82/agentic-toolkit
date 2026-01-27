#!/bin/bash
# Lite XL Installation Script with SDL3 and Markdown Preview
# For Fedora-based systems

set -e  # Exit on any error

echo "================================"
echo "Lite XL Installation Script"
echo "================================"
echo ""

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

print_info() {
    echo -e "${YELLOW}[i]${NC} $1"
}

# Check if running on Fedora
if ! command -v apt-get &> /dev/null; then
    print_error "This script requires apt-get (Fedora-based system)"
    exit 1
fi

print_info "Checking system requirements..."

# Install base dependencies
print_info "Installing base dependencies..."
sudo dnf check-update
sudo dnf install -y @development-tools git ninja-build sdl2-devel \
    freetype6-devel python3-pip cmake

print_status "Base dependencies installed"

# Remove old meson if exists
if command -v meson &> /dev/null; then
    OLD_MESON_VERSION=$(meson --version)
    print_info "Found existing meson version: $OLD_MESON_VERSION"
    sudo apt-get remove -y meson 2>/dev/null || true
fi

# Install newer meson via pip
print_info "Installing Meson build system..."
pip3 install --user --upgrade meson

# Add pip bin to PATH
export PATH="$HOME/.local/bin:$PATH"

# Verify meson version
MESON_VERSION=$(~/.local/bin/meson --version)
print_status "Meson $MESON_VERSION installed"

if [ "$(printf '%s\n' "0.63" "$MESON_VERSION" | sort -V | head -n1)" != "0.63" ]; then
    print_error "Meson version must be >= 0.63, got $MESON_VERSION"
    exit 1
fi

# Build and install SDL3
print_info "Building SDL3 from source..."
cd ~
if [ -d "SDL" ]; then
    print_info "Removing existing SDL directory..."
    rm -rf SDL
fi

git clone https://github.com/libsdl-org/SDL.git
cd SDL
git checkout release-3.2.0

mkdir -p build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j$(nproc)
sudo make install
sudo ldconfig

print_status "SDL3 installed successfully"

# Clone and build Lite XL
print_info "Cloning Lite XL repository..."
cd ~
if [ -d "lite-xl" ]; then
    print_info "Removing existing lite-xl directory..."
    rm -rf lite-xl
fi

git clone https://github.com/lite-xl/lite-xl.git
cd lite-xl

print_info "Building Lite XL..."
~/.local/bin/meson setup build --buildtype=release
~/.local/bin/meson compile -C build

# Manual installation
print_info "Installing Lite XL..."
sudo cp build/src/lite-xl /usr/local/bin/
sudo mkdir -p /usr/local/share/lite-xl
sudo cp -r data/* /usr/local/share/lite-xl/
sudo chmod +x /usr/local/bin/lite-xl

print_status "Lite XL installed to /usr/local/bin/lite-xl"

# Verify installation
if ! command -v lite-xl &> /dev/null; then
    print_error "Installation verification failed"
    exit 1
fi

LITEXL_VERSION=$(lite-xl --version 2>&1 | head -n1 || echo "unknown")
print_status "Lite XL version: $LITEXL_VERSION"

# Install markdown preview plugin
print_info "Installing markdown preview plugin..."
mkdir -p ~/.config/lite-xl/plugins

cat > ~/.config/lite-xl/plugins/markdown_preview.lua << 'EOF'
-- mod-version:3
local core = require "core"
local command = require "core.command"
local keymap = require "core.keymap"
local DocView = require "core.docview"
local Doc = require "core.doc"

local function render_markdown(text)
  local lines = {}
  local in_code_block = false
  
  for line in (text .. "\n"):gmatch("([^\n]*)\n") do
    if line:match("^```") then
      in_code_block = not in_code_block
      table.insert(lines, "")
      goto continue
    end
    
    if in_code_block then
      table.insert(lines, "    " .. line)
      goto continue
    end
    
    local h1 = line:match("^# (.+)")
    if h1 then
      table.insert(lines, "")
      table.insert(lines, string.upper(h1))
      table.insert(lines, string.rep("=", #h1))
      table.insert(lines, "")
      goto continue
    end
    
    local h2 = line:match("^## (.+)")
    if h2 then
      table.insert(lines, "")
      table.insert(lines, h2)
      table.insert(lines, string.rep("-", #h2))
      table.insert(lines, "")
      goto continue
    end
    
    local h3 = line:match("^### (.+)")
    if h3 then
      table.insert(lines, "")
      table.insert(lines, ">> " .. h3)
      table.insert(lines, "")
      goto continue
    end
    
    line = line:gsub("^%* (.+)", "  • %1")
    line = line:gsub("^%- (.+)", "  • %1")
    line = line:gsub("^(%d+)%. (.+)", "  %1. %2")
    line = line:gsub("%*%*(.-)%*%*", "【%1】")
    line = line:gsub("__(.-)__", "【%1】")
    line = line:gsub("%*(.-)%*", "‹%1›")
    line = line:gsub("_(.-)_", "‹%1›")
    line = line:gsub("`([^`]+)`", "[%1]")
    line = line:gsub("%[(.-)%]%((.-)%)", "%1 (%2)")
    line = line:gsub("^> (.+)", "│ %1")
    
    if line:match("^%-%-%-+") or line:match("^%*%*%*+") then
      line = string.rep("-", 60)
    end
    
    table.insert(lines, line)
    ::continue::
  end
  
  return table.concat(lines, "\n")
end

command.add("core.docview", {
  ["markdown-preview:show"] = function()
    local av = core.active_view
    if av:is(DocView) and av.doc.filename and av.doc.filename:match("%.md$") then
      local text = av.doc:get_text(1, 1, math.huge, math.huge)
      local rendered = render_markdown(text)
      
      local doc = Doc()
      doc:insert(1, 1, rendered)
      local filename = av.doc.filename:match("([^/\\]+)$") or "preview"
      doc:set_filename(filename .. " [Preview]")
      
      local node = core.root_view:get_active_node()
      node:split("right")
      core.root_view:open_doc(doc)
      
      core.log("Markdown preview opened")
    else
      core.error("Not a markdown file")
    end
  end,
})

keymap.add {
  ["ctrl+shift+m"] = "markdown-preview:show"
}
EOF

if [ -f ~/.config/lite-xl/plugins/markdown_preview.lua ]; then
    print_status "Markdown preview plugin installed"
else
    print_error "Failed to install markdown preview plugin"
fi

# Add PATH to bashrc if not already there
if ! grep -q '.local/bin' ~/.bashrc; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    print_status "Added ~/.local/bin to PATH in ~/.bashrc"
fi

echo ""
echo "================================"
print_status "Installation complete!"
echo "================================"
echo ""
echo "You can now run 'lite-xl' from the terminal"
echo ""
echo "Markdown preview:"
echo "  - Open a .md file in Lite XL"
echo "  - Press Ctrl+Shift+M for preview"
echo "  - Or use Ctrl+Shift+P and type 'markdown-preview:show'"
echo ""
print_info "Note: You may need to restart your terminal or run:"
print_info "      source ~/.bashrc"
echo ""
