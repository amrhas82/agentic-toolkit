/**
 * Project detection utilities for MCP Memory Server
 * Extracts project_name and project_path from current working directory
 * Based on FR-10, FR-20
 */

import { execSync } from "child_process";
import path from "path";
import fs from "fs";

/**
 * Get the current project path (absolute path)
 * Returns the current working directory
 */
export function getProjectPath(): string {
  return process.cwd();
}

/**
 * Get the project name from git repo or directory name
 * Priority:
 * 1. Git repository name (from remote origin URL)
 * 2. Git repository name (from .git directory parent)
 * 3. Directory name
 *
 * @param projectPath - Optional project path (defaults to cwd)
 * @returns Project name (human-readable string)
 */
export function getProjectName(projectPath?: string): string {
  const targetPath = projectPath || getProjectPath();

  try {
    // Try to get git repository name from remote origin URL
    const remoteUrl = execSync("git config --get remote.origin.url", {
      cwd: targetPath,
      encoding: "utf-8",
      stdio: ["pipe", "pipe", "pipe"], // Suppress stderr
    }).trim();

    if (remoteUrl) {
      // Extract repo name from various Git URL formats:
      // - https://github.com/user/repo.git
      // - git@github.com:user/repo.git
      // - /path/to/repo.git
      const match = remoteUrl.match(/([^/]+?)(\.git)?$/);
      if (match && match[1]) {
        return match[1];
      }
    }
  } catch {
    // Git command failed, continue to fallback
  }

  try {
    // Check if .git directory exists (local git repo without remote)
    const gitDir = path.join(targetPath, ".git");
    if (fs.existsSync(gitDir)) {
      // Use parent directory name
      const dirName = path.basename(targetPath);
      if (dirName) {
        return dirName;
      }
    }
  } catch {
    // .git check failed, continue to fallback
  }

  // Fallback: Use directory name
  const dirName = path.basename(targetPath);
  return dirName || "unknown-project";
}

/**
 * Detect project context (name and path)
 * Convenience function that returns both values
 *
 * @param projectPath - Optional project path (defaults to cwd)
 * @returns Object with project_name and project_path
 */
export function detectProjectContext(projectPath?: string): {
  project_name: string;
  project_path: string;
} {
  const project_path = projectPath || getProjectPath();
  const project_name = getProjectName(project_path);

  return {
    project_name,
    project_path,
  };
}
