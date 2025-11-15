/**
 * Search utilities for MCP Memory Server
 * Implements cosine similarity, semantic search, and keyword search
 * Based on FR-13, FR-14, FR-15
 */

import type { Memory, SearchResult } from "../storage/types.js";
import type { EmbeddingProvider } from "../embeddings/EmbeddingProvider.js";

/**
 * Calculate cosine similarity between two embedding vectors (FR-13)
 * Returns a score between 0 and 1, where:
 * - 1.0 = identical vectors (most similar)
 * - 0.0 = orthogonal vectors (not similar)
 * - Values close to 1 indicate high similarity
 *
 * Formula: similarity = (A · B) / (||A|| * ||B||)
 * Where:
 * - A · B is the dot product
 * - ||A|| and ||B|| are the magnitudes (Euclidean norms)
 *
 * @param vec1 - First embedding vector
 * @param vec2 - Second embedding vector
 * @returns Cosine similarity score (0-1)
 */
export function cosineSimilarity(vec1: number[], vec2: number[]): number {
  // Validate input vectors
  if (vec1.length !== vec2.length) {
    throw new Error(
      `Vector dimensions must match: vec1 has ${vec1.length} dimensions, vec2 has ${vec2.length} dimensions`
    );
  }

  if (vec1.length === 0) {
    throw new Error("Cannot calculate cosine similarity of empty vectors");
  }

  // Calculate dot product (A · B)
  let dotProduct = 0;
  for (let i = 0; i < vec1.length; i++) {
    dotProduct += vec1[i]! * vec2[i]!;
  }

  // Calculate magnitudes (||A|| and ||B||)
  let magnitude1 = 0;
  let magnitude2 = 0;
  for (let i = 0; i < vec1.length; i++) {
    magnitude1 += vec1[i]! * vec1[i]!;
    magnitude2 += vec2[i]! * vec2[i]!;
  }
  magnitude1 = Math.sqrt(magnitude1);
  magnitude2 = Math.sqrt(magnitude2);

  // Avoid division by zero
  if (magnitude1 === 0 || magnitude2 === 0) {
    return 0;
  }

  // Calculate cosine similarity
  const similarity = dotProduct / (magnitude1 * magnitude2);

  // Clamp to [0, 1] range to handle floating point errors
  return Math.max(0, Math.min(1, similarity));
}

/**
 * Perform semantic search using embeddings and cosine similarity (FR-13, FR-14)
 * Generates embedding for query and ranks memories by similarity score
 *
 * @param query - Search query text
 * @param memories - Array of memories to search
 * @param embeddingProvider - Embedding provider for generating query embedding
 * @param limit - Maximum number of results to return (default: 5)
 * @returns Array of search results sorted by similarity (highest first)
 */
export async function semanticSearch(
  query: string,
  memories: Memory[],
  embeddingProvider: EmbeddingProvider,
  limit: number = 5
): Promise<SearchResult[]> {
  // Generate embedding for the query
  const queryEmbedding = await embeddingProvider.generateEmbedding(query);

  // Calculate similarity for each memory
  const results: SearchResult[] = memories.map((memory) => {
    const similarity = cosineSimilarity(queryEmbedding, memory.embedding);

    const result: SearchResult = {
      id: memory.id,
      content: memory.content,
      category: memory.category,
      tags: memory.tags,
      similarity_score: similarity,
      timestamp: memory.timestamp,
      importance: memory.importance,
      documentation_path: memory.documentation_path,
    };

    // Add optional project_name if present
    if (memory.project_name) {
      result.project_name = memory.project_name;
    }

    return result;
  });

  // Sort by similarity score (highest first)
  results.sort((a, b) => b.similarity_score - a.similarity_score);

  // Return top N results
  return results.slice(0, limit);
}

/**
 * Perform keyword-based search as fallback (FR-15)
 * Searches for query keywords in memory content and tags
 * Returns memories that contain any of the query keywords
 *
 * @param query - Search query text
 * @param memories - Array of memories to search
 * @param limit - Maximum number of results to return (default: 5)
 * @returns Array of search results with similarity_score based on keyword matches
 */
export function keywordSearch(
  query: string,
  memories: Memory[],
  limit: number = 5
): SearchResult[] {
  // Normalize query: lowercase and split into keywords
  const keywords = query
    .toLowerCase()
    .split(/\s+/)
    .filter((word) => word.length > 0);

  if (keywords.length === 0) {
    return [];
  }

  // Score each memory based on keyword matches (with intermediate type for sorting)
  const resultsWithMatches = memories
    .map((memory) => {
      const contentLower = memory.content.toLowerCase();
      const tagsLower = memory.tags.map((tag) => tag.toLowerCase());

      // Count keyword matches in content and tags
      let matchCount = 0;
      for (const keyword of keywords) {
        // Check content
        if (contentLower.includes(keyword)) {
          matchCount += 1;
        }

        // Check tags (exact match)
        if (tagsLower.includes(keyword)) {
          matchCount += 2; // Weight tags higher
        }
      }

      // Calculate similarity score (normalized by total possible matches)
      const maxPossibleMatches = keywords.length * 3; // 1 for content + 2 for tags
      const similarity_score = matchCount / maxPossibleMatches;

      // Create search result
      const result: SearchResult = {
        id: memory.id,
        content: memory.content,
        category: memory.category,
        tags: memory.tags,
        similarity_score,
        timestamp: memory.timestamp,
        importance: memory.importance,
        documentation_path: memory.documentation_path,
      };

      // Add optional project_name if present
      if (memory.project_name) {
        result.project_name = memory.project_name;
      }

      return {
        result,
        matchCount,
      };
    })
    .filter((item) => item.matchCount > 0); // Only return matches

  // Sort by match count (highest first), then by importance
  resultsWithMatches.sort((a, b) => {
    if (b.matchCount !== a.matchCount) {
      return b.matchCount - a.matchCount;
    }
    return b.result.importance - a.result.importance;
  });

  // Extract SearchResult objects
  const finalResults = resultsWithMatches.map((item) => item.result);

  // Return top N results
  return finalResults.slice(0, limit);
}
