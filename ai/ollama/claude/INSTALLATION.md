# Installation Guide - Claude Model Switcher

## Quick Installation

```bash
cd ~/Documents/PycharmProjects/agentic-toolkit/ai/ollama/claude
bash install.sh install
source ~/.bashrc
cc-status
```

## Installation Methods

### Method 1: Interactive Installation (Recommended)

```bash
cd ~/Documents/PycharmProjects/agentic-toolkit/ai/ollama/claude
bash install.sh install
```

The installer will:
- Prompt for your ANTHROPIC_AUTH_TOKEN
- Show existing key (first 8 chars) if already configured
- Create necessary directories
- Install scripts and make them executable
- Add aliases to shell configuration files
- Test the installation
- Show you next steps

### Method 2: Quick Installation (Skip Prompts)

```bash
bash install.sh quick
```

Uses existing API key or placeholder. You can configure your key later by re-running the full installation.

### Method 3: Manual Installation

```bash
# Create directories
mkdir -p ~/.claude/backups

# Copy files
cp ~/Documents/PycharmProjects/agentic-toolkit/ai/ollama/claude/switch-model-enhanced.sh ~/.claude/
cp ~/Documents/PycharmProjects/agentic-toolkit/ai/ollama/claude/aliases.sh ~/.claude/
cp ~/Documents/PycharmProjects/agentic-toolkit/ai/ollama/claude/settings.example.json ~/.claude/settings.json

# Make executable
chmod +x ~/.claude/switch-model-enhanced.sh

# Add aliases to shell config
echo '[ -f ~/.claude/aliases.sh ] && source ~/.claude/aliases.sh' >> ~/.bashrc

# Reload current session
source ~/.bashrc
```

## API Key Management

### During Installation

The installer will prompt:

```
Enter your ANTHROPIC_AUTH_TOKEN:
This is your API key from https://console.anthropic.com
(Press Enter to keep existing key or skip)

API Key: [your-key-here]
```

### Where Your API Key is Stored

- **Location**: `~/.claude/.auth-token`
- **Permissions**: 600 (owner read/write only)
- **Security**: Not visible in status output
- **Persistence**: Preserved across mode switches

### Getting Your API Key

1. Visit https://console.anthropic.com
2. Sign in to your account
3. Navigate to API Keys section
4. Generate or copy your key
5. Use it during installation

### Updating Your API Key

Simply re-run the installer:

```bash
bash install.sh install
```

Or update manually:

```bash
echo "your-new-key" > ~/.claude/.auth-token
chmod 600 ~/.claude/.auth-token
```

## Global Command Availability

### How It Works

The installer automatically adds this line to your shell configuration:

```bash
[ -f ~/.claude/aliases.sh ] && source ~/.claude/aliases.sh
```

### Configuration Files Updated

- `~/.bashrc` - Interactive shells
- `~/.bash_profile` - Login shells (if exists)
- `~/.bash_aliases` - Debian/Ubuntu convention (if exists)

### Making Commands Work Immediately

After installation, activate in your current session:

```bash
source ~/.bashrc
```

Or simply open a new terminal window - commands will work automatically.

### Commands Work Everywhere

- All new terminal windows
- After reboots
- In tmux/screen sessions
- SSH sessions
- No manual sourcing needed

## Directory Structure After Installation

```
~/.claude/
├── settings.json              # Current model configuration
├── switch-model-enhanced.sh   # Main switcher script
├── aliases.sh                 # Command aliases
├── .auth-token                # Your API key (600 permissions)
└── backups/                   # Automatic backups
    └── settings_*.json        # Timestamped backups
```

## Verification

### Check Installation Status

```bash
bash install.sh status
```

This shows:
- Directory existence
- File presence
- Alias configuration
- Command availability

### Test Commands

```bash
# Check if alias exists
type cc-status

# Should show:
# cc-status is aliased to `bash ~/.claude/switch-model-enhanced.sh cc-status'

# Run the command
cc-status
```

### Verify Files

```bash
# Check files exist
ls -lh ~/.claude/{aliases.sh,switch-model-enhanced.sh}

# Check API key
ls -la ~/.claude/.auth-token

# Should show: -rw------- (600 permissions)
```

## Shell Configuration

### For Bash Users

Aliases are added to:
- `~/.bashrc`
- `~/.bash_profile` (if it exists)
- `~/.bash_aliases` (if it exists)

### For Zsh Users

The installer detects Zsh and adds to:
- `~/.zshrc`

### Verification

Check if aliases are configured:

```bash
grep "source.*claude/aliases.sh" ~/.bashrc
```

Should show:

```
[ -f ~/.claude/aliases.sh ] && source ~/.claude/aliases.sh
```

## Dependencies

### Required

- Bash 4.0+
- Standard Unix tools (grep, sed, cat)

### Optional

- `jq` - For better JSON parsing (highly recommended)

Install jq:

```bash
# Ubuntu/Debian
sudo apt install jq

# macOS
brew install jq

# Fedora/RHEL
sudo dnf install jq
```

## Uninstallation

```bash
bash install.sh uninstall
```

This will:
- Remove aliases from shell config
- Optionally backup ~/.claude directory
- Clean up shell configuration

Manual uninstall:

```bash
# Remove aliases from shell config
sed -i '/claude\/aliases.sh/d' ~/.bashrc
sed -i '/claude\/aliases.sh/d' ~/.bash_profile

# Backup and remove directory
mv ~/.claude ~/.claude.backup

# Reload shell
source ~/.bashrc
```

## Troubleshooting Installation

### Commands Not Found After Installation

**Solution**: Reload your shell:

```bash
source ~/.bashrc
```

Or open a new terminal window.

### Permission Denied Errors

**Solution**: Make scripts executable:

```bash
chmod +x ~/.claude/switch-model-enhanced.sh
```

### Aliases Not Persisting

**Solution**: Ensure bashrc sources the aliases:

```bash
grep "source.*claude/aliases.sh" ~/.bashrc
```

If not present, add it:

```bash
echo '[ -f ~/.claude/aliases.sh ] && source ~/.claude/aliases.sh' >> ~/.bashrc
source ~/.bashrc
```

### API Key Not Saved

**Solution**: Check file permissions:

```bash
ls -la ~/.claude/.auth-token
```

Should show: `-rw------- (600)`

If not, fix permissions:

```bash
chmod 600 ~/.claude/.auth-token
```

## Post-Installation

### First Steps

1. Check current status:
   ```bash
   cc-status
   ```

2. Try switching modes:
   ```bash
   cc-mixed
   ```

3. Verify the switch:
   ```bash
   cc-status
   ```

### Recommended Setup

Use mixed mode for best value:

```bash
cc-mixed
```

This gives you:
- Claude Sonnet (premium) for heavy lifting
- GLM Haiku (fast/cheap) for lighter tasks

### Backup Your Settings

Settings are automatically backed up on every switch, but you can manually backup:

```bash
cp ~/.claude/settings.json ~/.claude/settings.json.backup
```

## Advanced Installation

### Custom Installation Directory

To install to a custom location:

```bash
# Set custom directory
export CLAUDE_HOME=/path/to/custom/location

# Run installer
bash install.sh install
```

### Multiple Profiles

You can maintain multiple configuration files:

```bash
~/.claude/
├── settings.json           # Current active config
├── settings.native.json    # Native Claude
├── settings.glm.json       # GLM config
└── settings.mixed.json     # Mixed config
```

Switch between them manually or create custom scripts.

## Integration with Other Tools

The Claude Model Switcher works with:

- **Claude Code CLI** - Official Claude CLI
- **OpenCode** - Open source AI coding assistant
- **Droid CLI** - Android development assistant
- Any tool using Claude's API endpoint

## Next Steps

1. Read [README.md](README.md) for command reference
2. See [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for common issues
3. Check [GLM_README.md](GLM_README.md) for GLM-specific setup

## Support

### Check Installation

```bash
bash install.sh status
```

### View Help

```bash
bash ~/.claude/switch-model-enhanced.sh help
```

### Reinstall

```bash
bash install.sh install
```

## Success Checklist

After installation, verify:

- [ ] Can run `cc-status` and see output
- [ ] Can switch modes with `cc-mixed`
- [ ] Commands work in new terminal windows
- [ ] API key stored in `~/.claude/.auth-token` with 600 permissions
- [ ] Aliases present in `~/.bashrc`
- [ ] Backups directory exists: `~/.claude/backups/`

If all checked, you're good to go!
