# Claude Model Switcher Aliases
# Add these to your ~/.bashrc or ~/.zshrc
# Automatically configured by installer

# Quick switching commands (new naming scheme)
alias cc-native='bash ~/.claude/switch-model-enhanced.sh cc-native'
alias cc-mixed='bash ~/.claude/switch-model-enhanced.sh cc-mixed'
alias cc-glm='bash ~/.claude/switch-model-enhanced.sh cc-glm'
alias cc-status='bash ~/.claude/switch-model-enhanced.sh cc-status'
alias fast-cc='bash ~/.claude/switch-model-enhanced.sh fast-cc'
alias fast-glm='bash ~/.claude/switch-model-enhanced.sh fast-glm'

# Legacy aliases for backward compatibility
alias claude-native='bash ~/.claude/switch-model-enhanced.sh cc-native'
alias claude-mixed='bash ~/.claude/switch-model-enhanced.sh cc-mixed'
alias glm-override='bash ~/.claude/switch-model-enhanced.sh cc-glm'
alias claude-status='bash ~/.claude/switch-model-enhanced.sh cc-status'
alias claude-fast='bash ~/.claude/switch-model-enhanced.sh fast-cc'
alias glm-fast='bash ~/.claude/switch-model-enhanced.sh fast-glm'

# Interactive model switcher
alias claude-switch='bash ~/.claude/switch-model-enhanced.sh'

# List available models
alias claude-models='bash ~/.claude/switch-model-enhanced.sh profiles'
