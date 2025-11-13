# Product Requirements Document (PRD)
## Skill-to-Command Converter Tool - Version 2.0

**Version:** 2.0
**Date:** 2025-11-12
**Author:** PRD Development Team
**Status:** Ready for Implementation

---

## Table of Contents

1. [Executive Summary](#executive-summary)
2. [Problem Statement](#problem-statement)
3. [Proposed Solution](#proposed-solution)
4. [User Stories](#user-stories)
5. [Functional Requirements](#functional-requirements)
6. [Technical Specifications](#technical-specifications)
7. [Transformation Rules](#transformation-rules)
8. [Example Transformations](#example-transformations)
9. [Command Format Specification](#command-format-specification)
10. [Implementation Plan](#implementation-plan)
11. [Testing Strategy](#testing-strategy)
12. [Success Criteria](#success-criteria)

---

## Executive Summary

### Overview

Version 2.0 of the Skill-to-Command Converter introduces sophisticated handling for complex skill structures. Unlike v1.0, which flattened all skill content into single markdown files, v2.0 preserves subdirectories and executable scripts while maintaining the single-file command documentation format.

### Key Changes from v1.0

**What's New:**
- **Subdirectory Preservation**: Skills with scripts, utilities, and assets preserve their directory structure
- **Script Path Management**: Automatic path rewriting for root-level scripts moved to subdirectories
- **Intelligent Merging**: Multiple root-level markdown files merge into single command file
- **Three Transformation Modes**: Automatic detection and handling of different skill architectures

**What Stays the Same:**
- Output markdown files always at `/commands/` root
- Factory AI command format compliance
- YAML frontmatter preservation
- Batch processing with detailed reporting

### Strategic Value

This upgrade enables the converter to handle real-world skill packages that include:
- Executable scripts and utilities (`.sh`, `.py`, `.js`, etc.)
- Supporting libraries and modules in subdirectories
- Complex documentation structures with multiple reference files
- Mixed content (documentation + code + assets)

---

## Problem Statement

### Current Limitations (v1.0)

The existing converter at `/home/user/agentic-kit/skill-to-command/skill_to_command_converter.py` has critical limitations:

**Problem 1: Subdirectory Exclusion**
- v1.0 excludes entire subdirectories like `scripts/`, `ooxml/`
- Result: Sophisticated skills lose essential executable components
- Example: `docx` skill loses `scripts/` directory containing conversion utilities

**Problem 2: Flat File Assumption**
- Assumes all relevant content is in root-level markdown files
- Cannot handle skills with deep directory structures
- No mechanism to preserve relative file relationships

**Problem 3: No Script Handling**
- Root-level scripts are ignored or excluded
- Path references in documentation become broken
- Users cannot execute examples that depend on scripts

**Problem 4: Single Markdown Merge**
- Merges all markdown into one document without context
- Loses organizational structure from original skill
- No distinction between primary and supporting documentation

### Real-World Impact

**Affected Skills:**
1. **docx** - Loses `scripts/` and `ooxml/` subdirectories
2. **algorithmic-art** - Loses `templates/` subdirectory
3. **root-cause-tracing** - Root script `find-polluter.sh` excluded
4. **pdf** - Supporting scripts in subdirectories lost

### Business Requirements

Users need:
- Complete skill packages that work out-of-the-box
- Executable examples and utilities preserved
- Documentation that accurately references existing files
- Clean separation between documentation and implementation

---

## Proposed Solution

### Core Architecture

Version 2.0 implements a **dual-output strategy**:

```
Input:  /skills/{skill-name}/
        ├── SKILL.md (and other .md files)
        ├── executable scripts
        └── subdirectories/

Output: /commands/{skill-name}.md           ← Documentation (merged)
        /commands/{skill-name}/...          ← Subdirectories + scripts
```

### Three Transformation Scenarios

The converter automatically detects and applies one of three transformation modes:

#### Scenario 1: Skills with Subdirectories

**Detection:** Skill contains subdirectories (excluding `__pycache__`, `.git`)

**Transformation:**
- Merge all root-level `.md` files → `/commands/{skill-name}.md`
- Copy subdirectories as-is → `/commands/{skill-name}/`
- Preserve directory structure and relative paths

**Example: docx skill**
```
Input:  /skills/docx/
        ├── SKILL.md
        ├── docx-js.md
        ├── ooxml.md
        ├── LICENSE.txt
        ├── scripts/
        └── ooxml/

Output: /commands/docx.md
        /commands/docx/scripts/
        /commands/docx/ooxml/
```

#### Scenario 2: Simple Skills (Single-File)

**Detection:** Only `SKILL.md` in root (no subdirs, no scripts)

**Transformation:**
- Rename `SKILL.md` → `/commands/{skill-name}.md`
- No subdirectory creation needed

**Example: brainstorming skill**
```
Input:  /skills/brainstorming/
        ├── SKILL.md
        └── LICENSE.txt

Output: /commands/brainstorming.md
```

#### Scenario 3: Root-Level Scripts

**Detection:** Executable scripts at root level (`.sh`, `.py`, `.js`, etc.)

**Transformation:**
- Merge root-level `.md` files → `/commands/{skill-name}.md`
- Move scripts → `/commands/{skill-name}/`
- Update paths in markdown: `./script.sh` → `./{skill-name}/script.sh`

**Example: root-cause-tracing skill**
```
Input:  /skills/root-cause-tracing/
        ├── SKILL.md
        ├── find-polluter.sh
        └── LICENSE.txt

Output: /commands/root-cause-tracing.md (with updated paths)
        /commands/root-cause-tracing/find-polluter.sh
```

### Decision Logic

```python
def determine_transformation_mode(skill_dir):
    """
    Determine which transformation scenario to apply.

    Returns: "DIRECTORY_WITH_SUBDIRS" | "DIRECTORY_WITH_SCRIPTS" | "SINGLE_FILE"
    """

    # Step 1: Check for subdirectories (excluding __pycache__, .git, etc.)
    subdirs = get_valid_subdirectories(skill_dir)

    if len(subdirs) > 0:
        return "DIRECTORY_WITH_SUBDIRS"  # Scenario 1

    # Step 2: Check for root-level scripts
    scripts = get_root_level_scripts(skill_dir)

    if len(scripts) > 0:
        return "DIRECTORY_WITH_SCRIPTS"  # Scenario 3

    # Step 3: Default to single-file
    return "SINGLE_FILE"  # Scenario 2
```

---

## User Stories

### Primary User Stories

**US-2.0-001: Preserve Executable Scripts**
```
As a skill developer
I want executable scripts to be preserved in the command package
So that users can run examples and utilities without manual setup
```

**US-2.0-002: Maintain Directory Structure**
```
As a skill maintainer
I want subdirectory structures preserved exactly as designed
So that relative imports and file references continue working
```

**US-2.0-003: Automatic Path Updates**
```
As a documentation writer
I want paths in markdown automatically updated when files move
So that all documentation references remain valid
```

**US-2.0-004: Merge Multiple Markdown Files**
```
As a content creator
I want multiple root-level markdown files merged intelligently
So that users get comprehensive documentation in one file
```

**US-2.0-005: Intelligent Mode Detection**
```
As a batch processor
I want the tool to automatically detect the right transformation mode
So that I don't need to configure each skill individually
```

### Secondary User Stories

**US-2.0-006: License File Exclusion**
```
As a legal compliance officer
I want LICENSE.txt files excluded from command packages
So that licensing is handled at the package level, not per-command
```

**US-2.0-007: Factory AI Format Compliance**
```
As a Factory AI integration developer
I want all command files to follow the slash command specification
So that commands work correctly in the Factory AI system
```

**US-2.0-008: Detailed Transformation Reporting**
```
As a quality assurance engineer
I want detailed logs of which mode was applied and what was transformed
So that I can verify correctness and debug issues
```

---

## Functional Requirements

### FR-2.0-1: Output Structure Management

**FR-2.0-1.1: Markdown File Placement (CRITICAL)**
- ALL output markdown files MUST be placed at `/commands/` root
- NEVER create subdirectories for markdown files
- Naming convention: `{skill-name}.md`
- Examples:
  - `/commands/docx.md`
  - `/commands/algorithmic-art.md`
  - `/commands/root-cause-tracing.md`

**FR-2.0-1.2: Subdirectory Placement (CRITICAL)**
- ALL subdirectories MUST be placed at `/commands/{skill-name}/`
- MUST preserve exact subdirectory structure
- MUST preserve file permissions (especially for scripts)
- Examples:
  - `/commands/docx/scripts/`
  - `/commands/docx/ooxml/`
  - `/commands/algorithmic-art/templates/`

**FR-2.0-1.3: Path Consistency**
- Output structure MUST be consistent across all transformation modes
- Users MUST be able to predict output locations
- Relative paths between files MUST remain valid after transformation

### FR-2.0-2: SKILL.md Transformation

**FR-2.0-2.1: File Renaming**
- `SKILL.md` MUST be renamed to `{parent_folder_name}.md`
- Parent folder name is the immediate directory containing SKILL.md
- Examples:
  - `/skills/docx/SKILL.md` → `/commands/docx.md`
  - `/skills/brainstorming/SKILL.md` → `/commands/brainstorming.md`

**FR-2.0-2.2: YAML Frontmatter Preservation**
- YAML frontmatter from SKILL.md MUST be preserved
- Frontmatter MUST be the only YAML block in output file
- Other merged files' frontmatter MUST be removed

**FR-2.0-2.3: Content Integration Priority**
- SKILL.md content MUST appear first (after frontmatter)
- Other merged markdown files follow in alphabetical order
- No duplicate section headers should be created

### FR-2.0-3: Markdown Merging

**FR-2.0-3.1: Root-Level Markdown Detection**
- Tool MUST identify all `.md` files at skill root level
- Tool MUST exclude `SKILL.md` from merge list (processed separately)
- Tool MUST process merge candidates alphabetically

**FR-2.0-3.2: Section Header Conversion**
- Each merged file MUST become a `## {filename}` section
- Filename MUST have `.md` extension removed
- Examples:
  - `docx-js.md` → `## docx-js`
  - `ooxml.md` → `## ooxml`

**FR-2.0-3.3: Merge Order**
```
Output structure:
---
[YAML frontmatter from SKILL.md]
---

[SKILL.md content body]

## {first-alphabetical-file}
[content from first file]

## {second-alphabetical-file}
[content from second file]

...
```

**FR-2.0-3.4: Frontmatter Removal from Merged Files**
- If merged files have YAML frontmatter, it MUST be removed
- Only content body of merged files should be included
- Prevents multiple frontmatter blocks in output

### FR-2.0-4: Subdirectory Preservation

**FR-2.0-4.1: Directory Copying**
- Tool MUST copy entire subdirectory trees
- Tool MUST preserve file permissions (especially +x for scripts)
- Tool MUST maintain relative paths within subdirectories
- Tool MUST handle symbolic links safely

**FR-2.0-4.2: Exclusions During Copy**
- MUST exclude: `.git/`, `__pycache__/`, `.DS_Store`
- MUST exclude: `LICENSE.txt`, `LICENSE` at any depth
- MUST exclude: `.gitignore` files
- MAY exclude: other version control artifacts

**FR-2.0-4.3: No Content Modification**
- Files in subdirectories MUST NOT be modified
- Binary files preserved exactly
- Text files preserved exactly
- No path rewriting within subdirectory files

### FR-2.0-5: Root Script Handling

**FR-2.0-5.1: Script Detection**
- Tool MUST identify scripts by extension: `.sh`, `.py`, `.js`, `.ts`, `.rb`, `.pl`
- Tool MUST check if script is at root level (not in subdirectory)
- Tool MUST preserve executable permissions

**FR-2.0-5.2: Script Relocation**
- Root-level scripts MUST be moved to `/commands/{skill-name}/`
- Directory structure maintained for organizational purposes
- Examples:
  - `/skills/root-cause-tracing/find-polluter.sh` → `/commands/root-cause-tracing/find-polluter.sh`

**FR-2.0-5.3: Path Updates in Markdown**
- Tool MUST scan markdown files for script references
- Tool MUST update relative paths to reflect new location
- Patterns to update:
  - `./script.sh` → `./{skill-name}/script.sh`
  - `./find-polluter.sh` → `./root-cause-tracing/find-polluter.sh`
  - `/script.sh` → `/{skill-name}/script.sh` (absolute path fix)

**FR-2.0-5.4: Path Update Algorithm**
```python
def update_script_paths(markdown_content, skill_name, script_names):
    """
    Update relative script paths in markdown content.

    Args:
        markdown_content: String content of markdown file
        skill_name: Name of the skill (directory name)
        script_names: List of script filenames to update

    Returns:
        Updated markdown content with corrected paths
    """
    for script in script_names:
        # Pattern: ./script.sh or /script.sh
        old_pattern_relative = f"./{script}"
        old_pattern_absolute = f"/{script}"

        new_path = f"./{skill_name}/{script}"

        markdown_content = markdown_content.replace(old_pattern_relative, new_path)
        markdown_content = markdown_content.replace(old_pattern_absolute, new_path)

    return markdown_content
```

### FR-2.0-6: File Exclusion Rules

**FR-2.0-6.1: Always Exclude**
The following files MUST ALWAYS be excluded at any depth:
- `LICENSE.txt`
- `LICENSE`
- `.gitignore`
- `__pycache__/` (directory)
- `.git/` (directory)
- `.DS_Store`

**FR-2.0-6.2: Binary File Handling**
- Binary files in subdirectories MUST be copied as-is
- Binary files at root level SHOULD be excluded (not useful in documentation)
- Exception: If binary is in a subdirectory being preserved, include it

**FR-2.0-6.3: Exclusion Reporting**
- Tool MUST log all excluded files
- Report MUST distinguish between intentional exclusions and errors
- Users can verify nothing important was excluded

### FR-2.0-7: Transformation Mode Decision Logic

**FR-2.0-7.1: Mode Detection Algorithm**
```python
# Constants
SCRIPT_EXTENSIONS = {'.sh', '.py', '.js', '.ts', '.rb', '.pl'}
EXCLUDE_DIRS = {'__pycache__', '.git', 'node_modules'}

def determine_mode(skill_path: Path) -> str:
    """
    Determine transformation mode for a skill directory.

    Returns:
        "DIRECTORY_WITH_SUBDIRS" | "DIRECTORY_WITH_SCRIPTS" | "SINGLE_FILE"
    """

    # Get all items in root directory
    root_items = list(skill_path.iterdir())

    # Check for subdirectories (excluding special dirs)
    subdirs = [
        item for item in root_items
        if item.is_dir() and item.name not in EXCLUDE_DIRS
    ]

    if len(subdirs) > 0:
        return "DIRECTORY_WITH_SUBDIRS"

    # Check for root-level scripts
    scripts = [
        item for item in root_items
        if item.is_file() and item.suffix in SCRIPT_EXTENSIONS
    ]

    if len(scripts) > 0:
        return "DIRECTORY_WITH_SCRIPTS"

    # Default: single file mode
    return "SINGLE_FILE"
```

**FR-2.0-7.2: Mode-Specific Processing**

Each mode MUST follow its specific transformation rules:

**Mode: DIRECTORY_WITH_SUBDIRS**
1. Merge all root `.md` files → `/commands/{skill}.md`
2. Copy all subdirectories → `/commands/{skill}/`
3. No path updates needed (subdirs preserve structure)

**Mode: DIRECTORY_WITH_SCRIPTS**
1. Merge all root `.md` files → `/commands/{skill}.md`
2. Move scripts → `/commands/{skill}/`
3. Update script paths in merged markdown

**Mode: SINGLE_FILE**
1. Rename `SKILL.md` → `/commands/{skill}.md`
2. No subdirectories to copy
3. No path updates needed

### FR-2.0-8: Error Handling and Recovery

**FR-2.0-8.1: Missing SKILL.md in Complex Structure**
- If Scenario 1 or 3 applies but no SKILL.md exists:
  - Merge all available `.md` files
  - Generate frontmatter from first merged file
  - Status: PARTIAL_SUCCESS

**FR-2.0-8.2: Subdirectory Copy Failures**
- If subdirectory copy fails (permissions, disk space):
  - Log detailed error with directory path
  - Continue with markdown generation
  - Status: PARTIAL_SUCCESS

**FR-2.0-8.3: Path Update Failures**
- If script path regex fails to match:
  - Log warning with original path
  - Include script in output anyway
  - Add note to manual review
  - Status: PARTIAL_SUCCESS

**FR-2.0-8.4: Mode Detection Ambiguity**
- If mode cannot be determined:
  - Default to SINGLE_FILE
  - Log warning about ambiguous structure
  - Status: PARTIAL_SUCCESS

### FR-2.0-9: Reporting Enhancements

**FR-2.0-9.1: Mode Reporting**
Each processing result MUST include:
- Detected transformation mode
- Files merged (count and names)
- Subdirectories copied (count and paths)
- Scripts relocated (count and names)
- Path updates performed (count)

**FR-2.0-9.2: Report Format Addition**
```
[1] docx
    Status: SUCCESS
    Mode: DIRECTORY_WITH_SUBDIRS
    Output: /commands/docx.md
    Markdown Files Merged: 3 (SKILL.md, docx-js.md, ooxml.md)
    Subdirectories Copied: 2
      - scripts/ (3 files)
      - ooxml/ (5 files)
    Files Excluded: 1 (LICENSE.txt)
    Notes: None
```

**FR-2.0-9.3: Path Update Logging**
For Scenario 3 (root scripts), log each path update:
```
    Path Updates: 2
      - ./find-polluter.sh → ./root-cause-tracing/find-polluter.sh
      - /find-polluter.sh → /root-cause-tracing/find-polluter.sh
```

---

## Technical Specifications

### TS-2.0-1: Architecture Changes

**TS-2.0-1.1: New Classes/Modules**
```python
class TransformationMode(Enum):
    """Enumeration of transformation modes."""
    DIRECTORY_WITH_SUBDIRS = "DIRECTORY_WITH_SUBDIRS"
    DIRECTORY_WITH_SCRIPTS = "DIRECTORY_WITH_SCRIPTS"
    SINGLE_FILE = "SINGLE_FILE"

class ModeDetector:
    """Detects which transformation mode to apply."""

    def detect_mode(self, skill_dir: Path) -> TransformationMode:
        """Analyze skill structure and return appropriate mode."""
        pass

class MarkdownMerger:
    """Handles merging of multiple markdown files."""

    def merge_files(self, files: List[Path], skill_name: str) -> str:
        """Merge multiple markdown files into single output."""
        pass

    def preserve_frontmatter(self, skill_md_content: str) -> Dict[str, str]:
        """Extract and preserve YAML frontmatter from SKILL.md."""
        pass

class SubdirectoryPreserver:
    """Handles copying of subdirectory structures."""

    def copy_tree(self, src: Path, dest: Path, exclude_patterns: List[str]):
        """Recursively copy directory tree with exclusions."""
        pass

    def preserve_permissions(self, src_file: Path, dest_file: Path):
        """Preserve file permissions (especially +x for scripts)."""
        pass

class PathUpdater:
    """Updates file paths in markdown content."""

    def update_script_paths(self, content: str, skill_name: str,
                           scripts: List[str]) -> str:
        """Update relative script paths in markdown."""
        pass

    def find_script_references(self, content: str) -> List[str]:
        """Find all script references in markdown content."""
        pass
```

**TS-2.0-1.2: Modified Classes**
```python
class SkillConverter:
    """Enhanced with mode detection and multi-strategy processing."""

    def __init__(self):
        self.mode_detector = ModeDetector()
        self.markdown_merger = MarkdownMerger()
        self.subdir_preserver = SubdirectoryPreserver()
        self.path_updater = PathUpdater()

    def process_skill(self, skill_dir: Path) -> ProcessingResult:
        """
        Enhanced processing with mode detection.

        1. Detect transformation mode
        2. Apply mode-specific transformations
        3. Generate output based on mode
        """
        mode = self.mode_detector.detect_mode(skill_dir)

        if mode == TransformationMode.DIRECTORY_WITH_SUBDIRS:
            return self._process_with_subdirs(skill_dir)
        elif mode == TransformationMode.DIRECTORY_WITH_SCRIPTS:
            return self._process_with_scripts(skill_dir)
        else:
            return self._process_single_file(skill_dir)
```

### TS-2.0-2: Data Structures

**TS-2.0-2.1: Enhanced ProcessingResult**
```python
@dataclass
class ProcessingResult:
    """Extended to include transformation mode and details."""
    skill_name: str
    status: str  # "SUCCESS", "PARTIAL_SUCCESS", "FAILED"
    transformation_mode: TransformationMode
    output_file: Optional[str]

    # File tracking
    markdown_files_merged: List[str]
    subdirectories_copied: List[str]
    scripts_relocated: List[str]
    files_excluded: List[str]

    # Path updates
    path_updates_count: int
    path_update_details: List[Tuple[str, str]]  # (old_path, new_path)

    # Standard fields
    files_processed: List[str]
    errors: List[str]
    notes: List[str]
    retry_count: int
```

**TS-2.0-2.2: Mode Detection Result**
```python
@dataclass
class ModeDetectionResult:
    """Result of mode detection analysis."""
    mode: TransformationMode
    subdirectories: List[Path]
    root_scripts: List[Path]
    root_markdown: List[Path]
    reasoning: str  # Explanation of why this mode was chosen
```

### TS-2.0-3: Algorithms

**TS-2.0-3.1: Markdown Merging Algorithm**
```python
def merge_markdown_files(skill_dir: Path, skill_md: Path,
                         other_md_files: List[Path]) -> str:
    """
    Merge multiple markdown files into single output.

    Steps:
    1. Extract YAML frontmatter from SKILL.md
    2. Extract content body from SKILL.md (after frontmatter)
    3. For each other .md file (alphabetically):
        a. Remove any YAML frontmatter from file
        b. Create section header: ## {filename}
        c. Append file content
    4. Assemble final output:
        - YAML frontmatter
        - SKILL.md content
        - Merged sections
    """
    output_parts = []

    # Step 1: Extract frontmatter from SKILL.md
    frontmatter = extract_yaml_frontmatter(skill_md)
    output_parts.append(format_yaml_frontmatter(frontmatter))
    output_parts.append("")  # Blank line after frontmatter

    # Step 2: Add SKILL.md content (without frontmatter)
    skill_content = read_file_without_frontmatter(skill_md)
    output_parts.append(skill_content)
    output_parts.append("")  # Blank line before merged sections

    # Step 3: Merge other files alphabetically
    for md_file in sorted(other_md_files, key=lambda p: p.name):
        # Remove .md extension for section header
        section_name = md_file.stem

        # Read content (strip frontmatter if present)
        content = read_file_without_frontmatter(md_file)

        # Create section
        output_parts.append(f"## {section_name}")
        output_parts.append("")
        output_parts.append(content)
        output_parts.append("")

    return "\n".join(output_parts)
```

**TS-2.0-3.2: Path Update Algorithm**
```python
import re

def update_script_paths_in_markdown(content: str, skill_name: str,
                                     script_names: List[str]) -> Tuple[str, int]:
    """
    Update script paths in markdown content.

    Returns:
        (updated_content, update_count)
    """
    updated_content = content
    update_count = 0

    for script in script_names:
        # Pattern 1: ./script.sh
        pattern1 = re.compile(rf'\./{re.escape(script)}')
        replacement1 = f'./{skill_name}/{script}'

        matches1 = pattern1.findall(updated_content)
        updated_content = pattern1.sub(replacement1, updated_content)
        update_count += len(matches1)

        # Pattern 2: /script.sh (absolute)
        pattern2 = re.compile(rf'(?<!\.)/{re.escape(script)}')
        replacement2 = f'/{skill_name}/{script}'

        matches2 = pattern2.findall(updated_content)
        updated_content = pattern2.sub(replacement2, updated_content)
        update_count += len(matches2)

    return updated_content, update_count
```

**TS-2.0-3.3: Subdirectory Copy Algorithm**
```python
import shutil
from pathlib import Path

def copy_subdirectory_tree(src: Path, dest: Path,
                          exclude_patterns: Set[str]) -> int:
    """
    Copy directory tree with exclusions and permission preservation.

    Returns:
        Number of files copied
    """
    files_copied = 0

    # Create destination directory
    dest.mkdir(parents=True, exist_ok=True)

    for item in src.rglob('*'):
        # Skip if matches exclusion pattern
        if any(pattern in item.parts for pattern in exclude_patterns):
            continue

        # Calculate relative path
        rel_path = item.relative_to(src)
        dest_path = dest / rel_path

        if item.is_dir():
            # Create directory
            dest_path.mkdir(parents=True, exist_ok=True)
        else:
            # Copy file
            dest_path.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(item, dest_path)  # copy2 preserves metadata

            # Preserve executable bit
            if item.stat().st_mode & 0o111:
                dest_path.chmod(dest_path.stat().st_mode | 0o111)

            files_copied += 1

    return files_copied
```

### TS-2.0-4: Configuration Constants

```python
# Transformation mode detection
SCRIPT_EXTENSIONS = {'.sh', '.py', '.js', '.ts', '.rb', '.pl', '.bash'}
EXCLUDE_DIRS = {'__pycache__', '.git', 'node_modules', '.venv', 'venv'}
EXCLUDE_FILES = {'LICENSE.txt', 'LICENSE', '.gitignore', '.DS_Store'}

# Path patterns for updates
SCRIPT_PATH_PATTERNS = [
    r'\./{script}',      # Relative: ./script.sh
    r'(?<!\.)/{script}', # Absolute: /script.sh
]

# Output paths
INPUT_DIR = Path(__file__).parent / "skills"
OUTPUT_DIR = Path(__file__).parent / "commands"
```

---

## Transformation Rules

### Processing Order

The converter MUST follow this exact sequence:

**Step 1: Discovery**
1. Scan skill directory
2. Identify all root-level items
3. Categorize: markdown files, scripts, subdirectories, other

**Step 2: Mode Detection**
1. Apply mode detection algorithm
2. Log detected mode
3. Prepare mode-specific processing strategy

**Step 3: Markdown Processing**
1. Locate SKILL.md (if exists)
2. Identify other root `.md` files
3. Execute merge algorithm
4. Generate output markdown content

**Step 4: Asset Handling** (mode-dependent)

**For DIRECTORY_WITH_SUBDIRS:**
1. Copy all subdirectories to `/commands/{skill}/`
2. Preserve permissions
3. Exclude blacklisted files/dirs

**For DIRECTORY_WITH_SCRIPTS:**
1. Move scripts to `/commands/{skill}/`
2. Update paths in merged markdown
3. Preserve executable permissions

**For SINGLE_FILE:**
1. No additional asset handling
2. Skip to output generation

**Step 5: Output Generation**
1. Write `/commands/{skill}.md`
2. Write any subdirectories (if applicable)
3. Verify all files written successfully

**Step 6: Reporting**
1. Compile processing statistics
2. Log transformation details
3. Add to batch report

### Markdown Merging Rules

**Rule 1: YAML Frontmatter**
- Only SKILL.md frontmatter appears in output
- Other files' frontmatter must be stripped
- If SKILL.md missing, generate fallback frontmatter

**Rule 2: Section Headers**
- Each merged file becomes `## {filename}` section
- Filename has `.md` extension removed
- Preserve capitalization from original filename

**Rule 3: Content Preservation**
- Do NOT modify merged file content
- Preserve code blocks exactly
- Preserve formatting and whitespace

**Rule 4: Merge Order**
```
1. YAML frontmatter (from SKILL.md)
2. SKILL.md content body
3. [alphabetical file 1] as ## section
4. [alphabetical file 2] as ## section
...
```

### Path Update Rules

**Rule 1: Script Reference Detection**
Detect paths in the following contexts:
- Code blocks: `` `./script.sh` ``
- Links: `[run script](./script.sh)`
- Plain text: `Execute ./script.sh to...`
- Commands: `$ ./script.sh`

**Rule 2: Path Transformation**
```
Old Pattern         New Pattern
--------------     ---------------------------
./script.sh        ./{skill-name}/script.sh
/script.sh         /{skill-name}/script.sh
script.sh          {skill-name}/script.sh (if standalone)
```

**Rule 3: Path Validation**
- After update, verify new path would be valid
- Log any paths that couldn't be updated
- Don't update paths in code blocks (preserve as examples)

### Subdirectory Preservation Rules

**Rule 1: Exact Copy**
- Copy subdirectories recursively
- Preserve all file permissions
- Preserve timestamps (use `shutil.copy2`)
- Preserve empty directories

**Rule 2: Exclusions**
Never copy:
- `__pycache__/` directories
- `.git/` directories
- `LICENSE.txt` files (at any depth)
- `.gitignore` files
- Binary artifacts: `.pyc`, `.so`, `.dll`

**Rule 3: Symbolic Links**
- Resolve symbolic links before copying
- Don't create circular references
- Log symbolic link handling

---

## Example Transformations

### Example 1: DIRECTORY_WITH_SUBDIRS - docx skill

**Input Structure:**
```
/home/user/agentic-kit/skill-to-command/skills/docx/
├── SKILL.md                 (main documentation)
├── docx-js.md               (JavaScript API reference)
├── ooxml.md                 (OOXML structure guide)
├── LICENSE.txt              (excluded)
├── scripts/
│   ├── convert.sh
│   ├── extract.py
│   └── utils.js
└── ooxml/
    ├── document.xml
    ├── styles.xml
    └── settings.xml
```

**Mode Detection:**
```
Subdirectories found: 2 (scripts/, ooxml/)
Root scripts: 0
Mode: DIRECTORY_WITH_SUBDIRS
```

**Transformation Process:**

1. **Merge Markdown Files:**
   - SKILL.md (keep frontmatter)
   - docx-js.md → `## docx-js` section
   - ooxml.md → `## ooxml` section

2. **Copy Subdirectories:**
   - `scripts/` → `/commands/docx/scripts/`
   - `ooxml/` → `/commands/docx/ooxml/`

3. **Exclude:**
   - LICENSE.txt

**Output Structure:**
```
/home/user/agentic-kit/skill-to-command/commands/
├── docx.md                  (merged documentation)
└── docx/
    ├── scripts/
    │   ├── convert.sh       (executable preserved)
    │   ├── extract.py       (executable preserved)
    │   └── utils.js
    └── ooxml/
        ├── document.xml
        ├── styles.xml
        └── settings.xml
```

**Output File Content (docx.md - excerpt):**
```markdown
---
description: Work with Microsoft Word DOCX files using Office Open XML
argument-hint: <docx-file>
---

Create, modify, and extract content from Microsoft Word DOCX files using the Office Open XML (OOXML) format.

[Content from SKILL.md body...]

## docx-js

[Content from docx-js.md without frontmatter...]

## ooxml

[Content from ooxml.md without frontmatter...]
```

**Report Entry:**
```
[1] docx
    Status: SUCCESS
    Mode: DIRECTORY_WITH_SUBDIRS
    Output: /commands/docx.md
    Markdown Files Merged: 3
      - SKILL.md (2,450 chars)
      - docx-js.md (1,823 chars)
      - ooxml.md (3,102 chars)
    Subdirectories Copied: 2
      - scripts/ (3 files, 12.4 KB)
      - ooxml/ (3 files, 8.9 KB)
    Files Excluded: 1
      - LICENSE.txt
    Path Updates: 0
    Notes: All subdirectories preserved successfully
```

---

### Example 2: SINGLE_FILE - brainstorming skill

**Input Structure:**
```
/home/user/agentic-kit/skill-to-command/skills/brainstorming/
├── SKILL.md
└── LICENSE.txt
```

**Mode Detection:**
```
Subdirectories found: 0
Root scripts: 0
Mode: SINGLE_FILE
```

**Transformation Process:**

1. **Simple Rename:**
   - SKILL.md → brainstorming.md

2. **No merging needed** (only one markdown file)

3. **Exclude:**
   - LICENSE.txt

**Output Structure:**
```
/home/user/agentic-kit/skill-to-command/commands/
└── brainstorming.md
```

**Output File Content (brainstorming.md - excerpt):**
```markdown
---
description: Facilitate creative brainstorming sessions with structured techniques
---

[Exact content from SKILL.md, including all sections...]
```

**Report Entry:**
```
[2] brainstorming
    Status: SUCCESS
    Mode: SINGLE_FILE
    Output: /commands/brainstorming.md
    Markdown Files Merged: 1
      - SKILL.md (1,234 chars)
    Subdirectories Copied: 0
    Files Excluded: 1
      - LICENSE.txt
    Path Updates: 0
    Notes: Simple single-file transformation
```

---

### Example 3: DIRECTORY_WITH_SCRIPTS - root-cause-tracing

**Input Structure:**
```
/home/user/agentic-kit/skill-to-command/skills/root-cause-tracing/
├── SKILL.md
├── find-polluter.sh         (executable script at root)
└── LICENSE.txt
```

**SKILL.md References (before transformation):**
```markdown
## Usage

Run the script to find the polluting commit:

```bash
./find-polluter.sh test-command
```

Or use the absolute path:

```bash
/find-polluter.sh "npm test"
```
```

**Mode Detection:**
```
Subdirectories found: 0
Root scripts: 1 (find-polluter.sh)
Mode: DIRECTORY_WITH_SCRIPTS
```

**Transformation Process:**

1. **Merge Markdown:**
   - Only SKILL.md exists (no other markdown files)

2. **Move Script:**
   - `find-polluter.sh` → `/commands/root-cause-tracing/find-polluter.sh`
   - Preserve +x permission

3. **Update Paths in Markdown:**
   - `./find-polluter.sh` → `./root-cause-tracing/find-polluter.sh`
   - `/find-polluter.sh` → `/root-cause-tracing/find-polluter.sh`

4. **Exclude:**
   - LICENSE.txt

**Output Structure:**
```
/home/user/agentic-kit/skill-to-command/commands/
├── root-cause-tracing.md
└── root-cause-tracing/
    └── find-polluter.sh     (executable preserved)
```

**Output File Content (root-cause-tracing.md - excerpt):**
```markdown
---
description: Trace root causes of test failures using git bisect automation
argument-hint: <test-command>
---

Automatically find the commit that introduced a bug using git bisect with your test command.

## Usage

Run the script to find the polluting commit:

```bash
./root-cause-tracing/find-polluter.sh test-command
```

Or use the absolute path:

```bash
/root-cause-tracing/find-polluter.sh "npm test"
```
```

**Report Entry:**
```
[3] root-cause-tracing
    Status: SUCCESS
    Mode: DIRECTORY_WITH_SCRIPTS
    Output: /commands/root-cause-tracing.md
    Markdown Files Merged: 1
      - SKILL.md (1,456 chars)
    Subdirectories Copied: 1
      - (created for scripts)
    Scripts Relocated: 1
      - find-polluter.sh → root-cause-tracing/find-polluter.sh
    Files Excluded: 1
      - LICENSE.txt
    Path Updates: 2
      - ./find-polluter.sh → ./root-cause-tracing/find-polluter.sh
      - /find-polluter.sh → /root-cause-tracing/find-polluter.sh
    Notes: Script paths updated in markdown
```

---

### Example 4: DIRECTORY_WITH_SUBDIRS - algorithmic-art

**Input Structure:**
```
/home/user/agentic-kit/skill-to-command/skills/algorithmic-art/
├── SKILL.md
├── LICENSE.txt
└── templates/
    ├── fractal-tree.md
    ├── geometric-pattern.md
    ├── mandelbrot.md
    └── spiral-galaxy.md
```

**Mode Detection:**
```
Subdirectories found: 1 (templates/)
Root scripts: 0
Mode: DIRECTORY_WITH_SUBDIRS
```

**Transformation Process:**

1. **Merge Markdown:**
   - Only SKILL.md at root (templates/ markdown files stay in subdirectory)

2. **Copy Subdirectory:**
   - `templates/` → `/commands/algorithmic-art/templates/`

3. **Exclude:**
   - LICENSE.txt

**Output Structure:**
```
/home/user/agentic-kit/skill-to-command/commands/
├── algorithmic-art.md
└── algorithmic-art/
    └── templates/
        ├── fractal-tree.md
        ├── geometric-pattern.md
        ├── mandelbrot.md
        └── spiral-galaxy.md
```

**Output File Content (algorithmic-art.md - excerpt):**
```markdown
---
description: Create beautiful algorithmic art using code and mathematics
argument-hint: <template-name>
---

Generate stunning visual art through mathematical algorithms and creative coding.

[Content from SKILL.md...]

Available templates are located in `./algorithmic-art/templates/`:
- fractal-tree.md
- geometric-pattern.md
- mandelbrot.md
- spiral-galaxy.md
```

**Report Entry:**
```
[4] algorithmic-art
    Status: SUCCESS
    Mode: DIRECTORY_WITH_SUBDIRS
    Output: /commands/algorithmic-art.md
    Markdown Files Merged: 1
      - SKILL.md (2,134 chars)
    Subdirectories Copied: 1
      - templates/ (4 files, 15.2 KB)
    Files Excluded: 1
      - LICENSE.txt
    Path Updates: 0
    Notes: Template files preserved in subdirectory
```

---

## Command Format Specification

### Factory AI Slash Command Format

All output command files MUST comply with the Factory AI slash command specification.

**Format Structure:**
```markdown
---
description: One-line description under 80 characters for autocomplete
argument-hint: <optional-placeholder>
---

[Instructions TO the agent about what to do when this command is invoked]

## Section Title

[Content that guides the agent's behavior when executing this command]

Use $ARGUMENTS placeholder when the command accepts parameters.
```

### Key Requirements

**FR-2.0-10.1: YAML Frontmatter**
- MUST have `description` field (required)
- MAY have `argument-hint` field (optional)
- Description MUST be under 80 characters
- No other metadata fields required

**FR-2.0-10.2: Tone and Voice**
- Body content is instructions TO the agent (not user documentation)
- Use conversational, directive tone
- Tell the agent what to do, not what the command does

**FR-2.0-10.3: Argument Handling**
- Use `$ARGUMENTS` placeholder in body for user-provided arguments
- Example: "Use $ARGUMENTS to determine which template to load"

**FR-2.0-10.4: Section Structure**
- Use `##` for major sections (agent workflow steps)
- Use `**bold**` for subsections
- Use bullet points for action lists

### Example: Compliant Command File

```markdown
---
description: Generate algorithmic art from mathematical templates
argument-hint: <template-name>
---

When this command is invoked, generate beautiful algorithmic art using the specified template.

## Step 1: Load Template

Load the template file from `./algorithmic-art/templates/$ARGUMENTS.md`. If $ARGUMENTS is not provided, list available templates and ask the user to choose one.

## Step 2: Parse Template Parameters

Extract the following from the template:
- Algorithm type (fractal, geometric, parametric)
- Canvas dimensions
- Color palette
- Mathematical parameters

## Step 3: Generate Art

Execute the algorithm specified in the template:

**For fractal algorithms:**
- Apply recursive branching with depth parameter
- Use rotation angles from template

**For geometric patterns:**
- Generate shapes based on mathematical sequences
- Apply symmetry transformations

## Step 4: Output

Present the generated art code to the user with:
- Rendering instructions
- Parameter explanations
- Suggestions for variations

## Usage

**Basic usage:** `/algorithmic-art fractal-tree`
**List templates:** `/algorithmic-art`
```

---

## Implementation Plan

### Phase 1: Mode Detection (Week 1)

**Objectives:**
- Implement mode detection algorithm
- Add new data structures
- Create unit tests for mode detection

**Deliverables:**
- `ModeDetector` class
- `TransformationMode` enum
- Unit tests covering all scenarios
- Documentation of detection logic

**Success Criteria:**
- 100% accurate mode detection on test cases
- All edge cases handled (empty dirs, symlinks, etc.)

---

### Phase 2: Markdown Merging (Week 2)

**Objectives:**
- Implement markdown merging algorithm
- Handle frontmatter extraction and preservation
- Support multiple file integration

**Deliverables:**
- `MarkdownMerger` class
- Frontmatter handling utilities
- Integration tests with real skill samples

**Success Criteria:**
- Merged output follows specification exactly
- Frontmatter preserved from SKILL.md only
- Section headers correctly generated

---

### Phase 3: Subdirectory Handling (Week 3)

**Objectives:**
- Implement recursive directory copying
- Preserve file permissions (especially +x)
- Handle exclusions correctly

**Deliverables:**
- `SubdirectoryPreserver` class
- Permission preservation logic
- Integration tests with complex directory structures

**Success Criteria:**
- Executable scripts remain executable
- Directory structure preserved exactly
- Exclusions applied at all depths

---

### Phase 4: Path Updates (Week 4)

**Objectives:**
- Implement path detection in markdown
- Update paths correctly for relocated scripts
- Log all path transformations

**Deliverables:**
- `PathUpdater` class
- Regex patterns for path detection
- Path update logging

**Success Criteria:**
- All script references updated correctly
- No false positives (code examples not updated)
- Detailed logging of each update

---

### Phase 5: Integration & Testing (Week 5)

**Objectives:**
- Integrate all components
- Test with full skill library
- Performance optimization

**Deliverables:**
- Updated `SkillConverter` class
- Full integration tests
- Performance benchmarks
- Updated reporting

**Success Criteria:**
- All 22 skills process successfully
- Processing time < 30 seconds for full library
- Comprehensive test coverage (>90%)

---

### Phase 6: Documentation & Deployment (Week 6)

**Objectives:**
- Update user documentation
- Create migration guide from v1.0
- Deploy to production

**Deliverables:**
- Updated README
- Migration guide
- Version 2.0 release notes
- Deployment documentation

**Success Criteria:**
- Documentation complete and accurate
- Migration path clear for users
- Zero regression bugs from v1.0

---

## Testing Strategy

### Unit Testing

**Test Coverage Targets:**
- Mode detection: 100%
- Markdown merging: 100%
- Path updates: 100%
- Subdirectory copying: 95% (platform-specific edge cases)

**Key Test Cases:**

**Mode Detection:**
- Empty directory
- Only SKILL.md
- SKILL.md + subdirectories
- SKILL.md + root scripts
- No SKILL.md (multiple scenarios)
- Symbolic links
- Hidden directories (.git, __pycache__)

**Markdown Merging:**
- Single file (SKILL.md only)
- Two files (SKILL.md + one other)
- Multiple files (SKILL.md + 3+ others)
- Files with frontmatter
- Files without frontmatter
- Empty files
- Files with special characters

**Path Updates:**
- Relative paths (./script.sh)
- Absolute paths (/script.sh)
- Paths in code blocks (should NOT update)
- Paths in links
- Paths in plain text
- Multiple occurrences
- No occurrences (no updates needed)

**Subdirectory Copying:**
- Single subdirectory
- Multiple subdirectories
- Nested subdirectories (3+ levels)
- Executable files
- Binary files
- Symbolic links
- Permission preservation

### Integration Testing

**Test Scenarios:**

**Scenario 1: Full Library Processing**
- Process all 22 skills in test library
- Verify each output matches expected structure
- Check no files lost or corrupted
- Validate all transformations applied correctly

**Scenario 2: Error Recovery**
- Introduce permission errors
- Introduce corrupted files
- Introduce missing files
- Verify graceful degradation
- Verify PARTIAL_SUCCESS status applied correctly

**Scenario 3: Idempotency**
- Run converter twice on same input
- Verify identical output both times
- Verify no unintended side effects

**Scenario 4: Real-World Skills**
- Test with actual skill packages:
  - docx (complex subdirectories)
  - algorithmic-art (templates subdirectory)
  - root-cause-tracing (root script)
  - brainstorming (simple single-file)

### Performance Testing

**Benchmarks:**
- Single skill: < 500ms (average)
- 22 skills: < 15 seconds (total)
- Memory usage: < 100MB (peak for 22 skills)

**Load Testing:**
- 50 skills: < 30 seconds
- 100 skills: < 60 seconds
- Large files (10MB+): Should complete without errors

### Validation Testing

**Output Validation:**
- Markdown syntax validation (linting)
- YAML frontmatter validation
- File path existence checks
- Permission verification
- Factory AI format compliance

---

## Success Criteria

### Functional Success

**FS-1: Transformation Accuracy**
- ✅ 100% of skills processed (no crashes)
- ✅ 95%+ SUCCESS rate (PARTIAL_SUCCESS acceptable for known edge cases)
- ✅ All subdirectories preserved in DIRECTORY_WITH_SUBDIRS mode
- ✅ All scripts relocated in DIRECTORY_WITH_SCRIPTS mode
- ✅ All paths updated correctly when scripts moved

**FS-2: Output Quality**
- ✅ All output markdown files valid syntax
- ✅ All output markdown files have YAML frontmatter
- ✅ All merged files appear in correct order
- ✅ All subdirectories copied completely
- ✅ All executable permissions preserved

**FS-3: Format Compliance**
- ✅ All outputs comply with Factory AI slash command format
- ✅ Descriptions under 80 characters
- ✅ Tone is directive (instructions to agent)
- ✅ $ARGUMENTS placeholder used correctly

### Performance Success

**PS-1: Speed**
- ✅ Single skill: < 500ms average
- ✅ Full library (22 skills): < 15 seconds
- ✅ No timeout errors

**PS-2: Resource Usage**
- ✅ Memory: < 100MB peak for 22 skills
- ✅ Disk I/O: Efficient (no redundant reads)
- ✅ CPU: < 50% utilization on modern hardware

### Reliability Success

**RS-1: Error Handling**
- ✅ All errors logged with actionable messages
- ✅ No unhandled exceptions
- ✅ Graceful degradation on partial failures
- ✅ PARTIAL_SUCCESS status used appropriately

**RS-2: Idempotency**
- ✅ Running twice produces identical results
- ✅ No side effects from multiple runs
- ✅ Deterministic output (same input → same output)

### Usability Success

**US-1: Ease of Use**
- ✅ Single command execution: `python skill_to_command_converter.py`
- ✅ Clear progress indicators
- ✅ Detailed final report

**US-2: Documentation**
- ✅ README explains v2.0 features
- ✅ Migration guide from v1.0
- ✅ Examples for each transformation mode

### Validation Success

**VS-1: Manual Verification**
Sample 5 random outputs:
- ✅ Markdown renders correctly
- ✅ Subdirectories intact and functional
- ✅ Scripts executable
- ✅ Paths valid
- ✅ Content complete

**VS-2: Automated Validation**
- ✅ Unit tests: 100% pass rate
- ✅ Integration tests: 100% pass rate
- ✅ Linting: No markdown syntax errors
- ✅ YAML validation: All frontmatter valid

---

## Appendix A: Decision Matrix

### When to Use Each Mode

| Skill Characteristic | Mode | Reasoning |
|---------------------|------|-----------|
| Has subdirectories with content | DIRECTORY_WITH_SUBDIRS | Preserve structure for imports/references |
| Has root-level scripts only | DIRECTORY_WITH_SCRIPTS | Scripts need relocation, paths need update |
| Only SKILL.md exists | SINGLE_FILE | Simple rename, no merging needed |
| Multiple root .md files, no subdirs | SINGLE_FILE* | Merge into single file |
| Empty subdirectories | SINGLE_FILE | Ignore empty dirs, treat as single-file |

*Note: Multiple root markdown files trigger merging logic within SINGLE_FILE mode.

---

## Appendix B: File Type Reference

### Script Extensions (auto-detected)
- `.sh`, `.bash`, `.zsh` - Shell scripts
- `.py` - Python scripts
- `.js`, `.mjs` - JavaScript scripts
- `.ts` - TypeScript scripts
- `.rb` - Ruby scripts
- `.pl`, `.pm` - Perl scripts

### Always Excluded
- `LICENSE.txt`, `LICENSE`
- `.gitignore`, `.git/`
- `__pycache__/`, `.pyc`
- `.DS_Store`
- `node_modules/`

### Preserved in Subdirectories
- All file types
- Binary files
- Config files
- Documentation

---

## Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 2.0 | 2025-11-12 | PRD Development Team | Complete v2.0 specification with three transformation scenarios |

---

**End of PRD - Version 2.0**
