# 🧠 JustAGuy Linux Neovim Config

![Migrated from GitHub](https://img.shields.io/badge/Migrated%20from-GitHub%20(16%20⭐)-lightgrey?logo=github)

> Minimal, fast, and intuitive Neovim setup — designed for Markdown writing, scripting, and everyday editing without unnecessary bloat.

This is my personal Neovim configuration — focused on startup speed, clean visuals, and distraction-free editing.  
No LSPs. No heavy language tooling. Just a rock-solid, keyboard-first workflow with sensible plugins and optional Markdown enhancements.

---

![Screenshot](nvim/screenshots/neovim.png)

---

## ✨ Features

- ⚡ Fast startup via `lazy.nvim` with optimized loading
- 📁 Buffer-based file explorer (`oil.nvim`)
- 🔍 Fuzzy finding with `fzf-lua` 
- 🧠 Smart syntax highlighting via Treesitter
- 🎨 GitHub-inspired theme
- 🖋️ Markdown support with optional Prettier formatting
- 🔐 Git integration with `vim-fugitive`
- 📦 Modular plugin structure
- ⌨️ Keybinding discovery with `which-key.nvim`

---

## 🧩 Plugin Highlights

| Plugin                   | Purpose                                 |
|--------------------------|-----------------------------------------|
| `alpha-nvim`             | Dashboard on launch                     |
| `bufferline.nvim`        | Tab-style buffer UI                     |
| `lualine.nvim`           | Statusline customization                |
| `fzf-lua`                | Fast fuzzy finder (files, words, etc.)  |
| `oil.nvim`               | File browser using buffers              |
| `nvim-treesitter`        | Syntax parsing for multiple filetypes   |
| `vim-fugitive`           | Git integration                         |
| `github-nvim-theme`      | GitHub-style colorscheme                |
| `transparent.nvim`       | Toggle background transparency          |
| `nvim-colorizer.lua`     | Inline hex/rgb color preview            |
| `indent-blankline.nvim`  | Indentation guides                      |
| `markdown-preview.nvim`  | Live Markdown preview in browser        |
| `render-markdown.nvim`   | Inline Markdown rendering in Neovim     |
| `autopairs.nvim`         | Auto-close brackets, quotes, etc.       |
| `autolist.nvim`          | Auto-continue Markdown lists (optional) |
| `which-key.nvim`         | Keybinding discovery and help           |

---

## 🚀 Installation

### 1. Requires Neovim 0.10+

**Recommended:** Install the included Neovim 0.11.4 (much newer than Debian repos):

```bash
wget https://codeberg.org/justaguylinux/nvim/raw/branch/main/nvim-linux-x86_64.deb
sudo apt install ./nvim-linux-x86_64.deb
```

> **Why include the .deb?** Debian 12 ships with Neovim 0.7.2 and Debian 13 has 0.10.4. This config requires 0.10+ and benefits from 0.11+ features. The included .deb provides Neovim 0.11.4 for the best experience.

---

### 2. Backup Any Existing Config

```bash
mv ~/.config/nvim ~/.config/nvim.backup
mv ~/.local/share/nvim ~/.local/share/nvim.backup
```

---

### 3. Clone the Config

```bash
git clone https://codeberg.org/justaguylinux/nvim ~/.config/nvim
```

---

### 4. Launch Neovim

```bash
nvim
```

Plugins will auto-install on first launch.

---

## ⌨️ Keybinding Cheatsheet

| Action               | Keybinding         | Description                          |
|----------------------|--------------------|--------------------------------------|
| Find file            | `<leader>ff`       | Fuzzy file search                    |
| Live grep            | `<leader>fw`       | Grep for word/project search         |
| File explorer        | `<leader>e`        | Open `oil.nvim`                      |
| New tab              | `<leader>t`        | Create new tab                       |
| Close tab            | `<leader>x`        | Close current tab                    |
| Next tab             | `<leader>j`        | Tab forward                          |
| Previous tab         | `<leader>k`        | Tab backward                         |
| Next buffer          | `<Tab>`            | Buffer forward                       |
| Previous buffer      | `<S-Tab>`          | Buffer backward                      |
| Horizontal split     | `<leader>s`        | Open horizontal split                |
| Vertical split       | `<leader>v`        | Open vertical split                  |
| Resize splits        | `<C-Left/Right>`   | Adjust vertical split width          |
| **Markdown Preview** | `<leader>md`       | Open Markdown in browser             |
| **Prettier Format**  | `<leader>mp`       | Format Markdown (optional Prettier)  |

> All keybindings live in `lua/core/mappings.lua` — `space` is the leader key.

---

## 🛠 Requirements

- [`ripgrep`](https://github.com/BurntSushi/ripgrep) (`apt install ripgrep`)
- [`fd`](https://github.com/sharkdp/fd) (`apt install fd-find`)
- A **Nerd Font** terminal (for icons and symbols)

---

## 📝 Optional: Markdown Formatting with Prettier

This config includes optional support for formatting Markdown files using [Prettier](https://prettier.io).

### ✨ Benefits:
- Cleans up messy tables
- Aligns list spacing
- Beautifies headers, paragraphs, and spacing

### 💡 Usage:
1. Install Prettier globally:

   ```bash
   npm install -g prettier
   ```

2. Press `<leader>mp` in any `.md` file to format it.

If Prettier is missing, a friendly error message will be shown in Neovim.

> Prettier is optional — this config works great without it, but it’s a nice tool for polished Markdown.

---

## 🌐 Browser Preview for Markdown

To preview a Markdown file in your browser:

1. Set your preferred browser in `lua/plugins/markdown.lua`:

   ```lua
   vim.g.mkdp_browser = "firefox" -- or "thorium-browser", "librewolf", etc.
   ```

2. Press `<leader>md` in any Markdown file.

---

## 📁 Directory Layout

```text
nvim/
├── init.lua
├── lua/
│   ├── core/        → Options and keymaps
│   ├── plugins/     → Plugin modules
└── nvim-linux-x86_64.deb
```

---

## 🙋‍♂️ Maintained By

**JustAGuy Linux**  
📺 YouTube: [@justaguylinux](https://youtube.com/@justaguylinux)  
💻 Config Repo: [codeberg.org/justaguylinux/nvim](https://codeberg.org/justaguylinux/nvim)
