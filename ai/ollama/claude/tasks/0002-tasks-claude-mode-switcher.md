# Task List: Claude Mode Switcher Implementation

**PRD Reference:** `0001-prd-claude-mode-switcher.md`
**Status:** Phase 2 - Detailed Sub-Tasks (Ready for Implementation)
**Generated:** 2025-11-09

---

## Relevant Files

### Core Implementation Files
- `~/.claude/switcher/switch-mode.sh` - Main switcher script with all mode switching logic
- `~/.claude/switcher/switch-mode.sh.test` - Unit tests for switcher functions
- `~/.claude/switcher/integration-tests.sh` - Integration and end-to-end tests

### Preset Configuration Files
- `~/.claude/switcher/presets/glm/glm.json` - Master GLM configuration with all settings
- `~/.claude/switcher/presets/glm/fast-glm.json` - GLM-4-flash/plus/plus preset
- `~/.claude/switcher/presets/glm/fast-claude.json` - Claude Haiku/Sonnet/Opus preset
- `~/.claude/switcher/presets/glm/cc-mixed.json` - Mixed GLM and Claude preset
- `~/.claude/switcher/presets/glm/cc-glm.json` - GLM-optimized preset

### System Integration Files
- `~/.bashrc` or `~/.zshrc` - Shell configuration to define cc-change function/alias
- `~/.local/bin/cc-change` - Symlink to switch-mode.sh for global command invocation
- `README.md` (project root) - Updated documentation for new switcher
- `aliases.sh` (if exists) - Updated to reference new cc-change command

### Log Files (Generated at Runtime)
- `~/.claude/switcher/logs/switch-YYYYMMDD-HHMMSS.log` - Timestamped operation logs

### Backup Files (Generated at Runtime)
- `~/.claude/settings.json.backup.YYYYMMDD-HHMMSS` - Timestamped backups
- `~/.claude/settings.json.last` - Tracking file for last injected configuration

### Documentation Files (Create)
- `~/.claude/switcher/TROUBLESHOOTING.md` - Error messages and recovery procedures
- `~/.claude/switcher/INSTALLATION.md` - Setup instructions

---

## Implementation Notes

### Architecture & Design Patterns
1. **Single Script Architecture:** All functionality in `switch-mode.sh` with modular functions
2. **Function Organization:**
   - Utility functions: `backup_settings()`, `restore_settings()`, `validate_json()`
   - Core functions: `remove_injection()`, `inject_preset()`, `merge_configs()`
   - Menu functions: `display_menu()`, `show_status()`, `show_list()`, `show_dry_run()`
   - Main workflow: `execute_switch()`, orchestrates entire operation
3. **JSON Processing:** Use `jq` for all JSON parsing/manipulation (no string parsing)
4. **Error Handling:** Trap signals and exit codes; rollback automatically on any failure
5. **Logging:** Simple append-only logs with timestamps; structured for grep-ability

### JSON Validation Strategy
- **Syntax:** `jq empty < settings.json` to detect JSON parse errors
- **Structure:** Verify root is object, check expected top-level keys
- **Safety:** Validate before writing; compare checksums before/after operations

### Testing Framework
- **Unit Tests:** Use `bats` (Bash Automated Testing System) for function testing
- **Integration Tests:** Test full workflows with real file operations in temp directories
- **Fixtures:** Create example settings.json, preset files, and corruption scenarios
- **Mocking:** Create helper functions to simulate failures

### Key Constraints & Assumptions
- Bash 4.0+ (for associative arrays)
- `jq` 1.6+ available in PATH
- Standard Unix utilities (cat, cp, mv, rm, mkdir, date)
- settings.json is up to 100KB (reasonable Claude Code config)
- Operations must complete in under 3 seconds on typical hardware
- All paths use absolute paths ($HOME expansion)

### Dependency Order
1. **Task 1.0** must complete before any other tasks
2. **Task 2.0** must complete before Task 3.0 (presets needed for injection)
3. **Task 3.0** must complete before Tasks 4.0, 5.0, 6.0
4. **Tasks 1.0-6.0** must complete before Task 7.0 (testing)
5. **Tasks 1.0-7.0** must complete before Task 8.0 (documentation)

### Code Style Guide
- Function names: `snake_case`
- Variable names: `UPPERCASE` for globals, `lowercase` for locals
- Indentation: 2 spaces (match existing patterns in agentic-toolkit)
- Comments: Explain "why" not "what"
- Error messages: User-friendly, actionable, brief

---

## Phase 1: High-Level Parent Tasks (Recap)

- [x] **1.0 Foundation: Core Architecture & Setup**
- [x] **2.0 Configuration & Presets Management**
- [x] **3.0 Core Switching Logic Implementation**
- [x] **4.0 Command Interface & User Experience**
- [ ] **5.0 Error Handling & Recovery**
- [ ] **6.0 Migration & Deprecation**
- [ ] **7.0 Comprehensive Testing Suite**
- [ ] **8.0 Documentation & Installation**

---

## Phase 2: Detailed Sub-Tasks

### 1.0 Foundation: Core Architecture & Setup

- [x] 1.1 Create directory structure and script skeleton
  - **Action:** Create `/home/hamr/.claude/switcher/` directory with subdirectories: `presets/glm/`, `logs/`
  - **Files to Create:**
    - `~/.claude/switcher/switch-mode.sh` (empty Bash script with shebang and header comment)
    - Create directories: `presets/glm/`, `logs/`
  - **Implementation Details:**
    - Use `mkdir -p` to create nested directories
    - Add file header comment with script purpose, usage, and version
    - Add strict mode: `set -euo pipefail` and error handler `trap 'handle_error' ERR`
    - Define global variables: `SETTINGS_FILE`, `SETTINGS_LAST`, `BACKUPS_DIR`, `LOGS_DIR`, `PRESETS_DIR`
    - Make script executable: `chmod 755 switch-mode.sh`
  - **Acceptance Criteria:**
    - All directories exist with correct permissions (755)
    - Script file is readable/executable
    - Global variables defined in script
  - **Dependencies:** None
  - **Complexity:** Small (15-30 min)
  - **Testing:** Manual verification: `ls -la ~/.claude/switcher/`

- [x] 1.2 Implement utility functions: logging and error handling
  - **Action:** Add functions to `switch-mode.sh`: `log_message()`, `log_error()`, `handle_error()`, `create_backup()`
  - **Files to Modify:**
    - `~/.claude/switcher/switch-mode.sh`
  - **Implementation Details:**
    - `log_message()`: Append to log file with timestamp. Usage: `log_message "Operation X completed"`
      - Ensure log file is created if missing
      - Use format: `[YYYY-MM-DD HH:MM:SS] MESSAGE`
      - Log file path: `~/.claude/switcher/logs/switch-$(date +%Y%m%d-%H%M%S).log`
    - `log_error()`: Log error with context. Usage: `log_error "File not found: $file"`
    - `handle_error()`: Called on trap ERR. Logs line number, exit code, attempts rollback
    - `create_backup()`: Creates timestamped backup of settings.json if it exists
      - Backup path: `~/.claude/settings.json.backup.YYYYMMDD-HHMMSS`
      - Only create if settings.json exists; handle missing file gracefully
      - Use: `cp settings.json settings.json.backup.$(date +%Y%m%d-%H%M%S)`
    - All functions should return 0 on success, exit with code on error
  - **Acceptance Criteria:**
    - `log_message()` creates log files in ~/.claude/switcher/logs/ with correct timestamp format
    - `create_backup()` creates timestamped backups in ~/.claude/ directory
    - `handle_error()` is called on any script error via trap
    - Functions handle edge cases (missing files, permission errors)
  - **Dependencies:** None (foundational)
  - **Complexity:** Medium (1-2 hours)
  - **Testing:** Create simple tests: call each function, verify outputs

- [ ] 1.3 Implement backup and restore functions
  - **Action:** Add functions `backup_settings()`, `restore_from_backup()`, `list_backups()`
  - **Files to Modify:**
    - `~/.claude/switcher/switch-mode.sh`
  - **Implementation Details:**
    - `backup_settings()`:
      - Backs up current settings.json to timestamped file
      - Called before any modification to settings.json
      - Returns backup filename for potential rollback
    - `restore_from_backup()`:
      - Takes backup filename as argument
      - Restores settings.json from backup
      - Validates restored file before declaring success
      - Used on validation failure or error
    - `list_backups()`:
      - Lists all backup files with timestamps, sorted newest first
      - Optional: Used by diagnostic/help commands
    - Backup validation: verify file exists, is readable, contains valid JSON
  - **Acceptance Criteria:**
    - Backup files are created with YYYYMMDD-HHMMSS format in correct directory
    - Restore correctly replaces settings.json from backup
    - Restore validates JSON before completing
    - Multiple backups can exist without conflict
    - Handles case where settings.json doesn't exist initially
  - **Dependencies:** Task 1.2
  - **Complexity:** Medium (1-2 hours)
  - **Testing:** Create fixtures with test settings.json files; test backup/restore cycle

- [ ] 1.4 Implement JSON validation function
  - **Action:** Add function `validate_json_syntax()` and `validate_json_structure()`
  - **Files to Modify:**
    - `~/.claude/switcher/switch-mode.sh`
  - **Implementation Details:**
    - `validate_json_syntax()`:
      - Uses `jq empty < file` to check if JSON is valid
      - Returns 0 if valid, 1 if invalid
      - Captures jq error messages for logging
    - `validate_json_structure()`:
      - Ensures root element is an object (not array, string, etc.)
      - Checks for expected top-level keys (if defined in preset)
      - Basic schema validation: verify expected keys have correct types
      - Example: "models" key should be an object, not a string
    - Both functions should log validation details for debugging
    - Used before committing changes to settings.json
  - **Acceptance Criteria:**
    - Detects invalid JSON (missing braces, malformed arrays, etc.)
    - Detects structural issues (root is array instead of object)
    - Returns clear error messages indicating what failed
    - Passes valid settings.json files without complaint
    - Works with files up to 100KB without performance issues
  - **Dependencies:** Task 1.2
  - **Complexity:** Small-Medium (45 min - 1.5 hours)
  - **Testing:** Create fixture files with valid/invalid JSON; test all scenarios

- [ ] 1.5 Implement settings.json.last tracking functions
  - **Action:** Add functions `read_last_injection()`, `save_last_injection()`, `clear_last_injection()`
  - **Files to Modify:**
    - `~/.claude/switcher/switch-mode.sh`
  - **Implementation Details:**
    - `read_last_injection()`:
      - Reads ~/.claude/settings.json.last and echoes content (pure JSON)
      - Returns 1 if file doesn't exist (not an error, just no previous injection)
      - Validates that file contains valid JSON before echoing
    - `save_last_injection()`:
      - Takes JSON as argument (via stdin or variable)
      - Writes to ~/.claude/settings.json.last with exact formatting
      - Preserves JSON formatting (2-space indentation)
      - Creates file if missing, overwrites if exists
    - `clear_last_injection()`:
      - Removes ~/.claude/settings.json.last file
      - Used when switching to cc-native mode
      - Safe to call even if file doesn't exist
    - All functions should validate JSON content before writing
  - **Acceptance Criteria:**
    - Settings.json.last file is created with valid JSON content
    - File can be read back and used for key removal
    - Clear operation removes file without error
    - Handles non-existent file gracefully
    - JSON formatting is consistent (2 spaces, newlines)
  - **Dependencies:** Task 1.2, 1.4
  - **Complexity:** Small (45 min - 1 hour)
  - **Testing:** Test write/read cycle; verify JSON formatting; test with missing file

- [ ] 1.6 Create main script structure with argument parsing
  - **Action:** Add main function and argument parsing to `switch-mode.sh`
  - **Files to Modify:**
    - `~/.claude/switcher/switch-mode.sh`
  - **Implementation Details:**
    - Add `main()` function that orchestrates entire workflow
    - Add argument parsing for flags: `--status`, `--list`, `--dry-run MODE`, `--reinject MODE`
    - Add default interactive mode when no args provided
    - Usage/help message explaining all commands and options
    - Call appropriate function based on arguments
    - Exit with proper code (0 on success, 1 on error)
    - Example structure:
      ```bash
      case "${1:-}" in
        --status) show_status ;;
        --list) show_list ;;
        --dry-run) show_dry_run "$2" ;;
        --reinject) reinject_mode "$2" ;;
        --help) show_help ;;
        "") display_menu ;;
        *) echo "Unknown option: $1"; show_help; exit 1 ;;
      esac
      ```
  - **Acceptance Criteria:**
    - Script accepts all documented flags without error
    - Unknown flags show help message and exit with code 1
    - Script can be called with no arguments (default to menu)
    - All entry points properly log their invocation
  - **Dependencies:** Tasks 1.1-1.5
  - **Complexity:** Small (30-45 min)
  - **Testing:** Test each flag individually; test invalid flags

---

### 2.0 Configuration & Presets Management

- [ ] 2.1 Create master glm.json configuration file
  - **Action:** Create `/home/hamr/.claude/switcher/presets/glm/glm.json` with comprehensive GLM settings
  - **Files to Create:**
    - `~/.claude/switcher/presets/glm/glm.json`
  - **Implementation Details:**
    - Define complete GLM configuration with all possible settings
    - Structure as object with top-level configuration sections
    - Include model mappings for GLM variants: `glm-4-flash`, `glm-4-plus`, `glm-4-turbo`
    - Include MCP server configurations if applicable
    - Include any GLM-specific features or parameters
    - Use 2-space indentation for consistency
    - Add comments explaining sections (use JSON-compatible comments where applicable, or add README)
    - Example structure:
      ```json
      {
        "mcpServers": {
          "glm-local": {
            "command": "ollama",
            "args": ["serve"]
          }
        },
        "models": {
          "haiku": "glm-4-flash",
          "sonnet": "glm-4-plus",
          "opus": "glm-4-plus"
        },
        "features": {
          "streaming": true
        }
      }
      ```
    - This file serves as the "source of truth" for GLM settings
  - **Acceptance Criteria:**
    - File is valid JSON (verified by `jq`)
    - File includes all GLM model configurations
    - File can be read by jq without errors
    - File formatting is consistent (2 spaces, proper indentation)
    - File path is correct: `~/.claude/switcher/presets/glm/glm.json`
  - **Dependencies:** Task 1.1
  - **Complexity:** Medium (1-1.5 hours) - depends on final GLM config complexity
  - **Testing:** `jq . glm.json | head` succeeds; validate structure against schema

- [ ] 2.2 Create fast-glm.json preset (GLM-4-flash, GLM-4-plus, GLM-4-plus)
  - **Action:** Create `/home/hamr/.claude/switcher/presets/glm/fast-glm.json` preset inspired by glm.json
  - **Files to Create:**
    - `~/.claude/switcher/presets/glm/fast-glm.json`
  - **Implementation Details:**
    - This preset represents: haiku=glm-4-flash, sonnet=glm-4-plus, opus=glm-4-plus
    - Can be subset of glm.json or enhanced version
    - Must be complete, standalone configuration (doesn't rely on glm.json)
    - Include model mappings, MCP servers, and any GLM-specific settings
    - Use same 2-space indentation as glm.json
    - Optimize for "fast" operations: prioritize speed over capability
  - **Acceptance Criteria:**
    - File is valid JSON (verified by `jq`)
    - File is complete and standalone (not referencing glm.json)
    - Contains correct model mappings (flash/plus/plus)
    - File can be injected without errors
    - File formatting matches glm.json style
  - **Dependencies:** Task 2.1, 1.1
  - **Complexity:** Small-Medium (45 min - 1 hour)
  - **Testing:** `jq . fast-glm.json` succeeds; verify model mappings with `jq '.models'`

- [ ] 2.3 Create fast-claude.json preset (Haiku, Sonnet, Opus)
  - **Action:** Create `/home/hamr/.claude/switcher/presets/glm/fast-claude.json` preset
  - **Files to Create:**
    - `~/.claude/switcher/presets/glm/fast-claude.json`
  - **Implementation Details:**
    - This preset represents: haiku=claude-3-haiku, sonnet=claude-sonnet-4-5, opus=claude-opus-4
    - Must be complete, standalone configuration
    - Include model mappings for Anthropic Claude models
    - Include any Claude-specific MCP servers or configurations
    - Use same JSON formatting as other presets
  - **Acceptance Criteria:**
    - File is valid JSON
    - Contains correct model mappings (haiku/sonnet-4-5/opus-4)
    - File is complete and can be injected without dependency on other files
    - Formatting is consistent with other presets
  - **Dependencies:** Task 2.1, 1.1
  - **Complexity:** Small-Medium (45 min - 1 hour)
  - **Testing:** `jq . fast-claude.json` succeeds; verify models contain "claude"

- [ ] 2.4 Create cc-mixed.json preset (mixed GLM and Claude models)
  - **Action:** Create `/home/hamr/.claude/switcher/presets/glm/cc-mixed.json` preset
  - **Files to Create:**
    - `~/.claude/switcher/presets/glm/cc-mixed.json`
  - **Implementation Details:**
    - This preset represents: haiku=glm-4-flash, sonnet=claude-sonnet-4-5, opus=claude-opus-4
    - Mixed approach: fast GLM for low-thinking, Claude for medium/high-thinking
    - Must be complete, standalone configuration
    - Include both GLM and Claude configurations
    - Use consistent JSON formatting
  - **Acceptance Criteria:**
    - File is valid JSON
    - Contains mixed model mappings (glm for haiku, claude for sonnet/opus)
    - File is complete and standalone
    - Formatting matches other presets
  - **Dependencies:** Task 2.1-2.3, 1.1
  - **Complexity:** Small-Medium (45 min - 1 hour)
  - **Testing:** `jq '.models' cc-mixed.json` shows glm-4-flash, claude-sonnet-4-5, claude-opus-4

- [ ] 2.5 Create cc-glm.json preset (GLM-optimized configuration)
  - **Action:** Create `/home/hamr/.claude/switcher/presets/glm/cc-glm.json` preset
  - **Files to Create:**
    - `~/.claude/switcher/presets/glm/cc-glm.json`
  - **Implementation Details:**
    - This preset is GLM-optimized (similar to fast-glm but with CC-specific tuning)
    - Same model mappings: haiku=glm-4-flash, sonnet=glm-4-plus, opus=glm-4-plus
    - May include additional Claude Code-specific configurations
    - Must be complete, standalone configuration
    - Use consistent JSON formatting
  - **Acceptance Criteria:**
    - File is valid JSON
    - Contains GLM model mappings (flash/plus/plus)
    - File is complete and standalone
    - Formatting is consistent
  - **Dependencies:** Task 2.1-2.4, 1.1
  - **Complexity:** Small-Medium (45 min - 1 hour)
  - **Testing:** `jq '.models' cc-glm.json` shows all glm models

- [ ] 2.6 Validate all preset files for JSON syntax and structure
  - **Action:** Validate glm.json, fast-glm.json, fast-claude.json, cc-mixed.json, cc-glm.json
  - **Files to Validate:**
    - `~/.claude/switcher/presets/glm/glm.json`
    - `~/.claude/switcher/presets/glm/fast-glm.json`
    - `~/.claude/switcher/presets/glm/fast-claude.json`
    - `~/.claude/switcher/presets/glm/cc-mixed.json`
    - `~/.claude/switcher/presets/glm/cc-glm.json`
  - **Implementation Details:**
    - Use `jq empty < file` to validate syntax for each preset
    - Check that each preset is an object (root element)
    - Verify each preset contains "models" key with object value
    - Verify "models" contains "haiku", "sonnet", "opus" keys
    - Check for any obvious issues (empty files, missing braces, etc.)
    - Create validation script or run manual checks
  - **Acceptance Criteria:**
    - All five preset files pass JSON syntax validation
    - All presets are objects (not arrays or primitives)
    - All presets contain required "models" key
    - No jq errors occur when processing presets
  - **Dependencies:** Tasks 2.1-2.5
  - **Complexity:** Small (30 min)
  - **Testing:** Run `jq . ~/claude/switcher/presets/glm/*.json` for all files

- [ ] 2.7 Set appropriate file permissions for preset files
  - **Action:** Set permissions on all preset files to ensure correct access
  - **Files to Modify:**
    - `~/.claude/switcher/presets/glm/glm.json` → 644
    - `~/.claude/switcher/presets/glm/fast-glm.json` → 644
    - `~/.claude/switcher/presets/glm/fast-claude.json` → 644
    - `~/.claude/switcher/presets/glm/cc-mixed.json` → 644
    - `~/.claude/switcher/presets/glm/cc-glm.json` → 644
  - **Implementation Details:**
    - Use `chmod 644 file` for all preset files (read-only for user/group/others, write for user)
    - Use `chmod 755 directory` for all directories (executable to allow traversal)
    - Verify permissions with `ls -la`
  - **Acceptance Criteria:**
    - All preset files are readable (644)
    - All directories are readable and traversable (755)
    - Permissions can be verified: `ls -la ~/.claude/switcher/presets/`
  - **Dependencies:** Tasks 2.1-2.6
  - **Complexity:** Small (15 min)
  - **Testing:** `ls -la ~/.claude/switcher/presets/glm/` shows correct permissions

---

### 3.0 Core Switching Logic Implementation

- [ ] 3.1 Implement key removal function: remove_injection()
  - **Action:** Add function to remove previously injected keys from settings.json
  - **Files to Modify:**
    - `~/.claude/switcher/switch-mode.sh`
  - **Implementation Details:**
    - Function signature: `remove_injection()` - no arguments
    - Read ~/.claude/settings.json.last (previous injection) or return 0 if missing
    - Read ~/.claude/settings.json (current settings)
    - For each top-level key in settings.json.last, delete from settings.json
    - Example: if settings.json.last has {"models": {...}, "mcpServers": {...}}
      - Delete "models" and "mcpServers" keys from settings.json
      - Keep all other keys in settings.json untouched
    - Output resulting JSON to stdout
    - Use `jq 'del(.KEYNAME)' settings.json` for each key
    - Handle case where settings.json is empty or missing (should remain empty)
    - Don't modify files; only output result (caller handles writing)
  - **Acceptance Criteria:**
    - Correctly identifies keys in settings.json.last
    - Removes only those keys from settings.json
    - Preserves all other keys and their values
    - Outputs valid JSON
    - Works when settings.json.last is missing (no-op)
    - Works when settings.json is empty (remains empty)
  - **Dependencies:** Tasks 1.1-1.5
  - **Complexity:** Small-Medium (1-1.5 hours)
  - **Testing:** Create fixtures with multiple keys; verify only injected keys are removed

- [ ] 3.2 Implement preset injection/merging function: inject_preset()
  - **Action:** Add function to merge preset configuration into settings.json
  - **Files to Modify:**
    - `~/.claude/switcher/switch-mode.sh`
  - **Implementation Details:**
    - Function signature: `inject_preset(mode_name)` - takes mode name as argument
    - Read preset file from ~/.claude/switcher/presets/glm/{mode_name}.json
    - Read current settings.json
    - Merge preset into settings.json using jq:
      - `jq -s '.[0] * .[1]' settings.json preset.json` (shallow merge)
      - Or use recursive merge if needed for nested objects
    - Output resulting merged JSON to stdout
    - Handle case where settings.json doesn't exist (start with empty object {})
    - Preserve all settings that are NOT in the preset
    - Don't modify files; only output result
  - **Acceptance Criteria:**
    - Correctly merges preset keys into settings.json
    - Preserves non-preset keys from settings.json
    - Handles missing settings.json gracefully (starts with {})
    - Outputs valid JSON
    - Preset keys override settings.json keys (as intended)
  - **Dependencies:** Tasks 1.1-1.5, 2.1-2.5
  - **Complexity:** Small-Medium (1-1.5 hours)
  - **Testing:** Test with various fixtures; verify override and preservation behavior

- [ ] 3.3 Implement orchestration function: execute_switch()
  - **Action:** Add main orchestration function that coordinates entire mode switch
  - **Files to Modify:**
    - `~/.claude/switcher/switch-mode.sh`
  - **Implementation Details:**
    - Function signature: `execute_switch(mode_name)` - takes mode name as argument
    - Orchestrates complete workflow:
      1. Log switch attempt with mode name
      2. Create backup: `backup_settings()`
      3. Read settings.json (or start with {})
      4. Remove previous injection: `remove_injection()`
      5. If mode is "cc-native": skip to validation
      6. If mode is not cc-native: inject preset: `inject_preset(mode_name)`
      7. Validate result: `validate_json_syntax()` and `validate_json_structure()`
      8. If invalid: restore backup and exit with error
      9. If valid:
         - Write merged result to settings.json
         - Save injection to settings.json.last (or clear for cc-native)
         - Log success
         - Return 0
      10. Handle errors: catch any command failure, restore, log, exit 1
    - All steps should use proper error handling (set -e or explicit checks)
    - Log all actions for debugging
  - **Acceptance Criteria:**
    - Backup is created before any modifications
    - Previous injection is always removed first
    - New preset is injected (except cc-native)
    - Result is validated before writing
    - settings.json is updated only if validation passes
    - settings.json.last is updated (or cleared for cc-native)
    - On failure, settings.json is restored from backup
    - All steps are logged with timestamps
  - **Dependencies:** Tasks 1.1-3.2
  - **Complexity:** Large (2-3 hours)
  - **Testing:** Test each mode switch; simulate validation failures; verify rollback

- [ ] 3.4 Implement special case: cc-native mode (clean removal)
  - **Action:** Ensure cc-native mode correctly removes all injections without adding new ones
  - **Files to Modify:**
    - `~/.claude/switcher/switch-mode.sh` (in execute_switch and supporting functions)
  - **Implementation Details:**
    - cc-native mode (mode #5) should:
      1. Create backup
      2. Read settings.json
      3. Remove previous injection (using settings.json.last)
      4. Validate resulting JSON
      5. Write settings.json WITHOUT injecting any new preset
      6. Clear settings.json.last (delete the file)
      7. Log that cc-native mode was applied
    - This means settings.json will only contain user's persistent settings
    - Empty settings.json is valid (results in {})
    - No preset file for cc-native (no ~/.claude/switcher/presets/glm/cc-native.json)
  - **Acceptance Criteria:**
    - cc-native correctly removes injected keys
    - settings.json.last is deleted/cleared after cc-native switch
    - Resulting settings.json contains only persistent user settings
    - Validation succeeds even if result is empty object
    - Previous mode's injections are completely removed
  - **Dependencies:** Tasks 3.1-3.3
  - **Complexity:** Small-Medium (45 min - 1 hour)
  - **Testing:** Switch to various modes, then to cc-native; verify cleanup

- [ ] 3.5 Implement preservation of persistent settings
  - **Action:** Add logic to ensure user's non-injected settings survive mode switches
  - **Files to Modify:**
    - `~/.claude/switcher/switch-mode.sh` (in remove_injection and execute_switch)
  - **Implementation Details:**
    - Key principle: settings.json.last tracks exactly what was injected
    - When removing injection, delete ONLY keys present in settings.json.last
    - When merging new preset, preserve keys not in the new preset
    - Example:
      - User has: {"editor": "vim", "theme": "dark", "models": {"haiku": "old"}}
      - Previous injection was: {"models": {"haiku": "old"}}
      - New preset is: {"models": {"haiku": "new", ...}}
      - Result should be: {"editor": "vim", "theme": "dark", "models": {"haiku": "new", ...}}
    - This is naturally handled by remove_injection + inject_preset
    - Document this clearly in code comments
  - **Acceptance Criteria:**
    - User's persistent settings (e.g., "editor", "theme") are preserved across mode switches
    - Only injected keys are replaced, not all keys
    - Multiple mode switches preserve all persistent user settings
    - Can be verified by comparing before/after JSON for non-injected keys
  - **Dependencies:** Tasks 3.1-3.3
  - **Complexity:** Medium (1-1.5 hours) - mostly testing to verify behavior
  - **Testing:** Create fixture with persistent + injected settings; switch modes; verify preservation

- [ ] 3.6 Implement rollback mechanism for validation failures
  - **Action:** Ensure failed validations trigger automatic restore from backup
  - **Files to Modify:**
    - `~/.claude/switcher/switch-mode.sh` (in execute_switch)
  - **Implementation Details:**
    - If validation fails (syntax or structure error):
      1. Log validation failure with details
      2. Call `restore_from_backup(backup_filename)`
      3. Display user-friendly error message
      4. Exit with code 1
      5. Do NOT update settings.json.last (old mode remains active)
    - Backup filename is saved from create_backup() call
    - Restore must verify that settings.json is valid JSON after restore
    - If restore itself fails, inform user of critical situation
  - **Acceptance Criteria:**
    - Validation failure triggers restore from backup
    - Backup is correctly restored to settings.json
    - settings.json.last is not updated on validation failure
    - User is informed of failure and rollback
    - Old mode remains active after failed switch attempt
  - **Dependencies:** Tasks 1.3, 3.3
  - **Complexity:** Medium (1 hour)
  - **Testing:** Create invalid JSON result; verify rollback; check that old mode remains active

- [ ] 3.7 Test end-to-end mode switching for all five modes
  - **Action:** Create integration test script to verify all mode transitions work
  - **Files to Create:**
    - `~/.claude/switcher/integration-tests.sh` (or add to switch-mode.sh.test)
  - **Implementation Details:**
    - Test each mode switch: fast-glm → fast-claude → cc-mixed → cc-glm → cc-native → fast-glm
    - For each switch:
      - Verify settings.json is valid after switch
      - Verify settings.json.last matches what was injected
      - Verify previous mode's settings are removed
      - Verify persistent user settings are preserved
    - Create test fixtures (starting settings.json with persistent settings)
    - Clean up test files after each test
    - Use temp directory for testing to avoid affecting real settings
    - Test should succeed within 3 seconds
  - **Acceptance Criteria:**
    - All mode switches complete without error
    - settings.json is valid JSON after each switch
    - Mode-specific model mappings are correct
    - Persistent settings are preserved
    - All within 3-second time budget
  - **Dependencies:** Tasks 1.1-3.6, 2.1-2.5
  - **Complexity:** Large (2-3 hours for comprehensive testing)
  - **Testing:** Run integration test suite; verify all transitions work

---

### 4.0 Command Interface & User Experience

- [ ] 4.1 Implement interactive menu display
  - **Action:** Create display_menu() function that shows mode options
  - **Files to Modify:**
    - `~/.claude/switcher/switch-mode.sh`
  - **Implementation Details:**
    - Function signature: `display_menu()` - no arguments
    - Display formatted menu with all 5 modes:
      ```
      Claude Mode Switcher
      --------------------
      Select a mode:

      1. fast-glm (glm-4-flash, glm-4-plus, glm-4-plus)
         Low/Medium/High thinking with GLM models

      2. fast-claude (claude-3-haiku, claude-sonnet-4-5, claude-opus-4)
         Low/Medium/High thinking with Claude models

      3. cc-mixed (glm-4-flash, claude-sonnet-4-5, claude-opus-4)
         Mixed GLM and Claude models

      4. cc-glm (glm-4-flash, glm-4-plus, glm-4-plus)
         GLM-optimized configuration

      5. cc-native
         Remove all injections, use Claude Code defaults with persistent settings

      Enter selection (1-5):
      ```
    - Read user input, validate (1-5), call execute_switch() with selected mode
    - Handle invalid input (show error, re-prompt)
    - Use `read -p` for user input
  - **Acceptance Criteria:**
    - Menu displays cleanly in standard terminal
    - All 5 modes are visible with descriptions
    - Model mappings are accurate
    - Menu accepts input 1-5
    - Invalid input is rejected with error message
    - User can retry on invalid input
  - **Dependencies:** Task 1.6, 3.1-3.6
  - **Complexity:** Small (30-45 min)
  - **Testing:** Run script with no arguments; manually test all menu options

- [ ] 4.2 Implement --status flag (show current active mode)
  - **Action:** Create show_status() function that displays current mode
  - **Files to Modify:**
    - `~/.claude/switcher/switch-mode.sh`
  - **Implementation Details:**
    - Function signature: `show_status()` - no arguments
    - Determine current mode by reading ~/.claude/settings.json.last
    - If settings.json.last exists:
      - Parse to determine which preset is currently injected
      - Display: "Current mode: [mode-name]"
      - Show what was injected (brief summary)
    - If settings.json.last doesn't exist:
      - Display: "Current mode: cc-native (no injections applied)"
    - Show last switch timestamp if available (from log file)
    - Exit with code 0
  - **Acceptance Criteria:**
    - Correctly identifies current mode
    - Displays cc-native when no injections exist
    - Shows clear, user-friendly status message
    - Works without entering interactive menu
    - Can be called as `./switch-mode.sh --status`
  - **Dependencies:** Tasks 1.5, 1.6
  - **Complexity:** Small (30-45 min)
  - **Testing:** Apply different modes, verify --status shows correct mode

- [ ] 4.3 Implement --list flag (show available modes)
  - **Action:** Create show_list() function that displays all available modes
  - **Files to Modify:**
    - `~/.claude/switcher/switch-mode.sh`
  - **Implementation Details:**
    - Function signature: `show_list()` - no arguments
    - Display all available modes in simple list format:
      ```
      Available modes:
      1. fast-glm (glm-4-flash, glm-4-plus, glm-4-plus)
      2. fast-claude (claude-3-haiku, claude-sonnet-4-5, claude-opus-4)
      3. cc-mixed (glm-4-flash, claude-sonnet-4-5, claude-opus-4)
      4. cc-glm (glm-4-flash, glm-4-plus, glm-4-plus)
      5. cc-native (remove all injections)
      ```
    - Or use show_menu function but don't wait for input
    - Exit with code 0
  - **Acceptance Criteria:**
    - Displays all 5 modes clearly
    - Includes model mappings for each mode
    - Doesn't prompt for input
    - Can be called as `./switch-mode.sh --list`
  - **Dependencies:** Tasks 1.6, 4.1
  - **Complexity:** Small (15-30 min)
  - **Testing:** Run `./switch-mode.sh --list`; verify output

- [ ] 4.4 Implement --dry-run flag (preview changes)
  - **Action:** Create show_dry_run() function that shows what would change
  - **Files to Modify:**
    - `~/.claude/switcher/switch-mode.sh`
  - **Implementation Details:**
    - Function signature: `show_dry_run(mode_name)` - takes mode as argument
    - Show what would happen if user switched to this mode:
      1. Read current settings.json
      2. Show current state: "Current settings.json:"
      3. Simulate the switch (remove_injection + inject_preset)
      4. Show result: "After switching to [mode-name]:"
      5. Show diff or before/after JSON
      6. Do NOT modify any files
      7. Do NOT ask for confirmation
    - Format output clearly so user can see differences
    - Example: use `diff -u` or jq formatting
    - Exit with code 0
  - **Acceptance Criteria:**
    - Shows current settings.json
    - Shows how settings would change
    - Doesn't modify files
    - Can be called as `./switch-mode.sh --dry-run fast-glm`
    - Clearly indicates what would be added/removed/changed
  - **Dependencies:** Tasks 1.6, 3.1-3.2
  - **Complexity:** Small-Medium (1-1.5 hours)
  - **Testing:** Run dry-run for each mode; verify output is accurate and helpful

- [ ] 4.5 Implement --reinject flag (re-apply mode after API key update)
  - **Action:** Create reinject_mode() function for re-applying current mode
  - **Files to Modify:**
    - `~/.claude/switcher/switch-mode.sh`
  - **Implementation Details:**
    - Function signature: `reinject_mode(mode_name)` - takes mode as argument
    - Workflow:
      1. Log re-injection attempt
      2. Read current mode from settings.json.last
      3. If mode_name differs from current mode, warn user but proceed
      4. Call execute_switch(mode_name) to re-apply
      5. Log that re-injection was completed
    - Use case: user updated API key in preset file, wants to re-apply without switching away and back
    - Follows same backup/restore/validation process as normal switch
  - **Acceptance Criteria:**
    - Re-applies specified mode
    - Follows same safety checks as normal switch (backup, validation, rollback)
    - Works even if already on that mode
    - Can be called as `./switch-mode.sh --reinject fast-glm`
  - **Dependencies:** Tasks 1.6, 3.1-3.6
  - **Complexity:** Small (30 min)
  - **Testing:** Update preset file, run --reinject, verify new content is applied

- [ ] 4.6 Implement cc-change command installation
  - **Action:** Create symlink or shell function for global cc-change command
  - **Files to Create/Modify:**
    - `~/.local/bin/cc-change` (symlink to ~/.claude/switcher/switch-mode.sh)
    - `~/.bashrc` or `~/.zshrc` (optional: add function alias)
  - **Implementation Details:**
    - Create symlink: `ln -s ~/.claude/switcher/switch-mode.sh ~/.local/bin/cc-change`
    - Ensure ~/.local/bin is in user's PATH
    - Alternative: add shell function to ~/.bashrc:
      ```bash
      cc-change() {
        ~/.claude/switcher/switch-mode.sh "$@"
      }
      ```
    - Test that `cc-change` works from anywhere in filesystem
    - Document in README how to install
  - **Acceptance Criteria:**
    - `cc-change` command works from any directory
    - `cc-change --help` shows usage
    - `cc-change` (no args) shows menu
    - Symlink is correctly set up
    - Command is discoverable in user's PATH
  - **Dependencies:** Tasks 1.1, 1.6, 4.1-4.5
  - **Complexity:** Small (15-30 min)
  - **Testing:** Test `which cc-change`, `cc-change --help`, run menu from different directories

- [ ] 4.7 Create comprehensive help/usage documentation
  - **Action:** Add show_help() function with detailed usage documentation
  - **Files to Modify:**
    - `~/.claude/switcher/switch-mode.sh`
  - **Implementation Details:**
    - Function signature: `show_help()` - no arguments
    - Display comprehensive help including:
      - Description of tool purpose
      - Usage: `cc-change [COMMAND]`
      - Available commands:
        - (no args) - interactive menu
        - `--help` - show this help
        - `--list` - list available modes
        - `--status` - show current mode
        - `--dry-run <mode>` - preview changes
        - `--reinject <mode>` - re-apply mode after preset update
      - Examples of common tasks
      - Restart advice
    - Format clearly with indentation and sections
    - Exit with code 0
  - **Acceptance Criteria:**
    - Help shows all available commands
    - Help is clear and actionable
    - Help fits on single screen (or can be scrolled)
    - Can be called as `./switch-mode.sh --help` or `cc-change -h`
  - **Dependencies:** Task 1.6
  - **Complexity:** Small (30 min)
  - **Testing:** Run `cc-change --help`; verify all commands are documented

---

### 5.0 Error Handling & Recovery

- [x] 5.1 Handle corrupted settings.json.last
  - **Action:** Add error detection and handling for missing/corrupted settings.json.last
  - **Files to Modify:**
    - `~/.claude/switcher/switch-mode.sh` (in read_last_injection and execute_switch)
  - **Implementation Details:**
    - If settings.json.last exists but contains invalid JSON:
      1. Log error with details
      2. Attempt backup of settings.json anyway (as safe as possible)
      3. Inform user: "Warning: settings.json.last is corrupted. Proceeding with caution..."
      4. Treat as "no previous injection" and skip removal step
      5. Continue with preset injection and validation
      6. If validation succeeds, proceed (it's ok - we're injecting fresh config)
      7. If validation fails, restore and abort
    - If settings.json.last is missing: treat as no previous injection, proceed normally
  - **Acceptance Criteria:**
    - Missing settings.json.last doesn't block mode switching
    - Corrupted settings.json.last is detected and logged
    - User is warned if proceeding with corrupted file
    - Switch proceeds safely even with corrupted tracking file
    - Validation catches any problems in final result
  - **Dependencies:** Tasks 1.2, 1.4-1.5
  - **Complexity:** Small-Medium (45 min - 1 hour)
  - **Testing:** Create corrupted settings.json.last; test mode switch behavior

- [x] 5.2 Handle missing or malformed preset files
  - **Action:** Add validation and error handling for preset files
  - **Files to Modify:**
    - `~/.claude/switcher/switch-mode.sh` (in inject_preset and execute_switch)
  - **Implementation Details:**
    - Before reading preset file:
      1. Check that file exists
      2. Check that file is readable
      3. Validate JSON syntax
      4. Validate structure (root is object, contains expected keys)
    - If preset file is missing:
      1. Log error
      2. Restore backup if one was created
      3. Display error: "Preset file not found: ~/.claude/switcher/presets/glm/{mode}.json"
      4. Exit with code 1
    - If preset file is malformed:
      1. Log error with jq parsing error details
      2. Restore backup
      3. Display error: "Preset file is invalid JSON: {details}"
      4. Exit with code 1
  - **Acceptance Criteria:**
    - Missing preset files are detected before use
    - Malformed preset files are caught with clear errors
    - User is informed of problem with action (install missing preset)
    - Backup is restored if mode switch was attempted
  - **Dependencies:** Tasks 1.2, 1.4, 3.2
  - **Complexity:** Small-Medium (45 min - 1 hour)
  - **Testing:** Delete/corrupt preset files; verify error handling

- [ ] 5.3 Handle corrupted settings.json at switch time
  - **Action:** Add detection for corrupted settings.json before starting switch
  - **Files to Modify:**
    - `~/.claude/switcher/switch-mode.sh` (in execute_switch)
  - **Implementation Details:**
    - Before executing switch:
      1. Check if settings.json exists
      2. If exists, validate JSON syntax
      3. If invalid:
         - Log error with corruption details
         - Create backup of corrupted file
         - Display error: "Your settings.json is corrupted. Backup created at: [path]"
         - Ask user: "Continue with repair (remove corrupted file)? [y/n]"
         - If yes: delete settings.json, proceed with empty {}
         - If no: abort
    - This allows recovery from corruption
  - **Acceptance Criteria:**
    - Corrupted settings.json is detected
    - User is informed and given options
    - Backup of corrupted file is created
    - User can choose to repair or abort
  - **Dependencies:** Tasks 1.2, 1.4
  - **Complexity:** Small-Medium (1 hour)
  - **Testing:** Create corrupted settings.json; test detection and recovery

- [ ] 5.4 Implement automatic backup restoration on errors
  - **Action:** Ensure all errors trigger backup restoration
  - **Files to Modify:**
    - `~/.claude/switcher/switch-mode.sh` (in execute_switch, handle_error)
  - **Implementation Details:**
    - Create backup at start of execute_switch
    - Any error (file I/O, JSON parsing, validation) triggers:
      1. Log error details
      2. Call restore_from_backup(backup_filename)
      3. Verify restored settings.json is valid
      4. If restore succeeds: display "Rolled back to previous configuration"
      5. If restore fails: display critical error and instructions
    - Use proper error handling (trap or set -e with explicit checks)
  - **Acceptance Criteria:**
    - Any error during switch triggers restore
    - settings.json is restored to pre-switch state
    - Restoration is verified before completing
    - User is informed of rollback
  - **Dependencies:** Tasks 1.3, 3.3
  - **Complexity:** Medium (1-1.5 hours)
  - **Testing:** Simulate various errors; verify rollback on each

- [ ] 5.5 Implement user-friendly error notifications
  - **Action:** Create clear, actionable error messages
  - **Files to Modify:**
    - `~/.claude/switcher/switch-mode.sh` (all functions)
  - **Implementation Details:**
    - Error messages should follow format:
      - What went wrong (brief)
      - Why it matters
      - What to do about it
    - Examples:
      - "ERROR: Preset file 'fast-glm.json' not found.\n    Install presets to ~/.claude/switcher/presets/glm/\n    See README.md for setup instructions."
      - "ERROR: Your settings.json contains invalid JSON.\n    Rolled back to previous working configuration.\n    Check the log file: ~/.claude/switcher/logs/switch-[timestamp].log"
    - All errors should display to stderr, not stdout
    - Include reference to log file for debugging
  - **Acceptance Criteria:**
    - Error messages are clear and actionable
    - Messages include file paths and next steps
    - Messages reference log files for debugging
    - All errors output to stderr
  - **Dependencies:** Task 1.2
  - **Complexity:** Small-Medium (45 min)
  - **Testing:** Trigger various errors; verify messages are helpful

- [ ] 5.6 Implement comprehensive error logging
  - **Action:** Ensure all operations are logged to ~/.claude/switcher/logs/
  - **Files to Modify:**
    - `~/.claude/switcher/switch-mode.sh` (all functions should call log_message)
  - **Implementation Details:**
    - Every significant action should be logged:
      - Mode switch attempt (which mode, when)
      - Backup created (filename)
      - Injection removed (keys removed)
      - Preset injected (mode, keys added)
      - Validation (passed/failed, details)
      - Restoration (when, from which backup)
      - Completion (success/failure)
    - Log format: `[TIMESTAMP] [LEVEL] MESSAGE`
    - Example: `[2025-11-09 14:23:45] INFO Mode switch to fast-glm initiated`
    - Error logs should include stack trace or jq error details
    - Logs should be readable with grep: `grep ERROR ~/.claude/switcher/logs/*`
    - Create log file on first write; ensure permissions are 644
  - **Acceptance Criteria:**
    - All operations are logged with timestamps
    - Logs are stored in ~/.claude/switcher/logs/
    - Log files are timestamped and readable
    - Errors can be found with grep
    - Log format is consistent
  - **Dependencies:** Task 1.2
  - **Complexity:** Small-Medium (1 hour)
  - **Testing:** Run mode switches; verify log file contains all operations

- [ ] 5.7 Implement corrupted file detection and cleanup
  - **Action:** Add ability to detect and remove corrupted files safely
  - **Files to Modify:**
    - `~/.claude/switcher/switch-mode.sh` (in handle_error and execute_switch)
  - **Implementation Details:**
    - When corrupted settings.json is detected:
      1. Create backup with "CORRUPTED" prefix
      2. Log that file is corrupted
      3. Offer user choice to delete it
      4. If user confirms: delete settings.json (backup is safe)
      5. If user declines: abort and direct to manual recovery
    - If corrupted backup file is detected during restore:
      1. Skip that backup and try older backups
      2. Log which backups were skipped
      3. If no valid backup found: inform user
    - Never silently delete files; always inform user
  - **Acceptance Criteria:**
    - Corrupted files are detected
    - User is informed before deletion
    - Backups are created with "CORRUPTED" prefix
    - Cleanup is logged
    - User has option to decline cleanup
  - **Dependencies:** Tasks 1.2, 1.3, 5.3
  - **Complexity:** Medium (1-1.5 hours)
  - **Testing:** Create corrupted files; test detection and cleanup workflow

- [ ] 5.8 Test all error scenarios with simulated failures
  - **Action:** Create comprehensive error scenario tests
  - **Files to Create:**
    - Add error scenario tests to `~/.claude/switcher/integration-tests.sh`
  - **Implementation Details:**
    - Test each error scenario:
      1. Missing settings.json.last (should work fine)
      2. Corrupted settings.json.last (should warn and proceed)
      3. Missing preset file (should error and rollback)
      4. Malformed preset file (should error and rollback)
      5. Corrupted settings.json before switch (should detect and offer repair)
      6. Validation failure (should rollback to backup)
      7. Backup file missing (should error gracefully)
      8. Backup restore fails (should inform user)
    - For each scenario, verify:
      - Correct error message displayed
      - Backup is created (if applicable)
      - Rollback occurs (if applicable)
      - settings.json is not corrupted
      - User can recover
    - Use temp directory to avoid affecting real settings
  - **Acceptance Criteria:**
    - All error scenarios are tested
    - Correct error messages are displayed
    - Recovery is possible for all scenarios
    - No data loss occurs
    - Logs contain useful debugging info
  - **Dependencies:** Tasks 5.1-5.7
  - **Complexity:** Large (2-3 hours)
  - **Testing:** Run full error scenario test suite

---

### 6.0 Migration & Deprecation

- [ ] 6.1 Review switch-model-enhanced.sh for feature parity
  - **Action:** Analyze existing script and identify all functionality to migrate
  - **Files to Read:**
    - `switch-model-enhanced.sh` (wherever it exists in project)
  - **Implementation Details:**
    - Review script and document all features:
      - What commands does it support?
      - What error handling does it have?
      - How does it manage configurations?
      - What edge cases does it handle?
      - How does it validate JSON?
      - What logging does it do?
    - Create mapping of old functionality to new script:
      - Old: ... → New: ...
    - Identify gaps: what new features exist in new script?
    - Identify regressions: what old features are missing in new script?
    - Create checklist of all features to test for parity
  - **Acceptance Criteria:**
    - All switch-model-enhanced.sh functionality is mapped
    - Gaps and new features are identified
    - Test checklist is created
  - **Dependencies:** Task 1.1
  - **Complexity:** Medium (1-1.5 hours)
  - **Testing:** Manual review; create test checklist

- [ ] 6.2 Migrate equivalent functionality to new switch-mode.sh
  - **Action:** Ensure new script provides same or better functionality
  - **Files to Modify:**
    - `~/.claude/switcher/switch-mode.sh` (add any missing features)
  - **Implementation Details:**
    - Based on 6.1 review, identify missing functionality
    - Implement any equivalent features that should be in new script
    - Ensure all commands from old script work in new script
    - Verify all flags are equivalent or improved
    - Test that any edge cases from old script are handled
  - **Acceptance Criteria:**
    - All features from switch-model-enhanced.sh are supported
    - No functionality loss from migration
    - New features are added (--dry-run, better error handling, etc.)
  - **Dependencies:** Tasks 6.1, 1.1-5.7
  - **Complexity:** Medium (1-2 hours)
  - **Testing:** Test all old functionality works in new script

- [ ] 6.3 Mark switch-model-enhanced.sh as deprecated
  - **Action:** Update old script with deprecation notice
  - **Files to Modify:**
    - `switch-model-enhanced.sh` (add deprecation header)
  - **Implementation Details:**
    - Add prominent deprecation notice at top of script:
      ```bash
      # DEPRECATED: This script is no longer maintained.
      # Please use: cc-change
      # Migration guide: ~/.claude/switcher/MIGRATION.md
      ```
    - Keep script functional for backward compatibility
    - If old script is called, display warning to user:
      - "WARNING: switch-model-enhanced.sh is deprecated"
      - "Please use 'cc-change' instead"
      - Point to migration documentation
  - **Acceptance Criteria:**
    - Deprecation notice is visible in code
    - User warning is displayed when script is called
    - Migration documentation is referenced
    - Old script still works (backward compatible)
  - **Dependencies:** Tasks 6.1-6.2
  - **Complexity:** Small (15-30 min)
  - **Testing:** Run old script; verify deprecation warning

- [ ] 6.4 Update aliases to point to new cc-change command
  - **Action:** Ensure shell aliases/functions use new command
  - **Files to Modify:**
    - `aliases.sh` (if it exists and has mode-switching commands)
    - `~/.bashrc` or `~/.zshrc` (if aliases are defined there)
  - **Implementation Details:**
    - Search for any aliases or functions that call switch-model-enhanced.sh
    - Update them to call cc-change or switch-mode.sh instead
    - Examples:
      - Old: `alias cc-switch='~/path/to/switch-model-enhanced.sh'`
      - New: `alias cc-switch='cc-change'` (or just use cc-change)
    - Test all aliases work correctly
  - **Acceptance Criteria:**
    - All aliases point to new cc-change command
    - Aliases work without errors
    - Both old and new command names work (if applicable)
  - **Dependencies:** Task 4.6
  - **Complexity:** Small (30 min)
  - **Testing:** Test all aliases; verify they call cc-change

- [ ] 6.5 Ensure backward compatibility where practical
  - **Action:** Support old command formats if they're not too disruptive
  - **Files to Modify:**
    - `~/.claude/switcher/switch-mode.sh` (in argument parsing)
  - **Implementation Details:**
    - If switch-model-enhanced.sh had common command formats, support them:
      - Example: if old script used `--mode=fast-glm`, support that
      - Example: if old script used positional args, map to new flags
    - Add compatibility layer in argument parsing
    - Log when old-style command is used (inform user of new style)
    - Display deprecation warning if old format is used
  - **Acceptance Criteria:**
    - Old command formats still work (if reasonable)
    - Users are informed of new command style
    - New style is preferred and documented
  - **Dependencies:** Task 1.6, 6.2
  - **Complexity:** Small-Medium (45 min - 1 hour)
  - **Testing:** Test old command formats work

- [ ] 6.6 Document migration path for existing users
  - **Action:** Create MIGRATION.md explaining transition
  - **Files to Create:**
    - `~/.claude/switcher/MIGRATION.md`
  - **Implementation Details:**
    - Explain what changed and why
    - Provide side-by-side comparison of old vs. new commands
    - Show how to update aliases/scripts
    - Explain new features (--dry-run, better error handling)
    - Provide troubleshooting section
    - Link to README and TROUBLESHOOTING.md
    - Example: Old `./switch-model-enhanced.sh --fast-glm` → New `cc-change --list` and choose, or `cc-change --reinject fast-glm`
  - **Acceptance Criteria:**
    - Migration guide is clear and comprehensive
    - Users understand what changed
    - Users know how to update their workflows
    - FAQ section addresses common concerns
  - **Dependencies:** Tasks 6.1-6.5
  - **Complexity:** Small (30-45 min)
  - **Testing:** Test that new users can follow migration guide

- [ ] 6.7 Test all switch-model-enhanced.sh functionality in new tool
  - **Action:** Create test suite verifying all old functionality works
  - **Files to Create:**
    - Test cases in `~/.claude/switcher/integration-tests.sh`
  - **Implementation Details:**
    - For each feature in old script:
      - Test it works in new script
      - Verify same result or better
      - Verify error handling is equivalent or better
    - Test common workflows:
      - Simple mode switching
      - Error recovery
      - Status checking
      - Help/documentation
    - Use same test fixtures as new script
  - **Acceptance Criteria:**
    - All old functionality works in new script
    - Results are same or better
    - Error handling is robust
    - No regressions found
  - **Dependencies:** Tasks 3.7, 5.8, 6.1-6.6
  - **Complexity:** Large (2-3 hours)
  - **Testing:** Run comprehensive regression test suite

---

### 7.0 Comprehensive Testing Suite

- [ ] 7.1 Create unit tests for utility functions
  - **Action:** Write tests for JSON ops, validation, backup functions
  - **Files to Create:**
    - `~/.claude/switcher/switch-mode.sh.test` (using BATS framework)
  - **Implementation Details:**
    - Use BATS (Bash Automated Testing System) for framework
    - Test each utility function:
      - `backup_settings()` - create backup, verify format
      - `restore_from_backup()` - restore from backup, verify integrity
      - `validate_json_syntax()` - valid/invalid JSON
      - `validate_json_structure()` - correct/incorrect structure
      - `read_last_injection()` - read tracking file
      - `save_last_injection()` - write tracking file
      - `remove_injection()` - remove specific keys
      - `inject_preset()` - merge presets
    - Each test should:
      - Use temp directory for file operations
      - Create fixtures (sample JSON files)
      - Verify expected output/behavior
      - Clean up after completion
    - Aim for 100% function coverage
  - **Acceptance Criteria:**
    - All utility functions have tests
    - Tests cover normal cases and edge cases
    - Tests pass consistently
    - Coverage is 100% of utility functions
  - **Dependencies:** Tasks 1.1-1.6, 3.1-3.4
  - **Complexity:** Large (3-4 hours)
  - **Testing:** Run `bats switch-mode.sh.test`; verify all tests pass

- [ ] 7.2 Create integration tests for mode switching workflows
  - **Action:** Write end-to-end tests for full mode switch workflows
  - **Files to Create:**
    - `~/.claude/switcher/integration-tests.sh` (or tests section in switch-mode.sh.test)
  - **Implementation Details:**
    - Test complete workflows:
      - Switch from cc-native → fast-glm (first switch)
      - Switch from fast-glm → fast-claude (change mode)
      - Switch to cc-native (remove injection)
      - Round-trip: fast-glm → fast-claude → cc-glm → cc-native → fast-glm
    - For each workflow:
      - Start with known settings.json state
      - Execute switch
      - Verify final state:
        - settings.json has correct content
        - settings.json.last has correct content
        - Persistent settings are preserved
        - Backup was created
        - Log entry was written
    - Use realistic test fixtures
    - Verify each workflow completes in under 3 seconds
  - **Acceptance Criteria:**
    - All mode transitions work correctly
    - Persistent settings are preserved
    - All workflows complete within 3 seconds
    - Backups are created
    - Logs are comprehensive
  - **Dependencies:** Tasks 3.7, 1.1-3.6
  - **Complexity:** Large (3-4 hours)
  - **Testing:** Run integration test suite; verify all workflows pass

- [ ] 7.3 Create error scenario tests
  - **Action:** Write tests for error handling and recovery
  - **Files to Create:**
    - `~/.claude/switcher/integration-tests.sh` (error test section)
  - **Implementation Details:**
    - Test each error scenario (from Task 5.8):
      - Missing settings.json.last (should work)
      - Corrupted settings.json.last (should warn and work)
      - Missing preset file (should error and rollback)
      - Malformed preset file (should error and rollback)
      - Corrupted settings.json (should detect and offer repair)
      - Validation failure (should rollback)
      - Backup file corrupted (should skip and try others)
      - Restore failure (should error gracefully)
    - For each scenario:
      - Create fixture to trigger error
      - Execute mode switch
      - Verify error is detected
      - Verify correct error message
      - Verify settings.json is safe (not corrupted)
      - Verify recovery is possible
    - Use mocking to simulate failures (file system errors, etc.)
  - **Acceptance Criteria:**
    - All error scenarios are tested
    - Correct errors are detected
    - Correct error messages are shown
    - Recovery is possible for all scenarios
    - No data loss occurs
  - **Dependencies:** Tasks 5.1-5.7
  - **Complexity:** Large (3-4 hours)
  - **Testing:** Run error scenario test suite; verify robustness

- [ ] 7.4 Create end-to-end tests for all mode transitions
  - **Action:** Write comprehensive tests for each mode and transition
  - **Files to Create:**
    - Add to `~/.claude/switcher/integration-tests.sh`
  - **Implementation Details:**
    - Test each of 5 modes: fast-glm, fast-claude, cc-mixed, cc-glm, cc-native
    - Test each transition: from every mode to every other mode (25 combinations)
    - For each transition:
      - Verify models are correctly set
      - Verify previous configuration is removed
      - Verify persistent settings survive
      - Verify JSON is valid
      - Verify settings.json.last matches (or empty for cc-native)
    - Test special cases:
      - Switching from mode X to mode X (idempotent)
      - Switching with empty settings.json
      - Switching with large settings.json (test performance)
    - Create realistic fixture data with user settings
  - **Acceptance Criteria:**
    - All 5 modes can be switched to from any other mode
    - All 25 transitions are tested (or representative subset)
    - Mode-specific configurations are correct
    - Persistent settings are preserved
    - Operations complete in under 3 seconds
  - **Dependencies:** Tasks 3.7, 7.1-7.3
  - **Complexity:** Large (4-5 hours)
  - **Testing:** Run comprehensive mode transition tests

- [ ] 7.5 Create performance tests
  - **Action:** Verify mode switching meets performance requirements
  - **Files to Create:**
    - Add performance tests to `~/.claude/switcher/integration-tests.sh`
  - **Implementation Details:**
    - Test requirement: mode switching completes within 3 seconds
    - Test with various settings.json sizes:
      - Small: ~1KB
      - Medium: ~10KB
      - Large: ~100KB (max supported)
    - For each size:
      - Measure time for complete mode switch cycle
      - Measure backup creation time
      - Measure JSON validation time
      - Record results
    - Test on typical hardware (or CI environment)
    - Flag if any operation exceeds 3-second budget
  - **Acceptance Criteria:**
    - All mode switches complete in under 3 seconds
    - Backup creation is fast (< 1 second)
    - Validation is fast (< 1 second)
    - Performance degrades gracefully with larger files
    - No timeouts on 100KB files
  - **Dependencies:** Tasks 3.7, 7.2
  - **Complexity:** Medium (1-2 hours)
  - **Testing:** Run performance tests; record timing metrics

- [ ] 7.6 Create UI/UX tests for command interface
  - **Action:** Test menu display, flags, and output formatting
  - **Files to Create:**
    - Add UI tests to `~/.claude/switcher/integration-tests.sh`
  - **Implementation Details:**
    - Test interactive menu:
      - Menu displays correctly (all options visible)
      - Menu accepts input 1-5
      - Invalid input is rejected
      - User can retry
    - Test flags:
      - `--help` shows comprehensive help
      - `--list` shows all modes clearly
      - `--status` shows current mode
      - `--dry-run` shows realistic diff
      - `--reinject` works without menu
    - Test output formatting:
      - Output is readable in standard terminal
      - Lines fit within 80 columns (or 120 max)
      - Error messages are clear and actionable
      - Success messages confirm what happened
    - Test edge cases:
      - Very long file paths (truncate gracefully)
      - Non-ASCII characters (handle safely)
      - Fast terminal environments (don't exceed term width)
  - **Acceptance Criteria:**
    - Menu displays correctly and is user-friendly
    - All flags work as documented
    - Output is readable and well-formatted
    - Error messages are helpful
    - Help text is comprehensive
  - **Dependencies:** Tasks 4.1-4.7
  - **Complexity:** Medium (1-2 hours)
  - **Testing:** Run UI tests; manual terminal testing for visual verification

- [ ] 7.7 Create regression tests for migration
  - **Action:** Verify all old functionality still works
  - **Files to Create:**
    - Add migration tests to `~/.claude/switcher/integration-tests.sh`
  - **Implementation Details:**
    - Test all features from switch-model-enhanced.sh:
      - Any command-line flags from old script
      - Any mode names that might have changed
      - Any error handling from old script
      - Any special cases from old script
    - Compare behavior:
      - Old script vs. new script
      - Verify same results or improvements
      - Verify error messages are equivalent or better
    - Test backward compatibility:
      - Old command formats should work
      - Users' existing scripts should work
      - Aliases should point to new script
  - **Acceptance Criteria:**
    - All old functionality works in new script
    - No regressions found
    - Backward compatibility is maintained
    - Error handling is equivalent or better
  - **Dependencies:** Tasks 6.1-6.7, 7.2-7.6
  - **Complexity:** Large (2-3 hours)
  - **Testing:** Run comprehensive regression test suite

- [ ] 7.8 Verify persistent settings preservation across all modes
  - **Action:** Comprehensive test of settings preservation
  - **Files to Create:**
    - Add preservation tests to `~/.claude/switcher/integration-tests.sh`
  - **Implementation Details:**
    - Create fixture with persistent user settings:
      ```json
      {
        "editor": "vim",
        "theme": "dark",
        "paths": {
          "workspace": "/home/user/projects"
        }
      }
      ```
    - Switch through all 5 modes, verifying:
      - "editor", "theme", "paths" survive every switch
      - Mode-specific settings (models, mcpServers) are replaced
      - No unintended keys are removed
    - Test round-trip: save all settings before and after, compare
    - Test with multiple persistent settings (5+)
    - Test with nested persistent settings
  - **Acceptance Criteria:**
    - All persistent user settings survive mode switches
    - Zero data loss of non-injected settings
    - Mode switches only affect preset-related keys
    - Nested structures are preserved correctly
  - **Dependencies:** Tasks 3.5, 7.2-7.4
  - **Complexity:** Large (2-3 hours)
  - **Testing:** Run comprehensive preservation test; verify 100% success

- [ ] 7.9 Verify zero configuration loss or corruption in any scenario
  - **Action:** Comprehensive test for data integrity
  - **Files to Create:**
    - Add integrity tests to `~/.claude/switcher/integration-tests.sh`
  - **Implementation Details:**
    - Test data integrity:
      - No settings.json files are left corrupted
      - No partial JSON is written (atomic writes)
      - Backups are always available
      - Rollback always restores valid state
    - Test edge cases:
      - Power failure simulation (kill script mid-operation)
      - Disk full simulation (write failure)
      - Permission errors during file operations
      - Concurrent access (if applicable)
    - Verify recovery:
      - Can always restore from backup
      - Corrupted files don't corrupt other files
      - User has clear recovery instructions
  - **Acceptance Criteria:**
    - Zero corrupted settings.json in any scenario
    - 100% recovery possible for all failures
    - Backups are reliable and accessible
    - Rollback works for all error conditions
    - User always has a working configuration
  - **Dependencies:** Tasks 5.1-5.8, 7.3-7.8
  - **Complexity:** Large (3-4 hours)
  - **Testing:** Run comprehensive integrity test suite

---

### 8.0 Documentation & Installation

- [ ] 8.1 Update README.md with new mode switcher functionality
  - **Action:** Add comprehensive documentation to project README
  - **Files to Modify:**
    - `README.md` (project root)
  - **Implementation Details:**
    - Add new section: "Claude Mode Switcher"
    - Include:
      - What it is and what it does (brief)
      - Five supported modes with model mappings
      - Quick start: `cc-change` to open menu
      - All command flags: `--list`, `--status`, `--dry-run`, `--reinject`
      - Example workflows
      - Link to INSTALLATION.md for setup
    - Update table of contents if applicable
    - Link to TROUBLESHOOTING.md for error recovery
    - Mention MIGRATION.md for switch-model-enhanced.sh users
  - **Acceptance Criteria:**
    - README documents all features
    - Quick start is simple and clear
    - All modes are explained
    - Command examples are provided
    - Links to detailed docs are present
  - **Dependencies:** Tasks 1.1-8.0
  - **Complexity:** Small-Medium (45 min - 1 hour)
  - **Testing:** Manual review: can new user understand from README?

- [ ] 8.2 Create installation instructions
  - **Action:** Create INSTALLATION.md with setup guide
  - **Files to Create:**
    - `~/.claude/switcher/INSTALLATION.md`
  - **Implementation Details:**
    - Step-by-step installation:
      1. Prerequisites (Bash 4+, jq 1.6+)
      2. Clone/copy repository (or manual file placement)
      3. Run installation script (if applicable)
      4. Verify installation (test cc-change command)
      5. (Optional) Add to shell rc file
    - Include system-specific instructions (Linux, macOS, Windows/WSL)
    - Include troubleshooting for common issues
    - Explain file structure
    - Link to README for usage
  - **Acceptance Criteria:**
    - New users can install without errors
    - Installation is repeatable
    - Verification step confirms success
    - Troubleshooting covers common issues
  - **Dependencies:** Tasks 1.1, 4.6
  - **Complexity:** Small (30-45 min)
  - **Testing:** Follow installation steps as new user

- [ ] 8.3 Document all command flags and usage examples
  - **Action:** Create comprehensive command reference
  - **Files to Modify:**
    - `~/.claude/switcher/INSTALLATION.md` or separate `COMMANDS.md`
  - **Implementation Details:**
    - Document each command:
      - `cc-change` (interactive menu)
      - `cc-change --help` (usage)
      - `cc-change --list` (show modes)
      - `cc-change --status` (show current mode)
      - `cc-change --dry-run <mode>` (preview changes)
      - `cc-change --reinject <mode>` (re-apply mode)
    - For each command:
      - Description
      - Usage syntax
      - Example invocation
      - Expected output
      - When to use it
    - Include common workflows:
      - First time setup
      - Switch modes
      - Update API keys
      - Check current mode
      - Recover from error
  - **Acceptance Criteria:**
    - All commands are documented
    - Examples are realistic and runnable
    - Common workflows are clear
    - Users know when to use each command
  - **Dependencies:** Tasks 4.1-4.7
  - **Complexity:** Small (30-45 min)
  - **Testing:** Follow examples; verify they work as documented

- [ ] 8.4 Document preset configuration format and customization
  - **Action:** Explain preset file structure and how to customize
  - **Files to Create:**
    - `~/.claude/switcher/PRESETS.md`
  - **Implementation Details:**
    - Explain preset file structure:
      - JSON format
      - Top-level keys (models, mcpServers, etc.)
      - Model naming conventions (haiku, sonnet, opus)
    - Show example preset:
      ```json
      {
        "models": {
          "haiku": "glm-4-flash",
          "sonnet": "glm-4-plus",
          "opus": "glm-4-plus"
        },
        "mcpServers": { ... }
      }
      ```
    - Document how to:
      - Create custom preset
      - Update API keys in presets
      - Add model-specific settings
      - Test preset before using
    - Link to master glm.json as reference
    - Warn about validation and testing
  - **Acceptance Criteria:**
    - Preset format is clearly explained
    - Examples show structure
    - Customization instructions are clear
    - Validation/testing steps are included
  - **Dependencies:** Tasks 2.1-2.5
  - **Complexity:** Small (30-45 min)
  - **Testing:** Create custom preset; verify it works with --dry-run

- [ ] 8.5 Document file structure and directory layout
  - **Action:** Explain directory organization and file purposes
  - **Files to Create:**
    - `~/.claude/switcher/FILE_STRUCTURE.md` or section in INSTALLATION.md
  - **Implementation Details:**
    - Show directory tree:
      ```
      ~/.claude/
      ├── settings.json
      ├── settings.json.last
      ├── settings.json.backup.YYYYMMDD-HHMMSS
      └── switcher/
          ├── switch-mode.sh
          ├── switch-mode.sh.test
          ├── integration-tests.sh
          ├── presets/
          │   └── glm/
          │       ├── glm.json
          │       ├── fast-glm.json
          │       ├── fast-claude.json
          │       ├── cc-mixed.json
          │       └── cc-glm.json
          └── logs/
              └── switch-YYYYMMDD-HHMMSS.log
      ```
    - Explain purpose of each:
      - settings.json: active configuration
      - settings.json.last: tracking previous injection
      - presets/: configuration templates
      - logs/: operation history
      - switch-mode.sh: main script
    - Explain file permissions and why they matter
    - Explain why certain files are auto-created
  - **Acceptance Criteria:**
    - File structure is clearly documented
    - Purpose of each file is explained
    - Users understand how files work together
    - Directory structure is explained
  - **Dependencies:** Task 1.1, 2.1-2.5
  - **Complexity:** Small (30 min)
  - **Testing:** Manual review: does it match actual structure?

- [ ] 8.6 Document backup/recovery procedures
  - **Action:** Create guide for using backups and recovering from errors
  - **Files to Create:**
    - `~/.claude/switcher/RECOVERY.md` or section in TROUBLESHOOTING.md
  - **Implementation Details:**
    - Explain backup system:
      - Automatic timestamped backups created before switches
      - Stored in ~/.claude/ directory
      - Managed by script (automatic cleanup not implemented)
    - Explain recovery procedures:
      - Manual restore: `cp ~/.claude/settings.json.backup.YYYYMMDD-HHMMSS ~/.claude/settings.json`
      - Check available backups: `ls -lh ~/.claude/settings.json.backup.*`
      - Verify restored file: open in editor and review
      - Restart Claude Code
    - Explain automatic recovery:
      - Script automatically restores on validation failure
      - No manual action needed for most errors
    - Document edge cases:
      - Backup file is corrupted: skip to older backup
      - No backups available: manual recovery from known state
      - Multiple corrupted backups: restore manually or start fresh
  - **Acceptance Criteria:**
    - Users understand backup system
    - Recovery procedures are clear and complete
    - Edge cases are documented
    - Users can recover from most errors
  - **Dependencies:** Tasks 1.3, 5.1-5.8
  - **Complexity:** Small (30-45 min)
  - **Testing:** Test manual recovery procedures

- [ ] 8.7 Document error messages and troubleshooting
  - **Action:** Create TROUBLESHOOTING.md with common errors and solutions
  - **Files to Create:**
    - `~/.claude/switcher/TROUBLESHOOTING.md`
  - **Implementation Details:**
    - Document common errors:
      - "Preset file not found"
      - "settings.json is invalid JSON"
      - "Validation failed, rolled back"
      - "Permission denied"
      - "jq not found in PATH"
    - For each error:
      - What it means
      - Why it happened
      - How to fix it
      - Where to find more info (log file)
    - Include diagnostic steps:
      - Check log files
      - Verify file permissions
      - Check jq installation
      - Validate JSON manually
    - FAQ section:
      - How do I recover from a failed switch?
      - How do I see what mode I'm in?
      - How do I undo a mode change?
      - Can I run multiple switches?
    - Link to RECOVERY.md for detailed recovery
    - Link to logs location and how to read them
  - **Acceptance Criteria:**
    - Common errors are documented
    - Solutions are clear and actionable
    - FAQ covers common questions
    - Users can self-diagnose issues
    - Escalation path is clear (GitHub issue, etc.)
  - **Dependencies:** Tasks 5.1-5.8
  - **Complexity:** Small-Medium (45 min - 1 hour)
  - **Testing:** Test diagnostic steps; verify they help identify issues

- [ ] 8.8 Add quick reference guide for common tasks
  - **Action:** Create cheat sheet for frequent operations
  - **Files to Create:**
    - `~/.claude/switcher/QUICK_REFERENCE.md` or section in README.md
  - **Implementation Details:**
    - Create quick reference with common tasks:
      - "Switch to a mode": `cc-change` (interactive) or `cc-change --reinject fast-glm`
      - "See available modes": `cc-change --list`
      - "Check current mode": `cc-change --status`
      - "Preview changes": `cc-change --dry-run fast-claude`
      - "Get help": `cc-change --help`
      - "Find logs": `ls -l ~/.claude/switcher/logs/`
      - "Restore from backup": `cp ~/.claude/settings.json.backup.* ~/.claude/settings.json`
    - Format as table or list
    - Include command + brief description + when to use
    - Keep to single page (fit on screen)
    - Link to detailed docs for more info
  - **Acceptance Criteria:**
    - Quick reference covers most common tasks
    - Commands are correct and tested
    - Format is easy to scan
    - Users can copy/paste commands
  - **Dependencies:** Tasks 4.1-4.7, 8.2-8.7
  - **Complexity:** Small (30 min)
  - **Testing:** Test all commands in quick reference

- [ ] 8.9 Update shell configuration for cc-change command
  - **Action:** Ensure cc-change is available in user's shell
  - **Files to Modify:**
    - `~/.bashrc`, `~/.zshrc`, or `aliases.sh` (if exists)
  - **Implementation Details:**
    - Option 1: Use symlink (preferred)
      - Already done in Task 4.6
      - Ensure ~/.local/bin is in PATH
      - User adds to ~/.bashrc: `export PATH=$HOME/.local/bin:$PATH`
    - Option 2: Shell function
      - Add to ~/.bashrc: `cc-change() { ~/.claude/switcher/switch-mode.sh "$@"; }`
    - Option 3: Alias
      - Add to aliases.sh: `alias cc-change='~/.claude/switcher/switch-mode.sh'`
    - Verify PATH includes directory with command
    - Document in INSTALLATION.md
    - Provide optional convenience: add to shell rc automatically (if user approves)
  - **Acceptance Criteria:**
    - `cc-change` command works from any directory
    - Command is available in new shell sessions
    - User doesn't need to provide full path
    - Instructions are clear for manual setup
  - **Dependencies:** Task 4.6
  - **Complexity:** Small (30 min)
  - **Testing:** Test `which cc-change`, `cc-change --help` after shell reload

---

## Summary

**Total Parent Tasks:** 8
**Total Sub-Tasks:** Approximately 71 detailed sub-tasks
**Estimated Total Duration:** 25-35 hours for junior developer

### Task Breakdown by Complexity:
- **Small (15-30 min):** ~20 tasks
- **Small-Medium (45 min - 1 hour):** ~25 tasks
- **Medium (1-1.5 hours):** ~15 tasks
- **Medium-Large (2-3 hours):** ~8 tasks
- **Large (3-5 hours):** ~3 tasks

### Key Dependencies:
1. **Phase 1 (Foundation & Presets):** Tasks 1.0 + 2.0 must complete first
2. **Phase 2 (Core Logic):** Task 3.0 depends on 1.0 + 2.0
3. **Phase 3 (Interface & Errors):** Tasks 4.0 + 5.0 depend on 3.0
4. **Phase 4 (Testing):** Task 7.0 depends on 1.0-6.0
5. **Phase 5 (Documentation):** Task 8.0 depends on 1.0-7.0

### Quality Assurance Checkpoints:
- After Task 3.0: Verify core switching works correctly
- After Task 5.0: Verify error handling is robust
- After Task 7.0: Verify 100% test coverage and all tests pass
- After Task 8.0: Final review of documentation completeness

---

**Document Version:** 2.0 (Phase 2 Complete)
**Status:** Phase 2 - Ready for Implementation
**Generated:** 2025-11-09
**Last Updated:** 2025-11-09

**Changelog:**
- v2.0 (2025-11-09): Phase 2 sub-tasks generated with detailed implementation guidance
