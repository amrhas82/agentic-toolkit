# Subagent Kits Manual

Complete ready-to-use package of AI subagents, skills, and task templates for **Claude Code**, **OpenCode**, **Amp**, and **Droid**. Production-tested agent definitions from Simple + BMAD methodologies, zero configuration needed.

---

## 🚀 Quick Start

Clone the toolkit:
```bash
git clone https://github.com/amrhas82/agentic-toolkit
cd agentic-toolkit
```

Install and invoke for your platform:

| Platform | Installation | Invocation |
|----------|--------------|-----------|
| **Claude Code** | `cp -rv ai/subagentic/claude/* ~/.claude/` | Automatic via orchestrator (or `@agent-name`, `As agent-name, ...`) |
| **OpenCode** | `cp -rv ai/subagentic/opencode/* ~/.config/opencode/` | Automatic via orchestrator (or `@agent-name` or `As agent-name, ...` )|
| **Amp** | `cp -rv ai/subagentic/ampcode/* ~/.config/amp/` | Automatic via orchestrator (or `As agent-name, ...` )|
| **Droid** | `cp -rv ai/subagentic/droid/* ~/.factory/` + enable in `~/.factory/settings.json` | Automatic via orchestrator (or `invoke droid agent_name`) |

---

## 📦 What's Included

**Per-kit contents**:
- **14 Subagents Total** – 3 Workflow + 11 Specialist agents
  - **3 Workflow Subagents** – Three-phase development: 1-Create PRD → 2-Generate Tasks → 3-Process Task List
  - **11 Specialist Subagents** – Expert roles (UX, QA, Product, Dev, Architecture, Documentation, etc.)
- **Commands/Skills by Platform**:
  - **OpenCode, Droid, Amp**: 20 commands (full set)
  - **Claude Code**: 9 commands (core subset)
- **Zero Configuration** – Ready to use immediately
---

## 🤖 14 Subagents

### Workflow Phase Agents (3)
| Agent | Purpose | Token Load* |
|-------|---------|------------|
| **1-create-prd** | Create Product Requirement Documents with structured scope and requirements | ~889 tokens |
| **2-generate-tasks** | Break PRDs into granular, actionable task lists | ~1,029 tokens |
| **3-process-task-list** | Execute tasks iteratively with built-in review and progress tracking | ~1,004 tokens |

**Recommended Workflow:** PRD → Tasks → Process → Complete

### Specialist Agents (12)
| Agent | Purpose | Token Load*    |
|-------|---------|----------------|
| **ui-designer** | UI/UX design, wireframes, prototypes, front-end specifications | ~1,113 tokens  |
| **story-writer** | User stories, epic management, agile process guidance | ~927 tokens    |
| **quality-assurance** | Test architecture, quality gates, code review feedback | ~1,351 tokens  |
| **backlog-manager** | Backlog management, story refinement, acceptance criteria | ~1,299 tokens  |
| **feature-planner** | PRDs, product strategy, feature prioritization, roadmaps | ~1,243 tokens  |
| **code-developer** | Code implementation, debugging, refactoring | ~1,025 tokens  |
| **system-architect** | System design, architecture docs, API design, scalability | ~1,427 tokens  |
| **market-researcher** | Market research, competitive analysis, project discovery | ~1,295 tokens  |
| **orchestrator** | Workflow coordination, multi-agent task management, automatic routing | ~902 tokens    |
| **master** | Comprehensive expertise across all domains, universal executor | ~1,073 tokens  |
| **context-builder** | Project context setup, documentation discovery, creates CLAUDE.md with agent system | ~1,614 tokens |

**\*Progressive Disclosure:** Token loads shown are **full agent sizes when invoked**. Your base conversation only loads lightweight stubs (~50-90 tokens each, ~950 tokens total for all 14 agents). Full agent content loads only when you invoke that specific agent via `Task` tool. Check with `/context` command to see actual current usage.

---

## 🛠 Commands/Skills

### Full Package: 20 Commands (OpenCode, Droid, Amp)

**Development & Testing (10)**
| Command | Purpose |
|---------|---------|
| **test-driven-development** | Write tests first, red-green-refactor cycle ensures tests verify behavior |
| **testing-anti-patterns** | Avoid mock testing, test-only code, and mindless mocking |
| **test-generate** | Generate comprehensive test suites |
| **code-review** | Structured code review workflow before merging |
| **systematic-debugging** | Four-phase debugging: investigate → analyze → hypothesize → implement |
| **root-cause-tracing** | Trace bugs backward through call stack to find original trigger |
| **debug** | Debug an issue systematically |
| **condition-based-waiting** | Replace timeouts with polling to eliminate flaky tests |
| **verification-before-completion** | Verify claims with evidence before marking tasks complete |
| **subagent-spawning** | Templates for spawning fresh subagents with TDD-aware task isolation |

**Code Operations (6)**
| Command | Purpose |
|---------|---------|
| **refactor** | Refactor while maintaining behavior |
| **optimize** | Analyze and optimize performance |
| **explain** | Explain code for someone new |
| **review** | Comprehensive code review |
| **security** | Security vulnerability scan |
| **ship** | Pre-deployment verification |

**Strategy & Planning (4)**
| Command | Purpose |
|---------|---------|
| **brainstorming** | Collaborative design through questioning and exploration |
| **skill-creator** | Create custom skills extending Claude's capabilities |
| **docs-builder** | Create comprehensive project documentation with structured /docs hierarchy |
| **git-commit** | Analyze changes and create commit |

### Claude Code Package: 9 Commands (Core Subset)
**debug, explain, git-commit, optimize, refactor, review, security, ship, test-generate**

**\*Progressive Disclosure:** Commands load on-demand when invoked. Until activated, they consume minimal tokens as slash command metadata. Use `/context` to monitor actual usage.

---

## 🎯 How to Use This Package

### Claude Code (Orchestrator-First Pattern)
1. **Install** – `cp -rv ai/subagentic/claude/* ~/.claude/`
2. **Make requests naturally** – "Add authentication feature", "Review this code", "Plan next sprint"
3. **Orchestrator routes automatically** – Matches intent to optimal workflow, asks conditional questions
4. **Bypass when needed** – `@agent-name` or `As agent-name, ...` for direct agent access
5. **9 workflow patterns** – Pre-defined sequences in CLAUDE.md (Feature Discovery, Architecture Decision, etc.)

### Other Platforms
1. **Clone and Install** – Copy files to your CLI's config directory
2. **Start with Workflow** – Use 1-create-prd → 2-generate-tasks → 3-process-task-list
3. **Add Specialists** – Invoke agents by name for specific domain expertise
4. **Leverage Skills** – Use skills within agents for specialized capabilities
5. **Reuse Tasks** – Apply pre-built task templates for common patterns
