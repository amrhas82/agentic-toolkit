# Plan: Universal Verification Gate + Subagent Isolation + Toolkit Cleanup

## Overview

1. **Skills/Commands Cleanup** - Remove non-essential, keep core workflow skills
2. **Universal Verification Gate** - No completion claims without evidence
3. **Subagent Isolation** - Fresh context per task execution
4. **Cross-Package Sync** - Apply to all 4 CLI tools

## Design Principle: Standalone First

**Agentic Toolkit works independently.** Superpowers is optional add-on.
- All verification logic lives in toolkit's own agents/skills
- No hard dependencies on superpowers files
- Lightweight, focused on workflow enhancement

## Goals

- Remove non-essential skills (pdf, docx, xlsx, etc.)
- Keep only core workflow skills (9 total)
- Sync commands to all packages (currently only claude has them)
- Every agent completion goes through verification
- Task execution uses fresh subagents (no context pollution)
- TDD enforcement where valuable

---

## Phase 0: Skills, Commands, and Resources Cleanup

### 0.1 Skills to KEEP (10 core)

| Skill | Purpose | Why Core |
|-------|---------|----------|
| brainstorming | Idea refinement | Orchestrator workflow |
| code-review | Quality checks | QA workflow |
| condition-based-waiting | Test reliability | Prevents flaky tests |
| root-cause-tracing | Debugging | Systematic debugging |
| skill-creator | Extend toolkit | Meta/customization |
| subagent-spawning | Task isolation templates | 3-process-task-list needs this |
| systematic-debugging | 4-phase debugging | Core debugging workflow |
| test-driven-development | TDD workflow | Plan requires this |
| testing-anti-patterns | Test quality | Prevents bad tests |
| verification-before-completion | Verification gate | Plan requires this |

### 0.2 Skills to REMOVE (13)

```
algorithmic-art/
artifacts-builder/
brand-guidelines/
canvas-design/
docx/
internal-comms/
mcp-builder/
pdf/
pptx/
slack-gif-creator/
theme-factory/
webapp-testing/
xlsx/
```

### 0.3 Commands to KEEP (all 9)

| Command | Purpose |
|---------|---------|
| debug.md | Debugging shortcut |
| explain.md | Code explanation |
| git-commit.md | Commit workflow |
| optimize.md | Performance tuning |
| refactor.md | Refactoring |
| review.md | Code review shortcut |
| security.md | Security audit |
| ship.md | Deployment checklist |
| test-generate.md | Test generation |

### 0.4 Resources Folder - DELETE ENTIRELY

**Remove all resources:**
```
resources/
├── agent-teams.yaml      # REMOVE - unused
├── checklists.md         # REMOVE - replace with embedded self-verification
├── data.md               # REMOVE - unused
├── task-briefs.md        # REMOVE - agents can execute without briefs
├── templates.yaml        # REMOVE - unused
└── workflows.yaml        # REMOVE - orchestrator has workflow patterns
```

**Rationale:**
- ~500KB of rarely-used content
- Agents are self-sufficient and can infer checklist items
- Self-verification checklists (Phase 6) replace external checklists
- Task briefs not needed - agents understand tasks from descriptions

### 0.5 New Skill to ADD

Create `skills/subagent-spawning/SKILL.md` - Templates for fresh subagent spawning (replaces implementer-prompt resource)

---

## Phase 0 Implementation

### 0.6 Remove non-core skills from all packages

**Claude:**
```bash
cd ai/subagentic/claude/skills/
rm -rf algorithmic-art artifacts-builder brand-guidelines canvas-design \
       docx internal-comms mcp-builder pdf pptx slack-gif-creator \
       theme-factory webapp-testing xlsx
```

**OpenCode, AmpCode, Droid:** Same removal if skills exist.

### 0.7 Delete resources folder from all packages

```bash
# Claude
rm -rf ai/subagentic/claude/resources/

# OpenCode
rm -rf ai/subagentic/opencode/resources/

# AmpCode
rm -rf ai/subagentic/ampcode/resources/

# Droid
rm -rf ai/subagentic/droid/resources/
```

### 0.8 Clean up resource references from all agent files

Remove references to `resources/`, `checklists.md`, `task-briefs.md` from:

**Agent files (in all 4 packages):**
- `code-developer.md` - remove `Dependencies` section referencing checklists/tasks
- `quality-assurance.md` - remove task-briefs references
- `backlog-manager.md` - remove task-briefs references
- `story-writer.md` - remove task-briefs references
- `market-researcher.md` - remove task-briefs references
- `orchestrator.md` - remove any resource references
- All other agents - audit and remove resource references

**Manifest files:**
- `ai/subagentic/claude/CLAUDE.md` - remove Tasks section, update Skills section
- `ai/subagentic/opencode/AGENTS.md` - remove Tasks section, update Skills section
- `ai/subagentic/ampcode/AGENT.md` - remove Tasks section, update Skills section
- `ai/subagentic/droid/AGENTS.md` - remove Tasks section, update Skills section

### 0.9 Sync commands to all packages

Commands currently exist only in `ai/subagentic/claude/commands/`

```bash
# Copy to OpenCode (command/ folder)
cp ai/subagentic/claude/commands/*.md ai/subagentic/opencode/command/

# Copy to AmpCode (commands/ folder)
cp ai/subagentic/claude/commands/*.md ai/subagentic/ampcode/commands/

# Copy to Droid (commands/ folder)
cp ai/subagentic/claude/commands/*.md ai/subagentic/droid/commands/
```

### 0.10 Create subagent-spawning skill/command

**For Claude** - Create as skill:
```
skills/subagent-spawning/SKILL.md
```

**For OpenCode, AmpCode, Droid** - Create as command (converted from skill):
```
command/subagent-spawning.md      # OpenCode
commands/subagent-spawning.md     # AmpCode, Droid
```

### 0.11 Convert remaining core skills to commands (OpenCode, AmpCode, Droid)

For each of the 10 core skills, convert to command format:

| Claude Skill | OpenCode/AmpCode/Droid Command |
|--------------|--------------------------------|
| `skills/brainstorming/SKILL.md` | `command/brainstorming.md` |
| `skills/code-review/` (folder) | `command/code-review/` (folder) |
| `skills/condition-based-waiting/SKILL.md` | `command/condition-based-waiting.md` |
| `skills/root-cause-tracing/SKILL.md` | `command/root-cause-tracing.md` |
| `skills/skill-creator/SKILL.md` | `command/skill-creator.md` |
| `skills/subagent-spawning/SKILL.md` | `command/subagent-spawning.md` |
| `skills/systematic-debugging/SKILL.md` | `command/systematic-debugging.md` |
| `skills/test-driven-development/SKILL.md` | `command/test-driven-development.md` |
| `skills/testing-anti-patterns/SKILL.md` | `command/testing-anti-patterns.md` |
| `skills/verification-before-completion/SKILL.md` | `command/verification-before-completion.md` |

**Conversion steps:**
1. Copy SKILL.md content
2. Rename to `skill-name.md` (or create folder if has supporting files)
3. Place in `command/` or `commands/` directory

### 0.12 Subagent-spawning skill content

Create `skills/subagent-spawning/SKILL.md` (Claude) or `command/subagent-spawning.md` (others):

```markdown
---
name: subagent-spawning
description: Use when spawning fresh subagents for isolated task execution. Provides TDD-aware templates for 3-process-task-list and other agents.
---

## Auto-Trigger

**APPLIES WHEN:**
- 3-process-task-list spawning implementer for a task
- Any agent delegating work to fresh subagent
- Task isolation needed (prevent context pollution)

**APPLIES TO:**
- Task list processing
- Parallel task execution
- Complex multi-step implementations

## Template A: With TDD (when tdd: yes)

```
You are implementing Task: {task_description}

CONTEXT:
{relevant_file_contents}

ACCEPTANCE CRITERIA:
{task_specific_criteria}

TDD REQUIRED:
Write test FIRST. Watch it FAIL. Then implement. Then watch it PASS.
{tdd_note}

VERIFY WITH: {verify_command}

WORKFLOW:
1. Write test for expected behavior
2. Run test - MUST see it FAIL (red)
3. Implement minimal code to pass
4. Run test - verify it PASSES (green)
5. Refactor if needed
6. Report: test output (fail→pass) + changes + concerns

CONSTRAINTS:
- Do NOT implement before writing test
- Do NOT skip red-green verification
- Do NOT reference other tasks
- Do NOT assume context not provided
```

## Template B: Without TDD (when tdd: no)

```
You are implementing Task: {task_description}

CONTEXT:
{relevant_file_contents}

ACCEPTANCE CRITERIA:
{task_specific_criteria}

VERIFY WITH: {verify_command}

WORKFLOW:
1. Implement the task completely
2. Run verify command BEFORE claiming done
3. Report: changes + verify output + concerns

CONSTRAINTS:
- Do NOT reference other tasks
- Do NOT assume context not provided
- Do NOT claim done without verify output
```

## Why Fresh Subagents?

- Task 1 confusion doesn't pollute task 5
- Each task gets clean reasoning slate
- Prevents "I already tried that" false memories
- Forces explicit context = fewer assumptions
```

---

## Target Directories

All changes apply to `/ai/subagentic/` in the toolkit repo:

| CLI Tool | Agents | Skills/Commands | Manifest |
|----------|--------|-----------------|----------|
| Claude | `claude/agents/` | `claude/skills/` + `claude/commands/` (separate) | `CLAUDE.md` |
| OpenCode | `opencode/agents/` | `opencode/command/` (merged) | `AGENTS.md` |
| AmpCode | `ampcode/agents/` | `ampcode/commands/` (merged) | `AGENT.md` |
| Droid | `droid/droids/` | `droid/commands/` (merged) | `AGENTS.md` |

### Skills/Commands Structure Difference

**Claude** has separate folders:
```
claude/
├── skills/           # Skills as SKILL.md in folders
│   ├── brainstorming/SKILL.md
│   └── code-review/SKILL.md
└── commands/         # Commands as name.md files
    ├── debug.md
    └── review.md
```

**OpenCode, AmpCode, Droid** have merged folder:
```
opencode/command/     # Skills converted to commands
├── brainstorming.md           # Simple skill → single file
├── code-review.md             # Main command (at root level)
├── code-review/               # Supporting files ONLY (if any)
│   └── code-reviewer.md       # Supporting file
├── debug.md                   # Regular command
└── review.md                  # Regular command
```

### Conversion Pattern (Skills → Commands)

| Skill Type | Claude | OpenCode/AmpCode/Droid |
|------------|--------|------------------------|
| Simple (SKILL.md only) | `skills/brainstorming/SKILL.md` | `command/brainstorming.md` |
| With supporting files | `skills/code-review/SKILL.md` + files | `command/code-review.md` + `command/code-review/` (supporting files) |

**Sync Strategy:** Update claude/ first, then convert and sync to other 3 tools.

---

## Phase 1: Universal Verification Gate

### 1.1 Update orchestrator.md digraph

Add verification nodes after `execute_step`:

```dot
  verify_claim [label="Run verification\n(test/build/lint)", fillcolor=orange];
  claim_valid [label="Output confirms\nclaim?", shape=diamond];
  report_actual [label="Report ACTUAL state\n(with evidence)"];

  execute_step -> verify_claim;
  verify_claim -> claim_valid;
  claim_valid -> track_state [label="YES + evidence"];
  claim_valid -> report_actual [label="NO"];
  report_actual -> ask_next;
```

### 1.2 Add Verification Gate rules to orchestrator.md

```markdown
# Verification Gate (Universal)

After ANY agent reports completion:

1. **IDENTIFY** - What command proves the claim?
2. **RUN** - Execute fresh, complete (not cached)
3. **READ** - Full output, exit code, failure count
4. **ACCEPT or REJECT** - Output confirms → proceed; contradicts → report actual state

**Red flags (never accept):**
- "should work", "looks good", "I fixed it"
- No command output shown
- Partial verification
```

### 1.3 Update verification-before-completion skill

Path: `ai/subagentic/claude/skills/verification-before-completion/SKILL.md`

Add auto-trigger section:

```markdown
## Auto-Trigger

**APPLIES WHEN:**
- About to say: done, fixed, complete, passing, success
- About to commit, push, create PR
- About to mark task [x]

**APPLIES TO:** All agents, all invocation paths

**NEVER SKIP:** Even for "obvious" tasks
```

### 1.4 Add verify node to code-developer.md and quality-assurance.md

Add before their "done" node:

```dot
  verify_before_done [label="Run verification", fillcolor=orange];
  [last_action] -> verify_before_done;
  verify_before_done -> done;
```

---

## Phase 2: Subagent Isolation for 3-process-task-list

### 2.1 Update 3-process-task-list.md digraph

Replace direct execute with subagent spawn pattern (see full digraph in original plan).

### 2.2 Add Context Extraction rules

**INCLUDE:** Task description, relevant files, TDD hint, verify command
**EXCLUDE:** Previous outputs, accumulated context, other tasks

### 2.3 Add Verification Command Resolution table

| Task Contains | Verify Command |
|---------------|----------------|
| test, spec | test runner |
| api, endpoint | curl + test |
| build, config | build command |
| lint, format | linter |
| migration | migration + schema check |

---

## Phase 3: Task Generation Updates

### 3.1 Update 2-generate-tasks.md

Add TDD + verify hints to task template:

```markdown
- [ ] 1.1 Create User model
  - tdd: yes
  - verify: `npm test -- --grep "User"`
```

### 3.2 Add TDD detection table

| Task Type | TDD Hint |
|-----------|----------|
| Create model/class/function | yes |
| Add API endpoint | yes |
| Fix bug | yes |
| Update docs/config | no |

---

## Phase 4: Subagent Spawning Skill (Already Created in Phase 0.10)

The subagent-spawning skill was created in Phase 0.10 with both TDD and non-TDD templates.

### 4.1 Update 3-process-task-list.md to use subagent-spawning skill

Add to 3-process-task-list.md digraph and rules:

```markdown
## Dependencies

**Skills:** subagent-spawning (for fresh subagent templates)

## Subagent Dispatch

When spawning implementer subagent:
1. Read task's `tdd:` hint
2. Use subagent-spawning skill template (A or B)
3. Pass minimal context (task + files + verify command)
4. Await result and verify
```

---

## Phase 5: Document-Producing Agents Verification

### 5.1-5.4 Add verification commands to:
- 1-create-prd.md
- 2-generate-tasks.md (verify hints present)
- docs-builder.md
- context-builder.md

---

## Phase 6: Manual Review Agents - Self-Verification Checklists

### 6.1-6.6 Add checklists to:
- system-architect.md
- feature-planner.md
- backlog-manager.md
- story-writer.md
- ui-designer.md
- market-researcher.md

---

## Phase 7: Master Agent - Hybrid Verification

### 7.1 Add task-type verification to master.md

Detection: Code → tests, Document → file check, Analysis → checklist

---

## Phase 8: TDD Skill Enhancement

### 8.1 Update test-driven-development skill

Path: `ai/subagentic/claude/skills/test-driven-development/SKILL.md`

Add auto-trigger section.

---

## Phase 9: Update Manifest Files

### 9.1 Update manifest files in each package

**Claude:**
- `ai/subagentic/claude/CLAUDE.md`

**OpenCode:**
- `ai/subagentic/opencode/AGENTS.md`

**AmpCode:**
- `ai/subagentic/ampcode/AGENTS.md`

**Droid:**
- `ai/subagentic/droid/AGENTS.md`

Update skills list to show only 9 core skills.
Update commands list to show all 9 commands.

### 9.2 Update subagentic-manual.md

Path: `ai/subagentic/subagentic-manual.md`

Update:
- Skills inventory (9 core, removed 13)
- Commands inventory (9, now in all packages)
- Token counts (reduced due to removal)
- Add note about superpowers as optional add-on

---

## Implementation Checklist

- [ ] **Phase 0: Cleanup**
  - [ ] 0.6 Remove 13 non-core skills from claude/skills/
  - [ ] 0.6 Remove 13 non-core commands from opencode/, ampcode/, droid/
  - [ ] 0.7 Delete resources/ folder from all packages
  - [ ] 0.8 Clean resource references from all agent files
  - [ ] 0.8 Clean resource references from CLAUDE.md, AGENTS.md, AGENT.md
  - [ ] 0.9 Sync 9 commands to opencode/, ampcode/, droid/
  - [ ] 0.10 Create subagent-spawning (skill for claude, command for others)
  - [ ] 0.11 Convert 10 core skills to commands for opencode/, ampcode/, droid/

- [ ] **Phase 1: Universal Verification Gate**
  - [ ] 1.1 Update orchestrator.md digraph
  - [ ] 1.2 Add verification gate rules
  - [ ] 1.3 Update verification-before-completion skill
  - [ ] 1.4 Add verify node to code-developer.md
  - [ ] 1.5 Add verify node to quality-assurance.md

- [ ] **Phase 2: Subagent Isolation**
  - [ ] 2.1 Update 3-process-task-list.md digraph
  - [ ] 2.2 Add context extraction rules
  - [ ] 2.3 Add verification command resolution

- [ ] **Phase 3: Task Generation**
  - [ ] 3.1 Update 2-generate-tasks.md template
  - [ ] 3.2 Add TDD detection table

- [ ] **Phase 4: Subagent Spawning**
  - [ ] 4.1 Update 3-process-task-list.md to reference subagent-spawning skill

- [ ] **Phase 5: Document Agents**
  - [ ] 5.1 Update 1-create-prd.md
  - [ ] 5.2 Update 2-generate-tasks.md verification
  - [ ] 5.3 Update docs-builder.md
  - [ ] 5.4 Update context-builder.md

- [ ] **Phase 6: Manual Review Agents**
  - [ ] 6.1-6.6 Add self-verification checklists to 6 agents

- [ ] **Phase 7: Master Agent**
  - [ ] 7.1 Add task-type verification

- [ ] **Phase 8: TDD Skill**
  - [ ] 8.1 Add auto-trigger section

- [ ] **Phase 9: Manifests**
  - [ ] 9.1 Update CLAUDE.md - remove Tasks section, update Skills
  - [ ] 9.2 Update AGENTS.md (opencode, droid) - remove Tasks, update Skills
  - [ ] 9.3 Update AGENT.md (ampcode) - remove Tasks, update Skills
  - [ ] 9.4 Update subagentic-manual.md

- [ ] **Phase 10: Cross-Package Sync**
  - [ ] 10.1 Sync all agent changes to opencode/
  - [ ] 10.2 Sync all agent changes to ampcode/
  - [ ] 10.3 Sync all agent changes to droid/

---

## Files Summary

### Per Package

| Category | Count |
|----------|-------|
| Agents modified | 15 |
| Skills modified | 2 (verification-before-completion, test-driven-development) |
| Skills created | 1 (subagent-spawning) |
| Skills removed | 13 |
| Commands synced | 9 (to 3 packages) |
| Resources deleted | 6 files (~500KB) |
| Manifests updated | 1 |

### Total Across All 4 Packages

| Action | Count |
|--------|-------|
| Agent files modified | 60 (15 × 4) |
| Skills modified | 8 (2 × 4) |
| Skills created | 4 (1 × 4) |
| Skills deleted | 52 (13 × 4) |
| Commands copied | 27 (9 × 3 packages) |
| Resources deleted | 24 (6 × 4 packages) |
| Manifests updated | 4 |
| subagentic-manual.md | 1 |

### Net Effect

| Before | After |
|--------|-------|
| 22 skills | 10 skills |
| 6 resource files (~500KB) | 0 resource files |
| Commands only in claude | Commands in all 4 packages |
| Task briefs referenced | Self-sufficient agents |

---

## Final Structure

### Claude (skills + commands separate)

```
claude/
├── agents/           # 15 agents (all modified with verification)
├── skills/           # 10 core skills (was 22)
│   ├── brainstorming/
│   ├── code-review/
│   ├── condition-based-waiting/
│   ├── root-cause-tracing/
│   ├── skill-creator/
│   ├── subagent-spawning/      # NEW
│   ├── systematic-debugging/
│   ├── test-driven-development/
│   ├── testing-anti-patterns/
│   ├── verification-before-completion/
│   └── README.md
├── commands/         # 9 commands
│   ├── debug.md
│   ├── explain.md
│   ├── git-commit.md
│   ├── optimize.md
│   ├── refactor.md
│   ├── review.md
│   ├── security.md
│   ├── ship.md
│   └── test-generate.md
└── CLAUDE.md         # Updated manifest (no Tasks section)
```

### OpenCode, AmpCode, Droid (skills merged into commands)

```
opencode/
├── agents/           # 15 agents (all modified with verification)
├── command/          # 19 commands (10 skills-as-commands + 9 commands)
│   ├── brainstorming.md
│   ├── code-review.md            # Main command (at root)
│   ├── code-review/              # Supporting files only
│   │   └── code-reviewer.md
│   ├── condition-based-waiting.md
│   ├── debug.md
│   ├── explain.md
│   ├── git-commit.md
│   ├── optimize.md
│   ├── refactor.md
│   ├── review.md
│   ├── root-cause-tracing.md
│   ├── security.md
│   ├── ship.md
│   ├── skill-creator.md
│   ├── subagent-spawning.md      # NEW
│   ├── systematic-debugging.md
│   ├── test-driven-development.md
│   ├── test-generate.md
│   ├── testing-anti-patterns.md
│   └── verification-before-completion.md
└── AGENTS.md         # Updated manifest (no Tasks section)
```

**Note:**
- No `resources/` folder in any package - agents are self-sufficient
- OpenCode uses `command/`, AmpCode and Droid use `commands/`

---

## Success Criteria

1. **Lightweight** - Only 10 core skills (removed 13, added 1)
2. **No resources folder** - Agents are self-sufficient
3. **Complete** - Commands in all 4 packages
4. **Consistent** - Same agents/skills/commands across packages
5. **Verified** - All agents have verification gates
6. **Isolated** - Task execution uses fresh subagents (subagent-spawning skill)
7. **TDD-aware** - Tasks have tdd: yes/no hints
8. **Clean manifests** - No Tasks section, only Agents and Skills
9. **Documented** - subagentic-manual.md reflects all changes
