# Task List: MCP Memory Server Implementation

**Based on:** 0001-prd-mcp-memory-server.md (v1.2)
**Status:** Sub-tasks generated - ready for implementation
**Option:** A (Embeddings with semantic search)

---

## Relevant Files

### Source Files
- `memcp/package.json` - Project dependencies and build scripts
- `memcp/tsconfig.json` - TypeScript configuration
- `memcp/src/storage/types.ts` - TypeScript interfaces for Memory, Config, SearchResult
- `memcp/src/storage/MemoryStore.ts` - Core storage logic (load, save, delete memories)
- `memcp/src/embeddings/EmbeddingProvider.ts` - Abstract embedding interface
- `memcp/src/embeddings/LocalEmbeddings.ts` - Local model implementation (@xenova/transformers)
- `memcp/src/utils/config.ts` - Config file management (load, create defaults)
- `memcp/src/utils/search.ts` - Cosine similarity and keyword search
- `memcp/src/tools/memcpStore.ts` - memcp_store tool implementation
- `memcp/src/tools/memcpRetrieve.ts` - memcp_retrieve tool implementation
- `memcp/src/tools/memcpList.ts` - memcp_list tool implementation
- `memcp/src/tools/memcpUpdate.ts` - memcp_update tool implementation
- `memcp/src/tools/memcpDelete.ts` - memcp_delete tool implementation
- `memcp/src/server.ts` - Main MCP server entry point

### Documentation Files
- `memcp/README.md` - Quick start guide
- `memcp/docs/SETUP.md` - Detailed installation and configuration
- `memcp/docs/ARCHITECTURE.md` - System design and component overview
- `memcp/docs/FLOW.md` - Data flow diagrams and process explanations
- `memcp/docs/TECH_STACK.md` - Dependencies and technology choices
- `memcp/docs/TROUBLESHOOTING.md` - Common issues and solutions
- `memcp/docs/CLAUDE_CODE_CONFIG.md` - Claude Code integration guide

### Build Files
- `memcp/dist/` - Compiled JavaScript output (created by build)
- `memcp/.gitignore` - Ignore node_modules, dist, etc.

---

## Tasks

- [x] 1.0 **Project Setup & Configuration**
  - [x] 1.1 Create `package.json` with dependencies (@modelcontextprotocol/sdk, @xenova/transformers, uuid) and scripts (dev, build, start)
  - [x] 1.2 Create `tsconfig.json` with Node.js 20+ target, ESM module, and strict type checking
  - [x] 1.3 Create `.gitignore` to exclude node_modules, dist, and test memory files
  - [x] 1.4 Run `npm install` to install all dependencies
  - [x] 1.5 Create basic directory structure (src/storage, src/embeddings, src/tools, src/utils, docs)
  - [x] 1.6 Verify TypeScript compilation with empty placeholder files

- [x] 2.0 **Core Storage Layer**
  - [x] 2.1 Define TypeScript interfaces in `src/storage/types.ts` (Memory, MemoryCategory, Config, SearchResult, MemoryScope)
  - [x] 2.2 Implement `src/utils/config.ts` to load or create default config at `~/.mcp-memory/config.json` (FR-21, FR-22)
  - [x] 2.3 Implement `MemoryStore.loadMemories()` to read JSON from `<project>/.mcp-memory/memories.json` or `~/.mcp-memory/global-memories.json` (FR-7, FR-8)
  - [x] 2.4 Implement `MemoryStore.saveMemory()` to append/update memory in JSON file with auto-create directories (FR-6)
  - [x] 2.5 Implement `MemoryStore.deleteMemory()` to remove memory by ID from JSON file (FR-4)
  - [x] 2.6 Implement `MemoryStore.updateMemory()` to modify existing memory and update timestamp (FR-5, FR-9)
  - [x] 2.7 Add project detection logic (extract project_name from directory name or git repo, get project_path from cwd) (FR-10, FR-20)
  - [x] 2.8 Add error handling for invalid JSON, missing files, and permission errors

- [x] 3.0 **Embedding & Search System**
  - [x] 3.1 Create `EmbeddingProvider` abstract class in `src/embeddings/EmbeddingProvider.ts` with `generateEmbedding(text)` method
  - [x] 3.2 Implement `LocalEmbeddings` class using `@xenova/transformers` with model `Xenova/all-MiniLM-L6-v2` (FR-12)
  - [x] 3.3 Add model loading and caching logic (load once, reuse across calls)
  - [x] 3.4 Implement `cosineSimilarity(vec1, vec2)` function in `src/utils/search.ts` (FR-13)
  - [x] 3.5 Implement `semanticSearch(query, memories, embeddingProvider)` that generates query embedding and ranks by similarity
  - [x] 3.6 Implement `keywordSearch(query, memories)` as fallback for embedding failures (FR-15)
  - [x] 3.7 Add tests to verify embedding generation returns 384-dimension vectors
  - [x] 3.8 Add error handling for model download failures with informative messages

- [x] 4.0 **MCP Tool Implementations**
  - [x] 4.1 Implement `memcp_store` tool in `src/tools/memcpStore.ts` (FR-1)
    - Accept content, category, tags, scope, importance, documentation_path
    - Generate UUID for memory ID
    - Detect project context (project_name, project_path)
    - Generate embedding for content
    - Add timestamp
    - Save to appropriate JSON file (project or global)
    - Return success message with memory ID
  - [x] 4.2 Implement `memcp_retrieve` tool in `src/tools/memcpRetrieve.ts` (FR-2, FR-13, FR-14)
    - Accept query, optional category, scope, limit
    - Load memories from appropriate scope (project/global/all)
    - Generate embedding for query
    - Perform semantic search with cosine similarity
    - Filter by category if provided
    - Return top N results with similarity scores, timestamps, project names
  - [x] 4.3 Implement `memcp_list` tool in `src/tools/memcpList.ts` (FR-3)
    - Accept optional filters (category, scope, tags)
    - Load memories from appropriate scope
    - Filter by category, tags if provided
    - Return all matching memories (no embedding needed)
  - [x] 4.4 Implement `memcp_update` tool in `src/tools/memcpUpdate.ts` (FR-5)
    - Accept memory_id and optional fields (content, category, tags, importance, documentation_path)
    - Validate at least one field provided
    - Load existing memory by ID
    - Merge updates with existing memory
    - Regenerate embedding if content changed
    - Update timestamp to current time
    - Save updated memory
    - Return updated memory object
  - [x] 4.5 Implement `memcp_delete` tool in `src/tools/memcpDelete.ts` (FR-4)
    - Accept memory_id
    - Find and delete memory from appropriate JSON file
    - Return success or error if not found

- [x] 5.0 **MCP Server Integration**
  - [x] 5.1 Create main server in `src/server.ts` using `@modelcontextprotocol/sdk` with stdio transport (FR-16)
  - [x] 5.2 Initialize embedding provider (LocalEmbeddings) and memory store on server startup
  - [x] 5.3 Register all 5 tools with proper MCP schemas in `tools/list` handler (FR-17)
  - [x] 5.4 Implement `tools/call` handler to route requests to appropriate tool implementations (FR-18)
  - [x] 5.5 Add global error handling with descriptive error messages for tool failures (FR-19)
  - [x] 5.6 Add startup logging (config loaded, embedding model initialized, server ready)
  - [x] 5.7 Add build script to compile TypeScript to `dist/` using `tsc`
  - [x] 5.8 Test server manually by running `node dist/server.js` and sending MCP protocol messages via stdin

- [ ] 6.0 **Documentation & Testing**
  - [x] 6.1 Write `README.md` with quick start (installation, build, Claude Code config, basic usage examples)
  - [x] 6.2 Write `docs/SETUP.md` with detailed installation steps, prerequisites, configuration options
  - [x] 6.3 Write `docs/ARCHITECTURE.md` with system design, component overview, data flow diagrams
  - [x] 6.4 Write `docs/FLOW.md` explaining store/retrieve/update flows with diagrams
  - [x] 6.5 Write `docs/TECH_STACK.md` documenting all dependencies and why they were chosen
  - [x] 6.6 Write `docs/TROUBLESHOOTING.md` with common issues (model download fails, JSON corruption, permission errors)
  - [x] 6.7 Write `docs/CLAUDE_CODE_CONFIG.md` with step-by-step Claude Code MCP configuration
  - [x] 6.8 Create example scenarios in README (store technical decision, retrieve context, update memory)
  - [ ] 6.9 Test all 5 tools end-to-end with Claude Code integration
  - [ ] 6.10 Verify project-specific memories don't leak into other projects (M-3)
  - [ ] 6.11 Verify global memories are accessible from any project (M-4)

---

**Implementation Notes:**
- Follow the PROCESS_TASKS.md workflow: implement one sub-task at a time, wait for user approval before proceeding
- Use AddyPin's existing patterns: TypeScript, async/await, descriptive error messages
- Test each component before moving to the next
- Commit after completing each parent task (when all subtasks are done)
