# Agent Consolidation Plan

## Overview

Consolidate agents, skills, and manifests across all CLI packages for consistency, remove broken references, and convert docs-builder from agent to skill.

## Step 1: Claude Package (`/ai/subagentic/claude/`)

### 1a. Agents - Frontmatter (14 agents)

Shorten all descriptions to 8-12 words (router-focused trigger phrases):

| Agent | Current | Proposed |
|-------|---------|----------|
| 1-create-prd | "Creates Product Requirements Documents (PRDs) through structured discovery..." | "Create PRDs through structured discovery" |
| 2-generate-tasks | "Converts PRDs into actionable development task lists..." | "Convert PRDs into development task lists" |
| 3-process-task-list | "Manages implementation progress using markdown task lists..." | "Execute task lists with sequential commits" |
| backlog-manager | "Use for backlog management, story refinement..." | "Manage backlog, refine stories, plan sprints" |
| code-developer | "Use for code implementation, debugging, refactoring..." | "Implement code, debug, refactor" |
| context-builder | "Creates lightweight CLAUDE.md..." | "Initialize project context and documentation" |
| feature-planner | "Use this agent to create PRDs, develop product strategy..." | "Create PRDs, plan features, prioritize roadmap" |
| market-researcher | "Use for strategic business analysis, market research..." | "Research markets, analyze competitors, brainstorm" |
| master | "Use for comprehensive task execution across all domains..." | "Execute any task without specialized persona" |
| orchestrator | "Workflow coordinator - analyzes intent..." | "Coordinate workflows, route to specialists" |
| quality-assurance | "Use for comprehensive quality assessment..." | "Quality gates, test architecture, code review" |
| story-writer | "Use to create detailed user stories..." | "Create user stories, manage epics, run retros" |
| system-architect | "Use for comprehensive system design..." | "Design systems, select tech, plan architecture" |
| ui-designer | "Use for UI/UX design tasks, wireframes..." | "Design UI/UX, wireframes, accessibility" |

### 1b. Agents - Remove broken/external references (7 agents)

| Agent | Lines | References to Remove |
|-------|-------|---------------------|
| backlog-manager | ~98 | `change-checklist.md` |
| code-developer | ~113 | `apply-qa-fixes.md task` |
| story-writer | 25-26 | `create-next-story.md`, `execute-checklist.md`, `story-draft-checklist.md` |
| system-architect | ~60 | `architect-checklist.md`, `technical-preferences.md` |
| feature-planner | 82-85, 98 | `pm-checklist`, template references |
| master | 82-90 | Resource-dependent commands |
| market-researcher | ~50 | `brainstorming-techniques.md` |

### 1c. Skills - Remove external references (3 skills)

| Skill | References to Remove |
|-------|---------------------|
| brainstorming | `superpowers:using-git-worktrees`, `superpowers:writing-plans` |
| code-review | `superpowers:code-reviewer` refs |
| systematic-debugging | `defense-in-depth` ref (skill doesn't exist) |

### 1d. Convert docs-builder: Agent → Skill

```
# DELETE
agents/docs-builder.md

# CREATE
skills/docs-builder/
├── SKILL.md                    (~100 lines: workflow, rules, structure)
└── references/templates.md     (full templates, lazy loaded)
```

### 1e. Orchestrator - Fix counts

| Line | Current | Fix |
|------|---------|-----|
| ~172 | "14 agents available" | "14 agents available" (correct after docs-builder removal) |
| ~174 | "16 skills available" | "11 skills available" (10 + docs-builder) |

Also update agent registry to remove docs-builder from agents list.

### 1f. Update CLAUDE.md

- Remove docs-builder from Agents section (directory table + detailed entry)
- Add docs-builder to Skills section

---

## Step 2: Update subagentic-manual.md

Location: `/home/hamr/PycharmProjects/agentic-toolkit/docs/subagentic-manual.md`

- Remove entries for 13 deleted skills (from Phase 0)
- Update docs-builder: move from agents to skills section
- Verify counts match

---

## Step 3: Propagate to Other CLI Tools

### ampcode (`/ai/subagentic/ampcode/`)

| Item | Action |
|------|--------|
| `agents/*.md` (14) | Copy body from claude, preserve frontmatter |
| `agents/docs-builder.md` | DELETE |
| `commands/docs-builder.md` | CREATE (main skill) |
| `commands/docs-builder/instructions.md` | CREATE (templates) |
| orchestrator | Manual update (tool-specific paths) |
| CLAUDE.md | Remove docs-builder from agents, add to commands |

### droid (`/ai/subagentic/droid/`)

| Item | Action |
|------|--------|
| `droids/*.md` (14) | Copy body from claude, preserve frontmatter |
| `droids/docs-builder.md` | DELETE |
| `commands/docs-builder.md` | CREATE (main skill) |
| `commands/docs-builder/instructions.md` | CREATE (templates) |
| orchestrator | Manual update (tool-specific paths) |
| CLAUDE.md | Remove docs-builder from agents, add to commands |

### opencode (`/ai/subagentic/opencode/`)

| Item | Action |
|------|--------|
| `agent/*.md` (14) | Copy body from claude, preserve frontmatter |
| `agent/docs-builder.md` | DELETE |
| `command/docs-builder.md` | CREATE (main skill) |
| `command/docs-builder/instructions.md` | CREATE (templates) |
| orchestrator | Manual update (tool-specific paths) |
| CLAUDE.md | Remove docs-builder from agents, add to commands |

---

## Execution Sequence

```
Claude Package:
1.  agents/*.md (14)          → frontmatter + body fixes
2.  skills/*.md (3)           → remove external refs
3.  agents/docs-builder.md    → DELETE
4.  skills/docs-builder/      → CREATE (2 files)
5.  agents/orchestrator.md    → fix counts + registry
6.  CLAUDE.md                 → update docs-builder location

Manual/Docs:
7.  subagentic-manual.md      → remove old skills, update docs-builder

ampcode:
8.  agents/*.md (14)          → copy body, preserve frontmatter
9.  agents/docs-builder.md    → DELETE
10. commands/docs-builder/    → CREATE (2 files)
11. orchestrator              → manual update
12. CLAUDE.md                 → update

droid:
13. droids/*.md (14)          → copy body, preserve frontmatter
14. droids/docs-builder.md    → DELETE
15. commands/docs-builder/    → CREATE (2 files)
16. orchestrator              → manual update
17. CLAUDE.md                 → update

opencode:
18. agent/*.md (14)           → copy body, preserve frontmatter
19. agent/docs-builder.md     → DELETE
20. command/docs-builder/     → CREATE (2 files)
21. orchestrator              → manual update
22. CLAUDE.md                 → update
23. opencode.jsonc            → UPDATE (see Step 4)
    - Fix qa-test-architecht typo
    - Remove docs-builder from agents
    - Remove 13 old commands
    - Add docs-builder to commands
```

---

## File Counts

| Package | Agents Modified | Skills Modified | New Files | Deleted |
|---------|-----------------|-----------------|-----------|---------|
| claude | 14 | 3 | 2 | 1 |
| ampcode | 14 | 0 | 2 | 1 |
| droid | 14 | 0 | 2 | 1 |
| opencode | 14 | 0 | 2 | 1 |
| manual | 1 | - | - | - |

**Total: ~60 file operations (56 modify, 8 create, 4 delete)**

---

## Step 4: Update opencode.jsonc

Location: `/ai/subagentic/opencode/opencode.jsonc`

### Agents Section

| Entry | Action |
|-------|--------|
| `qa-test-architecht` | Fix typo → `quality-assurance` |
| `docs-builder` | REMOVE (moving to commands) |
| All 14 remaining | Update descriptions to match new short format |

### Commands Section - Remove Old Skills (13)

```
REMOVE:
- xlsx
- webapp-testing
- slack-gif-creator
- theme-factory
- internal-comms
- pdf
- mcp-builder
- pptx
- docx
- brand-guidelines
- canvas-design
- artifacts-builder
- algorithmic-art
```

### Commands Section - Keep (10 core)

```
KEEP:
- systematic-debugging
- verification-before-completion
- skill-creator
- test-driven-development
- testing-anti-patterns
- root-cause-tracing
- condition-based-waiting
- brainstorming
- code-review
```

### Commands Section - Add (1)

```
ADD:
- docs-builder (from agents)
```

Note: `subagent-spawning` is internal infrastructure (used by 3-process-task-list), NOT user-invocable. Don't add to commands.

### Final Counts

| Section | Before | After |
|---------|--------|-------|
| Agents | 15 | 14 |
| Commands | 22 | 10 |

---

## Verification

After completion:
- [ ] All agents have 8-12 word descriptions
- [ ] No broken resource references in any agent
- [ ] No external `superpowers:*` references in skills
- [ ] docs-builder exists as skill in all packages
- [ ] docs-builder deleted from agents in all packages
- [ ] Orchestrator counts correct (14 agents, 11 skills)
- [ ] CLAUDE.md updated in all packages
- [ ] subagentic-manual.md updated
- [ ] opencode.jsonc updated (14 agents, 10 commands)
- [ ] qa-test-architecht typo fixed in opencode.jsonc
