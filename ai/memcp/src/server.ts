#!/usr/bin/env node
/**
 * MCP Memory Server - Main server entry point
 * Implements Model Context Protocol for Claude Code integration
 * Based on FR-16, FR-17, FR-18, FR-19
 */

import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
  Tool,
} from "@modelcontextprotocol/sdk/types.js";

import { LocalEmbeddings } from "./embeddings/LocalEmbeddings.js";
import { loadConfig } from "./utils/config.js";
import { memcpStore } from "./tools/memcpStore.js";
import { memcpRetrieve } from "./tools/memcpRetrieve.js";
import { memcpList } from "./tools/memcpList.js";
import { memcpUpdate } from "./tools/memcpUpdate.js";
import { memcpDelete } from "./tools/memcpDelete.js";

// Global embedding provider instance
let embeddingProvider: LocalEmbeddings;

/**
 * MCP Tool definitions with schemas (FR-17)
 */
const TOOLS: Tool[] = [
  {
    name: "memcp_store",
    description:
      "Store a new memory with semantic embedding. Creates a memory that can be retrieved later using semantic search. Automatically detects project context for project-scoped memories.",
    inputSchema: {
      type: "object",
      properties: {
        content: {
          type: "string",
          description: "The memory content to store (required)",
        },
        category: {
          type: "string",
          enum: ["technical", "deployment", "preference", "bug", "ways_of_working"],
          description: "Category classification (required)",
        },
        tags: {
          type: "array",
          items: { type: "string" },
          description: "Entity tags for search (e.g., ['nginx', 'ssl', 'staging'])",
        },
        scope: {
          type: "string",
          enum: ["project", "global"],
          description:
            "Scope: 'project' for current project only, 'global' for all projects (required)",
        },
        importance: {
          type: "number",
          minimum: 1,
          maximum: 10,
          description: "Importance score 1-10 (default: 5)",
        },
        documentation_path: {
          type: "string",
          description: "Optional path to related documentation",
        },
      },
      required: ["content", "category", "tags", "scope"],
    },
  },
  {
    name: "memcp_retrieve",
    description:
      "Retrieve memories using semantic search. Finds relevant memories based on query text using embedding similarity. Returns top N most relevant results with similarity scores.",
    inputSchema: {
      type: "object",
      properties: {
        query: {
          type: "string",
          description: "Search query text (required)",
        },
        category: {
          type: "string",
          enum: ["technical", "deployment", "preference", "bug", "ways_of_working"],
          description: "Filter by category (optional)",
        },
        scope: {
          type: "string",
          enum: ["project", "global", "all"],
          description:
            "Search scope: 'project', 'global', or 'all' (default: 'all')",
        },
        limit: {
          type: "number",
          minimum: 1,
          maximum: 20,
          description: "Maximum number of results to return (default: 5)",
        },
      },
      required: ["query"],
    },
  },
  {
    name: "memcp_list",
    description:
      "List all memories with optional filtering. Returns memories without semantic search (faster than retrieve). Useful for browsing all memories or filtering by category/tags.",
    inputSchema: {
      type: "object",
      properties: {
        category: {
          type: "string",
          enum: ["technical", "deployment", "preference", "bug", "ways_of_working"],
          description: "Filter by category (optional)",
        },
        scope: {
          type: "string",
          enum: ["project", "global", "all"],
          description: "Filter by scope (default: 'all')",
        },
        tags: {
          type: "array",
          items: { type: "string" },
          description:
            "Filter by tags - returns memories containing any of these tags (optional)",
        },
      },
    },
  },
  {
    name: "memcp_update",
    description:
      "Update an existing memory by ID. Can update content, category, tags, importance, or documentation_path. Automatically regenerates embedding if content is changed.",
    inputSchema: {
      type: "object",
      properties: {
        memory_id: {
          type: "string",
          description: "UUID of memory to update (required)",
        },
        content: {
          type: "string",
          description: "New content (triggers embedding regeneration)",
        },
        category: {
          type: "string",
          enum: ["technical", "deployment", "preference", "bug", "ways_of_working"],
          description: "New category",
        },
        tags: {
          type: "array",
          items: { type: "string" },
          description: "New tags array",
        },
        importance: {
          type: "number",
          minimum: 1,
          maximum: 10,
          description: "New importance score 1-10",
        },
        documentation_path: {
          type: "string",
          description: "New documentation path",
        },
      },
      required: ["memory_id"],
    },
  },
  {
    name: "memcp_delete",
    description:
      "Delete a memory by ID. Permanently removes the memory from storage. Returns confirmation with details of deleted memory.",
    inputSchema: {
      type: "object",
      properties: {
        memory_id: {
          type: "string",
          description: "UUID of memory to delete (required)",
        },
      },
      required: ["memory_id"],
    },
  },
];

/**
 * Main server function
 */
async function main() {
  try {
    console.error("🚀 Starting MCP Memory Server...");

    // Load configuration (FR-21, FR-22)
    console.error("📋 Loading configuration...");
    const config = await loadConfig();
    console.error(`✓ Config loaded: ${config.embedding_model}`);

    // Initialize embedding provider (FR-12)
    console.error("🤖 Initializing embedding provider...");
    embeddingProvider = new LocalEmbeddings(config.embedding_model);
    await embeddingProvider.initialize();
    console.error("✓ Embedding provider initialized");

    // Create MCP server with stdio transport (FR-16)
    const server = new Server(
      {
        name: "mcp-memory-server",
        version: "1.0.0",
      },
      {
        capabilities: {
          tools: {},
        },
      }
    );

    // Register tools/list handler (FR-17)
    server.setRequestHandler(ListToolsRequestSchema, async () => {
      return {
        tools: TOOLS,
      };
    });

    // Register tools/call handler (FR-18)
    server.setRequestHandler(CallToolRequestSchema, async (request) => {
      try {
        const { name, arguments: args } = request.params;

        // Route to appropriate tool implementation
        switch (name) {
          case "memcp_store": {
            const result = await memcpStore(args as any, embeddingProvider);
            return {
              content: [{ type: "text", text: result }],
            };
          }

          case "memcp_retrieve": {
            const results = await memcpRetrieve(args as any, embeddingProvider);
            return {
              content: [
                {
                  type: "text",
                  text: JSON.stringify(results, null, 2),
                },
              ],
            };
          }

          case "memcp_list": {
            const memories = await memcpList(args as any);
            return {
              content: [
                {
                  type: "text",
                  text: JSON.stringify(memories, null, 2),
                },
              ],
            };
          }

          case "memcp_update": {
            const result = await memcpUpdate(args as any, embeddingProvider);
            return {
              content: [{ type: "text", text: result }],
            };
          }

          case "memcp_delete": {
            const result = await memcpDelete(args as any);
            return {
              content: [{ type: "text", text: result }],
            };
          }

          default:
            throw new Error(`Unknown tool: ${name}`);
        }
      } catch (error) {
        // Global error handling (FR-19)
        const errorMessage =
          error instanceof Error ? error.message : String(error);
        console.error(`❌ Tool error: ${errorMessage}`);
        return {
          content: [
            {
              type: "text",
              text: `Error: ${errorMessage}`,
            },
          ],
          isError: true,
        };
      }
    });

    // Start server with stdio transport (FR-16)
    const transport = new StdioServerTransport();
    await server.connect(transport);

    console.error("✅ MCP Memory Server ready!");
    console.error(`📦 Available tools: ${TOOLS.map((t) => t.name).join(", ")}`);
    console.error("🔌 Listening on stdio...");
  } catch (error) {
    console.error("❌ Failed to start server:");
    console.error(error instanceof Error ? error.message : String(error));
    process.exit(1);
  }
}

// Handle shutdown gracefully
process.on("SIGINT", async () => {
  console.error("\n🛑 Shutting down MCP Memory Server...");
  if (embeddingProvider) {
    await embeddingProvider.cleanup();
  }
  process.exit(0);
});

process.on("SIGTERM", async () => {
  console.error("\n🛑 Shutting down MCP Memory Server...");
  if (embeddingProvider) {
    await embeddingProvider.cleanup();
  }
  process.exit(0);
});

// Start the server
main().catch((error) => {
  console.error("Fatal error:", error);
  process.exit(1);
});
