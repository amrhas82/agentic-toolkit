/**
 * LocalEmbeddings - Local embedding generation using @xenova/transformers
 * Uses Xenova/all-MiniLM-L6-v2 model for generating 384-dimension embeddings
 * Based on FR-12 (local embedding model)
 */

import { pipeline } from "@xenova/transformers";
import { EmbeddingProvider } from "./EmbeddingProvider.js";

/**
 * Local embedding provider using Transformers.js
 * Downloads and runs model locally (no API required)
 */
export class LocalEmbeddings extends EmbeddingProvider {
  private model: any = null;
  private readonly modelName: string;
  private isInitializing = false;
  private initializationPromise: Promise<void> | null = null;

  /**
   * Create a new LocalEmbeddings instance
   * @param modelName - Model name from Hugging Face (default: Xenova/all-MiniLM-L6-v2)
   */
  constructor(modelName: string = "Xenova/all-MiniLM-L6-v2") {
    super();
    this.modelName = modelName;
  }

  /**
   * Initialize the embedding model
   * Downloads model on first run (~80MB for all-MiniLM-L6-v2)
   * Model is cached locally for subsequent runs
   */
  async initialize(): Promise<void> {
    // If already initialized, return immediately
    if (this.model !== null) {
      return;
    }

    // If currently initializing, wait for that to complete
    if (this.isInitializing && this.initializationPromise) {
      return this.initializationPromise;
    }

    // Start initialization
    this.isInitializing = true;
    this.initializationPromise = this.loadModel();

    try {
      await this.initializationPromise;
    } finally {
      this.isInitializing = false;
      this.initializationPromise = null;
    }
  }

  /**
   * Load the embedding model
   * @private
   */
  private async loadModel(): Promise<void> {
    try {
      console.log(`Loading embedding model: ${this.modelName}...`);
      console.log(
        "First-time download: ~80MB for Xenova/all-MiniLM-L6-v2 (cached for subsequent runs)"
      );

      // Create feature-extraction pipeline with the specified model
      this.model = await pipeline("feature-extraction", this.modelName);

      console.log(`Embedding model loaded successfully: ${this.modelName}`);
    } catch (error) {
      // Provide specific error messages for common failure scenarios
      const errorMessage = error instanceof Error ? error.message : String(error);

      // Network errors
      if (
        errorMessage.includes("fetch") ||
        errorMessage.includes("network") ||
        errorMessage.includes("ENOTFOUND") ||
        errorMessage.includes("ECONNREFUSED")
      ) {
        throw new Error(
          `Failed to download embedding model ${this.modelName}: Network error. ` +
            `Please check your internet connection and try again. ` +
            `The model (~80MB) needs to be downloaded on first use. ` +
            `Original error: ${errorMessage}`
        );
      }

      // Disk space errors
      if (
        errorMessage.includes("ENOSPC") ||
        errorMessage.includes("no space")
      ) {
        throw new Error(
          `Failed to load embedding model ${this.modelName}: Insufficient disk space. ` +
            `The model requires ~80MB of free space in your home directory. ` +
            `Please free up disk space and try again. ` +
            `Original error: ${errorMessage}`
        );
      }

      // Permission errors
      if (
        errorMessage.includes("EACCES") ||
        errorMessage.includes("permission denied")
      ) {
        throw new Error(
          `Failed to load embedding model ${this.modelName}: Permission denied. ` +
            `Cannot write to model cache directory. ` +
            `Please check file permissions in your home directory. ` +
            `Original error: ${errorMessage}`
        );
      }

      // Model not found
      if (
        errorMessage.includes("404") ||
        errorMessage.includes("not found")
      ) {
        throw new Error(
          `Failed to load embedding model ${this.modelName}: Model not found. ` +
            `Please verify the model name is correct. ` +
            `Expected format: "Xenova/model-name" from Hugging Face. ` +
            `Original error: ${errorMessage}`
        );
      }

      // Generic error with helpful context
      throw new Error(
        `Failed to load embedding model ${this.modelName}: ${errorMessage}\n\n` +
          `Troubleshooting:\n` +
          `1. Check internet connection (first-time download: ~80MB)\n` +
          `2. Ensure sufficient disk space in home directory\n` +
          `3. Verify model name: ${this.modelName}\n` +
          `4. Check file permissions for writing to cache directory`
      );
    }
  }

  /**
   * Generate embedding vector for given text
   * Automatically initializes model on first call
   *
   * @param text - Text to embed
   * @returns Promise resolving to 384-dimension embedding vector
   */
  async generateEmbedding(text: string): Promise<number[]> {
    // Ensure model is initialized
    if (this.model === null) {
      await this.initialize();
    }

    // Model should be loaded at this point
    if (this.model === null) {
      throw new Error("Embedding model failed to initialize");
    }

    try {
      // Generate embedding using the pipeline
      // The result is a tensor, we need to convert it to a regular array
      const result = await this.model(text, {
        pooling: "mean",
        normalize: true,
      });

      // Extract the embedding array from the result
      // @xenova/transformers returns a Tensor object
      const embedding = Array.from(result.data) as number[];

      return embedding;
    } catch (error) {
      throw new Error(
        `Failed to generate embedding for text: ${
          error instanceof Error ? error.message : String(error)
        }`
      );
    }
  }

  /**
   * Clean up model resources
   * Call this when shutting down to free memory
   */
  async cleanup(): Promise<void> {
    if (this.model !== null) {
      // @xenova/transformers pipelines don't have explicit cleanup
      // Just set to null to allow garbage collection
      this.model = null;
      console.log("Embedding model resources released");
    }
  }

  /**
   * Get embedding dimension for all-MiniLM-L6-v2
   * @returns 384 dimensions
   */
  getEmbeddingDimension(): number {
    return 384;
  }
}
