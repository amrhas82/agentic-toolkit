# 🧈 ButterBash
![Made for Debian](https://img.shields.io/badge/Made%20for-Debian-A81D33?style=for-the-badge&logo=debian&logoColor=white)

A smooth, modular Bash configuration framework that makes your shell experience butter-smooth.

## ✨ Features

- **Modular Design**: Clean separation of concerns with individual files for aliases, functions, and configurations
- **FZF Integration**: Fuzzy finding for files and processes
- **Git-Aware Prompt**: Shows current branch in your prompt
- **Extensive Aliases**: Productivity shortcuts for common tasks
- **Archive Extraction**: Universal `extract` command for all archive types
- **System Functions**: Quick system info, colored man pages, and more
- **Extension Ready**: Works perfectly with [ButterNotes](https://codeberg.org/justaguylinux/butternotes) for note-taking and todo management

## 📦 Installation

### Recommended: Install via ButterScripts

The easiest way to install ButterBash is through the [ButterScripts](https://codeberg.org/justaguylinux/butterscripts) optional installer:

```bash
# Clone and run butterscripts installer
git clone https://codeberg.org/justaguylinux/butterscripts.git
cd butterscripts/setup
./optional_tools.sh
# Select option 1: ButterBash ⭐
```

ButterBash is featured as the top option in ButterScripts' optional tools, providing seamless integration with the broader ecosystem of development tools.

### Direct Install

1. Clone the repository:
```bash
git clone https://codeberg.org/justaguylinux/butterbash.git
cd butterbash
```

2. Run the install script:
```bash
./install.sh
```

3. Reload your shell:
```bash
source ~/.bashrc
```

> **Important**: ButterBash will backup your existing `.bashrc` and replace it with a modular configuration. This is the intended behavior for the full ButterBash experience.

## 🗂️ Structure

```
~/.config/bash/
├── aliases.bash        # Command shortcuts
├── prompt.bash         # Custom prompt with git branch
├── keybinds.bash       # Keyboard shortcuts
├── fzf.bash           # FZF configuration
└── functions/
    ├── system.bash    # System utilities
    └── utils.bash     # General utilities
```

## 🎯 Core Functions

### Utility Functions
```bash
mkcd directory        # Create and enter directory
extract file.tar.gz   # Extract any archive type
backup file.txt       # Create timestamped backup
calc 2+2             # Quick calculations
sysinfo              # Display system information
```

## ⚙️ Configuration

### Customization

Add your own customizations by creating files in `~/.config/bash/`:

1. Create a new module: `~/.config/bash/custom.bash`
2. It will be automatically loaded on next shell start

### Local Overrides

For machine-specific settings, create `~/.bashrc.local`:
```bash
# ~/.bashrc.local
export CUSTOM_VAR="value"
alias myalias="command"

# Add custom configurations here
```

### Integration with Other Projects

ButterBash works seamlessly with other projects in the ButterScripts ecosystem:
- **[ButterScripts](https://codeberg.org/justaguylinux/butterscripts)** - Comprehensive setup scripts for Debian systems
- **[ButterNotes](https://codeberg.org/justaguylinux/butternotes)** - Note-taking and todo management extension
- Integrates with terminal emulators like WezTerm
- Compatible with window managers (DWM, BSPWM, etc.)
- Works alongside other development tools and configurations

#### Want Note-Taking and Todo Management?

ButterBash focuses on shell configuration. For productivity features like notes and todos, install **[ButterNotes](https://codeberg.org/justaguylinux/butternotes)**:

```bash
git clone https://codeberg.org/justaguylinux/butternotes.git
cd butternotes && ./install.sh
```

ButterNotes works perfectly alongside ButterBash and adds:
- Intelligent note-taking with clipboard integration
- Todo management with markdown checkboxes
- Project organization with FZF
- Mobile sync compatibility
- Interactive terminal UI

## 🚀 Key Bindings

- **Ctrl+L**: Clear screen
- **↑/↓**: Search command history
- **Ctrl+R**: Reverse history search (with FZF if available)

## 📋 Requirements

- Bash 4.0+
- Optional but recommended:
  - `fzf` - Fuzzy finder
  - `ripgrep` - Fast grep alternative
  - `eza` or `exa` - Modern ls replacement
  - `xclip` - Clipboard integration (X11)
  - `wl-clipboard` - Clipboard integration (Wayland)

Install optional dependencies:
```bash
install_tools  # Built-in function to install fzf and ripgrep
```

## 🤝 Contributing

Contributions are welcome! Please visit our [Codeberg repository](https://codeberg.org/justaguylinux/butterbash) to:

- Report issues: https://codeberg.org/justaguylinux/butterbash/issues
- Submit pull requests
- Join discussions

For major changes, please open an issue first to discuss your ideas.

## 📝 License

MIT

## 🙏 Acknowledgments

- Inspired by various dotfile repositories
- Built with love for the Bash community

---

## ☕ Support

If ButterBash has been helpful, consider buying me a coffee:

<a href="https://www.buymeacoffee.com/justaguylinux" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png" alt="Buy me a coffee" /></a>

---

Made with 🧈 by [JustAGuyLinux](https://www.youtube.com/@justaguylinux)
