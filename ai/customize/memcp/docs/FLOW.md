# MCP Memory Server - Data Flow

Detailed request/response flows and sequence diagrams for all operations.

## Table of Contents

1. [Overview](#overview)
2. [Store Memory Flow](#store-memory-flow)
3. [Retrieve Memory Flow](#retrieve-memory-flow)
4. [List Memory Flow](#list-memory-flow)
5. [Update Memory Flow](#update-memory-flow)
6. [Delete Memory Flow](#delete-memory-flow)
7. [Server Lifecycle](#server-lifecycle)
8. [Error Flows](#error-flows)

## Overview

The MCP Memory Server uses **stdio transport** with JSON-RPC protocol for communication with Claude Code. All operations follow a request-response pattern.

### General Flow Pattern

```
┌─────────────┐                    ┌──────────────┐
│ Claude Code │                    │ MCP Server   │
└──────┬──────┘                    └──────┬───────┘
       │                                  │
       │  1. Tool Call Request (JSON-RPC) │
       ├─────────────────────────────────►│
       │                                  │
       │                                  │  2. Process Request
       │                                  │     - Validate input
       │                                  │     - Execute logic
       │                                  │     - Handle errors
       │                                  │
       │  3. Tool Response (JSON-RPC)     │
       ◄─────────────────────────────────┤
       │                                  │
```

### MCP Protocol Structure

**Request Format**:
```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "method": "tools/call",
  "params": {
    "name": "memcp_store",
    "arguments": {
      "content": "...",
      "category": "technical",
      ...
    }
  }
}
```

**Response Format**:
```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": {
    "content": [
      {
        "type": "text",
        "text": "✓ Memory stored successfully..."
      }
    ]
  }
}
```

## Store Memory Flow

### High-Level Sequence

```
Claude Code   memcpStore   LocalEmbeddings   MemoryStore   FileSystem
     │             │              │               │             │
     │  1. store   │              │               │             │
     ├────────────►│              │               │             │
     │             │              │               │             │
     │             │  2. generate │               │             │
     │             │   embedding  │               │             │
     │             ├─────────────►│               │             │
     │             │              │               │             │
     │             │              │  3. initialize│             │
     │             │              │    (first use)│             │
     │             │              ├──────────────►│             │
     │             │              │               │  4. read    │
     │             │              │               │    cache    │
     │             │              │               ├────────────►│
     │             │              │               │             │
     │             │              │  5. [384 dim] │             │
     │             │◄─────────────┤               │             │
     │             │              │               │             │
     │             │  6. detect   │               │             │
     │             │   project    │               │             │
     │             ├───────┐      │               │             │
     │             │       │      │               │             │
     │             │◄──────┘      │               │             │
     │             │              │               │             │
     │             │  7. save     │               │             │
     │             │   memory     │               │             │
     │             ├──────────────────────────────►│             │
     │             │              │               │             │
     │             │              │               │  8. mkdir   │
     │             │              │               ├────────────►│
     │             │              │               │             │
     │             │              │               │  9. read    │
     │             │              │               ├────────────►│
     │             │              │               │             │
     │             │              │               │ 10. append  │
     │             │              │               │             │
     │             │              │               │ 11. write   │
     │             │              │               ├────────────►│
     │             │              │               │             │
     │             │              │               │◄────────────┤
     │             │◄──────────────────────────────┤             │
     │             │              │               │             │
     │ 12. success │              │               │             │
     │◄────────────┤              │               │             │
     │             │              │               │             │
```

### Detailed Steps

1. **Input Validation**
   ```typescript
   // Check required fields
   if (!input.content || input.content.trim().length === 0) {
     throw new Error("Content is required and cannot be empty");
   }
   // Validate category, tags, scope
   ```

2. **Embedding Generation**
   ```typescript
   const embedding = await embeddingProvider.generateEmbedding(input.content);
   // Returns: number[384]
   // Time: ~50-100ms (after initial model load)
   ```

3. **Project Detection** (if scope = "project")
   ```typescript
   const project_name = getProjectName();     // From package.json or dir
   const project_path = getProjectPath();     // Current working directory
   ```

4. **Memory Object Creation**
   ```typescript
   const memory: Memory = {
     id: uuidv4(),                           // Generate UUID
     content: input.content.trim(),
     category: input.category,
     tags: input.tags,
     scope: input.scope,
     importance: input.importance ?? 5,
     timestamp: new Date().toISOString(),
     documentation_path: input.documentation_path ?? null,
     embedding: embedding,
   };

   if (project_name) memory.project_name = project_name;
   if (project_path) memory.project_path = project_path;
   ```

5. **Storage**
   ```typescript
   await MemoryStore.saveMemory(memory, project_path);
   // 1. Create .mcp-memory/ directory if needed
   // 2. Load existing memories.json
   // 3. Append new memory or update if ID exists
   // 4. Write back to file with formatting
   ```

6. **Response**
   ```typescript
   return `✓ Memory stored successfully (project: ${project_name})
   ID: ${memoryId}
   Category: ${input.category}
   Importance: ${importance}
   Tags: ${input.tags.join(", ")}`;
   ```

## Retrieve Memory Flow

### High-Level Sequence

```
Claude Code   memcpRetrieve   LocalEmbeddings   MemoryStore   search.ts
     │              │                │               │            │
     │  1. retrieve │                │               │            │
     ├─────────────►│                │               │            │
     │              │                │               │            │
     │              │  2. generate   │               │            │
     │              │    embedding   │               │            │
     │              ├───────────────►│               │            │
     │              │                │               │            │
     │              │  3. [384 dim]  │               │            │
     │              │◄───────────────┤               │            │
     │              │                │               │            │
     │              │  4. load       │               │            │
     │              │   memories     │               │            │
     │              ├────────────────────────────────►│            │
     │              │                │               │            │
     │              │  5. [memories] │               │            │
     │              │◄────────────────────────────────┤            │
     │              │                │               │            │
     │              │  6. filter by  │               │            │
     │              │    category    │               │            │
     │              ├───────┐        │               │            │
     │              │       │        │               │            │
     │              │◄──────┘        │               │            │
     │              │                │               │            │
     │              │  7. semantic   │               │            │
     │              │    search      │               │            │
     │              ├────────────────────────────────────────────►│
     │              │                │               │            │
     │              │                │               │  8. compute│
     │              │                │               │    cosine  │
     │              │                │               │  similarity│
     │              │                │               │            │
     │              │                │               │  9. rank   │
     │              │                │               │            │
     │              │ 10. [results]  │               │            │
     │              │◄────────────────────────────────────────────┤
     │              │                │               │            │
     │ 11. results  │                │               │            │
     │◄─────────────┤                │               │            │
     │              │                │               │            │
```

### Detailed Steps

1. **Query Embedding**
   ```typescript
   const queryEmbedding = await embeddingProvider.generateEmbedding(input.query);
   // Same 384-dim vector as stored memories
   ```

2. **Load Memories**
   ```typescript
   let memories: Memory[] = [];

   if (input.scope === "project" || input.scope === "all") {
     const projectMemories = await MemoryStore.loadMemories("project", projectPath);
     memories.push(...projectMemories);
   }

   if (input.scope === "global" || input.scope === "all") {
     const globalMemories = await MemoryStore.loadMemories("global");
     memories.push(...globalMemories);
   }
   ```

3. **Apply Filters**
   ```typescript
   if (input.category) {
     memories = memories.filter(m => m.category === input.category);
   }
   ```

4. **Semantic Search**
   ```typescript
   // Compute similarity for each memory
   const results = memories.map(memory => ({
     memory,
     similarity: cosineSimilarity(queryEmbedding, memory.embedding)
   }));

   // Sort by similarity (descending)
   results.sort((a, b) => b.similarity - a.similarity);

   // Take top N
   const topResults = results.slice(0, input.limit ?? 5);
   ```

5. **Keyword Boost** (optional enhancement)
   ```typescript
   // Boost scores if query terms appear in content/tags
   const queryTerms = input.query.toLowerCase().split(/\s+/);

   results.forEach(result => {
     const contentLower = result.memory.content.toLowerCase();
     const tagsLower = result.memory.tags.map(t => t.toLowerCase());

     const keywordMatches = queryTerms.filter(term =>
       contentLower.includes(term) ||
       tagsLower.some(tag => tag.includes(term))
     ).length;

     // Boost score by 0.1 per keyword match
     result.similarity += keywordMatches * 0.1;
   });
   ```

6. **Response**
   ```json
   [
     {
       "memory": {
         "id": "...",
         "content": "...",
         ...
       },
       "similarity": 0.87
     },
     ...
   ]
   ```

## List Memory Flow

### High-Level Sequence

```
Claude Code   memcpList   MemoryStore   FileSystem
     │            │            │             │
     │  1. list   │            │             │
     ├───────────►│            │             │
     │            │            │             │
     │            │  2. load   │             │
     │            ├───────────►│             │
     │            │            │             │
     │            │            │  3. read    │
     │            │            ├────────────►│
     │            │            │             │
     │            │            │  4. parse   │
     │            │            │             │
     │            │  5. [all]  │             │
     │            │◄───────────┤             │
     │            │            │             │
     │            │  6. filter │             │
     │            │   (category│             │
     │            │    /tags)  │             │
     │            ├───────┐    │             │
     │            │       │    │             │
     │            │◄──────┘    │             │
     │            │            │             │
     │  7. [list] │            │             │
     │◄───────────┤            │             │
     │            │            │             │
```

### Detailed Steps

1. **Load Memories** (based on scope)
   ```typescript
   let allMemories: Memory[] = [];

   // Load project memories if requested
   if (input.scope === "project" || input.scope === "all") {
     allMemories.push(...await MemoryStore.loadMemories("project", projectPath));
   }

   // Load global memories if requested
   if (input.scope === "global" || input.scope === "all") {
     allMemories.push(...await MemoryStore.loadMemories("global"));
   }
   ```

2. **Apply Filters**
   ```typescript
   let filteredMemories = allMemories;

   // Filter by category
   if (input.category) {
     filteredMemories = filteredMemories.filter(
       m => m.category === input.category
     );
   }

   // Filter by tags (any tag matches)
   if (input.tags && input.tags.length > 0) {
     filteredMemories = filteredMemories.filter(memory =>
       input.tags!.some(tag => memory.tags.includes(tag))
     );
   }
   ```

3. **Response** (no embedding computation)
   ```json
   [
     { "id": "...", "content": "...", "category": "technical", ... },
     { "id": "...", "content": "...", "category": "deployment", ... },
     ...
   ]
   ```

**Performance**: Fast (~5-10ms) - no embedding generation

## Update Memory Flow

### High-Level Sequence

```
Claude Code   memcpUpdate   LocalEmbeddings   MemoryStore   FileSystem
     │             │               │               │             │
     │  1. update  │               │               │             │
     ├────────────►│               │               │             │
     │             │               │               │             │
     │             │  2. find by   │               │             │
     │             │     ID        │               │             │
     │             ├───────────────────────────────►│             │
     │             │               │               │             │
     │             │               │               │  3. read    │
     │             │               │               ├────────────►│
     │             │               │               │             │
     │             │  4. [found]   │               │             │
     │             │◄───────────────────────────────┤             │
     │             │               │               │             │
     │             │  5. if content│               │             │
     │             │    changed    │               │             │
     │             ├──────┐        │               │             │
     │             │      │        │               │             │
     │             │◄─────┘        │               │             │
     │             │               │               │             │
     │             │  6. regenerate│               │             │
     │             │    embedding  │               │             │
     │             ├──────────────►│               │             │
     │             │               │               │             │
     │             │  7. [384 dim] │               │             │
     │             │◄──────────────┤               │             │
     │             │               │               │             │
     │             │  8. update    │               │             │
     │             │    memory     │               │             │
     │             ├───────────────────────────────►│             │
     │             │               │               │             │
     │             │               │               │  9. write   │
     │             │               │               ├────────────►│
     │             │               │               │             │
     │             │               │               │◄────────────┤
     │             │◄───────────────────────────────┤             │
     │             │               │               │             │
     │ 10. success │               │               │             │
     │◄────────────┤               │               │             │
     │             │               │               │             │
```

### Detailed Steps

1. **Find Existing Memory**
   ```typescript
   // Search both scopes
   const projectMemories = await MemoryStore.loadMemories("project", projectPath);
   const globalMemories = await MemoryStore.loadMemories("global");

   let existingMemory = projectMemories.find(m => m.id === input.memory_id);
   let scope: "project" | "global" = "project";

   if (!existingMemory) {
     existingMemory = globalMemories.find(m => m.id === input.memory_id);
     scope = "global";
   }

   if (!existingMemory) {
     throw new Error(`Memory with ID ${input.memory_id} not found`);
   }
   ```

2. **Update Fields**
   ```typescript
   const updatedMemory: Memory = { ...existingMemory };

   if (input.content !== undefined) {
     updatedMemory.content = input.content.trim();
     // Regenerate embedding
     updatedMemory.embedding = await embeddingProvider.generateEmbedding(input.content);
   }

   if (input.category !== undefined) {
     updatedMemory.category = input.category;
   }

   if (input.tags !== undefined) {
     updatedMemory.tags = input.tags;
   }

   // ... other fields
   ```

3. **Save Updated Memory**
   ```typescript
   await MemoryStore.updateMemory(
     updatedMemory,
     scope === "project" ? projectPath : undefined
   );
   ```

4. **Response**
   ```typescript
   return `✓ Memory updated successfully
   ID: ${input.memory_id}
   Fields updated: ${updatedFields.join(", ")}`;
   ```

## Delete Memory Flow

### High-Level Sequence

```
Claude Code   memcpDelete   MemoryStore   FileSystem
     │             │              │             │
     │  1. delete  │              │             │
     ├────────────►│              │             │
     │             │              │             │
     │             │  2. find by  │             │
     │             │     ID       │             │
     │             ├─────────────►│             │
     │             │              │             │
     │             │              │  3. read    │
     │             │              ├────────────►│
     │             │              │             │
     │             │  4. [found]  │             │
     │             │◄─────────────┤             │
     │             │              │             │
     │             │  5. delete   │             │
     │             ├─────────────►│             │
     │             │              │             │
     │             │              │  6. read    │
     │             │              ├────────────►│
     │             │              │             │
     │             │              │  7. filter  │
     │             │              │             │
     │             │              │  8. write   │
     │             │              ├────────────►│
     │             │              │             │
     │             │◄─────────────┤             │
     │             │              │             │
     │  9. success │              │             │
     │◄────────────┤              │             │
     │             │              │             │
```

### Detailed Steps

1. **Find Memory**
   ```typescript
   // Search both scopes
   const [projectMemories, globalMemories] = await Promise.all([
     MemoryStore.loadMemories("project", projectPath),
     MemoryStore.loadMemories("global"),
   ]);

   let existingMemory = projectMemories.find(m => m.id === input.memory_id);
   let scope: "project" | "global";

   if (existingMemory) {
     scope = "project";
   } else {
     existingMemory = globalMemories.find(m => m.id === input.memory_id);
     scope = "global";
   }

   if (!existingMemory) {
     throw new Error(`Memory with ID ${input.memory_id} not found`);
   }
   ```

2. **Delete from Storage**
   ```typescript
   const deletedMemory = await MemoryStore.deleteMemory(
     input.memory_id,
     scope,
     scope === "project" ? projectPath : undefined
   );
   ```

3. **Response**
   ```typescript
   return `✓ Memory deleted successfully (${scope})
   ID: ${input.memory_id}
   Category: ${deletedMemory.category}
   Content: ${deletedMemory.content.substring(0, 100)}...`;
   ```

## Server Lifecycle

### Startup Sequence

```
1. main() called
   ↓
2. Load configuration (~/.mcp-memory/config.json or defaults)
   ↓
3. Create LocalEmbeddings instance (model not loaded yet)
   ↓
4. Create MCP Server with stdio transport
   ↓
5. Register tool handlers:
   - tools/list → return tool schemas
   - tools/call → route to tool implementations
   ↓
6. Connect to stdio transport
   ↓
7. Server ready, listening on stdin
   ↓
8. Wait for tool calls...
```

### First Tool Call

```
1. Tool call received (e.g., memcp_store)
   ↓
2. embeddingProvider.generateEmbedding() called
   ↓
3. Check if model is loaded → NO
   ↓
4. Initialize model:
   - Check ~/.cache/huggingface/ for cached model
   - If not cached: Download from Hugging Face (~80MB)
   - Load ONNX model into memory
   - Load tokenizer
   ↓
5. Generate embedding (384-dim vector)
   ↓
6. Continue with tool logic
   ↓
7. Model remains in memory for subsequent calls
```

### Shutdown Sequence

```
1. SIGINT or SIGTERM received
   ↓
2. Log shutdown message
   ↓
3. embeddingProvider.cleanup()
   - Release model resources
   - Clear cached data
   ↓
4. Exit process (code 0)
```

## Error Flows

### Validation Error

```
Claude Code → memcp_store (invalid input)
                   ↓
          Input validation fails
                   ↓
          Throw Error("...")
                   ↓
          Server catches error
                   ↓
          Return error response:
          { isError: true, content: "Error: ..." }
                   ↓
Claude Code ← Error displayed to user
```

### Storage Error

```
Tool → MemoryStore.saveMemory()
            ↓
    fs.writeFile() fails (EACCES)
            ↓
    Catch error, inspect error.code
            ↓
    Throw descriptive error:
    "Permission denied: Cannot write to ..."
            ↓
    Server catches, returns error response
```

### Embedding Error

```
Tool → embeddingProvider.generateEmbedding()
                 ↓
       Model initialization fails
                 ↓
       Throw Error("Failed to initialize...")
                 ↓
       Tool catches error
                 ↓
       Return user-friendly message:
       "Embedding generation failed. Check internet connection..."
```

### Not Found Error

```
memcp_update → Find memory by ID
                      ↓
            Search project memories → NOT FOUND
                      ↓
            Search global memories → NOT FOUND
                      ↓
            Throw Error("Memory with ID ... not found")
                      ↓
            Server returns error response
```

---

**Related**: [Architecture](ARCHITECTURE.md) | [Tech Stack](TECH_STACK.md)
