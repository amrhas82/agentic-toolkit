# Claude Model Switcher

A CLI tool to easily switch between Claude's native models and custom GLM model configurations.

## 🚀 Quick Start

### Option 1: Smart Installer (Recommended)
```bash
cd ~/PycharmProjects/agentic-toolkit/ai/ollama/claude
bash install.sh install
```

### Option 2: Manual Commands
```bash
# Switch to Claude's native models
bash ~/.claude/switch-model.sh claude-native

# Switch to GLM override (your current config)
bash ~/.claude/switch-model.sh glm-override

# Use mixed mode (Claude Sonnet + GLM Haiku)
bash ~/.claude/switch-model.sh mixed

# Check current configuration
bash ~/.claude/switch-model.sh status
```

### Option 3: Global Aliases (After Installation)
```bash
claude-native      # Switch to Claude native models
glm-override       # Switch to GLM models
claude-mixed       # Switch to mixed mode
claude-status      # Show current configuration
claude-fast        # Claude Haiku for everything
glm-fast           # GLM-4.5-air for everything
```

## 📁 File Structure

```
~/.claude/                              # Main directory
├── settings.json                       # Your Claude configuration
├── switch-model.sh                     # Main switcher script (FIXED)
├── aliases.sh                          # Shell aliases
└── backups/                            # Auto-generated backups
    └── settings_YYYYMMDD_HHMMSS.json

~/PycharmProjects/agentic-toolkit/ai/ollama/claude/  # Project copy
├── README.md                           # This documentation (UPDATED)
├── install.sh                          # Smart installer (ENHANCED)
├── switch-model.sh                     # Switcher script (FIXED)
├── aliases.sh                          # Shell aliases
├── settings.example.json               # Example configuration
└── settings.json                       # Your config (if copied)
```

## 🛠️ Installation

### Method 1: Smart Installer (Recommended) ✨
```bash
cd ~/PycharmProjects/agentic-toolkit/ai/ollama/claude
bash install.sh install
```

**The installer automatically:**
- ✅ Detects your shell (Bash/Zsh) automatically
- ✅ Prompts for your API key securely
- ✅ Creates necessary directories
- ✅ Installs scripts and makes them executable
- ✅ **Adds aliases to BOTH ~/.bashrc AND ~/.bash_profile**
- ✅ **Sets up global command availability**
- ✅ Tests the installation
- ✅ Shows you next steps

### Method 2: Manual Installation
```bash
# Create directories
mkdir -p ~/.claude/backups

# Copy files
cp ~/PycharmProjects/agentic-toolkit/ai/ollama/claude/switch-model.sh ~/.claude/
cp ~/PycharmProjects/agentic-toolkit/ai/ollama/claude/aliases.sh ~/.claude/
cp ~/PycharmProjects/agentic-toolkit/ai/ollama/claude/settings.example.json ~/.claude/settings.json

# Make executable
chmod +x ~/.claude/switch-model.sh

# Add aliases to BOTH files for global availability
echo 'source ~/.claude/aliases.sh' >> ~/.bashrc
echo 'source ~/.claude/aliases.sh' >> ~/.bash_profile

# Reload current session
source ~/.bashrc
```

## 🌐 Global Command Setup - SOLVED!

### The Problem:
New terminal windows weren't loading aliases because they were only in `~/.bashrc`.

### The Solution:
The installer now adds aliases to **both** `~/.bashrc` **and** `~/.bash_profile` to ensure global availability.

### Why Both Files?
- `~/.bashrc`: Loaded by interactive non-login shells (most terminals)
- `~/.bash_profile`: Loaded by login shells (some terminals, SSH sessions)
- Having both ensures aliases work everywhere

### Manual Fix (if needed):
```bash
# Add to both files
echo 'source ~/.claude/aliases.sh' >> ~/.bashrc
echo 'source ~/.claude/aliases.sh' >> ~/.bash_profile

# Test installation
bash install.sh status

# Or reload current session
source ~/.bashrc
```

## 🎯 Available Model Profiles

### 1. **Claude Native** (`claude-native`)
- **URL**: `https://api.anthropic.com`
- **Sonnet**: `claude-sonnet-4-5-20250929`
- **Haiku**: `claude-haiku-3-5-20241022`
- **Opus**: `claude-opus-3-5-20241022`

### 2. **GLM Override** (`glm-override`) - Your current config
- **URL**: `https://api.z.ai/api/anthropic`
- **Sonnet**: `glm-4.6`
- **Haiku**: `glm-4.5-air`
- **Opus**: `glm-4.6`

### 3. **Mixed Mode** (`claude-mixed`) - Best of both
- **URL**: `https://api.z.ai/api/anthropic`
- **Sonnet**: `claude-sonnet-4-5-20250929` (Official Claude)
- **Haiku**: `glm-4.5-air` (Fast GLM)
- **Opus**: `glm-4.6`

### 4. **Development Modes**
- **Claude Fast** (`claude-fast`) - Claude Haiku for everything
- **GLM Fast** (`glm-fast`) - GLM-4.5-air for everything

## 🔄 How to Use

### From Terminal (Global Commands) 🌍
```bash
# These work from ANYWHERE after installation
claude-native      # Switch to Claude native models
glm-override       # Switch to GLM models
claude-mixed       # Switch to mixed mode
claude-status      # Check current model
claude-fast        # Claude Haiku for everything
glm-fast           # GLM-4.5-air for everything
```

### From Within Claude (Conversational) 💬
Simply ask me:
- *"Switch to Claude native models"*
- *"Switch to GLM models"*
- *"Switch to mixed mode"*
- *"Check my current model status"*

### Direct Script Commands (Always work) 🔧
```bash
bash ~/.claude/switch-model.sh claude-native
bash ~/.claude/switch-model.sh glm-override
bash ~/.claude/switch-model.sh mixed
bash ~/.claude/switch-model.sh status
```

## 📋 Configuration Files

### 1. `~/.claude/settings.json` (Your configuration)
```json
{
    "env": {
        "ANTHROPIC_AUTH_TOKEN": "your-api-key-here",
        "ANTHROPIC_BASE_URL": "https://api.z.ai/api/anthropic",
        "API_TIMEOUT_MS": "3000000",
        "ANTHROPIC_DEFAULT_HAIKU_MODEL": "glm-4.5-air",
        "ANTHROPIC_DEFAULT_SONNET_MODEL": "glm-4.6",
        "ANTHROPIC_DEFAULT_OPUS_MODEL": "glm-4.6"
    }
}
```

### 2. `~/.claude/aliases.sh` (Shell aliases)
```bash
# Claude Model Switcher Aliases
alias claude-switch='bash ~/.claude/switch-model.sh'
alias claude-native='bash ~/.claude/switch-model.sh claude-native'
alias glm-override='bash ~/.claude/switch-model.sh glm-override'
alias claude-mixed='bash ~/.claude/switch-model.sh mixed'
alias claude-fast='bash ~/.claude/switch-model.sh claude-fast'
alias glm-fast='bash ~/.claude/switch-model.sh glm-fast'
alias claude-status='bash ~/.claude/switch-model.sh status'
```

## 🔧 Major Updates & Improvements (November 2024)

### ✅ **CRITICAL FIXES**
- **🔧 Unified Template System**: Fixed the core issue where each profile had hardcoded templates
- **🔑 API Token Preservation**: Your API token is now preserved across ALL model switches
- **📁 Smart Backup System**: Timestamped backups for every switch with detailed filenames
- **🌐 Global Alias Fix**: Commands now work in ALL terminal windows (added to ~/.bash_profile)
- **🛡️ Better Error Handling**: Improved validation and error messages

### ✅ **ENHANCED INSTALLER**
- **🔍 Shell Detection**: Automatically detects Bash/Zsh
- **🔐 Secure API Key Input**: Prompts for API key during installation
- **⚙️ Automatic Configuration**: Adds aliases to multiple shell config files
- **🧪 Installation Testing**: Verifies everything works after setup
- **📊 Status Checking**: `bash install.sh status` shows installation health

### ✅ **NEW FEATURES**
- **🔀 Mixed Mode**: Claude Sonnet + GLM Haiku (best of both worlds)
- **⚡ Fast Modes**: All-Haiku or All-GLM for development
- **📋 Detailed Status**: Enhanced status output with all model information
- **🔄 Smart Switching**: Intelligent model configuration updates

## 📊 Usage Examples

### Basic Switching
```bash
claude-status      # Check current model
claude-native      # Switch to official Claude
glm-override       # Switch back to GLM
claude-mixed       # Use mixed mode for best performance
```

### Development Workflows
```bash
# Use fast GLM for quick tasks
glm-fast

# Switch to Claude for complex reasoning
claude-native

# Check what you're currently using
claude-status
```

### Within Claude Conversations
```
User: Switch me to Claude native models for better reasoning
Claude: I'll help you switch to Claude native models.
[runs bash ~/.claude/switch-model.sh claude-native]
✅ Settings backed up to: settings_20251106_151200.json
✅ Settings updated successfully
📍 Sonnet: claude-sonnet-4-5-20250929, Haiku: claude-haiku-3-5-20241022
```

## 🛡️ Safety & Backups

- **🔄 Automatic Backups**: Every switch creates a timestamped backup
- **🔑 Token Preservation**: Your API token is preserved across all switches
- **✅ Config Validation**: Settings are validated before switching
- **📁 Easy Recovery**: Restore from `~/.claude/backups/` directory

## 🐛 Troubleshooting

### Commands not found in new terminals? 🔧
```bash
# Test installation status
bash install.sh status

# Check if aliases are configured in both files
grep "source ~/.claude/aliases.sh" ~/.bashrc
grep "source ~/.claude/aliases.sh" ~/.bash_profile

# Add manually if needed
echo 'source ~/.claude/aliases.sh' >> ~/.bashrc
echo 'source ~/.claude/aliases.sh' >> ~/.bash_profile

# Reload current session
source ~/.bashrc
```

### Models not switching?
```bash
# Check if settings file exists
ls -la ~/.claude/settings.json

# Test switcher directly
bash ~/.claude/switch-model.sh status

# Reinstall if needed
cd ~/PycharmProjects/agentic-toolkit/ai/ollama/claude
bash install.sh install
```

### Permission errors?
```bash
chmod +x ~/.claude/switch-model.sh
```

### Aliases still not working?
```bash
# Check shell type
echo $SHELL
echo $0

# Ensure aliases are loaded in current session
source ~/.bashrc

# Test with full command
bash ~/.claude/switch-model.sh status
```

## 📝 Advanced Usage

### Custom Model Configurations
Modify the `switch-model.sh` script to add your own model profiles using the `update_settings()` function.

### Installation Commands
```bash
bash install.sh install    # Full interactive installation
bash install.sh quick      # Quick installation (no prompts)
bash install.sh status     # Check installation status
bash install.sh test       # Test current installation
bash install.sh uninstall  # Complete removal
```

### Integration with Other Tools
The switcher works alongside:
- Claude Code CLI
- OpenCode
- Droid CLI
- Any tool using Claude's API

## 🤝 Contributing

Feel free to modify the scripts to add:
- New model profiles
- Additional API endpoints
- Custom configurations
- Integration with other tools

## 📄 License

This project is provided as-is for educational and development purposes.