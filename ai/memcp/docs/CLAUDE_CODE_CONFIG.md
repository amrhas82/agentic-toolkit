# MCP Memory Server - Claude Code Integration Guide

Complete guide for integrating the MCP Memory Server with Claude Code.

## Table of Contents

1. [Overview](#overview)
2. [Configuration File Location](#configuration-file-location)
3. [Basic Configuration](#basic-configuration)
4. [Advanced Configuration](#advanced-configuration)
5. [Multiple MCP Servers](#multiple-mcp-servers)
6. [Environment Variables](#environment-variables)
7. [Usage Examples](#usage-examples)
8. [Best Practices](#best-practices)
9. [Verification](#verification)

## Overview

Claude Code uses the **Model Context Protocol (MCP)** to integrate with external tools and servers. The MCP Memory Server is configured in Claude Code's configuration file as an MCP server.

### Architecture

```
┌─────────────────────────────────┐
│        Claude Code              │
│                                 │
│  ┌──────────────────────────┐  │
│  │  MCP Client              │  │
│  │  - Discovers tools       │  │
│  │  - Makes tool calls      │  │
│  │  - Handles responses     │  │
│  └────────────┬─────────────┘  │
└───────────────┼─────────────────┘
                │ stdio (JSON-RPC)
                │
┌───────────────▼─────────────────┐
│   MCP Memory Server Process     │
│   (spawned by Claude Code)      │
│                                 │
│   node dist/server.js           │
└─────────────────────────────────┘
```

## Configuration File Location

### macOS

```
~/Library/Application Support/Claude/claude_desktop_config.json
```

### Linux

```
~/.config/Claude/claude_desktop_config.json
```

### Windows

```
%APPDATA%\Claude\claude_desktop_config.json
```

### Finding the File

If unsure of the location:

```bash
# macOS/Linux
find ~ -name "claude_desktop_config.json" 2>/dev/null

# Or check Claude Code settings UI
# Settings → Developer → Configuration File Path
```

## Basic Configuration

### Minimal Configuration

Add the MCP Memory Server to your configuration file:

```json
{
  "mcpServers": {
    "memory": {
      "command": "node",
      "args": ["/home/user/addypin/memcp/dist/server.js"]
    }
  }
}
```

**Important**:
- Use **absolute paths** (not relative like `./dist/server.js`)
- Replace `/home/user/addypin/memcp` with your actual installation path
- Server name `"memory"` can be anything (used for logging)

### Step-by-Step Setup

1. **Build the server**:
   ```bash
   cd /home/user/addypin/memcp
   npm run build
   ```

2. **Find absolute path**:
   ```bash
   cd /home/user/addypin/memcp
   pwd
   # Copy this path
   ```

3. **Edit configuration file**:
   ```bash
   # macOS
   code ~/Library/Application\ Support/Claude/claude_desktop_config.json

   # Linux
   code ~/.config/Claude/claude_desktop_config.json
   ```

4. **Add server configuration** (see above)

5. **Restart Claude Code** (quit completely and reopen)

## Advanced Configuration

### With Environment Variables

Pass configuration via environment variables:

```json
{
  "mcpServers": {
    "memory": {
      "command": "node",
      "args": ["/home/user/addypin/memcp/dist/server.js"],
      "env": {
        "NODE_ENV": "production",
        "MCP_MEMORY_CONFIG": "/custom/path/config.json",
        "NODE_OPTIONS": "--max-old-space-size=4096"
      }
    }
  }
}
```

**Environment Variables**:
- `NODE_ENV`: Environment mode (`production` or `development`)
- `MCP_MEMORY_CONFIG`: Custom configuration file path
- `NODE_OPTIONS`: Node.js runtime options (e.g., heap size)

### With Custom Node.js Path

If using a specific Node.js version via nvm or similar:

```json
{
  "mcpServers": {
    "memory": {
      "command": "/home/user/.nvm/versions/node/v20.10.0/bin/node",
      "args": ["/home/user/addypin/memcp/dist/server.js"],
      "env": {}
    }
  }
}
```

### Development Mode Configuration

For development with hot reload:

```json
{
  "mcpServers": {
    "memory": {
      "command": "npx",
      "args": ["tsx", "/home/user/addypin/memcp/src/server.ts"],
      "env": {
        "NODE_ENV": "development"
      }
    }
  }
}
```

**Note**: This runs TypeScript directly without building. Useful during development.

### With Increased Memory Limit

If processing large numbers of memories:

```json
{
  "mcpServers": {
    "memory": {
      "command": "node",
      "args": [
        "--max-old-space-size=4096",
        "/home/user/addypin/memcp/dist/server.js"
      ],
      "env": {}
    }
  }
}
```

## Multiple MCP Servers

You can run multiple MCP servers simultaneously:

```json
{
  "mcpServers": {
    "memory": {
      "command": "node",
      "args": ["/home/user/addypin/memcp/dist/server.js"]
    },
    "filesystem": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "/path/to/files"
      ]
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "your-token-here"
      }
    }
  }
}
```

**Available Tools in Claude Code**:
- `memcp_store`, `memcp_retrieve`, `memcp_list`, `memcp_update`, `memcp_delete` (from memory server)
- File system tools (from filesystem server)
- GitHub tools (from github server)

## Environment Variables

### Standard Variables

| Variable | Description | Default | Example |
|----------|-------------|---------|---------|
| `NODE_ENV` | Environment mode | `production` | `production`, `development` |
| `HOME` | User home directory | System default | `/home/user` |
| `MCP_MEMORY_CONFIG` | Custom config path | `~/.mcp-memory/config.json` | `/custom/config.json` |

### Node.js Runtime Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `NODE_OPTIONS` | Node.js CLI options | `--max-old-space-size=4096` |
| `UV_THREADPOOL_SIZE` | Thread pool size | `4` (default), `8` (more concurrent I/O) |

### Custom Application Variables

You can add custom environment variables that your code reads:

```json
{
  "mcpServers": {
    "memory": {
      "command": "node",
      "args": ["/home/user/addypin/memcp/dist/server.js"],
      "env": {
        "MEMORY_MAX_ENTRIES": "5000",
        "ENABLE_DEBUG_LOGS": "true"
      }
    }
  }
}
```

Then in your code:
```typescript
const maxEntries = parseInt(process.env.MEMORY_MAX_ENTRIES || "1000");
const debugEnabled = process.env.ENABLE_DEBUG_LOGS === "true";
```

## Usage Examples

### Asking Claude to Use Memory Tools

Once configured, you can ask Claude Code to use the memory tools:

#### Store a Memory

```
Store a memory: "Database uses PostgreSQL 15 with connection pooling (max 20 connections)"
Category: technical
Tags: database, postgres, connection-pooling
Scope: project
Importance: 8
```

Claude Code will call `memcp_store` with these parameters.

#### Search for Memories

```
Search my memories for information about database configuration
```

Claude Code will call `memcp_retrieve` with semantic search.

#### List All Memories

```
Show me all deployment-related memories for this project
```

Claude Code will call `memcp_list` with appropriate filters.

#### Update a Memory

```
Update memory <id> to increase importance to 10 and add tag "critical"
```

Claude Code will call `memcp_update`.

#### Delete a Memory

```
Delete memory <id>
```

Claude Code will call `memcp_delete`.

### Best Practices

#### 1. Use Descriptive Memory Content

Good:
```
"Staging environment uses Nginx with SSL cert at /etc/letsencrypt/live/staging.example.com.
Certificate auto-renews via certbot cron job. Port 443 proxies to app on port 3000."
```

Bad:
```
"staging nginx ssl"
```

#### 2. Choose Appropriate Scope

- **Project scope**: Technical details specific to this codebase
- **Global scope**: Personal preferences, general knowledge, cross-project patterns

Examples:
- Project: "Database schema uses Drizzle ORM with migrations in db/migrations/"
- Global: "Prefer Tailwind CSS over custom CSS for styling"

#### 3. Use Specific Tags

Good tags:
```
["nginx", "ssl", "staging", "certbot", "port-443"]
```

Bad tags:
```
["server", "config", "stuff"]
```

#### 4. Set Appropriate Importance

- **9-10**: Critical, must-remember information
- **7-8**: Important, frequently referenced
- **5-6**: Useful, occasionally referenced
- **3-4**: Nice-to-have, rarely needed
- **1-2**: Optional, archival

#### 5. Link to Documentation

Always provide `documentation_path` when applicable:
```json
{
  "content": "Rate limiter uses in-memory store with 100 req/15min limit",
  "documentation_path": "server/middleware/rateLimiter.ts"
}
```

#### 6. Regular Maintenance

- Review and update memories periodically
- Delete outdated memories
- Consolidate duplicate memories
- Update importance scores as priorities change

### Common Workflows

#### Onboarding to a Project

1. **Store project structure**:
   ```
   Store: "Project uses React frontend (client/), Node.js backend (server/), PostgreSQL database"
   Category: technical, Scope: project, Tags: ["architecture", "structure"]
   ```

2. **Store key commands**:
   ```
   Store: "Build with 'npm run build', start with 'npm run start', dev mode 'npm run dev'"
   Category: ways_of_working, Scope: project, Tags: ["commands", "npm"]
   ```

3. **Store deployment info**:
   ```
   Store: "Deploy via GitHub Actions, manual trigger, uses Docker containers"
   Category: deployment, Scope: project, Tags: ["ci-cd", "docker", "github-actions"]
   ```

#### During Development

1. **Store bug fixes**:
   ```
   Store: "Fixed memory leak in rate limiter by clearing expired entries every hour"
   Category: bug, Scope: project, Tags: ["rate-limiter", "memory-leak", "fix"]
   ```

2. **Store design decisions**:
   ```
   Store: "Using JSON storage instead of database for simplicity (< 2000 memories)"
   Category: technical, Scope: project, Tags: ["storage", "json", "architecture"]
   ```

#### Before Making Changes

1. **Search for related memories**:
   ```
   "Search for memories about authentication"
   ```

2. **Review existing decisions**:
   ```
   "List all technical memories for this project"
   ```

3. **Check for constraints**:
   ```
   "Search for memories about rate limiting"
   ```

## Verification

### Check Server Is Running

After restarting Claude Code, verify the server started:

```bash
# macOS
tail -20 ~/Library/Logs/Claude/mcp*.log

# Linux
tail -20 ~/.local/share/Claude/logs/mcp*.log
```

Look for:
```
🚀 Starting MCP Memory Server...
✅ MCP Memory Server ready!
📦 Available tools: memcp_store, memcp_retrieve, memcp_list, memcp_update, memcp_delete
```

### Test Tool Availability

In Claude Code, ask:
```
What MCP tools are available?
```

You should see:
- `memcp_store` - Store a new memory
- `memcp_retrieve` - Semantic search
- `memcp_list` - List memories
- `memcp_update` - Update memory
- `memcp_delete` - Delete memory

### Test Basic Functionality

Try storing and retrieving a test memory:

```
Store a test memory: "This is a test memory to verify the MCP server works"
Category: technical, Tags: ["test"], Scope: global, Importance: 1

Then search for: "test memory verification"
```

If successful, you should see the stored memory in search results.

### Troubleshooting

If tools don't appear:
1. Check configuration file syntax (valid JSON)
2. Verify absolute paths are correct
3. Ensure server is built (`npm run build`)
4. Restart Claude Code completely (quit, not just close)
5. Check server logs for errors

See [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for detailed solutions.

## Advanced Topics

### Custom Server Name

The server name in configuration is just a label:

```json
{
  "mcpServers": {
    "my-awesome-memory-server": {
      "command": "node",
      "args": ["/home/user/addypin/memcp/dist/server.js"]
    }
  }
}
```

This appears in logs but doesn't affect functionality.

### Running Multiple Instances

You can run multiple instances with different configurations:

```json
{
  "mcpServers": {
    "memory-work": {
      "command": "node",
      "args": ["/home/user/work-memcp/dist/server.js"],
      "env": {
        "MCP_MEMORY_CONFIG": "/home/user/work-config.json"
      }
    },
    "memory-personal": {
      "command": "node",
      "args": ["/home/user/personal-memcp/dist/server.js"],
      "env": {
        "MCP_MEMORY_CONFIG": "/home/user/personal-config.json"
      }
    }
  }
}
```

**Note**: Tool names may conflict. Consider modifying tool names in code.

### Process Management

Claude Code manages the server process lifecycle:
- **Start**: Spawns process when Claude Code starts
- **Monitor**: Restarts if process crashes
- **Stop**: Kills process when Claude Code quits

No manual process management needed.

### Logging and Debugging

Server logs are captured by Claude Code:

```bash
# View all MCP server logs
tail -f ~/Library/Logs/Claude/mcp*.log

# View specific server logs (if multiple servers)
tail -f ~/Library/Logs/Claude/mcp-memory*.log
```

Enable verbose logging via environment:
```json
{
  "env": {
    "DEBUG": "*",
    "NODE_ENV": "development"
  }
}
```

## Reference

### Complete Configuration Example

```json
{
  "mcpServers": {
    "memory": {
      "command": "node",
      "args": [
        "--max-old-space-size=4096",
        "/home/user/addypin/memcp/dist/server.js"
      ],
      "env": {
        "NODE_ENV": "production",
        "MCP_MEMORY_CONFIG": "/home/user/.mcp-memory/config.json",
        "MEMORY_MAX_ENTRIES": "5000"
      }
    }
  }
}
```

### Configuration Schema

```typescript
interface MCPServerConfig {
  command: string;           // Executable (e.g., "node", "npx", "/path/to/binary")
  args: string[];           // Command arguments
  env?: Record<string, string>;  // Environment variables (optional)
}

interface ClaudeConfig {
  mcpServers: Record<string, MCPServerConfig>;
}
```

---

**Related**: [Setup Guide](SETUP.md) | [Troubleshooting](TROUBLESHOOTING.md) | [Architecture](ARCHITECTURE.md)
