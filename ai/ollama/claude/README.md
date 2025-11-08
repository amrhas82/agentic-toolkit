# Claude Model Switcher

A CLI tool to easily switch between Claude's native models and custom GLM model configurations.

## Quick Start

```bash
# Navigate to directory
cd ~/Documents/PycharmProjects/agentic-toolkit/ai/ollama/claude

# Run installer
bash install.sh install

# Activate in current session
source ~/.bashrc

# Test it out
cc-status
```

## Available Commands

### Primary Commands

| Command | Description |
|---------|-------------|
| `cc-native` | Switch to Claude native mode (web authentication) |
| `cc-mixed` | Switch to mixed mode (Claude Sonnet + GLM Haiku) - Recommended |
| `cc-glm` | Switch to GLM override (all GLM models) |
| `cc-status` | Show current configuration and model setup |
| `fast-cc` | Switch to Claude fast mode (all Haiku) |
| `fast-glm` | Switch to GLM fast mode (all GLM-4.5-air) |

### Legacy Commands (Still Supported)

- `claude-native`, `claude-mixed`, `glm-override`, `claude-status`, `claude-fast`, `glm-fast`

All legacy commands continue to work for backward compatibility.

## Model Profiles Explained

### cc-native (Claude Native)
- **Authentication**: Web-based (no API key needed)
- **Models**: Default Claude models from web interface
- **Use case**: Using Claude's official web authentication

### cc-mixed (Mixed Mode) - Recommended
- **Sonnet**: claude-sonnet-4-5-20250929
- **Haiku**: glm-4.5-air
- **Opus**: glm-4.6
- **Use case**: Premium quality on Sonnet, economy on Haiku

### cc-glm (GLM Override)
- **Sonnet**: glm-4.6
- **Haiku**: glm-4.5-air
- **Opus**: glm-4.6
- **Use case**: Full GLM stack for cost optimization

### fast-cc (Claude Fast)
- **All models**: claude-haiku-3-5-20241022
- **Use case**: Maximum speed with Claude

### fast-glm (GLM Fast)
- **All models**: glm-4.5-air
- **Use case**: Maximum speed with GLM

## How to Use

### From Terminal (Global Commands)

After installation, these commands work from anywhere:

```bash
cc-native      # Switch to Claude native models
cc-mixed       # Switch to mixed mode
cc-status      # Check current model
fast-glm       # GLM-4.5-air for everything
```

### From Within Claude (Conversational)

Simply ask:
- "Switch to Claude native models"
- "Switch to mixed mode"
- "Check my current model status"

### Direct Script Commands (Always Work)

```bash
bash ~/.claude/switch-model-enhanced.sh cc-native
bash ~/.claude/switch-model-enhanced.sh status
```

## Usage Examples

### Basic Switching

```bash
cc-status      # Check current model
cc-native      # Switch to official Claude
cc-mixed       # Use mixed mode for best performance
```

### Development Workflows

```bash
# Use fast GLM for quick tasks
fast-glm

# Switch to Claude for complex reasoning
cc-native

# Check what you're currently using
cc-status
```

## File Structure

```
~/.claude/                              # Main directory
├── settings.json                       # Your Claude configuration
├── switch-model-enhanced.sh            # Main switcher script
├── aliases.sh                          # Shell aliases
├── .auth-token                         # Your API key (600 permissions)
└── backups/                            # Auto-generated backups
    └── settings_YYYYMMDD_HHMMSS.json

~/Documents/PycharmProjects/agentic-toolkit/ai/ollama/claude/
├── README.md                           # This file
├── INSTALLATION.md                     # Installation guide
├── TROUBLESHOOTING.md                  # Troubleshooting guide
├── GLM_README.md                       # GLM configuration guide
├── install.sh                          # Installer script
├── switch-model-enhanced.sh            # Switcher script
├── aliases.sh                          # Shell aliases
├── verify-install.sh                   # Installation verification
└── settings.example.json               # Example configuration
```

## Safety and Backups

- **Automatic Backups**: Every switch creates a timestamped backup
- **Token Preservation**: Your API token is preserved across all switches
- **Config Validation**: Settings are validated before switching
- **Easy Recovery**: Restore from `~/.claude/backups/` directory

## Advanced Usage

### Restore from Backup

```bash
# List backups
bash ~/.claude/switch-model-enhanced.sh restore

# Restore specific backup
bash ~/.claude/switch-model-enhanced.sh restore 20251108_14
```

### Installation Commands

```bash
bash install.sh install    # Full interactive installation
bash install.sh quick      # Quick installation (no prompts)
bash install.sh status     # Check installation status
bash install.sh uninstall  # Complete removal
```

## Next Steps

1. Read [INSTALLATION.md](INSTALLATION.md) for detailed installation instructions
2. See [TROUBLESHOOTING.md](TROUBLESHOOTING.md) if you encounter issues
3. Check [GLM_README.md](GLM_README.md) for GLM-specific configuration

## Integration with Other Tools

The switcher works alongside:
- Claude Code CLI
- OpenCode
- Droid CLI
- Any tool using Claude's API

## Contributing

Feel free to modify the scripts to add:
- New model profiles
- Additional API endpoints
- Custom configurations
- Integration with other tools

## License

This project is provided as-is for educational and development purposes.
