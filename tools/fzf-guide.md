# fzf Command-Line Fuzzy Finder Guide

## Table of Contents
- [Installation](#installation)
- [Quick Start - Essential Commands](#quick-start---essential-commands)
- [Basic Usage](#basic-usage)
- [Multi-Selection](#multi-selection)
- [Key Bindings](#key-bindings)
- [Common Commands](#common-commands)
- [SSH and Directory Navigation](#ssh-and-directory-navigation)
- [Advanced Usage](#advanced-usage)
- [Integration with Shell](#integration-with-shell)
- [Tips and Tricks](#tips-and-tricks)

## Installation

```bash
# Ubuntu/Debian
sudo apt install fzf

# macOS
brew install fzf

# From source
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

## Quick Start - Essential Commands

### Absolute Basics (Start Here!)

```bash
# Search and select a file
fzf

# Search and open file in editor
vim $(fzf)

# Change to a directory
cd **/[TAB]   # Type cd, then **, then TAB

# SSH to a host
ssh **[TAB]   # Type ssh, then **, then TAB

# Multi-select files (use Tab to mark, Enter to confirm)
vim $(fzf -m)

# Search command history
history | fzf

# Find and delete files (multi-select with Tab)
rm $(fzf -m)
```

### Most Common Key Bindings

- `Ctrl-T` - Search files/folders and paste to command line
- `Ctrl-R` - Search command history
- `Alt-C` - Search directories and cd into selected
- `Tab` - Mark item (multi-select mode)
- `Shift-Tab` - Unmark item
- `Enter` - Confirm selection and exit
- `Esc` - Cancel

## Basic Usage

### Simple File Search
```bash
# Find files in current directory
fzf

# Preview files while searching
fzf --preview 'cat {}'

# With better preview using bat
fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}'
```

### Piping Input
```bash
# Search through command output
ls | fzf

# Search through history
history | fzf

# Search processes
ps aux | fzf
```

## Multi-Selection

Multi-selection is one of fzf's most powerful features!

### Enable Multi-Select Mode
```bash
# Use -m flag to enable multi-select
fzf -m
```

### How to Multi-Select
1. Run command with `-m` flag: `fzf -m`
2. Use `Tab` to mark items you want
3. Use `Shift-Tab` to unmark items
4. Press `Enter` to confirm all selected items

### Practical Multi-Select Examples

```bash
# Select multiple files to open
vim $(fzf -m)

# Select multiple files to delete
rm $(fzf -m)

# Select multiple files to copy
cp $(fzf -m) /destination/path/

# Select multiple files to move
mv $(fzf -m) /destination/path/

# Add multiple files to git
git add $(git status --short | fzf -m | awk '{print $2}')

# Select multiple processes to kill
kill $(ps aux | fzf -m | awk '{print $2}')

# Select multiple directories to list
ls -la $(find . -type d | fzf -m)
```

### Multi-Select with Preview
```bash
# Multi-select files with preview window
fzf -m --preview 'bat --color=always --style=numbers {}'

# Multi-select with custom height and layout
fzf -m --height 50% --reverse --preview 'cat {}'
```

## Key Bindings

### Navigation
- `Ctrl-J` / `Ctrl-N` / `Down` - Move down
- `Ctrl-K` / `Ctrl-P` / `Up` - Move up
- `Ctrl-D` / `PageDown` - Scroll preview down
- `Ctrl-U` / `PageUp` - Scroll preview up
- `Ctrl-F` / `PageDown` - Scroll down one page
- `Ctrl-B` / `PageUp` - Scroll up one page

### Selection
- `Enter` - Select item and exit
- `Tab` - Mark multiple items (with `-m` flag)
- `Shift-Tab` - Unmark items
- `Ctrl-A` - Select all
- `Ctrl-D` - Deselect all
- `Ctrl-T` - Toggle selection

### Search
- `Ctrl-R` - Toggle search mode (fuzzy/exact)
- `Ctrl-Space` - Toggle preview
- `Ctrl-/` - Toggle preview
- `Esc` - Cancel and exit

### Editing
- `Ctrl-W` - Delete word backward
- `Alt-Backspace` - Delete word backward
- `Ctrl-U` - Clear query

## Common Commands

### File Operations

```bash
# Edit file with vim
vim $(fzf)

# Open file with default editor
$EDITOR $(fzf)

# Change directory
cd $(find . -type d | fzf)

# Delete files interactively
rm -i $(fzf -m)

# Copy file to destination
cp $(fzf) /destination/path/
```

### Git Integration

```bash
# Checkout branch
git checkout $(git branch -a | fzf | sed 's/^[* ]*//' | sed 's/remotes\/origin\///')

# Show git log and checkout commit
git log --oneline | fzf | awk '{print $1}' | xargs git checkout

# Add files to staging
git add $(git status --short | fzf -m | awk '{print $2}')

# View git diff for a file
git diff $(git ls-files -m | fzf)

# Interactive rebase
git rebase -i $(git log --oneline | fzf | awk '{print $1}')^
```

### Process Management

```bash
# Kill process interactively
kill -9 $(ps aux | fzf | awk '{print $2}')

# View process details
ps aux | fzf --preview 'echo {}' --preview-window down:3:wrap
```

### History Search

```bash
# Execute command from history
$(history | fzf | sed 's/^[ ]*[0-9]*[ ]*//')

# Fuzzy history search (with Ctrl-R binding)
# Add to ~/.bashrc or ~/.zshrc
```

## SSH and Directory Navigation

### The ** Trigger (Most Useful Feature!)

The `**` sequence is a special trigger that activates fzf completion. After typing `**` and pressing `TAB`, fzf will launch an interactive search.

### Directory Navigation with **

```bash
# Basic directory navigation - type this, then TAB
cd **

# This will show all directories below current location
# Navigate with arrow keys, type to filter, press Enter to select

# Change to a specific path
cd ~/Documents/**[TAB]

# Go to a subdirectory
cd ./src/**[TAB]

# Works with any depth
cd /usr/local/**[TAB]
```

### SSH with **

```bash
# Interactive SSH host selection - type this, then TAB
ssh **

# This reads from:
# - ~/.ssh/config
# - /etc/ssh/ssh_config
# - ~/.ssh/known_hosts

# You can also combine with hostname patterns
ssh user@**[TAB]

# SSH with specific user
ssh myuser@**[TAB]
```

### File Selection with **

```bash
# Select any file - type this, then TAB
vim **

# Open files from specific directory
cat ~/logs/**[TAB]

# Works with any command
less **[TAB]
cp **[TAB] /destination/
mv **[TAB] ./new-location/

# Multiple files with ** (must enable multi-select in config)
rm **[TAB]  # Use Tab to mark multiple files
```

### Environment Variables with **

```bash
# Select from environment variables
echo $**[TAB]

# Unset a variable interactively
unset **[TAB]

# Export a variable
export **[TAB]
```

### Process Selection with **

```bash
# Kill a process interactively
kill **[TAB]

# Send signal to process
kill -9 **[TAB]
```

### How to Enable ** Trigger

Add to `~/.bashrc` or `~/.zshrc`:

```bash
# Enable fzf key bindings (includes ** trigger)
[ -f ~/.fzf.bash ] && source ~/.fzf.bash  # For bash
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh    # For zsh

# Or if installed via package manager
source /usr/share/doc/fzf/examples/key-bindings.bash  # For bash
source /usr/share/doc/fzf/examples/key-bindings.zsh   # For zsh
```

### Custom ** Trigger Settings

```bash
# Configure what directories to search
export FZF_COMPLETION_TRIGGER='**'

# Configure options for completion
export FZF_COMPLETION_OPTS='--preview "bat --color=always --style=numbers --line-range=:500 {}"'

# Custom command for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude .git . "$1"
}

# Custom command for file completion
_fzf_compgen_path() {
  fd --hidden --follow --exclude .git . "$1"
}
```

### SSH Config for Better ** Integration

Create or edit `~/.ssh/config`:

```
Host server1
    HostName 192.168.1.100
    User admin

Host server2
    HostName example.com
    User root
    Port 2222

Host dev-*
    User developer
    IdentityFile ~/.ssh/dev_key

Host *.local
    User localuser
```

Now `ssh **[TAB]` will show all these hosts with fuzzy search!

### Quick Tips for ** Usage

1. **Always press TAB** after typing `**`
2. **Use Tab** to mark multiple items (if multi-select is enabled)
3. **Type to filter** - fzf will fuzzy match as you type
4. **Ctrl-R** in the middle of a command to search history
5. **Create shortcuts** for commonly used ** patterns

```bash
# Add these to your shell rc file
alias cdd='cd **'           # Quick directory jump (then TAB)
alias vssh='ssh **'         # Quick SSH (then TAB)
alias vv='vim **'           # Quick file open (then TAB)
```

## Advanced Usage

### Preview Options

```bash
# Preview with syntax highlighting
fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'

# Preview with file type detection
fzf --preview '[[ $(file --mime {}) =~ binary ]] && echo "Binary file" || bat --style=numbers --color=always {}'

# Preview directories
fzf --preview 'tree -C {} | head -200'

# Preview with line numbers
fzf --preview 'cat -n {}'
```

### Multi-Selection

```bash
# Enable multi-select mode
fzf -m

# Select multiple files and open in vim
vim $(fzf -m)

# Delete multiple files
rm $(fzf -m)
```

### Search Syntax

```bash
# Exact match (quoted)
fzf --query "'word"

# Prefix exact match
fzf --query "^prefix"

# Suffix exact match
fzf --query "suffix$"

# Exclude term
fzf --query "!exclude"

# OR operator
fzf --query "term1 | term2"

# AND operator (default behavior)
fzf --query "term1 term2"
```

### Custom Options

```bash
# Reverse layout
fzf --reverse

# Custom height
fzf --height 40%

# With border
fzf --border

# Custom prompt
fzf --prompt "Select file: "

# Multiple selections with preview
fzf -m --preview 'cat {}' --preview-window right:50%

# Case-insensitive by default
fzf -i
```

## Integration with Shell

### Bash/Zsh Key Bindings

Add to `~/.bashrc` or `~/.zshrc`:

```bash
# Ctrl-T - Paste selected files/directories
export FZF_CTRL_T_COMMAND="find . -type f -o -type d"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:500 {}'"

# Ctrl-R - Command history
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:wrap"

# Alt-C - Change directory
export FZF_ALT_C_COMMAND="find . -type d"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"

# Default options
export FZF_DEFAULT_OPTS="--height 40% --reverse --border"
```

### Custom Functions

```bash
# Fuzzy find and edit
fe() {
  local file
  file=$(fzf --preview 'bat --style=numbers --color=always --line-range :500 {}')
  [ -n "$file" ] && ${EDITOR:-vim} "$file"
}

# Fuzzy cd
fcd() {
  local dir
  dir=$(find ${1:-.} -type d 2> /dev/null | fzf +m) && cd "$dir"
}

# Fuzzy kill process
fkill() {
  local pid
  pid=$(ps aux | sed 1d | fzf -m | awk '{print $2}')
  if [ -n "$pid" ]; then
    echo "$pid" | xargs kill -${1:-9}
  fi
}

# Git fuzzy branch checkout
fgb() {
  local branch
  branch=$(git branch -a | grep -v HEAD | fzf | sed 's/^[* ]*//' | sed 's/remotes\/origin\///')
  git checkout "$branch"
}

# Fuzzy grep with preview
fgrep() {
  local file
  local line
  read -r file line < <(
    grep -rn "$1" . 2>/dev/null |
    fzf --delimiter ':' --preview 'bat --style=numbers --color=always --highlight-line {2} {1}' |
    awk -F: '{print $1, $2}'
  )
  [ -n "$file" ] && ${EDITOR:-vim} "$file" +${line:-0}
}

# Docker container selection
fdocker() {
  local container
  container=$(docker ps -a | sed 1d | fzf | awk '{print $1}')
  [ -n "$container" ] && docker exec -it "$container" /bin/bash
}
```

## Tips and Tricks

### Performance Optimization

```bash
# Use fd instead of find for faster results
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

# Use ripgrep for faster searching
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
```

### Color Schemes

```bash
# Monokai theme
export FZF_DEFAULT_OPTS='
  --color=bg+:#293739,bg:#1B1D1E,border:#808080,spinner:#E6DB74,hl:#7E8E91
  --color=fg:#F8F8F2,header:#7E8E91,info:#A6E22E,pointer:#A6E22E
  --color=marker:#F92672,fg+:#F8F8F2,prompt:#F92672,hl+:#F92672
'

# Solarized Dark
export FZF_DEFAULT_OPTS='
  --color=bg+:#073642,bg:#002b36,spinner:#719e07,hl:#586e75
  --color=fg:#839496,header:#586e75,info:#cb4b16,pointer:#719e07
  --color=marker:#719e07,fg+:#839496,prompt:#719e07,hl+:#719e07
'
```

### Useful Aliases

```bash
# Quick file preview
alias fp='fzf --preview "bat --style=numbers --color=always {}"'

# Find and cd
alias fcd='cd $(find . -type d | fzf)'

# Find and open
alias fo='vim $(fzf)'

# Git checkout branch
alias gcb='git checkout $(git branch | fzf | sed "s/^[* ]*//")'

# Process kill
alias fk='kill -9 $(ps aux | fzf | awk "{print \$2}")'
```

### Integration with Other Tools

```bash
# With ripgrep for content search
rg --files | fzf --preview "bat --color=always {}"

# With fd for file search
fd --type f | fzf --preview "bat --color=always {}"

# With tree for directory preview
find . -type d | fzf --preview "tree -C {} | head -n 50"

# With git for branch management
git branch | fzf --preview "git log --oneline --graph --date=short --pretty='format:%C(auto)%cd %h%d %s' {}"

# With docker
docker images | fzf --header-lines=1 --preview "docker inspect {3}"
```

### Workflow Examples

```bash
# Complete workflow: search, preview, and edit
alias fwe='vim $(rg --files | fzf --preview "bat --color=always --style=numbers {}")'

# Search in files and edit at line
alias fse='vim +$(rg -n . | fzf | cut -d: -f2) $(rg -n . | fzf | cut -d: -f1)'

# Find recently modified files
alias recent='find . -type f -mtime -7 | fzf --preview "bat --color=always {}"'

# Find large files
alias large='du -ah . | sort -rh | head -n 50 | fzf --preview "ls -lh {2}"'
```

## Resources

- [Official fzf Repository](https://github.com/junegunn/fzf)
- [fzf Wiki](https://github.com/junegunn/fzf/wiki)
- [Advanced fzf Examples](https://github.com/junegunn/fzf/wiki/examples)

## Common Issues

### No matches found
- Check your search query syntax
- Try case-insensitive search with `-i`
- Verify the input stream has content

### Preview not working
- Install `bat` for better syntax highlighting: `cargo install bat`
- Check preview command syntax
- Ensure preview window size is appropriate

### Performance issues
- Use `fd` or `rg` instead of `find`
- Limit search depth with `--max-depth`
- Use `--no-preview` for large file sets

### Key bindings not working
- Source fzf key bindings: `source ~/.fzf.bash` or `source ~/.fzf.zsh`
- Check for conflicts with existing bindings
- Reload shell configuration
