/**
 * memcp_delete - Delete a memory by ID
 * Removes memory from storage (project or global scope)
 * Based on FR-4
 */

import type { DeleteMemoryInput, Memory } from "../storage/types.js";
import { MemoryStore } from "../storage/MemoryStore.js";
import { getProjectPath } from "../utils/project.js";

/**
 * Delete a memory by ID
 * Searches both project and global scopes to find and delete the memory
 *
 * @param input - Delete memory input parameters
 * @returns Success message with deleted memory details
 */
export async function memcpDelete(input: DeleteMemoryInput): Promise<string> {
  // Validate required fields
  if (!input.memory_id || input.memory_id.trim().length === 0) {
    throw new Error("Memory ID is required");
  }

  // Find the memory in project and global scopes
  const projectPath = getProjectPath();
  const [projectMemories, globalMemories] = await Promise.all([
    MemoryStore.loadMemories("project", projectPath),
    MemoryStore.loadMemories("global"),
  ]);

  // Find the memory by ID to determine scope
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

  // Delete the memory using MemoryStore
  const deletedMemory = await MemoryStore.deleteMemory(
    input.memory_id,
    scope,
    scope === "project" ? projectPath : undefined
  );

  // Build success message
  const scopeInfo =
    scope === "project"
      ? ` (project: ${deletedMemory.project_name})`
      : " (global)";
  return `✓ Memory deleted successfully${scopeInfo}\nID: ${input.memory_id}\nCategory: ${deletedMemory.category}\nContent: ${deletedMemory.content.substring(0, 100)}${deletedMemory.content.length > 100 ? "..." : ""}`;
}
