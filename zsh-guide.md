# Zsh Installation and Configuration Guide

## Table of Contents
- [Basic Installation](#basic-installation)
- [Oh My Zsh Customization](#oh-my-zsh-customization)
- [Theme Configuration](#theme-configuration)
  - [Agnoster Theme](#agnoster-theme)
  - [Powerlevel10k Theme (Optional)](#powerlevel10k-theme-optional)
- [Plugin Installation](#plugin-installation)
  - [Zsh Syntax Highlighting](#zsh-syntax-highlighting)
  - [Zsh Auto-Suggestions](#zsh-auto-suggestions)
- [ColorLS Setup](#colorls-setup)

---

## Basic Installation

Install Zsh shell on Ubuntu/Debian systems:

```bash
sudo apt install zsh
```

After installation, you can optionally set Zsh as your default shell:

```bash
chsh -s $(which zsh)
```

---

## Oh My Zsh Customization

Oh My Zsh is a framework for managing your Zsh configuration with themes and plugins.

### Install Oh My Zsh

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

---

## Theme Configuration

### Agnoster Theme

A popular powerline-style theme with Git integration.

```bash
# Open Zsh configuration file
nvim ~/.zshrc

# Add or modify the theme line
ZSH_THEME="agnoster"

# Apply changes
source ~/.zshrc
```

### Powerlevel10k Theme (Optional)

A modern, feature-rich theme with extensive customization options.

#### Installation

```bash
# Clone Powerlevel10k repository
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k

# Add to Zsh configuration
echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc

# Apply changes
source ~/.zshrc
```

After installation, Powerlevel10k will launch its configuration wizard automatically.

---

## Plugin Installation

### Zsh Syntax Highlighting

Provides syntax highlighting for commands as you type.

#### Installation

```bash
# Clone the repository
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Edit configuration
nvim ~/.zshrc

# Add plugin to the plugins array
plugins=(git zsh-syntax-highlighting)

# Apply changes
source ~/.zshrc
```

### Zsh Auto-Suggestions

Suggests commands based on your history as you type.

#### Installation

```bash
# Clone the repository
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Edit configuration
nvim ~/.zshrc

# Add plugin to the plugins array (combine with existing plugins)
plugins=(git zsh-syntax-highlighting zsh-autosuggestions)

# Apply changes
source ~/.zshrc
```

**Note:** You can enable multiple plugins by adding them to the same plugins array, space-separated.

---

## ColorLS Setup

ColorLS adds colors and icons to the `ls` command output.

### Prerequisites

Install Ruby development files:

```bash
sudo apt install ruby-dev
```

### Installation

```bash
# Install ColorLS gem
sudo gem install colorls

# Edit configuration
nvim ~/.zshrc

# Add alias to use colorls instead of ls
alias ls='colorls'

# Apply changes
source ~/.zshrc
```

### Optional ColorLS Flags

You can customize the alias with additional flags:

```bash
# Examples:
alias ls='colorls -lA --sd'  # Long format, almost all, sorted by directories
alias ls='colorls --tree'     # Tree view
```

For more ColorLS options, run: `colorls --help`

---

## Complete Plugin Configuration Example

Here's a complete example of a well-configured `~/.zshrc` plugins section:

```bash
# ~/.zshrc
ZSH_THEME="agnoster"  # or "powerlevel10k/powerlevel10k"

# Plugins
plugins=(
  git
  zsh-syntax-highlighting
  zsh-autosuggestions
)

# Aliases
alias ls='colorls'

# Source Oh My Zsh
source $ZSH/oh-my-zsh.sh
```

---

## Troubleshooting

### Issue: Plugins not loading

```bash
# Make sure plugins are properly installed in the custom directory
ls ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/
```

### Issue: Theme not displaying correctly

- Install a Powerline-compatible font (e.g., Meslo Nerd Font, Fira Code)
- Configure your terminal emulator to use the font

### Issue: ColorLS icons not showing

- Install a Nerd Font and configure your terminal to use it
- Update ColorLS: `sudo gem update colorls`

---

## Additional Resources

- [Oh My Zsh Documentation](https://github.com/ohmyzsh/ohmyzsh)
- [Powerlevel10k GitHub](https://github.com/romkatv/powerlevel10k)
- [Zsh Syntax Highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
- [Zsh Auto-Suggestions](https://github.com/zsh-users/zsh-autosuggestions)
- [ColorLS GitHub](https://github.com/athityakumar/colorls)
