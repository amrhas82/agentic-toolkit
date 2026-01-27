# Lazygit Complete Guide: Version Control in Neovim

A comprehensive guide for Git and Lazygit workflows within LazyVim.

---

## 🚀 Introduction

**Lazygit** is a simple terminal UI for Git commands. When combined with **LazyVim**, it creates a powerful development environment for version control management without leaving your editor.

This guide covers:
- ✅ **Git Integration**: Version control within Neovim
- ✅ **Lazygit Essentials**: Terminal UI workflows
- ✅ **Development Patterns**: Common Git workflows
- ✅ **Plugins**: Essential Git-related plugins

---

## 📦 Installation & Setup

### Prerequisites
```bash
# Ensure Neovim is installed
nvim --version  # Should be v0.9+

# Install Git
git --version

# Install Lazygit
# macOS
brew install lazygit

# Ubuntu/Debian
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
```

### Master Setup Script
```bash
cd /home/hamr/Documents/PycharmProjects/agentic-toolkit/tools
./master-lazygit.sh
```

### Verify Installation
```bash
# Check Git
git --version

# Check Lazygit
lazygit --version

# Check LazyVim installation
nvim --headless -c "lua print('LazyVim loaded')" -c "quit"
```

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

## 🔗 Lazygit Integration

### Starting Lazygit

```bash
# From within Neovim
:LazyGit
:LG

# From command line
lazygit
```

### Essential Lazygit Shortcuts

| Shortcut | Action | Description |
|----------|--------|-------------|
| `q` | Quit | Exit Lazygit |
| `Q` | Force Quit | Force quit Lazygit |
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

### Navigation in Lazygit

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
n                # In Lazygit branch view
                # Enter branch name

# Merge branch
m                # In Lazygit branch view
                # Select source branch

# Delete branch
D                # In Lazygit branch view
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
Space + c        # Checkout commit (Lazygit)
Space + b        # Checkout branch (Lazygit)

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
# Use LSP features or manual editing
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
    delete = { hl = "GitSignsDelete", text = "", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
    topdelete = { hl = "GitSignsDelete", text = "", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
    changedelete = { hl = "GitSignsDelete", text = "▎", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
  },
  on_attach = function(buffer)
    vim.keymap.set("n", "<leader>ghp", require("gitsigns").preview_hunk, { buffer = buffer, desc = "Preview Git Hunk" })
    vim.keymap.set("n", "<leader>ghr", require("gitsigns").reset_hunk, { buffer = buffer, desc = "Reset Git Hunk" })
  end,
}
require("gitsigns").setup(opts)
```

#### `lazygit.nvim` - Lazygit Integration

```lua
-- Configuration for better Lazygit integration
vim.keymap.set("n", "<leader>gg", ":LazyGit<CR>", { desc = "Open Lazygit" })
vim.keymap.set("n", "<leader>gL", ":LazyGitFilter<CR>", { desc = "Lazygit Log Current File" })
vim.keymap.set("n", "<leader>gB", ":LazyGitFilterBranches<CR>", { desc = "Lazygit Filter Branches" })
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

#### Lazygit Not Starting
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
end, { desc = "Open Lazygit" })
```

### Key Remapping Tips

```lua
-- ~/.config/nvim/lua/config/keymaps.lua
-- Better git shortcuts
local map = vim.keymap.set

-- Quick git status
map("n", "<leader>gs", "<cmd>Git<CR>", { desc = "Git Status" })

-- Quick lazygit
map("n", "<leader>gg", "<cmd>LazyGit<CR>", { desc = "Lazygit" })

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
:LazyGit             # Start Lazygit from Neovim
Space + g + s        # Git status

# Git Commands
git status           # Check status
git add .            # Stage all changes
git commit -m "msg"  # Commit changes
git push             # Push changes
git pull             # Pull changes

# Lazygit
lazygit             # Start Lazygit
q                   # Quit Lazygit
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
```

### Common Keyboard Shortcuts Summary
```bash
# Git Operations
Space + g + s    # Git status
Space + g + c    # Commit
Space + g + p    # Push
Space + g + b    # Branches
Space + g + l    # Log

# Lazygit
Space + g + g    # Open Lazygit
c                # Create commit
p                # Push
Space            # Toggle context
```

---

## 🎉 Conclusion

Lazygit combined with LazyVim provides a powerful, efficient version control environment. This guide has covered:

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
- 📖 [Lazygit Documentation](https://github.com/jesseduffield/lazygit)
- 🔧 [Git Documentation](https://git-scm.com/doc)
- 📋 [Conventional Commits](https://www.conventionalcommits.org/)
- 💬 [LazyVim Discord](https://discord.gg/nvim-lazy)

Happy version control with Lazygit! 🚀

---

*Last Updated: December 2025*
*Version: 1.0*
