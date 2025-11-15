# MCP Memory Server - Testing Guide

Guide for completing end-to-end testing with Claude Code (Tasks 6.9-6.11).

## Overview

The MCP Memory Server implementation is complete. This guide helps you verify all functionality works correctly when integrated with Claude Code.

## Prerequisites

Before testing:

1. **Server is built**:
   ```bash
   cd /home/user/addypin/memcp
   npm run build
   ```

2. **Claude Code is configured**:
   - Configuration file updated (see [CLAUDE_CODE_CONFIG.md](CLAUDE_CODE_CONFIG.md))
   - Claude Code restarted after configuration

3. **Server is running**:
   - Check logs for "✅ MCP Memory Server ready!" message
   ```bash
   # macOS
   tail -20 ~/Library/Logs/Claude/mcp*.log

   # Linux
   tail -20 ~/.local/share/Claude/logs/mcp*.log
   ```

## Task 6.9: Test All 5 Tools End-to-End

Test each tool systematically with Claude Code.

### Test 1: memcp_store (Store Memory)

**Test Case 1.1: Store project-scoped technical memory**

Ask Claude Code:
```
Store a memory for me:
Content: "This project uses React 18 with TypeScript for the frontend, located in client/src/"
Category: technical
Tags: ["react", "typescript", "frontend", "architecture"]
Scope: project
Importance: 8
Documentation path: client/src/
```

**Expected Result**:
- Success message with memory ID (UUID)
- Project name displayed (e.g., "addypin")
- Memory stored in `<project>/.mcp-memory/memories.json`

**Verification**:
```bash
cat .mcp-memory/memories.json | jq '.'
# Should show the stored memory with correct fields
```

**Test Case 1.2: Store global preference memory**

Ask Claude Code:
```
Store a global memory:
Content: "I prefer using async/await over .then() for Promise handling"
Category: preference
Tags: ["async", "promises", "javascript", "coding-style"]
Scope: global
Importance: 6
```

**Expected Result**:
- Success message with memory ID
- Scope shown as "global"
- Memory stored in `~/.mcp-memory/global-memories.json`

**Verification**:
```bash
cat ~/.mcp-memory/global-memories.json | jq '.'
# Should show the global memory
```

**Test Case 1.3: Store with missing required field (error handling)**

Ask Claude Code:
```
Store a memory without tags:
Content: "Test memory"
Category: technical
Scope: project
```

**Expected Result**:
- Error message indicating missing required field
- Memory not stored

### Test 2: memcp_retrieve (Semantic Search)

**Test Case 2.1: Retrieve by semantic similarity**

Ask Claude Code:
```
Search my memories for: "How is the frontend organized?"
```

**Expected Result**:
- Returns memory from Test 1.1 (about React/TypeScript)
- Similarity score shown (likely 0.6-0.8)
- Memory details displayed (content, category, tags)

**Test Case 2.2: Retrieve with category filter**

Ask Claude Code:
```
Search for "coding style" in preference category only
```

**Expected Result**:
- Returns memory from Test 1.2 (about async/await)
- Only preference category memories shown
- Technical memories not included

**Test Case 2.3: Retrieve with scope filter**

Ask Claude Code:
```
Search for "React" in project scope only
```

**Expected Result**:
- Returns project-specific memories
- Global memories not included

**Test Case 2.4: Retrieve with limit**

Store a few more memories, then ask:
```
Search for "javascript" but limit to top 3 results
```

**Expected Result**:
- Maximum 3 results returned
- Sorted by similarity score (highest first)

### Test 3: memcp_list (List Memories)

**Test Case 3.1: List all project memories**

Ask Claude Code:
```
List all memories for this project
```

**Expected Result**:
- All project-scoped memories displayed
- No semantic search performed (fast)
- Global memories not included

**Test Case 3.2: List by category**

Ask Claude Code:
```
List all technical memories for this project
```

**Expected Result**:
- Only technical category memories shown
- Other categories excluded

**Test Case 3.3: List by tags**

Ask Claude Code:
```
List memories tagged with "react" or "typescript"
```

**Expected Result**:
- Memories with either tag included
- Other memories excluded

**Test Case 3.4: List global memories**

Ask Claude Code:
```
List all global memories
```

**Expected Result**:
- All global-scoped memories displayed
- Project-specific memories not included

### Test 4: memcp_update (Update Memory)

**Test Case 4.1: Update importance**

First, get a memory ID from the list, then ask:
```
Update memory <id> to set importance to 10
```

**Expected Result**:
- Success message
- Only importance field changed
- Other fields unchanged

**Verification**:
```bash
cat .mcp-memory/memories.json | jq '.[] | select(.id=="<id>")'
# Check importance is now 10
```

**Test Case 4.2: Update content (triggers re-embedding)**

Ask Claude Code:
```
Update memory <id> to change content to:
"This project uses React 18 with TypeScript and Vite for fast HMR"
```

**Expected Result**:
- Success message
- Content updated
- Embedding regenerated (takes ~100-200ms)
- Timestamp updated

**Test Case 4.3: Update tags**

Ask Claude Code:
```
Update memory <id> to add "vite" tag
```

**Expected Result**:
- Success message
- Tags array updated
- Other fields unchanged

**Test Case 4.4: Update non-existent memory (error handling)**

Ask Claude Code:
```
Update memory with ID "invalid-uuid-12345"
```

**Expected Result**:
- Error message: "Memory with ID ... not found"
- No changes made

### Test 5: memcp_delete (Delete Memory)

**Test Case 5.1: Delete existing memory**

Ask Claude Code:
```
Delete memory <id>
```

**Expected Result**:
- Success message with deleted memory details
- Memory removed from JSON file

**Verification**:
```bash
cat .mcp-memory/memories.json | jq '.'
# Memory should not appear
```

**Test Case 5.2: Delete non-existent memory (error handling)**

Ask Claude Code:
```
Delete memory "non-existent-id"
```

**Expected Result**:
- Error message: "Memory with ID ... not found"

### Summary Checklist

- [ ] memcp_store creates project-scoped memories
- [ ] memcp_store creates global memories
- [ ] memcp_store validates required fields
- [ ] memcp_retrieve finds semantically similar memories
- [ ] memcp_retrieve filters by category
- [ ] memcp_retrieve filters by scope
- [ ] memcp_retrieve limits results correctly
- [ ] memcp_list shows all memories without semantic search
- [ ] memcp_list filters by category and tags
- [ ] memcp_update changes specific fields
- [ ] memcp_update regenerates embedding when content changes
- [ ] memcp_update handles non-existent IDs
- [ ] memcp_delete removes memories
- [ ] memcp_delete handles non-existent IDs

## Task 6.10: Verify Project-Specific Memory Isolation

Test that project memories don't leak across projects.

### Setup

1. **Create test project A**:
   ```bash
   mkdir /tmp/test-project-a
   cd /tmp/test-project-a
   echo '{"name": "test-project-a"}' > package.json
   ```

2. **Store memory in project A**:

   In Claude Code (while in `/tmp/test-project-a`):
   ```
   Store a project memory:
   Content: "Project A uses Express.js for the backend"
   Category: technical
   Tags: ["express", "backend", "project-a"]
   Scope: project
   ```

3. **Verify storage**:
   ```bash
   cat /tmp/test-project-a/.mcp-memory/memories.json | jq '.'
   # Should show the memory with project_name: "test-project-a"
   ```

4. **Create test project B**:
   ```bash
   mkdir /tmp/test-project-b
   cd /tmp/test-project-b
   echo '{"name": "test-project-b"}' > package.json
   ```

5. **Try to retrieve Project A's memory from Project B**:

   In Claude Code (while in `/tmp/test-project-b`):
   ```
   Search project memories for "Express backend"
   ```

6. **Expected Result**:
   - No results found (Project A's memory not accessible)
   - Only Project B's memories searchable

7. **Verify with scope "all"**:
   ```
   Search all memories (project and global) for "Express backend"
   ```

8. **Expected Result**:
   - Still no results (project memories are isolated to their project)
   - Only global memories accessible across projects

### Verification Checklist

- [ ] Project A memory stored in Project A's directory
- [ ] Project B cannot see Project A's memories (even with scope "all")
- [ ] Each project has separate `.mcp-memory/memories.json` file
- [ ] Project names correctly identified (from package.json)

## Task 6.11: Verify Global Memory Accessibility

Test that global memories are accessible from any project.

### Setup

1. **Store global memory** (from any project):

   In Claude Code:
   ```
   Store a global memory:
   Content: "Always use descriptive variable names over abbreviations"
   Category: preference
   Tags: ["coding-style", "naming", "best-practice"]
   Scope: global
   ```

2. **Verify storage location**:
   ```bash
   cat ~/.mcp-memory/global-memories.json | jq '.'
   # Should show the global memory
   ```

3. **Access from Project A**:
   ```bash
   cd /tmp/test-project-a
   ```

   In Claude Code:
   ```
   Search global memories for "variable naming"
   ```

4. **Expected Result**:
   - Global memory returned
   - Accessible from Project A

5. **Access from Project B**:
   ```bash
   cd /tmp/test-project-b
   ```

   In Claude Code:
   ```
   Search global memories for "variable naming"
   ```

6. **Expected Result**:
   - Same global memory returned
   - Accessible from Project B

7. **Access from original project**:
   ```bash
   cd /home/user/addypin
   ```

   In Claude Code:
   ```
   Search global memories for "coding style"
   ```

8. **Expected Result**:
   - Global memory returned
   - Accessible from all projects

### Verification Checklist

- [ ] Global memory stored in `~/.mcp-memory/global-memories.json`
- [ ] Global memory accessible from Project A
- [ ] Global memory accessible from Project B
- [ ] Global memory accessible from original project
- [ ] Global memory appears in searches with scope "global" or "all"
- [ ] Global memory does NOT appear in searches with scope "project"

## Performance Benchmarks

While testing, note these performance characteristics:

| Operation | Expected Time | Notes |
|-----------|--------------|-------|
| First embedding | 2-3 seconds | Model initialization |
| Subsequent embeddings | 50-100ms | Model cached |
| Store memory | 100-200ms | Embedding + file I/O |
| Retrieve (semantic) | 50ms per memory | Cosine similarity |
| List memories | 5-10ms | No embeddings |
| Update (no content change) | 5-10ms | File I/O only |
| Update (content change) | 100-200ms | Re-embedding |
| Delete memory | 5-10ms | File I/O only |

## Troubleshooting

If tests fail, check:

1. **Server logs**:
   ```bash
   tail -50 ~/Library/Logs/Claude/mcp*.log
   ```

2. **Memory files exist**:
   ```bash
   ls -la ~/.mcp-memory/
   ls -la .mcp-memory/
   ```

3. **JSON file validity**:
   ```bash
   cat ~/.mcp-memory/global-memories.json | jq '.'
   ```

4. **Configuration correct**:
   - Absolute paths in Claude Code config
   - Server built and `dist/` directory exists
   - Node.js 20+ installed

See [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for detailed solutions.

## Reporting Issues

If you encounter issues during testing:

1. Gather information:
   - Error message
   - Server logs
   - Steps to reproduce
   - Expected vs actual behavior

2. Check if issue is documented in [TROUBLESHOOTING.md](TROUBLESHOOTING.md)

3. If not documented:
   - Create GitHub issue
   - Include all gathered information
   - Tag with "testing" label

## Next Steps After Testing

Once all tests pass:

1. **Mark tasks complete** in `tasks/tasks-0001-prd-mcp-memory-server.md`
2. **Update project status** to "Production Ready"
3. **Share feedback** on what worked well or could be improved
4. **Start using** the memory server in your daily workflow!

## Usage Tips

After successful testing, consider:

1. **Create memory templates** for common use cases
2. **Establish tagging conventions** for your team
3. **Set up regular memory reviews** (weekly/monthly)
4. **Document important project decisions** as memories
5. **Use global memories** for personal preferences and patterns

---

**Related**: [Setup Guide](SETUP.md) | [Claude Code Config](CLAUDE_CODE_CONFIG.md) | [Troubleshooting](TROUBLESHOOTING.md)
