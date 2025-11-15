/**
 * TypeScript type definitions for MCP Memory Server
 * Based on PRD v1.2 - Functional Requirements
 */

/**
 * Memory categories (FR-1)
 */
export type MemoryCategory =
  | "technical"
  | "deployment"
  | "preference"
  | "bug"
  | "ways_of_working";

/**
 * Memory scope (FR-1)
 */
export type MemoryScope = "project" | "global";

/**
 * Memory structure stored in JSON files (FR-6)
 */
export interface Memory {
  /** UUID v4 identifier */
  id: string;

  /** Memory content text */
  content: string;

  /** Category classification */
  category: MemoryCategory;

  /** Entity tags for search (e.g., ["nginx", "ssl", "staging"]) */
  tags: string[];

  /** Project-local or global scope */
  scope: MemoryScope;

  /** Human-readable project name (only for project scope) */
  project_name?: string;

  /** Absolute path to project (only for project scope) */
  project_path?: string;

  /** Importance score 1-10 (default: 5) */
  importance: number;

  /** ISO 8601 timestamp of creation/last update */
  timestamp: string;

  /** Optional path to related documentation */
  documentation_path: string | null;

  /** Embedding vector (384 dimensions for all-MiniLM-L6-v2) */
  embedding: number[];
}

/**
 * Configuration structure (FR-21)
 */
export interface Config {
  /** Embedding provider: local or OpenAI API */
  embedding_provider: "local" | "openai";

  /** Model name/path (e.g., "Xenova/all-MiniLM-L6-v2") */
  embedding_model: string;

  /** Default search result limit */
  default_limit: number;

  /** Enable/disable automatic embedding generation */
  auto_embed: boolean;
}

/**
 * Search result structure (FR-14)
 */
export interface SearchResult {
  /** Memory ID for updates/deletes */
  id: string;

  /** Memory content */
  content: string;

  /** Category */
  category: MemoryCategory;

  /** Tags */
  tags: string[];

  /** Relevance score 0-1 (cosine similarity) */
  similarity_score: number;

  /** ISO 8601 timestamp */
  timestamp: string;

  /** Project name (only for project-scoped memories) */
  project_name?: string;

  /** Importance score */
  importance: number;

  /** Optional documentation path */
  documentation_path: string | null;
}

/**
 * Tool input for memcp_store (FR-1)
 */
export interface StoreMemoryInput {
  content: string;
  category: MemoryCategory;
  tags: string[];
  scope: MemoryScope;
  importance?: number;
  documentation_path?: string;
}

/**
 * Tool input for memcp_retrieve (FR-2)
 */
export interface RetrieveMemoryInput {
  query: string;
  category?: MemoryCategory;
  scope?: MemoryScope | "all";
  limit?: number;
}

/**
 * Tool input for memcp_list (FR-3)
 */
export interface ListMemoriesInput {
  category?: MemoryCategory;
  scope?: MemoryScope | "all";
  tags?: string[];
}

/**
 * Tool input for memcp_update (FR-5)
 */
export interface UpdateMemoryInput {
  memory_id: string;
  content?: string;
  category?: MemoryCategory;
  tags?: string[];
  importance?: number;
  documentation_path?: string;
}

/**
 * Tool input for memcp_delete (FR-4)
 */
export interface DeleteMemoryInput {
  memory_id: string;
}
