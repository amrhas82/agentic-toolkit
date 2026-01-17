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

**Per-kit contents** (14 subagents + 22 skills + 20+ tasks):
- **3 Workflow Subagents** – Three-phase development: 1-Create PRD → 2-Generate Tasks → 3-Process Task List
- **11 Specialist Subagents** – Expert roles (UX, QA, Product, Dev, Architecture, etc.)
- **11 Core Skills** – Code creation, testing, debugging, docs, design, file processing
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

### Specialist Agents (11)
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

**\*Progressive Disclosure:** Token loads shown are **full agent sizes when invoked**. Your base conversation only loads lightweight stubs (~50-90 tokens each, ~967 tokens total for all 14 agents). Full agent content loads only when you invoke that specific agent via `Task` tool. Check with `/context` command to see actual current usage.

---

## 🛠 22 Reusable Skills

### Development & Testing (7)
| Skill | Purpose | Token Load* |
|-------|---------|------------|
| **test-driven-development** | Write tests first, red-green-refactor cycle ensures tests verify behavior | ~2,434 tokens |
| **testing-anti-patterns** | Avoid mock testing, test-only code, and mindless mocking | ~2,101 tokens |
| **code-review** | Structured code review workflow before merging | ~846 tokens |
| **systematic-debugging** | Four-phase debugging: investigate → analyze → hypothesize → implement | ~163 tokens |
| **root-cause-tracing** | Trace bugs backward through call stack to find original trigger | ~1,400 tokens |
| **condition-based-waiting** | Replace timeouts with polling to eliminate flaky tests | ~937 tokens |
| **verification-before-completion** | Verify claims with evidence before marking tasks complete | ~1,050 tokens |

### Design & Creativity (5)
| Skill | Purpose | Token Load* |
|-------|---------|------------|
| **algorithmic-art** | Create generative art using p5.js with seeded randomness | ~4,942 tokens |
| **canvas-design** | Create visual art in PNG/PDF with design philosophy | ~2,984 tokens |
| **artifacts-builder** | Build React/TypeScript/Tailwind/shadcn artifacts with Parcel bundling | ~769 tokens |
| **theme-factory** | Apply 10 curated professional themes with color/font pairings | ~781 tokens |
| **slack-gif-creator** | Create optimized animated GIFs for Slack | ~4,285 tokens |

### Office & Document Processing (4)
| Skill | Purpose | Token Load* |
|-------|---------|------------|
| **pdf** | Extract/create PDFs, merge/split, handle forms and tables | ~2,359 tokens |
| **docx** | Create/edit Word documents with tracked changes and comments | ~2,537 tokens |
| **pptx** | Create/edit PowerPoint with design-first approach and HTML conversion | ~6,387 tokens |
| **xlsx** | Create/edit spreadsheets with formulas, formatting, and data analysis | ~2,658 tokens |

### Strategy & Communication (4)
| Skill | Purpose | Token Load* |
|-------|---------|------------|
| **brainstorming** | Collaborative design through questioning and exploration | ~640 tokens |
| **internal-comms** | Write internal communications with company-approved formats | ~377 tokens |
| **brand-guidelines** | Apply Anthropic's official brand colors and typography | ~558 tokens |
| **mcp-builder** | Create MCP servers for LLM-service integration | ~3,388 tokens |

### Specialized (2)
| Skill | Purpose | Token Load* |
|-------|---------|------------|
| **webapp-testing** | Test local web apps with Playwright – verify, debug, screenshot | ~978 tokens |
| **skill-creator** | Create custom skills extending Claude's capabilities | ~2,886 tokens |

**\*Progressive Disclosure:** Token loads shown are **full skill sizes when activated**. Skills load on-demand via the `Skill` tool when you invoke them (e.g., `/pdf`, `/brainstorming`). Until activated, skills consume minimal tokens as slash command metadata (~3.1k tokens total for all 22 skills). Use `/context` to monitor actual usage.

---

## 🎯 How to Use This Package

### Claude Code (Orchestrator-First Pattern)
1. **Install** – `cp -rv ai/subagentic/claude/* ~/.claude/`
2. **Make requests naturally** – "Add authentication feature", "Review this code", "Plan next sprint"
3. **Orchestrator routes automatically** – Matches intent to optimal workflow, asks conditional questions
4. **Bypass when needed** – `@agent-name` or `As agent-name, ...` for direct agent access
5. **9 workflow patterns** – Pre-defined sequences in CLAUDE.md (Feature Discovery, Architecture Decision, etc.)

**Key files:**
- `~/.claude/CLAUDE.md` – Agent system with orchestrator-first routing and 9 workflows
- `~/.claude/agents/` – 14 specialist agents (orchestrator, 1-create-prd, code-developer, qa, etc.)
- Project `CLAUDE.md` – Auto-created by context-builder with agent system reminder

### Other Platforms
1. **Clone and Install** – Copy files to your CLI's config directory
2. **Start with Workflow** – Use 1-create-prd → 2-generate-tasks → 3-process-task-list
3. **Add Specialists** – Invoke agents by name for specific domain expertise
4. **Leverage Skills** – Use skills within agents for specialized capabilities
5. **Reuse Tasks** – Apply pre-built task templates for common patterns
