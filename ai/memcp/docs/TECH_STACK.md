# MCP Memory Server - Tech Stack

Complete documentation of dependencies, technology choices, and rationale.

## Table of Contents

1. [Overview](#overview)
2. [Runtime Dependencies](#runtime-dependencies)
3. [Development Dependencies](#development-dependencies)
4. [TypeScript Configuration](#typescript-configuration)
5. [Technology Decisions](#technology-decisions)
6. [Alternatives Considered](#alternatives-considered)
7. [Future Enhancements](#future-enhancements)

## Overview

The MCP Memory Server is built with modern Node.js and TypeScript, prioritizing:
- **Type Safety**: Full TypeScript with strict mode
- **Offline-First**: No external APIs required
- **Minimal Dependencies**: Only essential packages
- **Standards-Based**: MCP protocol compliance
- **Performance**: Fast local embeddings

### Stack Summary

| Category | Technology | Version | Purpose |
|----------|-----------|---------|---------|
| Runtime | Node.js | 20+ | JavaScript runtime |
| Language | TypeScript | 5.0+ | Type-safe development |
| Protocol | MCP SDK | 1.0+ | Model Context Protocol |
| Embeddings | Xenova Transformers | 2.10+ | Local ML models |
| Storage | JSON + File System | - | Persistent storage |
| IDs | uuid | 9.0+ | Memory identifiers |

## Runtime Dependencies

### @modelcontextprotocol/sdk (^1.0.0)

**Purpose**: Implement Model Context Protocol for Claude Code integration

**Features Used**:
- `Server` class for MCP server implementation
- `StdioServerTransport` for stdio communication
- Request schemas (`ListToolsRequestSchema`, `CallToolRequestSchema`)
- Type definitions (`Tool`, `Content`, etc.)

**Why This Package**:
- Official implementation from Anthropic
- Handles JSON-RPC protocol details
- Type-safe request/response handling
- Automatic schema validation

**Key Imports**:
```typescript
import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
  Tool,
} from "@modelcontextprotocol/sdk/types.js";
```

**Size**: ~200KB
**License**: MIT

### @xenova/transformers (^2.10.0)

**Purpose**: Local embedding generation using transformer models

**Features Used**:
- `pipeline("feature-extraction")` for embeddings
- ONNX runtime for CPU inference
- Automatic model downloading and caching
- Mean pooling and normalization

**Why This Package**:
- Runs completely offline (after initial model download)
- No API keys or external services required
- Fast CPU inference (~50-100ms per embedding)
- Supports wide range of Hugging Face models
- ONNX optimization for production use

**Model Used**: `Xenova/all-MiniLM-L6-v2`
- **Type**: Sentence transformer (BERT-based)
- **Dimensions**: 384
- **Size**: ~80MB
- **License**: Apache 2.0
- **Training**: 1B+ sentence pairs
- **Quality**: Good balance of speed and accuracy

**Key Usage**:
```typescript
import { pipeline } from "@xenova/transformers";

const extractor = await pipeline(
  "feature-extraction",
  "Xenova/all-MiniLM-L6-v2"
);

const result = await extractor(text, {
  pooling: "mean",
  normalize: true,
});
```

**Performance**:
- First initialization: ~2-3 seconds (model load)
- Subsequent embeddings: ~50-100ms each
- Memory usage: ~150MB (model in RAM)

**Size**: ~5MB (package) + ~80MB (model download)
**License**: Apache 2.0

**Alternatives Considered**:
- **OpenAI API**: Requires API keys, online, costs money
- **Cohere API**: Same issues as OpenAI
- **Sentence-Transformers (Python)**: Would require Python runtime
- **TensorFlow.js**: Larger bundle size, slower inference

### uuid (^9.0.0)

**Purpose**: Generate RFC4122 UUIDs for memory identifiers

**Features Used**:
- `v4()` - Random UUID generation

**Why This Package**:
- Standard UUID implementation
- Cryptographically secure random values
- Zero dependencies
- Universally unique identifiers

**Key Usage**:
```typescript
import { v4 as uuidv4 } from "uuid";

const memoryId = uuidv4();
// Example: "123e4567-e89b-12d3-a456-426614174000"
```

**Size**: ~15KB
**License**: MIT

**Alternatives Considered**:
- **nanoid**: Shorter IDs but non-standard format
- **crypto.randomUUID()**: Node 15+ only, less portable
- **Manual generation**: Reinventing the wheel

## Development Dependencies

### TypeScript (^5.0.0)

**Purpose**: Type-safe JavaScript development

**Key Features Used**:
- ES2022 target
- NodeNext module resolution
- Strict type checking
- ESM output

**Configuration Highlights**:
```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "NodeNext",
    "moduleResolution": "NodeNext",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "outDir": "./dist"
  }
}
```

**Why TypeScript**:
- Catch errors at compile time
- Better IDE support and autocomplete
- Self-documenting code with types
- Easier refactoring

**Size**: ~30MB (dev only)
**License**: Apache 2.0

### tsx (^4.0.0)

**Purpose**: TypeScript execution for development

**Features Used**:
- Direct TypeScript execution (`tsx src/server.ts`)
- Hot reload during development
- No separate compilation step

**Why This Package**:
- Fast development iteration
- No need for nodemon + tsc watch
- Supports ESM modules
- Handles TypeScript path mappings

**Usage**:
```bash
npm run dev  # Uses tsx src/server.ts
```

**Size**: ~8MB (dev only)
**License**: MIT

**Alternatives Considered**:
- **ts-node**: Slower, less ESM support
- **nodemon + tsc**: Requires two processes
- **esbuild-register**: Less TypeScript feature support

### @types/node (^20.0.0)

**Purpose**: TypeScript type definitions for Node.js APIs

**Why This Package**:
- Type safety for Node.js built-ins (fs, path, process)
- Matches Node.js 20 API surface
- Required for strict TypeScript

**Size**: ~5MB (dev only)
**License**: MIT

### @types/uuid (^9.0.0)

**Purpose**: TypeScript type definitions for uuid package

**Why This Package**:
- Type safety for UUID functions
- Better IDE autocomplete

**Size**: ~10KB (dev only)
**License**: MIT

## TypeScript Configuration

### Target Configuration

**File**: `tsconfig.json`

```json
{
  "compilerOptions": {
    "target": "ES2022",              // Modern JavaScript features
    "module": "NodeNext",            // ESM modules
    "moduleResolution": "NodeNext",  // Node.js ESM resolution
    "lib": ["ES2022"],              // Available APIs
    "outDir": "./dist",             // Output directory
    "rootDir": "./src",             // Source directory
    "strict": true,                 // All strict checks enabled
    "esModuleInterop": true,        // CommonJS interop
    "skipLibCheck": true,           // Skip node_modules type checks
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,      // Import JSON files
    "declaration": true,            // Generate .d.ts files
    "sourceMap": false              // No source maps for production
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist", "**/*.test.ts"]
}
```

### Why ES2022?

- **Top-level await**: Used in module initialization
- **Class fields**: Cleaner class syntax
- **Private fields**: Better encapsulation
- **Node.js 20 support**: Stable and LTS

### Why ESM (NodeNext)?

- **Modern standard**: Future of JavaScript modules
- **Better tree-shaking**: Smaller bundles (potential)
- **Explicit imports**: .js extensions required
- **MCP SDK requirement**: Uses ESM

**Impact**: All imports must use `.js` extensions:
```typescript
// Correct
import { Memory } from "./types.js";

// Wrong (will fail)
import { Memory } from "./types";
```

## Technology Decisions

### 1. Local Embeddings vs API-Based

**Decision**: Local embeddings with @xenova/transformers

**Rationale**:
- ✅ **Offline operation**: No internet required after setup
- ✅ **No API keys**: Simpler setup, no credentials
- ✅ **No costs**: Free to use indefinitely
- ✅ **Privacy**: Data never leaves machine
- ✅ **Fast**: ~50-100ms per embedding
- ❌ **Larger package**: ~85MB vs API client (~1MB)
- ❌ **CPU inference**: Slower than GPU APIs

**Use Case Fit**: Perfect for local development tool like Claude Code

### 2. JSON Storage vs Database

**Decision**: JSON file storage

**Rationale**:
- ✅ **Simple**: No database setup required
- ✅ **Portable**: Copy directories to backup
- ✅ **Human-readable**: Easy debugging
- ✅ **Version control friendly**: Can commit memories
- ✅ **Zero config**: Works out of the box
- ❌ **Limited scalability**: Slow with 10,000+ memories
- ❌ **No transactions**: Potential data loss on crash
- ❌ **No indexing**: Linear search only

**Use Case Fit**: Ideal for personal memory system (<2,000 memories per project)

**Migration Path**: If needed, can add SQLite backend later without API changes

### 3. Stdio Transport vs HTTP

**Decision**: Stdio (stdin/stdout) transport

**Rationale**:
- ✅ **MCP standard**: Required by protocol
- ✅ **Secure**: No network ports exposed
- ✅ **Simple**: No TLS/auth needed
- ✅ **Process isolation**: Server dies with client
- ❌ **Single client**: Can't serve multiple clients
- ❌ **No browser access**: Desktop only

**Use Case Fit**: MCP protocol requirement, perfect for Claude Code integration

### 4. TypeScript vs JavaScript

**Decision**: TypeScript with strict mode

**Rationale**:
- ✅ **Type safety**: Catch errors before runtime
- ✅ **Better DX**: IDE autocomplete and refactoring
- ✅ **Self-documenting**: Types serve as documentation
- ✅ **Maintainability**: Easier to understand code
- ❌ **Build step**: Requires compilation
- ❌ **Learning curve**: More complex than JS

**Use Case Fit**: Essential for maintainable server implementation

### 5. UUID v4 vs Sequential IDs

**Decision**: UUID v4 (random)

**Rationale**:
- ✅ **No coordination**: Generate IDs without central authority
- ✅ **Merge-friendly**: No conflicts when merging memories
- ✅ **Privacy**: IDs don't reveal creation order
- ✅ **Standard**: RFC4122 compliance
- ❌ **Longer**: 36 characters vs 1-10 for sequential
- ❌ **Not sortable**: Can't sort by ID to get chronological order

**Use Case Fit**: Good for distributed/offline-first systems

## Alternatives Considered

### Storage Alternatives

| Alternative | Pros | Cons | Why Not Chosen |
|-------------|------|------|----------------|
| **SQLite** | Fast, ACID, indexed | Requires native module | Overkill for POC |
| **LevelDB** | Fast, simple | Native module, less portable | Similar to SQLite |
| **MongoDB** | Flexible schema | Requires server process | Too heavy |
| **Redis** | Very fast | Requires server, not persistent | Not suitable for durable storage |

### Embedding Alternatives

| Alternative | Pros | Cons | Why Not Chosen |
|-------------|------|------|----------------|
| **OpenAI Embeddings** | Best quality | API key, costs, online | Privacy concerns, cost |
| **Cohere** | Good quality | API key, costs, online | Same as OpenAI |
| **Sentence-Transformers** | High quality | Requires Python | Extra runtime dependency |
| **Universal Sentence Encoder** | Good quality | TensorFlow.js, large | Larger bundle, slower |

### Protocol Alternatives

| Alternative | Pros | Cons | Why Not Chosen |
|-------------|------|------|----------------|
| **HTTP REST** | Universal, simple | Requires port, TLS | Not MCP standard |
| **gRPC** | Fast, typed | Complex setup | Overkill |
| **WebSockets** | Real-time | Requires port | Not needed |
| **Unix Sockets** | Fast, secure | Unix only | Stdio is more portable |

## Future Enhancements

### Potential Upgrades

1. **Storage Layer**
   - Add SQLite backend option for 10,000+ memories
   - Implement full-text search index
   - Add memory compression for older entries

2. **Embedding Options**
   - Support custom Hugging Face models
   - Add multilingual model option
   - GPU acceleration for faster embeddings

3. **Search Enhancements**
   - Hybrid search (semantic + keyword)
   - Re-ranking with cross-encoder
   - Temporal decay (older memories less relevant)

4. **Memory Management**
   - Automatic memory merging (deduplicate similar memories)
   - Smart pruning (remove low-importance memories)
   - Memory analytics (usage stats, top tags)

5. **Developer Experience**
   - Web UI for memory browsing
   - VS Code extension for direct memory management
   - Export/import functionality (JSON, CSV)

6. **Performance**
   - Batch embedding generation
   - Caching layer for frequent queries
   - Lazy loading for large memory sets

### Dependency Updates

**Monitoring**:
- `@modelcontextprotocol/sdk`: Watch for protocol updates
- `@xenova/transformers`: Track new model releases
- `typescript`: Stay on latest stable version

**Security**:
- Run `npm audit` regularly
- Update dependencies quarterly
- Pin versions in package-lock.json

### Breaking Changes to Watch

1. **MCP Protocol**: V2 may change tool schemas
2. **Node.js**: Major version upgrades (21, 22)
3. **TypeScript**: Breaking changes in type system
4. **Xenova**: Model format changes

## Version Requirements

### Minimum Versions

```json
{
  "engines": {
    "node": ">=20.0.0"
  }
}
```

**Why Node.js 20+**:
- ESM support is stable
- Fetch API built-in
- Performance improvements
- Long-term support (LTS)

### Compatibility Matrix

| Node.js | TypeScript | MCP SDK | Xenova | Status |
|---------|-----------|---------|--------|--------|
| 20.x | 5.x | 1.x | 2.10+ | ✅ Tested |
| 21.x | 5.x | 1.x | 2.10+ | ✅ Expected |
| 18.x | 5.x | 1.x | 2.10+ | ⚠️ May work |
| 16.x | 5.x | 1.x | 2.10+ | ❌ Not supported |

## Build Output

### Compiled Structure

```
dist/
├── server.js                    # Main entry point
├── server.d.ts                  # Type declarations
├── embeddings/
│   ├── EmbeddingProvider.js
│   ├── EmbeddingProvider.d.ts
│   ├── LocalEmbeddings.js
│   └── LocalEmbeddings.d.ts
├── storage/
│   ├── types.js
│   ├── types.d.ts
│   ├── MemoryStore.js
│   └── MemoryStore.d.ts
├── tools/
│   ├── memcpStore.js
│   ├── memcpRetrieve.js
│   ├── memcpList.js
│   ├── memcpUpdate.js
│   └── memcpDelete.js
└── utils/
    ├── config.js
    ├── project.js
    └── search.js
```

### Bundle Size

| Component | Size (minified) |
|-----------|----------------|
| Server + MCP SDK | ~250KB |
| Tools | ~50KB |
| Storage | ~20KB |
| Embeddings (code) | ~30KB |
| Utilities | ~15KB |
| **Total** | **~365KB** |

Note: Embedding model (~80MB) is separate and cached by @xenova/transformers

---

**Related**: [Architecture](ARCHITECTURE.md) | [Setup Guide](SETUP.md)
