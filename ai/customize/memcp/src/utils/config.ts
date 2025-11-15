/**
 * Configuration management for MCP Memory Server
 * Handles loading and creating config at ~/.mcp-memory/config.json
 * Based on FR-21, FR-22
 */

import fs from "fs/promises";
import path from "path";
import os from "os";
import type { Config } from "../storage/types.js";

/**
 * Default configuration values (FR-22)
 */
const DEFAULT_CONFIG: Config = {
  embedding_provider: "local",
  embedding_model: "Xenova/all-MiniLM-L6-v2",
  default_limit: 5,
  auto_embed: true,
};

/**
 * Get the config directory path (~/.mcp-memory)
 */
export function getConfigDir(): string {
  return path.join(os.homedir(), ".mcp-memory");
}

/**
 * Get the config file path (~/.mcp-memory/config.json)
 */
export function getConfigPath(): string {
  return path.join(getConfigDir(), "config.json");
}

/**
 * Create default config file at ~/.mcp-memory/config.json
 * Creates directory if it doesn't exist (FR-22)
 */
async function createDefaultConfig(): Promise<Config> {
  const configDir = getConfigDir();
  const configPath = getConfigPath();

  try {
    // Create directory if it doesn't exist
    await fs.mkdir(configDir, { recursive: true });

    // Write default config
    await fs.writeFile(
      configPath,
      JSON.stringify(DEFAULT_CONFIG, null, 2),
      "utf-8"
    );

    console.log(`Created default config at ${configPath}`);
    return DEFAULT_CONFIG;
  } catch (error) {
    throw new Error(
      `Failed to create default config at ${configPath}: ${
        error instanceof Error ? error.message : String(error)
      }`
    );
  }
}

/**
 * Load configuration from ~/.mcp-memory/config.json
 * Creates default config if file doesn't exist (FR-21, FR-22)
 */
export async function loadConfig(): Promise<Config> {
  const configPath = getConfigPath();

  try {
    // Try to read existing config
    const configData = await fs.readFile(configPath, "utf-8");
    const config = JSON.parse(configData) as Config;

    // Validate required fields
    if (
      !config.embedding_provider ||
      !config.embedding_model ||
      typeof config.default_limit !== "number" ||
      typeof config.auto_embed !== "boolean"
    ) {
      throw new Error("Invalid config structure: missing required fields");
    }

    return config;
  } catch (error) {
    // If file doesn't exist, create default config
    if (
      error instanceof Error &&
      "code" in error &&
      error.code === "ENOENT"
    ) {
      console.log("Config file not found, creating default config...");
      return await createDefaultConfig();
    }

    // If JSON parse error, create default config
    if (error instanceof SyntaxError) {
      console.warn(
        `Invalid JSON in config file, recreating default config: ${error.message}`
      );
      return await createDefaultConfig();
    }

    // Re-throw other errors
    throw error;
  }
}

/**
 * Get default configuration without loading from file
 */
export function getDefaultConfig(): Config {
  return { ...DEFAULT_CONFIG };
}
