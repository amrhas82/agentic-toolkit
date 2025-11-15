# MCP Memory Server

A powerful **Model Context Protocol (MCP)** server that provides persistent, searchable memory for Claude Code with semantic search capabilities. Store technical notes, deployment configurations, preferences, and more across your projects.

## Features

- **Semantic Search**: Uses embeddings (384-dimension vectors) for intelligent memory retrieval
- **Project-Scoped & Global Memories**: Organize memories by project or share globally
- **5 Core Tools**: Store, retrieve, list, update, and delete memories
- **Category System**: Technical, deployment, preference, bug, ways_of_working
- **Tag-Based Organization**: Flexible tagging for easy filtering
- **Importance Scoring**: 1-10 scale for prioritizing memories
- **Local Embeddings**: Runs offline using Xenova/all-MiniLM-L6-v2 (no API keys required)
- **TypeScript**: Type-safe implementation with comprehensive error handling

## Quick Start

### Installation

```bash
# Navigate to the memcp directory
cd /home/user/addypin/memcp

# Install dependencies
npm install

# Build the project
npm run build
```

### Configure Claude Code

Add to your Claude Code configuration:

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

### Start the Server

```bash
# Development mode (with hot reload)
npm run dev

# Production mode
npm run start
```

## Available Tools

### 1. `memcp_store` - Store a New Memory

Store technical notes, configurations, or preferences with automatic semantic embedding.

```typescript
// Example: Store a deployment configuration
{
  "content": "Staging uses Nginx with SSL cert at /etc/letsencrypt/live/staging.addypin.com",
  "category": "deployment",
  "tags": ["nginx", "ssl", "staging"],
  "scope": "project",
  "importance": 8,
  "documentation_path": "docs/DEPLOYMENT-GUIDE.md"
}
```

**Parameters**:
- `content` (required): The memory content to store
- `category` (required): `technical` | `deployment` | `preference` | `bug` | `ways_of_working`
- `tags` (required): Array of entity tags (e.g., `["nginx", "ssl", "staging"]`)
- `scope` (required): `project` | `global`
- `importance` (optional): 1-10 score (default: 5)
- `documentation_path` (optional): Related documentation file path

### 2. `memcp_retrieve` - Semantic Search

Find relevant memories using natural language queries with embedding similarity.

```typescript
// Example: Search for SSL configuration
{
  "query": "How do I configure SSL certificates for staging?",
  "category": "deployment",
  "scope": "project",
  "limit": 5
}
```

**Parameters**:
- `query` (required): Search query text
- `category` (optional): Filter by category
- `scope` (optional): `project` | `global` | `all` (default: `all`)
- `limit` (optional): Max results (1-20, default: 5)

**Returns**: Array of memories with similarity scores (0-1), sorted by relevance.

### 3. `memcp_list` - List All Memories

Browse all memories with optional filtering (faster than semantic search).

```typescript
// Example: List all deployment memories
{
  "category": "deployment",
  "scope": "project",
  "tags": ["nginx", "ssl"]
}
```

**Parameters**: All optional
- `category`: Filter by category
- `scope`: `project` | `global` | `all` (default: `all`)
- `tags`: Filter by tags (matches any tag)

### 4. `memcp_update` - Update Existing Memory

Modify content, category, tags, or importance. Automatically regenerates embedding if content changes.

```typescript
// Example: Update importance score
{
  "memory_id": "123e4567-e89b-12d3-a456-426614174000",
  "importance": 10,
  "tags": ["nginx", "ssl", "staging", "critical"]
}
```

**Parameters**:
- `memory_id` (required): UUID of memory to update
- `content` (optional): New content (triggers embedding regeneration)
- `category` (optional): New category
- `tags` (optional): New tags array
- `importance` (optional): New importance score (1-10)
- `documentation_path` (optional): New documentation path

### 5. `memcp_delete` - Delete Memory

Permanently remove a memory by ID.

```typescript
// Example: Delete a memory
{
  "memory_id": "123e4567-e89b-12d3-a456-426614174000"
}
```

**Parameters**:
- `memory_id` (required): UUID of memory to delete

## Storage Locations

### Project-Scoped Memories
```
<project-root>/.mcp-memory/memories.json
```
Stores memories specific to the current project. Automatically detects project name from `package.json` or directory name.

### Global Memories
```
~/.mcp-memory/global-memories.json
```
Stores memories accessible across all projects.

## Example Use Cases

### 1. Technical Configuration
```json
{
  "content": "Database connection uses pooling with max 20 connections. See server/db.ts",
  "category": "technical",
  "tags": ["database", "postgres", "connection-pooling"],
  "scope": "project",
  "importance": 7
}
```

### 2. Deployment Procedure
```json
{
  "content": "Always run health checks after deployment. Manual trigger via GitHub Actions UI",
  "category": "deployment",
  "tags": ["ci-cd", "health-check", "github-actions"],
  "scope": "project",
  "importance": 9
}
```

### 3. Personal Preference
```json
{
  "content": "Prefer Tailwind CSS utility classes over custom CSS for styling",
  "category": "preference",
  "tags": ["css", "tailwind", "styling"],
  "scope": "global",
  "importance": 6
}
```

### 4. Bug Fix Note
```json
{
  "content": "Fixed rate limiter memory leak by clearing expired entries every hour",
  "category": "bug",
  "tags": ["rate-limiter", "memory-leak", "middleware"],
  "scope": "project",
  "importance": 8,
  "documentation_path": "server/middleware/rateLimiter.ts"
}
```

### 5. Ways of Working
```json
{
  "content": "Always use feature branches with 'claude/' prefix for automated deployments",
  "category": "ways_of_working",
  "tags": ["git", "workflow", "branching"],
  "scope": "global",
  "importance": 7
}
```

## Development

### Scripts

```bash
npm run dev        # Start development server with tsx
npm run build      # Compile TypeScript to dist/
npm run start      # Run compiled server
npm run check      # Type check without emitting files
```

### Project Structure

```
memcp/
├── src/
│   ├── server.ts                    # Main MCP server entry point
│   ├── embeddings/
│   │   ├── EmbeddingProvider.ts     # Abstract base class
│   │   └── LocalEmbeddings.ts       # Xenova transformer implementation
│   ├── storage/
│   │   ├── types.ts                 # TypeScript types & interfaces
│   │   └── MemoryStore.ts           # JSON file persistence
│   ├── tools/
│   │   ├── memcpStore.ts            # Store tool implementation
│   │   ├── memcpRetrieve.ts         # Retrieve tool implementation
│   │   ├── memcpList.ts             # List tool implementation
│   │   ├── memcpUpdate.ts           # Update tool implementation
│   │   └── memcpDelete.ts           # Delete tool implementation
│   └── utils/
│       ├── config.ts                # Configuration loader
│       ├── project.ts               # Project detection utilities
│       └── search.ts                # Semantic & keyword search
├── docs/                            # Detailed documentation
├── dist/                            # Compiled JavaScript output
├── package.json
├── tsconfig.json
└── README.md
```

## How It Works

### Semantic Search Flow

1. **Store**: Content → Embedding (384-dim vector) → JSON file
2. **Retrieve**: Query → Embedding → Cosine similarity with all memories → Top N results
3. **Ranking**: Combines semantic similarity + keyword matching (tags weighted 2x)

### Embedding Model

- **Model**: `Xenova/all-MiniLM-L6-v2`
- **Dimensions**: 384
- **Type**: Normalized vectors (unit vectors)
- **Speed**: ~50-100ms per embedding (CPU)
- **Offline**: Runs locally, no API keys required

### Similarity Scoring

- **Range**: 0.0 (unrelated) to 1.0 (identical)
- **Threshold**: Results typically above 0.3 are relevant
- **Normalization**: All vectors normalized for accurate cosine similarity

## Configuration

### Environment Variables

The server loads configuration from `~/.mcp-memory/config.json` (optional):

```json
{
  "embedding_model": "Xenova/all-MiniLM-L6-v2",
  "max_memories_per_project": 1000,
  "default_importance": 5
}
```

If not found, defaults are used.

## Requirements

- **Node.js**: >= 20.0.0
- **TypeScript**: ^5.0.0
- **Disk Space**: ~100MB (for embedding model cache)
- **Memory**: ~200MB RAM during operation

## Performance

- **Store**: ~100-200ms (embedding generation + file I/O)
- **Retrieve**: ~50ms per memory comparison (semantic search)
- **List**: ~5-10ms (direct JSON load, no embeddings)
- **Update**: ~100-200ms if content changed (embedding regeneration)
- **Delete**: ~5-10ms (JSON file update)

## Documentation

- [Setup Guide](docs/SETUP.md) - Detailed installation and configuration
- [Architecture](docs/ARCHITECTURE.md) - System design and components
- [Data Flow](docs/FLOW.md) - Request/response flows
- [Tech Stack](docs/TECH_STACK.md) - Dependencies and rationale
- [Troubleshooting](docs/TROUBLESHOOTING.md) - Common issues and solutions
- [Claude Code Integration](docs/CLAUDE_CODE_CONFIG.md) - Setup with Claude Code

## Troubleshooting

### Server won't start
- Check Node.js version: `node --version` (must be >= 20.0.0)
- Verify build: `npm run build`
- Check logs for errors

### Embeddings fail
- First run downloads model (~80MB) - may take time
- Check disk space in `~/.cache/huggingface/`
- Verify internet connection for initial model download

### Memories not found
- Check scope: project vs global
- Verify project detection: logs show project name on startup
- List all memories: Use `memcp_list` to browse

### Slow semantic search
- Normal: First query initializes model (~2-3 seconds)
- Subsequent queries: ~50-100ms per memory
- Alternative: Use `memcp_list` for faster browsing without semantic search

## License

MIT

## Support

For issues, questions, or contributions, see the [main AddyPin repository](https://github.com/amrhas82/addypin).
