# Installation & Setup Guide

Complete guide to install, configure, troubleshoot, and use the Claude Code Mode Switcher.

## 📦 Installation

### Prerequisites

- Bash or Zsh shell
- `jq` installed (for JSON processing)
- API key from Anthropic (if using GLM modes)

### Step-by-Step Installation

#### 1. Navigate to Project Directory

```bash
cd ~/Documents/PycharmProjects/agentic-toolkit/ai/ollama/claude
```

#### 2. Run the Installer

```bash
bash install.sh install
```

The installer will:
- ✅ Detect your shell (Bash/Zsh)
- ✅ Prompt for your API key (optional for cc-native mode)
- ✅ Create `~/.claude/` directory structure
- ✅ Copy scripts to `~/.claude/switcher/`
- ✅ Setup aliases in your shell config
- ✅ Make scripts executable
- ✅ Create initial configuration

#### 3. Activate in Current Session

```bash
source ~/.bashrc
```

Or open a new terminal window.

#### 4. Verify Installation

```bash
cc-change --status
```

You should see the current mode and configuration.

### What Gets Installed

```
~/.claude/
├── settings.json                 # Your active Claude Code config
├── settings.json.backup          # Emergency backup
├── settings.json.last            # Current mode tracker
├── .auth-token                   # Your API key (600 permissions)
├── aliases.sh                    # Aliases configuration
├── backups/                      # (Legacy, not used in v2.0)
└── switcher/
    ├── switch-mode.sh            # Main switcher script
    ├── presets/glm/              # Mode configurations
    └── logs/                      # Operation logs
```

---

## 🔑 API Key Management

### Initial Setup

The installer will prompt you for your API key:

```
❓ Enter your ANTHROPIC_AUTH_TOKEN:
This is your API key from https://console.anthropic.com
(Press Enter to keep existing key or skip)
```

- **New installation**: Enter your key (or press Enter to skip)
- **Existing installation**: Press Enter to keep your current key

### Update API Key

To update your API key later:

```bash
cd ~/Documents/PycharmProjects/agentic-toolkit/ai/ollama/claude
bash install.sh install
```

Then:
- Enter your new API key when prompted
- Or press Enter to keep the existing one

The key is stored securely in `~/.claude/.auth-token` with **600 permissions** (read/write by owner only).

### Verify Your Key is Stored

```bash
# Check if .auth-token exists
ls -la ~/.claude/.auth-token

# See first 20 characters of your key
cat ~/.claude/.auth-token | head -c 20
echo "..."
```

---

## 🔧 Usage

### Interactive Menu

```bash
cc-change
```

Shows:
```
╔════════════════════════════════════════╗
║  Claude Code Mode Switcher             ║
╚════════════════════════════════════════╝

Select a mode:

  1) cc-native
     Sonnet: Default | Opus: Default | Haiku: Default

  2) cc-glm
     Sonnet: GLM-4.6 | Opus: GLM-4.6 | Haiku: GLM-4.5-air

  3) cc-mixed (recommended)
     Sonnet: Claude Sonnet | Opus: Claude Opus | Haiku: GLM-4.5-air

  4) fast-glm
     Sonnet: GLM-4.5-air | Opus: GLM-4.6 | Haiku: GLM-4.5-air

  h) Help - Show all available commands

Choice [1-4 or h]:
```

### Direct Commands

```bash
# Switch modes
cc-change cc-glm
cc-change cc-mixed
cc-change cc-native

# Show information
cc-change --status         # Current mode and models
cc-change --list           # Available modes
cc-change --help           # Help text
```

### Show Status

```bash
cc-change --status
```

Output:
```
Current Configuration:

• Current Mode: cc-glm
• Base URL: https://api.z.ai/api/anthropic
• Sonnet: glm-4.6
• Haiku: glm-4.5-air
```

For native mode:
```
Current Configuration:

• Current Mode: cc-native
• Type: Native (no API injection)
```

---

## 🛟 Troubleshooting

### Commands Not Found

**Problem**: After installing, `cc-change` command is not found

**Solutions**:

1. **Reload shell in current session**:
   ```bash
   source ~/.bashrc
   ```

2. **Or open a new terminal window** (automatically loads config)

3. **Check if aliases are configured**:
   ```bash
   grep "source ~/.claude/aliases.sh" ~/.bashrc
   ```

4. **If grep finds nothing, manually add**:
   ```bash
   echo 'source ~/.claude/aliases.sh' >> ~/.bashrc
   source ~/.bashrc
   ```

### API Key Issues

**Problem**: "API token file not found" error

**Cause**: The installer didn't save your API key

**Solutions**:

1. **Reinstall and provide API key**:
   ```bash
   cd ~/Documents/PycharmProjects/agentic-toolkit/ai/ollama/claude
   bash install.sh install
   ```

   Enter your key when prompted.

2. **Manually create the auth token file**:
   ```bash
   echo "your-api-key-here" > ~/.claude/.auth-token
   chmod 600 ~/.claude/.auth-token
   ```

3. **Verify it was saved**:
   ```bash
   cat ~/.claude/.auth-token
   ```

### Mode Switch Fails

**Problem**: "Configuration validation failed" or similar error

**Causes**:
- Corrupted settings.json
- Missing preset file
- Invalid JSON

**Solutions**:

1. **Check settings.json**:
   ```bash
   jq . ~/.claude/settings.json
   ```

2. **Restore from backup**:
   ```bash
   cc-change
   # Press 'r' to restore from backup
   ```

3. **Or manually restore**:
   ```bash
   cp ~/.claude/settings.json.backup ~/.claude/settings.json
   ```

4. **Check logs for details**:
   ```bash
   tail -20 ~/.claude/switcher/logs/*
   ```

### Permission Denied

**Problem**: "Permission denied" when running commands

**Solution**:

```bash
# Make scripts executable
chmod +x ~/.claude/switcher/switch-mode.sh

# Verify
ls -la ~/.claude/switcher/switch-mode.sh
# Should show: -rwxr-xr-x (755 permissions)
```

### Settings Seem Unchanged After Switch

**Problem**: Switched modes but settings look the same

**This is normal!** Only the `env` section changes:

```bash
# Check the env section
jq '.env' ~/.claude/settings.json

# This should show the mode-specific models
```

Your `statusLine`, `model`, and `alwaysThinkingEnabled` are **preserved** across switches.

---

## 📖 Understanding the System

### File Purposes

| File | Purpose | Updated By |
|------|---------|-----------|
| `settings.json` | Active Claude Code config | Mode switches |
| `settings.json.backup` | Emergency backup | Switch FROM native only |
| `settings.json.last` | Current mode name | Every mode switch |
| `.auth-token` | Your API key | install.sh |
| `switch-mode.sh` | Main switcher script | You update it |
| `presets/glm/*.json` | Mode configurations | You update if customizing |

### Mode Configuration Files

Each mode has a JSON file in `~/.claude/switcher/presets/glm/`:

**cc-glm.json**:
```json
{
  "env": {
    "ANTHROPIC_AUTH_TOKEN": "YOUR_API_KEY",
    "ANTHROPIC_BASE_URL": "https://api.z.ai/api/anthropic",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "glm-4.5-air",
    "ANTHROPIC_DEFAULT_SONNET_MODEL": "glm-4.6",
    "ANTHROPIC_DEFAULT_OPUS_MODEL": "glm-4.6"
  }
}
```

**Note**: The `YOUR_API_KEY` placeholder is replaced with your real key from `~/.claude/.auth-token` during mode switching.

---

## 🔄 Common Workflows

### Daily Use

```bash
# Check what you're using
cc-change --status

# Quick switch
cc-change cc-mixed

# Later, switch back
cc-change cc-native
```

### Development (Fast Mode)

```bash
# Fast GLM for testing
cc-change fast-glm

# Do your work...

# Back to quality
cc-change cc-mixed
```

### Testing Different Models

```bash
# Try GLM
cc-change cc-glm
# Use Claude for a bit...

# Switch to Claude
cc-change cc-native
# Compare behavior...

# Back to mixed
cc-change cc-mixed
```

---

## 🔍 Advanced Debugging

### View Recent Logs

```bash
# List log files
ls -lh ~/.claude/switcher/logs/

# View latest log
tail -50 ~/.claude/switcher/logs/*

# Follow logs in real-time
tail -f ~/.claude/switcher/logs/*
```

### Check File Integrity

```bash
# Validate settings.json
jq . ~/.claude/settings.json

# Validate preset
jq . ~/.claude/switcher/presets/glm/cc-glm.json

# Check permissions
ls -la ~/.claude/
ls -la ~/.claude/.auth-token
```

### Manual Mode Switch (Advanced)

If something breaks, you can manually set the mode:

```bash
# Set mode to cc-glm
echo "cc-glm" > ~/.claude/settings.json.last

# Verify
cat ~/.claude/settings.json.last
```

---

## 🚨 Emergency Recovery

### Complete Reset

If everything is broken:

```bash
# Backup your current settings (just in case)
cp ~/.claude/settings.json ~/.claude/settings.json.emergency

# Remove the switcher (keeps backups)
rm ~/.claude/settings.json
rm ~/.claude/settings.json.last

# Remove auth token
rm ~/.claude/.auth-token

# Reinstall
cd ~/Documents/PycharmProjects/agentic-toolkit/ai/ollama/claude
bash install.sh install
```

### Restore from Backup

```bash
# Restore saved backup
cp ~/.claude/settings.json.backup ~/.claude/settings.json

# Reset tracking
echo "cc-native" > ~/.claude/settings.json.last

# Verify
cc-change --status
```

---

## ✅ Installation Checklist

After installation, verify:

- [ ] `~/.claude/` directory exists
- [ ] `~/.claude/settings.json` exists and is valid JSON
- [ ] `~/.claude/.auth-token` exists with permissions 600
- [ ] `~/.claude/switcher/switch-mode.sh` is executable
- [ ] `cc-change` command works in terminal
- [ ] `cc-change --status` shows current mode
- [ ] `cc-change cc-glm` successfully switches modes
- [ ] `cc-change --list` shows available modes

---

## 📞 Need Help?

1. **Check logs**: `tail ~/.claude/switcher/logs/*`
2. **Validate JSON**: `jq . ~/.claude/settings.json`
3. **Review ARCHITECTURE.md** for technical details
4. **Try the interactive menu**: `cc-change`

---

**Version**: 2.0
**Last Updated**: November 9, 2025
