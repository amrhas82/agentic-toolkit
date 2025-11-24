/**
 * memcp_list - List all memories with optional filtering
 * Retrieves memories without semantic search (no embeddings needed)
 * Based on FR-3
 */

import type { ListMemoriesInput, Memory } from "../storage/types.js";
import { MemoryStore } from "../storage/MemoryStore.js";
import { getProjectPath } from "../utils/project.js";

/**
 * List memories with optional filters
 * Does not use embeddings - returns all matching memories sorted by timestamp
 *
 * @param input - List memories input parameters (optional filters)
 * @returns Array of memories matching the filters
 */
export async function memcpList(
  input: ListMemoriesInput = {}
): Promise<Memory[]> {
  // Determine scope and load memories
  const scope = input.scope ?? "all"; // Default to "all"

  let memories: Memory[];
  if (scope === "all") {
    // Load both project and global memories
    const projectPath = getProjectPath();
    memories = await MemoryStore.loadAllMemories(projectPath);
  } else if (scope === "project") {
    // Load project-specific memories
    const projectPath = getProjectPath();
    memories = await MemoryStore.loadMemories("project", projectPath);
  } else {
    // Load global memories
    memories = await MemoryStore.loadMemories("global");
  }

  // Filter by category if provided
  if (input.category) {
    memories = memories.filter((m) => m.category === input.category);
  }

  // Filter by tags if provided
  if (input.tags && input.tags.length > 0) {
    memories = memories.filter((m) =>
      input.tags!.some((tag) => m.tags.includes(tag))
    );
  }

  // Sort by timestamp (most recent first)
  memories.sort((a, b) => {
    return new Date(b.timestamp).getTime() - new Date(a.timestamp).getTime();
  });

  return memories;
}

/**
 * Format memory list as a readable string
 * Helper function for displaying memories to users
 *
 * @param memories - Array of memories
 * @returns Formatted string with memories
 */
export function formatMemoryList(memories: Memory[]): string {
  if (memories.length === 0) {
    return "No memories found.";
  }

  const lines = [`Total memories: ${memories.length}\n`];

  for (let i = 0; i < memories.length; i++) {
    const memory = memories[i]!;
    const projectInfo = memory.project_name
      ? ` (project: ${memory.project_name})`
      : " (global)";

    lines.push(`${i + 1}. [${memory.category}]${projectInfo}`);
    lines.push(`   Content: ${memory.content}`);
    lines.push(`   Tags: ${memory.tags.join(", ")}`);
    lines.push(`   Importance: ${memory.importance}/10`);
    lines.push(`   ID: ${memory.id}`);
    lines.push(`   Timestamp: ${memory.timestamp}`);
    if (memory.documentation_path) {
      lines.push(`   Documentation: ${memory.documentation_path}`);
    }
    lines.push(""); // Empty line between memories
  }

  return lines.join("\n");
}
