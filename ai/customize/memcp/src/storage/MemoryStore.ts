/**
 * MemoryStore - Core storage logic for MCP Memory Server
 * Handles loading, saving, updating, and deleting memories
 * Based on FR-7, FR-8
 */

import fs from "fs/promises";
import path from "path";
import os from "os";
import type { Memory, MemoryScope } from "./types.js";

export class MemoryStore {
  /**
   * Get the project-specific memory directory path
   * Returns <project_root>/.mcp-memory
   */
  static getProjectMemoryDir(projectPath: string): string {
    return path.join(projectPath, ".mcp-memory");
  }

  /**
   * Get the project-specific memory file path
   * Returns <project_root>/.mcp-memory/memories.json (FR-7)
   */
  static getProjectMemoryPath(projectPath: string): string {
    return path.join(this.getProjectMemoryDir(projectPath), "memories.json");
  }

  /**
   * Get the global memory directory path
   * Returns ~/.mcp-memory
   */
  static getGlobalMemoryDir(): string {
    return path.join(os.homedir(), ".mcp-memory");
  }

  /**
   * Get the global memory file path
   * Returns ~/.mcp-memory/global-memories.json (FR-8)
   */
  static getGlobalMemoryPath(): string {
    return path.join(this.getGlobalMemoryDir(), "global-memories.json");
  }

  /**
   * Load memories from JSON file based on scope
   * Returns empty array if file doesn't exist (FR-7, FR-8)
   *
   * @param scope - "project" or "global"
   * @param projectPath - Required if scope is "project"
   * @returns Array of memories
   */
  static async loadMemories(
    scope: MemoryScope,
    projectPath?: string
  ): Promise<Memory[]> {
    // Determine file path based on scope
    let memoryPath: string;
    if (scope === "project") {
      if (!projectPath) {
        throw new Error(
          "projectPath is required when loading project-scoped memories"
        );
      }
      memoryPath = this.getProjectMemoryPath(projectPath);
    } else {
      memoryPath = this.getGlobalMemoryPath();
    }

    try {
      // Try to read the file
      const fileData = await fs.readFile(memoryPath, "utf-8");

      // Parse JSON
      const memories = JSON.parse(fileData) as Memory[];

      // Validate that it's an array
      if (!Array.isArray(memories)) {
        throw new Error(
          `Invalid memory file format at ${memoryPath}: expected array, got ${typeof memories}`
        );
      }

      // Validate each memory has required fields
      for (const memory of memories) {
        if (
          !memory.id ||
          !memory.content ||
          !memory.category ||
          !Array.isArray(memory.tags) ||
          !memory.scope ||
          typeof memory.importance !== "number" ||
          !memory.timestamp ||
          !Array.isArray(memory.embedding)
        ) {
          console.warn(
            `Skipping invalid memory in ${memoryPath}: missing required fields`,
            memory
          );
          continue;
        }
      }

      return memories;
    } catch (error) {
      // If file doesn't exist, return empty array
      if (
        error instanceof Error &&
        "code" in error &&
        error.code === "ENOENT"
      ) {
        return [];
      }

      // If permission denied, throw descriptive error
      if (
        error instanceof Error &&
        "code" in error &&
        error.code === "EACCES"
      ) {
        throw new Error(
          `Permission denied: Cannot read memory file at ${memoryPath}. Check file permissions.`
        );
      }

      // If JSON parse error, throw descriptive error
      if (error instanceof SyntaxError) {
        throw new Error(
          `Invalid JSON in memory file at ${memoryPath}: ${error.message}. The file may be corrupted.`
        );
      }

      // If path is a directory instead of a file
      if (
        error instanceof Error &&
        "code" in error &&
        error.code === "EISDIR"
      ) {
        throw new Error(
          `Expected a file but found a directory at ${memoryPath}`
        );
      }

      // Re-throw other errors with context
      throw new Error(
        `Failed to load memories from ${memoryPath}: ${
          error instanceof Error ? error.message : String(error)
        }`
      );
    }
  }

  /**
   * Load all memories (both project and global)
   * Useful for scope="all" queries
   *
   * @param projectPath - Project path for loading project memories
   * @returns Combined array of project and global memories
   */
  static async loadAllMemories(projectPath: string): Promise<Memory[]> {
    const [projectMemories, globalMemories] = await Promise.all([
      this.loadMemories("project", projectPath),
      this.loadMemories("global"),
    ]);

    return [...projectMemories, ...globalMemories];
  }

  /**
   * Save a memory to JSON file (append or update)
   * Auto-creates directory if it doesn't exist (FR-6)
   *
   * @param memory - Memory object to save
   * @param projectPath - Required if memory.scope is "project"
   */
  static async saveMemory(
    memory: Memory,
    projectPath?: string
  ): Promise<void> {
    // Determine file path and directory based on scope
    let memoryPath: string;
    let memoryDir: string;

    if (memory.scope === "project") {
      if (!projectPath) {
        throw new Error(
          "projectPath is required when saving project-scoped memories"
        );
      }
      memoryDir = this.getProjectMemoryDir(projectPath);
      memoryPath = this.getProjectMemoryPath(projectPath);
    } else {
      memoryDir = this.getGlobalMemoryDir();
      memoryPath = this.getGlobalMemoryPath();
    }

    try {
      // Auto-create directory if it doesn't exist (FR-6)
      await fs.mkdir(memoryDir, { recursive: true });

      // Load existing memories
      const existingMemories = await this.loadMemories(
        memory.scope,
        projectPath
      );

      // Check if memory with same ID exists (update vs append)
      const existingIndex = existingMemories.findIndex(
        (m) => m.id === memory.id
      );

      if (existingIndex >= 0) {
        // Update existing memory
        existingMemories[existingIndex] = memory;
      } else {
        // Append new memory
        existingMemories.push(memory);
      }

      // Write back to file with pretty formatting
      await fs.writeFile(
        memoryPath,
        JSON.stringify(existingMemories, null, 2),
        "utf-8"
      );
    } catch (error) {
      // If permission denied, throw descriptive error
      if (
        error instanceof Error &&
        "code" in error &&
        error.code === "EACCES"
      ) {
        throw new Error(
          `Permission denied: Cannot write to memory file at ${memoryPath}. Check file and directory permissions.`
        );
      }

      // If no space left on device
      if (
        error instanceof Error &&
        "code" in error &&
        error.code === "ENOSPC"
      ) {
        throw new Error(
          `No space left on device: Cannot write memory file at ${memoryPath}. Free up disk space and try again.`
        );
      }

      // If read-only file system
      if (
        error instanceof Error &&
        "code" in error &&
        error.code === "EROFS"
      ) {
        throw new Error(
          `Read-only file system: Cannot write to ${memoryPath}. The file system is mounted as read-only.`
        );
      }

      // Re-throw other errors with context
      throw new Error(
        `Failed to save memory to ${memoryPath}: ${
          error instanceof Error ? error.message : String(error)
        }`
      );
    }
  }

  /**
   * Delete a memory by ID from JSON file (FR-4)
   * Removes memory from appropriate scope and writes back to file
   *
   * @param memoryId - UUID of memory to delete
   * @param scope - "project" or "global"
   * @param projectPath - Required if scope is "project"
   * @returns The deleted memory object
   * @throws Error if memory not found or scope is invalid
   */
  static async deleteMemory(
    memoryId: string,
    scope: MemoryScope,
    projectPath?: string
  ): Promise<Memory> {
    // Determine file path based on scope
    let memoryPath: string;

    if (scope === "project") {
      if (!projectPath) {
        throw new Error(
          "projectPath is required when deleting project-scoped memories"
        );
      }
      memoryPath = this.getProjectMemoryPath(projectPath);
    } else {
      memoryPath = this.getGlobalMemoryPath();
    }

    try {
      // Load existing memories
      const existingMemories = await this.loadMemories(scope, projectPath);

      // Find the memory to delete
      const memoryIndex = existingMemories.findIndex((m) => m.id === memoryId);

      if (memoryIndex === -1) {
        throw new Error(
          `Memory with ID ${memoryId} not found in ${scope} scope`
        );
      }

      // Get the memory before removing it (safe to use ! because we checked memoryIndex !== -1)
      const deletedMemory = existingMemories[memoryIndex]!;

      // Remove the memory from array
      existingMemories.splice(memoryIndex, 1);

      // Write back to file with pretty formatting
      await fs.writeFile(
        memoryPath,
        JSON.stringify(existingMemories, null, 2),
        "utf-8"
      );

      return deletedMemory;
    } catch (error) {
      // If error already has a message about memory not found, re-throw as-is
      if (
        error instanceof Error &&
        error.message.includes("not found in")
      ) {
        throw error;
      }

      // If permission denied, throw descriptive error
      if (
        error instanceof Error &&
        "code" in error &&
        error.code === "EACCES"
      ) {
        throw new Error(
          `Permission denied: Cannot delete memory from ${memoryPath}. Check file and directory permissions.`
        );
      }

      // If no space left on device
      if (
        error instanceof Error &&
        "code" in error &&
        error.code === "ENOSPC"
      ) {
        throw new Error(
          `No space left on device: Cannot write changes to ${memoryPath}. Free up disk space and try again.`
        );
      }

      // If read-only file system
      if (
        error instanceof Error &&
        "code" in error &&
        error.code === "EROFS"
      ) {
        throw new Error(
          `Read-only file system: Cannot delete memory from ${memoryPath}. The file system is mounted as read-only.`
        );
      }

      // Otherwise wrap with context
      throw new Error(
        `Failed to delete memory from ${memoryPath}: ${
          error instanceof Error ? error.message : String(error)
        }`
      );
    }
  }

  /**
   * Update an existing memory by ID (FR-5, FR-9)
   * Merges provided updates with existing memory and updates timestamp
   * Note: Embedding regeneration is handled in the tool layer
   *
   * @param memoryId - UUID of memory to update
   * @param updates - Partial memory object with fields to update
   * @param scope - "project" or "global"
   * @param projectPath - Required if scope is "project"
   * @returns The updated memory object
   * @throws Error if memory not found or scope is invalid
   */
  static async updateMemory(
    memoryId: string,
    updates: Partial<Omit<Memory, "id" | "timestamp">>,
    scope: MemoryScope,
    projectPath?: string
  ): Promise<Memory> {
    // Determine file path based on scope
    let memoryPath: string;

    if (scope === "project") {
      if (!projectPath) {
        throw new Error(
          "projectPath is required when updating project-scoped memories"
        );
      }
      memoryPath = this.getProjectMemoryPath(projectPath);
    } else {
      memoryPath = this.getGlobalMemoryPath();
    }

    try {
      // Load existing memories
      const existingMemories = await this.loadMemories(scope, projectPath);

      // Find the memory to update
      const memoryIndex = existingMemories.findIndex((m) => m.id === memoryId);

      if (memoryIndex === -1) {
        throw new Error(
          `Memory with ID ${memoryId} not found in ${scope} scope`
        );
      }

      // Get existing memory (safe to use ! because we checked memoryIndex !== -1)
      const existingMemory = existingMemories[memoryIndex]!;

      // Merge updates with existing memory
      const updatedMemory: Memory = {
        ...existingMemory,
        ...updates,
        // Always update timestamp to current time (FR-9)
        timestamp: new Date().toISOString(),
        // Preserve id (cannot be changed)
        id: memoryId,
      };

      // Update memory in array
      existingMemories[memoryIndex] = updatedMemory;

      // Write back to file with pretty formatting
      await fs.writeFile(
        memoryPath,
        JSON.stringify(existingMemories, null, 2),
        "utf-8"
      );

      return updatedMemory;
    } catch (error) {
      // If error already has a message about memory not found, re-throw as-is
      if (
        error instanceof Error &&
        error.message.includes("not found in")
      ) {
        throw error;
      }

      // If permission denied, throw descriptive error
      if (
        error instanceof Error &&
        "code" in error &&
        error.code === "EACCES"
      ) {
        throw new Error(
          `Permission denied: Cannot update memory in ${memoryPath}. Check file and directory permissions.`
        );
      }

      // If no space left on device
      if (
        error instanceof Error &&
        "code" in error &&
        error.code === "ENOSPC"
      ) {
        throw new Error(
          `No space left on device: Cannot write changes to ${memoryPath}. Free up disk space and try again.`
        );
      }

      // If read-only file system
      if (
        error instanceof Error &&
        "code" in error &&
        error.code === "EROFS"
      ) {
        throw new Error(
          `Read-only file system: Cannot update memory in ${memoryPath}. The file system is mounted as read-only.`
        );
      }

      // Otherwise wrap with context
      throw new Error(
        `Failed to update memory in ${memoryPath}: ${
          error instanceof Error ? error.message : String(error)
        }`
      );
    }
  }
}
