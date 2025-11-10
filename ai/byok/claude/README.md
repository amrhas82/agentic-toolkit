# Claude Code Mode Switcher

A clean, simple CLI tool to switch between different Claude Code configuration modes: native Claude, GLM models, mixed modes, and fast variants.

## ✨ Key Features

- **Simple**: One command to switch modes
- **Safe**: Single backup file, automatic validation
- **Transparent**: Clear logging and colors
- **Fast**: Instant mode switching with preserved settings
- **Secure**: API keys stored in protected file (600 permissions)

## 🚀 Quick Start

```bash
# 1. Install (one-time setup)
cd ~/Documents/PycharmProjects/agentic-toolkit/ai/byok/claude
bash install.sh install

# 2. Activate in current session
source ~/.bashrc

# 3. Use it
cc-change              # Show interactive menu
cc-change cc-glm       # Switch to GLM mode
cc-change --status     # Show current mode
```

## 📋 Available Modes

| Mode | Sonnet | Opus | Haiku | Use Case |
|------|--------|------|-------|----------|
| **cc-native** | Default | Default | Default | Official Claude Code experience |
| **cc-glm** | GLM-4.6 | GLM-4.6 | GLM-4.5-air | Full GLM experience |
| **cc-mixed** ⭐ | Claude Sonnet | Claude Opus | GLM-4.5-air | Best balance (recommended) |
| **fast-glm** | GLM-4.5-air | GLM-4.6 | GLM-4.5-air | Maximum speed with GLM |

## 💻 Commands

```bash
# Interactive menu
cc-change

# Switch to specific mode
cc-change cc-glm
cc-change cc-mixed
cc-change fast-glm

# Show information
cc-change --status         # Current mode and config
cc-change --list           # List all available modes
cc-change --help           # Show help

# Restore from backup
cc-change --help           # Menu has restore option (r)
```

## 🏗️ How It Works

### Installation Flow
```
bash install.sh install
  ↓
1. Detect shell (bash/zsh)
2. Prompt for API key → Save to ~/.claude/.auth-token (600 permissions)
3. Create ~/.claude/ directory structure
4. Copy scripts to ~/.claude/switcher/
5. Setup aliases in ~/.bashrc
6. Done!
```

### Mode Switching Flow
```
cc-change cc-glm
  ↓
1. Read current settings.json (preserve statusLine, model, etc.)
2. Delete old "env" key (if it exists from previous mode)
3. Read real API key from ~/.claude/.auth-token
4. Load cc-glm preset (model mappings)
5. Create new "env" with API token + preset config
6. Merge env into current settings
7. Validate JSON
8. Write to settings.json
9. Record "cc-glm" in settings.json.last
  ↓
Success! ✅
```

### Switching FROM Native
```
cc-change cc-glm (from native state)
  ↓
1. Same as above...
2. BUT: Also backup current settings → ~/.claude/settings.json.backup
3. This backup is used when you switch back FROM another mode to native
  ↓
Backup updated! ✅
```

### Switching TO Native
```
cc-change cc-native
  ↓
1. Read current settings (with env from previous mode)
2. BACKUP to ~/.claude/settings.json.backup (user's last non-native state)
3. Delete "env" key
4. Write settings WITHOUT env
5. Record "cc-native" in settings.json.last
  ↓
Switched to native! ✅
```

## 📁 Directory Structure

```
~/.claude/
├── settings.json                 # Current active config
├── settings.json.backup          # Emergency backup (updated from native only)
├── settings.json.last            # Current mode name (cc-glm, cc-native, etc.)
├── .auth-token                   # API key (600 permissions, managed by install.sh)
├── aliases.sh                    # Shell aliases
└── switcher/
    ├── switch-mode.sh            # Main switcher script (NEW, simplified)
    ├── presets/glm/
    │   ├── cc-native.json        # No preset needed (inherent)
    │   ├── cc-glm.json           # GLM-4.6 for Sonnet/Opus, GLM-4.5-air for Haiku
    │   ├── cc-mixed.json         # Claude Sonnet/Opus + GLM-4.5-air Haiku
    │   └── fast-glm.json         # GLM-4.5-air for Sonnet/Haiku, GLM-4.6 for Opus
    └── logs/
        └── switch-YYYYMMDD-HHMMSS.log  # Operation logs

~/Documents/PycharmProjects/agentic-toolkit/ai/ollama/claude/
├── README.md                     # This file
├── ARCHITECTURE.md               # Detailed design and flow
├── GUIDE.md                      # Installation + Troubleshooting merged
├── GLM_README.md                 # GLM-specific configuration
├── install.sh                    # Main installer
├── aliases.sh                    # Shell aliases template
├── verify-install.sh             # Verification script
├── settings.example.json         # Example config
└── _archive/
    └── switch-model-enhanced.sh  # Old script (deprecated)
```

## 🔧 How to Reinstall / Update API Key

```bash
# Just run install again - it will:
# 1. Ask for new API key (or keep existing if you press Enter)
# 2. Update ~/.claude/.auth-token
# 3. Keep your settings and backups

cd ~/Documents/PycharmProjects/agentic-toolkit/ai/byok/claude
bash install.sh install
```

## 🛟 Restore from Backup

If something goes wrong:

```bash
# Show interactive menu
cc-change

# In the menu, press 'r' to restore from backup
# This restores ~/.claude/settings.json.backup to ~/.claude/settings.json
```

## ✅ What's Safe

- **statusLine**: Preserved across all switches (your custom prompt config)
- **model**: Preserved (your default model preference)
- **alwaysThinkingEnabled**: Preserved (your thinking settings)
- **API Key**: Never overwritten, always from .auth-token
- **Backups**: One stable backup file, updated intelligently

## ❌ What Could Go Wrong (And How We Handle It)

| Issue | Handling |
|-------|----------|
| Corrupted settings.json | Error message, no changes made |
| Missing API key | Error message, prompts to run install.sh |
| Missing preset file | Error message, switch cancelled |
| Invalid JSON after merge | Error message, no file written |

All errors are logged to `~/.claude/switcher/logs/` for debugging.

## 🔍 Troubleshooting

### Commands not found after install?
```bash
# Reload shell in current session
source ~/.bashrc

# Or open a new terminal
```

### API key issues?
```bash
# Reinstall and update the key
cd ~/Documents/PycharmProjects/agentic-toolkit/ai/byok/claude
bash install.sh install
```

### Need to see what's happening?
```bash
# Check current mode
cc-change --status

# View logs
tail -f ~/.claude/switcher/logs/*

# Check backup file
cat ~/.claude/settings.json.backup
```

### Mode switch failed?
```bash
# Restore from backup using the menu
cc-change
# Press 'r' to restore
```

## 📖 More Information

- **[ARCHITECTURE.md](ARCHITECTURE.md)** - Deep dive into design, flow, and technical details
- **[GLM_README.md](GLM_README.md)** - GLM-specific configuration and setup

## 🎯 Next Steps

1. Run `bash install.sh install` to get started
2. Use `cc-change` to switch modes
3. Read [ARCHITECTURE.md](ARCHITECTURE.md) if you want to understand the design
4. Check logs in `~/.claude/switcher/logs/` if anything needs debugging

## 📝 Notes

- This tool manages `~/.claude/settings.json` for Claude Code
- API key is stored securely in `~/.claude/.auth-token` (600 permissions)
- All operations are logged for debugging
- Backups are preserved for safety
- No configuration is lost, only the "env" section is swapped per mode

---

**Version**: 2.0 (Simplified Architecture)
**Last Updated**: November 9, 2025
