# LazyVim + Git Integration: Complete Development Workflow Guide

## 🚀 Introduction to LazyVim + Git Integration

**LazyVim** is a modern Neovim configuration focused on making Vim approachable while also being suitable for deep, long-term editing. When combined with **Git** and **Lazygit**, it creates a powerful development environment for modern software development.

This guide covers:
- ✅ **LazyVim Essentials**: Core navigation and editing features
- ✅ **Git Integration**: Version control within Neovim
- ✅ **Lazygit Synergy**: Seamless integration with the terminal UI
- ✅ **Workflows**: Common development patterns and processes
- ✅ **Plugins**: Essential Git-related plugins and configurations

### Why This Combination?
| Feature | LazyVim | Traditional Vim | VS Code |
|---------|---------|----------------|---------|
| **Startup Speed** | ~50ms | ~100ms | ~1s+ |
| **Memory Usage** | ~30MB | ~20MB | ~300MB+ |
| **Customization** | Lua-based | Vimscript/Python | JSON/JS |
| **Git Integration** | Built-in plugins | Manual setup | Built-in |
| **Cross-platform** | Excellent | Good | Excellent |

---

## 📦 Installation & Setup

### Prerequisites
```bash
# Ensure Node.js and npm are installed
node --version  # Should be v16+
npm --version

# Install Neovim (if not already installed)
sudo snap install nvim --classic
```

### Master Setup Scripts
```bash
# Setup LazyVim with all dependencies
cd /home/hamr/Documents/PycharmProjects/agentic-toolkit/tools
./master-lazygit.sh

# Setup Ghostty (optional, for optimal terminal experience)
./master-ghostty.sh
```

### Verify Installation
```bash
# Check Neovim version
nvim --version

# Check LazyVim installation
nvim --headless -c "lua print('LazyVim loaded')" -c "quit"

# Check Lazygit installation
lazygit --version
```

### Initial Configuration
The setup scripts will automatically configure LazyVim with:
- 🎨 Catppuccin Frappe theme
- 🔧 Lazy plugin manager
- 📁 File tree (NvimTree)
- 🔍 Fuzzy finder (Telescope)
- 🌲 Git signs and gutters
- 🧩 Language support (LSP)

---

## ⌨️ LazyVim Essential Shortcuts

### File Operations & Navigation

| Shortcut | Action | Description |
|----------|--------|-------------|
| `Space + f + f` | Find File | Open fuzzy file finder |
| `Space + f + o` | Recent Files | Show recent files |
| `Space + b` | Buffer Explorer | Open buffer manager |
| `Space + e` | File Explorer | Toggle NvimTree |
| `Ctrl + p` | Fuzzy Finder | Alternative file search |
| `Space + /` | Live Grep | Search within files |
| `Space + g + g` | Git Status | Open git status |
| `Space + g + c` | Commits | Show git commits |
| `Space + g + b` | Branches | Show git branches |

### Window Management

| Shortcut | Action | Description |
|----------|--------|-------------|
| `Ctrl + w + s` | Split Horizontal | Create horizontal split |
| `Ctrl + w + v` | Split Vertical | Create vertical split |
| `Ctrl + w + h/j/k/l` | Navigate Splits | Move between splits |
| `Ctrl + w + H/J/K/L` | Move Window | Move split to new position |
| `Ctrl + w + x` | Swap Windows | Exchange two windows |
| `Ctrl + w + t` | Tab New | Create new tab |
| `Ctrl + w + T` | Tab Move | Move window to new tab |
| `Ctrl + w + n` | New Window | Create new window |
| `Ctrl + w + c` | Close Window | Close current window |
| `Space + w + v` | VSplit Vertical | Vertical split |
| `Space + w + s` | Split Horizontal | Horizontal split |
| `Space + w + l` | Maximize | Maximize current window |
| `Space + w =` | Balance | Balance window sizes |

### Buffer Management

| Shortcut | Action | Description |
|----------|--------|-------------|
| `Space + b + b` | Buffer Explorer | Show all buffers |
| `Space + b + d` | Delete Buffer | Delete current buffer |
| `Space + b + D` | Force Delete | Force delete buffer |
| `Space + b + n` | Next Buffer | Go to next buffer |
| `Space + b + p` | Previous Buffer | Go to previous buffer |
| `Space + b + l` | Last Buffer | Go to last buffer |
| `Space + b + s` | Scratch Buffer | Create scratch buffer |
| `Space + b + f` | Find Buffer | Fuzzy find buffer |
| `Space + b + o` | Only Buffer | Close other buffers |

### Search & Replace

| Shortcut | Action | Description |
|----------|--------|-------------|
| `/` | Search Forward | Search forward in buffer |
| `?` | Search Backward | Search backward in buffer |
| `n` | Next Match | Go to next search match |
| `N` | Previous Match | Go to previous search match |
| `*` | Word Under Cursor | Search for word under cursor |
| `#` | Word Under Cursor | Search backward for word |
| `Space + r + r` | Replace Word | Replace all occurrences |
| `:%s/old/new/g` | Replace All | Vim-style replace |
| `Ctrl + r` | Redo | Redo last change |
| `u` | Undo | Undo last change |

### Basic Text Editing

| Shortcut | Action | Description |
|----------|--------|-------------|
| `i` | Insert Mode | Insert before cursor |
| `a` | Append Mode | Append after cursor |
| `I` | Insert SOL | Insert at start of line |
| `A` | Append EOL | Append at end of line |
| `o` | New Line Below | Insert new line below |
| `O` | New Line Above | Insert new line above |
| `x` | Delete Char | Delete character at cursor |
| `X` | Delete Prev | Delete character before cursor |
| `dd` | Delete Line | Delete entire line |
| `D` | Delete EOL | Delete to end of line |
| `d$` | Delete to EOL | Delete from cursor to end |
| `d^` | Delete to SOL | Delete from cursor to start |
| `dw` | Delete Word | Delete word |
| `dW` | Delete Word+Space | Delete word with space |
| `diw` | Delete In Word | Delete inner word |
| `daw` | Delete A Word | Delete word with space |
| `cc` | Change Line | Change entire line |
| `cw` | Change Word | Change word |
| `ciw` | Change In Word | Change inner word |
| `s` | Substitute Char | Substitute single character |
| `S` | Substitute Line | Substitute entire line |
| `.` | Repeat Last | Repeat last command |
| `u` | Undo | Undo last change |
| `Ctrl + r` | Redo | Redo undone change |

### Visual Mode & Selection

| Shortcut | Action | Description |
|----------|--------|-------------|
| `v` | Visual Character | Start visual selection (char) |
| `V` | Visual Line | Start visual selection (line) |
| `Ctrl + v` | Visual Block | Start visual selection (block) |
| `o` | Swap Cursor | Swap cursor position in selection |
| `h/j/k/l` | Extend Selection | Extend visual selection |
| `w` | Select Word | Select forward by word |
| `b` | Select Back | Select backward by word |
| `e` | Select End | Select to end of word |
| `$` | Select to EOL | Select to end of line |
| `^` | Select to SOL | Select to start of line |
| `%` | Bracket Match | Select matching bracket |
| `iw` | Inner Word | Select inner word |
| `aw` | A Word | Select word with space |
| `i"` | Inner Quote | Select inside quotes |
| `a"` | A Quote | Select quotes and content |
| `it` | Inner Tag | Select inner HTML tag |
| `at` | A Tag | Select HTML tag |
| `>` | Indent | Indent selection |
| `<` | Unindent | Unindent selection |
| `=` | Autoindent | Autoindent selection |
| `~` | Toggle Case | Toggle case of selection |
| `u` | Lowercase | Convert to lowercase |
| `U` | Uppercase | Convert to uppercase |

### Copy, Paste & Registers

| Shortcut | Action | Description |
|----------|--------|-------------|
| `yy` | Yank Line | Copy entire line |
| `y$` | Yank to EOL | Copy from cursor to end |
| `y^` | Yank to SOL | Copy from cursor to start |
| `yw` | Yank Word | Copy word |
| `yiw` | Yank Inner Word | Copy inner word |
| `yaw` | Yank A Word | Copy word with space |
| `yi"` | Yank Inner Quotes | Copy inside quotes |
| `yi{` | Yank Inner Braces | Copy inside braces |
| `p` | Paste After | Paste after cursor |
| `P` | Paste Before | Paste before cursor |
| `]p` | Paste Indent | Paste and adjust indent |
| `[p` | Paste Indent Before | Paste before with indent |
| `"+y` | Yank to Clipboard | Copy to system clipboard |
| `"+p` | Paste from Clipboard | Paste from system clipboard |
| `"ayy` | Yank to Register a | Copy to register 'a' |
| `"ap` | Paste from Register a | Paste from register 'a' |
| `:reg` | Show Registers | Show all registers |

### Find & Replace

| Shortcut | Action | Description |
|----------|--------|-------------|
| `/pattern` | Search Forward | Search for pattern forward |
| `?pattern` | Search Backward | Search backward for pattern |
| `n` | Next Match | Jump to next match |
| `N` | Previous Match | Jump to previous match |
| `*` | Search Word | Search for word under cursor |
| `#` | Search Word Back | Search word under cursor backward |
| `g*` | Search Partial | Search partial word match |
| `g#` | Search Partial Back | Search partial word backward |
| `:s/old/new/` | Replace One | Replace first occurrence |
| `:s/old/new/g` | Replace Line | Replace all on line |
| `:%s/old/new/g` | Replace All | Replace all in file |
| `:%s/old/new/gc` | Replace Confirm | Replace with confirmation |
| `:s/old/new/gi` | Replace Case-Insensitive | Replace ignoring case |
| `:s/\<old\>/new/g` | Replace Word | Replace whole word only |
| `:%s/old/new/gi` | Replace All Ignore Case | Replace all, case-insensitive |
| `:s/\(pattern\)/\1/` | Regex Groups | Use regex with groups |
| `:s/^/prefix/` | Add Prefix | Add prefix to line |
| `:s/$/suffix/` | Add Suffix | Add suffix to line |

### Page & Buffer Navigation

| Shortcut | Action | Description |
|----------|--------|-------------|
| `Ctrl + u` | Page Up | Scroll half page up |
| `Ctrl + d` | Page Down | Scroll half page down |
| `Ctrl + b` | Page Up Full | Scroll full page up |
| `Ctrl + f` | Page Down Full | Scroll full page down |
| `gg` | Go Top | Go to start of file |
| `G` | Go Bottom | Go to end of file |
| `nG` | Go Line | Go to line number n |
| `:n` | Go Line | Go to line number n (command) |
| `Ctrl + Home` | Go File Start | Go to start of file |
| `Ctrl + End` | Go File End | Go to end of file |
| `H` | High Screen | Go to top of screen |
| `M` | Middle Screen | Go to middle of screen |
| `L` | Low Screen | Go to bottom of screen |
| `zz` | Center Line | Center line in viewport |
| `zt` | Top Line | Move line to top |
| `zb` | Bottom Line | Move line to bottom |
| `z.` | Center & Top | Center and show line at top |
| `:set number` | Show Line Numbers | Display line numbers |
| `:set relativenumber` | Relative Numbers | Show relative line numbers |
| `Ctrl + g` | Show Position | Show current line/column |

### Advanced Vim Functions

| Shortcut | Action | Description |
|----------|--------|-------------|
| `q:` | Command History | Open command history window |
| `q/` | Search History | Open search history window |
| `:read file.txt` | Read File | Insert file contents |
| `:read !command` | Read Command | Insert command output |
| `!motion command` | Filter Lines | Filter lines through command |
| `!!command` | Filter Line | Filter current line through command |
| `:set paste` | Paste Mode | Enable paste mode (no indent) |
| `:set nopaste` | Normal Mode | Disable paste mode |
| `:set nowrap` | No Wrap | Don't wrap long lines |
| `:set wrap` | Wrap | Wrap long lines |
| `:set list` | Show Whitespace | Show tabs and spaces |
| `:set nolist` | Hide Whitespace | Hide tabs and spaces |
| `Ctrl + w + z` | Close Preview | Close preview window |
| `:split` | Horizontal Split | Split window horizontally |
| `:vsplit` | Vertical Split | Split window vertically |
| `:only` | Close Others | Close all other windows |
| `:%!command` | Filter Buffer | Filter entire buffer |
| `:!command` | Run Command | Run shell command |
| `:read !ls` | List Directory | Insert directory listing |
| `gq` | Format Text | Format text (wrap) |
| `gqq` | Format Line | Format current line |
| `gqap` | Format Paragraph | Format paragraph |
| `J` | Join Lines | Join lines together |
| `gJ` | Join No Space | Join lines without space |
| `~` | Toggle Case | Toggle character case |
| `g~` | Toggle Case Operator | Toggle case (use with motion) |
| `gu` | Lowercase | Convert to lowercase |
| `gU` | Uppercase | Convert to uppercase |
| `:retab` | Convert Tabs | Convert tabs to spaces |
| `:set tabstop=4` | Tab Size | Set tab width |
| `ma` | Mark Position | Mark current position as 'a' |
| `'a` | Jump Mark | Jump to mark 'a' |
| `` `a `` | Exact Mark | Jump to exact position of mark |
| `:marks` | List Marks | Show all marks |

### LSP Features (Language Server Protocol)

| Shortcut | Action | Description |
|----------|--------|-------------|
| `g + d` | Go to Definition | Jump to definition |
| `g + D` | Go to Declaration | Jump to declaration |
| `g + i` | Find Implementation | Find implementations |
| `g + r` | Find References | Find references |
| `g + t` | Type Definition | Jump to type definition |
| `Space + l + i` | Info | Show LSP information |
| `Space + l + r` | Rename | Rename symbol |
| `Space + l + a` | Code Action | Show code actions |
| `Space + l + f` | Format | Format buffer |
| `Space + l + o` | Organize Imports | Organize imports |
| `K` | Hover | Show hover information |
| `Ctrl + s` | Signature Help | Show signature help |

### Plugin Management (Lazy)

| Shortcut | Action | Description |
|----------|--------|-------------|
| `Space + p + i` | Install Plugin | Install new plugin |
| `Space + p + c` | Check Plugins | Check for updates |
| `Space + p + s` | Sync Plugins | Sync and install plugins |
| `Space + p + h` | Help | Show plugin help |
| `Space + p + l` | Log | Show plugin log |
| `Space + p + L` | Lazy Logs | Show lazy.nvim logs |
| `Space + p + d` | Debug | Toggle debug mode |
| `Space + p + D` | Debug Logs | Show debug logs |

### Tab Management & Surfing

| Shortcut | Action | Description |
|----------|--------|-------------|
| `gt` | Next Tab | Go to next tab |
| `gT` | Previous Tab | Go to previous tab |
| `1gt` | Tab 1 | Jump to tab 1 |
| `2gt` | Tab 2 | Jump to tab 2 |
| `ngt` | Tab n | Jump to tab number n |
| `:tabnew` | New Tab | Create new tab |
| `:tabnew file.txt` | Open in Tab | Open file in new tab |
| `Ctrl + w + t` | New Tab Window | Create new tab |
| `:tabedit file.txt` | Tab Edit | Edit file in new tab |
| `:tabnext` | Next Tab | Go to next tab |
| `:tabprev` | Previous Tab | Go to previous tab |
| `:tabnext n` | Jump Tab | Jump to tab n |
| `:tabfirst` | First Tab | Go to first tab |
| `:tablast` | Last Tab | Go to last tab |
| `:tabclose` | Close Tab | Close current tab |
| `:tabclose n` | Close Tab n | Close tab number n |
| `:tabonly` | Only Tab | Close all other tabs |
| `:tabmove` | Move Tab | Move tab to different position |
| `:tabmove 0` | Move to Start | Move tab to start |
| `:tabmove $` | Move to End | Move tab to end |
| `:tabs` | List Tabs | Show all open tabs |
| `:tabdo command` | Tab All | Execute command in all tabs |
| `Space + <` | Previous Tab | Go to previous tab (custom) |
| `Space + >` | Next Tab | Go to next tab (custom) |

### Telescope (Fuzzy Finder)

| Shortcut | Action | Description |
|----------|--------|-------------|
| `Space + f + f` | Find Files | Find files |
| `Space + f + o` | Recent Files | Recent files |
| `Space + f + g` | Git Files | Git tracked files |
| `Space + f + w` | Words | Find words in buffer |
| `Space + /` | Live Grep | Live grep |
| `Space + s + b` | Buffer Search | Search buffers |
| `Space + s + c` | Commands | Commands |
| `Space + s + h` | Help Tags | Help tags |
| `Space + s + m` | Marks | Marks |
| `Space + s + r` | Registers | Registers |
| `Space + s + k` | Keymaps | Keymaps |
| `Space + s + o` | Options | Options |

### FZF Integration with LazyVim

**FZF** (Fuzzy Finder) is a command-line fuzzy finder that integrates seamlessly with LazyVim. While Telescope is the default, FZF offers faster performance for large codebases.

#### FZF Installation & Setup

```bash
# Install FZF
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# Or via package manager
brew install fzf        # macOS
sudo apt-get install fzf # Ubuntu/Debian
```

#### FZF Key Bindings in LazyVim

| Shortcut | Action | Description |
|----------|--------|-------------|
| `Ctrl + t` | Files | Search files |
| `Ctrl + r` | History | Search command history |
| `Alt + c` | Change Dir | Fuzzy navigate directories |
| `Ctrl + x + Ctrl + f` | Path | Complete file path |
| `Ctrl + x + Ctrl + d` | Directory | Complete directory |
| `Ctrl + x + Ctrl + l` | Line | Search line history |
| `Ctrl + x + Ctrl + k` | Keybindings | Search key bindings |

#### FZF Configuration for LazyVim

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
      { "<leader>fb", "<cmd>Buffers<CR>", desc = "FZF Buffers" },
      { "<leader>fc", "<cmd>Commits<CR>", desc = "FZF Commits" },
      { "<leader>fl", "<cmd>Lines<CR>", desc = "FZF Lines" },
      { "<leader>fg", "<cmd>GFiles<CR>", desc = "FZF Git Files" },
      { "<leader>fr", "<cmd>Rg<CR>", desc = "FZF Ripgrep" },
      { "<leader>fh", "<cmd>History<CR>", desc = "FZF History" },
      { "<leader>fs", "<cmd>Snippets<CR>", desc = "FZF Snippets" },
      { "<leader>fm", "<cmd>Maps<CR>", desc = "FZF Maps" },
      { "<leader>fw", "<cmd>Windows<CR>", desc = "FZF Windows" },
    },
    config = function()
      vim.g.fzf_layout = { window = { width = 0.9, height = 0.6 } }
      vim.g.fzf_preview_window = { "right:50%" }
    end,
  },
}
```

#### FZF Commands in LazyVim

| Command | Description |
|---------|-------------|
| `:Files` | Find files in current directory |
| `:GFiles` | Find git tracked files |
| `:Buffers` | Search open buffers |
| `:Lines` | Search lines in current buffer |
| `:BLines` | Search lines in open buffers |
| `:Commits` | Search git commits |
| `:BCommits` | Search commits for current file |
| `:History` | Search command history |
| `:History:` | Search search history |
| `:History/` | Search command line history |
| `:Rg pattern` | Ripgrep search |
| `:RgRaw pattern` | Ripgrep with raw flags |
| `:Snippets` | Search snippets |
| `:Maps` | Search key maps |
| `:Colors` | Search color schemes |
| `:Windows` | Search open windows |
| `:Marks` | Search marks |
| `:Tags` | Search tags |
| `:Jumps` | Search jump list |
| `:Changes` | Search change list |

#### FZF vs Telescope Comparison

| Feature | FZF | Telescope |
|---------|-----|-----------|
| **Speed** | ⚡ Very fast | 🚀 Fast |
| **Large Codebase** | ✅ Excellent | ⚠️ Good |
| **Integration** | Simple | Full-featured |
| **Customization** | Good | Excellent |
| **Built-in LSP** | No | Yes |
| **Previews** | Basic | Advanced |
| **Best For** | Speed, simplicity | Power users |

#### Enable FZF for Specific Commands

```bash
# ~/.zshrc or ~/.bashrc
export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_CTRL_T_COMMAND='fd --type f'
export FZF_ALT_C_COMMAND='fd --type d'

# Use ripgrep with fzf
export FZF_DEFAULT_COMMAND='rg --files --hidden'
```

#### FZF Preview Configuration

```lua
-- ~/.config/nvim/lua/config/keymaps.lua
-- Enhanced FZF with previews
local function fzf_files_preview()
  vim.fn['fzf#run'](vim.fn['fzf#wrap']({
    source = 'fd --type f',
    options = {
      '--preview', 'cat {}',
      '--preview-window', 'right:50%'
    }
  }))
end

vim.keymap.set('n', '<leader>fp', fzf_files_preview, { desc = "FZF Files with Preview" })
```

### Terminal Operations

| Shortcut | Action | Description |
|----------|--------|-------------|
| `Space + t + t` | Terminal Toggle | Toggle terminal |
| `Space + t + h` | Terminal Horizontal | Terminal horizontal split |
| `Space + t + v` | Terminal Vertical | Terminal vertical split |
| `Space + t + l` | Terminal Last | Last terminal |
| `Space + t + s` | Terminal Size | Set terminal size |
| `Ctrl + c` | Terminal Interrupt | Interrupt terminal |
| `Ctrl + d` | Terminal Exit | Exit terminal |
| `Enter` | Terminal Send | Send command |

---

## 🐙 Git Integration with LazyVim

### Git Signs & Gutter

LazyVim provides visual Git feedback in the gutter:
- 🟢 **Green**: Added lines
- 🔴 **Red**: Deleted lines
- 🔵 **Blue**: Changed lines

| Shortcut | Action | Description |
|----------|--------|-------------|
| `Space + g + s` | Git Status | Open git status window |
| `Space + g + c` | Commits | Show commit history |
| `Space + g + b` | Branches | Show branches |
| `Space + g + l` | Log | Show git log |
| `Space + g + L` | Log Current | Show current branch log |
| `Space + g + p` | Pull | Pull latest changes |
| `Space + g + P` | Push | Push changes |
| `Space + g + i` | Ignore | Add to .gitignore |
| `Space + g + r` | Revert | Revert file |
| `Space + g + y` | Copy SHA | Copy commit hash |
| `Space + g + S` | Stage | Stage current file |
| `Space + g + U` | Unstage | Unstage current file |

### Git Commands in Command Line

| Command | Description | Equivalent Shortcut |
|---------|-------------|-------------------|
| `:G` | Git Status | `Space + g + s` |
| `:Gdiff` | Diff | `Space + g + d` |
| `:Gblame` | Blame | `Space + g + b` |
| `:Glog` | Log | `Space + g + l` |
| `:Gcommit` | Commit | `Space + g + c` |
| `:Gpull` | Pull | `Space + g + p` |
| `:Gpush` | Push | `Space + g + P` |

---

## 🔗 LazyGit Integration

### Starting LazyGit
```bash
# From within Neovim
:LazyGit
:LG

# From command line
lazygit
```

### Essential LazyGit Shortcuts

| Shortcut | Action | Description |
|----------|--------|-------------|
| `q` | Quit | Exit LazyGit |
| `Q` | Force Quit | Force quit LazyGit |
| `c` | Commit | Create commit |
| `C` | Commit All | Stage all and commit |
| `p` | Push | Push to remote |
| `P` | Pull | Pull from remote |
| `l` | Log | View commit log |
| `L` | Ref Log | View ref log |
| `s` | Stage | Stage file/selection |
| `u` | Unstage | Unstage file/selection |
| `S` | Stash | Create stash |
| `z` | Stash Pop | Pop from stash |
| `x` | Discard | Discard changes |
| `r` | Rename | Rename branch |
| `m` | Merge | Merge branch |
| `b` | Branch | Switch branch |
| `n` | New Branch | Create new branch |
| `D` | Delete Branch | Delete branch |
| `w` | Workspace | Worktree operations |
| `e` | Repository | Repository operations |
| `?` | Help | Show help |
| `/` | Search | Search commits |
| `o` | Open | Open file in editor |
| `Enter` | Diff | Toggle diff panel |
| `Space` | Context | Toggle context |
| `Tab` | Horizontal Toggle | Toggle horizontal scroll |

### Navigation in LazyGit

| Shortcut | Action | Description |
|----------|--------|-------------|
| `j` | Down | Move down |
| `k` | Up | Move up |
| `h` | Left | Move left |
| `l` | Right | Move right |
| `Ctrl + u` | Page Up | Page up |
| `Ctrl + d` | Page Down | Page down |
| `gg` | Go Top | Go to top |
| `G` | Go Bottom | Go to bottom |
| `0` | Start | Go to start of line |
| `$` | End | Go to end of line |

---

## 🔄 Integrated Workflows

### Basic Development Workflow

```bash
# 1. Start work on a new feature
git checkout -b feature/new-feature

# 2. Open LazyVim
nvim

# 3. Make changes and see git signs
# Green: added lines, Red: deleted lines, Blue: changed lines

# 4. Stage changes
Space + g + S    # Stage current file
Space + g + s    # Open git status to stage multiple files

# 5. Commit changes
Space + g + c    # Open commit window
Space + g + C    # Quick commit (all staged changes)

# 6. Push to remote
Space + g + P    # Push changes

# 7. Check git log
Space + g + l    # Show git log
Space + g + L    # Show current branch log
```

### Branch Workflow

```bash
# Switch to development branch
Space + g + b    # Select branch
                # Use arrow keys to navigate
                # Enter to switch

# Create new branch
n                # In LazyGit branch view
                # Enter branch name

# Merge branch
m                # In LazyGit branch view
                # Select source branch

# Delete branch
D                # In LazyGit branch view
                # Select branch to delete

# Check branch status from LazyVim
Space + g + b    # Branch manager
```

### Code Review Workflow

```bash
# 1. Open git log
Space + g + l    # Git log

# 2. Select commit to view
j/k              # Navigate commits
Enter            # View commit details

# 3. Checkout commit or branch
o                # Open file in editor
Space + c        # Checkout commit (LazyGit)
Space + b        # Checkout branch (LazyGit)

# 4. Compare branches
Space + g + d    # Compare with HEAD

# 5. Create pull request
P                # Push and create PR (if configured)
```

### Merge Conflict Resolution

```bash
# 1. Identify conflicts
Space + g + s    # Git status will show conflicts
Space + g + m    # Merge (triggers conflicts)

# 2. Open conflict markers
/conflict        # Search for conflict markers
/<<<<<<<         # Find conflict start

# 3. Resolve conflicts
# Use LSP features
g + d            # Go to definition
g + r            # Rename variable
Space + l + f    # Format code

# 4. Stage resolved files
Space + g + S    # Stage current file

# 5. Complete merge
Space + g + c    # Complete commit
```

---

## 🧩 Plugin Ecosystem for Git

### Essential Git Plugins in LazyVim

#### `gitsigns.nvim` - Git Signs
```lua
-- Configuration in ~/.config/nvim/lua/config/options.lua
local opts = {
  signs = {
    add = { hl = "GitSignsAdd", text = "▎", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
    change = { hl = "GitSignsChange", text = "▎", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
    delete = { hl = "GitSignsDelete", text = "", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
    topdelete = { hl = "GitSignsDelete", text = "", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
    changedelete = { hl = "GitSignsDelete", text = "▎", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
  },
  on_attach = function(buffer)
    vim.keymap.set("n", "<leader>ghp", require("gitsigns").preview_hunk, { buffer = buffer, desc = "Preview Git Hunk" })
    vim.keymap.set("n", "<leader>ghr", require("gitsigns").reset_hunk, { buffer = buffer, desc = "Reset Git Hunk" })
  end,
}
require("gitsigns").setup(opts)
```

#### `lazygit.nvim` - LazyGit Integration
```lua
-- Configuration for better LazyGit integration
vim.keymap.set("n", "<leader>gg", ":LazyGit<CR>", { desc = "Open LazyGit" })
vim.keymap.set("n", "<leader>gL", ":LazyGitFilter<CR>", { desc = "LazyGit Log Current File" })
vim.keymap.set("n", "<leader>gB", ":LazyGitFilterBranches<CR>", { desc = "LazyGit Filter Branches" })
```

#### `diffview.nvim` - Advanced Diff Viewer
```lua
-- Enhanced diff viewing
vim.keymap.set("n", "<leader>gd", ":DiffviewOpen<CR>", { desc = "Open DiffView" })
vim.keymap.set("n", "<leader>gD", ":DiffviewClose<CR>", { desc = "Close DiffView" })
vim.keymap.set("n", "<leader>gh", ":DiffviewFileHistory<CR>", { desc = "File History" })
```

### Git-related Configuration

#### Git Blame Integration
```lua
-- Enable git blame with gitsigns
vim.keymap.set("n", "<leader>gb", function()
  vim.cmd("Gitsigns toggle_current_line_blame")
end, { desc = "Toggle Git Blame" })
```

#### Git Commit Template
```ini
# ~/.config/git/commit_template.txt
# %s: subject, %b: body, %an: author name
# Style: Conventional Commits

%s

%b

Closes #<issue-number>
```

#### Git Aliases
```bash
# ~/.config/git/config or ~/.gitconfig
[alias]
  co = checkout
  br = branch
  st = status
  ci = commit
  pl = pull
  ps = push
  lg = log --oneline --graph --decorate
  last = log -1 --pretty=format:'%h %s'
  diff = diff --color
  wdiff = diff --word-diff=color
  root = !git rev-parse --show-toplevel
```

---

## 🚀 Advanced Git Workflows

### Stash Management

```bash
# Create stash with message
:s

# List stashes
:Gstash

# Apply stash
@<number>         # In stash view, select stash

# Pop stash
p<number>         # In stash view, select stash

# Create branch from stash
:b<number>        # Create branch from stash
```

### Cherry-pick Operations

```bash
# 1. Find commit hash
Space + g + l    # View log
Space + y        # Copy hash

# 2. Cherry-pick
:Gpick <hash>   # Cherry-pick specific commit

# 3. Continue cherry-pick
:Gpick --continue
```

### Bisect and Debugging

```bash
# Start bisect
:Gbisect start

# Mark bad commit
:Gbisect bad

# Test commits
:Gbisect good    # Mark as good
:Gbisect bad     # Mark as bad

# End bisect
:Gbisect reset
```

### Tag Management

```bash
# Create tag
:Gtag create <tag-name>

# List tags
:Gtag list

# Push tags
:Gtag push <tag-name>

# Delete tag
:Gtag delete <tag-name>
```

### Remote Workflow

```bash
# Add remote
:Gremote add <name> <url>

# View remotes
:Gremote list

# Fetch
:Gfetch

# Update remotes
:Gremote prune
```

---

## 🔧 Troubleshooting & Tips

### Common Issues

#### Git Signs Not Showing
```bash
# Check git configuration
git config --list | grep -E "(user\.|core\.editor)"

# Ensure git is initialized
git status

# Check permissions
git config --global --get core.editor
```

#### LazyGit Not Starting
```bash
# Check if lazygit is installed
which lazygit
lazygit --version

# Check Neovim configuration
nvim --headless -c "lua print(require('lazy').stats())" -c "quit"
```

#### LSP Not Working for Git Files
```bash
# Check LSP server
:LspInfo

# Check file type
:set filetype?

# Reinitialize LSP
:LspRestart
```

### Performance Tips

```lua
-- ~/.config/nvim/lua/config/options.lua
-- Optimize git signs for large files
vim.g.git_signs_priority = 100

-- Disable git signs in large files
vim.api.nvim_create_autocmd("BufWinEnter", {
  callback = function()
    local line_count = vim.api.nvim_buf_line_count(0)
    if line_count > 5000 then
      vim.b.gitsigns_disabled = true
    end
  end,
})

-- Optimize lazygit loading
vim.keymap.set("n", "<leader>gg", function()
  require("lazygit").lazygit()
end, { desc = "Open LazyGit" })
```

### Key Remapping Tips

```lua
-- ~/.config/nvim/lua/config/keymaps.lua
-- Better git shortcuts
local map = vim.keymap.set

-- Quick git status
map("n", "<leader>gs", "<cmd>Git<CR>", { desc = "Git Status" })

-- Quick lazygit
map("n", "<leader>gg", "<cmd>LazyGit<CR>", { desc = "LazyGit" })

-- Stage and commit
map("n", "<leader>sc", function()
  vim.cmd("write")
  vim.cmd("Git add %")
  vim.cmd("Git commit")
end, { desc = "Stage and Commit File" })
```

### Integration Tips

```lua
-- ~/.config/nvim/lua/plugins/init.lua
-- Git telescope extensions
return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-github.nvim",
    },
    keys = {
      {
        "<leader>gS",
        function()
          require("telescope.builtin").git_status()
        end,
        desc = "Git Status",
      },
    },
  },
}
```

---

## 📚 Quick Reference

### Essential Commands
```bash
# Neovim
nvim                 # Start LazyVim
:LazyGit             # Start LazyGit from Neovim
Space + g + s        # Git status

# Git Commands
git status           # Check status
git add .            # Stage all changes
git commit -m "msg"  # Commit changes
git push             # Push changes
git pull             # Pull changes

# LazyGit
lazygit             # Start LazyGit
q                   # Quit LazyGit
c                   # Create commit
p                   # Push changes
```

### Configuration Files
```bash
# LazyVim configuration
~/.config/nvim/lua/config/
~/.config/nvim/lua/plugins/
~/.config/nvim/init.lua

# Git configuration
~/.gitconfig
~/.config/git/config

# Ghostty configuration
~/.config/ghostty/config
```

### Common Keyboard Shortcuts Summary
```bash
# File Navigation
Space + f + f    # Find files
Space + e        # File explorer
Space + b + b    # Buffer explorer

# Git Operations
Space + g + s    # Git status
Space + g + c    # Commit
Space + g + p    # Push
Space + g + b    # Branches
Space + g + l    # Log

# Window Management
Space + w + v    # Vertical split
Space + w + s    # Horizontal split
Space + w =      # Balance windows

# Terminal
Space + t + t    # Toggle terminal
```

---

## 🎉 Conclusion

LazyVim combined with Git and Lazygit provides a powerful, efficient development environment. This guide has covered:

- ✅ **LazyVim Essentials**: Core navigation and editing features
- ✅ **Git Integration**: Built-in git signs and operations
- ✅ **Lazygit Synergy**: Seamless terminal UI integration
- ✅ **Development Workflows**: Common patterns and processes
- ✅ **Plugin Ecosystem**: Essential git-related plugins
- ✅ **Advanced Features**: Complex workflows and debugging

**Next Steps:**
1. ✅ Install and configure the development environment
2. ✅ Learn the essential shortcuts and workflows
3. ✅ Customize the configuration for your needs
4. ✅ Explore advanced features and plugins
5. ✅ Integrate with your existing tools and workflows

**Additional Resources:**
- 📖 [LazyVim Documentation](https://www.lazyvim.org/)
- 🐙 [Lazygit Documentation](https://github.com/jesseduffield/lazygit)
- 🔧 [Git Documentation](https://git-scm.com/doc)
- 💬 [LazyVim Discord](https://discord.gg/nvim-lazy)

Happy coding with LazyVim! 🚀

---

*Last Updated: November 2025*
*Version: 1.0*