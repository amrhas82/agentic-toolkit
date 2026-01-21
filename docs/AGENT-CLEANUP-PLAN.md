
● Summary - All Updates Complete

  Files Deleted (from all packages)

  - claude/agents/story-writer.md
  - claude/agents/backlog-manager.md
  - ampcode/agents/story-writer.md
  - ampcode/agents/backlog-manager.md

  Files Updated (ampcode only for agent changes)
  File: ampcode/agents/feature-planner.md
  Changes: Removed PRD/research; Added epics, stories, backlog, prioritization,
    retros
  ────────────────────────────────────────
  File: ampcode/agents/market-researcher.md
  Changes: Cleaned earlier in session
  ────────────────────────────────────────
  File: ampcode/agents/orchestrator.md
  Changes: Removed deleted agent references, updated registry
  Documentation Updated (all packages)
  File: ampcode/AGENT.md
  Changes: 14→11 agents, updated descriptions
  ────────────────────────────────────────
  File: claude/CLAUDE.md
  Changes: 14→11 agents, updated descriptions
  ────────────────────────────────────────
  File: droid/AGENTS.md
  Changes: 14→11 agents, updated descriptions
  ────────────────────────────────────────
  File: opencode/AGENTS.md
  Changes: 14→11 agents, updated descriptions
  ────────────────────────────────────────
  File: subagentic-manual.md
  Changes: Full update with new agent counts and descriptions
  ────────────────────────────────────────
  File: ampcode/AGENT-CLEANUP-PLAN.md
  Changes: Created with summary
  Final Agent List (11)
  Type: Workflow (3)
  Agents: 1-create-prd, 2-generate-tasks, 3-process-task-list
  ────────────────────────────────────────
  Type: Specialist (8)
  Agents: orchestrator, feature-planner, market-researcher, code-developer,
    quality-assurance, system-architect, ui-designer, context-builder
# Agent Cleanup Plan - COMPLETED

## Summary

**Before**: 14 agents
**After**: 11 agents (removed 3)

## Completed Actions

### DELETED (from all packages)
| Agent | Reason |
|---|---|
| **story-writer** | Merged into feature-planner |
| **backlog-manager** | Merged into feature-planner |
| **master** | Did not exist (already removed or never created) |

### UPDATED (ampcode only)
| Agent | Changes |
|---|---|
| **feature-planner** | Removed PRD/research commands; Added: epics, stories, backlog navigation, story refinement, retrospectives, prioritization |
| **orchestrator** | Removed references to deleted agents; Updated agent registry (14→11); Updated intent mapping |
| **market-researcher** | Previously cleaned - no additional changes |

### DOCUMENTATION UPDATED
| File | Changes |
|---|---|
| **subagentic-manual.md** | Updated agent counts (14→11), removed deleted agents from tables, updated feature-planner description |

## Final Agent List (11 agents)

### Workflow Agents (3)
| Agent | Purpose |
|---|---|
| 1-create-prd | PRD creation through structured discovery |
| 2-generate-tasks | Convert PRDs into task lists |
| 3-process-task-list | Execute tasks sequentially |

### Specialist Agents (8)
| Agent | Purpose |
|---|---|
| orchestrator | Coordinate workflows, route to specialists |
| feature-planner | Epics, stories, prioritization, backlog, retros |
| market-researcher | Research, discovery, competitive analysis |
| code-developer | Implementation, debugging, refactoring |
| quality-assurance | Quality gates, test architecture, review |
| system-architect | System design, tech selection, API design |
| ui-designer | UI/UX design, wireframes, accessibility |
| context-builder | Project context, CLAUDE.md, knowledge base |

## Flow Diagram

```
market-researcher (research) ─┐
                              ├─→ feature-planner (epics/stories) ─┐
                              │                                     │
                              └─────────────────────────────────────┴─→ 1-create-prd → 2-generate-tasks → 3-process-task-list
                                                                                                                    │
code-developer (direct tasks) ←─────────────────────────────────────────────────────────────────────────────────────┘
```

## Principles Applied
- Narrow scope = better results
- Avoid bloat
- Merge when clear overlap
- Keep multi-turn coherence
