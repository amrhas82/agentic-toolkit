# MCP Memory Server - Troubleshooting

Common issues, error messages, and solutions for the MCP Memory Server.

## Table of Contents

1. [Installation Issues](#installation-issues)
2. [Server Startup Issues](#server-startup-issues)
3. [Claude Code Integration Issues](#claude-code-integration-issues)
4. [Storage Issues](#storage-issues)
5. [Embedding Issues](#embedding-issues)
6. [Search and Retrieval Issues](#search-and-retrieval-issues)
7. [Performance Issues](#performance-issues)
8. [Debugging Tips](#debugging-tips)

## Installation Issues

### Issue: `npm install` fails with network errors

**Error**:
```
npm ERR! network request to https://registry.npmjs.org/... failed
```

**Solutions**:
1. Check internet connection
2. Try with different registry:
   ```bash
   npm install --registry=https://registry.npmjs.org/
   ```
3. Clear npm cache:
   ```bash
   npm cache clean --force
   npm install
   ```
4. Use `--ignore-scripts` if optional dependencies fail:
   ```bash
   npm install --ignore-scripts
   ```

### Issue: Sharp proxy error during installation

**Error**:
```
sharp: Installation error: Status 403 Forbidden
```

**Solution**:
Sharp is an optional dependency of @xenova/transformers. Use:
```bash
npm install --ignore-scripts
```

This skips optional dependencies without affecting core functionality.

### Issue: TypeScript compilation fails

**Error**:
```
error TS2307: Cannot find module '@modelcontextprotocol/sdk/server/index.js'
```

**Solutions**:
1. Ensure dependencies are installed:
   ```bash
   npm install
   ```
2. Check Node.js version (must be 20+):
   ```bash
   node --version
   ```
3. Clean and rebuild:
   ```bash
   rm -rf node_modules dist
   npm install
   npm run build
   ```

## Server Startup Issues

### Issue: "Cannot find module" when starting server

**Error**:
```
Error: Cannot find module '/home/user/addypin/memcp/dist/server.js'
```

**Solutions**:
1. Build the project first:
   ```bash
   npm run build
   ```
2. Verify dist/ directory exists:
   ```bash
   ls -la dist/
   ```
3. If using development mode:
   ```bash
   npm run dev  # Uses tsx, no build needed
   ```

### Issue: Server starts but Claude Code can't connect

**Error**: No error message, server appears running but tools not available

**Solutions**:
1. Check Claude Code configuration path is correct:
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
2. Use absolute paths (not relative like `./dist/server.js`)
3. Restart Claude Code completely (quit and reopen)
4. Check server logs (see [Debugging Tips](#debugging-tips))

### Issue: "EADDRINUSE: address already in use"

**Note**: This shouldn't happen with stdio transport, but if using custom transport:

**Solution**:
1. Kill existing process:
   ```bash
   pkill -f "node.*server.js"
   ```
2. Find and kill process on port:
   ```bash
   lsof -ti:3000 | xargs kill -9
   ```

### Issue: Node.js version too old

**Error**:
```
SyntaxError: Unexpected token 'export'
```

**Solution**:
Install Node.js 20 or higher:
```bash
# Check current version
node --version

# Install Node.js 20 (Ubuntu/Debian)
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs
```

## Claude Code Integration Issues

### Issue: Tools not appearing in Claude Code

**Symptoms**: Ask "What MCP tools are available?" and don't see memcp_* tools

**Solutions**:
1. Verify server is configured in Claude Code settings
2. Check configuration file location:
   - macOS: `~/Library/Application Support/Claude/claude_desktop_config.json`
   - Linux: `~/.config/Claude/claude_desktop_config.json`
3. Validate JSON syntax:
   ```bash
   node -e "console.log(JSON.parse(require('fs').readFileSync('PATH')))"
   ```
4. Restart Claude Code completely (quit, not just close window)
5. Check MCP server logs:
   ```bash
   # macOS
   tail -f ~/Library/Logs/Claude/mcp*.log

   # Linux
   tail -f ~/.local/share/Claude/logs/mcp*.log
   ```

### Issue: "Server error" when calling tools

**Error**: Generic "Server error" message in Claude Code

**Solutions**:
1. Check server logs for actual error
2. Verify server process is running:
   ```bash
   ps aux | grep server.js
   ```
3. Test server standalone:
   ```bash
   cd /home/user/addypin/memcp
   npm run dev
   ```
4. Check file permissions:
   ```bash
   ls -la dist/server.js
   # Should be readable: -rw-r--r--
   ```

### Issue: Tools fail with validation errors

**Error**: "Content is required and cannot be empty"

**Solution**: Ensure all required parameters are provided:
```typescript
// memcp_store requires:
{
  "content": "...",        // Required, non-empty
  "category": "technical", // Required, valid enum
  "tags": ["tag1"],       // Required, array
  "scope": "project"       // Required, "project" or "global"
}
```

## Storage Issues

### Issue: "Permission denied" when storing memory

**Error**:
```
Error: EACCES: permission denied, mkdir '~/.mcp-memory'
```

**Solutions**:
1. Check directory permissions:
   ```bash
   ls -la ~/.mcp-memory
   ```
2. Create directory manually:
   ```bash
   mkdir -p ~/.mcp-memory
   chmod 755 ~/.mcp-memory
   ```
3. For project scope, check project directory:
   ```bash
   mkdir -p .mcp-memory
   chmod 755 .mcp-memory
   ```

### Issue: "No space left on device"

**Error**:
```
Error: ENOSPC: no space left on device
```

**Solutions**:
1. Check disk space:
   ```bash
   df -h ~/.mcp-memory
   ```
2. Clean up old memories:
   ```bash
   # List memory files
   find ~/.mcp-memory -name "*.json" -exec du -h {} \;
   ```
3. Consider moving storage to larger disk (update config)

### Issue: Memory file corrupted

**Error**:
```
SyntaxError: Unexpected token in JSON at position ...
```

**Solutions**:
1. Backup corrupted file:
   ```bash
   cp ~/.mcp-memory/global-memories.json ~/.mcp-memory/global-memories.json.backup
   ```
2. Try to repair JSON:
   ```bash
   # Validate JSON
   node -e "JSON.parse(require('fs').readFileSync('~/.mcp-memory/global-memories.json', 'utf-8'))"
   ```
3. If unrecoverable, start fresh:
   ```bash
   echo "[]" > ~/.mcp-memory/global-memories.json
   ```
4. Restore from backup if available

### Issue: Project not detected correctly

**Error**: Memories stored in wrong project or as global

**Solutions**:
1. Verify package.json exists:
   ```bash
   cat package.json | grep '"name"'
   ```
2. Check current working directory:
   ```bash
   pwd
   # Should be project root
   ```
3. Manually specify scope as "project" in tool calls
4. Check server logs for project detection:
   ```
   ✓ Project detected: <project-name>
   ```

## Embedding Issues

### Issue: Model download fails

**Error**:
```
Failed to initialize embedding model: fetch failed
```

**Solutions**:
1. Check internet connection (required for first download)
2. Check firewall/proxy settings
3. Try direct download:
   ```bash
   # Model downloads to:
   ~/.cache/huggingface/hub/models--Xenova--all-MiniLM-L6-v2
   ```
4. Verify disk space (~100MB needed):
   ```bash
   df -h ~/.cache/huggingface/
   ```
5. Clear cache and retry:
   ```bash
   rm -rf ~/.cache/huggingface/
   ```

### Issue: Embedding generation very slow

**Symptoms**: First embedding takes 5+ seconds

**Solutions**:
1. **Expected behavior**: First embedding initializes model (~2-3 seconds)
2. Subsequent embeddings should be ~50-100ms
3. If consistently slow:
   - Check CPU usage (embedding is CPU-bound)
   - Close other resource-intensive applications
   - Consider model caching issue (restart server)

### Issue: "Expected 384 dimensions, got X"

**Error**:
```
Error: Expected 384 dimensions, got 512
```

**Cause**: Wrong model or model misconfiguration

**Solutions**:
1. Verify model in config:
   ```json
   {
     "embedding_model": "Xenova/all-MiniLM-L6-v2"
   }
   ```
2. Clear model cache:
   ```bash
   rm -rf ~/.cache/huggingface/
   ```
3. Restart server to re-download

### Issue: Out of memory during embedding

**Error**:
```
JavaScript heap out of memory
```

**Solutions**:
1. Increase Node.js heap size:
   ```bash
   NODE_OPTIONS="--max-old-space-size=4096" node dist/server.js
   ```
2. Check for memory leaks (restart server periodically)
3. Reduce batch size if processing multiple embeddings

## Search and Retrieval Issues

### Issue: No results found for query

**Symptoms**: `memcp_retrieve` returns empty array

**Solutions**:
1. Check if memories exist:
   ```bash
   # Use memcp_list to see all memories
   ```
2. Verify scope matches:
   - Query with `scope: "all"` to search everywhere
3. Try different queries:
   - Use keywords instead of questions
   - Try exact phrases from memory content
4. Check similarity threshold (all results have scores)
5. Increase limit:
   ```json
   {
     "query": "...",
     "limit": 20  // Default is 5
   }
   ```

### Issue: Irrelevant results returned

**Symptoms**: Search returns memories that don't match query

**Solutions**:
1. **Expected behavior**: Semantic search finds conceptually similar content
2. Check similarity scores:
   - Scores < 0.4 are usually not relevant
   - Consider filtering results client-side
3. Use category filter to narrow results:
   ```json
   {
     "query": "deployment",
     "category": "deployment"  // Only deployment memories
   }
   ```
4. Add more specific tags when storing memories
5. Use `memcp_list` with filters for exact matches

### Issue: Memory not found by ID

**Error**:
```
Error: Memory with ID ... not found
```

**Solutions**:
1. Verify ID is correct (UUIDs are case-sensitive)
2. Use `memcp_list` to see all IDs:
   ```bash
   # Lists all memories with IDs
   ```
3. Check if memory was deleted
4. Verify scope (project vs global)

## Performance Issues

### Issue: Server uses too much memory

**Symptoms**: Server process uses 500MB+ RAM

**Causes**:
- Embedding model loaded: ~150MB expected
- Large number of memories: ~1KB per memory
- Memory leak (if growing over time)

**Solutions**:
1. Check memory usage:
   ```bash
   ps aux | grep server.js
   ```
2. Expected usage:
   - Base: ~100MB
   - Model: +150MB
   - 1,000 memories: +1MB
3. If excessive, restart server:
   ```bash
   # Claude Code will restart automatically
   ```
4. Consider splitting large projects into multiple memory files

### Issue: Slow response times

**Symptoms**: Tool calls take 5+ seconds

**Diagnosis**:
1. First call: ~2-3 seconds (model initialization) - **expected**
2. Store: ~100-200ms - **expected**
3. Retrieve: ~50ms per memory - **expected**
4. List: ~5-10ms - **expected**

**Solutions if slower**:
1. Check disk I/O:
   ```bash
   iostat -x 1 5
   ```
2. Check CPU usage:
   ```bash
   top -p $(pgrep -f server.js)
   ```
3. Reduce number of memories (archive old ones)
4. Use SSD instead of HDD for memory storage

### Issue: High CPU usage

**Symptoms**: Server pegs CPU at 100%

**Causes**:
- Embedding generation (expected during store/retrieve)
- Many concurrent tool calls
- Infinite loop (bug)

**Solutions**:
1. **During embedding**: 100% CPU is normal for ~100ms
2. If sustained:
   - Check server logs for errors
   - Restart server
   - Report bug with reproduction steps

## Debugging Tips

### Enable Verbose Logging

Server logs go to stderr by default. Claude Code captures these.

**View logs**:
```bash
# macOS
tail -f ~/Library/Logs/Claude/mcp-memory*.log

# Linux
tail -f ~/.local/share/Claude/logs/mcp-memory*.log
```

**Log messages to look for**:
```
🚀 Starting MCP Memory Server...
✓ Config loaded: Xenova/all-MiniLM-L6-v2
✓ Embedding provider initialized
✅ MCP Memory Server ready!
```

### Test Server Standalone

Run server directly to see all output:
```bash
cd /home/user/addypin/memcp
npm run dev
```

Then manually send MCP requests via stdin (advanced).

### Inspect Memory Files

```bash
# View global memories
cat ~/.mcp-memory/global-memories.json | jq '.'

# View project memories
cat .mcp-memory/memories.json | jq '.'

# Count memories
cat ~/.mcp-memory/global-memories.json | jq 'length'

# Search for specific content
cat ~/.mcp-memory/global-memories.json | jq '.[] | select(.content | contains("database"))'
```

### Validate JSON Files

```bash
# Check if JSON is valid
node -e "JSON.parse(require('fs').readFileSync('~/.mcp-memory/global-memories.json'))" && echo "Valid JSON"
```

### Check File Sizes

```bash
# Memory file sizes
du -h ~/.mcp-memory/*.json
du -h .mcp-memory/*.json

# Model cache size
du -sh ~/.cache/huggingface/
```

### Test Embedding Generation

Use the test script:
```bash
cd /home/user/addypin/memcp
npx tsx test-embeddings.ts
```

Expected output:
```
✅ ALL TESTS PASSED!
✓ Embedding generation works correctly
✓ Dimension is 384 as expected
...
```

### Network Diagnostics

Check if Hugging Face is accessible:
```bash
curl -I https://huggingface.co/
# Should return 200 OK
```

### Process Diagnostics

```bash
# Find server process
ps aux | grep server.js

# Check resource usage
top -p $(pgrep -f server.js)

# Check open files
lsof -p $(pgrep -f server.js)
```

## Common Error Messages Reference

| Error Message | Cause | Solution |
|--------------|-------|----------|
| "Content is required and cannot be empty" | Missing/empty content field | Provide non-empty content |
| "Memory with ID ... not found" | Invalid memory ID | Check ID with memcp_list |
| "EACCES: permission denied" | No write access to directory | Fix permissions with chmod |
| "ENOSPC: no space left on device" | Disk full | Free up disk space |
| "Cannot find module '...'" | Missing dependencies or build | Run npm install && npm run build |
| "Expected 384 dimensions, got X" | Wrong embedding model | Use Xenova/all-MiniLM-L6-v2 |
| "Failed to initialize embedding model" | Network issue or disk full | Check connection and disk space |
| "SyntaxError: Unexpected token" | Corrupted JSON file | Restore from backup or reinitialize |
| "Project not detected" | No package.json or not in project root | Use global scope or fix project structure |

## Getting Help

If you've tried the solutions above and still have issues:

1. **Check documentation**:
   - [Setup Guide](SETUP.md)
   - [Architecture](ARCHITECTURE.md)
   - [Data Flow](FLOW.md)

2. **Gather debugging information**:
   - Server logs
   - Error messages
   - Steps to reproduce
   - System info (OS, Node.js version)

3. **Report issue**:
   - Create GitHub issue with debugging info
   - Include relevant log excerpts
   - Describe expected vs actual behavior

4. **Temporary workarounds**:
   - Restart Claude Code
   - Restart server (automatic with Claude Code restart)
   - Clear memory cache and start fresh
   - Use global scope instead of project scope

---

**Related**: [Setup Guide](SETUP.md) | [Architecture](ARCHITECTURE.md)
