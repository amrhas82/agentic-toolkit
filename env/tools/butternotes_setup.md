# 🧈 ButterNotes

![Made for Debian](https://img.shields.io/badge/Made_for-Debian-A81D33?style=for-the-badge)
![Made for Linux](https://img.shields.io/badge/Made_for-Linux-FCC624?style=for-the-badge)
![Terminal Based](https://img.shields.io/badge/Terminal-Based-4EAA25?style=for-the-badge)

A streamlined note-taking and todo management tool with smart fzf-enhanced project management.
Following the "inbox first, organize later" philosophy for maximum productivity.

> **Universal Shell Support** - Works with bash, zsh, fish, or any shell. Originally designed for [ButterBash](https://codeberg.org/justaguylinux/butterbash) but now works independently. Part of the [JustAGuy Linux](https://codeberg.org/justaguylinux) productivity toolkit.

## 📜 Philosophy

ButterNotes embraces the **inbox workflow**:
- **Quick Capture First** - Never lose a thought while deciding where it goes
- **Organize Later** - Clean separation between rapid note-taking and structured documentation  
- **Plain Text Power** - Markdown files that sync with any mobile app
- **Terminal Focused** - Fast, keyboard-driven, distraction-free

**Two complementary workflows:**
1. **Inbox** (`notes.md` + `todos.md`) - Stream of consciousness, rapid capture
2. **Projects** (`projects/*.md`) - Organized documentation with fzf management

---

## ✨ Features

- **🚀 Fast Capture**: Instant note and todo entry from anywhere
- **📝 Inbox System**: Stream-of-consciousness notes with timestamps  
- **✅ Smart Todos**: Persistent numbering, markdown checkboxes, easy toggling
- **📁 Project Manager**: fzf-powered file management with preview and templates
- **🔍 Basic Search**: Simple text search within notes
- **📱 Mobile Sync**: Standard markdown files work with any mobile app
- **🎯 Terminal Native**: Clean sub-prompts, keyboard shortcuts, no GUI bloat
- **⚡ Shell Integration**: Seamless aliases and PATH integration

---

## 🚀 Installation

### Quick Install (Recommended)

ButterNotes works with any shell and offers intelligent integration options:

```bash
# Clone and install
git clone https://codeberg.org/justaguylinux/butternotes.git
cd butternotes && ./install.sh

# The installer will:
# 1. Install butter executable to ~/.local/bin/
# 2. Auto-detect your shell (bash/zsh/fish) and offer integration options
# 3. Optionally install ButterBash if you want the full modular shell experience
```

### Shell Integration Options

The installer auto-detects your shell and offers integration:

```bash
📁 Where should the aliases be added?
  1) ~/.bashrc (bash users)
  2) ~/.zshrc (zsh users)
  3) ButterBash (~/.config/bash/aliases.bash)
  4) Create separate file for manual sourcing
  5) Skip aliases
```

### Quick Install (ButterScripts)

The easiest way is through [ButterScripts](https://codeberg.org/justaguylinux/butterscripts):

```bash
git clone https://codeberg.org/justaguylinux/butterscripts.git
cd butterscripts/setup && ./optional_tools.sh
# Select option 2: ButterNotes
```

**What the installer does:**
- Installs `butter` executable to `~/.local/bin/`
- Creates config at `~/.config/butternotes/butter.conf`
- Auto-detects your shell and offers integration options
- Sets up mobile-sync friendly notes directory
- Checks for optional dependencies (fzf required for project management)

### Dependencies

**Required:**
- `bash` - Core functionality
- `xclip` or `wl-clipboard` - Clipboard integration

**Optional:**
- `fzf` - Required for project management features (without fzf, only basic project commands work)

---

## 🎯 Quick Start

### Inbox Capture
```bash
# Add notes instantly
butter "Random brilliant idea"
butter clip                    # Save clipboard as note

# Manage todos  
butter todo "Fix the thing"
butter todos                   # List all todos
```

### Project Management
```bash
# Launch project manager (requires fzf)
butter project
# ┌─ Project Manager ─────────────────────┐
# │ 📝 New project                        │
# │ 🗑️  Delete project                    │  
# │ 🚪 Exit                               │
# │ ───────────────────────────────────── │
# │ homelab                   [preview]   │
# │ python                                │
# │ nextcloud                             │
# └───────────────────────────────────────┘
```

### Interactive Mode
```bash
$ b                           # Launch butter
🧈 Butter - Interactive Mode

Commands:
  n    - Notes mode            (quick capture)
  t    - Todo mode             (task management)  
  p    - Projects mode         (requires fzf)
  l    - List notes
  c    - Clear screen
  q    - Quit

butter> p                     # Opens project manager (requires fzf)
butter> n                     # Enter notes sub-prompt
butter/notes> a Hello world   # Add note
butter/notes> ..              # Back to main
```

---

## 📚 Core Workflows

### 1. Inbox Philosophy

**The Problem**: Deciding where a note belongs interrupts your thinking.

**The Solution**: Capture everything in the inbox first, organize later.

```bash
# Rapid capture - no decisions needed
butter "Meeting notes from standup"
butter "Bug in the authentication flow"  
butter clip                              # Save interesting article
butter todo "Review pull request #123"
```

**Result**: `~/Documents/ButterNotes/notes.md`
```markdown
[2025-01-15 09:30:15] Meeting notes from standup
[2025-01-15 09:31:22] Bug in the authentication flow
[2025-01-15 09:32:18] Interesting article about...
```

### 2. Project Organization

When you're ready to organize, use the **project manager** (requires fzf):

```bash
butter project               # Launch manager
# Select "📝 New project" → Create "authentication"
# Move relevant notes to projects/authentication.md
```

**Project manager controls** (when fzf is available):
- `Enter` - Edit selected project
- `Ctrl-N` - Create new project (with template choice)
- `Ctrl-D` - Delete project
- `Tab` - Toggle preview
- `Escape` - Exit manager

**Project templates available:**
- **Blank** - Simple title, free-form content (default)
- **Daily log** - Morning/Afternoon/Evening/Tomorrow structure
- **Simple list** - Bullet point format for brainstorming

### 3. Todo Management

```bash
butter todo "Fix authentication bug"     # Add todo
butter todos                             # List all

# Interactive todo management  
butter> t
✅ Todo Mode
butter/todos> a "New task"               # Add
butter/todos> d 3                        # Toggle done #3  
butter/todos> rm 5                       # Remove #5
```

---

## 🗂️ File Structure

```
~/Documents/ButterNotes/          # Default (configurable)
├── notes.md                      # 📥 Inbox - all notes  
├── todos.md                      # ✅ Task list
└── projects/                     # 📁 Organized docs
    ├── homelab.md
    ├── python.md
    └── authentication.md
```

**Mobile Sync**: Place `ButterNotes/` in your cloud folder (Nextcloud, Dropbox, etc.) for automatic mobile sync with markdown apps.

---

## ⌨️ Shell Integration

After installation, these aliases are available:

```bash
b         # Launch interactive mode
bc        # Save clipboard as note  
bt "task" # Add todo
```

**Advanced usage:**
```bash
butter "Quick note"                    # Direct note
butter todo "Important task"          # Direct todo  
butter project python                 # View python project
butter project python edit           # Edit python project
```

---

## 🎨 Customization

### Storage Location
```bash
./install.sh
# Choose from:
# 1) ~/Documents/ButterNotes/     (mobile sync)
# 2) ~/notes/                     (simple)  
# 3) ~/Nextcloud/Notes/           (Nextcloud)
# 4) Custom location
```

### Configuration
Edit `config/butter.conf`:
```bash
# Notes storage location
BUTTER_NOTES_DIR="$HOME/Documents/ButterNotes"

# Editor preference  
BUTTER_EDITOR="${EDITOR:-nvim}"
```

---

## 🔧 Troubleshooting

### Project Manager Issues
- **"Project manager not working"**: Requires `fzf` to be installed (`sudo apt install fzf` on Debian/Ubuntu)
- **Without fzf**: Only basic project commands work (`butter project <name>` to view/edit specific projects)

### Clipboard Issues
- **Linux**: Requires `xclip` or `wl-clipboard` (`sudo apt install xclip`)
- **"Clipboard content too large"**: Limited to 100KB for safety

### File Permissions
- **Notes not saving**: Check that `~/Documents/ButterNotes/` is writable
- **Executable not found**: Ensure `~/.local/bin/` is in your PATH

### Desktop Integration Tips
- **Quick clipboard capture**: Bind `butter clip && notify-send "Note saved"` to a keyboard shortcut for instant clipboard saving with visual feedback

---

## 🤝 Similar Projects

ButterNotes draws inspiration from:
- **Getting Things Done** - Inbox methodology
- **Zettelkasten** - Linked note-taking
- **Plain text workflows** - Future-proof, tool-agnostic  

**Why ButterNotes?**
- Simpler than Obsidian for basic workflows
- More organized than basic note scripts
- Faster than GUI apps for terminal users
- Better mobile sync than terminal-only solutions

---

## 🛠️ Development

### Philosophy
- **Keep notes/todos simple** - They work perfectly for fast capture
- **Enhance projects** - Files benefit from management features  
- **Terminal first** - No GUI bloat
- **Plain text** - Tool-independent, future-proof

### Contributing
1. Fork the repository
2. Create your feature branch
3. Test with `./bin/butter --help`
4. Submit a pull request

---

## 📄 License

MIT License - Use it, modify it, share it.

---

## ☕ Support

If ButterNotes has been helpful, consider buying me a coffee:

<a href="https://www.buymeacoffee.com/justaguylinux" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png" alt="Buy me a coffee" /></a>

## 📺 Watch on YouTube

Want to see productivity workflows in action?  
🎥 Check out [JustAGuy Linux on YouTube](https://www.youtube.com/@JustAGuyLinux)

---

## 🙋 Community

- **Issues**: [Codeberg Issues](https://codeberg.org/justaguylinux/butternotes/issues)
- **Discussions**: Share workflows and tips
- **Pull Requests**: Contributions welcome

---

Made with 🧈 by [JustAGuyLinux](https://www.youtube.com/@justaguylinux)
