# Claude Model Switcher Aliases
# Add these to your ~/.bashrc or ~/.zshrc

# Interactive model switcher
alias claude-switch='bash ~/.claude/switch-model.sh'

# Quick switching commands
alias claude-native='bash ~/.claude/switch-model.sh claude-native'
alias glm-override='bash ~/.claude/switch-model.sh glm-override'
alias claude-mixed='bash ~/.claude/switch-model.sh mixed'
alias claude-fast='bash ~/.claude/switch-model.sh claude-fast'
alias glm-fast='bash ~/.claude/switch-model.sh glm-fast'

# Status check
alias claude-status='bash ~/.claude/switch-model.sh status'

# List available models
alias claude-models='bash ~/.claude/switch-model.sh list'