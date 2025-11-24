/**
 * memcp_update - Update an existing memory
 * Modifies memory fields and regenerates embedding if content changed
 * Based on FR-5, FR-9
 */

import type { UpdateMemoryInput, Memory } from "../storage/types.js";
import type { EmbeddingProvider } from "../embeddings/EmbeddingProvider.js";
import { MemoryStore } from "../storage/MemoryStore.js";
import { getProjectPath } from "../utils/project.js";

/**
 * Update an existing memory by ID
 * Regenerates embedding if content changed, updates timestamp
 *
 * @param input - Update memory input parameters
 * @param embeddingProvider - Embedding provider for regenerating embeddings
 * @returns Success message with updated fields
 */
export async function memcpUpdate(
  input: UpdateMemoryInput,
  embeddingProvider: EmbeddingProvider
): Promise<string> {
  // Validate required fields
  if (!input.memory_id || input.memory_id.trim().length === 0) {
    throw new Error("Memory ID is required");
  }

  // Validate at least one field to update is provided
  const hasUpdates =
    input.content !== undefined ||
    input.category !== undefined ||
    input.tags !== undefined ||
    input.importance !== undefined ||
    input.documentation_path !== undefined;

  if (!hasUpdates) {
    throw new Error(
      "At least one field must be provided for update (content, category, tags, importance, or documentation_path)"
    );
  }

  // Find the memory in project and global scopes
  const projectPath = getProjectPath();
  const [projectMemories, globalMemories] = await Promise.all([
    MemoryStore.loadMemories("project", projectPath),
    MemoryStore.loadMemories("global"),
  ]);

  // Find the memory by ID
  let existingMemory: Memory | undefined;
  let scope: "project" | "global";

  existingMemory = projectMemories.find((m) => m.id === input.memory_id);
  if (existingMemory) {
    scope = "project";
  } else {
    existingMemory = globalMemories.find((m) => m.id === input.memory_id);
    if (existingMemory) {
      scope = "global";
    } else {
      throw new Error(`Memory with ID ${input.memory_id} not found`);
    }
  }

  // Build updates object
  const updates: Partial<Omit<Memory, "id" | "timestamp">> = {};

  if (input.content !== undefined) {
    if (input.content.trim().length === 0) {
      throw new Error("Memory content cannot be empty");
    }
    updates.content = input.content.trim();
  }

  if (input.category !== undefined) {
    updates.category = input.category;
  }

  if (input.tags !== undefined) {
    if (!Array.isArray(input.tags)) {
      throw new Error("Tags must be an array");
    }
    updates.tags = input.tags;
  }

  if (input.importance !== undefined) {
    if (typeof input.importance !== "number" || input.importance < 1 || input.importance > 10) {
      throw new Error("Importance must be a number between 1 and 10");
    }
    updates.importance = input.importance;
  }

  if (input.documentation_path !== undefined) {
    updates.documentation_path = input.documentation_path;
  }

  // Regenerate embedding if content changed
  if (input.content !== undefined) {
    const embedding = await embeddingProvider.generateEmbedding(updates.content!);

    // Validate embedding dimension
    const expectedDimension = embeddingProvider.getEmbeddingDimension();
    if (embedding.length !== expectedDimension) {
      throw new Error(
        `Invalid embedding dimension: expected ${expectedDimension}, got ${embedding.length}`
      );
    }

    updates.embedding = embedding;
  }

  // Update the memory using MemoryStore
  const updatedMemory = await MemoryStore.updateMemory(
    input.memory_id,
    updates,
    scope,
    scope === "project" ? projectPath : undefined
  );

  // Build success message listing updated fields
  const updatedFields: string[] = [];
  if (input.content !== undefined) updatedFields.push("content");
  if (input.category !== undefined) updatedFields.push("category");
  if (input.tags !== undefined) updatedFields.push("tags");
  if (input.importance !== undefined) updatedFields.push("importance");
  if (input.documentation_path !== undefined) updatedFields.push("documentation_path");

  const scopeInfo = scope === "project" ? ` (project: ${updatedMemory.project_name})` : " (global)";
  return `✓ Memory updated successfully${scopeInfo}\nID: ${input.memory_id}\nUpdated fields: ${updatedFields.join(", ")}\nTimestamp: ${updatedMemory.timestamp}`;
}
