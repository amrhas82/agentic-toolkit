#!/bin/bash

# Neovim + NvimTree Complete Setup Script
# Installs and configures: Neovim (from source) + nvim-tree + Lazygit + plugins + config

set -e

echo "================================================"
echo "  Neovim + NvimTree Setup"
echo "================================================"
echo ""
echo "This script will install and configure:"
echo "  • Neovim (latest from source)"
echo "  • nvim-tree file explorer"
echo "  • Lazygit for Git management"
echo "  • All necessary plugins and configurations"
echo ""
read -p "Continue with installation? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Installation cancelled."
    exit 0
fi

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    echo "Please do not run this script as root"
    echo "The script will ask for sudo password when needed"
    exit 1
fi

# ==========================================
# NEOVIM SETUP
# ==========================================

echo ""
echo "================================================"
echo "Setting up Neovim"
echo "================================================"
echo ""

echo "Installing prerequisites..."
sudo dnf check-update
sudo dnf install -y \
    curl \
    git \
    @development-tools \
    unzip \
    gettext \
    cmake \
    ripgrep \
    fd-find \
    software-properties-common \
    ninja-build \
    pkg-config \
    automake \
    autoconf

echo ""
echo "Installing Node.js..."
if ! command -v node &> /dev/null; then
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo dnf install -y nodejs
fi

echo ""
echo "Installing Neovim..."
# Remove old neovim if exists
sudo dnf remove neovim -y 2>/dev/null || true

# Clone Neovim repository
cd ~
if [ -d "neovim" ]; then
    rm -rf neovim
fi

git clone https://github.com/neovim/neovim.git
cd neovim
git checkout stable

# Build Neovim
echo "Compiling Neovim (this takes 5-10 minutes)..."
make CMAKE_BUILD_TYPE=RelWithDebInfo

# Install Neovim
echo "Installing Neovim..."
sudo make install

cd ~
rm -rf neovim
hash -r

echo ""
echo "Installing Lazygit..."
if ! command -v lazygit &> /dev/null; then
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit /usr/local/bin
    rm lazygit lazygit.tar.gz
fi

echo ""
echo "Installing vim-plug..."
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

mkdir -p ~/.config/nvim

echo ""
echo "Creating Neovim configuration..."
cat > ~/.config/nvim/init.vim << 'NVIM_EOF'
set number
set relativenumber
set mouse=a
set ignorecase
set smartcase
set hlsearch
set incsearch
set expandtab
set tabstop=2
set shiftwidth=2
set smartindent
set termguicolors
set clipboard=unnamedplus
set hidden
set updatetime=300
set timeoutlen=500
set splitright
set splitbelow
set cursorline
set signcolumn=yes
set scrolloff=8
set noshowmode

call plug#begin('~/.local/share/nvim/plugged')
Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'folke/tokyonight.nvim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.5' }
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'lewis6991/gitsigns.nvim'
Plug 'kdheepak/lazygit.nvim'
Plug 'windwp/nvim-autopairs'
Plug 'numToStr/Comment.nvim'
Plug 'lukas-reineke/indent-blankline.nvim'
call plug#end()

colorscheme tokyonight-night

lua << LUAEND
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    width = 35,
  },
  renderer = {
    group_empty = true,
    highlight_git = true,
    highlight_opened_files = "name",
    icons = {
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
      },
      glyphs = {
        default = "",
        symlink = "",
        folder = {
          arrow_closed = "",
          arrow_open = "",
          default = "",
          open = "",
          empty = "",
          empty_open = "",
        },
        git = {
          unstaged = "✗",
          staged = "✓",
          unmerged = "",
          renamed = "➜",
          untracked = "★",
          deleted = "",
          ignored = "◌",
        },
      },
    },
  },
  filters = {
    dotfiles = false,
  },
  git = {
    enable = true,
    ignore = false,
  },
})

require('lualine').setup({
  options = {
    theme = 'tokyonight',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    globalstatus = true,
  },
})

require('nvim-treesitter.configs').setup({
  ensure_installed = { "lua", "vim", "python", "javascript", "html", "css", "bash", "json" },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true
  },
})

require('gitsigns').setup({
  signs = {
    add          = { text = '│' },
    change       = { text = '│' },
    delete       = { text = '_' },
    topdelete    = { text = '‾' },
    changedelete = { text = '~' },
  },
})

require('nvim-autopairs').setup()
require('Comment').setup()

require("ibl").setup({
  indent = { char = "│" },
  scope = { enabled = true },
})

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})
LUAEND

let mapleader = " "

nnoremap <C-n> :NvimTreeToggle<CR>
nnoremap <leader>e :NvimTreeFocus<CR>
nnoremap <leader>r :NvimTreeRefresh<CR>
nnoremap <leader>f :NvimTreeFindFile<CR>
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>fr <cmd>Telescope oldfiles<cr>
nnoremap <leader>gg :LazyGit<CR>
nnoremap <leader>gc :LazyGitConfig<CR>
nnoremap <leader>gf :LazyGitFilter<CR>
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprevious<CR>
nnoremap <leader>bd :bdelete<CR>
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <Esc> :noh<CR>
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>x :x<CR>
nnoremap <leader>sv :vsplit<CR>
nnoremap <leader>sh :split<CR>
vnoremap < <gv
vnoremap > >gv

autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) | execute 'cd' argv()[0] | execute 'NvimTreeOpen' | endif
autocmd BufEnter * if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif
NVIM_EOF

echo ""
echo "Installing Neovim plugins..."
nvim +PlugInstall +qall

echo "✓ Neovim setup complete"

# ==========================================
# COMPLETION SUMMARY
# ==========================================

echo ""
echo "================================================"
echo "  ✓ Neovim Setup Finished!"
echo "================================================"
echo ""
echo "Installed Software:"
echo "  • Neovim: $(nvim --version | head -n1)"
echo "  • Lazygit: $(lazygit --version)"
echo "  • Node.js: $(node --version)"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "NEOVIM KEYBINDINGS (Leader = Space)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Ctrl+n          - Toggle file tree"
echo "  Space+e         - Focus file tree"
echo "  Space+f         - Find file in tree"
echo "  Space+ff        - Find files (Telescope)"
echo "  Space+fg        - Search in files (Live grep)"
echo "  Space+fb        - Browse buffers"
echo "  Space+fr        - Recent files"
echo "  Space+gg        - Open Lazygit"
echo "  Space+w         - Save file"
echo "  Space+q         - Quit"
echo "  Space+x         - Save and quit"
echo "  Tab/Shift+Tab   - Next/Previous buffer"
echo "  Ctrl+h/j/k/l    - Navigate splits"
echo ""
echo "Quick Start:"
echo "  1. Open nvim: nvim"
echo "  2. Toggle file tree: Ctrl+n"
echo "  3. Find files: Space+ff"
echo "  4. Open git: Space+gg"
echo ""
echo "Configuration File:"
echo "  • Neovim: ~/.config/nvim/init.vim"
echo ""
echo "Installed Plugins:"
echo "  • nvim-tree (file explorer)"
echo "  • nvim-web-devicons (file icons)"
echo "  • tokyonight (color theme)"
echo "  • lualine (status line)"
echo "  • Telescope (fuzzy finder)"
echo "  • Treesitter (syntax highlighting)"
echo "  • Gitsigns (Git integration)"
echo "  • Lazygit (Git UI)"
echo "  • nvim-autopairs (auto-closing brackets)"
echo "  • Comment.nvim (commenting)"
echo "  • indent-blankline (indentation guides)"
echo ""
echo "Enjoy your new Neovim setup! 🚀"
echo ""
