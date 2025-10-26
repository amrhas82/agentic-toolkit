<a name="readme-top"></a>

<div align='center'>
<a href="https://trendshift.io/repositories/13971" target="_blank"><img src="https://trendshift.io/api/badge/repositories/13971" alt="eyaltoledano%2Fclaude-task-master | Trendshift" style="width: 250px; height: 55px;" width="250" height="55"/></a>
</div>

<p align="center">
  <a href="https://task-master.dev"><img src="./images/logo.png?raw=true" alt="Taskmaster logo"></a>
</p>

<p align="center">
<b>Taskmaster</b>: A task management system for AI-driven development, designed to work seamlessly with any AI chat.
</p>

<p align="center">
  <a href="https://discord.gg/taskmasterai" target="_blank"><img src="https://dcbadge.limes.pink/api/server/https://discord.gg/taskmasterai?style=flat" alt="Discord"></a> |
  <a href="https://docs.task-master.dev" target="_blank">Docs</a>
</p>

<p align="center">
  <a href="https://github.com/eyaltoledano/claude-task-master/actions/workflows/ci.yml"><img src="https://github.com/eyaltoledano/claude-task-master/actions/workflows/ci.yml/badge.svg" alt="CI"></a>
  <a href="https://github.com/eyaltoledano/claude-task-master/stargazers"><img src="https://img.shields.io/github/stars/eyaltoledano/claude-task-master?style=social" alt="GitHub stars"></a>
  <a href="https://badge.fury.io/js/task-master-ai"><img src="https://badge.fury.io/js/task-master-ai.svg" alt="npm version"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT%20with%20Commons%20Clause-blue.svg" alt="License"></a>
</p>

## By [@eyaltoledano](https://x.com/eyaltoledano) & [@RalphEcom](https://x.com/RalphEcom)

[![Twitter Follow](https://img.shields.io/twitter/follow/eyaltoledano)](https://x.com/eyaltoledano)
[![Twitter Follow](https://img.shields.io/twitter/follow/RalphEcom)](https://x.com/RalphEcom)

---

## Documentation

📚 **[View Full Documentation](https://docs.task-master.dev)**

Quick Reference:
- [Configuration Guide](docs/configuration.md)
- [Tutorial](docs/tutorial.md)
- [Command Reference](docs/command-reference.md)
- [Example Interactions](docs/examples.md)

---

## Requirements

Task Master requires at least **one** of the following:

- **Node.js** 14.0.0 or higher
- **API Keys** (at least one):
  - Anthropic API key (Claude)
  - OpenAI API key
  - Google Gemini API key
  - Perplexity API key (for research)
  - xAI, OpenRouter, Mistral, Groq, Azure, or Ollama
  - **OR** Claude Code CLI (no API key required)
  - **OR** Codex CLI with OAuth (ChatGPT subscription)

---

## Installation

### Option 1: MCP (Recommended for IDE Integration)

#### Quick Install for Cursor 1.0+ (One-Click)

[![Add task-master-ai MCP server to Cursor](https://cursor.com/deeplink/mcp-install-dark.svg)](https://cursor.com/en/install-mcp?name=task-master-ai&config=eyJjb21tYW5kIjoibnB4IC15IC0tcGFja2FnZT10YXNrLW1hc3Rlci1haSB0YXNrLW1hc3Rlci1haSIsImVudiI6eyJBTlRIUk9QSUNfQVBJX0tFWSI6IllPVVJfQU5USFJPUElDX0FQSV9LRVlfSEVSRSIsIlBFUlBMRVhJVFlfQVBJX0tFWSI6IllPVVJfUEVSUExFWElUWV9BUElfS0VZX0hFUkUiLCJPUEVOQUlfQVBJX0tFWSI6IllPVVJfT1BFTkFJX0tFWV9IRVJFIiwiR09PR0xFX0FQSV9LRVkiOiJZT1VSX0dPT0dMRV9LRVlfSEVSRSIsIk1JU1RSQUxfQVBJX0tFWSI6IllPVVJfTUlTVFJBTF9LRVlfSEVSRSIsIkdST1FfQVBJX0tFWSI6IllPVVJfR1JPUV9LRVlfSEVSRSIsIk9QRU5ST1VURVJfQVBJX0tFWSI6IllPVVJfT1BFTlJPVVRFUl9LRVlfSEVSRSIsIlhBSV9BUElfS0VZIjoiWU9VUl9YQUlfS0VZX0hFUkUiLCJBWlVSRV9PUEVOQUlfQVBJX0tFWSI6IllPVVJfQVpVUkVfS0VZX0hFUkUiLCJPTExBTUFfQVBJX0tFWSI6IllPVVJfT0xMQU1BX0FQSV9LRVlfSEVSRSJ9fQ%3D%3D)

> **Note:** After installation, replace placeholder API keys with your actual keys.

#### Claude Code Quick Install

```bash
claude mcp add taskmaster-ai -- npx -y task-master-ai
```

Then add your API keys in `.env` or MCP config's `env` section.

#### Manual MCP Configuration

**MCP Config Locations:**

| Editor       | Scope   | Config Path                           | Key          |
| ------------ | ------- | ------------------------------------- | ------------ |
| **Cursor**   | Global  | `~/.cursor/mcp.json`                  | `mcpServers` |
|              | Project | `<project_folder>/.cursor/mcp.json`   | `mcpServers` |
| **Windsurf** | Global  | `~/.codeium/windsurf/mcp_config.json` | `mcpServers` |
| **VS Code**  | Project | `<project_folder>/.vscode/mcp.json`   | `servers`    |
| **Q CLI**    | Global  | `~/.aws/amazonq/mcp.json`             | `mcpServers` |

**For Cursor/Windsurf/Q (`mcpServers`):**

```json
{
  "mcpServers": {
    "task-master-ai": {
      "command": "npx",
      "args": ["-y", "task-master-ai"],
      "env": {
        "TASK_MASTER_TOOLS": "standard",
        "ANTHROPIC_API_KEY": "YOUR_KEY_HERE",
        "PERPLEXITY_API_KEY": "YOUR_KEY_HERE",
        "OPENAI_API_KEY": "YOUR_KEY_HERE"
      }
    }
  }
}
```

**For VS Code (`servers`):**

```json
{
  "servers": {
    "task-master-ai": {
      "command": "npx",
      "args": ["-y", "task-master-ai"],
      "env": {
        "TASK_MASTER_TOOLS": "standard",
        "ANTHROPIC_API_KEY": "YOUR_KEY_HERE"
      },
      "type": "stdio"
    }
  }
}
```

### Option 2: Command Line (CLI)

```bash
# Install globally
npm install -g task-master-ai

# OR install locally
npm install task-master-ai

# Initialize project
task-master init

# Initialize with specific rules
task-master init --rules cursor,windsurf,vscode
```

---

## Configuration

Task Master uses two configuration methods:

1. **`.taskmasterconfig`** (Project Root)
   - Stores: model selections, max tokens, temperature, logging, defaults
   - Managed via: `task-master models --setup` or the `models` MCP tool
   - **Do not edit manually**

2. **Environment Variables** (`.env` or MCP `env` block)
   - Only for: API keys (e.g., `ANTHROPIC_API_KEY`, `PERPLEXITY_API_KEY`)
   - CLI: Place in `.env` file
   - MCP: Place in `env` section of MCP config

**Tool Loading Modes** (set via `TASK_MASTER_TOOLS`):
- `all` (default): 36 tools, ~21K tokens - complete feature set
- `standard`: 15 tools, ~10K tokens - common operations
- `core` or `lean`: 7 tools, ~5K tokens - essential workflow

[Full Configuration Guide](docs/configuration.md) | [Available Models](docs/models.md)

---

## Quick Start Guide

### 1. Initialize Project

**Via MCP/Chat:**
```
Initialize taskmaster-ai in my project
```

**Via CLI:**
```bash
task-master init
```

### 2. Create or Add PRD

Place your Product Requirements Document at:
- **New projects:** `.taskmaster/docs/prd.txt`
- **Existing projects:** `scripts/prd.txt` (or migrate with `task-master migrate`)

Example template available at: `.taskmaster/templates/example_prd.txt`

> **Tip:** The more detailed your PRD, the better the generated tasks.

### 3. Parse PRD and Generate Tasks

**Via Chat:**
```
Parse my PRD at scripts/prd.txt
```

**Via CLI:**
```bash
task-master parse-prd scripts/prd.txt
```

This generates `tasks.json` with structured tasks, dependencies, and priorities.

### 4. Work on Tasks

**Common chat commands:**
- `What's the next task I should work on?`
- `Can you help me implement task 3?`
- `Show me tasks 1, 3, and 5`
- `Can you expand task 4?`
- `Research the latest JWT authentication best practices`

**Common CLI commands:**
```bash
task-master next                    # Show next task
task-master show 3                  # Show specific task
task-master list                    # List all tasks
task-master set-status --id=3 --status=done
task-master expand --id=5 --num=3   # Break down task
task-master research "latest React patterns"
```

[More Examples](docs/examples.md) | [Full Command Reference](docs/command-reference.md)

---

## AI-Driven Workflow

### Task Discovery
Ask: `What tasks are available to work on?`
- Agent runs `task-master list` and `task-master next`
- Analyzes dependencies and priorities
- Suggests next task

### Task Implementation
Ask: `Let's implement task 3`
- Agent references task details and dependencies
- Follows project coding standards
- Creates tests per task's testStrategy

### Task Completion
Say: `Task 3 is complete`
- Agent executes: `task-master set-status --id=3 --status=done`

### Handling Changes
Say: `We're using Express instead of Fastify. Update future tasks.`
- Agent executes: `task-master update --from=4 --prompt="Using Express now"`

### Breaking Down Complex Tasks
Ask: `Break down task 5 with security focus`
- Agent executes: `task-master expand --id=5 --prompt="Focus on security"`

---

## Essential Commands

### Core Operations
```bash
# Parse PRD
task-master parse-prd <file.txt> [--num-tasks=5]

# Task Management
task-master list [--status=pending] [--with-subtasks]
task-master next
task-master show <id> or <id1,id2,id3>
task-master generate

# Status Updates
task-master set-status --id=<id> --status=<status>
task-master set-status --id=1,2,3 --status=done

# Task Expansion
task-master expand --id=<id> [--num=3] [--prompt="context"]
task-master expand --all [--research]

# Complexity Analysis
task-master analyze-complexity [--research]
task-master complexity-report

# Dependencies
task-master add-dependency --id=<id> --depends-on=<id>
task-master validate-dependencies
task-master fix-dependencies

# Add Tasks
task-master add-task --prompt="Task description" [--priority=high]

# Research
task-master research "search query with context"

# Cross-Tag Movement
task-master move --from=5 --from-tag=backlog --to-tag=in-progress
```

[Complete Command Reference](docs/command-reference.md)

---

## Task Structure

Tasks in `tasks.json`:
```json
{
  "id": 1,
  "title": "Initialize Repo",
  "description": "Set up repository structure",
  "status": "pending",
  "dependencies": [1, 2],
  "priority": "high",
  "details": "Detailed implementation instructions...",
  "testStrategy": "Verification approach...",
  "subtasks": []
}
```

**Status values:** `pending`, `in-progress`, `done`, `deferred`
**Priority:** `high`, `medium`, `low`

---

## Best Practices

1. **Start with detailed PRD** - Better PRD = better tasks
2. **Analyze complexity** - Use `analyze-complexity` to identify tasks needing breakdown
3. **Follow dependencies** - Respect task order
4. **Update as you go** - Use `update` when implementation diverges
5. **Break down complex tasks** - Use `expand` for granularity
6. **Validate dependencies** - Run `validate-dependencies` periodically

---

## Troubleshooting

### `task-master init` doesn't respond

```bash
# Try with Node directly
node node_modules/claude-task-master/scripts/init.js

# Or clone and run
git clone https://github.com/eyaltoledano/claude-task-master.git
cd claude-task-master
node scripts/init.js
```

### MCP shows "0 tools enabled"

- Restart your editor
- Verify API keys are correctly set in MCP config
- Check `TASK_MASTER_TOOLS` setting

[Full Troubleshooting Guide](docs/tutorial.md)

---

## Licensing

Task Master is licensed under **MIT License with Commons Clause**.

✅ **Allowed:**
- Use for any purpose (personal, commercial, academic)
- Modify the code
- Distribute copies
- Create and sell products built using Task Master

❌ **Not Allowed:**
- Sell Task Master itself
- Offer Task Master as a hosted service
- Create competing products based on Task Master

[Full License Details](docs/licensing.md)

---

## Contributors

<a href="https://github.com/eyaltoledano/claude-task-master/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=eyaltoledano/claude-task-master" alt="Task Master contributors" />
</a>

---

## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=eyaltoledano/claude-task-master&type=Timeline)](https://www.star-history.com/#eyaltoledano/claude-task-master&Timeline)

<p align="right">(<a href="#readme-top">back to top</a>)</p>
