# Product Requirements Document (PRD)
## Skill-to-Command Converter Tool

**Version:** 1.1
**Date:** 2025-11-12
**Author:** PRD Creator Agent
**Updated:** 2025-11-12 (clarifications and error handling improvements)

---

## Table of Contents

1. [Product Overview](#product-overview)
2. [User Stories](#user-stories)
3. [Functional Requirements](#functional-requirements)
4. [Technical Specifications](#technical-specifications)
5. [Edge Cases](#edge-cases)
6. [Success Criteria](#success-criteria)
7. [Example Input/Output](#example-inputoutput)

---

## Product Overview

### Purpose

The Skill-to-Command Converter Tool is a Python-based command-line utility that automates the consolidation of skill directories into formatted command markdown files. This tool bridges the gap between modular skill documentation (spread across multiple files and subdirectories) and single-file command documentation that follows a standardized format.

### Problem Statement

Currently, skills are organized in directory structures with:
- Main SKILL.md documentation file
- Supporting reference documentation files
- Example files in subdirectories
- Code scripts and utilities
- Theme or configuration files

These need to be converted into single, well-formatted command markdown files that:
- Follow a specific YAML front matter + structured content format
- Integrate all relevant documentation contextually
- Are placed in a flat directory structure for easy access
- Maintain consistent formatting and section hierarchy

### Target Users

- Development team members who need to convert skill directories to command format
- Documentation maintainers who manage skill and command documentation
- CI/CD pipelines that automate documentation generation

### Key Benefits

1. **Automation**: Eliminates manual copy-paste and formatting work
2. **Consistency**: Ensures all command files follow the same structure and format
3. **Resilience**: Handles errors gracefully and continues processing
4. **Transparency**: Provides detailed logging and reporting of all operations
5. **Intelligence**: Automatically handles file naming conflicts and missing files

---

## User Stories

### Primary User Stories

**US-001: Batch Conversion**
```
As a documentation maintainer
I want to convert all skill directories to command files in one operation
So that I can quickly generate updated command documentation
```

**US-002: Error Resilience**
```
As a developer
I want the tool to handle errors gracefully and continue processing
So that one problematic skill doesn't block the entire batch conversion
```

**US-003: Detailed Reporting**
```
As a team member
I want to see a detailed report of what was processed
So that I can verify the conversion and identify any issues
```

**US-004: Format Consistency**
```
As a documentation consumer
I want all command files to follow the same format
So that I have a consistent experience across all commands
```

**US-005: Conflict Resolution**
```
As a developer
I want the tool to automatically handle naming conflicts
So that I don't have to manually rename files or troubleshoot collisions
```

### Secondary User Stories

**US-006: Selective File Integration**
```
As a documentation maintainer
I want to exclude specific file types (LICENSE, scripts, binaries)
So that only relevant content is included in the command files
```

**US-007: Subdirectory Handling**
```
As a developer
I want subdirectory content to be integrated contextually
So that themes, examples, and references are properly organized in the output
```

**US-008: Overwrite Protection with Reporting**
```
As a team member
I want to be notified when existing files are overwritten
So that I can track changes and prevent unintended data loss
```

---

## Functional Requirements

### FR-1: Input Processing

**FR-1.1: Directory Scanning (Skill Discovery - Non-Recursive)**
- The tool SHALL scan the input directory `/home/user/agentic-kit/packages/claude/skills/`
- The tool SHALL identify all **direct subdirectories only** (one level deep) as skill folders
- The tool SHALL NOT recurse into nested subdirectories for skill discovery
- SKILL.md MUST always be located in the parent folder (direct subdirectory of /skills/)
- The tool SHALL process each skill folder independently
- Example: `/skills/mcp-builder/` is a skill folder (contains SKILL.md), `/skills/mcp-builder/reference/` is NOT a separate skill

**FR-1.2: File Discovery (Within Skill - Recursive)**
- Once a skill folder is identified, the tool SHALL **recursively search** all subdirectories within that skill folder
- The tool SHALL locate the SKILL.md file in the skill's root directory (if present)
- The tool SHALL identify all markdown files (.md) at **any depth** within the skill folder
- The tool SHALL identify code files (.py, .js, .sh, .ts, etc.) at **any depth** for inclusion as code blocks
- The tool SHALL identify configuration files (.json, .yaml, .xml, etc.) at **any depth** for inclusion
- The tool SHALL exclude LICENSE.txt files (at any depth)
- The tool SHALL exclude binary executables and compiled files
- The tool SHALL **include** script files (.sh, .py, .js) even in nested subdirectories like `scripts/subfolder/build.sh`

**FR-1.2.1: File Discovery Examples**
```
/skills/mcp-builder/                    ← Skill folder (discovered at level 1)
├── SKILL.md                            ← Main skill file (must be here)
├── reference/
│   ├── doc1.md                         ← Integrate (found via recursive search)
│   └── subfolder/
│       └── doc2.md                     ← Integrate (found via recursive search)
├── scripts/
│   ├── build.sh                        ← Integrate as code block (recursive)
│   └── utils/
│       └── helper.py                   ← Integrate as code block (recursive)
└── LICENSE.txt                         ← Skip (at any depth)

/skills/pdf/                            ← Skill folder (discovered at level 1)
├── SKILL.md                            ← Main skill file (must be here)
├── forms.md                            ← Integrate
├── reference.md                        ← Integrate
└── scripts/
    └── nested/
        └── example.py                  ← Integrate as code block (recursive)
```

**Key Distinction:**
- **Skill Discovery**: Non-recursive, only direct children of /skills/
- **File Integration**: Recursive, search entire skill folder tree

**FR-1.3: File Reading**
- The tool SHALL read all identified markdown files
- The tool SHALL read relevant non-markdown text files (code examples, configs)
- The tool SHALL handle UTF-8 encoding
- The tool SHALL handle file read errors gracefully

### FR-2: Content Integration

**FR-2.1: File Processing Order**
- The tool SHALL process SKILL.md first (if present)
- The tool SHALL process remaining files in alphabetical order
- The tool SHALL maintain this order consistently across all skills

**FR-2.2: Content Consolidation**
- The tool SHALL extract YAML front matter from SKILL.md (if present)
- The tool SHALL preserve code blocks with proper markdown formatting
- The tool SHALL integrate reference documentation in appropriate sections
- The tool SHALL integrate example files in an Examples section
- The tool SHALL integrate code files with proper syntax highlighting
- The tool SHALL maintain the hierarchical structure from the sample format

**FR-2.3: Format Structure**
- The tool SHALL create output with the following structure:
  1. YAML front matter (with `description` and optional `argument-hint`)
  2. Brief summary paragraph
  3. Structured sections (Step 1, Step 2, etc., or similar hierarchy)
  4. Code examples in proper markdown code blocks
  5. Examples section (if applicable)
  6. Usage section at the end

**FR-2.4: Sample Format Reference**
- The tool SHALL read `/home/user/agentic-kit/packages/droid/commands/algorithmic-art.md` as a format template
- The tool SHALL match the section hierarchy style (## Step 1, ## Step 2, etc.)
- The tool SHALL match the YAML front matter format
- The tool SHALL match the code block formatting style

### FR-3: Output Generation

**FR-3.1: Output Directory**
- The tool SHALL create output files in `/home/user/agentic-kit/packages/claude/commands/`
- The tool SHALL create the commands/ directory if it doesn't exist
- The tool SHALL use **flat directory structure** - all output files at the same level (no subdirectories)
- Example: All skills output to `/commands/skill-name.md`, never `/commands/category/skill-name.md`

**FR-3.2: Skeleton Template**
- The tool SHALL create and maintain a skeleton template file: `COMMAND_SKELETON_TEMPLATE.md`
- The skeleton SHALL define the expected output structure:
  - YAML front matter format
  - Section hierarchy (Step 1, Step 2, Examples, Usage)
  - Code block formatting examples
  - Integration points for reference files
- The tool SHALL use this skeleton as a reference during conversion
- The skeleton SHALL be stored in the same directory as the converter script

**FR-3.3: File Naming**
- The tool SHALL use the skill directory name as the base filename
- The tool SHALL convert directory names to kebab-case (lowercase with hyphens)
- The tool SHALL append .md extension to output files
- Examples:
  - `mcp-builder/` → `mcp-builder.md`
  - `pdf/` → `pdf.md`
  - `theme-factory/` → `theme-factory.md`

**FR-3.4: Naming Conflict Resolution**
- The tool SHALL detect if an output filename would conflict
- The tool SHALL automatically append numeric suffixes (-2, -3, etc.) to resolve conflicts
- The tool SHALL report all name adjustments in the final report

**FR-3.5: File Writing**
- The tool SHALL write output files in UTF-8 encoding
- The tool SHALL overwrite existing files
- The tool SHALL track which files were overwritten for reporting

### FR-4: Error Handling

**FR-4.1: Error Recovery Strategy with Retry**
- The tool SHALL attempt to resolve errors programmatically first
- The tool SHALL **retry failed operations exactly once** before marking as error
- The tool SHALL log errors that cannot be resolved after retry
- The tool SHALL continue processing remaining folders after an error
- The tool SHALL NOT terminate the entire process due to a single folder error
- Example: If reading a file fails, wait briefly (0.5s) and retry once before moving on

**FR-4.2: Error Types to Handle**
- File not found errors (retry once)
- Permission errors (retry once)
- Encoding errors (try alternate encodings: utf-8, latin-1, cp1252)
- Malformed YAML errors (attempt to fix common issues like missing quotes)
- Empty file errors (skip and log)
- Directory access errors (retry once)

**FR-4.3: Missing SKILL.md Handling**
- The tool SHALL continue processing if SKILL.md is missing
- The tool SHALL attempt to generate front matter from other files
- The tool SHALL report missing SKILL.md files in the final report
- The tool SHALL still create output file with available content
- Status for these conversions: PARTIAL SUCCESS

### FR-5: Logging and Reporting

**FR-5.1: Processing Log**
- The tool SHALL log each skill folder being processed
- The tool SHALL log each file being read and integrated
- The tool SHALL log all errors encountered
- The tool SHALL log all automatic adjustments made

**FR-5.2: Final Report Structure**
- The report SHALL be divided into three main sections:
  1. **Summary Statistics** (top of report)
  2. **Successful Conversions** (with brief comments)
  3. **Failed Conversions** (with detailed error descriptions)

**FR-5.3: Summary Statistics Section**
- Total skills processed (count)
- Successful conversions (count)
- Partial successes (count)
- Failed conversions (count)
- Total files processed (count)
- Total errors encountered (count)
- Total retries attempted (count)

**FR-5.4: Successful Conversions Section**
- List each successful skill with:
  - Skill Name
  - Output File path
  - Files Processed count
  - Brief comments (e.g., "Overwritten existing file", "Included 3 reference docs", "Integrated 10 theme files")

**FR-5.5: Failed Conversions Section**
- List each failed/partial success skill with:
  - Skill Name
  - Status (FAILED or PARTIAL SUCCESS)
  - Detailed error descriptions
  - Retry attempts made
  - Files that were successfully processed (if any)
  - Specific errors encountered (file names, error types)
  - Suggestions for manual resolution

**FR-5.6: Report Format**
- The tool SHALL output the report to console/stdout
- The tool SHALL use clear section headers with visual separation
- The tool SHALL use structured format with consistent indentation
- The tool SHALL highlight failed conversions for easy identification

**FR-5.7: Report Example**
```
=============================================================
SKILL-TO-COMMAND CONVERSION REPORT
=============================================================

SUMMARY STATISTICS:
- Total Skills Processed: 23
- Successful Conversions: 20
- Partial Successes: 2
- Failed Conversions: 1
- Total Files Processed: 147
- Total Errors: 3
- Total Retries Attempted: 5

=============================================================
SUCCESSFUL CONVERSIONS (20)
=============================================================

[1] mcp-builder
    Output: /commands/mcp-builder.md
    Files: 6 (SKILL.md + 5 reference docs)
    Comments: Included scripts/build.sh as code block, Skipped LICENSE.txt

[2] pdf
    Output: /commands/pdf.md
    Files: 4 (SKILL.md + forms.md + reference.md + scripts/example.py)
    Comments: Overwritten existing file, Included example.py as code block

[3] theme-factory
    Output: /commands/theme-factory.md
    Files: 11 (SKILL.md + 10 theme files)
    Comments: Integrated all theme files into Examples section

[4] xlsx
    Output: /commands/xlsx.md
    Files: 3 (SKILL.md + 2 reference docs)
    Comments: Standard conversion, no issues

... [showing first 4 of 20 successful conversions]

=============================================================
FAILED / PARTIAL SUCCESS CONVERSIONS (3)
=============================================================

[PARTIAL SUCCESS] brainstorming
    Output: /commands/brainstorming.md
    Files Processed: 2 (brainstorming-guide.md, examples.md)

    Issues:
    - WARNING: No SKILL.md found in directory
    - Generated front matter from brainstorming-guide.md
    - Missing standard structure, may need manual review

    Retry Attempts: 1 (tried to locate SKILL.md in subdirs)

[FAILED] problematic-skill
    Output: N/A
    Files Processed: 0

    Errors:
    - ERROR: Permission denied accessing directory
    - Retry #1: Permission denied (failed again after 0.5s wait)
    - Unable to read any files from this skill directory

    Suggestions:
    - Check directory permissions
    - Verify ownership of /skills/problematic-skill/
    - Run with appropriate permissions or fix directory access

[PARTIAL SUCCESS] incomplete-skill
    Output: /commands/incomplete-skill.md
    Files Processed: 1 (SKILL.md only)

    Issues:
    - WARNING: Reference files mentioned in SKILL.md not found
    - ERROR: Could not read reference/missing-doc.md (file not found)
    - Retry #1: Still not found after retry
    - Output created but incomplete

    Suggestions:
    - Check if reference files exist
    - Update SKILL.md to remove references to missing files

=============================================================
```

### FR-6: Command-Line Interface

**FR-6.1: Basic Execution**
- The tool SHALL be executable via: `python skill_to_command_converter.py`
- The tool SHALL not require command-line arguments (uses hardcoded paths)
- The tool SHALL display progress during execution

**FR-6.2: Optional Arguments (Future Enhancement)**
- `--input-dir`: Override default input directory
- `--output-dir`: Override default output directory
- `--sample-format`: Override default sample format file
- `--dry-run`: Preview changes without writing files
- `--verbose`: Show detailed processing logs
- `--quiet`: Show only final report

### FR-7: Skeleton Template Creation

**FR-7.1: Template File Generation**
- The tool SHALL create a file named `COMMAND_SKELETON_TEMPLATE.md` in the same directory as the script
- The skeleton SHALL be created on first run if it doesn't exist
- The skeleton SHALL serve as a reference structure for the conversion process

**FR-7.2: Template Structure**
The skeleton SHALL include:
```markdown
---
description: [Brief description of what this command does]
argument-hint: [Optional hint for command arguments]
---

[One-line summary paragraph about the skill/command]

## Step 1: [First Major Step]

[Description of the first step]

**Key Points:**
- Bullet point 1
- Bullet point 2

## Step 2: [Second Major Step]

[Description of the second step]

**Code Example:**
```language
// Example code here
```

## Step 3: [Additional Steps as Needed]

[Continue with logical steps]

## Examples

**Example 1: [Example Name]**
Description and code/output

**Example 2: [Another Example]**
Description and code/output

## Usage

**Basic usage:** `/command-name [arguments]`
**Advanced usage:** `/command-name [advanced-arguments]`

[Additional usage notes]
```

**FR-7.3: Template Usage**
- The conversion logic SHALL reference this template structure
- Code SHALL extract section patterns from the template
- The tool SHALL use the template to determine where to place integrated content

---

## Technical Specifications

### TS-1: Technology Stack

**TS-1.1: Programming Language**
- Python 3.8 or higher

**TS-1.2: Core Libraries**
- `os` - Directory and file operations
- `pathlib` - Modern path handling
- `re` - Regular expressions for text processing
- `yaml` - YAML front matter parsing (PyYAML)
- `glob` - File pattern matching
- `json` - Report formatting option
- Standard library only (no external dependencies initially)

**TS-1.3: Optional Libraries**
- `markdown` - For advanced markdown parsing (if needed)
- `frontmatter` - Specialized YAML front matter handling (python-frontmatter)

### TS-2: Architecture

**TS-2.1: Modular Design**
```python
# Main components:
class SkillProcessor:
    """Handles processing of individual skill directories"""

class FileIntegrator:
    """Integrates multiple files into single output"""

class FormatParser:
    """Parses sample format file and applies structure"""

class ConflictResolver:
    """Handles naming conflicts and file adjustments"""

class ReportGenerator:
    """Generates detailed processing reports"""

class ErrorHandler:
    """Manages error recovery and logging"""
```

**TS-2.2: Data Flow**
```
Input Directory
    ↓
Skill Directory Scanner
    ↓
For Each Skill:
    ↓
File Discovery → File Filter → File Reader
    ↓
Content Parser → Content Integrator → Format Applier
    ↓
Output Generator → Conflict Resolver → File Writer
    ↓
Report Logger
    ↓
Final Report
```

**TS-2.3: Key Algorithms**

1. **File Integration Algorithm**
```python
def integrate_skill_files(skill_dir, sample_format):
    """
    1. Read SKILL.md and extract front matter
    2. Parse sample format to understand structure
    3. Read remaining files alphabetically
    4. Categorize files by type:
       - Reference docs → Step sections
       - Examples → Examples section
       - Code files → Code examples with syntax
    5. Assemble output following sample structure
    6. Add Usage section at end
    """
```

2. **Conflict Resolution Algorithm**
```python
def resolve_naming_conflict(base_name, output_dir):
    """
    1. Check if base_name.md exists in output_dir
    2. If not, return base_name.md
    3. If yes, try base_name-2.md, base_name-3.md, etc.
    4. Return first available name
    5. Log adjustment for reporting
    """
```

3. **Error Recovery Algorithm**
```python
def process_with_recovery(skill_dir):
    """
    1. Try to read SKILL.md
       - If fails, set flag and continue
    2. Try to read each additional file
       - If fails, log error and skip that file
    3. If no files readable, mark skill as FAILED
    4. If some files readable, mark as PARTIAL SUCCESS
    5. If all files readable, mark as SUCCESS
    6. Continue to next skill regardless of status
    """
```

### TS-3: File Structure

**TS-3.1: Input Directory Structure**
```
/home/user/agentic-kit/packages/claude/skills/
├── skill-name-1/
│   ├── SKILL.md
│   ├── reference.md
│   ├── examples.md
│   ├── LICENSE.txt (skip)
│   ├── scripts/ (skip)
│   └── subdirectory/
│       └── additional-content.md
├── skill-name-2/
│   ├── SKILL.md
│   ├── reference/
│   │   ├── doc1.md
│   │   └── doc2.md
│   ├── scripts/ (skip)
│   └── LICENSE.txt (skip)
└── ...
```

**TS-3.2: Output Directory Structure**
```
/home/user/agentic-kit/packages/claude/commands/
├── skill-name-1.md
├── skill-name-2.md
├── skill-name-3.md
└── ...
```

**TS-3.3: Output File Format**
```markdown
---
description: Brief description from SKILL.md
argument-hint: <optional-argument-format>
---

Brief summary paragraph introducing the command.

## Step 1: First Major Section

Detailed content from SKILL.md or integrated from reference files.

**Subsection:**
- Bullet points
- Additional details

```python
# Code examples from code files or inline examples
def example_function():
    pass
```

## Step 2: Second Major Section

More structured content...

## Examples

**Example Name:**
Description and code from examples.md or example files.

**Another Example:**
More examples...

## Usage

**Basic usage:** `/command-name argument`
**Advanced usage:** `/command-name --option argument`
```

### TS-4: Data Structures

**TS-4.1: Skill Processing Result**
```python
@dataclass
class ProcessingResult:
    skill_name: str
    status: str  # "SUCCESS", "PARTIAL_SUCCESS", "FAILED"
    output_file: Optional[str]
    files_processed: List[str]
    files_skipped: List[str]
    notes: List[str]
    errors: List[str]
```

**TS-4.2: Conversion Report**
```python
@dataclass
class ConversionReport:
    total_skills: int
    successful: int
    partial_success: int
    failed: int
    total_files_processed: int
    total_errors: int
    results: List[ProcessingResult]
```

### TS-5: Configuration

**TS-5.1: Hardcoded Paths**
```python
INPUT_DIR = "/home/user/agentic-kit/packages/claude/skills/"
OUTPUT_DIR = "/home/user/agentic-kit/packages/claude/commands/"
SAMPLE_FORMAT = "/home/user/agentic-kit/packages/droid/commands/algorithmic-art.md"
```

**TS-5.2: File Exclusion Patterns**
```python
EXCLUDE_FILES = ["LICENSE.txt"]
EXCLUDE_DIRS = ["scripts"]
EXCLUDE_EXTENSIONS = [".pyc", ".exe", ".bin", ".so", ".dll", ".pdf", ".png", ".jpg", ".jpeg", ".gif"]
```

**TS-5.3: Processing Rules**
```python
RULES = {
    "process_skill_md_first": True,
    "alphabetical_order": True,
    "create_output_dir": True,
    "overwrite_existing": True,
    "continue_on_error": True,
}
```

### TS-6: Performance Considerations

**TS-6.1: Scalability**
- Tool should handle 50+ skill directories efficiently
- Each skill may have 10-20 files
- Total processing time target: < 30 seconds for 50 skills

**TS-6.2: Memory Management**
- Process files sequentially to avoid loading all content into memory
- Stream large files if necessary
- Clear processed content after writing output

**TS-6.3: Error Handling Performance**
- Set reasonable timeouts for file operations
- Avoid retry loops that could hang processing
- Limit error log size per skill

---

## Edge Cases

### EC-1: Missing SKILL.md

**Scenario**: A skill directory has no SKILL.md file

**Handling**:
- Continue processing other markdown files in alphabetical order
- Generate minimal front matter from directory name and first file
- Log warning in report: "WARNING: No SKILL.md found"
- Status: PARTIAL SUCCESS (if other files exist)

**Example**:
```
Input: brainstorming/
       ├── guide.md
       └── examples.md
       (no SKILL.md)

Output: brainstorming.md with:
---
description: Guide for brainstorming (auto-generated)
---
[Content from guide.md and examples.md]

Report: WARNING: No SKILL.md found, generated basic front matter
```

### EC-2: Duplicate Filenames

**Scenario**: Multiple subdirectories contain files with same name

**Handling**:
- Process all files (don't skip duplicates)
- Organize by subdirectory in output (mention source in section headers)
- Log that duplicate names were handled
- Status: SUCCESS

**Example**:
```
Input: skill/
       ├── examples/example1.md
       └── reference/example1.md

Output: Include both as:
## Examples - examples/

## Examples - reference/
```

### EC-3: Empty Files

**Scenario**: A markdown file exists but is empty

**Handling**:
- Skip the file silently
- Log as "Skipped: filename.md (empty file)"
- Don't count toward files_processed
- Status: Depends on other files (SUCCESS if others exist)

### EC-4: Malformed YAML Front Matter

**Scenario**: SKILL.md has invalid YAML in front matter

**Handling**:
- Attempt to extract description using regex fallback
- Log error: "ERROR: Malformed YAML in SKILL.md, used fallback parsing"
- Continue processing with best-effort front matter
- Status: PARTIAL SUCCESS

### EC-5: Permission Denied

**Scenario**: Cannot read skill directory or files due to permissions

**Handling**:
- Log error: "ERROR: Permission denied accessing [path]"
- Try to process remaining accessible files in directory
- If no files accessible, mark skill as FAILED
- Continue to next skill
- Status: FAILED (if directory inaccessible) or PARTIAL SUCCESS (if some files accessible)

### EC-6: Non-UTF-8 Encoding

**Scenario**: A file uses different encoding (Latin-1, ASCII with special chars, etc.)

**Handling**:
- Try UTF-8 first
- If fails, try chardet library to detect encoding
- If detection fails, try Latin-1 as fallback
- If all fail, log error and skip file
- Log: "WARNING: Used [encoding] for filename.md"
- Status: PARTIAL SUCCESS if other files processed

### EC-7: Extremely Large Files

**Scenario**: A markdown file is unusually large (>10MB)

**Handling**:
- Log warning: "WARNING: Large file detected (filesize), processing may be slow"
- Consider truncating content with note: "[Content truncated due to size]"
- Or process normally if system can handle it
- Status: SUCCESS with note

### EC-8: Binary Files Not in Exclusion List

**Scenario**: A .dat or other binary file not explicitly excluded

**Handling**:
- Detect binary content by checking for null bytes
- Skip binary files automatically
- Log: "Skipped: filename.dat (binary file)"
- Status: SUCCESS (binary files don't affect status)

### EC-9: Circular Symlinks

**Scenario**: Skill directory contains symbolic links creating loops

**Handling**:
- Use `pathlib.resolve()` to detect symlinks
- Set max depth limit for directory traversal
- Skip symlinks that create loops
- Log: "WARNING: Skipped symlink [path] (circular reference)"
- Status: SUCCESS

### EC-10: Output Directory Not Writable

**Scenario**: Cannot create or write to output directory

**Handling**:
- Attempt to create directory with proper permissions
- If fails, log critical error and abort entire process
- Display error message to user
- Exit with non-zero status code
- (This is a critical failure that prevents all processing)

### EC-11: Naming Conflict with 100+ Suffixes

**Scenario**: Base filename has conflicts up to file-100.md

**Handling**:
- Continue incrementing: file-101.md, file-102.md, etc.
- No hard limit on suffix number
- Log: "WARNING: High number of naming conflicts for [base]"
- Status: SUCCESS

### EC-12: Special Characters in Directory Names

**Scenario**: Skill directory name has spaces, special chars: "My Skill (Beta)!"

**Handling**:
- Sanitize filename: convert to kebab-case
- "My Skill (Beta)!" → "my-skill-beta.md"
- Log: "Adjusted filename: 'My Skill (Beta)!' → 'my-skill-beta.md'"
- Status: SUCCESS with note

### EC-13: No Markdown Files in Directory

**Scenario**: Skill directory exists but contains no .md files

**Handling**:
- Check for other text files (.txt, .rst)
- If found, process those
- If no text files, mark as FAILED
- Log: "ERROR: No markdown or text files found in [skill_name]"
- Status: FAILED

### EC-14: Subdirectories Only, No Root Files

**Scenario**: All content is in subdirectories, no files in root

**Handling**:
- Process subdirectory files normally
- Generate basic front matter from directory name
- Log: "WARNING: No root-level SKILL.md, processed subdirectories"
- Status: SUCCESS (if subdirectory files found)

### EC-15: Code Blocks Without Language Specification

**Scenario**: Markdown contains ``` without language identifier

**Handling**:
- Preserve code blocks as-is
- Optionally attempt to detect language from content
- Don't modify original content
- Status: SUCCESS

---

## Success Criteria

### SC-1: Functional Success Metrics

**SC-1.1: Processing Completeness**
- ✅ 100% of accessible skill directories are processed
- ✅ At least 95% result in SUCCESS or PARTIAL SUCCESS status
- ✅ No premature termination of batch processing

**SC-1.2: Output Quality**
- ✅ All output files have valid markdown syntax
- ✅ All output files have YAML front matter with at least `description`
- ✅ All output files follow the sample format structure
- ✅ Code blocks maintain proper syntax highlighting
- ✅ Section hierarchy matches sample (## Step N format)

**SC-1.3: Error Handling**
- ✅ All errors are logged with descriptive messages
- ✅ Process continues after encountering errors
- ✅ At least 90% of files per skill are successfully processed (when accessible)

**SC-1.4: Reporting**
- ✅ Final report includes all required fields
- ✅ Report clearly distinguishes between SUCCESS, PARTIAL SUCCESS, and FAILED
- ✅ All file operations (skipped, overwritten, renamed) are reported
- ✅ Summary statistics are accurate

### SC-2: Performance Success Metrics

**SC-2.1: Speed**
- ✅ Processes 50 skills in under 30 seconds
- ✅ Individual skill processing takes less than 1 second (average)

**SC-2.2: Resource Usage**
- ✅ Memory usage stays under 500MB for 50 skills
- ✅ No memory leaks during extended operation

### SC-3: Reliability Success Metrics

**SC-3.1: Consistency**
- ✅ Running tool twice produces identical results (deterministic)
- ✅ Alphabetical ordering is consistent across runs
- ✅ Naming conflict resolution is deterministic

**SC-3.2: Robustness**
- ✅ Handles all edge cases gracefully
- ✅ No unhandled exceptions crash the program
- ✅ Tool recovers from file system errors

### SC-4: Usability Success Metrics

**SC-4.1: Ease of Use**
- ✅ Tool runs with single command: `python skill_to_command_converter.py`
- ✅ No configuration files required
- ✅ Clear progress indication during execution

**SC-4.2: Output Clarity**
- ✅ Report is easy to read and understand
- ✅ Errors are actionable (user knows what to fix)
- ✅ Summary provides at-a-glance status

### SC-5: Validation Criteria

**SC-5.1: Manual Verification**
- ✅ Random sampling of 5 output files shows correct format
- ✅ All SKILL.md content is preserved in output
- ✅ Examples and reference docs are properly integrated
- ✅ Code blocks render correctly in markdown viewers

**SC-5.2: Automated Testing**
- ✅ Unit tests pass for all core functions
- ✅ Integration tests pass for sample skill directories
- ✅ Edge case tests pass for all identified edge cases

---

## Example Input/Output

### Example 1: Standard Skill with SKILL.md and References

**Input Structure:**
```
/home/user/agentic-kit/packages/claude/skills/mcp-builder/
├── SKILL.md
├── LICENSE.txt
├── reference/
│   ├── evaluation.md
│   ├── mcp_best_practices.md
│   ├── node_mcp_server.md
│   └── python_mcp_server.md
└── scripts/
    ├── evaluation.py
    ├── connections.py
    └── requirements.txt
```

**Processing Steps:**
1. Read SKILL.md, extract front matter and content
2. Skip LICENSE.txt
3. Skip scripts/ directory
4. Read reference/*.md files alphabetically
5. Integrate all content following sample format

**Output File:**
```
/home/user/agentic-kit/packages/claude/commands/mcp-builder.md
```

**Output Content (Excerpt):**
```markdown
---
description: Guide for creating high-quality MCP (Model Context Protocol) servers that enable LLMs to interact with external services through well-designed tools. Use when building MCP servers to integrate external APIs or services, whether in Python (FastMCP) or Node/TypeScript (MCP SDK).
---

To create high-quality MCP (Model Context Protocol) servers that enable LLMs to effectively interact with external services, use this skill.

## Step 1: Deep Research and Planning

### Understand Agent-Centric Design Principles

Before diving into implementation, understand how to design tools for AI agents by reviewing these principles...

[Content from SKILL.md]

### Study Framework Documentation

**Load and read the following reference files:**

[Content from reference/mcp_best_practices.md]

## Step 2: Implementation

[Content integrated from reference/python_mcp_server.md and reference/node_mcp_server.md]

## Step 3: Evaluation

[Content from reference/evaluation.md]

## Examples

[Examples extracted from SKILL.md or reference docs]

## Usage

**Create Python MCP server:** `/mcp-builder --lang python service-name`
**Create TypeScript MCP server:** `/mcp-builder --lang typescript service-name`
```

**Report Entry:**
```
[1] mcp-builder
    Status: SUCCESS
    Output: /home/user/agentic-kit/packages/claude/commands/mcp-builder.md
    Files Processed: 5
    - SKILL.md
    - reference/evaluation.md
    - reference/mcp_best_practices.md
    - reference/node_mcp_server.md
    - reference/python_mcp_server.md
    Notes:
    - Skipped: LICENSE.txt
    - Skipped: scripts/ directory (3 files)
```

---

### Example 2: Skill with Themes in Subdirectory

**Input Structure:**
```
/home/user/agentic-kit/packages/claude/skills/theme-factory/
├── SKILL.md
├── LICENSE.txt
├── theme-showcase.pdf
└── themes/
    ├── arctic-frost.md
    ├── botanical-garden.md
    ├── desert-rose.md
    ├── forest-canopy.md
    ├── golden-hour.md
    ├── midnight-galaxy.md
    ├── modern-minimalist.md
    ├── ocean-depths.md
    ├── sunset-boulevard.md
    └── tech-innovation.md
```

**Processing Steps:**
1. Read SKILL.md for front matter and main content
2. Skip LICENSE.txt
3. Skip theme-showcase.pdf (binary)
4. Read all themes/*.md files alphabetically
5. Integrate themes into Examples section

**Output File:**
```
/home/user/agentic-kit/packages/claude/commands/theme-factory.md
```

**Output Content (Excerpt):**
```markdown
---
description: Generate professional color themes for web applications, presentations, and design systems
argument-hint: <theme-style>
---

Create beautiful, accessible color themes for your projects with this comprehensive theme generation tool.

## Step 1: Understanding Theme Components

[Content from SKILL.md explaining theme structure]

## Step 2: Generating Custom Themes

[Content from SKILL.md about generation process]

## Examples

### Arctic Frost Theme

[Content from themes/arctic-frost.md]

### Botanical Garden Theme

[Content from themes/botanical-garden.md]

### Desert Rose Theme

[Content from themes/desert-rose.md]

[... all other themes ...]

## Usage

**Generate arctic theme:** `/theme-factory arctic-frost`
**Generate custom theme:** `/theme-factory sunset-boulevard`
**Create new theme:** `/theme-factory "ocean waves"`
```

**Report Entry:**
```
[2] theme-factory
    Status: SUCCESS
    Output: /home/user/agentic-kit/packages/claude/commands/theme-factory.md
    Files Processed: 11
    - SKILL.md
    - themes/arctic-frost.md
    - themes/botanical-garden.md
    - themes/desert-rose.md
    - themes/forest-canopy.md
    - themes/golden-hour.md
    - themes/midnight-galaxy.md
    - themes/modern-minimalist.md
    - themes/ocean-depths.md
    - themes/sunset-boulevard.md
    - themes/tech-innovation.md
    Notes:
    - Skipped: LICENSE.txt
    - Skipped: theme-showcase.pdf (binary file)
```

---

### Example 3: Skill Missing SKILL.md

**Input Structure:**
```
/home/user/agentic-kit/packages/claude/skills/brainstorming/
├── brainstorming-guide.md
├── examples.md
└── techniques.md
```

**Processing Steps:**
1. Detect SKILL.md is missing
2. Read brainstorming-guide.md first
3. Extract title/description from first heading
4. Generate basic front matter
5. Read examples.md and techniques.md alphabetically
6. Assemble output with available content

**Output File:**
```
/home/user/agentic-kit/packages/claude/commands/brainstorming.md
```

**Output Content (Excerpt):**
```markdown
---
description: Comprehensive brainstorming guide and techniques
---

[Content from brainstorming-guide.md]

## Techniques

[Content from techniques.md]

## Examples

[Content from examples.md]

## Usage

**Start brainstorming:** `/brainstorming topic`
```

**Report Entry:**
```
[3] brainstorming
    Status: PARTIAL SUCCESS
    Output: /home/user/agentic-kit/packages/claude/commands/brainstorming.md
    Files Processed: 3
    - brainstorming-guide.md
    - examples.md
    - techniques.md
    Notes:
    - WARNING: No SKILL.md found
    - Generated front matter from first file
```

---

### Example 4: Error Handling Example

**Input Structure:**
```
/home/user/agentic-kit/packages/claude/skills/problematic-skill/
├── SKILL.md (permission denied)
├── reference.md (corrupted encoding)
└── examples/ (empty directory)
```

**Processing Steps:**
1. Try to read SKILL.md → Permission denied → Log error
2. Try to read reference.md → Encoding error → Try fallback encoding → Success
3. Check examples/ → Empty → Skip
4. Generate output with available content
5. Mark as PARTIAL SUCCESS

**Output File:**
```
/home/user/agentic-kit/packages/claude/commands/problematic-skill.md
```

**Output Content (Excerpt):**
```markdown
---
description: Problematic skill (auto-generated)
---

[Content from reference.md]

## Usage

**Use command:** `/problematic-skill`
```

**Report Entry:**
```
[4] problematic-skill
    Status: PARTIAL SUCCESS
    Output: /home/user/agentic-kit/packages/claude/commands/problematic-skill.md
    Files Processed: 1
    - reference.md
    Notes:
    - ERROR: Permission denied reading SKILL.md
    - WARNING: Used Latin-1 encoding for reference.md
    - WARNING: No SKILL.md found, generated basic front matter
    - Skipped: examples/ (empty directory)
```

---

### Example 5: Complete Failure Example

**Input Structure:**
```
/home/user/agentic-kit/packages/claude/skills/inaccessible-skill/
(entire directory has permission denied)
```

**Processing Steps:**
1. Try to access directory → Permission denied
2. Cannot list files → Log error
3. Mark skill as FAILED
4. Continue to next skill

**Output File:**
```
None (no file created)
```

**Report Entry:**
```
[5] inaccessible-skill
    Status: FAILED
    Output: N/A
    Files Processed: 0
    Notes:
    - ERROR: Permission denied accessing directory
    - ERROR: Unable to read any files
    - Skipped to next skill
```

---

### Example 6: Naming Conflict Resolution

**Input Structure:**
```
/home/user/agentic-kit/packages/claude/skills/pdf/
├── SKILL.md
└── reference.md
```

**Existing Output Files:**
```
/home/user/agentic-kit/packages/claude/commands/
├── pdf.md (already exists)
└── pdf-2.md (already exists)
```

**Processing Steps:**
1. Generate base filename: pdf.md
2. Check if pdf.md exists → Yes
3. Try pdf-2.md → Exists
4. Try pdf-3.md → Available
5. Use pdf-3.md as output filename
6. Log adjustment

**Output File:**
```
/home/user/agentic-kit/packages/claude/commands/pdf-3.md
```

**Report Entry:**
```
[6] pdf
    Status: SUCCESS
    Output: /home/user/agentic-kit/packages/claude/commands/pdf-3.md
    Files Processed: 2
    - SKILL.md
    - reference.md
    Notes:
    - Adjusted filename: 'pdf.md' → 'pdf-3.md' (conflict resolution)
```

---

### Example 7: Sample Format Analysis

**Sample Format File:**
```
/home/user/agentic-kit/packages/droid/commands/algorithmic-art.md
```

**Key Structure Elements to Extract:**
```markdown
---
description: [description text]
argument-hint: [argument format]
---

[Summary paragraph]

## Step 1: [Step Title]

**Subsection Title:**
- Bullet point
- Bullet point

```[language]
// Code example
```

## Step 2: [Step Title]

[Content...]

## Examples

**Example Name:**
Description...

## Usage

**Usage description:** `/command argument`
```

**Application:**
- Extract section hierarchy pattern (## Step N)
- Identify subsection patterns (** bold markers)
- Recognize code block format with language tags
- Note Examples section structure
- Understand Usage section placement at end

---

## Appendix: Implementation Phases

### Phase 1: Core Implementation (Week 1)
- [ ] Set up project structure
- [ ] Implement directory scanning
- [ ] Implement file reading with error handling
- [ ] Implement basic file integration
- [ ] Implement output file writing
- [ ] Create basic reporting

### Phase 2: Format Matching (Week 2)
- [ ] Parse sample format file
- [ ] Extract structure patterns
- [ ] Implement YAML front matter handling
- [ ] Implement section hierarchy matching
- [ ] Implement code block preservation
- [ ] Add Examples section generation

### Phase 3: Advanced Features (Week 3)
- [ ] Implement naming conflict resolution
- [ ] Add subdirectory content integration
- [ ] Implement file type detection and filtering
- [ ] Add encoding detection and fallback
- [ ] Enhance error recovery mechanisms
- [ ] Improve logging detail

### Phase 4: Polish and Testing (Week 4)
- [ ] Create unit tests for all components
- [ ] Create integration tests with sample skills
- [ ] Test all edge cases
- [ ] Optimize performance
- [ ] Generate comprehensive documentation
- [ ] Create usage guide

---

## Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2025-11-12 | PRD Creator Agent | Initial comprehensive PRD created |

---

**End of PRD**
