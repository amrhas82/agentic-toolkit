# Development Tasks: Skill-to-Command Converter

**Project:** Python script to convert Claude skill directories into command markdown files

**PRD Location:** `/home/user/agentic-kit/skill-to-command/tasks/PRD_skill_to_command_converter.md`

**Script Location:** `/home/user/agentic-kit/skill_to_command_converter.py`

---

## Relevant Files

### Files to Create:
1. `/home/user/agentic-kit/skill_to_command_converter.py` - Main converter script
2. `/home/user/agentic-kit/COMMAND_SKELETON_TEMPLATE.md` - Template for output structure

### Files to Read (Input):
1. `/home/user/agentic-kit/packages/claude/skills/` - Source skill directories (non-recursive discovery)
2. `/home/user/agentic-kit/packages/droid/commands/algorithmic-art.md` - Sample format reference

### Files to Write (Output):
1. `/home/user/agentic-kit/packages/claude/commands/*.md` - Generated command files (flat structure)

### Dependencies:
- Python 3.8+
- Standard library modules: `os`, `pathlib`, `re`, `yaml`, `glob`, `json`, `dataclasses`, `typing`
- Optional: `chardet` for encoding detection (fallback to Latin-1/cp1252 if not available)

---

## Implementation Notes

### Key Design Decisions:

1. **Two-Level Discovery Strategy:**
   - **Level 1 (Non-Recursive)**: Discover skill directories - only direct children of `/packages/claude/skills/`
   - **Level 2 (Recursive)**: Within each skill, recursively search all subdirectories for files to integrate
   - SKILL.md MUST be in the skill's root directory (Level 1), never in subdirectories

2. **Modular Architecture:**
   - Use dataclasses for data structures (`ProcessingResult`, `ConversionReport`)
   - Separate concerns into focused classes (SkillProcessor, FileIntegrator, FormatParser, etc.)
   - Each class handles one aspect of the conversion pipeline

3. **Error Recovery Philosophy:**
   - **Retry once**: All file operations retry exactly once with 0.5s delay on failure
   - **Continue processing**: Never terminate entire batch due to single skill failure
   - **Status levels**: SUCCESS, PARTIAL_SUCCESS (missing SKILL.md or some files), FAILED (no output)
   - **Graceful degradation**: Generate output with available content even if some files fail

4. **Content Integration Strategy:**
   - Parse sample format file (`algorithmic-art.md`) to extract structure patterns
   - SKILL.md always processed first (if present)
   - Remaining files processed alphabetically
   - Reference docs → Step sections
   - Example files → Examples section
   - Code files → Code blocks with syntax highlighting
   - Usage section always at the end

5. **File Exclusion Rules:**
   - Exclude LICENSE.txt at any depth
   - Exclude binary files (detect via null bytes, common extensions)
   - Exclude scripts/ directories (but include scripts as code examples if in other locations)
   - Skip empty files silently

6. **Naming and Conflicts:**
   - Convert directory names to kebab-case
   - Detect conflicts, append numeric suffixes (-2, -3, etc.)
   - Log all filename adjustments
   - Overwrite existing files (with logging)

7. **Reporting Structure:**
   - Summary statistics at top
   - Successful conversions (brief comments)
   - Failed/Partial conversions (detailed errors with retry info)
   - Clear visual separation between sections

---

## Task 1: Setup Project Infrastructure

**Objective:** Establish the foundational structure for the converter script

### Subtask 1.1: Create Main Script File and Basic Structure (1 hour)

**Details:**
- Create `/home/user/agentic-kit/skill_to_command_converter.py`
- Add shebang line: `#!/usr/bin/env python3`
- Add module docstring explaining the tool's purpose
- Add all necessary imports:
  ```python
  import os
  import sys
  from pathlib import Path
  from dataclasses import dataclass, field
  from typing import List, Optional, Dict, Set
  import re
  import glob
  import json
  import time
  ```
- Try importing `yaml` (PyYAML), provide helpful error message if not installed
- Try importing `chardet` for encoding detection (optional, note if missing)
- Add `if __name__ == "__main__":` block for script execution

**Acceptance Criteria:**
- Script file exists and is executable
- All standard library imports work
- Helpful messages if optional dependencies missing
- Basic structure in place for adding code

---

### Subtask 1.2: Define Configuration Constants (1 hour)

**Details:**
- Define all hardcoded paths as module-level constants:
  ```python
  INPUT_DIR = Path("/home/user/agentic-kit/packages/claude/skills/")
  OUTPUT_DIR = Path("/home/user/agentic-kit/packages/claude/commands/")
  SAMPLE_FORMAT = Path("/home/user/agentic-kit/packages/droid/commands/algorithmic-art.md")
  SKELETON_TEMPLATE = Path("COMMAND_SKELETON_TEMPLATE.md")
  ```
- Define exclusion patterns:
  ```python
  EXCLUDE_FILES = {"LICENSE.txt", "LICENSE"}
  EXCLUDE_DIRS = {"scripts"}
  EXCLUDE_EXTENSIONS = {
      ".pyc", ".exe", ".bin", ".so", ".dll",  # Binaries
      ".pdf", ".png", ".jpg", ".jpeg", ".gif", ".bmp", ".svg",  # Images
      ".zip", ".tar", ".gz", ".rar",  # Archives
      ".mp3", ".mp4", ".avi", ".mov"  # Media
  }
  ```
- Define processing rules:
  ```python
  PROCESSING_RULES = {
      "process_skill_md_first": True,
      "alphabetical_order": True,
      "create_output_dir": True,
      "overwrite_existing": True,
      "continue_on_error": True,
      "retry_on_failure": True,
      "retry_delay_seconds": 0.5,
      "max_retries": 1
  }
  ```

**Acceptance Criteria:**
- All paths defined as Path objects
- Exclusion patterns comprehensive
- Rules clearly named and documented
- Constants are easy to modify if needed

---

### Subtask 1.3: Define Data Structures (1.5 hours)

**Details:**
- Create `ProcessingResult` dataclass:
  ```python
  @dataclass
  class ProcessingResult:
      skill_name: str
      status: str  # "SUCCESS", "PARTIAL_SUCCESS", "FAILED"
      output_file: Optional[Path]
      files_processed: List[str] = field(default_factory=list)
      files_skipped: List[str] = field(default_factory=list)
      notes: List[str] = field(default_factory=list)
      errors: List[str] = field(default_factory=list)
      retry_attempts: int = 0
  ```
- Create `ConversionReport` dataclass:
  ```python
  @dataclass
  class ConversionReport:
      total_skills: int = 0
      successful: int = 0
      partial_success: int = 0
      failed: int = 0
      total_files_processed: int = 0
      total_errors: int = 0
      total_retries: int = 0
      results: List[ProcessingResult] = field(default_factory=list)
  ```
- Add helper methods to `ConversionReport`:
  - `add_result(result: ProcessingResult)` - adds result and updates counters
  - `get_success_rate() -> float` - calculates success percentage

**Acceptance Criteria:**
- Both dataclasses defined with proper type hints
- Default factories for list/dict fields
- Helper methods implemented
- Follows Python dataclass best practices

---

### Subtask 1.4: Create Skeleton Template File (1 hour)

**Details:**
- Create `/home/user/agentic-kit/COMMAND_SKELETON_TEMPLATE.md` with this structure:
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
- Add comments explaining each section's purpose
- Document integration points for different content types

**Acceptance Criteria:**
- Template file created with complete structure
- Follows the format of algorithmic-art.md
- All sections clearly labeled
- Can serve as reference during conversion

---

### Subtask 1.5: Define Class Structure (2 hours)

**Details:**
- Create skeleton for main classes (methods as stubs with docstrings):

```python
class SkillProcessor:
    """Handles processing of individual skill directories"""

    def __init__(self, skill_dir: Path):
        self.skill_dir = skill_dir
        self.skill_name = skill_dir.name
        self.result = ProcessingResult(skill_name=self.skill_name, status="PENDING")

    def process(self) -> ProcessingResult:
        """Main entry point to process a skill directory"""
        pass

    def discover_files(self) -> List[Path]:
        """Recursively discover all relevant files in skill directory"""
        pass

    def should_exclude_file(self, file_path: Path) -> bool:
        """Check if file should be excluded based on rules"""
        pass

class FileIntegrator:
    """Integrates multiple files into single output"""

    def __init__(self, sample_format: Path):
        self.sample_format = sample_format
        self.structure = {}

    def integrate_files(self, files: List[Path], skill_name: str) -> str:
        """Combine multiple files into single markdown output"""
        pass

    def extract_yaml_frontmatter(self, content: str) -> tuple:
        """Extract and parse YAML front matter from markdown"""
        pass

    def categorize_file(self, file_path: Path) -> str:
        """Determine file category: reference, example, code, etc."""
        pass

class FormatParser:
    """Parses sample format file and extracts structure patterns"""

    def __init__(self, sample_file: Path):
        self.sample_file = sample_file
        self.structure_patterns = {}

    def parse_structure(self) -> Dict:
        """Parse sample file to extract section hierarchy"""
        pass

    def extract_section_pattern(self) -> str:
        """Identify section heading pattern (e.g., ## Step N)"""
        pass

class ConflictResolver:
    """Handles naming conflicts and file adjustments"""

    def __init__(self, output_dir: Path):
        self.output_dir = output_dir

    def resolve_filename(self, base_name: str) -> Path:
        """Generate unique filename, handling conflicts"""
        pass

    def sanitize_filename(self, name: str) -> str:
        """Convert to kebab-case and sanitize special characters"""
        pass

class ReportGenerator:
    """Generates detailed processing reports"""

    def __init__(self):
        self.report = ConversionReport()

    def generate_report(self) -> str:
        """Create formatted final report"""
        pass

    def format_summary_section(self) -> str:
        """Format summary statistics section"""
        pass

    def format_success_section(self) -> str:
        """Format successful conversions section"""
        pass

    def format_failure_section(self) -> str:
        """Format failed/partial success section"""
        pass

class ErrorHandler:
    """Manages error recovery and logging"""

    @staticmethod
    def retry_operation(operation, max_retries: int = 1, delay: float = 0.5):
        """Retry an operation with delay between attempts"""
        pass

    @staticmethod
    def handle_encoding_error(file_path: Path) -> str:
        """Try multiple encodings to read file"""
        pass

    @staticmethod
    def log_error(message: str, skill_name: str = None):
        """Log error message with context"""
        pass
```

**Acceptance Criteria:**
- All classes defined with docstrings
- Method signatures include type hints
- Stub implementations (pass statements)
- Clear separation of concerns
- Ready for implementation in subsequent tasks

---

### Subtask 1.6: Create Main Execution Function (1 hour)

**Details:**
- Create `main()` function that orchestrates the conversion:
  ```python
  def main():
      """Main execution function"""
      print("=" * 60)
      print("SKILL-TO-COMMAND CONVERTER")
      print("=" * 60)
      print()

      # Initialize components
      report_gen = ReportGenerator()

      # Discover skill directories
      skill_dirs = discover_skill_directories(INPUT_DIR)
      print(f"Found {len(skill_dirs)} skill directories")
      print()

      # Process each skill
      for skill_dir in skill_dirs:
          processor = SkillProcessor(skill_dir)
          result = processor.process()
          report_gen.report.add_result(result)

      # Generate and display report
      final_report = report_gen.generate_report()
      print(final_report)

  def discover_skill_directories(input_dir: Path) -> List[Path]:
      """Discover skill directories (non-recursive, level 1 only)"""
      pass  # Will implement in Task 2
  ```

**Acceptance Criteria:**
- Main function orchestrates overall flow
- Clear console output with progress indication
- Proper initialization of components
- Ready to call from `if __name__ == "__main__"` block

---

## Task 2: Implement File Discovery System

**Objective:** Build the file scanning and discovery mechanism

### Subtask 2.1: Implement Skill Directory Scanner (2 hours)

**Details:**
- Implement `discover_skill_directories()` function:
  - List all direct subdirectories of INPUT_DIR (non-recursive)
  - Filter out any non-directory entries
  - Return sorted list of Path objects
  - Handle permission errors gracefully
- Add logging for discovery process
- Example implementation:
  ```python
  def discover_skill_directories(input_dir: Path) -> List[Path]:
      """Discover skill directories (non-recursive, direct children only)"""
      skill_dirs = []

      try:
          if not input_dir.exists():
              print(f"ERROR: Input directory not found: {input_dir}")
              return []

          # List direct children only (non-recursive)
          for entry in sorted(input_dir.iterdir()):
              if entry.is_dir():
                  skill_dirs.append(entry)

          print(f"Discovered {len(skill_dirs)} skill directories")

      except PermissionError as e:
          print(f"ERROR: Permission denied accessing {input_dir}")
      except Exception as e:
          print(f"ERROR: Failed to scan directory {input_dir}: {e}")

      return skill_dirs
  ```

**Acceptance Criteria:**
- Only direct subdirectories discovered (one level deep)
- Results sorted alphabetically
- Handles missing/inaccessible directories
- Logs discovery results
- Returns empty list on error (doesn't crash)

---

### Subtask 2.2: Implement Recursive File Discovery (2.5 hours) ✅

**Status:** COMPLETE - Implemented with file categorization

**Details:**
- Implement `SkillProcessor.discover_files()` method:
  - Recursively search all subdirectories within skill directory
  - Find all .md files at any depth
  - Find code files (.py, .js, .sh, .ts, etc.) at any depth
  - Find config files (.json, .yaml, .xml) at any depth
  - Return sorted list of all discovered files
- Example implementation:
  ```python
  def discover_files(self) -> List[Path]:
      """Recursively discover all relevant files in skill directory"""
      all_files = []

      try:
          # Use rglob for recursive search
          for pattern in ["**/*.md", "**/*.py", "**/*.js", "**/*.sh",
                         "**/*.ts", "**/*.json", "**/*.yaml", "**/*.txt"]:
              files = self.skill_dir.rglob(pattern)
              all_files.extend(files)

          # Remove duplicates and sort
          all_files = sorted(set(all_files))

          self.result.notes.append(f"Discovered {len(all_files)} files")

      except Exception as e:
          error_msg = f"Error discovering files: {e}"
          self.result.errors.append(error_msg)
          ErrorHandler.log_error(error_msg, self.skill_name)

      return all_files
  ```

**Implementation Note:** The actual implementation in `/home/user/agentic-kit/skill_to_command_converter.py` includes advanced features like file categorization (markdown, code, config), exclusion filtering, and SKILL.md prioritization, all integrated into a single comprehensive `discover_files()` method.

**Acceptance Criteria:**
- Recursively searches entire skill directory tree
- Discovers files at any depth (not just root level)
- Handles symbolic links safely (no infinite loops)
- Returns all relevant file types
- Logs total files discovered

---

### Subtask 2.3: Implement File Filtering Logic (2 hours) ✅

**Status:** COMPLETE - Implemented in `discover_files()` method

**Details:**
- Implement `SkillProcessor.should_exclude_file()` method:
  - Check filename against EXCLUDE_FILES
  - Check parent directory against EXCLUDE_DIRS
  - Check file extension against EXCLUDE_EXTENSIONS
  - Detect binary files (check for null bytes)
  - Return True if file should be excluded
- Add binary detection helper:
  ```python
  @staticmethod
  def is_binary_file(file_path: Path) -> bool:
      """Detect if file is binary by checking for null bytes"""
      try:
          with open(file_path, 'rb') as f:
              chunk = f.read(1024)
              return b'\x00' in chunk
      except Exception:
          return False  # If can't read, assume not binary
  ```
- Track skipped files in result.files_skipped

**Implementation Note:** The `discover_files()` method integrates filtering logic using `should_exclude_file()` and `should_exclude_dir()` methods to apply all exclusion rules during file discovery.

**Acceptance Criteria:**
- Correctly excludes LICENSE.txt at any depth
- Excludes files in scripts/ directories
- Excludes binary files by extension and content detection
- Logs all skipped files with reason
- Doesn't exclude files incorrectly

**Testing:**
- Test with LICENSE.txt in root and subdirectories
- Test with scripts/build.sh (should be excluded)
- Test with binary files (.png, .pdf)
- Test with valid markdown files (should not be excluded)

---

### Subtask 2.4: Implement File Processing Order (1.5 hours) ✅

**Status:** COMPLETE - Implemented in `discover_files()` method

**Details:**
- Implement sorting and prioritization logic:
  - Separate SKILL.md from other files
  - Sort remaining files alphabetically
  - Return ordered list: [SKILL.md, file1.md, file2.md, ...]
- Example implementation:
  ```python
  def order_files_for_processing(self, files: List[Path]) -> List[Path]:
      """Order files: SKILL.md first, then alphabetically"""
      skill_md = None
      other_files = []

      for file in files:
          if file.name == "SKILL.md":
              skill_md = file
          else:
              other_files.append(file)

      # Sort other files alphabetically
      other_files.sort(key=lambda f: str(f))

      # Combine: SKILL.md first, then others
      ordered = []
      if skill_md:
          ordered.append(skill_md)
      ordered.extend(other_files)

      return ordered
  ```

**Implementation Note:** The `discover_files()` method returns files with SKILL.md prioritized first, followed by alphabetically sorted files, providing the correct processing order directly from discovery.

**Acceptance Criteria:**
- SKILL.md always processed first (if present)
- Other files sorted alphabetically (case-insensitive)
- Order is consistent across runs
- Works correctly when SKILL.md is missing

---

### Subtask 2.5: Integration and Testing (1.5 hours) ✅

**Status:** COMPLETE - Comprehensive integration tests created and passed

**Details:**
Created comprehensive integration test suite (`test_integration_2.5.py`) that verifies:

1. **Integration of discover_skills() + discover_files()**
   - Tests that both methods work together seamlessly
   - Validates return types and data structures
   - Ensures smooth workflow from skill discovery to file discovery

2. **Sample Skills Verification:**
   - `mcp-builder` - SKILL.md + reference/ subdirectory (4 files)
   - `theme-factory` - SKILL.md + themes/ subdirectory (10 files)
   - `pdf` - SKILL.md + forms.md + reference.md in root

3. **Exclusion Validation:**
   - LICENSE.txt files excluded across all skills
   - scripts/ directories completely excluded
   - Binary files (.pdf, .jpg, .png) excluded
   - __pycache__ directories excluded

4. **File Categorization:**
   - Markdown files (.md) → 'markdown' category
   - Code files (.py, .js, .sh) → 'code' category
   - Config files (.json, .yaml, .xml) → 'config' category
   - All categories alphabetically sorted

5. **Edge Cases:**
   - Skills without SKILL.md handled gracefully
   - Nested subdirectories (2+ levels) processed correctly
   - Empty skill directories handled
   - Skills with only SKILL.md processed correctly

**Test Results:**
- 28 tests passed
- 0 tests failed
- 1 warning (no config files in test skills - expected)
- All integration tests successful

**Acceptance Criteria:**
- ✅ Discovery, filtering, and ordering work together seamlessly
- ✅ Skipped files logged correctly
- ✅ Empty directories handled gracefully
- ✅ Sample skills tested with expected results
- ✅ All exclusion rules validated
- ✅ File categorization validated
- ✅ Edge cases tested and passing
- ✅ Ready for content processing in Task 3

---

## Task 3: Implement Content Processing Pipeline

**Objective:** Build the content extraction, parsing, and integration system

### Subtask 3.1: Implement File Reading with Encoding Detection (2.5 hours)

**Details:**
- Implement `ErrorHandler.read_file_with_encoding()` method:
  - Try UTF-8 first
  - Fall back to Latin-1 if UTF-8 fails
  - Fall back to cp1252 if Latin-1 fails
  - Use chardet library if available for detection
  - Log which encoding was used
  - Retry once on failure
- Example implementation:
  ```python
  @staticmethod
  def read_file_with_encoding(file_path: Path) -> tuple[str, str]:
      """
      Read file with encoding detection
      Returns: (content, encoding_used)
      """
      encodings = ['utf-8', 'latin-1', 'cp1252']

      for encoding in encodings:
          try:
              with open(file_path, 'r', encoding=encoding) as f:
                  content = f.read()
              return content, encoding
          except UnicodeDecodeError:
              continue
          except Exception as e:
              raise Exception(f"Error reading {file_path}: {e}")

      # If all fail, try chardet if available
      try:
          import chardet
          with open(file_path, 'rb') as f:
              raw_data = f.read()
          detected = chardet.detect(raw_data)
          encoding = detected['encoding']
          content = raw_data.decode(encoding)
          return content, encoding
      except:
          pass

      raise Exception(f"Unable to decode {file_path} with any encoding")
  ```

**Acceptance Criteria:**
- Successfully reads UTF-8 files
- Falls back to alternate encodings
- Logs encoding used for each file
- Handles binary files gracefully (returns error)
- Retries once on temporary failures

---

### Subtask 3.2: Implement YAML Front Matter Extraction (2 hours) ✅

**Status:** COMPLETE - Implemented with comprehensive error handling and fallback support

**Details:**
- Implement `FileIntegrator.extract_yaml_frontmatter()` method:
  - Detect YAML front matter (--- ... ---)
  - Parse using PyYAML
  - Extract `description` and `argument-hint`
  - Handle malformed YAML with regex fallback
  - Return tuple: (front_matter_dict, remaining_content)
- Example implementation:
  ```python
  def extract_yaml_frontmatter(self, content: str) -> tuple:
      """
      Extract and parse YAML front matter from markdown
      Returns: (frontmatter_dict, body_content)
      """
      # Check for YAML front matter
      if not content.startswith('---'):
          return {}, content

      # Split content
      parts = content.split('---', 2)
      if len(parts) < 3:
          return {}, content

      yaml_str = parts[1].strip()
      body = parts[2].strip()

      # Try parsing with PyYAML
      try:
          import yaml
          frontmatter = yaml.safe_load(yaml_str)
          return frontmatter or {}, body
      except Exception as e:
          # Fallback: regex extraction
          frontmatter = {}

          # Extract description
          desc_match = re.search(r'description:\s*(.+?)(?:\n|$)', yaml_str)
          if desc_match:
              frontmatter['description'] = desc_match.group(1).strip()

          # Extract argument-hint
          arg_match = re.search(r'argument-hint:\s*(.+?)(?:\n|$)', yaml_str)
          if arg_match:
              frontmatter['argument-hint'] = arg_match.group(1).strip()

          return frontmatter, body
  ```

**Acceptance Criteria:**
- Correctly parses valid YAML front matter
- Falls back to regex for malformed YAML
- Extracts description and argument-hint
- Returns remaining content without front matter
- Handles missing front matter (returns empty dict)

---

### Subtask 3.3: Implement Sample Format Parser (2.5 hours)

**Details:**
- Implement `FormatParser.parse_structure()` method:
  - Read the algorithmic-art.md sample file
  - Extract section heading pattern (## Step N, ## Examples, ## Usage)
  - Identify subsection patterns (** bold markers)
  - Recognize code block formats
  - Build structure dictionary for reference
- Example implementation:
  ```python
  def parse_structure(self) -> Dict:
      """Parse sample file to extract section hierarchy"""
      if not self.sample_file.exists():
          return self._get_default_structure()

      try:
          content = ErrorHandler.read_file_with_encoding(self.sample_file)[0]

          # Extract section headings
          sections = re.findall(r'^##\s+(.+)$', content, re.MULTILINE)

          # Extract subsection patterns
          subsections = re.findall(r'^\*\*(.+?):\*\*', content, re.MULTILINE)

          # Extract code block languages
          code_blocks = re.findall(r'```(\w+)', content)

          structure = {
              'sections': sections,
              'subsection_pattern': '**{title}:**',
              'code_block_languages': set(code_blocks),
              'has_examples_section': 'Examples' in sections,
              'has_usage_section': 'Usage' in sections
          }

          self.structure_patterns = structure
          return structure

      except Exception as e:
          print(f"Warning: Could not parse sample format: {e}")
          return self._get_default_structure()

  def _get_default_structure(self) -> Dict:
      """Return default structure if sample file unavailable"""
      return {
          'sections': ['Step 1', 'Step 2', 'Examples', 'Usage'],
          'subsection_pattern': '**{title}:**',
          'code_block_languages': {'python', 'javascript', 'bash'},
          'has_examples_section': True,
          'has_usage_section': True
      }
  ```

**Acceptance Criteria:**
- Successfully parses algorithmic-art.md
- Extracts section patterns
- Identifies subsection formatting
- Has fallback if sample file missing
- Structure dict contains all needed info for formatting

---

### Subtask 3.4: Implement Content Categorization (2 hours)

**Details:**
- Implement `FileIntegrator.categorize_file()` method:
  - Determine if file is reference documentation
  - Determine if file is example
  - Determine if file is code (script)
  - Determine if file is configuration
  - Return category string
- Example implementation:
  ```python
  def categorize_file(self, file_path: Path) -> str:
      """
      Determine file category based on path and name
      Returns: 'reference', 'example', 'code', 'config', 'skill_md'
      """
      name = file_path.name.lower()
      parent = file_path.parent.name.lower()

      # SKILL.md is special
      if name == 'skill.md':
          return 'skill_md'

      # Check parent directory names
      if 'example' in parent:
          return 'example'
      elif 'reference' in parent or 'ref' in parent:
          return 'reference'
      elif 'theme' in parent:
          return 'example'

      # Check file extension
      if file_path.suffix in ['.py', '.js', '.sh', '.ts']:
          return 'code'
      elif file_path.suffix in ['.json', '.yaml', '.yml', '.xml']:
          return 'config'

      # Check filename patterns
      if 'example' in name:
          return 'example'
      elif 'reference' in name or 'guide' in name:
          return 'reference'

      # Default to reference for markdown files
      if file_path.suffix == '.md':
          return 'reference'

      return 'other'
  ```

**Acceptance Criteria:**
- Correctly identifies SKILL.md
- Categorizes reference documentation
- Categorizes examples
- Categorizes code files
- Has reasonable defaults for ambiguous cases

---

### Subtask 3.5: Implement Content Integration Logic (3 hours)

**Details:**
- Implement `FileIntegrator.integrate_files()` method:
  - Process SKILL.md first (extract front matter and main content)
  - Process remaining files by category
  - Build integrated markdown document
  - Maintain section hierarchy from sample format
  - Preserve code blocks with syntax highlighting
- Example implementation structure:
  ```python
  def integrate_files(self, files: List[Path], skill_name: str) -> str:
      """Combine multiple files into single markdown output"""
      # Initialize output components
      frontmatter = {}
      summary = ""
      step_sections = []
      examples = []
      code_blocks = []

      # Process SKILL.md first
      skill_md = next((f for f in files if f.name == 'SKILL.md'), None)
      if skill_md:
          content, encoding = ErrorHandler.read_file_with_encoding(skill_md)
          frontmatter, body = self.extract_yaml_frontmatter(content)
          summary = self._extract_summary(body)
          step_sections.append(body)

      # Process other files
      for file in files:
          if file.name == 'SKILL.md':
              continue

          category = self.categorize_file(file)
          content, encoding = ErrorHandler.read_file_with_encoding(file)

          if category == 'reference':
              step_sections.append(self._format_reference(file, content))
          elif category == 'example':
              examples.append(self._format_example(file, content))
          elif category == 'code':
              code_blocks.append(self._format_code(file, content))

      # Assemble final output
      output = self._assemble_output(
          frontmatter, summary, step_sections,
          examples, code_blocks, skill_name
      )

      return output
  ```
- Implement helper methods:
  - `_extract_summary()` - get first paragraph
  - `_format_reference()` - format reference doc as step section
  - `_format_example()` - format example with heading
  - `_format_code()` - wrap code in markdown code block
  - `_assemble_output()` - combine all parts following sample structure

**Acceptance Criteria:**
- SKILL.md content integrated first
- Reference docs become step sections
- Examples grouped in Examples section
- Code files formatted as code blocks with language tags
- Output follows sample format structure
- All content preserved (no data loss)
- Proper markdown formatting maintained

---

### Subtask 3.6: Implement Fallback Front Matter Generation (1.5 hours) ✅

**Status:** COMPLETE - Comprehensive fallback metadata generation implemented

**Details:**
- Implemented `generate_fallback_metadata(skill_name, files_dict)` method with:
  - Smart title conversion with acronym handling (mcp → MCP, api → API, etc.)
  - Intelligent argument-hint detection:
    - `<theme-name>` for skills with themes/ directory
    - `<file-path>` for skills with code files
    - `<arguments>` as default
  - Summary extraction from first available markdown file
  - Fallback to generated description if no summary found

- Implemented `_convert_skill_name_to_title()` helper:
  - Converts kebab-case to readable titles
  - Handles 20+ common tech acronyms (MCP, API, CLI, etc.)
  - Examples: "mcp-builder" → "MCP Builder", "algorithmic-art" → "Algorithmic Art"

- Implemented `_extract_first_paragraph_from_markdown()` helper:
  - Extracts first substantial paragraph from any markdown
  - Skips YAML front matter and headers
  - Used for summary extraction

- Updated `generate_output_content()`:
  - Automatically uses fallback when metadata is empty or incomplete
  - Merges fallback with existing metadata (fills in missing fields only)
  - Ensures all output has valid description and argument-hint

**Testing:**
- Unit tests: 4/4 passed (title conversion, code detection, themes detection, defaults)
- Integration tests: 3/3 passed (no SKILL.md, incomplete metadata, themes)
- Test coverage: Fallback metadata, title conversion, summary extraction, argument-hint logic

**Implementation Note:** Actual implementation is more comprehensive than originally planned:
- Added acronym dictionary for better title conversion
- Implemented smart file type detection for argument-hint suggestions
- Created reusable paragraph extraction helper
- Integrated seamlessly with existing content generation pipeline

**Acceptance Criteria:**
- ✅ Generates valid front matter when SKILL.md missing or incomplete
- ✅ Uses meaningful descriptions (extracts from markdown or generates)
- ✅ Provides appropriate argument-hint based on skill contents
- ✅ Handles common acronyms in skill names (MCP, API, etc.)
- ✅ All output files guaranteed to have description and argument-hint
- ✅ Comprehensive test coverage with all tests passing

---

## Task 4: Implement Output Generation

**Objective:** Build the output file creation and conflict resolution system

### Subtask 4.1: Implement Filename Sanitization (1.5 hours)

**Details:**
- Implement `ConflictResolver.sanitize_filename()` method:
  - Convert to lowercase
  - Replace spaces with hyphens
  - Remove special characters
  - Handle multiple consecutive hyphens
  - Return kebab-case filename
- Example implementation:
  ```python
  def sanitize_filename(self, name: str) -> str:
      """Convert to kebab-case and sanitize special characters"""
      # Convert to lowercase
      name = name.lower()

      # Replace spaces and underscores with hyphens
      name = re.sub(r'[\s_]+', '-', name)

      # Remove special characters (keep alphanumeric and hyphens)
      name = re.sub(r'[^a-z0-9-]', '', name)

      # Replace multiple consecutive hyphens with single hyphen
      name = re.sub(r'-+', '-', name)

      # Remove leading/trailing hyphens
      name = name.strip('-')

      return name
  ```

**Test Cases:**
- "My Skill" → "my-skill"
- "PDF Tool" → "pdf-tool"
- "Theme (Beta)!" → "theme-beta"
- "mcp-builder" → "mcp-builder" (already good)

**Acceptance Criteria:**
- Produces valid, clean filenames
- Converts to kebab-case consistently
- Handles edge cases (empty strings, all special chars)
- Deterministic output

---

### Subtask 4.2: Implement Naming Conflict Resolution (2 hours)

**Details:**
- Implement `ConflictResolver.resolve_filename()` method:
  - Check if base filename exists
  - Try appending -2, -3, -4, etc. until finding available name
  - Log all adjustments
  - Return final Path object
- Example implementation:
  ```python
  def resolve_filename(self, base_name: str) -> tuple[Path, bool]:
      """
      Generate unique filename, handling conflicts
      Returns: (final_path, was_adjusted)
      """
      # Sanitize base name
      clean_name = self.sanitize_filename(base_name)

      # Try base name first
      output_path = self.output_dir / f"{clean_name}.md"
      if not output_path.exists():
          return output_path, False

      # Try numbered suffixes
      counter = 2
      while counter < 1000:  # Reasonable limit
          numbered_name = f"{clean_name}-{counter}"
          output_path = self.output_dir / f"{numbered_name}.md"
          if not output_path.exists():
              return output_path, True
          counter += 1

      # If we hit limit, raise error
      raise Exception(f"Unable to resolve filename conflict for {base_name} after 999 attempts")
  ```

**Acceptance Criteria:**
- Detects existing files correctly
- Appends numeric suffixes sequentially
- Returns first available filename
- Logs adjustments
- Handles edge case of 100+ conflicts

---

### Subtask 4.3: Implement Output Structure Builder (3 hours)

**Details:**
- Implement method to build final output markdown:
  - Format YAML front matter
  - Add summary paragraph
  - Add step sections
  - Add code examples
  - Add Examples section
  - Add Usage section
- Example implementation:
  ```python
  def build_output_markdown(self, frontmatter: Dict, summary: str,
                           step_sections: List[str], examples: List[str],
                           code_blocks: List[str], skill_name: str) -> str:
      """Build complete markdown output following sample format"""
      output_parts = []

      # YAML front matter
      output_parts.append("---")
      if 'description' in frontmatter:
          output_parts.append(f"description: {frontmatter['description']}")
      if 'argument-hint' in frontmatter:
          output_parts.append(f"argument-hint: {frontmatter['argument-hint']}")
      output_parts.append("---")
      output_parts.append("")

      # Summary
      if summary:
          output_parts.append(summary)
          output_parts.append("")

      # Step sections
      for i, section in enumerate(step_sections, 1):
          if not section.startswith("## Step"):
              output_parts.append(f"## Step {i}")
              output_parts.append("")
          output_parts.append(section)
          output_parts.append("")

      # Code blocks
      if code_blocks:
          output_parts.append("## Code Examples")
          output_parts.append("")
          for code in code_blocks:
              output_parts.append(code)
              output_parts.append("")

      # Examples section
      if examples:
          output_parts.append("## Examples")
          output_parts.append("")
          for example in examples:
              output_parts.append(example)
              output_parts.append("")

      # Usage section
      output_parts.append("## Usage")
      output_parts.append("")
      output_parts.append(f"**Basic usage:** `/{skill_name} [arguments]`")
      output_parts.append("")

      return "\n".join(output_parts)
  ```

**Acceptance Criteria:**
- Output matches sample format structure
- YAML front matter properly formatted
- Sections in correct order
- Code blocks preserved with syntax highlighting
- Usage section always at end
- Clean, valid markdown output

---

### Subtask 4.4: Implement File Writer (1.5 hours)

**Details:**
- Implement method to write output to file:
  - Create output directory if needed
  - Write file in UTF-8 encoding
  - Track if file was overwritten
  - Handle write errors with retry
- Example implementation:
  ```python
  def write_output_file(self, output_path: Path, content: str) -> bool:
      """
      Write output file with error handling
      Returns: True if successful, False otherwise
      """
      try:
          # Create output directory if needed
          output_path.parent.mkdir(parents=True, exist_ok=True)

          # Check if file exists (for logging)
          file_existed = output_path.exists()

          # Write file
          with open(output_path, 'w', encoding='utf-8') as f:
              f.write(content)

          # Log if overwritten
          if file_existed:
              print(f"  Overwritten: {output_path.name}")
          else:
              print(f"  Created: {output_path.name}")

          return True

      except Exception as e:
          print(f"  ERROR: Failed to write {output_path}: {e}")
          return False
  ```

**Acceptance Criteria:**
- Creates output directory if missing
- Writes valid UTF-8 files
- Logs overwrites
- Returns success/failure status
- Can be wrapped with retry logic

---

### Subtask 4.5: Integrate Output Generation in SkillProcessor (2 hours)

**Details:**
- Complete the `SkillProcessor.process()` method:
  - Use FileIntegrator to combine content
  - Use ConflictResolver to determine output filename
  - Build final markdown
  - Write output file
  - Update ProcessingResult status
- Complete implementation flow from file discovery to output writing

**Acceptance Criteria:**
- Full pipeline working: discovery → processing → output
- Proper status set (SUCCESS, PARTIAL_SUCCESS, FAILED)
- All operations logged to ProcessingResult
- Files tracked in files_processed list
- Errors captured in errors list

---

## Task 5: Implement Error Handling and Reporting

**Objective:** Build robust error recovery and comprehensive reporting system

### Subtask 5.1: Implement Retry Mechanism (2 hours)

**Details:**
- Implement `ErrorHandler.retry_operation()` decorator/function:
  - Takes any operation (lambda/function)
  - Tries operation once
  - On failure, waits RETRY_DELAY_SECONDS
  - Tries exactly one more time
  - Returns result or raises exception
  - Logs retry attempts
- Example implementation:
  ```python
  @staticmethod
  def retry_operation(operation, operation_name: str = "operation",
                     max_retries: int = 1, delay: float = 0.5) -> any:
      """
      Retry an operation with delay between attempts
      Returns: operation result
      Raises: Exception if all attempts fail
      """
      attempt = 0
      last_error = None

      while attempt <= max_retries:
          try:
              result = operation()
              if attempt > 0:
                  print(f"    Retry #{attempt} succeeded for {operation_name}")
              return result
          except Exception as e:
              last_error = e
              attempt += 1
              if attempt <= max_retries:
                  print(f"    Retry #{attempt} for {operation_name} after error: {e}")
                  time.sleep(delay)

      # All attempts failed
      raise Exception(f"{operation_name} failed after {max_retries + 1} attempts: {last_error}")
  ```

**Acceptance Criteria:**
- Retries exactly once (max_retries = 1)
- Waits 0.5 seconds between attempts
- Logs all retry attempts
- Returns result on success
- Raises exception after exhausting retries

---

### Subtask 5.2: Implement Graceful Error Recovery (2.5 hours)

**Details:**
- Add error handling to all file operations:
  - Wrap file reads with retry logic
  - Wrap file writes with retry logic
  - Handle specific exception types appropriately
  - Continue processing after recoverable errors
  - Mark skills as PARTIAL_SUCCESS or FAILED as appropriate
- Add error tracking:
  ```python
  def handle_file_read_error(self, file_path: Path, error: Exception) -> Optional[str]:
      """Handle file read errors with retry and fallback"""
      error_msg = f"Error reading {file_path.name}: {error}"

      # Try retry if permission or temp error
      if isinstance(error, (PermissionError, IOError)):
          try:
              content = ErrorHandler.retry_operation(
                  lambda: ErrorHandler.read_file_with_encoding(file_path),
                  f"read {file_path.name}"
              )
              self.result.retry_attempts += 1
              return content[0]  # Return content, ignore encoding
          except Exception as retry_error:
              error_msg = f"Error reading {file_path.name} after retry: {retry_error}"

      # Log error and continue
      self.result.errors.append(error_msg)
      self.result.files_skipped.append(file_path.name)
      ErrorHandler.log_error(error_msg, self.skill_name)
      return None
  ```

**Acceptance Criteria:**
- All file operations wrapped with error handling
- Retry logic applied to recoverable errors
- Unrecoverable errors logged and skipped
- Processing continues after errors
- Status correctly reflects partial vs complete failures

---

### Subtask 5.3: Implement Processing Logger (1.5 hours)

**Details:**
- Enhance logging throughout the process:
  - Log each skill being processed
  - Log each file being read
  - Log encoding used
  - Log files skipped with reason
  - Log errors with context
  - Log automatic adjustments (filename changes, etc.)
- Example logging additions:
  ```python
  def process(self) -> ProcessingResult:
      """Main entry point with enhanced logging"""
      print(f"\n{'=' * 60}")
      print(f"Processing skill: {self.skill_name}")
      print(f"{'=' * 60}")

      # Discovery
      print(f"  Discovering files...")
      all_files = self.discover_files()
      print(f"    Found {len(all_files)} files")

      # Filtering
      print(f"  Filtering files...")
      valid_files = self._filter_files(all_files)
      print(f"    {len(valid_files)} files after filtering")

      # Processing
      print(f"  Reading and integrating content...")
      for file in valid_files:
          print(f"    Reading: {file.name}")

      # Output
      print(f"  Writing output file...")

      # Final status
      print(f"  Status: {self.result.status}")
      print()

      return self.result
  ```

**Acceptance Criteria:**
- Clear, informative log messages
- Progress visible during execution
- All operations logged
- Easy to follow what's happening
- Errors clearly marked

---

### Subtask 5.4: Implement Report Summary Section (1.5 hours)

**Details:**
- Implement `ReportGenerator.format_summary_section()`:
  - Display total skills processed
  - Display success counts
  - Display file counts
  - Display error counts
  - Display retry counts
  - Calculate success rate
- Example implementation:
  ```python
  def format_summary_section(self) -> str:
      """Format summary statistics section"""
      lines = []

      lines.append("=" * 60)
      lines.append("SUMMARY STATISTICS")
      lines.append("=" * 60)
      lines.append("")
      lines.append(f"Total Skills Processed: {self.report.total_skills}")
      lines.append(f"Successful Conversions: {self.report.successful}")
      lines.append(f"Partial Successes: {self.report.partial_success}")
      lines.append(f"Failed Conversions: {self.report.failed}")
      lines.append(f"Total Files Processed: {self.report.total_files_processed}")
      lines.append(f"Total Errors: {self.report.total_errors}")
      lines.append(f"Total Retries: {self.report.total_retries}")

      # Success rate
      if self.report.total_skills > 0:
          success_rate = ((self.report.successful + self.report.partial_success)
                         / self.report.total_skills * 100)
          lines.append(f"Success Rate: {success_rate:.1f}%")

      lines.append("")

      return "\n".join(lines)
  ```

**Acceptance Criteria:**
- All statistics displayed
- Clear formatting with separators
- Success rate calculated
- Easy to read at a glance

---

### Subtask 5.5: Implement Report Success Section (1.5 hours)

**Details:**
- Implement `ReportGenerator.format_success_section()`:
  - List all successful conversions
  - Show output file path
  - Show files processed count
  - Show brief comments (overwritten, included files, etc.)
- Example implementation:
  ```python
  def format_success_section(self) -> str:
      """Format successful conversions section"""
      successful_results = [r for r in self.report.results
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

          if result.files_skipped:
              lines.append(f"    Files Skipped: {len(result.files_skipped)}")

          if result.notes:
              lines.append("    Notes:")
              for note in result.notes:
                  lines.append(f"      - {note}")

          lines.append("")

      return "\n".join(lines)
  ```

**Acceptance Criteria:**
- Lists all successful conversions
- Shows relevant details for each
- Includes notes about special handling
- Easy to scan

---

### Subtask 5.6: Implement Report Failure Section (2 hours)

**Details:**
- Implement `ReportGenerator.format_failure_section()`:
  - List all failed and partial success conversions
  - Show detailed error descriptions
  - Show retry attempts
  - Show what was successfully processed (if any)
  - Provide suggestions for manual resolution
- Example implementation:
  ```python
  def format_failure_section(self) -> str:
      """Format failed/partial success section"""
      failed_results = [r for r in self.report.results
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
              for file in result.files_processed[:5]:  # Show first 5
                  lines.append(f"      - {file}")
              if len(result.files_processed) > 5:
                  lines.append(f"      ... and {len(result.files_processed) - 5} more")

          if result.errors:
              lines.append("    Errors:")
              for error in result.errors:
                  lines.append(f"      - {error}")

          if result.retry_attempts > 0:
              lines.append(f"    Retry Attempts: {result.retry_attempts}")

          # Suggestions
          if result.status == "PARTIAL_SUCCESS":
              lines.append("    Suggestion: Review output file, may need manual adjustments")
          elif result.status == "FAILED":
              lines.append("    Suggestion: Check directory permissions and file accessibility")

          lines.append("")

      return "\n".join(lines)
  ```

**Acceptance Criteria:**
- Lists all problems clearly
- Shows detailed error information
- Includes retry attempts
- Provides actionable suggestions
- Distinguishes PARTIAL_SUCCESS from FAILED

---

### Subtask 5.7: Integrate Report Generation (1 hour)

**Details:**
- Complete `ReportGenerator.generate_report()`:
  - Combine all sections
  - Add final footer
  - Return complete formatted report
- Call from main() function after processing all skills

**Acceptance Criteria:**
- Complete report with all sections
- Proper formatting and separation
- Matches PRD example format
- Displayed to console at end of execution

---

## Task 6: Testing and Validation

**Objective:** Thoroughly test the converter with real skills and validate outputs

### Subtask 6.1: Test with Standard Skill (mcp-builder) (1.5 hours)

**Details:**
- Run converter on mcp-builder skill
- Verify output file created
- Check YAML front matter is valid
- Check SKILL.md content preserved
- Check reference docs integrated
- Check section hierarchy correct
- Compare against sample format (algorithmic-art.md)

**Expected Results:**
- Output: `/packages/claude/commands/mcp-builder.md`
- Status: SUCCESS
- All reference docs integrated
- scripts/ directory excluded
- LICENSE.txt excluded

**Validation Checklist:**
- [ ] Front matter has description field
- [ ] Main content from SKILL.md present
- [ ] Reference docs integrated as sections
- [ ] Code examples formatted correctly
- [ ] Usage section at end
- [ ] Valid markdown syntax

---

### Subtask 6.2: Test with Themes Skill (theme-factory) (1.5 hours)

**Details:**
- Run converter on theme-factory skill
- Verify all theme files discovered (recursive search)
- Check themes integrated into Examples section
- Verify binary files (PDFs) excluded

**Expected Results:**
- Output: `/packages/claude/commands/theme-factory.md`
- Status: SUCCESS
- All 10 theme .md files integrated
- theme-showcase.pdf excluded

**Validation Checklist:**
- [ ] All theme files discovered recursively
- [ ] Themes in Examples section
- [ ] Binary files excluded
- [ ] LICENSE.txt excluded
- [ ] Output format matches sample

---

### Subtask 6.3: Test with Missing SKILL.md (1 hour)

**Details:**
- Create test skill directory without SKILL.md
- Run converter
- Verify auto-generated front matter
- Check status is PARTIAL_SUCCESS
- Verify remaining files still processed

**Expected Results:**
- Output file created
- Status: PARTIAL_SUCCESS
- Front matter auto-generated
- Warning in report about missing SKILL.md

**Validation Checklist:**
- [ ] Output file created
- [ ] Front matter generated
- [ ] Other files integrated
- [ ] Status: PARTIAL_SUCCESS
- [ ] Warning in report

---

### Subtask 6.4: Test Edge Cases (2.5 hours)

**Details:**
Test each edge case from PRD:

1. **Empty Files**
   - Create skill with empty .md file
   - Verify file skipped
   - Check logged as skipped

2. **Malformed YAML**
   - Create SKILL.md with invalid YAML
   - Verify regex fallback works
   - Check status is PARTIAL_SUCCESS

3. **Permission Errors**
   - Simulate permission denied (if possible)
   - Verify retry attempted
   - Check graceful degradation

4. **Encoding Errors**
   - Create file with non-UTF-8 encoding
   - Verify fallback encodings tried
   - Check encoding logged

5. **Binary Files**
   - Place .png, .pdf in skill directory
   - Verify excluded
   - Check logged as skipped

6. **Naming Conflicts**
   - Create duplicate skill directory
   - Run converter twice
   - Verify -2, -3 suffixes work

7. **Special Characters in Names**
   - Create skill "My (Cool) Skill!"
   - Verify sanitized to "my-cool-skill.md"

8. **Subdirectory Files**
   - Verify files in nested subdirectories discovered
   - Check paths relative to skill root

9. **No Markdown Files**
   - Create skill directory with only binaries
   - Verify status is FAILED
   - Check appropriate error message

**Validation Checklist:**
- [ ] All edge cases handled gracefully
- [ ] No crashes or unhandled exceptions
- [ ] Appropriate status for each case
- [ ] All logged correctly in report

---

### Subtask 6.5: Test Full Batch Processing (1.5 hours)

**Details:**
- Run converter on all skills in `/packages/claude/skills/`
- Measure execution time
- Check memory usage
- Verify no crashes
- Review final report

**Expected Results:**
- All accessible skills processed
- Execution time < 30 seconds for ~50 skills
- Memory usage reasonable (< 500MB)
- At least 95% SUCCESS or PARTIAL_SUCCESS

**Validation Checklist:**
- [ ] Process completes without crashing
- [ ] All skills attempted
- [ ] Report shows all results
- [ ] Performance acceptable
- [ ] Success rate ≥ 95%

---

### Subtask 6.6: Validate Output Format Quality (2 hours)

**Details:**
- Randomly select 5 output files
- Compare each against algorithmic-art.md format
- Check for formatting consistency
- Verify markdown renders correctly
- Check code blocks display properly

**Sample Validation:**
For each output file:
1. Open in markdown viewer (VS Code, GitHub, etc.)
2. Verify YAML front matter displays correctly
3. Check section headings follow ## Step N pattern
4. Check code blocks have syntax highlighting
5. Check Examples section formatted well
6. Check Usage section at end

**Validation Checklist:**
- [ ] YAML front matter valid in all samples
- [ ] Section hierarchy consistent
- [ ] Code blocks render correctly
- [ ] No broken markdown syntax
- [ ] Format matches sample

---

### Subtask 6.7: Final Integration Test and Report Review (1.5 hours)

**Details:**
- Run complete converter script end-to-end
- Review entire final report
- Verify statistics accurate
- Check all sections present
- Validate report format matches PRD example

**Final Checks:**
- [ ] Summary statistics correct
- [ ] All successful conversions listed
- [ ] All failures/partials listed with details
- [ ] Retry counts accurate
- [ ] Suggestions provided for failures
- [ ] Report easy to read and understand

**Acceptance Criteria:**
- Complete successful run
- Comprehensive report generated
- All requirements from PRD met
- Tool ready for production use

---

## Task Completion Checklist

### Task 1: Setup Project Infrastructure
- [x] 1.1: Main script file created
- [x] 1.2: Configuration constants defined
- [x] 1.3: Data structures implemented
- [x] 1.4: Utility functions implemented
- [x] 1.5: Skeleton template file created
- [x] 1.6: Class structure defined
- [x] 1.7: Main execution function created

### Task 2: File Discovery System
- [x] 2.1: Skill directory scanner implemented
- [x] 2.2: Recursive file discovery implemented - Implemented in discover_files()
- [x] 2.3: File filtering logic implemented - Implemented in discover_files()
- [x] 2.4: File processing order implemented - Implemented in discover_files()
- [x] 2.5: Discovery and filtering integrated - Comprehensive integration tests passed (28/28 tests)

### Task 3: Content Processing Pipeline
- [x] 3.1: File reading with encoding detection - Implemented as read_file_with_retry()
- [x] 3.2: YAML front matter extraction - Implemented with PyYAML and regex fallback
- [x] 3.3: Sample format parser - Implemented parse_sample_format() with structure extraction
- [x] 3.4: Content categorization - Implemented categorize_content_files() with file type detection
- [x] 3.5: Content integration logic - Implemented generate_output_content() with full integration
- [x] 3.6: Fallback front matter generation - Implemented with smart title conversion and argument-hint detection

### Task 4: Output Generation
- [x] 4.1: Filename sanitization - Implemented generate_output_filename() with comprehensive edge case handling
- [x] 4.2: Naming conflict resolution - Implemented check_naming_conflict() with numeric suffix handling
- [x] 4.3: Output directory creation - Implemented ensure_output_directory() and write_output_file() with comprehensive error handling
- [x] 4.4: File writer with overwrite tracking - Enhanced write_output_file() to detect and log overwrites vs new file creation
- [x] 4.5: Integration in SkillProcessor - Complete pipeline working with 6-step process (discover→extract→categorize→generate→write→report)

### Task 5: Error Handling and Reporting
- [x] 5.1: Retry mechanism - Implemented retry_operation() with configurable retries, delays, and comprehensive logging
- [x] 5.2: Graceful error recovery - Refactored safe_read_file() and write_output_file() to use retry_operation(), proper exception handling for non-retryable errors
- [x] 5.3: Processing logger - Already implemented in process_skill() with 6-step logging, file-level logging in read operations
- [x] 5.4: Report summary section - Implemented format_summary_section() with statistics and success rate
- [x] 5.5: Report success section - Implemented format_success_section() listing all successful conversions with details
- [x] 5.6: Report failure section - Implemented format_failure_section() with errors and suggestions
- [x] 5.7: Report generation integration - Implemented generate_report(), print_report(), and run() with complete orchestration

### Task 6: Testing and Validation
- [x] 6.1: Test with mcp-builder - Tested successfully (5 files, 101.7 KB output)
- [x] 6.2: Test with theme-factory - Tested successfully (11 files, 5.9 KB output)
- [x] 6.3: Test missing SKILL.md - Tested with fallback metadata generation
- [x] 6.4: Test all edge cases - Tested with retry logic, encoding detection, naming conflicts
- [x] 6.5: Test full batch processing - Successfully processed all 22 skills, 29 output files (2.7 MB), 100% success rate
- [x] 6.6: Validate output format quality - All outputs follow YAML front matter + markdown structure with proper sections
- [x] 6.7: Final integration test - Complete end-to-end test with comprehensive reporting

---

## Time Estimates

| Task | Subtasks | Estimated Hours | Notes |
|------|----------|-----------------|-------|
| Task 1 | 6 | 7.5 hours | Foundation and structure |
| Task 2 | 5 | 9 hours | File discovery logic |
| Task 3 | 6 | 14 hours | Most complex - content processing |
| Task 4 | 5 | 10 hours | Output generation and formatting |
| Task 5 | 7 | 12 hours | Error handling and reporting |
| Task 6 | 7 | 11.5 hours | Comprehensive testing |
| **Total** | **36** | **64 hours** | **~2 weeks for 1 developer** |

---

## Dependencies Between Tasks

```
Task 1 (Setup)
    ↓
Task 2 (Discovery) ← Must have classes from Task 1
    ↓
Task 3 (Processing) ← Must have discovery from Task 2
    ↓
Task 4 (Output) ← Must have processing from Task 3
    ↓
Task 5 (Errors & Reporting) ← Integrated throughout Tasks 2-4
    ↓
Task 6 (Testing) ← Requires complete implementation
```

**Recommendation:** Execute tasks sequentially. Each task builds on the previous one.

---

## Success Metrics

### Code Quality
- [ ] All functions have docstrings
- [ ] Type hints used throughout
- [ ] Modular, maintainable code
- [ ] Proper error handling everywhere
- [ ] DRY principle followed

### Functionality
- [ ] Processes all accessible skill directories
- [ ] Handles all edge cases gracefully
- [ ] Generates valid markdown output
- [ ] Follows sample format exactly
- [ ] Success rate ≥ 95%

### Performance
- [ ] Processes 50 skills in < 30 seconds
- [ ] Memory usage < 500MB
- [ ] Deterministic output (same results on repeat runs)

### Reporting
- [ ] Complete, accurate final report
- [ ] All operations logged
- [ ] Errors clearly described
- [ ] Actionable suggestions provided

---

**Generated by:** 2-generate-tasks agent (Phase 2)
**Date:** 2025-11-12
**PRD Version:** 1.1
**Status:** Detailed subtasks ready for implementation
