#!/usr/bin/env python3
"""
Skill-to-Command Converter Tool

This tool automates the consolidation of skill directories into formatted command
markdown files. It bridges the gap between modular skill documentation (spread
across multiple files and subdirectories) and single-file command documentation
that follows a standardized format.

Key Features:
- Batch processes all skill directories
- Handles errors gracefully and continues processing
- Integrates multiple markdown, code, and config files
- Follows standardized output format based on sample template
- Provides detailed reporting of all operations

Usage:
    python skill_to_command_converter.py

Author: Skill-to-Command Converter Development Team
Version: 1.0
"""

import os
import sys
import stat
import shutil
from pathlib import Path
from dataclasses import dataclass, field
from typing import List, Optional, Dict, Set, Any
from enum import Enum
import re
import glob
import json
import time

# Try importing PyYAML
try:
    import yaml
    YAML_AVAILABLE = True
except ImportError:
    YAML_AVAILABLE = False
    print("WARNING: PyYAML not installed. YAML parsing will use regex fallback.")
    print("Install with: pip install pyyaml")
    print()

# Try importing chardet for encoding detection (optional)
try:
    import chardet
    CHARDET_AVAILABLE = True
except ImportError:
    CHARDET_AVAILABLE = False
    print("INFO: chardet not installed. Using standard encoding fallback (utf-8, latin-1, cp1252).")
    print("For better encoding detection, install with: pip install chardet")
    print()


# Module-level constants - RELATIVE PATHS (relative to script location)
SCRIPT_DIR = Path(__file__).parent.resolve()
INPUT_DIR = SCRIPT_DIR / "skills"
OUTPUT_DIR = SCRIPT_DIR / "commands"
SAMPLE_FORMAT = SCRIPT_DIR.parent / "packages" / "droid" / "commands" / "algorithmic-art.md"
SKELETON_TEMPLATE = SCRIPT_DIR / "COMMAND_SKELETON_TEMPLATE.md"


# Exclusion patterns - Files and directories to skip during processing
# These patterns help filter out irrelevant files and prevent processing errors
EXCLUDE_FILES = [
    "LICENSE.txt",
    "LICENSE",
    "*.bak",
    "*.tmp"
]

EXCLUDE_DIRS = [
    "scripts",
    "__pycache__",
    ".git"
]

# Script file extensions - Used for detecting root-level executable scripts
SCRIPT_EXTENSIONS = {'.sh', '.py', '.js', '.ts', '.rb', '.pl', '.bash'}

# Directories to exclude during mode detection - Special directories that don't count as "subdirectories"
MODE_DETECTION_EXCLUDE_DIRS = {'__pycache__', '.git', 'node_modules', '.venv', 'venv'}

# Binary file extensions to exclude (not text-processable)
BINARY_EXTENSIONS = [
    ".pdf",
    ".jpg",
    ".jpeg",
    ".png",
    ".gif",
    ".ttf",
    ".woff",
    ".woff2",
    ".zip",
    ".tar.gz",
    ".tar",
    ".gz",
    ".exe",
    ".bin",
    ".dll",
    ".so"
]

# Code file extensions - files that contain code and should be syntax-highlighted
CODE_EXTENSIONS = [
    ".py",
    ".js",
    ".sh",
    ".ts",
    ".jsx",
    ".tsx",
    ".json",
    ".yaml",
    ".yml",
    ".xml"
]

# Markdown file extensions - primary documentation files
MARKDOWN_EXTENSIONS = [
    ".md",
    ".markdown"
]

# Processing limits - Safety constraints for file operations
MAX_FILE_SIZE_MB = 10  # Maximum file size to process (in megabytes)
MAX_FILE_SIZE_BYTES = MAX_FILE_SIZE_MB * 1024 * 1024

# Retry configuration - Error recovery settings
RETRY_WAIT_TIME = 0.5  # Seconds to wait between retry attempts
MAX_RETRIES = 1  # Number of retry attempts for failed operations


# ============================================================================
# Data Structures
# ============================================================================

class TransformationMode(Enum):
    """Enumeration of transformation modes for skill-to-command conversion.

    Defines the three transformation strategies based on skill directory structure:
    - DIRECTORY_WITH_SUBDIRS: Skills containing subdirectories (e.g., docx with scripts/, ooxml/)
    - DIRECTORY_WITH_SCRIPTS: Skills with root-level executable scripts (e.g., root-cause-tracing)
    - SINGLE_FILE: Simple skills with only markdown files (e.g., brainstorming)

    The mode determines how files are processed and organized in the output.
    """
    DIRECTORY_WITH_SUBDIRS = "DIRECTORY_WITH_SUBDIRS"
    DIRECTORY_WITH_SCRIPTS = "DIRECTORY_WITH_SCRIPTS"
    SINGLE_FILE = "SINGLE_FILE"


class ModeDetector:
    """Detects the appropriate transformation mode for a skill directory.

    Analyzes the structure of a skill directory to determine which of three
    transformation strategies should be applied:
    - DIRECTORY_WITH_SUBDIRS: Skill contains subdirectories to preserve
    - DIRECTORY_WITH_SCRIPTS: Skill has root-level executable scripts
    - SINGLE_FILE: Simple skill with only markdown files

    The detection follows a priority order:
    1. Check for subdirectories first (highest priority)
    2. Check for root-level scripts second
    3. Default to single-file mode (lowest priority)
    """

    def detect_mode(self, skill_dir: Path) -> TransformationMode:
        """Detect the transformation mode for a skill directory.

        Args:
            skill_dir: Path to the skill directory to analyze

        Returns:
            TransformationMode enum value indicating which transformation strategy to use

        Algorithm:
            1. Get all items in skill directory root
            2. Check for subdirectories (excluding special dirs like __pycache__)
            3. If subdirectories found, return DIRECTORY_WITH_SUBDIRS
            4. Check for root-level scripts (by file extension)
            5. If scripts found, return DIRECTORY_WITH_SCRIPTS
            6. Otherwise, return SINGLE_FILE
        """
        print(f"\n🔍 Detecting transformation mode for: {skill_dir.name}")

        if not skill_dir.exists() or not skill_dir.is_dir():
            # Default to SINGLE_FILE for invalid directories
            print(f"⚠️  Directory does not exist or is not valid: {skill_dir}")
            print(f"   → Mode: SINGLE_FILE (fallback)")
            return TransformationMode.SINGLE_FILE

        # Get all items in root directory
        try:
            root_items = list(skill_dir.iterdir())
        except (OSError, PermissionError) as e:
            # If we can't read the directory, default to SINGLE_FILE
            print(f"⚠️  Cannot read directory (permission error): {e}")
            print(f"   → Mode: SINGLE_FILE (fallback)")
            return TransformationMode.SINGLE_FILE

        # Step 1: Check for subdirectories (excluding special directories)
        subdirs = [
            item for item in root_items
            if item.is_dir() and item.name not in MODE_DETECTION_EXCLUDE_DIRS
        ]

        if len(subdirs) > 0:
            subdir_names = [d.name for d in subdirs]
            print(f"✓ Found {len(subdirs)} subdirectory(ies): {', '.join(subdir_names)}")
            print(f"   → Mode: DIRECTORY_WITH_SUBDIRS")
            return TransformationMode.DIRECTORY_WITH_SUBDIRS

        # Step 2: Check for root-level scripts
        scripts = [
            item for item in root_items
            if item.is_file() and item.suffix in SCRIPT_EXTENSIONS
        ]

        if len(scripts) > 0:
            script_names = [s.name for s in scripts]
            print(f"✓ Found {len(scripts)} root-level script(s): {', '.join(script_names)}")
            print(f"   → Mode: DIRECTORY_WITH_SCRIPTS")
            return TransformationMode.DIRECTORY_WITH_SCRIPTS

        # Step 3: Default to single file mode
        print(f"✓ No subdirectories or scripts found")
        print(f"   → Mode: SINGLE_FILE (default)")
        return TransformationMode.SINGLE_FILE


class MarkdownMerger:
    """Merges multiple markdown files into a single markdown document.

    This class handles the merging of SKILL.md with other markdown files in a skill directory.
    It extracts YAML frontmatter from the primary file, strips frontmatter from other files,
    and combines them into a single cohesive document with section headers.

    Key Features:
    - Preserves YAML frontmatter from primary file (SKILL.md)
    - Strips frontmatter from secondary files to prevent duplicates
    - Creates ## section headers from filenames
    - Merges files in alphabetical order (after SKILL.md)
    - Handles edge cases (missing files, empty content, malformed YAML)

    Usage:
        merger = MarkdownMerger()
        result = merger.merge_markdown_files(skill_md_path, other_md_paths)
    """

    def __init__(self):
        """Initialize the MarkdownMerger."""
        pass

    def extract_frontmatter(self, content: str) -> tuple[dict, str]:
        """Extract YAML frontmatter from markdown content.

        Separates the YAML frontmatter (between --- delimiters) from the
        main content of a markdown file. Parses the YAML into a dictionary.

        Args:
            content: Full markdown file content (may include frontmatter)

        Returns:
            Tuple of (frontmatter_dict, content_without_frontmatter)
            - frontmatter_dict: Parsed YAML as dictionary (empty dict if no frontmatter)
            - content_without_frontmatter: Content after the closing --- delimiter

        Notes:
            - Frontmatter must be at the start of the file (after stripping whitespace)
            - Uses --- as both opening and closing delimiters
            - Returns empty dict if no valid frontmatter found
            - Uses PyYAML if available, falls back to regex parsing
            - Attempts to fix common YAML issues automatically
        """
        frontmatter = {}

        # Strip leading whitespace
        content = content.lstrip()

        # Check if frontmatter exists
        if not content.startswith('---'):
            return {}, content

        # Split into lines
        lines = content.split('\n')

        if len(lines) < 3:
            # Not enough lines for valid frontmatter
            return {}, content

        # Find closing delimiter
        closing_index = -1
        for i in range(1, len(lines)):
            if lines[i].strip() == '---':
                closing_index = i
                break

        if closing_index == -1:
            # No closing delimiter - no valid frontmatter
            return {}, content

        # Extract YAML block
        yaml_lines = lines[1:closing_index]
        yaml_content = '\n'.join(yaml_lines)

        # Extract content after frontmatter
        content_lines = lines[closing_index + 1:]
        remaining_content = '\n'.join(content_lines).lstrip()

        # Parse YAML using PyYAML if available
        if YAML_AVAILABLE:
            try:
                # Try parsing with yaml.safe_load()
                parsed = yaml.safe_load(yaml_content)

                if parsed is None:
                    # Empty YAML block
                    return {}, remaining_content

                if not isinstance(parsed, dict):
                    # Invalid YAML structure
                    return {}, remaining_content

                # Successfully parsed - convert all values to strings
                for key, value in parsed.items():
                    if value is not None:
                        frontmatter[str(key)] = str(value)

                return frontmatter, remaining_content

            except yaml.YAMLError:
                # YAML parsing failed - try to fix common issues
                fixed_yaml = self._fix_common_yaml_issues(yaml_content)

                try:
                    parsed = yaml.safe_load(fixed_yaml)

                    if parsed and isinstance(parsed, dict):
                        # Convert all values to strings
                        for key, value in parsed.items():
                            if value is not None:
                                frontmatter[str(key)] = str(value)

                        return frontmatter, remaining_content
                except yaml.YAMLError:
                    # Still failed - fall through to regex
                    pass

        # Regex fallback - simple key: value extraction
        frontmatter = self._parse_yaml_with_regex(yaml_content)

        return frontmatter, remaining_content

    def strip_frontmatter(self, content: str) -> str:
        """Remove YAML frontmatter from markdown content.

        Removes the YAML frontmatter block (if present) and returns only
        the main markdown content.

        Args:
            content: Full markdown file content

        Returns:
            Content without frontmatter (whitespace stripped from start)

        Notes:
            - Returns original content if no frontmatter is found
            - Strips leading whitespace after frontmatter removal
        """
        _, content_without_frontmatter = self.extract_frontmatter(content)
        return content_without_frontmatter

    def _fix_common_yaml_issues(self, yaml_content: str) -> str:
        """Fix common YAML formatting issues.

        Attempts to automatically fix common problems in YAML frontmatter
        that prevent parsing, such as missing quotes or improper spacing.

        Args:
            yaml_content: Raw YAML content (without --- delimiters)

        Returns:
            Fixed YAML content

        Common fixes applied:
            - Add quotes around values containing colons
            - Add spaces after colons if missing
            - Remove extra trailing whitespace
        """
        lines = yaml_content.split('\n')
        fixed_lines = []

        for line in lines:
            # Skip empty lines and comments
            if not line.strip() or line.strip().startswith('#'):
                fixed_lines.append(line)
                continue

            # Check if line is a key-value pair
            if ':' in line:
                # Split on first colon only
                parts = line.split(':', 1)

                if len(parts) == 2:
                    key = parts[0].strip()
                    value = parts[1].strip()

                    # If value contains a colon and isn't already quoted, quote it
                    if ':' in value and not (
                        (value.startswith('"') and value.endswith('"')) or
                        (value.startswith("'") and value.endswith("'"))
                    ):
                        # Quote the value
                        # Escape any existing quotes in the value
                        value = value.replace('"', '\\"')
                        value = f'"{value}"'

                    # Reconstruct line with proper spacing
                    fixed_line = f"{key}: {value}"
                    fixed_lines.append(fixed_line)
                else:
                    # Keep original line if we can't parse it
                    fixed_lines.append(line)
            else:
                # Not a key-value pair, keep as-is
                fixed_lines.append(line)

        return '\n'.join(fixed_lines)

    def _parse_yaml_with_regex(self, yaml_content: str) -> dict:
        """Parse YAML using regex fallback (when PyYAML unavailable or fails).

        This is a simple parser that handles basic key: value pairs.
        Does not support complex YAML features like lists, nested dicts, etc.

        Args:
            yaml_content: Raw YAML content (without --- delimiters)

        Returns:
            Dictionary of key-value pairs (all values as strings)

        Notes:
            - Only handles simple key: value pairs
            - Does not support YAML lists, nested structures, or multi-line values
            - Used as fallback when PyYAML is unavailable or parsing fails
        """
        result = {}

        lines = yaml_content.split('\n')

        for line in lines:
            # Skip empty lines and comments
            if not line.strip() or line.strip().startswith('#'):
                continue

            # Look for key: value pattern
            match = re.match(r'^([a-zA-Z0-9_-]+)\s*:\s*(.*)$', line.strip())

            if match:
                key = match.group(1).strip()
                value = match.group(2).strip()

                # Remove quotes if present
                if value.startswith('"') and value.endswith('"'):
                    value = value[1:-1]
                elif value.startswith("'") and value.endswith("'"):
                    value = value[1:-1]

                # Unescape quotes
                value = value.replace('\\"', '"').replace("\\'", "'")

                result[key] = value

        return result

    def create_section_header(self, filename: str) -> str:
        """Create a section header from a filename.

        Converts a markdown filename into a readable section header.

        Args:
            filename: Filename (e.g., "api-reference.md", "getting_started.md")

        Returns:
            Section header as ## markdown (e.g., "## API Reference", "## Getting Started")

        Examples:
            "api-reference.md" -> "## API Reference"
            "getting_started.md" -> "## Getting Started"
            "INSTALL.md" -> "## INSTALL"
            "readme.md" -> "## Readme"

        Notes:
            - Removes .md/.markdown extension
            - Replaces hyphens and underscores with spaces
            - Title-cases each word (with acronym support)
            - Returns ## level header for consistency
        """
        # Common acronyms that should be fully capitalized
        acronyms = {
            'api': 'API',
            'cli': 'CLI',
            'ui': 'UI',
            'ux': 'UX',
            'url': 'URL',
            'html': 'HTML',
            'css': 'CSS',
            'js': 'JS',
            'json': 'JSON',
            'xml': 'XML',
            'sql': 'SQL',
            'rest': 'REST',
            'http': 'HTTP',
            'https': 'HTTPS',
            'ssh': 'SSH',
            'git': 'Git',
            'ai': 'AI',
            'ml': 'ML',
            'llm': 'LLM',
            'mcp': 'MCP',
        }

        # Remove file extension
        if filename.lower().endswith('.md'):
            name = filename[:-3]
        elif filename.lower().endswith('.markdown'):
            name = filename[:-9]
        else:
            name = filename

        # Replace separators with spaces
        name = name.replace('-', ' ').replace('_', ' ')

        # Split into words and capitalize each
        words = name.split()
        capitalized_words = []

        for word in words:
            word_lower = word.lower()
            if word_lower in acronyms:
                # Use the acronym form
                capitalized_words.append(acronyms[word_lower])
            else:
                # Regular title case
                capitalized_words.append(word.capitalize())

        title = ' '.join(capitalized_words)

        # Return as ## header
        return f"## {title}"

    def merge_markdown_files(self, primary_file_path, secondary_file_paths: list) -> str:
        """Merge multiple markdown files into a single document.

        Combines SKILL.md (primary) with other markdown files (secondary).
        The primary file's frontmatter is preserved, all others are stripped.
        Each secondary file becomes a section with a ## header.

        Args:
            primary_file_path: Path to primary markdown file (typically SKILL.md)
                              Can be None if no primary file exists
            secondary_file_paths: List of Path objects for other markdown files
                                 Will be sorted alphabetically before merging

        Returns:
            Merged markdown content as a single string

        Merging Algorithm:
            1. Read primary file (if exists)
               - Preserve frontmatter
               - Include content
            2. Sort secondary files alphabetically
            3. For each secondary file:
               - Strip frontmatter
               - Create ## section header from filename
               - Append content
            4. Join all sections with blank lines

        Notes:
            - Preserves only the primary file's frontmatter
            - Creates section headers from filenames
            - Handles missing files gracefully
            - Returns empty string if no files can be read
        """
        sections = []

        # Step 1: Process primary file (if it exists)
        if primary_file_path is not None:
            try:
                # Convert to Path object if needed
                if not isinstance(primary_file_path, Path):
                    primary_file_path = Path(primary_file_path)

                if primary_file_path.exists() and primary_file_path.is_file():
                    # Read primary file content
                    primary_content = primary_file_path.read_text(encoding='utf-8')

                    # Extract frontmatter and content
                    frontmatter, content = self.extract_frontmatter(primary_content)

                    # Reconstruct with frontmatter (if it exists)
                    if frontmatter:
                        # Rebuild YAML frontmatter block
                        yaml_lines = ['---']
                        for key, value in frontmatter.items():
                            # Quote values that contain colons
                            if ':' in str(value):
                                yaml_lines.append(f'{key}: "{value}"')
                            else:
                                yaml_lines.append(f'{key}: {value}')
                        yaml_lines.append('---')

                        primary_section = '\n'.join(yaml_lines) + '\n\n' + content
                    else:
                        # No frontmatter, just use content
                        primary_section = content

                    sections.append(primary_section.strip())

            except (OSError, PermissionError, UnicodeDecodeError) as e:
                # Failed to read primary file - continue without it
                pass

        # Step 2: Process secondary files
        if secondary_file_paths:
            # Sort files alphabetically by filename
            sorted_files = sorted(secondary_file_paths, key=lambda p: p.name.lower())

            for file_path in sorted_files:
                try:
                    # Convert to Path object if needed
                    if not isinstance(file_path, Path):
                        file_path = Path(file_path)

                    if not file_path.exists() or not file_path.is_file():
                        # Skip non-existent files
                        continue

                    # Read file content
                    file_content = file_path.read_text(encoding='utf-8')

                    # Strip frontmatter from secondary files
                    content_without_fm = self.strip_frontmatter(file_content)

                    # Skip empty files
                    if not content_without_fm.strip():
                        continue

                    # Create section header from filename
                    section_header = self.create_section_header(file_path.name)

                    # Combine header and content
                    section = f"{section_header}\n\n{content_without_fm.strip()}"

                    sections.append(section)

                except (OSError, PermissionError, UnicodeDecodeError) as e:
                    # Failed to read this file - skip it and continue
                    continue

        # Step 3: Merge all sections with blank lines between them
        if not sections:
            # No content was successfully read
            return ""

        merged_content = '\n\n'.join(sections)

        return merged_content


class SubdirectoryPreserver:
    """Preserves subdirectories from skill directory to command directory.

    This class handles copying subdirectories (and their contents) from a skill
    directory to the command directory while preserving file permissions, excluding
    unwanted files, and tracking statistics.

    Key Features:
    - Recursive directory copying with shutil.copytree
    - File permission preservation (especially executable bit for scripts)
    - Exclusion of unwanted files (LICENSE.txt, .gitignore, __pycache__)
    - Symbolic link resolution before copying
    - File count tracking and reporting
    - Handles nested directory structures

    Usage:
        preserver = SubdirectoryPreserver()
        stats = preserver.copy_subdirectories(source_dir, dest_dir, subdir_names)
    """

    # Files and directories to exclude at any depth
    EXCLUDE_PATTERNS = {
        'LICENSE.txt',
        'LICENSE',
        '.gitignore',
        '.git',
        '__pycache__',
        '*.pyc',
        '*.pyo',
        '*.pyd',
        '.DS_Store',
        'Thumbs.db',
    }

    def __init__(self):
        """Initialize the SubdirectoryPreserver."""
        pass

    def copy_subdirectories(self, source_dir: Path, dest_dir: Path,
                           subdir_names: list) -> dict:
        """Copy specified subdirectories from source to destination.

        Recursively copies subdirectories while preserving permissions and
        excluding unwanted files.

        Args:
            source_dir: Source skill directory containing subdirectories
            dest_dir: Destination command directory where subdirs will be copied
            subdir_names: List of subdirectory names to copy (e.g., ['scripts', 'ooxml'])

        Returns:
            Dictionary with copy statistics:
            {
                'copied_dirs': int,      # Number of directories copied
                'copied_files': int,     # Number of files copied
                'excluded_files': int,   # Number of files excluded
                'errors': list,          # List of error messages
            }

        Notes:
            - Creates dest_dir if it doesn't exist
            - Preserves file permissions including executable bit
            - Resolves symbolic links before copying
            - Excludes files matching EXCLUDE_PATTERNS
            - Handles errors gracefully and reports them
        """
        stats = {
            'copied_dirs': 0,
            'copied_files': 0,
            'excluded_files': 0,
            'errors': [],
        }

        # Convert to Path objects if needed
        if not isinstance(source_dir, Path):
            source_dir = Path(source_dir)
        if not isinstance(dest_dir, Path):
            dest_dir = Path(dest_dir)

        # Create destination directory if it doesn't exist
        try:
            dest_dir.mkdir(parents=True, exist_ok=True)
        except OSError as e:
            stats['errors'].append(f"Failed to create destination directory: {e}")
            return stats

        # Copy each subdirectory
        for subdir_name in subdir_names:
            source_subdir = source_dir / subdir_name
            dest_subdir = dest_dir / subdir_name

            # Check if source subdirectory exists
            if not source_subdir.exists() or not source_subdir.is_dir():
                stats['errors'].append(f"Source subdirectory not found: {subdir_name}")
                continue

            # Use recursive copy with our custom logic
            try:
                self._copy_directory_recursive(source_subdir, dest_subdir, stats)
                stats['copied_dirs'] += 1
            except Exception as e:
                stats['errors'].append(f"Error copying {subdir_name}: {e}")

        return stats

    def _copy_directory_recursive(self, src_dir: Path, dest_dir: Path,
                                  stats: dict) -> None:
        """Recursively copy a directory while preserving permissions and excluding files.

        Args:
            src_dir: Source directory to copy
            dest_dir: Destination directory
            stats: Statistics dictionary to update

        Notes:
            - Updates stats in place
            - Excludes files matching EXCLUDE_PATTERNS
            - Preserves file permissions
            - Resolves symbolic links
        """
        # Create destination directory
        try:
            dest_dir.mkdir(parents=True, exist_ok=True)
        except OSError as e:
            stats['errors'].append(f"Failed to create directory {dest_dir}: {e}")
            return

        # Iterate through source directory contents
        try:
            items = list(src_dir.iterdir())
        except (OSError, PermissionError) as e:
            stats['errors'].append(f"Failed to read directory {src_dir}: {e}")
            return

        for item in items:
            # Check if item should be excluded
            if self._should_exclude(item.name):
                stats['excluded_files'] += 1
                continue

            # Preserve original name before resolving symlinks
            original_name = item.name

            # Resolve symbolic links
            if item.is_symlink():
                try:
                    item = item.resolve()
                except (OSError, RuntimeError) as e:
                    stats['errors'].append(f"Failed to resolve symlink {item}: {e}")
                    continue

            # Use original name for destination (preserves symlink names)
            dest_item = dest_dir / original_name

            if item.is_dir():
                # Recursively copy subdirectory
                self._copy_directory_recursive(item, dest_item, stats)
                stats['copied_dirs'] += 1
            elif item.is_file():
                # Copy file with permissions
                if self._copy_with_permissions(item, dest_item):
                    stats['copied_files'] += 1
                else:
                    stats['errors'].append(f"Failed to copy file {item}")

    def _should_exclude(self, filename: str) -> bool:
        """Check if a file should be excluded based on EXCLUDE_PATTERNS.

        Args:
            filename: Name of the file to check

        Returns:
            True if file should be excluded, False otherwise

        Notes:
            - Checks against EXCLUDE_PATTERNS set
            - Supports exact matches and glob patterns (*.pyc)
        """
        import fnmatch

        # Check for exact match
        if filename in self.EXCLUDE_PATTERNS:
            return True

        # Check for glob pattern match
        for pattern in self.EXCLUDE_PATTERNS:
            if '*' in pattern or '?' in pattern:
                if fnmatch.fnmatch(filename, pattern):
                    return True

        return False

    def _copy_with_permissions(self, src: Path, dest: Path) -> bool:
        """Copy a file while preserving permissions.

        Args:
            src: Source file path
            dest: Destination file path

        Returns:
            True if copy succeeded, False otherwise

        Notes:
            - Preserves file mode (permissions)
            - Especially important for executable scripts
            - Handles symbolic links by resolving them first
        """
        try:
            # Copy file content
            shutil.copy2(src, dest)  # copy2 preserves metadata including permissions

            # Explicitly preserve executable bit (just to be sure)
            if os.access(src, os.X_OK):
                # Get current permissions and ensure executable bit is set
                current_mode = dest.stat().st_mode
                dest.chmod(current_mode | stat.S_IXUSR | stat.S_IXGRP | stat.S_IXOTH)

            return True

        except (OSError, PermissionError, IOError) as e:
            return False


class PathUpdater:
    """Updates file paths in markdown content after script relocation.

    This class handles the relocation of root-level scripts to a skill-specific
    subdirectory and updates all references to those scripts in markdown files.

    Key Features:
    - Detects script files by extension (SCRIPT_EXTENSIONS)
    - Relocates scripts to /commands/{skill-name}/ subdirectory
    - Finds relative path references in markdown (./script.sh patterns)
    - Updates paths to point to relocated scripts (./{skill-name}/script.sh)
    - Preserves paths in code blocks (examples shouldn't be updated)
    - Tracks number of path updates made

    Usage:
        updater = PathUpdater()
        relocated = updater.relocate_scripts(source_dir, dest_dir, skill_name, script_files)
        updated_md = updater.update_paths_in_markdown(markdown_content, skill_name, script_files)
    """

    def __init__(self):
        """Initialize the PathUpdater."""
        pass

    def relocate_scripts(self, source_dir: Path, dest_dir: Path,
                        skill_name: str, script_files: list) -> dict:
        """Relocate script files from source to skill-specific subdirectory.

        Moves root-level script files to a subdirectory named after the skill
        while preserving their permissions.

        Args:
            source_dir: Source skill directory containing scripts
            dest_dir: Destination commands directory
            skill_name: Name of the skill (used for subdirectory name)
            script_files: List of Path objects for script files to relocate

        Returns:
            Dictionary with relocation statistics:
            {
                'relocated_count': int,    # Number of scripts relocated
                'errors': list,            # List of error messages
            }

        Notes:
            - Creates {dest_dir}/{skill_name}/ subdirectory
            - Preserves file permissions including executable bit
            - Handles errors gracefully
        """
        stats = {
            'relocated_count': 0,
            'errors': [],
        }

        # Convert to Path objects if needed
        if not isinstance(source_dir, Path):
            source_dir = Path(source_dir)
        if not isinstance(dest_dir, Path):
            dest_dir = Path(dest_dir)

        # Create skill subdirectory
        skill_subdir = dest_dir / skill_name
        try:
            skill_subdir.mkdir(parents=True, exist_ok=True)
        except OSError as e:
            stats['errors'].append(f"Failed to create subdirectory {skill_name}: {e}")
            return stats

        # Relocate each script file
        for script_file in script_files:
            if not isinstance(script_file, Path):
                script_file = Path(script_file)

            # Build source and destination paths
            if script_file.is_absolute():
                source_path = script_file
            else:
                source_path = source_dir / script_file

            dest_path = skill_subdir / script_file.name

            # Copy file with permissions
            try:
                shutil.copy2(source_path, dest_path)

                # Ensure executable bit is preserved
                if os.access(source_path, os.X_OK):
                    current_mode = dest_path.stat().st_mode
                    dest_path.chmod(current_mode | stat.S_IXUSR | stat.S_IXGRP | stat.S_IXOTH)

                stats['relocated_count'] += 1

            except (OSError, PermissionError, IOError) as e:
                stats['errors'].append(f"Failed to relocate {script_file.name}: {e}")

        return stats

    def update_paths_in_markdown(self, content: str, skill_name: str,
                                 script_files: list) -> tuple[str, int]:
        """Update script paths in markdown content after relocation.

        Finds references to relocated scripts in markdown and updates them
        to point to the new location in the skill subdirectory.

        Args:
            content: Markdown content to update
            skill_name: Name of the skill (subdirectory name)
            script_files: List of script filenames that were relocated

        Returns:
            Tuple of (updated_content, update_count)
            - updated_content: Markdown with updated paths
            - update_count: Number of path replacements made

        Path Transformations:
            ./script.sh        → ./{skill-name}/script.sh
            ./setup.py         → ./{skill-name}/setup.py
            scripts/helper.sh  → {skill-name}/helper.sh (root-level only)

        Notes:
            - Only updates paths to relocated scripts
            - Preserves paths in code blocks (triple backticks)
            - Uses regex to find path references
            - Case-sensitive matching
        """
        update_count = 0
        updated_content = content

        # Extract just filenames from script_files
        script_filenames = []
        for script in script_files:
            if isinstance(script, Path):
                script_filenames.append(script.name)
            else:
                script_filenames.append(Path(script).name)

        # Find all script path references
        path_matches = self._find_script_paths(updated_content, script_filenames)

        # Sort by position (descending) to avoid offset issues during replacement
        path_matches.sort(key=lambda x: x[1], reverse=True)

        # Replace each path (if not in code block)
        for original_path, start_pos, end_pos in path_matches:
            # Check if this path is in a code block
            if self._is_in_code_block(updated_content, start_pos):
                continue  # Skip paths in code blocks

            # Replace the path
            new_path = self._replace_path(original_path, skill_name)

            # Perform replacement
            updated_content = (
                updated_content[:start_pos] +
                new_path +
                updated_content[end_pos:]
            )

            update_count += 1

        return updated_content, update_count

    def _find_script_paths(self, content: str, script_files: list) -> list:
        """Find all references to script files in markdown content.

        Uses regex to locate path references like ./script.sh, ./setup.py, etc.

        Args:
            content: Markdown content to search
            script_files: List of script filenames to look for

        Returns:
            List of tuples: [(original_path, start_pos, end_pos), ...]

        Notes:
            - Finds relative paths starting with ./ or ../
            - Matches script filenames from script_files list
            - Returns position information for replacement
        """
        matches = []

        for script_name in script_files:
            # Escape special regex characters in filename
            escaped_name = re.escape(script_name)

            # Pattern matches: ./ or ../ or nothing, followed by the script name
            # This captures paths like:
            # - ./script.sh
            # - ../script.sh
            # - script.sh (just the filename)
            pattern = r'(\./|\.\./|)' + escaped_name

            for match in re.finditer(pattern, content):
                original_path = match.group(0)
                start_pos = match.start()
                end_pos = match.end()

                matches.append((original_path, start_pos, end_pos))

        return matches

    def _is_in_code_block(self, content: str, position: int) -> bool:
        """Check if a position in the content is inside a code block.

        Code blocks (triple backticks) contain examples that shouldn't
        be updated.

        Args:
            content: Full markdown content
            position: Character position to check

        Returns:
            True if position is inside a code block, False otherwise

        Notes:
            - Checks for triple backtick code blocks (```)
            - Checks for indented code blocks (4 spaces)
            - Handles both fenced and indented code blocks
        """
        # Find all code block boundaries (triple backticks)
        code_blocks = []

        # Find fenced code blocks (```)
        lines = content.split('\n')
        in_code_block = False
        current_pos = 0
        block_start = 0

        for line in lines:
            line_length = len(line) + 1  # +1 for newline

            if line.strip().startswith('```'):
                if in_code_block:
                    # End of code block
                    code_blocks.append((block_start, current_pos + line_length))
                    in_code_block = False
                else:
                    # Start of code block
                    block_start = current_pos
                    in_code_block = True

            current_pos += line_length

        # Check if position is within any code block
        for block_start, block_end in code_blocks:
            if block_start <= position < block_end:
                return True

        return False

    def _replace_path(self, original_path: str, skill_name: str) -> str:
        """Replace a script path with the relocated path.

        Transforms paths to point to the skill subdirectory.

        Args:
            original_path: Original path (e.g., "./script.sh")
            skill_name: Skill name (subdirectory name)

        Returns:
            Updated path (e.g., "./{skill-name}/script.sh")

        Examples:
            ./script.sh        → ./{skill-name}/script.sh
            ./setup.py         → ./{skill-name}/setup.py
            script.sh          → {skill-name}/script.sh

        Notes:
            - Preserves ./ prefix if present
            - Handles paths with and without ./
            - Uses skill_name as subdirectory
        """
        # Extract filename from path
        if '/' in original_path:
            # Path has directory component
            filename = original_path.split('/')[-1]
        else:
            filename = original_path

        # Build new path based on original format
        if original_path.startswith('./'):
            # ./script.sh → ./{skill-name}/script.sh
            return f"./{skill_name}/{filename}"
        elif original_path.startswith('../'):
            # ../script.sh → ./{skill-name}/script.sh (normalize to current dir)
            return f"./{skill_name}/{filename}"
        else:
            # script.sh → {skill-name}/script.sh
            return f"{skill_name}/{filename}"


@dataclass
class ProcessingResult:
    """Result of processing a single skill directory.

    This dataclass captures the complete outcome of converting a single skill
    directory into a command markdown file. It tracks both successful operations
    and any errors encountered during processing.

    Attributes:
        skill_name: Name of the skill directory being processed (e.g., "algorithmic-art").
                   This is the directory name, not the full path.

        status: Processing outcome indicator. Must be one of:
               - "SUCCESS": All files processed without errors, output file created
               - "PARTIAL_SUCCESS": Output file created but some non-critical errors occurred
               - "FAILED": Processing failed, no output file created or unusable output

        output_file: Absolute path to the generated command markdown file.
                    None if processing failed before file creation.

        files_processed: List of relative paths (from skill directory root) of all files
                        that were successfully read and included in the output.
                        Includes markdown files, code files, and configuration files.

        errors: List of error messages encountered during processing.
               Empty list indicates no errors. Errors may include:
               - File read failures (encoding issues, permissions, not found)
               - Parsing errors (malformed YAML/JSON)
               - Template processing errors
               - File write failures

        notes: List of informational messages about the processing.
              Used for warnings, skipped files, fallback operations, etc.
              Examples: "Skipped binary file: image.png", "Using regex fallback for YAML"

        retry_count: Number of retry attempts made during processing.
                    0 indicates successful first attempt.
                    Used to track reliability and identify problematic skills.

        transformation_mode: The transformation mode detected for this skill.
                           One of: DIRECTORY_WITH_SUBDIRS, DIRECTORY_WITH_SCRIPTS, SINGLE_FILE.
                           None if mode detection was not performed.

        markdown_files_merged: Number of markdown files that were merged together.
                             0 for skills with only SKILL.md, >1 for skills with multiple .md files.

        subdirectories_copied: Number of subdirectories that were preserved and copied.
                             Only applicable for DIRECTORY_WITH_SUBDIRS mode.

        scripts_relocated: Number of root-level scripts that were relocated to skill subdirectory.
                         Only applicable for DIRECTORY_WITH_SCRIPTS mode.

        path_updates_count: Number of path references updated in markdown after script relocation.
                          0 if no scripts were relocated or no paths needed updating.

        path_update_details: List of specific path updates made (e.g., "./setup.sh → ./skill/setup.sh").
                           Empty list if no path updates were made.
    """
    skill_name: str
    status: str
    output_file: Optional[str]
    files_processed: List[str]
    errors: List[str]
    notes: List[str]
    retry_count: int
    transformation_mode: Optional[str] = None
    markdown_files_merged: int = 0
    subdirectories_copied: int = 0
    scripts_relocated: int = 0
    path_updates_count: int = 0
    path_update_details: List[str] = field(default_factory=list)


@dataclass
class ConversionReport:
    """Final report for entire conversion process.

    This dataclass aggregates results from all skill directory conversions
    and provides summary statistics for the entire batch operation. Used
    for final reporting and logging.

    Attributes:
        total_skills: Total number of skill directories discovered and queued
                     for processing. This is the count of all subdirectories
                     found in the skills/ input directory.

        successful: Count of skills that completed with status="SUCCESS".
                   These skills were fully processed without any errors.

        partial_success: Count of skills that completed with status="PARTIAL_SUCCESS".
                        These skills produced output but encountered some non-critical
                        errors (e.g., skipped files, encoding warnings).

        failed: Count of skills that completed with status="FAILED".
               These skills did not produce usable output files due to
               critical errors during processing.

        total_files_processed: Sum of all files successfully processed across
                              all skills. Counts individual files that were
                              read and included in command outputs.

        total_errors: Sum of all errors encountered across all skills.
                     Calculated from len(result.errors) for each result.
                     High error count indicates systematic issues.

        total_retries: Sum of all retry attempts across all skills.
                      Calculated from result.retry_count for each result.
                      High retry count indicates reliability issues.

        results: List of ProcessingResult objects, one per skill directory.
                Ordered by processing sequence. Used for detailed reporting
                and debugging. Allows inspection of individual skill outcomes.
    """
    total_skills: int
    successful: int
    partial_success: int
    failed: int
    total_files_processed: int
    total_errors: int
    total_retries: int
    results: List[ProcessingResult]


# ============================================================================
# Utility Functions
# ============================================================================

def detect_encoding(file_path: Path) -> str:
    """Detect the encoding of a file.

    Uses chardet library if available for automatic detection. Otherwise,
    tries common encodings in sequence: UTF-8, Latin-1, CP1252.

    Args:
        file_path: Path to the file to analyze.

    Returns:
        Detected encoding name as a string. Returns 'utf-8' as fallback
        if detection fails.

    Notes:
        - chardet provides better accuracy but is optional
        - Fallback sequence covers most Western text files
        - Always returns a valid encoding name
    """
    # Try chardet first if available
    if CHARDET_AVAILABLE:
        try:
            with open(file_path, 'rb') as f:
                raw_data = f.read()

            # Use chardet to detect encoding
            detected = chardet.detect(raw_data)
            if detected and detected['encoding']:
                confidence = detected.get('confidence', 0)
                encoding = detected['encoding']

                # Only use chardet result if confidence is reasonable
                if confidence > 0.7:
                    return encoding
        except Exception as e:
            # If chardet fails, fall through to manual detection
            pass

    # Try common encodings in sequence
    encodings_to_try = ['utf-8', 'latin-1', 'cp1252']

    for encoding in encodings_to_try:
        try:
            with open(file_path, 'r', encoding=encoding) as f:
                # Try to read first 1024 bytes to verify encoding works
                f.read(1024)
            return encoding
        except (UnicodeDecodeError, LookupError):
            continue
        except Exception:
            # Other errors (permission, file not found) should propagate
            pass

    # If all detection methods fail, return utf-8 as safe default
    return 'utf-8'


def safe_read_file(file_path: Path, retry: bool = True) -> Optional[str]:
    """Safely read a file with automatic encoding detection and retry logic.

    Attempts to read a file using detected encoding. Implements retry logic
    for transient failures like temporary permission issues or locks.

    Args:
        file_path: Path to the file to read.
        retry: If True, retry once after 0.5s wait on failure. Default: True.

    Returns:
        File contents as a string, or None if reading fails.

    Error Handling:
        - FileNotFoundError: Returns None, logs warning (no retry)
        - PermissionError: Retries if retry=True, returns None on final failure
        - UnicodeDecodeError: Returns None with error logging (no retry)
        - Other exceptions: Retries if retry=True, returns None on final failure

    Notes:
        - Uses detect_encoding() for automatic encoding detection
        - Uses retry_operation() for consistent retry behavior
        - Retry delay is RETRY_WAIT_TIME (0.5 seconds)
        - Maximum of 1 retry attempt (2 total attempts)
    """
    def _attempt_read() -> str:
        """Internal function to attempt file read."""
        # Detect encoding first
        encoding = detect_encoding(file_path)

        # Read file with detected encoding
        with open(file_path, 'r', encoding=encoding, errors='replace') as f:
            content = f.read()

        return content

    # Try to read the file - handle non-retryable errors first
    try:
        # Use retry_operation if retry is enabled
        if retry:
            return retry_operation(
                _attempt_read,
                operation_name=f"read {file_path.name}",
                max_retries=MAX_RETRIES,
                delay=RETRY_WAIT_TIME
            )
        else:
            return _attempt_read()

    except FileNotFoundError:
        print(f"WARNING: File not found: {file_path}")
        return None

    except UnicodeDecodeError as e:
        print(f"ERROR: Unicode decode error for {file_path.name}: {e}")
        return None

    except Exception as e:
        # All other errors (including retry exhaustion)
        print(f"ERROR: Failed to read {file_path.name}: {e}")
        return None


def should_exclude_file(file_path: Path) -> bool:
    """Check if a file should be excluded from processing.

    Applies exclusion rules based on:
    - Filename patterns (LICENSE.txt, *.bak, etc.)
    - File extensions (binary files)
    - File size limits

    Args:
        file_path: Path to the file to check.

    Returns:
        True if file should be excluded, False if it should be processed.

    Exclusion Rules:
        1. Files matching EXCLUDE_FILES patterns
        2. Files with BINARY_EXTENSIONS
        3. Files exceeding MAX_FILE_SIZE_BYTES
        4. Files in directories matching EXCLUDE_DIRS (checked separately)

    Notes:
        - Case-insensitive filename matching
        - Uses glob-style pattern matching for EXCLUDE_FILES
        - Size check prevents processing huge files
    """
    # Get filename and extension
    filename = file_path.name
    extension = file_path.suffix.lower()

    # Check against excluded filenames (exact match or pattern)
    for pattern in EXCLUDE_FILES:
        if pattern.startswith('*'):
            # Wildcard pattern (e.g., *.bak)
            if filename.endswith(pattern[1:]):
                return True
        else:
            # Exact match (case-insensitive)
            if filename.lower() == pattern.lower():
                return True

    # Check against binary extensions
    if extension in BINARY_EXTENSIONS:
        return True

    # Check file size
    try:
        file_size = file_path.stat().st_size
        if file_size > MAX_FILE_SIZE_BYTES:
            print(f"WARNING: Excluding {filename} - exceeds size limit ({file_size / (1024*1024):.1f} MB)")
            return True

        # Also exclude empty files
        if file_size == 0:
            return True
    except Exception as e:
        # If we can't get file size, exclude it to be safe
        print(f"WARNING: Cannot stat {filename}: {e}")
        return True

    return False


def should_exclude_dir(dir_name: str) -> bool:
    """Check if a directory should be excluded from processing.

    Checks directory name against EXCLUDE_DIRS patterns.

    Args:
        dir_name: Name of the directory (not full path, just the directory name).

    Returns:
        True if directory should be excluded, False if it should be processed.

    Exclusion Rules:
        - Directories matching EXCLUDE_DIRS patterns
        - Case-insensitive matching

    Notes:
        - Used during recursive file discovery
        - Helps skip irrelevant directories like __pycache__, .git, scripts/
    """
    # Normalize directory name to lowercase for comparison
    dir_name_lower = dir_name.lower()

    # Check against excluded directory names
    for excluded in EXCLUDE_DIRS:
        if dir_name_lower == excluded.lower():
            return True

    return False


def get_language_hint(file_path: Path) -> str:
    """Get syntax highlighting language hint for a file.

    Maps file extensions to language identifiers used in markdown
    code blocks for syntax highlighting.

    Args:
        file_path: Path to the file.

    Returns:
        Language identifier string (e.g., 'python', 'javascript', 'bash').
        Returns empty string if no specific language mapping exists.

    Language Mappings:
        - .py → python
        - .js, .jsx → javascript
        - .ts, .tsx → typescript
        - .sh, .bash → bash
        - .json → json
        - .yaml, .yml → yaml
        - .xml → xml
        - .md, .markdown → markdown
        - And more...

    Notes:
        - Used when creating code blocks in output markdown
        - Enables proper syntax highlighting in rendered markdown
        - Empty string is valid (renders as plain text)
    """
    # Get file extension (lowercase, without the dot)
    extension = file_path.suffix.lower()

    # Map extensions to language identifiers
    language_map = {
        # Programming languages
        '.py': 'python',
        '.js': 'javascript',
        '.jsx': 'javascript',
        '.ts': 'typescript',
        '.tsx': 'typescript',
        '.java': 'java',
        '.c': 'c',
        '.cpp': 'cpp',
        '.cc': 'cpp',
        '.cxx': 'cpp',
        '.h': 'c',
        '.hpp': 'cpp',
        '.cs': 'csharp',
        '.rb': 'ruby',
        '.go': 'go',
        '.rs': 'rust',
        '.php': 'php',
        '.swift': 'swift',
        '.kt': 'kotlin',
        '.scala': 'scala',

        # Shell scripts
        '.sh': 'bash',
        '.bash': 'bash',
        '.zsh': 'bash',
        '.fish': 'fish',

        # Web technologies
        '.html': 'html',
        '.htm': 'html',
        '.css': 'css',
        '.scss': 'scss',
        '.sass': 'sass',
        '.less': 'less',

        # Data formats
        '.json': 'json',
        '.yaml': 'yaml',
        '.yml': 'yaml',
        '.toml': 'toml',
        '.xml': 'xml',
        '.csv': 'csv',

        # Markup
        '.md': 'markdown',
        '.markdown': 'markdown',
        '.rst': 'rst',

        # Configuration
        '.ini': 'ini',
        '.cfg': 'ini',
        '.conf': 'conf',

        # Other
        '.sql': 'sql',
        '.txt': 'text',
    }

    # Return mapped language or empty string
    return language_map.get(extension, '')


def retry_operation(operation, operation_name: str = "operation",
                   max_retries: int = MAX_RETRIES, delay: float = RETRY_WAIT_TIME) -> Any:
    """
    Retry an operation with delay between attempts.

    Executes the given operation and retries it if it fails. Uses exponential
    backoff or fixed delay between retries. Designed for transient failures
    like network issues, file locks, or temporary permission errors.

    Args:
        operation: Callable (function or lambda) to execute. Should take no arguments.
        operation_name: Human-readable name for logging (e.g., "read file X")
        max_retries: Maximum number of retry attempts (default: MAX_RETRIES=1)
        delay: Seconds to wait between retry attempts (default: RETRY_WAIT_TIME=0.5)

    Returns:
        The result of the operation if successful

    Raises:
        Exception: If all attempts fail, raises the last exception encountered

    Example:
        >>> result = retry_operation(
        ...     lambda: file_path.read_text(),
        ...     operation_name="read config.json",
        ...     max_retries=1,
        ...     delay=0.5
        ... )

    Notes:
        - Logs retry attempts to stdout
        - First attempt is not counted as a retry
        - Logs success if retry succeeds
        - Total attempts = max_retries + 1 (initial attempt + retries)
    """
    attempt = 0
    last_error = None

    while attempt <= max_retries:
        try:
            # Execute the operation
            result = operation()

            # Log success on retry
            if attempt > 0:
                print(f"    ✓ Retry #{attempt} succeeded for {operation_name}")

            return result

        except Exception as e:
            # Store error and increment attempt counter
            last_error = e
            attempt += 1

            # If we have retries left, log and wait
            if attempt <= max_retries:
                print(f"    ⚠ Retry #{attempt} for {operation_name} after error: {str(e)[:80]}")
                time.sleep(delay)
            # Otherwise, we've exhausted retries (will raise below)

    # All attempts failed - raise exception with details
    total_attempts = max_retries + 1
    error_msg = f"{operation_name} failed after {total_attempts} attempt(s)"
    if last_error:
        error_msg += f": {last_error}"

    raise Exception(error_msg)


# ============================================================================
# SkillConverter Class
# ============================================================================

class SkillConverter:
    """Main converter class for processing skill directories into command files.

    This class orchestrates the entire conversion process:
    1. Discovers all skill directories in the input folder
    2. Processes each skill directory individually
    3. Generates output command markdown files
    4. Tracks results and generates final reports

    Attributes:
        results: List of ProcessingResult objects tracking each skill conversion.
        mode_detector: ModeDetector instance for detecting transformation modes.
        markdown_merger: MarkdownMerger instance for merging markdown files.
        subdirectory_preserver: SubdirectoryPreserver instance for copying subdirectories.
        path_updater: PathUpdater instance for relocating scripts and updating paths.
    """

    def __init__(self):
        """Initialize the converter and its component classes."""
        self.results: List[ProcessingResult] = []

        # Initialize v2.0 component classes
        self.mode_detector = ModeDetector()
        self.markdown_merger = MarkdownMerger()
        self.subdirectory_preserver = SubdirectoryPreserver()
        self.path_updater = PathUpdater()

    def read_file_with_retry(self, file_path: Path) -> Optional[str]:
        """Read a file with encoding detection and retry logic.

        Uses safe_read_file() utility which handles:
        - Encoding detection (UTF-8, Latin-1, CP1252, or chardet if available)
        - Retry logic (1 retry with 0.5s delay)
        - Error handling for permissions, encoding, and other issues

        This method adds integration logging and provides a clean interface
        for the conversion pipeline.

        Args:
            file_path: Path to file to read

        Returns:
            File content as string, or None if failed after all retry attempts

        Notes:
            - Logs read attempts and results
            - Uses safe_read_file() for all heavy lifting
            - Retry logic is handled by safe_read_file()
        """
        # Log attempt
        print(f"  Reading file: {file_path.name}")

        # Call safe_read_file() with retry enabled
        content = safe_read_file(file_path, retry=True)

        # Log result
        if content is not None:
            print(f"    ✓ Successfully read {file_path.name} ({len(content)} chars)")
        else:
            print(f"    ✗ Failed to read {file_path.name}")

        return content

    def extract_yaml_frontmatter(self, content: str) -> Dict[str, str]:
        """Extract YAML front matter from markdown content.

        Looks for YAML between --- delimiters at the start of the content.
        Attempts to fix common YAML formatting issues.

        Args:
            content: Markdown file content

        Returns:
            Dictionary with 'description' and optional 'argument-hint'.
            May also include other fields found in the YAML (e.g., 'name', 'license').
            Returns empty dict if no valid YAML found.

        Error Handling:
            - Returns empty dict if no --- delimiters found
            - Attempts to fix common YAML issues before giving up
            - Logs warnings for malformed YAML

        Common YAML Issues Fixed:
            - Missing quotes around values with colons
            - Extra whitespace
            - Missing spaces after colons
        """
        result = {}

        # Strip leading whitespace and check for --- delimiter
        content = content.lstrip()

        if not content.startswith('---'):
            # No YAML front matter
            return result

        # Find the closing --- delimiter
        # We need to find the second occurrence of --- (first is opening, second is closing)
        lines = content.split('\n')

        if len(lines) < 3:
            # Not enough lines for valid YAML front matter
            return result

        # Find closing delimiter
        closing_index = -1
        for i in range(1, len(lines)):
            if lines[i].strip() == '---':
                closing_index = i
                break

        if closing_index == -1:
            # No closing delimiter found
            print("WARNING: YAML front matter missing closing '---' delimiter")
            return result

        # Extract YAML block (lines between the two --- delimiters)
        yaml_lines = lines[1:closing_index]
        yaml_content = '\n'.join(yaml_lines)

        # Try to parse YAML
        if YAML_AVAILABLE:
            try:
                # Try parsing with yaml.safe_load()
                parsed = yaml.safe_load(yaml_content)

                if parsed is None:
                    # Empty YAML block
                    return result

                if not isinstance(parsed, dict):
                    print(f"WARNING: YAML front matter is not a dictionary, got {type(parsed)}")
                    return result

                # Successfully parsed - return the dictionary
                # Convert all values to strings for consistency
                for key, value in parsed.items():
                    if value is not None:
                        result[str(key)] = str(value)

                return result

            except yaml.YAMLError as e:
                # YAML parsing failed - try to fix common issues
                print(f"WARNING: YAML parsing failed: {e}")
                print("  Attempting to fix common YAML issues...")

                # Try fixing common issues
                fixed_yaml = self._fix_common_yaml_issues(yaml_content)

                try:
                    parsed = yaml.safe_load(fixed_yaml)

                    if parsed and isinstance(parsed, dict):
                        # Convert all values to strings
                        for key, value in parsed.items():
                            if value is not None:
                                result[str(key)] = str(value)

                        print("  ✓ Successfully parsed YAML after fixes")
                        return result
                    else:
                        print("  ✗ YAML still invalid after fixes")
                        return result

                except yaml.YAMLError as e2:
                    print(f"  ✗ Still failed after fixes: {e2}")
                    # Fall through to regex fallback
        else:
            # PyYAML not available - use regex fallback
            print("INFO: Using regex fallback for YAML parsing")

        # Regex fallback - simple key: value extraction
        result = self._parse_yaml_with_regex(yaml_content)

        return result

    def _fix_common_yaml_issues(self, yaml_content: str) -> str:
        """Fix common YAML formatting issues.

        Args:
            yaml_content: Raw YAML content

        Returns:
            Fixed YAML content

        Common fixes:
            - Add quotes around values containing colons
            - Add spaces after colons if missing
            - Remove extra trailing whitespace
        """
        lines = yaml_content.split('\n')
        fixed_lines = []

        for line in lines:
            # Skip empty lines and comments
            if not line.strip() or line.strip().startswith('#'):
                fixed_lines.append(line)
                continue

            # Check if line is a key-value pair
            if ':' in line:
                # Split on first colon only
                parts = line.split(':', 1)

                if len(parts) == 2:
                    key = parts[0].strip()
                    value = parts[1].strip()

                    # If value contains a colon and isn't already quoted, quote it
                    if ':' in value and not (
                        (value.startswith('"') and value.endswith('"')) or
                        (value.startswith("'") and value.endswith("'"))
                    ):
                        # Quote the value
                        # Escape any existing quotes in the value
                        value = value.replace('"', '\\"')
                        value = f'"{value}"'

                    # Reconstruct line with proper spacing
                    fixed_line = f"{key}: {value}"
                    fixed_lines.append(fixed_line)
                else:
                    # Keep original line if we can't parse it
                    fixed_lines.append(line)
            else:
                # Not a key-value pair, keep as-is
                fixed_lines.append(line)

        return '\n'.join(fixed_lines)

    def _parse_yaml_with_regex(self, yaml_content: str) -> Dict[str, str]:
        """Parse YAML using regex fallback (when PyYAML unavailable).

        This is a simple parser that handles basic key: value pairs.
        Does not support complex YAML features like lists, nested dicts, etc.

        Args:
            yaml_content: Raw YAML content

        Returns:
            Dictionary of key-value pairs
        """
        result = {}

        lines = yaml_content.split('\n')

        for line in lines:
            # Skip empty lines and comments
            if not line.strip() or line.strip().startswith('#'):
                continue

            # Look for key: value pattern
            match = re.match(r'^([a-zA-Z0-9_-]+)\s*:\s*(.*)$', line.strip())

            if match:
                key = match.group(1).strip()
                value = match.group(2).strip()

                # Remove quotes if present
                if value.startswith('"') and value.endswith('"'):
                    value = value[1:-1]
                elif value.startswith("'") and value.endswith("'"):
                    value = value[1:-1]

                # Unescape quotes
                value = value.replace('\\"', '"').replace("\\'", "'")

                result[key] = value

        return result

    def discover_skills(self) -> List[Path]:
        """Discover all skill directories (non-recursive scan of INPUT_DIR).

        Performs a non-recursive scan of the INPUT_DIR to find all immediate
        subdirectories that represent skill directories. Does not traverse
        into subdirectories.

        Returns:
            List of Path objects representing skill directories.
            Returns empty list if INPUT_DIR doesn't exist or has no subdirectories.

        Notes:
            - Only scans immediate children of INPUT_DIR
            - Excludes directories matching EXCLUDE_DIRS patterns
            - Returns sorted list for consistent processing order
        """
        skills = []

        try:
            # Check if INPUT_DIR exists
            if not INPUT_DIR.exists():
                print(f"WARNING: Input directory not found: {INPUT_DIR}")
                return skills

            if not INPUT_DIR.is_dir():
                print(f"ERROR: Input path is not a directory: {INPUT_DIR}")
                return skills

            # Scan only direct children (non-recursive)
            for item in INPUT_DIR.iterdir():
                # Filter: must be directory, not excluded
                if item.is_dir() and not should_exclude_dir(item.name):
                    skills.append(item)

            # Sort alphabetically for consistent processing
            skills.sort(key=lambda p: p.name.lower())

            # Log results
            print(f"\nDiscovered {len(skills)} skill directories:")
            for skill_path in skills:
                print(f"  - {skill_path.name}")

            if len(skills) == 0:
                print("  (No valid skill directories found)")

        except PermissionError as e:
            print(f"ERROR: Permission denied accessing {INPUT_DIR}: {e}")
        except Exception as e:
            print(f"ERROR: Failed to discover skills in {INPUT_DIR}: {e}")

        return skills

    def discover_files(self, skill_dir: Path) -> Dict[str, Any]:
        """Recursively discover files within a skill directory.

        Scans the skill directory recursively to find all relevant files.
        Categorizes files by type (markdown, code, config) for organized
        processing.

        Args:
            skill_dir: Path to the skill directory to scan.

        Returns:
            Dictionary mapping file categories to lists of file paths:
            - 'skill_md': SKILL.md from root directory (Path or None)
            - 'markdown': List of other .md/.markdown files
            - 'code': List of code files (.py, .js, .sh, etc.)
            - 'config': List of config files (.json, .yaml, .xml)
            - 'other': List of other text files

        Notes:
            - Recursive scan - processes all subdirectories
            - Applies exclusion rules (EXCLUDE_DIRS, EXCLUDE_FILES)
            - Skips binary files automatically
            - Returns sorted lists for consistent ordering
        """
        result = {
            "skill_md": None,
            "markdown": [],
            "code": [],
            "config": [],
            "other": []
        }

        # Check for SKILL.md in root directory
        skill_md_path = skill_dir / "SKILL.md"
        if skill_md_path.exists() and skill_md_path.is_file():
            if not should_exclude_file(skill_md_path):
                result["skill_md"] = skill_md_path

        # Define config extensions (separate from pure code files)
        config_extensions = {'.json', '.yaml', '.yml', '.xml'}

        # Define pure code extensions (excluding config formats)
        code_extensions = {'.py', '.js', '.sh', '.ts', '.jsx', '.tsx'}

        # Recursively walk directory tree
        try:
            for item in skill_dir.rglob('*'):
                # Skip directories
                if item.is_dir():
                    continue

                # Check if any parent directory should be excluded
                skip_file = False
                for parent in item.parents:
                    # Only check parents within the skill_dir
                    if parent == skill_dir:
                        break
                    if parent.is_relative_to(skill_dir):
                        if should_exclude_dir(parent.name):
                            skip_file = True
                            break

                if skip_file:
                    continue

                # Check if file should be excluded
                if should_exclude_file(item):
                    continue

                # Skip SKILL.md from root (already processed)
                if item == skill_md_path:
                    continue

                # Categorize file by extension
                extension = item.suffix.lower()

                if extension in MARKDOWN_EXTENSIONS:
                    result["markdown"].append(item)
                elif extension in config_extensions:
                    result["config"].append(item)
                elif extension in code_extensions:
                    result["code"].append(item)
                else:
                    # Other text files (only if not binary and passes filters)
                    result["other"].append(item)

            # Sort each category alphabetically for consistent ordering
            for key in ["markdown", "code", "config", "other"]:
                result[key].sort(key=lambda p: str(p))

        except PermissionError as e:
            print(f"WARNING: Permission denied accessing {skill_dir}: {e}")
        except Exception as e:
            print(f"ERROR: Failed to scan {skill_dir}: {e}")

        return result

    def categorize_content_files(self, files: Dict[str, Any]) -> Dict[str, List[Path]]:
        """
        Categorize discovered files by purpose for output generation.

        Takes the dictionary from discover_files() and categorizes files
        by their intended purpose in the output documentation.

        Args:
            files: Dictionary from discover_files() with categorized files:
                   - 'skill_md': SKILL.md from root (Path or None)
                   - 'markdown': List of other .md/.markdown files
                   - 'code': List of code files (.py, .js, .sh, etc.)
                   - 'config': List of config files (.json, .yaml, .xml)
                   - 'other': List of other text files

        Returns:
            Dictionary mapping content types to file lists:
            {
                'reference': [Path, ...],  # Reference documentation
                'examples': [Path, ...],    # Example files
                'code': [Path, ...],        # Code to show in blocks
                'themes': [Path, ...]       # Theme files
            }

        Categorization Logic:
            - Files in 'reference/' or 'docs/' directories → Reference
            - Files in 'examples/', 'templates/' directories → Examples
            - Files in 'themes/' directory → Themes (theme showcase files)
            - Files matching 'example*', '*_example.*', 'demo*' patterns → Examples
            - Code files (.py, .js, .sh, .ts, .jsx, .tsx) → Code
            - Config files (.json, .yaml, .yml, .xml) → Code (shown as examples)
            - Other markdown files → Reference (general documentation)
        """
        result = {
            'reference': [],
            'examples': [],
            'code': [],
            'themes': []
        }

        # Collect all files to categorize
        all_files = []

        # Include SKILL.md if it exists (prioritize as reference)
        if files.get('skill_md'):
            all_files.append(files['skill_md'])

        # Add all other file categories
        for category in ['markdown', 'code', 'config', 'other']:
            all_files.extend(files.get(category, []))

        # Categorize each file based on path and naming patterns
        for file_path in all_files:
            # Get path components for directory checking
            path_parts = file_path.parts
            filename = file_path.name.lower()
            extension = file_path.suffix.lower()

            # Priority 1: Check for themes directory
            # Theme files are special - they showcase visual themes
            if 'themes' in path_parts:
                result['themes'].append(file_path)
                print(f"    [THEMES] {file_path.name} (in themes/ directory)")
                continue

            # Priority 2: Check for examples/templates directories
            # These directories explicitly contain example content
            if any(part in ['examples', 'templates', 'demos', 'samples'] for part in path_parts):
                result['examples'].append(file_path)
                print(f"    [EXAMPLES] {file_path.name} (in examples/templates directory)")
                continue

            # Priority 3: Check for reference/docs directories
            # These directories contain reference documentation
            if any(part in ['reference', 'docs', 'documentation'] for part in path_parts):
                result['reference'].append(file_path)
                print(f"    [REFERENCE] {file_path.name} (in reference/docs directory)")
                continue

            # Priority 4: Check filename patterns for examples
            # Files explicitly named as examples or demos
            if (filename.startswith('example') or
                '_example.' in filename or
                '-example.' in filename or
                filename.startswith('demo') or
                '_demo.' in filename or
                '-demo.' in filename or
                filename.startswith('sample') or
                '_sample.' in filename or
                '-sample.' in filename):
                result['examples'].append(file_path)
                print(f"    [EXAMPLES] {file_path.name} (filename pattern match)")
                continue

            # Priority 5: Categorize by file type

            # Pure code files (.py, .js, .sh, etc.) - shown as code blocks
            if extension in ['.py', '.js', '.sh', '.ts', '.jsx', '.tsx']:
                result['code'].append(file_path)
                print(f"    [CODE] {file_path.name} (code file)")
            # Config/data files (.json, .yaml, .xml) - shown as code examples
            elif extension in ['.json', '.yaml', '.yml', '.xml']:
                result['code'].append(file_path)
                print(f"    [CODE] {file_path.name} (config file)")
            # Markdown files default to reference documentation
            elif extension in ['.md', '.markdown']:
                result['reference'].append(file_path)
                print(f"    [REFERENCE] {file_path.name} (markdown file)")
            # Other text files default to reference
            else:
                result['reference'].append(file_path)
                print(f"    [REFERENCE] {file_path.name} (other file)")

        # Print summary
        print(f"\n  Categorization Summary:")
        print(f"    Reference: {len(result['reference'])} files")
        print(f"    Examples: {len(result['examples'])} files")
        print(f"    Code: {len(result['code'])} files")
        print(f"    Themes: {len(result['themes'])} files")

        return result

    def parse_sample_format(self) -> Dict[str, Any]:
        """
        Parse the sample format file to understand output structure.

        Reads algorithmic-art.md to extract:
        - Section patterns and hierarchy
        - Expected section names (Steps, Examples, Usage)
        - YAML front matter structure
        - Overall content organization

        Returns:
            Dictionary with structure information:
            - yaml_fields: List of YAML front matter field names
            - sections: List of all section titles (## headers)
            - step_sections: List of dicts with step info (number, title)
            - has_steps: Boolean indicating if Step sections exist
            - has_examples: Boolean indicating if Examples section exists
            - has_usage: Boolean indicating if Usage section exists
            - step_count: Number of Step sections found
        """
        sample_path = SAMPLE_FORMAT

        # Validate sample file exists
        if not sample_path.exists():
            print(f"WARNING: Sample format file not found: {sample_path}")
            return {
                "yaml_fields": [],
                "sections": [],
                "step_sections": [],
                "has_steps": False,
                "has_examples": False,
                "has_usage": False,
                "step_count": 0
            }

        print(f"\nParsing sample format file: {sample_path.name}")

        # Read sample file
        content = self.read_file_with_retry(sample_path)

        if content is None:
            print(f"ERROR: Failed to read sample format file: {sample_path}")
            return {
                "yaml_fields": [],
                "sections": [],
                "step_sections": [],
                "has_steps": False,
                "has_examples": False,
                "has_usage": False,
                "step_count": 0
            }

        # Extract YAML front matter structure
        print("  Extracting YAML front matter...")
        yaml_data = self.extract_yaml_frontmatter(content)
        yaml_fields = list(yaml_data.keys()) if yaml_data else []
        print(f"    Found {len(yaml_fields)} YAML fields: {', '.join(yaml_fields)}")

        # Find section headers (## headers)
        print("  Analyzing section structure...")
        sections = []
        step_sections = []
        has_examples = False
        has_usage = False

        lines = content.split('\n')
        for line in lines:
            # Match ## headers (level 2 headers)
            if line.startswith('## '):
                section_title = line[3:].strip()
                sections.append(section_title)

                # Check for step sections
                step_match = re.match(r'Step (\d+):', section_title)
                if step_match:
                    step_num = int(step_match.group(1))
                    step_sections.append({
                        "number": step_num,
                        "title": section_title
                    })
                    print(f"    Found: {section_title}")

                # Check for Examples and Usage sections
                if section_title.lower() == 'examples':
                    has_examples = True
                    print(f"    Found: {section_title}")
                elif section_title.lower() == 'usage':
                    has_usage = True
                    print(f"    Found: {section_title}")

        # Build structure info
        structure = {
            "yaml_fields": yaml_fields,
            "sections": sections,
            "step_sections": step_sections,
            "has_steps": len(step_sections) > 0,
            "has_examples": has_examples,
            "has_usage": has_usage,
            "step_count": len(step_sections)
        }

        print(f"\n  Summary:")
        print(f"    Total sections: {len(sections)}")
        print(f"    Step sections: {len(step_sections)}")
        print(f"    Has Examples: {has_examples}")
        print(f"    Has Usage: {has_usage}")

        return structure

    def _convert_skill_name_to_title(self, skill_name: str) -> str:
        """
        Convert a skill name to a human-readable title.

        Handles common acronyms and capitalizes words properly.

        Args:
            skill_name: Skill directory name (e.g., "mcp-builder", "algorithmic-art")

        Returns:
            Human-readable title (e.g., "MCP Builder", "Algorithmic Art")
        """
        # Common acronyms that should be fully capitalized
        acronyms = {
            'mcp': 'MCP',
            'api': 'API',
            'cli': 'CLI',
            'ui': 'UI',
            'ux': 'UX',
            'url': 'URL',
            'html': 'HTML',
            'css': 'CSS',
            'js': 'JS',
            'json': 'JSON',
            'xml': 'XML',
            'sql': 'SQL',
            'rest': 'REST',
            'http': 'HTTP',
            'https': 'HTTPS',
            'ssh': 'SSH',
            'git': 'Git',
            'ai': 'AI',
            'ml': 'ML',
            'llm': 'LLM',
        }

        # Replace separators with spaces
        title = skill_name.replace('-', ' ').replace('_', ' ')

        # Split into words and capitalize each
        words = title.split()
        capitalized_words = []

        for word in words:
            word_lower = word.lower()
            if word_lower in acronyms:
                # Use the acronym form
                capitalized_words.append(acronyms[word_lower])
            else:
                # Regular title case
                capitalized_words.append(word.capitalize())

        return ' '.join(capitalized_words)

    def generate_fallback_metadata(self, skill_name: str, files_dict: Dict[str, Any]) -> Dict[str, str]:
        """
        Generate fallback metadata when SKILL.md is missing or has no YAML.

        Args:
            skill_name: Name of the skill directory
            files_dict: Dictionary from discover_files()

        Returns:
            Dictionary with 'description' and 'argument-hint'
        """
        print(f"    Generating fallback metadata for {skill_name}...")

        # ========================================
        # 1. Convert skill-name to readable title
        # ========================================
        # E.g., "mcp-builder" -> "MCP Builder"
        # E.g., "algorithmic-art" -> "Algorithmic Art"
        title = self._convert_skill_name_to_title(skill_name)

        # ========================================
        # 2. Generate description based on skill name
        # ========================================
        description = f"Tools and utilities for {title}"

        # ========================================
        # 3. Determine argument-hint from file types
        # ========================================
        argument_hint = "<arguments>"  # Default

        # Check for themes directory/files
        has_themes = False
        for category in ['markdown', 'code', 'config', 'other']:
            for file_path in files_dict.get(category, []):
                if 'themes' in file_path.parts:
                    has_themes = True
                    break
            if has_themes:
                break

        if has_themes:
            argument_hint = "<theme-name>"
            print(f"      Detected themes - using argument-hint: {argument_hint}")
        else:
            # Check for code files (suggests file processing)
            has_code = len(files_dict.get('code', [])) > 0
            if has_code:
                argument_hint = "<file-path>"
                print(f"      Detected code files - using argument-hint: {argument_hint}")

        # ========================================
        # 4. Try to extract summary from first available markdown file
        # ========================================
        # Priority: SKILL.md, then other markdown files
        summary = None

        if files_dict.get('skill_md'):
            skill_md_content = self.read_file_with_retry(files_dict['skill_md'])
            if skill_md_content:
                summary = self._extract_first_paragraph_from_markdown(skill_md_content)

        # If no summary from SKILL.md, try other markdown files
        if not summary:
            for md_file in files_dict.get('markdown', []):
                md_content = self.read_file_with_retry(md_file)
                if md_content:
                    summary = self._extract_first_paragraph_from_markdown(md_content)
                    if summary:
                        print(f"      Extracted summary from: {md_file.name}")
                        break

        # Use summary as description if found
        if summary:
            description = summary
            print(f"      Using extracted summary as description")
        else:
            print(f"      Using generated description: {description}")

        # ========================================
        # 5. Build and return metadata dictionary
        # ========================================
        result = {
            'description': description,
            'argument-hint': argument_hint
        }

        print(f"      Generated fallback metadata:")
        print(f"        description: {result['description']}")
        print(f"        argument-hint: {result['argument-hint']}")

        return result

    def _extract_first_paragraph_from_markdown(self, content: str) -> Optional[str]:
        """
        Extract the first substantial paragraph from markdown content.

        Skips YAML front matter and headers to find the first real paragraph.

        Args:
            content: Markdown file content

        Returns:
            First paragraph as a string, or None if not found
        """
        # Remove YAML front matter if present
        content = content.lstrip()
        if content.startswith('---'):
            lines = content.split('\n')
            closing_idx = -1
            for i in range(1, len(lines)):
                if lines[i].strip() == '---':
                    closing_idx = i
                    break

            if closing_idx > 0:
                content = '\n'.join(lines[closing_idx + 1:])

        # Split into lines and find first substantial paragraph
        lines = content.split('\n')

        paragraph_lines = []
        in_paragraph = False

        for line in lines:
            stripped = line.strip()

            # Skip empty lines before we start collecting
            if not in_paragraph and not stripped:
                continue

            # Skip headers
            if stripped.startswith('#'):
                continue

            # If we hit an empty line after starting, we're done
            if in_paragraph and not stripped:
                break

            # If we have a non-empty line, collect it
            if stripped:
                paragraph_lines.append(stripped)
                in_paragraph = True

        if paragraph_lines:
            return ' '.join(paragraph_lines)

        return None

    def generate_output_content(self, skill_name: str, files_dict: Dict[str, Any],
                               categorized: Dict[str, List[Path]],
                               metadata: Dict[str, str]) -> str:
        """
        Generate final output markdown content from categorized files.

        Args:
            skill_name: Name of the skill
            files_dict: Dictionary from discover_files()
            categorized: Dictionary from categorize_content_files()
            metadata: YAML front matter metadata

        Returns:
            Complete markdown content string
        """
        print(f"\n  Generating output content for {skill_name}...")

        # ========================================
        # 0. Use fallback metadata if needed
        # ========================================
        # Check if we need to generate fallback for any missing fields
        needs_fallback = (
            not metadata or
            'description' not in metadata or
            'argument-hint' not in metadata
        )

        if needs_fallback:
            print("    Metadata incomplete - using fallback for missing fields...")
            fallback = self.generate_fallback_metadata(skill_name, files_dict)

            # Merge fallback with existing metadata
            if not metadata:
                metadata = fallback
            else:
                # Only fill in missing fields
                if 'description' not in metadata:
                    metadata['description'] = fallback['description']
                if 'argument-hint' not in metadata:
                    metadata['argument-hint'] = fallback['argument-hint']

        output_lines = []

        # ========================================
        # 1. Build YAML front matter
        # ========================================
        print("    Building YAML front matter...")
        output_lines.append("---")

        # Add description (required - now guaranteed to exist)
        output_lines.append(f"description: {metadata['description']}")

        # Add argument-hint if present
        if "argument-hint" in metadata:
            output_lines.append(f"argument-hint: {metadata['argument-hint']}")

        output_lines.append("---")
        output_lines.append("")  # Blank line after front matter

        # ========================================
        # 2. Extract summary from SKILL.md
        # ========================================
        print("    Extracting summary from SKILL.md...")
        if files_dict.get("skill_md"):
            skill_md_content = self.read_file_with_retry(files_dict["skill_md"])
            if skill_md_content:
                summary = self._extract_summary_from_skill_md(skill_md_content)
                if summary:
                    output_lines.append(summary)
                    output_lines.append("")

        # ========================================
        # 3. Generate Step sections from reference files
        # ========================================
        print("    Generating Step sections from reference files...")
        reference_files = categorized.get('reference', [])

        # Filter out SKILL.md from reference files
        reference_files = [f for f in reference_files if f != files_dict.get("skill_md")]

        if reference_files:
            step_num = 1
            for ref_file in reference_files:
                ref_content = self.read_file_with_retry(ref_file)
                if ref_content:
                    # Generate step section
                    step_section = self._generate_step_section(step_num, ref_file, ref_content)
                    if step_section:
                        output_lines.append(step_section)
                        output_lines.append("")
                        step_num += 1

        # ========================================
        # 4. Generate Examples section
        # ========================================
        print("    Generating Examples section...")
        examples_files = categorized.get('examples', [])
        themes_files = categorized.get('themes', [])

        if examples_files or themes_files:
            output_lines.append("## Examples")
            output_lines.append("")

            # Add examples
            for example_file in examples_files:
                example_content = self.read_file_with_retry(example_file)
                if example_content:
                    example_section = self._generate_example_section(example_file, example_content)
                    if example_section:
                        output_lines.append(example_section)
                        output_lines.append("")

            # Add themes
            for theme_file in themes_files:
                theme_content = self.read_file_with_retry(theme_file)
                if theme_content:
                    theme_section = self._generate_theme_section(theme_file, theme_content)
                    if theme_section:
                        output_lines.append(theme_section)
                        output_lines.append("")

        # ========================================
        # 5. Generate code blocks from code files
        # ========================================
        print("    Generating code blocks from code files...")
        code_files = categorized.get('code', [])

        if code_files:
            # Add code files as a section if there are standalone code files
            # that weren't already included in steps or examples
            for code_file in code_files:
                code_content = self.read_file_with_retry(code_file)
                if code_content:
                    code_block = self._generate_code_block(code_file, code_content)
                    if code_block:
                        output_lines.append(code_block)
                        output_lines.append("")

        # ========================================
        # 6. Add Usage section
        # ========================================
        print("    Adding Usage section...")
        usage_section = self._generate_usage_section(skill_name, metadata)
        output_lines.append(usage_section)
        output_lines.append("")

        # ========================================
        # 7. Join and return
        # ========================================
        result = "\n".join(output_lines)
        print(f"    Generated {len(result)} characters of content")

        return result

    def _extract_summary_from_skill_md(self, content: str) -> Optional[str]:
        """
        Extract the summary paragraph from SKILL.md.

        The summary is the first substantial paragraph after the YAML front matter
        and any headers.

        Args:
            content: Content of SKILL.md

        Returns:
            Summary paragraph as a string, or None if not found
        """
        # Reuse the generic paragraph extraction method
        return self._extract_first_paragraph_from_markdown(content)

    def _generate_step_section(self, step_num: int, file_path: Path, content: str) -> Optional[str]:
        """
        Generate a Step section from a reference file.

        Args:
            step_num: Step number (1, 2, 3, ...)
            file_path: Path to the reference file
            content: Content of the reference file

        Returns:
            Step section as markdown string
        """
        # Generate step title from filename
        filename = file_path.stem  # Get filename without extension

        # Convert filename to title (e.g., "mcp_best_practices" -> "MCP Best Practices")
        title = filename.replace('_', ' ').replace('-', ' ').title()

        # Build step header
        step_header = f"## Step {step_num}: {title}"

        # Remove any YAML front matter from content
        content = content.lstrip()
        if content.startswith('---'):
            lines = content.split('\n')
            closing_idx = -1
            for i in range(1, len(lines)):
                if lines[i].strip() == '---':
                    closing_idx = i
                    break

            if closing_idx > 0:
                content = '\n'.join(lines[closing_idx + 1:]).lstrip()

        # Remove the first # header if it exists (since we're adding our own header)
        lines = content.split('\n')
        if lines and lines[0].strip().startswith('# '):
            content = '\n'.join(lines[1:]).lstrip()

        return f"{step_header}\n\n{content}"

    def _generate_example_section(self, file_path: Path, content: str) -> Optional[str]:
        """
        Generate an example subsection from an example file.

        Args:
            file_path: Path to the example file
            content: Content of the example file

        Returns:
            Example subsection as markdown string
        """
        # For markdown files, include the content directly
        if file_path.suffix.lower() in MARKDOWN_EXTENSIONS:
            # Remove any YAML front matter
            content = content.lstrip()
            if content.startswith('---'):
                lines = content.split('\n')
                closing_idx = -1
                for i in range(1, len(lines)):
                    if lines[i].strip() == '---':
                        closing_idx = i
                        break

                if closing_idx > 0:
                    content = '\n'.join(lines[closing_idx + 1:]).lstrip()

            return content

        # For code files, show as code block
        filename = file_path.name
        language = get_language_hint(file_path)

        return f"**{filename}:**\n\n```{language}\n{content}\n```"

    def _generate_theme_section(self, file_path: Path, content: str) -> Optional[str]:
        """
        Generate a theme subsection from a theme file.

        Args:
            file_path: Path to the theme file
            content: Content of the theme file

        Returns:
            Theme subsection as markdown string
        """
        # Themes are typically markdown files with theme specifications
        # Remove any YAML front matter
        content = content.lstrip()
        if content.startswith('---'):
            lines = content.split('\n')
            closing_idx = -1
            for i in range(1, len(lines)):
                if lines[i].strip() == '---':
                    closing_idx = i
                    break

            if closing_idx > 0:
                content = '\n'.join(lines[closing_idx + 1:]).lstrip()

        return content

    def _generate_code_block(self, file_path: Path, content: str) -> Optional[str]:
        """
        Generate a code block from a code file.

        Args:
            file_path: Path to the code file
            content: Content of the code file

        Returns:
            Code block as markdown string with proper syntax highlighting
        """
        filename = file_path.name
        language = get_language_hint(file_path)

        # Get relative path from skill directory for context
        # (helps identify the purpose of the code file)

        return f"**{filename}:**\n\n```{language}\n{content}\n```"

    def _generate_usage_section(self, skill_name: str, metadata: Dict[str, str]) -> str:
        """
        Generate the Usage section for the command.

        Args:
            skill_name: Name of the skill
            metadata: YAML front matter metadata

        Returns:
            Usage section as markdown string
        """
        lines = []
        lines.append("## Usage")
        lines.append("")

        # Get argument hint if available
        arg_hint = metadata.get('argument-hint', '[arguments]')

        # Basic usage
        lines.append(f"**Basic usage:** `/{skill_name} {arg_hint}`")

        return '\n'.join(lines)

    def generate_output_filename(self, skill_name: str) -> str:
        """
        Generate safe output filename from skill name.

        Converts skill directory name to kebab-case and sanitizes for
        safe filesystem usage. Handles edge cases like empty names,
        special characters, and ensures .md extension.

        Args:
            skill_name: Name of skill directory (e.g., "MCP Builder", "algorithmic_art")

        Returns:
            Sanitized filename with .md extension (e.g., "mcp-builder.md", "algorithmic-art.md")

        Examples:
            "MCP Builder" -> "mcp-builder.md"
            "algorithmic_art" -> "algorithmic-art.md"
            "My Cool  Skill!!!" -> "my-cool-skill.md"
            "___test___" -> "test.md"
            "" -> "unnamed-skill.md"
            "123" -> "123.md"
        """
        # Handle empty or whitespace-only names
        if not skill_name or not skill_name.strip():
            return "unnamed-skill.md"

        # Remove .md extension if present (since we'll add it at the end)
        filename = skill_name
        if filename.lower().endswith('.md'):
            filename = filename[:-3]

        # Convert to lowercase
        filename = filename.lower()

        # Replace spaces, underscores, and dots with hyphens
        filename = filename.replace(' ', '-').replace('_', '-').replace('.', '-')

        # Remove special characters - keep only alphanumeric and hyphens
        # This regex keeps: a-z, 0-9, and hyphens
        filename = re.sub(r'[^a-z0-9-]', '', filename)

        # Replace multiple consecutive hyphens with a single hyphen
        filename = re.sub(r'-+', '-', filename)

        # Remove leading and trailing hyphens
        filename = filename.strip('-')

        # If after sanitization we have nothing left, use default name
        if not filename:
            return "unnamed-skill.md"

        # Ensure .md extension
        if not filename.endswith('.md'):
            filename = f"{filename}.md"

        return filename

    def check_naming_conflict(self, filename: str, output_dir: Path) -> str:
        """
        Check for naming conflicts and resolve with numeric suffixes.

        If a file with the given name already exists in the output directory,
        appends a numeric suffix (-2, -3, etc.) until an available name is found.

        Args:
            filename: Proposed filename (e.g., "mcp-builder.md")
            output_dir: Output directory path to check for conflicts

        Returns:
            Final filename (possibly with -2, -3 suffix if conflict existed)

        Examples:
            If "mcp-builder.md" exists:
                "mcp-builder.md" -> "mcp-builder-2.md"
            If "mcp-builder.md" and "mcp-builder-2.md" exist:
                "mcp-builder.md" -> "mcp-builder-3.md"

        Notes:
            - Only checks for conflicts, doesn't create files
            - Always returns a safe, available filename
            - Handles files with and without .md extension
        """
        # Ensure output directory exists for checking
        if not output_dir.exists():
            # If directory doesn't exist, no conflicts possible
            return filename

        # Split filename into base and extension
        if filename.endswith('.md'):
            base_name = filename[:-3]  # Remove .md
            extension = '.md'
        else:
            base_name = filename
            extension = ''

        # Check if original filename is available
        candidate_path = output_dir / filename
        if not candidate_path.exists():
            return filename

        # Original name is taken, try with numeric suffixes
        counter = 2
        max_attempts = 1000  # Safety limit to prevent infinite loops

        while counter <= max_attempts:
            # Build candidate filename with suffix
            candidate_filename = f"{base_name}-{counter}{extension}"
            candidate_path = output_dir / candidate_filename

            # Check if this name is available
            if not candidate_path.exists():
                print(f"    Naming conflict resolved: {filename} -> {candidate_filename}")
                return candidate_filename

            counter += 1

        # If we somehow exhausted all attempts (very unlikely),
        # return a timestamp-based name as last resort
        import time
        timestamp = int(time.time())
        fallback_filename = f"{base_name}-{timestamp}{extension}"
        print(f"    WARNING: Exhausted numeric suffixes, using timestamp: {fallback_filename}")
        return fallback_filename

    def ensure_output_directory(self) -> bool:
        """
        Ensure output directory exists and is writable.

        Creates OUTPUT_DIR if it doesn't exist, verifies write permissions.
        Handles errors gracefully for permissions, disk space, etc.

        Returns:
            True if directory is ready (exists and writable), False if failed

        Error Handling:
            - PermissionError: Logs error and returns False
            - OSError: Logs error (disk space, I/O issues) and returns False
            - Other exceptions: Logs unexpected errors and returns False

        Notes:
            - Creates parent directories if needed (parents=True)
            - Verifies the path is actually a directory
            - Tests write permissions by checking directory stats
        """
        try:
            # Check if OUTPUT_DIR already exists
            if OUTPUT_DIR.exists():
                print(f"  Output directory exists: {OUTPUT_DIR}")

                # Verify it's actually a directory (not a file)
                if not OUTPUT_DIR.is_dir():
                    print(f"  ERROR: Output path exists but is not a directory: {OUTPUT_DIR}")
                    return False

                # Check write permissions by trying to get stats
                # On Unix systems, we can check os.access
                if not os.access(OUTPUT_DIR, os.W_OK):
                    print(f"  ERROR: Output directory is not writable: {OUTPUT_DIR}")
                    return False

                print(f"  ✓ Output directory is writable")
                return True

            # Directory doesn't exist - create it
            print(f"  Creating output directory: {OUTPUT_DIR}")
            OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

            # Verify creation succeeded
            if not OUTPUT_DIR.exists():
                print(f"  ERROR: Failed to create output directory: {OUTPUT_DIR}")
                return False

            # Verify write permissions on newly created directory
            if not os.access(OUTPUT_DIR, os.W_OK):
                print(f"  ERROR: Created directory is not writable: {OUTPUT_DIR}")
                return False

            print(f"  ✓ Successfully created output directory: {OUTPUT_DIR}")
            return True

        except PermissionError as e:
            print(f"  ERROR: Permission denied creating output directory: {e}")
            return False

        except OSError as e:
            # Handles disk space, I/O errors, etc.
            print(f"  ERROR: OS error creating output directory: {e}")
            return False

        except Exception as e:
            # Catch any unexpected errors
            print(f"  ERROR: Unexpected error with output directory: {e}")
            return False

    def write_output_file(self, filename: str, content: str) -> bool:
        """
        Write content to output file in OUTPUT_DIR.

        Creates the output directory if needed, writes content with UTF-8 encoding,
        and handles all errors gracefully.

        Args:
            filename: Name of the output file (e.g., "mcp-builder.md")
            content: Markdown content to write

        Returns:
            True if file was written successfully, False if failed

        Error Handling:
            - Directory creation failures: Returns False
            - PermissionError: Logs and returns False
            - IOError/OSError: Logs and returns False (disk full, etc.)
            - UnicodeEncodeError: Logs and returns False
            - Other exceptions: Logs and returns False

        Notes:
            - Automatically calls ensure_output_directory()
            - Uses UTF-8 encoding for all output files
            - Tracks and logs overwrites vs new file creation
            - Logs file size after successful write
            - Can be wrapped with retry logic in error handling layer
        """
        # Ensure output directory exists and is writable
        print(f"\n  Writing output file: {filename}")
        print(f"    Checking output directory...")

        if not self.ensure_output_directory():
            print(f"    ERROR: Cannot write file - output directory not available")
            return False

        # Build full output path
        output_path = OUTPUT_DIR / filename

        # Check if file already exists (for overwrite tracking)
        file_existed = output_path.exists()

        def _attempt_write():
            """Internal function to attempt file write."""
            print(f"    Writing content to: {output_path}")
            with open(output_path, 'w', encoding='utf-8') as f:
                f.write(content)

            # Verify file was written
            if not output_path.exists():
                raise IOError(f"File was not created: {output_path}")

            return output_path.stat().st_size

        # Try to write the file with retry logic
        try:
            file_size = retry_operation(
                _attempt_write,
                operation_name=f"write {filename}",
                max_retries=MAX_RETRIES,
                delay=RETRY_WAIT_TIME
            )

            if file_size == 0:
                print(f"    WARNING: File was created but is empty: {output_path}")
                # Don't return False here - empty files might be valid in some cases

            # Log success with overwrite status
            if file_existed:
                print(f"    ✓ Overwritten: {filename} ({file_size} bytes)")
            else:
                print(f"    ✓ Created: {filename} ({file_size} bytes)")

            return True

        except PermissionError as e:
            print(f"    ERROR: Permission denied writing file {filename}: {e}")
            return False

        except OSError as e:
            # Handles disk full, I/O errors, etc.
            print(f"    ERROR: OS error writing file {filename}: {e}")
            return False

        except UnicodeEncodeError as e:
            print(f"    ERROR: Unicode encoding error writing file {filename}: {e}")
            return False

        except Exception as e:
            # Catch any unexpected errors (including retry exhaustion)
            print(f"    ERROR: Failed to write file {filename}: {e}")
            return False

    def _process_with_subdirs(self, skill_dir: Path, skill_name: str) -> ProcessingResult:
        """Process skill with DIRECTORY_WITH_SUBDIRS mode.

        For skills that contain subdirectories to preserve (e.g., docx with scripts/, ooxml/).

        Processing steps:
        1. Find all markdown files in skill directory
        2. Merge markdown files using MarkdownMerger
        3. Preserve subdirectories using SubdirectoryPreserver
        4. Write merged markdown to /commands/{skill}.md
        5. Track statistics in ProcessingResult

        Args:
            skill_dir: Path to skill directory
            skill_name: Name of the skill

        Returns:
            ProcessingResult with transformation statistics
        """
        errors = []
        notes = []
        files_processed = []

        print(f"\n{'=' * 60}")
        print(f"Processing skill: {skill_name} (DIRECTORY_WITH_SUBDIRS mode)")
        print(f"{'=' * 60}")

        try:
            # Step 1: Find all markdown files
            print(f"\n[1/4] Finding markdown files...")
            md_files = []
            skill_md = None

            for item in skill_dir.iterdir():
                if item.is_file() and item.suffix.lower() == '.md':
                    if item.name.upper() == 'SKILL.MD':
                        skill_md = item
                    else:
                        md_files.append(item)

            print(f"  ✓ Found primary: {skill_md.name if skill_md else 'None'}")
            print(f"  ✓ Found {len(md_files)} secondary markdown files")

            # Step 2: Merge markdown files
            print(f"\n[2/4] Merging markdown files...")
            merged_content = self.markdown_merger.merge_markdown_files(skill_md, md_files)

            if not merged_content or len(merged_content.strip()) == 0:
                error_msg = "Generated empty merged content"
                errors.append(error_msg)
                print(f"  ERROR: {error_msg}")
            else:
                markdown_count = (1 if skill_md else 0) + len(md_files)
                print(f"  ✓ Merged {markdown_count} markdown files ({len(merged_content)} characters)")

            # Track processed files
            if skill_md:
                try:
                    files_processed.append(str(skill_md.relative_to(INPUT_DIR)))
                except ValueError:
                    # File not under INPUT_DIR (e.g., in tests), use relative to skill_dir
                    files_processed.append(str(skill_md.relative_to(skill_dir)))
            for md_file in md_files:
                try:
                    files_processed.append(str(md_file.relative_to(INPUT_DIR)))
                except ValueError:
                    files_processed.append(str(md_file.relative_to(skill_dir)))

            # Step 3: Preserve subdirectories
            print(f"\n[3/4] Preserving subdirectories...")

            # Find all subdirectories (excluding special dirs)
            subdirs = []
            for item in skill_dir.iterdir():
                if item.is_dir() and item.name not in MODE_DETECTION_EXCLUDE_DIRS:
                    subdirs.append(item.name)

            if subdirs:
                # Create destination directory: /commands/{skill}/
                dest_dir = OUTPUT_DIR / skill_name
                dest_dir.mkdir(parents=True, exist_ok=True)

                # Copy subdirectories
                stats = self.subdirectory_preserver.copy_subdirectories(
                    skill_dir, dest_dir, subdirs
                )

                print(f"  ✓ Copied {stats['copied_dirs']} directories, {stats['copied_files']} files")

                if stats['excluded_files'] > 0:
                    print(f"  ✓ Excluded {stats['excluded_files']} files")

                if stats['errors']:
                    errors.extend(stats['errors'])
                    print(f"  WARNING: {len(stats['errors'])} errors during copying")
            else:
                stats = {'copied_dirs': 0, 'copied_files': 0, 'excluded_files': 0, 'errors': []}
                print(f"  ✓ No subdirectories to preserve")

            # Step 4: Write output markdown
            print(f"\n[4/4] Writing output markdown...")
            output_filename = self.generate_output_filename(skill_name)
            final_filename = self.check_naming_conflict(output_filename, OUTPUT_DIR)

            if output_filename != final_filename:
                notes.append(f"Naming conflict resolved: {output_filename} → {final_filename}")
                print(f"  ! Conflict resolved: {output_filename} → {final_filename}")

            write_success = self.write_output_file(final_filename, merged_content)

            if not write_success:
                error_msg = f"Failed to write output file: {final_filename}"
                errors.append(error_msg)
                print(f"  ERROR: {error_msg}")
                status = "FAILED"
            else:
                status = "SUCCESS" if not errors else "PARTIAL_SUCCESS"
                print(f"\n✓ Status: {status}")
                print(f"  Output: {final_filename}")
                if subdirs:
                    print(f"  Assets: /commands/{skill_name}/")

            return ProcessingResult(
                skill_name=skill_name,
                status=status,
                output_file=final_filename if write_success else None,
                files_processed=files_processed,
                errors=errors,
                notes=notes,
                retry_count=0,
                transformation_mode="DIRECTORY_WITH_SUBDIRS",
                markdown_files_merged=(1 if skill_md else 0) + len(md_files),
                subdirectories_copied=stats['copied_dirs'],
                scripts_relocated=0,
                path_updates_count=0,
                path_update_details=[]
            )

        except Exception as e:
            error_msg = f"Unexpected error in _process_with_subdirs: {e}"
            errors.append(error_msg)
            print(f"\n  FATAL ERROR: {error_msg}")

            return ProcessingResult(
                skill_name=skill_name,
                status="FAILED",
                output_file=None,
                files_processed=files_processed,
                errors=errors,
                notes=notes,
                retry_count=0,
                transformation_mode="DIRECTORY_WITH_SUBDIRS"
            )

    def _process_with_scripts(self, skill_dir: Path, skill_name: str) -> ProcessingResult:
        """Process skill with DIRECTORY_WITH_SCRIPTS mode.

        For skills that contain root-level executable scripts (e.g., root-cause-tracing).

        Processing steps:
        1. Find all markdown files and scripts in skill directory
        2. Merge markdown files using MarkdownMerger
        3. Relocate scripts to /commands/{skill}/ using PathUpdater
        4. Update script paths in markdown using PathUpdater
        5. Write merged markdown to /commands/{skill}.md
        6. Track statistics in ProcessingResult

        Args:
            skill_dir: Path to skill directory
            skill_name: Name of the skill

        Returns:
            ProcessingResult with transformation statistics
        """
        errors = []
        notes = []
        files_processed = []

        print(f"\n{'=' * 60}")
        print(f"Processing skill: {skill_name} (DIRECTORY_WITH_SCRIPTS mode)")
        print(f"{'=' * 60}")

        try:
            # Step 1: Find all markdown files and scripts
            print(f"\n[1/5] Finding markdown files and scripts...")
            md_files = []
            skill_md = None
            script_files = []

            for item in skill_dir.iterdir():
                if item.is_file():
                    if item.suffix.lower() == '.md':
                        if item.name.upper() == 'SKILL.MD':
                            skill_md = item
                        else:
                            md_files.append(item)
                    elif item.suffix.lower() in SCRIPT_EXTENSIONS:
                        script_files.append(item)

            print(f"  ✓ Found primary: {skill_md.name if skill_md else 'None'}")
            print(f"  ✓ Found {len(md_files)} secondary markdown files")
            print(f"  ✓ Found {len(script_files)} script files")

            # Step 2: Merge markdown files
            print(f"\n[2/5] Merging markdown files...")
            merged_content = self.markdown_merger.merge_markdown_files(skill_md, md_files)

            if not merged_content or len(merged_content.strip()) == 0:
                error_msg = "Generated empty merged content"
                errors.append(error_msg)
                print(f"  ERROR: {error_msg}")
            else:
                markdown_count = (1 if skill_md else 0) + len(md_files)
                print(f"  ✓ Merged {markdown_count} markdown files ({len(merged_content)} characters)")

            # Track processed files
            if skill_md:
                try:
                    files_processed.append(str(skill_md.relative_to(INPUT_DIR)))
                except ValueError:
                    # File not under INPUT_DIR (e.g., in tests), use relative to skill_dir
                    files_processed.append(str(skill_md.relative_to(skill_dir)))
            for md_file in md_files:
                try:
                    files_processed.append(str(md_file.relative_to(INPUT_DIR)))
                except ValueError:
                    files_processed.append(str(md_file.relative_to(skill_dir)))

            # Step 3: Relocate scripts
            print(f"\n[3/5] Relocating scripts...")

            if script_files:
                # Relocate scripts to OUTPUT_DIR/{skill_name}/
                # Note: relocate_scripts creates the skill subdirectory
                reloc_stats = self.path_updater.relocate_scripts(
                    skill_dir, OUTPUT_DIR, skill_name, script_files
                )

                print(f"  ✓ Relocated {reloc_stats['relocated_count']} scripts")

                if reloc_stats['errors']:
                    errors.extend(reloc_stats['errors'])
                    print(f"  WARNING: {len(reloc_stats['errors'])} errors during relocation")

                for script in script_files:
                    try:
                        files_processed.append(str(script.relative_to(INPUT_DIR)))
                    except ValueError:
                        files_processed.append(str(script.relative_to(skill_dir)))
            else:
                reloc_stats = {'relocated_count': 0, 'errors': []}
                print(f"  ✓ No scripts to relocate")

            # Step 4: Update paths in markdown
            print(f"\n[4/5] Updating script paths in markdown...")

            if script_files and merged_content:
                script_names = [script.name for script in script_files]
                updated_content, update_count = self.path_updater.update_paths_in_markdown(
                    merged_content, skill_name, script_names
                )

                if update_count > 0:
                    merged_content = updated_content
                    print(f"  ✓ Updated {update_count} path references")
                    notes.append(f"Updated {update_count} script path references")
                else:
                    print(f"  ✓ No path updates needed")

                path_update_count = update_count
            else:
                path_update_count = 0
                print(f"  ✓ No path updates needed")

            # Step 5: Write output markdown
            print(f"\n[5/5] Writing output markdown...")
            output_filename = self.generate_output_filename(skill_name)
            final_filename = self.check_naming_conflict(output_filename, OUTPUT_DIR)

            if output_filename != final_filename:
                notes.append(f"Naming conflict resolved: {output_filename} → {final_filename}")
                print(f"  ! Conflict resolved: {output_filename} → {final_filename}")

            write_success = self.write_output_file(final_filename, merged_content)

            if not write_success:
                error_msg = f"Failed to write output file: {final_filename}"
                errors.append(error_msg)
                print(f"  ERROR: {error_msg}")
                status = "FAILED"
            else:
                status = "SUCCESS" if not errors else "PARTIAL_SUCCESS"
                print(f"\n✓ Status: {status}")
                print(f"  Output: {final_filename}")
                if script_files:
                    print(f"  Scripts: /commands/{skill_name}/")

            return ProcessingResult(
                skill_name=skill_name,
                status=status,
                output_file=final_filename if write_success else None,
                files_processed=files_processed,
                errors=errors,
                notes=notes,
                retry_count=0,
                transformation_mode="DIRECTORY_WITH_SCRIPTS",
                markdown_files_merged=(1 if skill_md else 0) + len(md_files),
                subdirectories_copied=0,
                scripts_relocated=reloc_stats['relocated_count'],
                path_updates_count=path_update_count,
                path_update_details=[]
            )

        except Exception as e:
            error_msg = f"Unexpected error in _process_with_scripts: {e}"
            errors.append(error_msg)
            print(f"\n  FATAL ERROR: {error_msg}")

            return ProcessingResult(
                skill_name=skill_name,
                status="FAILED",
                output_file=None,
                files_processed=files_processed,
                errors=errors,
                notes=notes,
                retry_count=0,
                transformation_mode="DIRECTORY_WITH_SCRIPTS"
            )

    def _process_single_file(self, skill_dir: Path, skill_name: str) -> ProcessingResult:
        """Process skill with SINGLE_FILE mode.

        For simple skills with only markdown files (e.g., brainstorming, algorithmic-art).

        Processing steps:
        1. Find all markdown files in skill directory
        2. Merge markdown files using MarkdownMerger (if multiple present)
        3. Write merged markdown to /commands/{skill}.md
        4. Track statistics in ProcessingResult

        Args:
            skill_dir: Path to skill directory
            skill_name: Name of the skill

        Returns:
            ProcessingResult with transformation statistics
        """
        errors = []
        notes = []
        files_processed = []

        print(f"\n{'=' * 60}")
        print(f"Processing skill: {skill_name} (SINGLE_FILE mode)")
        print(f"{'=' * 60}")

        try:
            # Step 1: Find all markdown files
            print(f"\n[1/3] Finding markdown files...")
            md_files = []
            skill_md = None

            for item in skill_dir.iterdir():
                if item.is_file() and item.suffix.lower() == '.md':
                    if item.name.upper() == 'SKILL.MD':
                        skill_md = item
                    else:
                        md_files.append(item)

            print(f"  ✓ Found primary: {skill_md.name if skill_md else 'None'}")
            print(f"  ✓ Found {len(md_files)} secondary markdown files")

            # Step 2: Merge markdown files
            print(f"\n[2/3] Merging markdown files...")
            merged_content = self.markdown_merger.merge_markdown_files(skill_md, md_files)

            if not merged_content or len(merged_content.strip()) == 0:
                error_msg = "Generated empty merged content"
                errors.append(error_msg)
                print(f"  ERROR: {error_msg}")
            else:
                markdown_count = (1 if skill_md else 0) + len(md_files)
                print(f"  ✓ Merged {markdown_count} markdown files ({len(merged_content)} characters)")

            # Track processed files
            if skill_md:
                try:
                    files_processed.append(str(skill_md.relative_to(INPUT_DIR)))
                except ValueError:
                    # File not under INPUT_DIR (e.g., in tests), use relative to skill_dir
                    files_processed.append(str(skill_md.relative_to(skill_dir)))
            for md_file in md_files:
                try:
                    files_processed.append(str(md_file.relative_to(INPUT_DIR)))
                except ValueError:
                    files_processed.append(str(md_file.relative_to(skill_dir)))

            # Step 3: Write output markdown
            print(f"\n[3/3] Writing output markdown...")
            output_filename = self.generate_output_filename(skill_name)
            final_filename = self.check_naming_conflict(output_filename, OUTPUT_DIR)

            if output_filename != final_filename:
                notes.append(f"Naming conflict resolved: {output_filename} → {final_filename}")
                print(f"  ! Conflict resolved: {output_filename} → {final_filename}")

            write_success = self.write_output_file(final_filename, merged_content)

            if not write_success:
                error_msg = f"Failed to write output file: {final_filename}"
                errors.append(error_msg)
                print(f"  ERROR: {error_msg}")
                status = "FAILED"
            else:
                status = "SUCCESS" if not errors else "PARTIAL_SUCCESS"
                print(f"\n✓ Status: {status}")
                print(f"  Output: {final_filename}")

            return ProcessingResult(
                skill_name=skill_name,
                status=status,
                output_file=final_filename if write_success else None,
                files_processed=files_processed,
                errors=errors,
                notes=notes,
                retry_count=0,
                transformation_mode="SINGLE_FILE",
                markdown_files_merged=(1 if skill_md else 0) + len(md_files),
                subdirectories_copied=0,
                scripts_relocated=0,
                path_updates_count=0,
                path_update_details=[]
            )

        except Exception as e:
            error_msg = f"Unexpected error in _process_single_file: {e}"
            errors.append(error_msg)
            print(f"\n  FATAL ERROR: {error_msg}")

            return ProcessingResult(
                skill_name=skill_name,
                status="FAILED",
                output_file=None,
                files_processed=files_processed,
                errors=errors,
                notes=notes,
                retry_count=0,
                transformation_mode="SINGLE_FILE"
            )

    def process_skill(self, skill_dir: Path) -> ProcessingResult:
        """Process a single skill directory using v2.0 transformation modes.

        This is the main entry point for skill processing. It detects the
        appropriate transformation mode and routes to specialized processors:

        1. DIRECTORY_WITH_SUBDIRS: Skills with subdirectories (e.g., docx)
        2. DIRECTORY_WITH_SCRIPTS: Skills with root-level scripts (e.g., root-cause-tracing)
        3. SINGLE_FILE: Simple markdown-only skills (e.g., brainstorming)

        Args:
            skill_dir: Path to the skill directory to process.

        Returns:
            ProcessingResult object with status, output file path,
            files processed, errors, notes, and transformation statistics.

        Error Handling:
            - Catches all exceptions to prevent one skill from breaking batch
            - Records errors in ProcessingResult.errors list
            - Returns FAILED status if critical errors occur
            - Falls back to SINGLE_FILE mode if detection is ambiguous

        Notes:
            - Uses ModeDetector to determine transformation mode
            - Routes to specialized _process_* methods
            - Maintains backward compatibility via fallback
        """
        skill_name = skill_dir.name
        errors = []
        notes = []

        print(f"\n{'=' * 60}")
        print(f"Processing skill: {skill_name}")
        print(f"{'=' * 60}")

        try:
            # Step 1: Detect transformation mode (subtask 5.3)
            print(f"\n[Mode Detection] Analyzing directory structure...")
            mode = self.mode_detector.detect_mode(skill_dir)

            print(f"  ✓ Detected mode: {mode.value}")
            notes.append(f"Transformation mode: {mode.value}")

            # Step 2: Route to appropriate processing method (subtasks 5.7, 5.8, 5.9)
            if mode == TransformationMode.DIRECTORY_WITH_SUBDIRS:
                print(f"  → Routing to DIRECTORY_WITH_SUBDIRS processor")
                return self._process_with_subdirs(skill_dir, skill_name)

            elif mode == TransformationMode.DIRECTORY_WITH_SCRIPTS:
                print(f"  → Routing to DIRECTORY_WITH_SCRIPTS processor")
                return self._process_with_scripts(skill_dir, skill_name)

            else:  # SINGLE_FILE mode (includes fallback)
                print(f"  → Routing to SINGLE_FILE processor")
                return self._process_single_file(skill_dir, skill_name)

        except Exception as e:
            # Fallback behavior (subtask 5.9): If mode detection fails, default to SINGLE_FILE
            error_msg = f"Mode detection failed for {skill_name}: {e}"
            print(f"\n  WARNING: {error_msg}")
            print(f"  → Falling back to SINGLE_FILE mode")

            notes.append("Mode detection failed - using SINGLE_FILE fallback")
            errors.append(error_msg)

            # Attempt to process with SINGLE_FILE mode as fallback
            try:
                result = self._process_single_file(skill_dir, skill_name)
                # Add fallback notes to result
                result.notes.extend(notes)
                result.errors.extend(errors)
                return result
            except Exception as fallback_error:
                # If even fallback fails, return FAILED status
                return ProcessingResult(
                    skill_name=skill_name,
                    status="FAILED",
                    output_file=None,
                    files_processed=[],
                    errors=errors + [f"Fallback processing failed: {fallback_error}"],
                    notes=notes,
                    retry_count=0,
                    transformation_mode="SINGLE_FILE"
                )

    def process_skill_legacy(self, skill_dir: Path) -> ProcessingResult:
        """Legacy processing method (pre-v2.0).

        This method contains the original v1.0 processing logic and is kept
        for reference and potential fallback scenarios. New code should use
        process_skill() which routes to specialized v2.0 processors.

        Complete processing pipeline for one skill:
        1. Discover all files in the skill directory
        2. Read and parse file contents
        3. Generate command markdown using template
        4. Write output file
        5. Return processing result with status and metadata

        Args:
            skill_dir: Path to the skill directory to process.

        Returns:
            ProcessingResult object with status, output file path,
            files processed, errors, and notes.

        Error Handling:
            - Catches all exceptions to prevent one skill from breaking batch
            - Records errors in ProcessingResult.errors list
            - Returns FAILED status if critical errors occur
            - Returns PARTIAL_SUCCESS if some files couldn't be processed

        Notes:
            - Implements retry logic for transient failures
            - Creates output directory if it doesn't exist
            - Uses SKELETON_TEMPLATE for output format
        """
        skill_name = skill_dir.name
        files_processed = []
        errors = []
        notes = []
        retry_count = 0

        print(f"\n{'=' * 60}")
        print(f"Processing skill: {skill_name} (LEGACY MODE)")
        print(f"{'=' * 60}")

        try:
            # Step 1: Discover all files in the skill directory
            print(f"\n[1/6] Discovering files in {skill_name}...")
            files_dict = self.discover_files(skill_dir)

            if not files_dict:
                error_msg = f"No files discovered in {skill_name}"
                errors.append(error_msg)
                print(f"  ERROR: {error_msg}")
                return ProcessingResult(
                    skill_name=skill_name,
                    status="FAILED",
                    output_file=None,
                    files_processed=[],
                    errors=errors,
                    notes=notes,
                    retry_count=0
                )

            # Count total files discovered
            total_files = (
                (1 if files_dict.get('skill_md') else 0) +
                len(files_dict.get('markdown', [])) +
                len(files_dict.get('code', [])) +
                len(files_dict.get('config', [])) +
                len(files_dict.get('other', []))
            )
            print(f"  ✓ Discovered {total_files} files")

            # Step 2: Extract metadata from SKILL.md (if present)
            print(f"\n[2/6] Extracting metadata...")
            metadata = {}

            if files_dict.get('skill_md'):
                skill_md_path = files_dict['skill_md']
                content = self.read_file_with_retry(skill_md_path)

                if content:
                    metadata = self.extract_yaml_frontmatter(content)
                    files_processed.append(str(skill_md_path.relative_to(INPUT_DIR)))
                    print(f"  ✓ Extracted metadata from SKILL.md")
                    if metadata:
                        print(f"    - Description: {metadata.get('description', 'N/A')[:60]}...")
                        if metadata.get('argument-hint'):
                            print(f"    - Argument hint: {metadata.get('argument-hint')}")
                else:
                    error_msg = f"Failed to read SKILL.md in {skill_name}"
                    errors.append(error_msg)
                    notes.append("Using fallback metadata generation")
                    print(f"  WARNING: {error_msg}")
            else:
                notes.append("No SKILL.md found - using fallback metadata")
                print(f"  WARNING: No SKILL.md found")

            # Generate fallback metadata if needed
            if not metadata:
                print(f"  Generating fallback metadata...")
                metadata = self.generate_fallback_metadata(skill_name, files_dict)
                print(f"  ✓ Generated fallback metadata")

            # Step 3: Categorize content files
            print(f"\n[3/6] Categorizing content files...")
            categorized = self.categorize_content_files(files_dict)

            category_counts = {
                'reference': len(categorized.get('reference', [])),
                'examples': len(categorized.get('examples', [])),
                'code': len(categorized.get('code', [])),
                'themes': len(categorized.get('themes', []))
            }
            print(f"  ✓ Categorized files:")
            for category, count in category_counts.items():
                if count > 0:
                    print(f"    - {category}: {count} files")

            # Step 4: Generate output content
            print(f"\n[4/6] Generating output content...")
            try:
                output_content = self.generate_output_content(
                    skill_name=skill_name,
                    files_dict=files_dict,
                    categorized=categorized,
                    metadata=metadata
                )

                if not output_content or len(output_content.strip()) == 0:
                    error_msg = "Generated empty output content"
                    errors.append(error_msg)
                    print(f"  ERROR: {error_msg}")
                    return ProcessingResult(
                        skill_name=skill_name,
                        status="FAILED",
                        output_file=None,
                        files_processed=files_processed,
                        errors=errors,
                        notes=notes,
                        retry_count=retry_count
                    )

                content_size = len(output_content)
                print(f"  ✓ Generated {content_size} characters of content")

                # Track all files that were integrated into the output
                for file_list in [categorized.get('reference', []),
                                 categorized.get('examples', []),
                                 categorized.get('code', []),
                                 categorized.get('themes', [])]:
                    for file_path in file_list:
                        rel_path = str(file_path.relative_to(INPUT_DIR))
                        if rel_path not in files_processed:
                            files_processed.append(rel_path)

            except Exception as e:
                error_msg = f"Failed to generate output content: {e}"
                errors.append(error_msg)
                print(f"  ERROR: {error_msg}")
                return ProcessingResult(
                    skill_name=skill_name,
                    status="FAILED",
                    output_file=None,
                    files_processed=files_processed,
                    errors=errors,
                    notes=notes,
                    retry_count=retry_count
                )

            # Step 5: Generate output filename with conflict resolution
            print(f"\n[5/6] Determining output filename...")
            base_filename = self.generate_output_filename(skill_name)
            final_filename = self.check_naming_conflict(base_filename, OUTPUT_DIR)

            if base_filename != final_filename:
                notes.append(f"Naming conflict resolved: {base_filename} → {final_filename}")
                print(f"  ! Conflict resolved: {base_filename} → {final_filename}")
            else:
                print(f"  ✓ Output filename: {final_filename}")

            # Step 6: Write output file
            print(f"\n[6/6] Writing output file...")
            write_success = self.write_output_file(final_filename, output_content)

            if not write_success:
                error_msg = f"Failed to write output file: {final_filename}"
                errors.append(error_msg)
                print(f"  ERROR: {error_msg}")
                return ProcessingResult(
                    skill_name=skill_name,
                    status="FAILED",
                    output_file=None,
                    files_processed=files_processed,
                    errors=errors,
                    notes=notes,
                    retry_count=retry_count
                )

            # Determine final status
            if errors:
                status = "PARTIAL_SUCCESS"
                notes.append(f"Completed with {len(errors)} error(s)")
                print(f"\n⚠ Status: PARTIAL_SUCCESS ({len(errors)} errors)")
            else:
                status = "SUCCESS"
                print(f"\n✓ Status: SUCCESS")

            print(f"  Output: {final_filename}")
            print(f"  Files processed: {len(files_processed)}")

            return ProcessingResult(
                skill_name=skill_name,
                status=status,
                output_file=final_filename,
                files_processed=files_processed,
                errors=errors,
                notes=notes,
                retry_count=retry_count
            )

        except Exception as e:
            # Catch-all for any unexpected errors
            error_msg = f"Unexpected error processing {skill_name}: {e}"
            errors.append(error_msg)
            print(f"\n  FATAL ERROR: {error_msg}")

            return ProcessingResult(
                skill_name=skill_name,
                status="FAILED",
                output_file=None,
                files_processed=files_processed,
                errors=errors,
                notes=notes,
                retry_count=retry_count
            )

    def format_summary_section(self, report: ConversionReport) -> str:
        """Format summary statistics section of the report.

        Args:
            report: ConversionReport object with aggregated statistics

        Returns:
            Formatted string with summary statistics

        Notes:
            - Includes total counts, success rate calculation
            - Uses separators for visual clarity
            - Displays all key metrics at a glance
        """
        lines = []

        lines.append("=" * 60)
        lines.append("SUMMARY STATISTICS")
        lines.append("=" * 60)
        lines.append("")
        lines.append(f"Total Skills Processed: {report.total_skills}")
        lines.append(f"Successful Conversions: {report.successful}")
        lines.append(f"Partial Successes: {report.partial_success}")
        lines.append(f"Failed Conversions: {report.failed}")
        lines.append(f"Total Files Processed: {report.total_files_processed}")
        lines.append(f"Total Errors: {report.total_errors}")
        lines.append(f"Total Retries: {report.total_retries}")

        # Calculate and display success rate
        if report.total_skills > 0:
            success_rate = ((report.successful + report.partial_success)
                           / report.total_skills * 100)
            lines.append(f"Success Rate: {success_rate:.1f}%")

        lines.append("")

        return "\n".join(lines)

    def format_success_section(self, report: ConversionReport) -> str:
        """Format successful conversions section of the report.

        Args:
            report: ConversionReport object with all processing results

        Returns:
            Formatted string listing all successful conversions

        Notes:
            - Lists only SUCCESS status results
            - Shows output file, file count, and notes for each
            - Includes v2.0 transformation statistics (mode, merged files, etc.)
            - Returns empty string if no successful conversions
        """
        successful_results = [r for r in report.results
                             if r.status == "SUCCESS"]

        if not successful_results:
            return ""

        lines = []
        lines.append("=" * 60)
        lines.append(f"SUCCESSFUL CONVERSIONS ({len(successful_results)})")
        lines.append("=" * 60)
        lines.append("")

        for i, result in enumerate(successful_results, 1):
            lines.append(f"[{i}] {result.skill_name}")
            lines.append(f"    Output: {result.output_file}")
            lines.append(f"    Files Processed: {len(result.files_processed)}")

            # Add v2.0 transformation mode (subtask 6.1)
            if result.transformation_mode:
                lines.append(f"    Transformation Mode: {result.transformation_mode}")

                # Add v2.0 transformation statistics (subtasks 6.2-6.5)
                stats_lines = []

                # Markdown files merged (subtask 6.2)
                if result.markdown_files_merged > 0:
                    stats_lines.append(f"Merged {result.markdown_files_merged} markdown file(s)")

                # Subdirectories copied (subtask 6.3)
                if result.subdirectories_copied > 0:
                    stats_lines.append(f"Copied {result.subdirectories_copied} subdirectory(ies)")

                # Scripts relocated (subtask 6.4)
                if result.scripts_relocated > 0:
                    stats_lines.append(f"Relocated {result.scripts_relocated} script(s)")

                # Path updates (subtask 6.5)
                if result.path_updates_count > 0:
                    stats_lines.append(f"Updated {result.path_updates_count} path reference(s)")

                if stats_lines:
                    lines.append(f"    Statistics: {', '.join(stats_lines)}")

            if result.notes:
                lines.append("    Notes:")
                for note in result.notes:
                    lines.append(f"      - {note}")

            lines.append("")

        return "\n".join(lines)

    def format_failure_section(self, report: ConversionReport) -> str:
        """Format failed and partial success conversions section.

        Args:
            report: ConversionReport object with all processing results

        Returns:
            Formatted string listing all failed/partial conversions

        Notes:
            - Lists FAILED and PARTIAL_SUCCESS status results
            - Shows detailed errors and suggestions for each
            - Returns empty string if no failures/partial successes
        """
        failed_results = [r for r in report.results
                         if r.status in ["FAILED", "PARTIAL_SUCCESS"]]

        if not failed_results:
            return ""

        lines = []
        lines.append("=" * 60)
        lines.append(f"FAILED / PARTIAL SUCCESS CONVERSIONS ({len(failed_results)})")
        lines.append("=" * 60)
        lines.append("")

        for i, result in enumerate(failed_results, 1):
            lines.append(f"[{result.status}] {result.skill_name}")

            if result.output_file:
                lines.append(f"    Output: {result.output_file}")
            else:
                lines.append(f"    Output: N/A")

            if result.files_processed:
                lines.append(f"    Files Processed: {len(result.files_processed)}")
                # Show first 5 files
                for file in result.files_processed[:5]:
                    lines.append(f"      - {file}")
                if len(result.files_processed) > 5:
                    lines.append(f"      ... and {len(result.files_processed) - 5} more")

            if result.errors:
                lines.append("    Errors:")
                for error in result.errors:
                    lines.append(f"      - {error}")

            if result.retry_count > 0:
                lines.append(f"    Retry Attempts: {result.retry_count}")

            # Provide suggestions based on status
            if result.status == "PARTIAL_SUCCESS":
                lines.append("    Suggestion: Review output file, may need manual adjustments")
            elif result.status == "FAILED":
                lines.append("    Suggestion: Check directory permissions and file accessibility")

            lines.append("")

        return "\n".join(lines)

    def print_report(self, report: ConversionReport):
        """Print formatted conversion report to stdout.

        Args:
            report: ConversionReport object with all results

        Notes:
            - Prints summary, successful conversions, and failures
            - Uses clear sections with separators
            - Provides actionable suggestions for failures
        """
        print("\n")
        print(self.format_summary_section(report))
        print(self.format_success_section(report))
        print(self.format_failure_section(report))

    def generate_report(self) -> ConversionReport:
        """Generate final conversion report.

        Aggregates all ProcessingResult objects to create a comprehensive
        ConversionReport with summary statistics.

        Returns:
            ConversionReport object containing:
            - Total skill count
            - Success/partial/failure counts
            - Total files processed
            - Total errors and retries
            - List of all individual results

        Notes:
            - Calculates statistics from self.results
            - Should be called after all skills are processed
            - Results are available for detailed inspection
        """
        # Count results by status
        successful = sum(1 for r in self.results if r.status == "SUCCESS")
        partial = sum(1 for r in self.results if r.status == "PARTIAL_SUCCESS")
        failed = sum(1 for r in self.results if r.status == "FAILED")

        # Sum total files and errors
        total_files = sum(len(r.files_processed) for r in self.results)
        total_errors = sum(len(r.errors) for r in self.results)
        total_retries = sum(r.retry_count for r in self.results)

        return ConversionReport(
            total_skills=len(self.results),
            successful=successful,
            partial_success=partial,
            failed=failed,
            total_files_processed=total_files,
            total_errors=total_errors,
            total_retries=total_retries,
            results=self.results
        )

    def run(self) -> ConversionReport:
        """Main execution method.

        Orchestrates the complete conversion process:
        1. Discover all skill directories
        2. Process each skill directory
        3. Generate and return final report

        Returns:
            ConversionReport object with complete results.

        Notes:
            - Creates output directory if it doesn't exist
            - Processes skills in sorted order for consistency
            - Continues processing even if individual skills fail
        """
        print("\n" + "=" * 60)
        print("SKILL-TO-COMMAND CONVERTER")
        print("=" * 60)
        print(f"Input Directory: {INPUT_DIR}")
        print(f"Output Directory: {OUTPUT_DIR}")
        print("=" * 60)

        # Step 1: Ensure output directory exists
        print("\n[Step 1/3] Checking output directory...")
        if not self.ensure_output_directory():
            print("ERROR: Cannot create or access output directory")
            print("Aborting conversion process.")
            return ConversionReport(
                total_skills=0,
                successful=0,
                partial_success=0,
                failed=0,
                total_files_processed=0,
                total_errors=0,
                total_retries=0,
                results=[]
            )

        # Step 2: Discover all skill directories
        print("\n[Step 2/3] Discovering skill directories...")
        skill_dirs = self.discover_skills()

        if not skill_dirs:
            print("WARNING: No skill directories found")
            print(f"  Checked directory: {INPUT_DIR}")
            print("  Make sure the INPUT_DIR contains skill subdirectories")
            return ConversionReport(
                total_skills=0,
                successful=0,
                partial_success=0,
                failed=0,
                total_files_processed=0,
                total_errors=0,
                total_retries=0,
                results=[]
            )

        print(f"Found {len(skill_dirs)} skill directories")
        print(f"Skills: {', '.join([d.name for d in skill_dirs[:5]])}")
        if len(skill_dirs) > 5:
            print(f"  ... and {len(skill_dirs) - 5} more")

        # Step 3: Process each skill directory
        print("\n[Step 3/3] Processing skill directories...")
        print(f"Starting batch processing of {len(skill_dirs)} skills...")
        print("")

        for skill_dir in sorted(skill_dirs):
            try:
                result = self.process_skill(skill_dir)
                self.results.append(result)
            except Exception as e:
                # Catch any unexpected errors and continue with next skill
                print(f"\nFATAL ERROR processing {skill_dir.name}: {e}")
                print(f"  Skipping to next skill...")
                # Create a FAILED result
                self.results.append(ProcessingResult(
                    skill_name=skill_dir.name,
                    status="FAILED",
                    output_file=None,
                    files_processed=[],
                    errors=[f"Fatal error: {e}"],
                    notes=[],
                    retry_count=0
                ))

        # Step 4: Generate final report
        print("\n" + "=" * 60)
        print("PROCESSING COMPLETE")
        print("=" * 60)
        print("")

        report = self.generate_report()
        self.print_report(report)

        return report


# ============================================================================
# Main Function
# ============================================================================

def main():
    """Main entry point for the converter."""
    try:
        converter = SkillConverter()
        report = converter.run()

        # Return exit code based on results
        if report.failed > 0:
            print(f"\n⚠ WARNING: {report.failed} skill(s) failed to convert")
            sys.exit(1)
        elif report.partial_success > 0:
            print(f"\n⚠ WARNING: {report.partial_success} skill(s) converted with errors")
            sys.exit(0)  # Partial success is still success
        else:
            print(f"\n✓ SUCCESS: All {report.successful} skill(s) converted successfully")
            sys.exit(0)

    except KeyboardInterrupt:
        print("\n\nConversion interrupted by user")
        sys.exit(130)

    except Exception as e:
        print(f"\n\nFATAL ERROR: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)


if __name__ == "__main__":
    main()
