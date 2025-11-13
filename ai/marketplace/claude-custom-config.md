# Claude Code Auto-Permissions Configuration Guide

This guide explains how to configure Claude Code to automatically approve certain operations while maintaining safety for potentially destructive commands.

## Overview: Permission Modes

Claude Code offers different permission modes to balance workflow efficiency with safety:

- **`default`**: Allows reads, asks before other operations
- **`plan`**: Analyze but not modify files or execute commands
- **`acceptEdits`**: Bypass permission prompts for file edits (recommended for most users)
- **`bypassPermissions`**: No permission prompts (dangerous, use with caution)

---

## Understanding `acceptEdits` Mode

The `acceptEdits` mode is the recommended middle-ground that streamlines file editing while maintaining safety prompts for potentially dangerous operations.

### What `acceptEdits` Auto-Approves:
- ✅ **File edits** (Read, Edit, Write operations)
- ✅ **Grep** (read operation - likely auto-approved even in default mode)
- ✅ **Glob** (read operation - likely auto-approved even in default mode)

### What It Still Asks Permission For:
- ⚠️ **Bash commands** (including destructive ones like `rm -rf`)
- ⚠️ **WebFetch operations**
- ⚠️ **MCP tools**

**Why this matters:** This mode lets Claude work efficiently on your code without interrupting you for every file read/write, while still protecting you from accidental command execution.

---

## Configuration Options

### Option 1: CLI Flag (Temporary)

Use this for a single session:

```bash
claude --permission-mode acceptEdits
```

**When to use:** Testing the mode before making it permanent, or one-off sessions where you want different permissions.

### Option 2: Settings File (Persistent - Recommended)

Create or edit `~/.claude/settings.json`:

```json
{
  "permissions": {
    "defaultMode": "acceptEdits"
  }
}
```

**When to use:** When you want this mode for all your Claude Code sessions.

### Option 3: In-Session Toggle (Interactive)

Press `Shift+Tab` during a Claude Code session to toggle to `acceptEdits` mode.

**When to use:** When you want to temporarily change modes without restarting.

---

## Advanced Configuration: Granular Permission Control

### Basic Configuration (File Operations + Web Access)

Auto-approve file operations, web access, and search:

```json
{
  "permissions": {
    "defaultMode": "acceptEdits",
    "allow": [
      "Read",
      "Grep",
      "Glob",
      "Edit",
      "Write",
      "WebFetch",
      "WebSearch"
    ]
  }
}
```

**What this does:**
- ✅ Auto-approves: File edits, Grep, Glob, WebFetch, WebSearch
- ⚠️ Still prompts for: All Bash commands
- 🚫 Blocks: Nothing explicitly (uses defaults)

---

### Including MCP Tools

If you have MCP (Model Context Protocol) servers installed, auto-approve them:

```json
{
  "permissions": {
    "defaultMode": "acceptEdits",
    "allow": [
      "Read",
      "Grep",
      "Glob",
      "Edit",
      "Write",
      "WebFetch",
      "WebSearch",
      "mcp__*"
    ]
  }
}
```

**Note:** The `mcp__*` wildcard approves all MCP tools. You can specify individual tools like `mcp__filesystem__read_file` for finer control.

---

### Fine-Grained WebFetch Control (Security-Focused)

Restrict web access to specific trusted domains:

```json
{
  "permissions": {
    "defaultMode": "acceptEdits",
    "allow": [
      "Read",
      "Grep",
      "Glob",
      "Edit",
      "Write",
      "WebFetch(domain:docs.anthropic.com)",
      "WebFetch(domain:github.com)",
      "WebFetch(domain:npmjs.com)",
      "WebSearch"
    ]
  }
}
```

**When to use:** When working in sensitive environments where you want to limit external network access.

---

### Safe Bash Commands (Allow + Deny Lists)

Auto-approve safe bash commands while explicitly blocking destructive ones:

```json
{
  "permissions": {
    "defaultMode": "acceptEdits",
    "allow": [
      "Read",
      "Grep",
      "Glob",
      "Edit",
      "Write",
      "WebFetch",
      "WebSearch",
      "Bash(git *)",
      "Bash(npm run *)",
      "Bash(pytest *)",
      "Bash(ls *)",
      "Bash(cat *)"
    ],
    "deny": [
      "Bash(rm -rf *)",
      "Bash(sudo *)"
    ]
  }
}
```

**Key points:**
- `allow` uses wildcards (`*`) to match command patterns
- `deny` explicitly blocks dangerous commands
- Bash commands not in either list will prompt for permission

---

## Complete Example Configuration

Here's a full `~/.claude/settings.json` with permissions and custom status line:

```json
{
  "permissions": {
    "defaultMode": "acceptEdits",
    "allow": [
      "Read",
      "Grep",
      "Glob",
      "Edit",
      "Write",
      "WebFetch",
      "WebSearch"
    ]
  },
  "statusLine": {
    "type": "command",
    "command": "input=$(cat); branch=$(git -c core.fileMode=false -c advice.detachedHead=false rev-parse --abbrev-ref HEAD 2>/dev/null); if [ -n \"$branch\" ]; then git_info=$(printf ' \\033[01;33m(%s)\\033[00m' \"$branch\"); fi; printf '\\033[01;35m[%s]\\033[00m \\033[01;32m%s@%s\\033[00m:\\033[01;34m%s\\033[00m%s' \"$(echo \"$input\" | jq -r '.model.display_name')\" \"$(whoami)\" \"$(hostname -s)\" \"$(pwd)\" \"$git_info\""
  },
  "alwaysThinkingEnabled": false,
  "model": "haiku"
}
```

**Configuration breakdown:**
- **`permissions`**: Auto-approves file operations and web access
- **`statusLine`**: Custom terminal prompt showing model, user, host, directory, and git branch
- **`alwaysThinkingEnabled`**: Disables verbose thinking output
- **`model`**: Sets Haiku as the default model (faster, cheaper)

---

## Configuration File Locations

Claude Code checks settings files in this order (later files override earlier ones):

1. **`~/.claude/settings.json`** - Global user settings (applies to all projects)
2. **`.claude/settings.json`** - Project-specific settings (applies only to current project)
3. **`~/.claude/settings.local.json`** - Local overrides (not committed to version control)
4. **`.claude/settings.local.json`** - Project-local overrides (not committed to version control)

**Best practice:** Use global settings for personal preferences, project settings for team-shared configurations.

---

## Security Considerations

### ⚠️ Important Safety Notes:

1. **Never use `bypassPermissions` mode** unless you fully trust the codebase and understand the risks
2. **Be cautious with bash wildcards** - `Bash(*)` approves ALL commands
3. **Review auto-approved tools regularly** - Your needs may change over time
4. **Use `.local.json` files** for sensitive/personal settings to avoid committing them

### Recommended Safe Configuration:

```json
{
  "permissions": {
    "defaultMode": "acceptEdits",
    "allow": [
      "Read", "Grep", "Glob", "Edit", "Write",
      "WebFetch", "WebSearch"
    ],
    "deny": [
      "Bash(rm -rf *)",
      "Bash(sudo *)",
      "Bash(curl * | bash)",
      "Bash(wget * | sh)"
    ]
  }
}
```

This configuration:
- ✅ Streamlines file operations
- ✅ Allows web access for documentation
- ⚠️ Prompts for bash commands
- 🚫 Explicitly blocks dangerous patterns

---

## Troubleshooting

### Issue: Settings not taking effect
**Solution:** Check file location and JSON syntax. Run `claude --version` to verify you're using the latest version.

### Issue: Too many permission prompts
**Solution:** Add frequently-used tools to the `allow` list, or switch to a more permissive mode.

### Issue: Accidentally allowed a dangerous command
**Solution:** Add it to the `deny` list immediately and restart Claude Code.

---

## Quick Start Recommendations

### For Most Users (Balanced):
```json
{
  "permissions": {
    "defaultMode": "acceptEdits",
    "allow": ["Read", "Grep", "Glob", "Edit", "Write", "WebFetch", "WebSearch"]
  }
}
```

### For Power Users (More Automation):
```json
{
  "permissions": {
    "defaultMode": "acceptEdits",
    "allow": [
      "Read", "Grep", "Glob", "Edit", "Write",
      "WebFetch", "WebSearch",
      "Bash(git *)", "Bash(npm *)", "Bash(pytest *)"
    ]
  }
}
```

### For Security-Conscious Users (Restricted):
```json
{
  "permissions": {
    "defaultMode": "default",
    "allow": ["Read", "Grep", "Glob"]
  }
}
```

---

## Additional Resources

- **Official Documentation**: https://docs.claude.com/en/docs/claude-code/settings
- **Security Best Practices**: https://docs.claude.com/en/docs/claude-code/security
- **Hooks Reference**: https://docs.claude.com/en/docs/claude-code/hooks

---

**Last Updated:** 2025-01-12
Footer
© 2025 GitHub, Inc.
Footer navigation

    Terms
    Privacy
    Security
    Status
    Community
    Docs
    Contact

Comparing main...claude/auto-terminal-permissions-011CV4CcuU5o8VKcsrT6rnVg · amrhas82/agentic-kit
