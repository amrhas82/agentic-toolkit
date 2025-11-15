# MCP Memory Server - Setup Guide

Complete installation and configuration guide for the MCP Memory Server.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Installation](#installation)
3. [Configuration](#configuration)
4. [Claude Code Integration](#claude-code-integration)
5. [Verification](#verification)
6. [Directory Structure](#directory-structure)
7. [Advanced Configuration](#advanced-configuration)

## Prerequisites

### Required

- **Node.js**: Version 20.0.0 or higher
- **npm**: Version 9.0.0 or higher (comes with Node.js)
- **Operating System**: Linux, macOS, or Windows with WSL2

### Verify Prerequisites

```bash
# Check Node.js version
node --version
# Expected: v20.0.0 or higher

# Check npm version
npm --version
# Expected: 9.0.0 or higher
```

### Installing Node.js (if needed)

#### Ubuntu/Debian
```bash
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs
```

#### macOS
```bash
brew install node@20
```

#### Windows WSL2
Follow Ubuntu/Debian instructions above

## Installation

### Step 1: Clone or Navigate to Directory

```bash
# If part of AddyPin repository
cd /home/user/addypin/memcp

# If standalone
git clone <repository-url> memcp
cd memcp
```

### Step 2: Install Dependencies

```bash
npm install
```

This installs:
- `@modelcontextprotocol/sdk` - MCP protocol implementation
- `@xenova/transformers` - Local embedding model (downloads ~80MB on first run)
- `uuid` - Memory ID generation
- TypeScript and development tools

**Note**: First install may take 2-3 minutes due to model download.

### Step 3: Build the Project

```bash
npm run build
```

This compiles TypeScript to JavaScript in the `dist/` directory.

### Step 4: Verify Build

```bash
# Check that dist/ directory was created
ls -la dist/

# Expected output:
# dist/
#   server.js
#   embeddings/
#   storage/
#   tools/
#   utils/
```

## Configuration

### Default Configuration

The server works out-of-the-box with sensible defaults:

```json
{
  "embedding_model": "Xenova/all-MiniLM-L6-v2",
  "max_memories_per_project": 1000,
  "default_importance": 5
}
```

### Custom Configuration (Optional)

Create a configuration file at `~/.mcp-memory/config.json`:

```bash
# Create configuration directory
mkdir -p ~/.mcp-memory

# Create config file
cat > ~/.mcp-memory/config.json << 'EOF'
{
  "embedding_model": "Xenova/all-MiniLM-L6-v2",
  "max_memories_per_project": 2000,
  "default_importance": 5
}
EOF
```

### Configuration Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `embedding_model` | string | `"Xenova/all-MiniLM-L6-v2"` | Hugging Face model identifier |
| `max_memories_per_project` | number | `1000` | Max memories per project (not enforced yet) |
| `default_importance` | number | `5` | Default importance score (1-10) |

## Claude Code Integration

### Step 1: Locate Claude Code Configuration

Claude Code configuration is typically at:
- **macOS**: `~/Library/Application Support/Claude/claude_desktop_config.json`
- **Linux**: `~/.config/Claude/claude_desktop_config.json`
- **Windows**: `%APPDATA%\Claude\claude_desktop_config.json`

### Step 2: Add MCP Server Configuration

Edit the configuration file and add the memory server:

```json
{
  "mcpServers": {
    "memory": {
      "command": "node",
      "args": ["/home/user/addypin/memcp/dist/server.js"],
      "env": {}
    }
  }
}
```

**Important**: Replace `/home/user/addypin/memcp` with your actual installation path.

### Step 3: Full Configuration Example

If you have other MCP servers configured:

```json
{
  "mcpServers": {
    "memory": {
      "command": "node",
      "args": ["/home/user/addypin/memcp/dist/server.js"],
      "env": {}
    },
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/path/to/files"]
    }
  }
}
```

### Step 4: Restart Claude Code

After modifying configuration:

1. Quit Claude Code completely
2. Restart Claude Code
3. The MCP Memory Server will start automatically

## Verification

### Step 1: Check Server Logs

When Claude Code starts, check MCP server logs:

```bash
# macOS
tail -f ~/Library/Logs/Claude/mcp*.log

# Linux
tail -f ~/.local/share/Claude/logs/mcp*.log
```

Expected output:
```
🚀 Starting MCP Memory Server...
📋 Loading configuration...
✓ Config loaded: Xenova/all-MiniLM-L6-v2
🤖 Initializing embedding provider...
✓ Embedding provider initialized
✅ MCP Memory Server ready!
📦 Available tools: memcp_store, memcp_retrieve, memcp_list, memcp_update, memcp_delete
🔌 Listening on stdio...
```

### Step 2: Test Tool Availability

In Claude Code, ask:
```
What MCP tools are available?
```

You should see:
- `memcp_store`
- `memcp_retrieve`
- `memcp_list`
- `memcp_update`
- `memcp_delete`

### Step 3: Test Basic Storage

In Claude Code, ask:
```
Store a test memory: "Database uses PostgreSQL 15 with Drizzle ORM"
with category "technical", tags ["database", "postgres", "orm"], scope "project"
```

Expected response:
```
✓ Memory stored successfully (project: <your-project-name>)
ID: <uuid>
Category: technical
Importance: 5
Tags: database, postgres, orm
```

### Step 4: Test Retrieval

In Claude Code, ask:
```
Search for memories about "database configuration"
```

Expected response: JSON array with the stored memory and similarity score.

## Directory Structure

After installation and first use:

```
/home/user/addypin/memcp/
├── src/                          # Source TypeScript files
│   ├── server.ts
│   ├── embeddings/
│   ├── storage/
│   ├── tools/
│   └── utils/
├── dist/                         # Compiled JavaScript (after build)
│   ├── server.js
│   └── ...
├── docs/                         # Documentation
│   ├── SETUP.md
│   ├── ARCHITECTURE.md
│   └── ...
├── node_modules/                 # Dependencies
├── package.json
├── tsconfig.json
├── .gitignore
└── README.md

~/.mcp-memory/                    # User data directory
├── config.json                   # Optional configuration
└── global-memories.json          # Global memories storage

<project>/.mcp-memory/            # Project-specific memories
└── memories.json                 # Project memories storage

~/.cache/huggingface/             # Embedding model cache
└── hub/
    └── models--Xenova--all-MiniLM-L6-v2/
        └── ... (~80MB)
```

## Advanced Configuration

### Custom Embedding Model

To use a different Hugging Face model:

1. Edit `~/.mcp-memory/config.json`:
```json
{
  "embedding_model": "Xenova/paraphrase-multilingual-MiniLM-L12-v2"
}
```

2. Restart Claude Code

**Note**: Model must be compatible with `@xenova/transformers` and output normalized embeddings.

### Multiple Projects

The server automatically detects project context:

1. **Project Detection**: Looks for `package.json` in current directory
2. **Project Name**: Extracted from `package.json` name field or directory name
3. **Storage Path**: `<project-root>/.mcp-memory/memories.json`

No additional configuration needed. Each project gets isolated memory storage.

### Development Mode

For development and testing:

```bash
# Run with tsx (hot reload)
npm run dev

# Type checking without building
npm run check

# Build and run
npm run build && npm run start
```

### Environment Variables

The server respects these environment variables:

| Variable | Description | Default |
|----------|-------------|---------|
| `NODE_ENV` | Environment mode | `production` |
| `HOME` | User home directory | System default |
| `MCP_MEMORY_CONFIG` | Custom config path | `~/.mcp-memory/config.json` |

Set in Claude Code configuration:

```json
{
  "mcpServers": {
    "memory": {
      "command": "node",
      "args": ["/home/user/addypin/memcp/dist/server.js"],
      "env": {
        "NODE_ENV": "development",
        "MCP_MEMORY_CONFIG": "/custom/path/config.json"
      }
    }
  }
}
```

## Troubleshooting

### Issue: "Cannot find module '@modelcontextprotocol/sdk'"

**Solution**: Dependencies not installed
```bash
npm install
npm run build
```

### Issue: "Permission denied" when accessing ~/.mcp-memory/

**Solution**: Check directory permissions
```bash
mkdir -p ~/.mcp-memory
chmod 755 ~/.mcp-memory
```

### Issue: "Model download failed"

**Solution**: Check internet connection and disk space
```bash
# Check disk space
df -h ~/.cache/huggingface/

# Clear cache and retry
rm -rf ~/.cache/huggingface/
npm run build
npm run start
```

### Issue: Claude Code doesn't show MCP tools

**Solution**: Verify configuration file location and syntax
```bash
# Check if file exists
cat ~/Library/Application\ Support/Claude/claude_desktop_config.json

# Validate JSON syntax
node -e "console.log(JSON.parse(require('fs').readFileSync('PATH_TO_CONFIG')))"
```

### Issue: "Cannot read properties of undefined (reading 'name')"

**Solution**: Project detection failed, use global scope
```
Store memory with scope "global" instead of "project"
```

For more troubleshooting, see [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

## Next Steps

- [Architecture Overview](ARCHITECTURE.md) - Understand system design
- [Data Flow Diagrams](FLOW.md) - See how requests are processed
- [Tech Stack Details](TECH_STACK.md) - Learn about dependencies
- [Claude Code Integration Guide](CLAUDE_CODE_CONFIG.md) - Advanced integration

## Support

For issues or questions:
1. Check [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
2. Review server logs (see [Verification](#verification))
3. Open an issue on GitHub
