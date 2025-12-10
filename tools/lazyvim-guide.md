# LazyVim Complete Guide: Navigation, Search & FZF

A comprehensive guide focused on using LazyVim for efficient reading, code navigation, and file searching with FZF integration.

---

## 🚀 Introduction to LazyVim

**LazyVim** is a modern Neovim configuration optimized for fast, efficient editing and navigation. This guide focuses on the core features you use daily:
- Navigation and movement
- Search and pattern matching
- Find and replace operations
- FZF integration for rapid file searching

---

## 📦 Installation & Setup

### Prerequisites
```bash
# Ensure Neovim is installed
nvim --version  # Should be v0.9+

# Install FZF
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# Or via package manager
brew install fzf        # macOS
sudo apt-get install fzf # Ubuntu/Debian
```

### Quick Setup
```bash
cd /home/hamr/Documents/PycharmProjects/agentic-toolkit/tools
./master-lazygit.sh
```

---

## ⌨️ Navigation Essentials

### Basic Movement

| Shortcut | Action | Description |
|----------|--------|-------------|
| `h/j/k/l` | Move Left/Down/Up/Right | Basic cursor movement |
| `w` | Next Word | Move to start of next word |
| `W` | Next WORD | Move to start of next word (ignoring punctuation) |
| `b` | Previous Word | Move to start of previous word |
| `B` | Previous WORD | Move to previous word (ignoring punctuation) |
| `e` | End of Word | Move to end of current word |
| `E` | End of WORD | Move to end of word (ignoring punctuation) |
| `^` | Start of Line | Move to first non-whitespace character |
| `$` | End of Line | Move to end of line |
| `0` | Start of Line | Move to column 0 |
| `g_` | Last Char | Move to last non-whitespace character |

### Page Navigation

| Shortcut | Action | Description |
|----------|--------|-------------|
| `Ctrl + u` | Page Up | Scroll half page up |
| `Ctrl + d` | Page Down | Scroll half page down |
| `Ctrl + b` | Page Up Full | Scroll full page up |
| `Ctrl + f` | Page Down Full | Scroll full page down |
| `gg` | Go to Top | Jump to start of file |
| `G` | Go to Bottom | Jump to end of file |
| `nG` | Go to Line n | Jump to line number (e.g., `42G` goes to line 42) |
| `:n` | Go to Line n | Jump to line using command (e.g., `:42`) |
| `Ctrl + Home` | File Start | Jump to beginning |
| `Ctrl + End` | File End | Jump to end |

### Screen Navigation

| Shortcut | Action | Description |
|----------|--------|-------------|
| `H` | Top of Screen | Jump to top of visible area |
| `M` | Middle of Screen | Jump to middle of visible area |
| `L` | Bottom of Screen | Jump to bottom of visible area |
| `zz` | Center Line | Center current line in viewport |
| `zt` | Top Line | Move line to top of screen |
| `zb` | Bottom Line | Move line to bottom of screen |
| `z.` | Center View | Center and show line at top |

### Jump Between Matches

| Shortcut | Action | Description |
|----------|--------|-------------|
| `%` | Bracket Match | Jump to matching bracket/paren/quote |
| `*` | Next Word | Jump to next occurrence of word under cursor |
| `#` | Previous Word | Jump to previous occurrence of word under cursor |
| `g*` | Partial Match | Jump to next partial word match |
| `g#` | Partial Match Back | Jump to previous partial word match |

### Marks & Jumps

| Shortcut | Action | Description |
|----------|--------|-------------|
| `ma` | Set Mark | Mark current position as 'a' |
| `'a` | Jump to Mark | Jump to line with mark 'a' |
| `` `a `` | Exact Mark | Jump to exact column of mark 'a' |
| `''` | Last Position | Jump to last position before jump |
| `` `` `` | Last Position Exact | Jump to exact column of last position |
| `:marks` | List Marks | Show all marked positions |
| `Ctrl + o` | Jump Back | Jump to previous position in jump list |
| `Ctrl + i` | Jump Forward | Jump to next position in jump list |

---

## 🔍 Search Operations

### Basic Search

| Shortcut | Action | Description |
|----------|--------|-------------|
| `/pattern` | Search Forward | Search for pattern going forward |
| `?pattern` | Search Backward | Search for pattern going backward |
| `n` | Next Match | Jump to next search result |
| `N` | Previous Match | Jump to previous search result |
| `*` | Word Under Cursor | Search forward for word under cursor |
| `#` | Word Back | Search backward for word under cursor |
| `g*` | Partial Match | Search for partial word under cursor |
| `g#` | Partial Back | Search partial word backward |

### Advanced Search Patterns

| Shortcut | Action | Description |
|----------|--------|-------------|
| `/\<word\>` | Whole Word | Search for whole word only |
| `/\Cpattern` | Case Sensitive | Force case-sensitive search |
| `/\cpattern` | Case Insensitive | Force case-insensitive search |
| `/.pattern/` | Literal Dots | Search for literal periods |
| `/^pattern` | Start of Line | Search at beginning of line |
| `/pattern$` | End of Line | Search at end of line |
| `/pat.ern` | Single Char | Search with single character wildcard |
| `/pat.*ern` | Any Chars | Search with any character match |

### Search Navigation

| Shortcut | Action | Description |
|----------|--------|-------------|
| `:set incsearch` | Live Search | Show match as typing |
| `:set hlsearch` | Highlight All | Highlight all matches |
| `:nohlsearch` | Clear Highlights | Clear search highlighting |
| `:set ignorecase` | Case Insensitive | Ignore case in searches |
| `:set smartcase` | Smart Case | Case-sensitive only if uppercase |

### Search History

| Shortcut | Action | Description |
|----------|--------|-------------|
| `q/` | Search History | Open search history window |
| `q?` | Search History Back | Open backward search history |
| `Ctrl + n` | Next in History | Next search in history |
| `Ctrl + p` | Prev in History | Previous search in history |

---

## 🔄 Find & Replace

### Basic Replace

| Shortcut | Action | Description |
|----------|--------|-------------|
| `:s/old/new/` | Replace One | Replace first occurrence on line |
| `:s/old/new/g` | Replace Line | Replace all occurrences on line |
| `:%s/old/new/g` | Replace All | Replace all in file |
| `:%s/old/new/gc` | Confirm Replace | Replace with confirmation |
| `:s/old/new/gi` | Case Insensitive | Replace ignoring case |
| `:%s/\<old\>/new/g` | Whole Word | Replace whole word only |

### Replace with Patterns

| Shortcut | Action | Description |
|----------|--------|-------------|
| `:s/\(pattern\)/\1/` | Regex Group | Use regex groups |
| `:s/^/prefix/` | Add Prefix | Add prefix to start of line |
| `:s/$/suffix/` | Add Suffix | Add suffix to end of line |
| `:%s/\s\+$/` | Remove Trailing | Remove trailing whitespace |
| `:%s/^[[:space:]]*//` | Remove Leading | Remove leading whitespace |

### Range Replace

| Shortcut | Action | Description |
|----------|--------|-------------|
| `:10,20s/old/new/g` | Line Range | Replace in lines 10-20 |
| `:'<,'>s/old/new/g` | Selection | Replace in selected text (visual mode) |
| `:.,+5s/old/new/g` | Relative Range | Replace current line and 5 below |
| `:.,\$s/old/new/g` | To End | Replace current line to end of file |

### Replace Confirmation

| Shortcut | Action | Description |
|----------|--------|-------------|
| `y` | Replace | Replace this match |
| `n` | Skip | Skip this match |
| `a` | Replace All | Replace all remaining matches |
| `q` | Quit | Stop replacing |
| `Ctrl + e` | Edit Replacement | Edit replacement string |
| `Ctrl + h` | Show Match | Show match context |

---

## 🎯 File Operations & Navigation

### File Operations

| Shortcut | Action | Description |
|----------|--------|-------------|
| `Space + e` | File Explorer | Toggle NvimTree |
| `Space + f + f` | Find File | Fuzzy find files |
| `Space + f + o` | Recent Files | Open recent files |
| `Space + b + b` | Buffer List | Show all open buffers |
| `Space + /` | Live Grep | Search within files |
| `:edit file` | Open File | Open specific file |
| `:split file` | Split & Open | Open in horizontal split |
| `:vsplit file` | Vsplit & Open | Open in vertical split |
| `:tabedit file` | Tab & Open | Open in new tab |

### Buffer Navigation

| Shortcut | Action | Description |
|----------|--------|-------------|
| `Space + b + n` | Next Buffer | Go to next buffer |
| `Space + b + p` | Previous Buffer | Go to previous buffer |
| `Space + b + d` | Delete Buffer | Close current buffer |
| `Space + b + l` | Last Buffer | Jump to last buffer |
| `:bn` | Next Buffer | Go to next buffer |
| `:bp` | Previous Buffer | Go to previous buffer |
| `:bd` | Delete Buffer | Close current buffer |
| `:bfirst` | First Buffer | Jump to first buffer |
| `:blast` | Last Buffer | Jump to last buffer |

---

## 🔎 FZF Integration

### FZF Installation & Setup

```bash
# Clone FZF
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# Or install via package manager
brew install fzf        # macOS
sudo apt-get install fzf # Ubuntu/Debian

# Set up environment variables in ~/.zshrc or ~/.bashrc
export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_CTRL_T_COMMAND='fd --type f'
export FZF_ALT_C_COMMAND='fd --type d'
```

### FZF Shell Keybindings

| Shortcut | Action | Description |
|----------|--------|-------------|
| `Ctrl + t` | Files | Fuzzy find files and insert path |
| `Ctrl + r` | History | Fuzzy search command history |
| `Alt + c` | Change Dir | Fuzzy navigate to directory |
| `Ctrl + x + Ctrl + f` | Path Complete | Complete file path |
| `Ctrl + x + Ctrl + d` | Dir Complete | Complete directory path |
| `Ctrl + x + Ctrl + l` | Line History | Search line history |
| `Ctrl + x + Ctrl + k` | Keybindings | Search key bindings |

### FZF with LazyVim Integration

```lua
-- ~/.config/nvim/lua/plugins/fzf.lua
return {
  {
    "junegunn/fzf",
    build = "./install --all",
    dependencies = { "junegunn/fzf.vim" },
  },
  {
    "junegunn/fzf.vim",
    keys = {
      { "<leader>ff", "<cmd>Files<CR>", desc = "FZF Files" },
      { "<leader>fg", "<cmd>GFiles<CR>", desc = "FZF Git Files" },
      { "<leader>fb", "<cmd>Buffers<CR>", desc = "FZF Buffers" },
      { "<leader>fr", "<cmd>Rg<CR>", desc = "FZF Ripgrep" },
      { "<leader>fl", "<cmd>Lines<CR>", desc = "FZF Lines" },
      { "<leader>fc", "<cmd>Commits<CR>", desc = "FZF Commits" },
      { "<leader>fh", "<cmd>History<CR>", desc = "FZF History" },
    },
    config = function()
      vim.g.fzf_layout = { window = { width = 0.9, height = 0.6 } }
      vim.g.fzf_preview_window = { "right:50%" }
    end,
  },
}
```

### FZF Commands in LazyVim

| Command | Description | Best For |
|---------|-------------|----------|
| `:Files` | Find files in current directory | General file search |
| `:GFiles` | Find git tracked files | Project files only |
| `:Buffers` | Search open buffers | Quick buffer switching |
| `:Lines` | Search lines in current buffer | Finding text in file |
| `:BLines` | Search lines in open buffers | Cross-file search |
| `:Rg pattern` | Ripgrep search (powerful) | Content searching |
| `:History` | Search command history | Rerun previous commands |
| `:History:` | Search search history | Previous searches |
| `:Commits` | Search git commits | Finding commits |
| `:Marks` | Search marks | Quick navigation |
| `:Jumps` | Search jump list | Navigation history |
| `:Changes` | Search change list | Edit history |

### FZF Configuration for Speed

```bash
# ~/.zshrc or ~/.bashrc
# Use fd instead of find (much faster)
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
export FZF_CTRL_T_COMMAND='fd --type f --hidden --exclude .git'
export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'

# Use ripgrep with fzf for better searching
export FZF_DEFAULT_COMMAND='rg --files --hidden'

# Enhanced preview with bat
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :500 {}'"
```

### FZF Preview Configuration

```lua
-- ~/.config/nvim/lua/config/keymaps.lua
-- FZF with preview
local function fzf_files_preview()
  vim.fn['fzf#run'](vim.fn['fzf#wrap']({
    source = 'fd --type f --hidden',
    options = {
      '--preview', 'bat --color=always --line-range :500 {}',
      '--preview-window', 'right:50%',
      '--bind', 'ctrl-/:toggle-preview'
    }
  }))
end

vim.keymap.set('n', '<leader>fp', fzf_files_preview, { desc = "FZF Files with Preview" })
```

### FZF vs Telescope Comparison

| Feature | FZF | Telescope |
|---------|-----|-----------|
| **Speed** | ⚡ Very fast (especially large codebases) | 🚀 Fast |
| **Setup Complexity** | Simple | More complex |
| **Shell Integration** | Excellent | Limited |
| **File Navigation** | Excellent | Good |
| **Preview Support** | Good | Advanced |
| **Best for Reading** | ✅ Optimal (fast navigation) | Good |
| **Best for FZF combo** | ✅ Native | Via extension |

---

## 📖 Practical Navigation Workflows

### Reading & Browsing Code

```vim
" Fast file finding
Ctrl + t                 " Open FZF file finder
" Type partial name, use arrow keys or Ctrl+j/k to navigate, Enter to select

" Quick content search
Ctrl + r                 " Search in command history
:Rg pattern              " Use ripgrep to find pattern everywhere

" Navigate within file
Space + /                " Live grep in current file
/pattern                 " Search forward
?pattern                 " Search backward
n/N                      " Jump next/previous

" Move efficiently
gg                       " Go to top
G                        " Go to bottom
H/M/L                    " Jump to top/middle/bottom of screen
Ctrl + u/d               " Scroll half page
```

### Find & Replace Workflow

```vim
" Simple replace
:%s/old/new/g            " Replace all occurrences
:%s/old/new/gc           " Replace with confirmation

" Smart replace
:%s/\<old\>/new/g        " Replace whole word only
:%s/old/new/gi           " Case-insensitive replace
:s/^/prefix/             " Add prefix to line

" Range replace
:10,20s/old/new/g        " Replace in lines 10-20
:'<,'>s/old/new/g        " Replace in selection (visual mode)
```

### File Navigation Workflow (FZF Focused)

```vim
" Fast file search
Space + f + f            " LazyVim fuzzy find
Ctrl + t                 " FZF file picker (in terminal)

" Search specific types
:GFiles                  " Git tracked files only
:Files /path/            " Find in specific directory

" Buffer jumping
Space + b + b            " Quick buffer switch
:Buffers                 " FZF buffer search

" Content search
:Rg pattern              " Search content everywhere
:Lines                   " Search in current file
:BLines                  " Search in all open buffers
```

---

## 🎨 Visual Mode & Selection

### Visual Selection Modes

| Shortcut | Action | Description |
|----------|--------|-------------|
| `v` | Visual Char | Select characters |
| `V` | Visual Line | Select entire lines |
| `Ctrl + v` | Visual Block | Select column block |
| `gv` | Reselect | Reselect last selection |
| `o` | Swap End | Swap cursor to selection end |

### Extend Selection

| Shortcut | Action | Description |
|----------|--------|-------------|
| `w/b` | Word | Extend by word |
| `e` | End of Word | Extend to end of word |
| `$/^` | Line End/Start | Extend to line boundaries |
| `%` | Bracket | Extend to matching bracket |
| `iw` | Inner Word | Select inner word |
| `aw` | A Word | Select word with space |
| `i"/'` | Inner Quotes | Select inside quotes |
| `a"/'` | A Quotes | Select quotes and content |

---

## 💾 Copy, Paste & Registers

### Yank (Copy) Operations

| Shortcut | Action | Description |
|----------|--------|-------------|
| `yy` | Yank Line | Copy entire line |
| `y$` | Yank to EOL | Copy from cursor to end |
| `y^` | Yank to SOL | Copy from cursor to start |
| `yw` | Yank Word | Copy word |
| `yiw` | Yank Inner | Copy inner word |
| `yi"` | Yank in Quotes | Copy inside quotes |
| `yi{` | Yank in Braces | Copy inside braces |
| `yt.` | Yank Until | Copy until specified character |

### Paste Operations

| Shortcut | Action | Description |
|----------|--------|-------------|
| `p` | Paste After | Paste after cursor |
| `P` | Paste Before | Paste before cursor |
| `]p` | Paste with Indent | Paste and auto-indent |
| `[p` | Paste Before Indent | Paste before with indent |
| `"+y` | Copy to Clipboard | Copy to system clipboard |
| `"+p` | Paste from Clipboard | Paste from system clipboard |

### Registers

| Shortcut | Action | Description |
|----------|--------|-------------|
| `"ayy` | Save to Register | Copy to register 'a' |
| `"ap` | Paste from Register | Paste from register 'a' |
| `:reg` | List Registers | Show all registers |
| `:reg a` | Show Register a | Show specific register content |

---

## ⌨️ Quick Reference Card

### Navigation Shortcuts
```
Movement:      h/j/k/l, w/b/e, ^/$, g_
Jumps:         gg, G, nG, %, Ctrl+o/i
Marks:         ma, 'a, :marks
Page:          Ctrl+u/d, Ctrl+b/f, zz/zt/zb
```

### Search Shortcuts
```
Search:        /pattern, ?pattern, n, N, *
Whole word:    /\<word\>
Case control:  \C (sensitive), \c (insensitive)
Regex:         .* (match), ^ (start), $ (end)
```

### Replace Shortcuts
```
Line:          :s/old/new/g
File:          :%s/old/new/g
With confirm:  :%s/old/new/gc
Whole word:    :%s/\<old\>/new/g
Range:         :10,20s/old/new/g
```

### FZF Shortcuts
```
Files:         Ctrl+t, :Files
History:       Ctrl+r, :History
Grep:          :Rg pattern
Buffers:       :Buffers, Space+b+b
Directory:     Alt+c
```

---

## 🚀 Advanced Tips for Reading Code

### Efficient Code Reading
```vim
" 1. Find file quickly
Ctrl + t                          " Open FZF
" Type filename, Enter

" 2. Search for specific function
/def function_name                " Search for function
*                                 " Find next occurrence

" 3. Navigate structure
gd                                " Go to definition
gD                                " Go to declaration
gr                                " Find references
%                                 " Jump to matching bracket

" 4. Keep position
ma                                " Mark current position
'a                                " Jump back to mark
Ctrl + o                          " Jump to previous position
```

### Multi-file Search with FZF
```vim
" Search across project
:Rg pattern                       " Find pattern in all files
" Select file in FZF, opens in buffer

" Find in specific directory
:Files src/                       " Search in src folder

" Quick buffer switching
Space + b + b                     " Jump to open file quickly
```

### Window Management for Reading
```vim
" Split screen for comparison
Ctrl + w + v                      " Vertical split
Ctrl + w + s                      " Horizontal split
Ctrl + w + h/j/k/l                " Navigate splits
Ctrl + w + =                      " Balance splits
```

---

## 🔧 Configuration Tips

### Essential .vimrc Settings
```vim
set number                        " Show line numbers
set relativenumber                " Show relative numbers
set hlsearch                      " Highlight search results
set incsearch                     " Show matches while typing
set ignorecase                    " Case-insensitive search
set smartcase                     " Case-sensitive if uppercase used
set nowrap                        " Don't wrap long lines
set scrolloff=3                   " Keep 3 lines visible when scrolling
```

### FZF with Ripgrep Speed
```bash
# ~/.zshrc
export FZF_DEFAULT_COMMAND='rg --files --hidden --smart-case'
export FZF_CTRL_T_COMMAND='rg --files --hidden --smart-case'
alias fzf='fzf --preview "bat --color=always {}"'
```

---

## 📚 Additional Resources

- [LazyVim Documentation](https://www.lazyvim.org/)
- [FZF Repository](https://github.com/junegunn/fzf)
- [Vim Documentation](http://www.vim.org/docs.php)
- [Ripgrep Guide](https://github.com/BurntSushi/ripgrep)

---

*Last Updated: December 2025*
*Version: 1.0*
