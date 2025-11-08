# Troubleshooting Guide - Claude Model Switcher

## Quick Fixes

### Commands Not Found

**Problem**: `cc-status: command not found` or similar errors

**Quick Fix**:
```bash
source ~/.bashrc
```

**If that doesn't work**:
```bash
# Check if aliases file exists
ls -la ~/.claude/aliases.sh

# Check if it's sourced in bashrc
grep "source.*claude/aliases.sh" ~/.bashrc

# Add if missing
echo '[ -f ~/.claude/aliases.sh ] && source ~/.claude/aliases.sh' >> ~/.bashrc
source ~/.bashrc
```

**Workaround** (always works):
```bash
bash ~/.claude/switch-model-enhanced.sh cc-status
bash ~/.claude/switch-model-enhanced.sh cc-native
```

### API Authentication Errors

**Problem**: Authentication failing or API key not recognized

**Solutions**:

1. Check if key exists:
   ```bash
   ls -la ~/.claude/.auth-token
   ```

2. Verify permissions (should be 600):
   ```bash
   chmod 600 ~/.claude/.auth-token
   ```

3. Update your key:
   ```bash
   bash install.sh install
   # Enter your API key when prompted
   ```

4. Manual update:
   ```bash
   echo "your-api-key-here" > ~/.claude/.auth-token
   chmod 600 ~/.claude/.auth-token
   ```

### Settings File Corrupted

**Problem**: `settings.json contains invalid JSON` or similar errors

**Solution - Restore from backup**:

```bash
# List available backups
ls -lt ~/.claude/backups/

# Restore latest backup
bash ~/.claude/switch-model-enhanced.sh restore

# Or restore specific backup
bash ~/.claude/switch-model-enhanced.sh restore 20251108_14
```

**Manual restore**:
```bash
# Copy latest backup
cp ~/.claude/backups/settings_*.json ~/.claude/settings.json

# Verify it works
cc-status
```

## Common Issues

### Issue: Aliases Work in One Terminal But Not Others

**Cause**: Aliases are loaded when shell starts, not available in already-running shells.

**Solutions**:

1. **Reload current shell**:
   ```bash
   source ~/.bashrc
   ```

2. **Open new terminal**: Close and reopen your terminal window

3. **Check shell configuration**:
   ```bash
   grep "source.*claude/aliases.sh" ~/.bashrc
   grep "source.*claude/aliases.sh" ~/.bash_profile
   ```

### Issue: Permission Denied When Running Commands

**Cause**: Script is not executable

**Solution**:
```bash
chmod +x ~/.claude/switch-model-enhanced.sh
ls -la ~/.claude/switch-model-enhanced.sh
# Should show: -rwxr-xr-x
```

### Issue: Old Commands Work But New cc-* Commands Don't

**Cause**: Old aliases.sh file is still in use

**Solution**:
```bash
# Update to latest version
cd ~/Documents/PycharmProjects/agentic-toolkit/ai/ollama/claude
cp aliases.sh ~/.claude/
source ~/.bashrc

# Verify
type cc-status
```

### Issue: Commands Not Persisting After Reboot

**Cause**: Aliases not properly configured in shell startup files

**Solution**:
```bash
# Add to both bashrc and bash_profile
echo '[ -f ~/.claude/aliases.sh ] && source ~/.claude/aliases.sh' >> ~/.bashrc
echo '[ -f ~/.claude/aliases.sh ] && source ~/.claude/aliases.sh' >> ~/.bash_profile

# For Ubuntu/Debian, also add to bash_aliases
echo '[ -f ~/.claude/aliases.sh ] && source ~/.claude/aliases.sh' >> ~/.bash_aliases

# Reload
source ~/.bashrc
```

### Issue: Model Not Switching

**Cause**: Various possibilities

**Diagnostics**:

1. Check if settings file exists:
   ```bash
   ls -la ~/.claude/settings.json
   ```

2. Test switcher directly:
   ```bash
   bash ~/.claude/switch-model-enhanced.sh status
   ```

3. Check for errors:
   ```bash
   bash ~/.claude/switch-model-enhanced.sh cc-mixed
   ```

4. Verify JSON is valid:
   ```bash
   cat ~/.claude/settings.json | jq
   ```

**Solution**:
```bash
# Reinstall if needed
cd ~/Documents/PycharmProjects/agentic-toolkit/ai/ollama/claude
bash install.sh install
```

## Step-by-Step Diagnosis

### 1. Check Files Exist

```bash
ls -la ~/.claude/
```

You should see:
- `switch-model-enhanced.sh` (executable)
- `aliases.sh`
- `settings.json`
- `.auth-token`
- `backups/` (directory)

### 2. Check Aliases Are Correct

```bash
cat ~/.claude/aliases.sh | grep cc-status
```

Should show:
```bash
alias cc-status='bash ~/.claude/switch-model-enhanced.sh cc-status'
```

### 3. Check If Sourced in Shell Config

```bash
grep "source.*aliases.sh" ~/.bashrc
```

Should show:
```bash
[ -f ~/.claude/aliases.sh ] && source ~/.claude/aliases.sh
```

### 4. Test Script Directly

```bash
bash ~/.claude/switch-model-enhanced.sh cc-status
```

This should work even if aliases don't.

### 5. Check Alias in Current Shell

```bash
type cc-status
```

Should show:
```
cc-status is aliased to `bash ~/.claude/switch-model-enhanced.sh cc-status'
```

## Why Commands Don't Work in Current Shell

Aliases only work in interactive shells and must be loaded when the shell starts.

**Your current terminal started BEFORE the new aliases were installed**, so it doesn't know about them yet.

**Solutions**:

1. **Reload shell** (fastest):
   ```bash
   source ~/.bashrc
   ```

2. **Open new terminal** (automatic)

3. **Use full path** (temporary):
   ```bash
   bash ~/.claude/switch-model-enhanced.sh cc-status
   ```

## Verification Tools

### Run Installation Verification

```bash
bash ~/Documents/PycharmProjects/agentic-toolkit/ai/ollama/claude/verify-install.sh
```

This checks:
- All files exist
- Permissions are correct
- Script execution works
- Available commands

### Check Installation Status

```bash
bash install.sh status
```

Shows:
- What's installed
- Configuration status
- Command availability

## Manual Fix Steps

If automated fixes don't work, try manual installation:

### 1. Copy Files

```bash
mkdir -p ~/.claude/backups
cp ~/Documents/PycharmProjects/agentic-toolkit/ai/ollama/claude/switch-model-enhanced.sh ~/.claude/
cp ~/Documents/PycharmProjects/agentic-toolkit/ai/ollama/claude/aliases.sh ~/.claude/
chmod +x ~/.claude/switch-model-enhanced.sh
```

### 2. Add to Shell Config

```bash
echo "" >> ~/.bashrc
echo "# Claude Model Switcher aliases" >> ~/.bashrc
echo '[ -f ~/.claude/aliases.sh ] && source ~/.claude/aliases.sh' >> ~/.bashrc
```

### 3. Reload Shell

```bash
source ~/.bashrc
```

### 4. Test

```bash
cc-status
```

## Advanced Troubleshooting

### Check Shell Type

```bash
echo $SHELL
echo $0
```

Different shells use different config files:
- Bash: `~/.bashrc`, `~/.bash_profile`
- Zsh: `~/.zshrc`
- Fish: `~/.config/fish/config.fish`

### Check for Conflicting Aliases

```bash
alias | grep cc-
alias | grep claude-
```

If you see unexpected aliases, they may be conflicting.

### Check for Errors in Shell Config

```bash
bash -c 'source ~/.bashrc' 2>&1 | grep -i error
```

This shows any errors when loading bashrc.

### Running in Screen/Tmux

If using screen or tmux, you may need to reload in those sessions:

```bash
# In tmux/screen session
source ~/.bashrc
```

### Check File Contents

Make sure files weren't corrupted:

```bash
head -20 ~/.claude/aliases.sh
head -20 ~/.claude/switch-model-enhanced.sh
```

## Clean Reinstall

If nothing else works, do a clean reinstall:

```bash
# Backup current settings
cp ~/.claude/settings.json ~/settings.json.backup

# Remove old installation
rm -rf ~/.claude

# Remove old aliases from shell configs
sed -i '/claude\/aliases.sh/d' ~/.bashrc
sed -i '/claude\/aliases.sh/d' ~/.bash_profile

# Run fresh install
cd ~/Documents/PycharmProjects/agentic-toolkit/ai/ollama/claude
bash install.sh install

# Restore settings
cp ~/settings.json.backup ~/.claude/settings.json

# Reload shell
source ~/.bashrc

# Test
cc-status
```

## Error Messages and Solutions

### "command not found: cc-status"

**Solution**: Run `source ~/.bashrc` or use full path

### "Permission denied"

**Solution**: `chmod +x ~/.claude/switch-model-enhanced.sh`

### "No such file or directory: ~/.claude/settings.json"

**Solution**: Run `bash install.sh install` to create initial config

### "Invalid JSON in settings.json"

**Solution**: Restore from backup or reinstall

### "API key not found"

**Solution**: Run `bash install.sh install` and enter your API key

## Available Commands Reference

After successful installation, these commands should work:

### New Commands (Primary)
- `cc-status` - Show current configuration
- `cc-native` - Switch to native Claude models
- `cc-mixed` - Switch to mixed mode
- `cc-glm` - Switch to GLM models
- `fast-cc` - Quick Claude mode
- `fast-glm` - Quick GLM mode

### Legacy Commands (Still Work)
- `claude-status` - Same as cc-status
- `claude-native` - Same as cc-native
- `claude-mixed` - Same as cc-mixed
- `glm-override` - Same as cc-glm
- `claude-fast` - Same as fast-cc
- `glm-fast` - Same as fast-glm

### Other Commands
- `claude-switch` - Interactive model switcher
- `claude-models` - List available profiles

## Testing Your Installation

### Quick Test

```bash
type cc-status
```

Should show:
```
cc-status is aliased to `bash ~/.claude/switch-model-enhanced.sh cc-status'
```

### Full Test

```bash
cc-status       # Should show current config
cc-native       # Should switch to native
cc-status       # Should show changed config
cc-mixed        # Should switch to mixed
```

## Still Having Issues?

### 1. Check Shell Type

```bash
echo $SHELL
```

Make sure you're using bash or zsh.

### 2. Run Verification Script

```bash
bash ~/Documents/PycharmProjects/agentic-toolkit/ai/ollama/claude/verify-install.sh
```

### 3. Check for Updates

```bash
cd ~/Documents/PycharmProjects/agentic-toolkit/ai/ollama/claude
git pull  # If in a git repo
bash install.sh install
```

### 4. Ask for Help

Provide this information:
- Output of `bash install.sh status`
- Output of `cc-status` (or error message)
- Output of `echo $SHELL`
- Output of `grep claude ~/.bashrc`

## Getting Support

### View Help

```bash
bash ~/.claude/switch-model-enhanced.sh help
```

### Check Installation

```bash
bash install.sh status
```

### Read Documentation

- [README.md](README.md) - Overview and commands
- [INSTALLATION.md](INSTALLATION.md) - Installation guide
- [GLM_README.md](GLM_README.md) - GLM configuration

## Summary of Common Solutions

| Problem | Quick Fix |
|---------|-----------|
| Commands not found | `source ~/.bashrc` |
| Permission denied | `chmod +x ~/.claude/switch-model-enhanced.sh` |
| API errors | `bash install.sh install` and re-enter key |
| Corrupted settings | `bash ~/.claude/switch-model-enhanced.sh restore` |
| Not persisting | Add aliases to `~/.bashrc` and `~/.bash_profile` |
| Old aliases only | Copy new `aliases.sh` to `~/.claude/` |

Most issues are solved by reloading your shell configuration or reinstalling!
