# MCP Memory Server - Architecture

Comprehensive system design and architecture documentation.

## Table of Contents

1. [System Overview](#system-overview)
2. [Architecture Layers](#architecture-layers)
3. [Component Design](#component-design)
4. [Data Flow](#data-flow)
5. [Storage Design](#storage-design)
6. [Embedding System](#embedding-system)
7. [Search Architecture](#search-architecture)
8. [Error Handling](#error-handling)
9. [Performance Considerations](#performance-considerations)
10. [Security](#security)

## System Overview

The MCP Memory Server is a **persistent memory system** that enables Claude Code to store and retrieve contextual information across sessions using semantic search.

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        Claude Code                          │
│                    (MCP Client)                             │
└────────────────────────┬────────────────────────────────────┘
                         │ stdio (JSON-RPC)
                         │
┌────────────────────────▼────────────────────────────────────┐
│                   MCP Memory Server                         │
│  ┌───────────────────────────────────────────────────────┐  │
│  │              Server Layer (server.ts)                 │  │
│  │  - MCP Protocol Handler                               │  │
│  │  - Tool Registration & Routing                        │  │
│  │  - Request/Response Management                        │  │
│  └──────────────┬────────────────────────────────────────┘  │
│                 │                                            │
│  ┌──────────────▼──────────────┐  ┌──────────────────────┐  │
│  │      Tool Layer             │  │   Embedding Layer    │  │
│  │  - memcp_store              │  │  - EmbeddingProvider │  │
│  │  - memcp_retrieve           │◄─┤  - LocalEmbeddings  │  │
│  │  - memcp_list               │  │  - Model Management  │  │
│  │  - memcp_update             │  └──────────────────────┘  │
│  │  - memcp_delete             │                             │
│  └──────────────┬──────────────┘                             │
│                 │                                            │
│  ┌──────────────▼──────────────────────────────────────────┐│
│  │              Storage Layer                              ││
│  │  - MemoryStore (JSON file I/O)                         ││
│  │  - Project Detection                                    ││
│  │  - Configuration Management                            ││
│  └─────────────────────────────────────────────────────────┘│
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
            ┌────────────────────────┐
            │   File System          │
            │  ~/.mcp-memory/        │
            │  <project>/.mcp-memory/│
            │  ~/.cache/huggingface/ │
            └────────────────────────┘
```

### Key Design Principles

1. **Layered Architecture**: Clear separation of concerns (Server → Tools → Storage)
2. **Lazy Initialization**: Embedding model loads on first use
3. **Type Safety**: Full TypeScript with strict mode
4. **Error Resilience**: Comprehensive error handling at all layers
5. **Offline-First**: Local embeddings, no API dependencies
6. **Scope Isolation**: Project-specific vs global memory separation

## Architecture Layers

### Layer 1: Server Layer (MCP Protocol)

**File**: `src/server.ts`

**Responsibilities**:
- Implement MCP protocol (stdio transport)
- Register tools with JSON schemas
- Route tool calls to implementations
- Handle global errors
- Manage embedding provider lifecycle

**Key Components**:
```typescript
// Server initialization
const server = new Server({
  name: "mcp-memory-server",
  version: "1.0.0"
}, {
  capabilities: { tools: {} }
});

// Tool listing (tools/list)
server.setRequestHandler(ListToolsRequestSchema, async () => ({
  tools: TOOLS  // 5 tool definitions with schemas
}));

// Tool execution (tools/call)
server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;
  // Route to appropriate tool implementation
});
```

**Communication**: JSON-RPC over stdio
- **Input**: stdin (tool calls from Claude Code)
- **Output**: stdout (tool responses)
- **Logging**: stderr (server logs)

### Layer 2: Tool Layer (Business Logic)

**Files**: `src/tools/*.ts`

**Responsibilities**:
- Validate input parameters
- Implement tool-specific logic
- Coordinate between storage and embedding layers
- Format responses

**Tools**:

1. **memcp_store** (`memcpStore.ts`)
   - Validate input (content, category, tags, scope)
   - Generate embedding for content
   - Detect project context (if scope=project)
   - Save to storage
   - Return success message with ID

2. **memcp_retrieve** (`memcpRetrieve.ts`)
   - Generate embedding for query
   - Load memories from storage (filtered by scope/category)
   - Compute semantic similarity (cosine)
   - Fallback to keyword search if needed
   - Rank and limit results
   - Return top N matches with scores

3. **memcp_list** (`memcpList.ts`)
   - Load memories from storage
   - Apply filters (category, scope, tags)
   - Return matching memories (no embedding computation)

4. **memcp_update** (`memcpUpdate.ts`)
   - Find memory by ID
   - Update specified fields
   - Regenerate embedding if content changed
   - Save updated memory
   - Return success message

5. **memcp_delete** (`memcpDelete.ts`)
   - Find memory by ID (search project + global)
   - Delete from storage
   - Return confirmation

### Layer 3: Embedding Layer

**Files**: `src/embeddings/*.ts`

**Responsibilities**:
- Generate 384-dimension embeddings from text
- Manage embedding model lifecycle
- Cache model instance

**Components**:

1. **EmbeddingProvider** (abstract class)
   ```typescript
   abstract class EmbeddingProvider {
     abstract initialize(): Promise<void>;
     abstract generateEmbedding(text: string): Promise<number[]>;
     abstract cleanup(): Promise<void>;
   }
   ```

2. **LocalEmbeddings** (implementation)
   - Uses `@xenova/transformers`
   - Model: `Xenova/all-MiniLM-L6-v2`
   - Lazy initialization
   - Singleton pattern
   - Normalization (unit vectors)

**Model Lifecycle**:
```
Start Server → Model = null
    ↓
First Tool Call (store/retrieve)
    ↓
Initialize Model → Download (~80MB on first run)
    ↓
Model Loaded → Cache in memory
    ↓
Subsequent Calls → Reuse cached model
    ↓
Server Shutdown → Cleanup resources
```

### Layer 4: Storage Layer

**Files**: `src/storage/*.ts`, `src/utils/*.ts`

**Responsibilities**:
- Load/save memories to JSON files
- Detect project context
- Manage configuration
- Handle file I/O errors

**Components**:

1. **MemoryStore** (`storage/MemoryStore.ts`)
   - `loadMemories(scope, projectPath)`: Load memories from JSON
   - `saveMemory(memory, projectPath)`: Save or update memory
   - `deleteMemory(id, scope, projectPath)`: Remove memory
   - `updateMemory(memory, projectPath)`: Update existing memory

2. **Project Detection** (`utils/project.ts`)
   - `getProjectPath()`: Detect current project root
   - `getProjectName()`: Extract project name from package.json

3. **Configuration** (`utils/config.ts`)
   - `loadConfig()`: Load from `~/.mcp-memory/config.json`
   - Defaults if not found

## Component Design

### Memory Type System

**File**: `src/storage/types.ts`

```typescript
export interface Memory {
  // Identity
  id: string;                    // UUID v4

  // Content
  content: string;               // Memory text
  category: MemoryCategory;      // Classification
  tags: string[];               // Entity tags

  // Context
  scope: MemoryScope;           // "project" | "global"
  project_name?: string;        // Only for project scope
  project_path?: string;        // Only for project scope

  // Metadata
  importance: number;           // 1-10 score
  timestamp: string;            // ISO 8601
  documentation_path: string | null;

  // Embedding
  embedding: number[];          // 384-dim vector
}

export type MemoryCategory =
  | "technical"
  | "deployment"
  | "preference"
  | "bug"
  | "ways_of_working";

export type MemoryScope = "project" | "global";
```

### Tool Input/Output Types

```typescript
// Store
export interface StoreMemoryInput {
  content: string;
  category: MemoryCategory;
  tags: string[];
  scope: MemoryScope;
  importance?: number;
  documentation_path?: string;
}

// Retrieve
export interface RetrieveMemoryInput {
  query: string;
  category?: MemoryCategory;
  scope?: "project" | "global" | "all";
  limit?: number;
}

// List
export interface ListMemoryInput {
  category?: MemoryCategory;
  scope?: "project" | "global" | "all";
  tags?: string[];
}

// Update
export interface UpdateMemoryInput {
  memory_id: string;
  content?: string;
  category?: MemoryCategory;
  tags?: string[];
  importance?: number;
  documentation_path?: string;
}

// Delete
export interface DeleteMemoryInput {
  memory_id: string;
}
```

## Data Flow

### Store Flow

```
1. Claude Code → memcp_store tool call
   Input: { content, category, tags, scope, ... }
        ↓
2. Tool validates input
        ↓
3. Generate embedding (LocalEmbeddings)
   → transformers.pipeline("feature-extraction")
   → normalize to unit vector
   → 384-dim float array
        ↓
4. Detect project context (if scope=project)
   → Find project root (package.json or git root)
   → Extract project name
        ↓
5. Create Memory object
   → Generate UUID
   → Add timestamp
   → Include embedding
        ↓
6. Save to storage (MemoryStore)
   → Determine file path based on scope
   → Load existing memories
   → Append or update
   → Write JSON file
        ↓
7. Return success message to Claude Code
   Output: "✓ Memory stored successfully..."
```

### Retrieve Flow

```
1. Claude Code → memcp_retrieve tool call
   Input: { query, category?, scope?, limit? }
        ↓
2. Generate query embedding (LocalEmbeddings)
   → Same 384-dim vector as storage
        ↓
3. Load memories from storage
   → Based on scope: project, global, or both
   → Apply category filter if specified
        ↓
4. Compute semantic similarity
   → For each memory: cosineSimilarity(query_emb, memory_emb)
   → Score range: 0.0 (unrelated) to 1.0 (identical)
        ↓
5. Keyword search (fallback/boost)
   → Check if query terms appear in content/tags
   → Boost scores for keyword matches
        ↓
6. Rank and limit results
   → Sort by similarity score (descending)
   → Take top N (default: 5)
        ↓
7. Return results to Claude Code
   Output: [{ memory, similarity }]
```

### List Flow

```
1. Claude Code → memcp_list tool call
   Input: { category?, scope?, tags? }
        ↓
2. Load memories from storage
   → Based on scope: project, global, or both
        ↓
3. Apply filters
   → Category filter (exact match)
   → Tags filter (any tag matches)
        ↓
4. Return all matching memories
   Output: [{ memory1 }, { memory2 }, ...]

Note: No embedding computation → Fast
```

### Update Flow

```
1. Claude Code → memcp_update tool call
   Input: { memory_id, content?, category?, ... }
        ↓
2. Find existing memory
   → Search project memories
   → Search global memories
   → Error if not found
        ↓
3. Update specified fields
   → Only update provided fields
   → Keep existing values for others
        ↓
4. If content changed → regenerate embedding
   → Generate new embedding
   → Replace old embedding
        ↓
5. Save updated memory (MemoryStore)
   → Replace in JSON array
   → Write file
        ↓
6. Return success message
   Output: "✓ Memory updated successfully..."
```

### Delete Flow

```
1. Claude Code → memcp_delete tool call
   Input: { memory_id }
        ↓
2. Find memory in both scopes
   → Search project memories
   → Search global memories
   → Error if not found
        ↓
3. Delete from storage (MemoryStore)
   → Remove from JSON array
   → Write file
        ↓
4. Return confirmation
   Output: "✓ Memory deleted successfully..."
```

## Storage Design

### File System Structure

```
~/.mcp-memory/
├── config.json                 # Optional configuration
└── global-memories.json        # Global memories

<project-root>/.mcp-memory/
└── memories.json              # Project-specific memories

~/.cache/huggingface/
└── hub/
    └── models--Xenova--all-MiniLM-L6-v2/
        ├── onnx/
        │   ├── model.onnx          (~80MB)
        │   └── model_quantized.onnx
        └── tokenizer.json
```

### JSON File Format

**Structure**: Array of Memory objects

```json
[
  {
    "id": "123e4567-e89b-12d3-a456-426614174000",
    "content": "Database uses PostgreSQL 15 with Drizzle ORM",
    "category": "technical",
    "tags": ["database", "postgres", "orm"],
    "scope": "project",
    "project_name": "addypin",
    "project_path": "/home/user/addypin",
    "importance": 7,
    "timestamp": "2025-01-15T10:30:00.000Z",
    "documentation_path": "server/db.ts",
    "embedding": [0.0234, -0.1234, 0.5678, ... ]  // 384 values
  },
  {
    "id": "...",
    ...
  }
]
```

### Storage Operations

**Load Memories**:
```typescript
static async loadMemories(scope: MemoryScope, projectPath?: string): Promise<Memory[]> {
  const memoryPath = this.getMemoryPath(scope, projectPath);

  try {
    const fileContent = await fs.readFile(memoryPath, "utf-8");
    return JSON.parse(fileContent) as Memory[];
  } catch (error) {
    if ((error as NodeJS.ErrnoException).code === "ENOENT") {
      return [];  // File doesn't exist yet
    }
    throw error;
  }
}
```

**Save Memory**:
```typescript
static async saveMemory(memory: Memory, projectPath?: string): Promise<void> {
  const memoryPath = this.getMemoryPath(memory.scope, projectPath);
  const memoryDir = path.dirname(memoryPath);

  // Ensure directory exists
  await fs.mkdir(memoryDir, { recursive: true });

  // Load existing, update or append
  const existingMemories = await this.loadMemories(memory.scope, projectPath);
  const existingIndex = existingMemories.findIndex((m) => m.id === memory.id);

  if (existingIndex >= 0) {
    existingMemories[existingIndex] = memory;  // Update
  } else {
    existingMemories.push(memory);  // Append
  }

  // Write back
  await fs.writeFile(memoryPath, JSON.stringify(existingMemories, null, 2), "utf-8");
}
```

### Path Resolution

**Project Scope**:
```typescript
// Project path: /home/user/addypin
// Memory file:  /home/user/addypin/.mcp-memory/memories.json
```

**Global Scope**:
```typescript
// User home:    /home/user
// Memory file:  /home/user/.mcp-memory/global-memories.json
```

## Embedding System

### Model Details

- **Model**: `Xenova/all-MiniLM-L6-v2`
- **Type**: Sentence transformer (BERT-based)
- **Dimensions**: 384
- **Size**: ~80MB
- **License**: Apache 2.0
- **Language**: English (primarily), multilingual capable

### Why This Model?

1. **Balance**: Good accuracy vs speed tradeoff
2. **Size**: Small enough for local deployment
3. **Offline**: No API calls required
4. **Standard**: Widely used for semantic search
5. **Quality**: Trained on 1B+ sentence pairs

### Embedding Generation

```typescript
async generateEmbedding(text: string): Promise<number[]> {
  if (this.model === null) {
    await this.initialize();
  }

  // Generate embedding
  const result = await this.model(text, {
    pooling: "mean",      // Mean pooling of token embeddings
    normalize: true,      // L2 normalization → unit vector
  });

  // Convert to JavaScript array
  const embedding = Array.from(result.data) as number[];

  // Validate
  if (embedding.length !== 384) {
    throw new Error(`Expected 384 dimensions, got ${embedding.length}`);
  }

  return embedding;
}
```

### Normalization

All embeddings are **normalized to unit vectors** (magnitude = 1.0):

```typescript
// Magnitude calculation
magnitude = sqrt(sum(x_i^2))

// Normalized vector
normalized_vector = vector / magnitude

// Property: dot(v1, v2) = cosine_similarity(v1, v2) when normalized
```

This allows using dot product instead of full cosine similarity formula for faster computation.

## Search Architecture

### Semantic Search (Primary)

**Algorithm**: Cosine Similarity

```typescript
export function cosineSimilarity(vec1: number[], vec2: number[]): number {
  let dotProduct = 0;
  for (let i = 0; i < vec1.length; i++) {
    dotProduct += vec1[i]! * vec2[i]!;
  }

  // Since vectors are normalized, magnitude = 1.0
  // So we can skip the division
  let magnitude1 = 0, magnitude2 = 0;
  for (let i = 0; i < vec1.length; i++) {
    magnitude1 += vec1[i]! * vec1[i]!;
    magnitude2 += vec2[i]! * vec2[i]!;
  }
  magnitude1 = Math.sqrt(magnitude1);
  magnitude2 = Math.sqrt(magnitude2);

  // Clamp to [0, 1] range
  return Math.max(0, Math.min(1, dotProduct / (magnitude1 * magnitude2)));
}
```

**Score Interpretation**:
- `1.0`: Identical content
- `0.8-0.9`: Very similar
- `0.6-0.8`: Related
- `0.4-0.6`: Somewhat related
- `0.0-0.4`: Unrelated

### Keyword Search (Fallback/Boost)

```typescript
export function keywordSearch(query: string, memories: Memory[]): Memory[] {
  const queryTerms = query.toLowerCase().split(/\s+/);

  return memories.filter(memory => {
    const contentLower = memory.content.toLowerCase();
    const tagsLower = memory.tags.map(t => t.toLowerCase());

    // Match if any query term appears in content or tags
    return queryTerms.some(term =>
      contentLower.includes(term) ||
      tagsLower.some(tag => tag.includes(term))
    );
  });
}
```

### Combined Search Strategy

```typescript
export function semanticSearch(
  queryEmbedding: number[],
  memories: Memory[],
  limit: number = 5
): Array<{ memory: Memory; similarity: number }> {
  // Compute similarities
  const results = memories.map(memory => ({
    memory,
    similarity: cosineSimilarity(queryEmbedding, memory.embedding)
  }));

  // Sort by similarity (descending)
  results.sort((a, b) => b.similarity - a.similarity);

  // Take top N
  return results.slice(0, limit);
}
```

## Error Handling

### Error Categories

1. **Validation Errors**: Invalid input parameters
2. **Storage Errors**: File I/O issues (EACCES, ENOSPC, ENOENT)
3. **Embedding Errors**: Model initialization or generation failures
4. **Not Found Errors**: Memory ID doesn't exist

### Error Handling Strategy

```typescript
// At tool level
try {
  // Business logic
} catch (error) {
  throw new Error(`Tool-specific error: ${error.message}`);
}

// At server level
server.setRequestHandler(CallToolRequestSchema, async (request) => {
  try {
    // Route to tool
  } catch (error) {
    console.error(`❌ Tool error: ${errorMessage}`);
    return {
      content: [{ type: "text", text: `Error: ${errorMessage}` }],
      isError: true
    };
  }
});
```

### Graceful Degradation

- **Embedding fails**: Return keyword search results
- **File not found**: Return empty array
- **Model load fails**: Clear error message with instructions

## Performance Considerations

### Bottlenecks

1. **Embedding Generation**: ~50-100ms per text (CPU-bound)
2. **Model Initialization**: ~2-3 seconds (first use only)
3. **File I/O**: ~5-10ms for JSON read/write
4. **Semantic Search**: O(N) where N = number of memories

### Optimizations

1. **Lazy Loading**: Model loads on first use
2. **Model Caching**: Reuse model instance across calls
3. **Batch Operations**: Load all memories once, filter in memory
4. **Normalized Vectors**: Faster cosine similarity computation
5. **Skip Embeddings**: Use `memcp_list` for browsing without semantic search

### Scalability Limits

- **Memory**: ~1KB per memory (with embedding)
- **1,000 memories**: ~1MB storage, ~50ms search time
- **10,000 memories**: ~10MB storage, ~500ms search time
- **Recommendation**: Keep per-project memories < 2,000

## Security

### No External APIs

- All processing happens locally
- No data sent to external services
- No API keys required

### File System Access

- Reads/writes only to designated directories:
  - `~/.mcp-memory/`
  - `<project>/.mcp-memory/`
  - `~/.cache/huggingface/`

### Input Validation

- All tool inputs validated against JSON schemas
- Type checking at runtime (TypeScript + Zod potential)
- Content length limits (practical, not enforced yet)

### Isolation

- Project memories isolated by project path
- Global memories shared but clearly scoped
- No cross-project memory leakage

---

**Next**: [Data Flow Diagrams](FLOW.md) | [Tech Stack](TECH_STACK.md)
