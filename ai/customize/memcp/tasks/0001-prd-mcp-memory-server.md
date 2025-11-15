# PRD: MCP Memory Server for Claude Code

## 1. Introduction/Overview

This PRD outlines the design and implementation of a Model Context Protocol (MCP) memory server that provides persistent, searchable memory capabilities to Claude Code. The server enables Claude to remember project-specific context (technical decisions, bugs, deployment history) and cross-project "ways of working" (preferences, patterns, conventions) across sessions.

**Problem Statement:** While CLAUDE.md files provide excellent static project documentation, they require manual updates and don't capture dynamic learnings from development sessions. Claude currently cannot remember context like:
- "Why did we choose X technology over Y?"
- "This deployment failed because of Z issue"
- "User prefers async/await over promises"
- "Port 8080 caused SSL issues on staging"

**Solution:** A lightweight, JSON-based MCP memory server that Claude can query and update through tool calls, complementing (not replacing) CLAUDE.md with dynamic, session-learned context.

## 2. Goals

1. **Enable Persistent Memory:** Allow Claude to store and retrieve factual information across sessions
2. **Project-Specific Context:** Maintain separate memory stores for each project
3. **Cross-Project Patterns:** Share "ways of working" memories across all projects
4. **Semantic Search:** Enable Claude to find relevant memories using embeddings-based search
5. **Transparency:** Make all memory operations visible through tool calls
6. **Reusability:** Create a generic MCP server usable beyond AddyPin
7. **Simplicity:** Keep implementation simple (JSON storage, no complex dependencies)

## 3. User Stories

**As a developer using Claude Code, I want to:**
- **Story 1:** Store technical decisions so Claude remembers why we made architectural choices
  - "Remember: We use Drizzle ORM instead of Prisma because it's lighter and more type-safe"

- **Story 2:** Save bug fixes and gotchas so Claude can reference past issues
  - "Remember: Port 8080 on staging caused SSL termination issues with Nginx reverse proxy. Solution: Use port 3001 internally."

- **Story 3:** Set personal preferences once and have them persist
  - "Remember: I prefer verbose commit messages with bullet points for key changes"

- **Story 4:** Track deployment history for troubleshooting
  - "Remember: Production deployment on 2025-11-10 failed due to missing DATABASE_URL env var"

- **Story 5:** Share coding conventions across projects
  - "Remember [global]: Always use async/await instead of .then() chains"

- **Story 6:** Search memories semantically when I ask questions
  - "What was that database issue we had last week?" → Claude searches memories and finds relevant context

## 4. Functional Requirements

### Core Memory Operations

1. **FR-1:** The system must provide a `memcp_store` tool that accepts:
   - `content`: The memory text to store
   - `category`: One of ["technical", "deployment", "preference", "bug", "ways_of_working"]
   - `tags`: Array of entity tags (e.g., ["nginx", "ssl", "staging"])
   - `scope`: Either "project" or "global"
   - `importance`: Integer 1-10 (default: 5)
   - `documentation_path`: Optional path to related documentation (e.g., "docs/ARCHITECTURE.md#section")

2. **FR-2:** The system must provide a `memcp_retrieve` tool that accepts:
   - `query`: Search query string
   - `category`: Optional category filter
   - `scope`: Optional scope filter ("project", "global", or "all")
   - `limit`: Max results to return (default: 5)

3. **FR-3:** The system must provide a `memcp_list` tool that returns all memories with optional filters:
   - `category`: Filter by category
   - `scope`: Filter by scope
   - `tags`: Filter by tag presence

4. **FR-4:** The system must provide a `memcp_delete` tool that accepts:
   - `memory_id`: UUID of memory to delete

5. **FR-5:** The system must provide a `memcp_update` tool that accepts:
   - `memory_id`: UUID of memory to update (required)
   - `content`: Optional updated memory text
   - `category`: Optional updated category
   - `tags`: Optional updated tags array
   - `importance`: Optional updated importance (1-10)
   - `documentation_path`: Optional updated documentation link

   **Update Rules:**
   - At least one field (besides memory_id) must be provided
   - If `content` is updated, the embedding must be automatically regenerated
   - The `timestamp` field must be automatically updated to current time
   - The following fields are immutable and cannot be updated:
     - `id` (memory identifier)
     - `scope` (cannot convert project ↔ global)
     - `project_name` / `project_path` (tied to storage location)
   - Returns the updated memory object or error if memory_id not found

### Storage & Data Structure

6. **FR-6:** The system must store memories in JSON files with the following structure:
   ```json
   {
     "id": "uuid-v4",
     "content": "Memory text",
     "category": "technical",
     "tags": ["drizzle", "orm", "database"],
     "scope": "project",
     "project_name": "addypin",
     "project_path": "/home/user/addypin",
     "importance": 7,
     "timestamp": "2025-11-14T10:30:00Z",
     "documentation_path": null,
     "embedding": [0.123, 0.456, ...]
   }
   ```

7. **FR-7:** Project-specific memories must be stored in `<project_root>/.mcp-memory/memories.json`

8. **FR-8:** Global memories must be stored in `~/.mcp-memory/global-memories.json`

9. **FR-9:** Each memory must include a timestamp of when it was created

10. **FR-10:** Each project-scoped memory must include both project name (human-readable) and project path (absolute path)

11. **FR-11:** The `documentation_path` field is optional and should link memories to relevant documentation files when applicable

### Search & Retrieval

12. **FR-12:** The system must generate embeddings for each memory using a simple embedding model (e.g., sentence-transformers or OpenAI embeddings API)

13. **FR-13:** The `memcp_retrieve` tool must use cosine similarity to rank memories by relevance to the query

14. **FR-14:** Search results must include:
    - Memory content
    - Category and tags
    - Similarity score (relevance score 0-1)
    - Timestamp
    - Memory ID (for updates/deletes)
    - Project name (for project-scoped memories)

15. **FR-15:** The system must support keyword-based fallback search if embedding generation fails

### MCP Server Integration

16. **FR-16:** The server must implement the MCP specification (stdio transport)

17. **FR-17:** The server must declare all tools in the `tools/list` response

18. **FR-18:** The server must handle `tools/call` requests for each tool

19. **FR-19:** The server must include error handling with descriptive error messages

20. **FR-20:** The server must auto-detect the current project based on the working directory

### Configuration

21. **FR-21:** The system must provide a configuration file at `~/.mcp-memory/config.json` with:
    - `embedding_provider`: "local" or "openai"
    - `embedding_model`: Model name/path
    - `default_limit`: Default search result limit
    - `auto_embed`: Boolean to enable/disable automatic embedding generation

22. **FR-22:** If no config exists, the system must create one with sensible defaults

## 5. Non-Goals (Out of Scope)

1. **NG-1:** **Does not replace CLAUDE.md** - This system complements static documentation, not replaces it
2. **NG-2:** **No cloud sync** - All storage is local-only for privacy and simplicity
3. **NG-3:** **No automatic memory extraction** - Claude must explicitly call `memcp_store` (no passive recording)
4. **NG-4:** **No complex AI summarization** - Memories are stored as-is, not compressed or rewritten
5. **NG-5:** **No multi-user collaboration** - Single-user, local-only system
6. **NG-6:** **No memory expiration/cleanup** - Users manually manage memory lifecycle
7. **NG-7:** **No integration with external services** - Standalone MCP server only

## 6. Design Considerations

### MCP Server Architecture

The MCP server will follow this structure:
```
/memcp/
├── src/
│   ├── server.ts           # Main MCP server entry point
│   ├── tools/
│   │   ├── memcpStore.ts   # memcp_store tool implementation
│   │   ├── memcpRetrieve.ts # memcp_retrieve tool implementation
│   │   ├── memcpList.ts    # memcp_list tool implementation
│   │   ├── memcpDelete.ts  # memcp_delete tool implementation
│   │   └── memcpUpdate.ts  # memcp_update tool implementation
│   ├── storage/
│   │   ├── MemoryStore.ts  # Core storage logic
│   │   └── types.ts        # TypeScript interfaces
│   ├── embeddings/
│   │   ├── EmbeddingProvider.ts # Abstract embedding interface
│   │   ├── LocalEmbeddings.ts   # Local model implementation
│   │   └── OpenAIEmbeddings.ts  # OpenAI API implementation (optional)
│   └── utils/
│       ├── config.ts       # Config file management
│       └── search.ts       # Similarity search logic
├── package.json
├── tsconfig.json
└── README.md
```

### Example Claude Code Configuration

To use the server, users will add to Claude Code's MCP settings:
```json
{
  "mcpServers": {
    "memory": {
      "command": "node",
      "args": ["/path/to/memcp/dist/server.js"],
      "env": {}
    }
  }
}
```

### Example Usage Scenarios

**Scenario 1: Storing a Technical Decision**
```
User: "Remember: We use esbuild with --packages=external because bundling
       dependencies causes 'Dynamic require not supported' errors"

Claude: [Calls memcp_store tool]
{
  "content": "Use esbuild with --packages=external flag...",
  "category": "technical",
  "tags": ["esbuild", "bundling", "backend"],
  "scope": "project",
  "importance": 8,
  "documentation_path": "CLAUDE.md#build-strategy"
}

Response: "I'll remember that AddyPin uses esbuild with external packages."
```

**Scenario 2: Retrieving Context**
```
User: "Why do we use external packages in esbuild?"

Claude: [Calls memcp_retrieve tool]
{
  "query": "esbuild external packages",
  "category": "technical",
  "scope": "project"
}

Response: "According to my memory, you use esbuild with --packages=external
          because bundling dependencies causes 'Dynamic require not supported'
          errors. [Project: addypin, Stored: 2025-11-10]"
```

**Scenario 3: Global Preferences**
```
User: "Remember globally: I prefer async/await over promise chains"

Claude: [Calls memcp_store tool]
{
  "content": "Prefer async/await over .then() promise chains",
  "category": "ways_of_working",
  "tags": ["javascript", "code-style"],
  "scope": "global",
  "importance": 6
}
```

**Scenario 4: Updating a Memory**
```
User: "Actually, staging uses port 3001, not 8080. Can you update that?"

Claude: [Calls memcp_retrieve tool first]
{
  "query": "staging port 8080",
  "scope": "project"
}

Response: [
  {
    "id": "abc-123",
    "content": "Port 8080 on staging caused SSL termination issues...",
    "similarity_score": 0.92
  }
]

Claude: [Calls memcp_update tool]
{
  "memory_id": "abc-123",
  "content": "Port 3001 is used internally on staging. Port 8080 caused SSL termination issues with Nginx reverse proxy."
}

Response: "Updated the staging port memory. The embedding has been regenerated and timestamp updated."
```

## 7. Technical Considerations

### Technology Stack
- **Runtime:** Node.js 20+ (matches AddyPin stack)
- **Language:** TypeScript (type safety, matches AddyPin)
- **MCP SDK:** `@modelcontextprotocol/sdk` (official Anthropic SDK)
- **Embeddings:**
  - Option 1: `@xenova/transformers` (local, no API calls)
  - Option 2: OpenAI Embeddings API (requires API key, optional)
- **Storage:** Node.js `fs` module with JSON serialization
- **Search:** Cosine similarity using simple vector math

### Dependencies
```json
{
  "dependencies": {
    "@modelcontextprotocol/sdk": "^1.0.0",
    "@xenova/transformers": "^2.10.0",
    "uuid": "^9.0.0"
  },
  "devDependencies": {
    "@types/node": "^20.0.0",
    "@types/uuid": "^9.0.0",
    "typescript": "^5.0.0",
    "tsx": "^4.0.0"
  }
}
```

### Configuration Defaults
```json
{
  "embedding_provider": "local",
  "embedding_model": "Xenova/all-MiniLM-L6-v2",
  "default_limit": 5,
  "auto_embed": true
}
```

### Error Handling
- Invalid JSON files: Log error, return empty array
- Missing directories: Auto-create `.mcp-memory` folders
- Embedding failures: Fall back to keyword search
- Tool call errors: Return descriptive error messages to Claude

### Performance Considerations
- Load memories lazily (only when needed)
- Cache embeddings (don't regenerate on every search)
- Limit search results (default: 5, max: 20)
- Simple JSON files (no database overhead for MVP)

## 8. Success Metrics

### Functional Success
1. **M-1:** Claude can store a memory and retrieve it in a subsequent session
2. **M-2:** Semantic search returns relevant memories (tested with 10+ stored memories)
3. **M-3:** Project-specific memories don't leak into other projects
4. **M-4:** Global memories are accessible from any project
5. **M-5:** All tool calls complete within 2 seconds (local operations)

### Usability Success
6. **M-6:** A junior developer can install and configure the MCP server in <10 minutes
7. **M-7:** Claude Code recognizes and uses all memory tools without errors
8. **M-8:** Memory files are human-readable and manually editable

### Integration Success
9. **M-9:** Example usage scenarios work end-to-end without issues
10. **M-10:** Documentation enables reuse beyond AddyPin project

## 9. Open Questions

1. **Embedding Model Size:** Should we use a smaller model for faster load times, or a larger model for better accuracy?
   - Proposed: Start with `all-MiniLM-L6-v2` (80MB, fast)

2. **Memory Limits:** Should we impose limits on total memories per project?
   - Proposed: No limits for MVP, add warnings if files exceed 10MB

3. **Migration Path:** How should users migrate memories if we change the JSON schema?
   - Proposed: Version the schema, provide migration scripts if needed

4. **Multi-project Context:** Should "global" memories include a "last_used_in" field to track which projects reference them?
   - Proposed: Add in v2, skip for MVP

5. **Memory Importance:** Should Claude auto-calculate importance based on user signals, or always require explicit input?
   - **Resolved:** Default to 5, allow explicit override

6. **Tool Naming:** Should tools be prefixed with `memory_` (e.g., `memory_store`) or kept simple (`store_memory`)?
   - **Resolved:** Use `memcp_*` prefix (e.g., `memcp_store`, `memcp_retrieve`) for clarity and namespace isolation

---

**PRD Version:** 1.2
**Created:** 2025-11-14
**Updated:** 2025-11-14
**Status:** Draft - Ready for Task Generation

**Changelog v1.2:**
- Clarified `memcp_update` behavior with detailed update rules (FR-5)
- Defined immutable fields (scope, project_name, project_path, id)
- Specified automatic embedding regeneration when content changes
- Specified automatic timestamp update on any modification
- Added Scenario 4: Update workflow showing retrieve → update pattern

**Changelog v1.1:**
- Updated tool names to use `memcp_*` prefix
- Added `project_name` field to JSON schema for human-readable project identification
- Added optional `documentation_path` field to link memories with documentation
- Updated FR numbering after schema additions
- Resolved Open Questions #5 and #6
- Updated example usage scenarios with new tool names and schema fields
