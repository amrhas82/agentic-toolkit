# Development Tasks: Skill-to-Command Converter v2.0

**Source PRD:** PRD_converter_modifications_v2.md
**Generated:** 2025-11-13
**Status:** Detailed sub-tasks ready for implementation

---

## Relevant Files

### Files to Modify
- `skill-to-command/skill_to_command_converter.py` - Main converter script (2616 lines, v1.0)
  - Add: `TransformationMode` enum class
  - Add: `ModeDetector` class
  - Add: `MarkdownMerger` class
  - Add: `SubdirectoryPreserver` class
  - Add: `PathUpdater` class
  - Modify: `ProcessingResult` dataclass (add new fields)
  - Modify: `SkillConverter` class (integrate new components)
  - Modify: `SkillConverter.process_skill()` method (add mode-based processing)

### Files to Create
- `skill-to-command/test/test_mode_detector.py` - Unit tests for mode detection (new file)
- `skill-to-command/test/test_markdown_merger.py` - Unit tests for markdown merging (new file)
- `skill-to-command/test/test_subdirectory_preserver.py` - Unit tests for subdirectory copying (new file)
- `skill-to-command/test/test_path_updater.py` - Unit tests for path updating (new file)
- `skill-to-command/test/test_integration_v2.py` - Integration tests for v2.0 features (new file)
- `skill-to-command/test/fixtures/` - Test fixture directories (new directory with sample skills)

### Reference Files
- `skill-to-command/COMMAND_SKELETON_TEMPLATE.md` - Output format template (reference only)
- `packages/droid/commands/algorithmic-art.md` - Sample format reference (reference only)

### Notes

- **Existing Architecture:** The converter uses a class-based design with `SkillConverter` as the main orchestrator
- **Error Handling Pattern:** Existing code uses `retry_operation()` wrapper and try/except with detailed logging
- **Testing Framework:** Create tests using Python's `unittest` module (consistent with project patterns)
- **File Reading:** Existing code has robust `safe_read_file()` with encoding detection - leverage this
- **Constants Location:** Add new constants (SCRIPT_EXTENSIONS, EXCLUDE_DIRS, etc.) near existing constants at top of file
- **Backwards Compatibility:** Ensure v1.0 single-file skills still work correctly with v2.0 changes
- **Path Handling:** Existing code uses `pathlib.Path` throughout - maintain consistency

---

## Tasks

- [ ] 1.0 Implement Mode Detection System
  - [x] 1.1 Create TransformationMode enum with three modes (DIRECTORY_WITH_SUBDIRS, DIRECTORY_WITH_SCRIPTS, SINGLE_FILE)
  - [x] 1.2 Create ModeDetector class with detection algorithm
  - [x] 1.3 Implement subdirectory detection logic (exclude __pycache__, .git, node_modules)
  - [x] 1.4 Implement root-level script detection by file extensions (.sh, .py, .js, .ts, .rb, .pl)
  - [ ] 1.5 Add mode detection result logging with reasoning
  - [ ] 1.6 Write unit tests for all three mode detection scenarios

- [ ] 2.0 Build Markdown Merging System
  - [ ] 2.1 Create MarkdownMerger class structure
  - [ ] 2.2 Implement YAML frontmatter extraction method (can leverage existing extract_yaml_frontmatter)
  - [ ] 2.3 Implement content-without-frontmatter reader method
  - [ ] 2.4 Implement merge algorithm that combines SKILL.md + other .md files alphabetically
  - [ ] 2.5 Ensure each merged file becomes a ## section with filename as header
  - [ ] 2.6 Add validation to prevent duplicate frontmatter blocks
  - [ ] 2.7 Write unit tests for merging 1, 2, and 5+ markdown files
  - [ ] 2.8 Write edge case tests (no SKILL.md, empty files, files with no frontmatter)

- [ ] 3.0 Implement Subdirectory Preservation
  - [ ] 3.1 Create SubdirectoryPreserver class structure
  - [ ] 3.2 Implement recursive directory copy method using shutil.copytree with ignore patterns
  - [ ] 3.3 Implement file permission preservation (especially executable bit for scripts)
  - [ ] 3.4 Add exclusion logic for LICENSE.txt, .gitignore, __pycache__ at any depth
  - [ ] 3.5 Implement symbolic link handling (resolve before copying)
  - [ ] 3.6 Add file count tracking and reporting
  - [ ] 3.7 Write unit tests for copying single directory, nested directories, and exclusions
  - [ ] 3.8 Write tests for permission preservation on executable files

- [ ] 4.0 Build Script Relocation and Path Updater
  - [ ] 4.1 Create PathUpdater class structure
  - [ ] 4.2 Implement script file detection by extensions (SCRIPT_EXTENSIONS constant)
  - [ ] 4.3 Implement script relocation method (move to /commands/{skill-name}/ subdirectory)
  - [ ] 4.4 Implement regex-based path finding in markdown (./script.sh patterns)
  - [ ] 4.5 Implement path replacement algorithm (./script.sh → ./{skill-name}/script.sh)
  - [ ] 4.6 Add tracking for number of path updates made
  - [ ] 4.7 Add edge case handling for paths in code blocks (preserve as examples, don't update)
  - [ ] 4.8 Write unit tests for path detection and replacement
  - [ ] 4.9 Write tests for relative vs absolute path handling

- [ ] 5.0 Enhance Converter Core Logic
  - [ ] 5.1 Add new fields to ProcessingResult dataclass (transformation_mode, markdown_files_merged, subdirectories_copied, scripts_relocated, path_updates_count, path_update_details)
  - [ ] 5.2 Initialize new component classes in SkillConverter.__init__() method
  - [ ] 5.3 Refactor process_skill() to detect mode first using ModeDetector
  - [ ] 5.4 Implement _process_with_subdirs() private method for Scenario 1
  - [ ] 5.5 Implement _process_with_scripts() private method for Scenario 3
  - [ ] 5.6 Implement _process_single_file() private method for Scenario 2 (refactor existing logic)
  - [ ] 5.7 Update process_skill() to route to appropriate method based on detected mode
  - [ ] 5.8 Ensure output structure is consistent: /commands/{skill}.md + /commands/{skill}/ for assets
  - [ ] 5.9 Add fallback behavior when mode detection is ambiguous (default to SINGLE_FILE with warning)

- [ ] 6.0 Upgrade Reporting and Error Handling
  - [ ] 6.1 Update format_success_section() to include transformation mode in output
  - [ ] 6.2 Add reporting of markdown files merged (count and filenames)
  - [ ] 6.3 Add reporting of subdirectories copied (count and paths)
  - [ ] 6.4 Add reporting of scripts relocated (count and filenames)
  - [ ] 6.5 Add reporting of path updates performed (count and before/after examples)
  - [ ] 6.6 Implement PARTIAL_SUCCESS status for when some operations fail but conversion continues
  - [ ] 6.7 Add detailed error messages for subdirectory copy failures
  - [ ] 6.8 Add warnings for path update failures (log but don't fail entire conversion)
  - [ ] 6.9 Update print_report() to display enhanced metrics in readable format

- [ ] 7.0 Create Test Suite and Validation
  - [ ] 7.1 Create test fixture directory structure in skill-to-command/test/fixtures/
  - [ ] 7.2 Create fixture: simple skill (SKILL.md only) for SINGLE_FILE mode testing
  - [ ] 7.3 Create fixture: skill with subdirectories (like docx) for DIRECTORY_WITH_SUBDIRS testing
  - [ ] 7.4 Create fixture: skill with root scripts for DIRECTORY_WITH_SCRIPTS testing
  - [ ] 7.5 Write integration test for complete Scenario 1 workflow (subdirs)
  - [ ] 7.6 Write integration test for complete Scenario 3 workflow (scripts)
  - [ ] 7.7 Write integration test for complete Scenario 2 workflow (single file)
  - [ ] 7.8 Write integration test verifying v1.0 backwards compatibility
  - [ ] 7.9 Create test runner script that executes all unit and integration tests
  - [ ] 7.10 Run converter on real skill directories (docx, root-cause-tracing, algorithmic-art) and manually validate output
  - [ ] 7.11 Document test coverage and create test execution instructions

---

## Implementation Notes

### Critical Success Factors
1. **Mode Detection First:** Task 1.0 is the foundation - all other features depend on correct mode detection
2. **Preserve Existing Behavior:** SINGLE_FILE mode (Scenario 2) must work identically to v1.0 to ensure backwards compatibility
3. **Path Consistency:** ALL output markdown files go to /commands/ root, ALL subdirectories go to /commands/{skill-name}/
4. **Permission Preservation:** Scripts must retain executable permissions after copying - this is critical for user experience
5. **Idempotent Operations:** Running converter multiple times should produce identical results

### Testing Strategy
- **Unit Tests:** Test each component class independently with mock data
- **Integration Tests:** Test complete workflows with fixture directories
- **Manual Validation:** Run on real skills (docx, root-cause-tracing, algorithmic-art) and verify:
  - Output structure matches specification
  - Scripts are executable
  - Paths in documentation work correctly
  - No files are lost or corrupted

### Architectural Patterns to Follow
- **Class-based Components:** Create separate classes for each major responsibility (ModeDetector, MarkdownMerger, etc.)
- **Dataclasses for Results:** Use @dataclass for structured result objects (following ProcessingResult pattern)
- **Retry Logic:** Use existing retry_operation() wrapper for file operations that might fail
- **Path Objects:** Use pathlib.Path throughout (not string paths)
- **Detailed Logging:** Log all decisions and operations for debuggability

### Potential Challenges
1. **Path Update Edge Cases:** Code blocks vs. actual file references - use context to distinguish
2. **Frontmatter Parsing:** Existing code handles malformed YAML - leverage this for merged files too
3. **Permission Handling:** Windows vs. Linux permission models - test on both if possible
4. **Circular Symlinks:** Ensure symbolic link resolution doesn't create infinite loops
5. **Binary Files in Subdirs:** Copy as-is without attempting to read/parse

### Dependencies
- **Existing:** pathlib, shutil, re, dataclasses (all standard library)
- **Optional:** PyYAML (already used), chardet (already used)
- **No New Dependencies:** All v2.0 features use standard library only

### Rollout Strategy
1. Implement and test mode detection independently
2. Implement and test each transformation component independently
3. Integrate components into main converter
4. Test integration thoroughly with fixtures
5. Validate with real skill directories
6. Run full test suite before considering complete

---

**Status:** Ready for implementation - all sub-tasks defined and sequenced.
**Next Step:** Use 3-process-task-list agent to begin implementation.
