/**
 * memcp_retrieve - Retrieve memories using semantic search
 * Searches memories by query text using embedding similarity
 * Based on FR-2, FR-13, FR-14
 */

import type { RetrieveMemoryInput, SearchResult } from "../storage/types.js";
import type { EmbeddingProvider } from "../embeddings/EmbeddingProvider.js";
import { MemoryStore } from "../storage/MemoryStore.js";
import { semanticSearch, keywordSearch } from "../utils/search.js";
import { getProjectPath } from "../utils/project.js";

/**
 * Retrieve memories using semantic search
 * Uses embeddings and cosine similarity to find relevant memories
 *
 * @param input - Retrieve memory input parameters
 * @param embeddingProvider - Embedding provider for generating query embedding
 * @returns Array of search results sorted by relevance
 */
export async function memcpRetrieve(
  input: RetrieveMemoryInput,
  embeddingProvider: EmbeddingProvider
): Promise<SearchResult[]> {
  // Validate required fields
  if (!input.query || input.query.trim().length === 0) {
    throw new Error("Search query cannot be empty");
  }

  // Determine scope and load memories
  const scope = input.scope ?? "all"; // Default to "all"
  const limit = input.limit ?? 5; // Default limit: 5

  let memories;
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

  // If no memories found, return empty array
  if (memories.length === 0) {
    return [];
  }

  // Perform semantic search with fallback to keyword search
  let results: SearchResult[];

  try {
    // Try semantic search first
    results = await semanticSearch(
      input.query,
      memories,
      embeddingProvider,
      limit
    );
  } catch (error) {
    // Fallback to keyword search if embedding fails
    console.warn(
      `Semantic search failed, falling back to keyword search: ${
        error instanceof Error ? error.message : String(error)
      }`
    );
    results = keywordSearch(input.query, memories, limit);
  }

  return results;
}

/**
 * Format search results as a readable string
 * Helper function for displaying results to users
 *
 * @param results - Array of search results
 * @returns Formatted string with results
 */
export function formatSearchResults(results: SearchResult[]): string {
  if (results.length === 0) {
    return "No memories found matching your query.";
  }

  const lines = [`Found ${results.length} matching memories:\n`];

  for (let i = 0; i < results.length; i++) {
    const result = results[i]!;
    const projectInfo = result.project_name
      ? ` (project: ${result.project_name})`
      : " (global)";

    lines.push(`${i + 1}. [${result.category}]${projectInfo}`);
    lines.push(`   Content: ${result.content}`);
    lines.push(`   Tags: ${result.tags.join(", ")}`);
    lines.push(
      `   Relevance: ${(result.similarity_score * 100).toFixed(1)}%`
    );
    lines.push(`   Importance: ${result.importance}/10`);
    lines.push(`   ID: ${result.id}`);
    lines.push(`   Timestamp: ${result.timestamp}`);
    if (result.documentation_path) {
      lines.push(`   Documentation: ${result.documentation_path}`);
    }
    lines.push(""); // Empty line between results
  }

  return lines.join("\n");
}
