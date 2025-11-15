/**
 * EmbeddingProvider - Abstract base class for embedding generation
 * Defines interface for generating embeddings from text
 * Based on FR-12 (embedding generation)
 */

/**
 * Abstract embedding provider interface
 * Implementations must provide a method to generate embeddings from text
 */
export abstract class EmbeddingProvider {
  /**
   * Generate embedding vector for given text
   * @param text - Text to embed
   * @returns Promise resolving to embedding vector (number array)
   */
  abstract generateEmbedding(text: string): Promise<number[]>;

  /**
   * Optional: Initialize the embedding provider
   * Override this method if your provider needs initialization
   * (e.g., loading models, connecting to APIs)
   */
  async initialize(): Promise<void> {
    // Default implementation does nothing
    // Subclasses can override if needed
  }

  /**
   * Optional: Clean up resources
   * Override this method if your provider needs cleanup
   * (e.g., releasing model memory, closing connections)
   */
  async cleanup(): Promise<void> {
    // Default implementation does nothing
    // Subclasses can override if needed
  }

  /**
   * Optional: Get embedding dimension
   * Override this method to specify the dimension of embeddings
   * @returns Embedding vector dimension
   */
  getEmbeddingDimension(): number {
    // Default: 384 dimensions (for all-MiniLM-L6-v2)
    return 384;
  }
}
