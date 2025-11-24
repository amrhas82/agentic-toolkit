/**
 * memcp_store - Store a new memory in the MCP Memory Server
 * Creates a new memory with embedding and saves to appropriate scope
 * Based on FR-1
 */

import { v4 as uuidv4 } from "uuid";
import type { StoreMemoryInput, Memory } from "../storage/types.js";
import type { EmbeddingProvider } from "../embeddings/EmbeddingProvider.js";
import { MemoryStore } from "../storage/MemoryStore.js";
import { detectProjectContext } from "../utils/project.js";

/**
 * Store a new memory
 * Generates UUID, detects project context, creates embedding, and saves to JSON
 *
 * @param input - Store memory input parameters
 * @param embeddingProvider - Embedding provider for generating embeddings
 * @returns Success message with memory ID
 */
export async function memcpStore(
  input: StoreMemoryInput,
  embeddingProvider: EmbeddingProvider
): Promise<string> {
  // Validate required fields
  if (!input.content || input.content.trim().length === 0) {
    throw new Error("Memory content cannot be empty");
  }

  if (!input.category) {
    throw new Error("Memory category is required");
  }

  if (!Array.isArray(input.tags)) {
    throw new Error("Memory tags must be an array");
  }

  if (!input.scope) {
    throw new Error("Memory scope is required (project or global)");
  }

  // Generate UUID for memory ID
  const memoryId = uuidv4();

  // Detect project context if scope is "project"
  let project_name: string | undefined;
  let project_path: string | undefined;

  if (input.scope === "project") {
    const projectContext = detectProjectContext();
    project_name = projectContext.project_name;
    project_path = projectContext.project_path;
  }

  // Generate embedding for content
  const embedding = await embeddingProvider.generateEmbedding(input.content);

  // Validate embedding dimension
  const expectedDimension = embeddingProvider.getEmbeddingDimension();
  if (embedding.length !== expectedDimension) {
    throw new Error(
      `Invalid embedding dimension: expected ${expectedDimension}, got ${embedding.length}`
    );
  }

  // Create Memory object
  const memory: Memory = {
    id: memoryId,
    content: input.content.trim(),
    category: input.category,
    tags: input.tags,
    scope: input.scope,
    importance: input.importance ?? 5, // Default importance: 5
    timestamp: new Date().toISOString(),
    documentation_path: input.documentation_path ?? null,
    embedding,
  };

  // Add optional project fields if present
  if (project_name) {
    memory.project_name = project_name;
  }
  if (project_path) {
    memory.project_path = project_path;
  }

  // Save to appropriate JSON file
  await MemoryStore.saveMemory(memory, project_path);

  // Return success message
  const scopeInfo =
    input.scope === "project" ? ` (project: ${project_name})` : " (global)";
  return `✓ Memory stored successfully${scopeInfo}\nID: ${memoryId}\nCategory: ${input.category}\nTags: ${input.tags.join(", ")}`;
}
