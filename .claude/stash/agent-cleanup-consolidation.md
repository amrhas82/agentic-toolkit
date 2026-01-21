# Stash: Agent Cleanup & Consolidation

**Timestamp**: 2026-01-21
**Session**: Agent persona review and simplification

---

## Summary

Comprehensive review and consolidation of subagentic agent system. Reduced from 14 to 11 agents by removing redundant agents and merging capabilities.

## Key Decisions

### Agents Deleted
| Agent | Reason |
|---|---|
| **story-writer** | Merged into feature-planner (epics, stories, retros) |
| **backlog-manager** | Merged into feature-planner (backlog navigation, prioritization) |
| **master** | Did not exist / redundant with orchestrator |

### Agents Updated (ampcode only)
| Agent | Changes |
|---|---|
| **feature-planner** | Removed: PRD creation, research commands. Added: epics, stories, backlog navigation, story refinement, retrospectives, prioritization |
| **market-researcher** | Cleaned: multi-turn elicitation, goal decomposition, WebSearch/WebFetch protocol |
| **orchestrator** | Updated agent registry (14→11), removed deleted agent references |

### Agents Reviewed (No Changes Needed)
- **1-create-prd** - Focused PRD creation, part of 1-2-3 flow
- **2-generate-tasks** - PRD to tasks, part of 1-2-3 flow
- **3-process-task-list** - Task execution, part of 1-2-3 flow
- **code-developer** - Clean, focused implementation
- **quality-assurance** - Distinct review/gate phase
- **system-architect** - Distinct technical architecture
- **ui-designer** - Niche UI/UX specialty
- **context-builder** - Local KB/project docs (not market research)

## Principles Applied

1. **Narrow scope = better results** - Each agent has ONE focused role
2. **Avoid bloat** - Merged overlapping agents
3. **Multi-turn coherence** - Agents stay focused in conversation
4. **Clear handoffs** - Distinct phase ownership

## Final Agent Architecture

```
market-researcher (research) ─┐
                              ├─→ feature-planner (epics/stories) ─┐
                              │                                     │
                              └─────────────────────────────────────┴─→ 1-create-prd → 2-generate-tasks → 3-process-task-list
                                                                                                                    │
code-developer (direct tasks) ←─────────────────────────────────────────────────────────────────────────────────────┘

Supporting: orchestrator, quality-assurance, system-architect, ui-designer, context-builder
```

## Files Modified

### Deleted
- `claude/agents/story-writer.md`
- `claude/agents/backlog-manager.md`
- `ampcode/agents/story-writer.md`
- `ampcode/agents/backlog-manager.md`

### Updated
- `ampcode/agents/feature-planner.md`
- `ampcode/agents/market-researcher.md`
- `ampcode/agents/orchestrator.md`
- `ampcode/AGENT.md`
- `claude/CLAUDE.md`
- `droid/AGENTS.md`
- `opencode/AGENTS.md`
- `subagentic-manual.md`

### Created
- `ampcode/AGENT-CLEANUP-PLAN.md`

## Agent Descriptions (Final)

| Agent | Description |
|---|---|
| 1-create-prd | Create PRDs through structured discovery |
| 2-generate-tasks | Convert PRDs into development task lists |
| 3-process-task-list | Execute task lists with sequential commits |
| code-developer | Implement code, debug, refactor |
| context-builder | Initialize project context, create CLAUDE.md |
| feature-planner | Epics, user stories, prioritization, backlog management |
| market-researcher | Research markets, analyze competitors, brainstorm |
| orchestrator | Coordinate workflows, route to specialists |
| quality-assurance | Quality gates, test architecture, code review |
| system-architect | Design systems, select tech, plan architecture |
| ui-designer | Design UI/UX, wireframes, accessibility |

## Pending / Future Work

- None identified - consolidation complete

---

**To restore**: Read this file and continue from the final state described above.
