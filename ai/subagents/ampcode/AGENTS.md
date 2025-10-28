# Amp Subagents

This directory contains specialized subagent personas for Amp. When you invoke an agent, I adopt that persona's expertise, principles, and capabilities.

## How To Use

Simply mention the agent role naturally in your prompt:
- "As orchestrator, coordinate implementing this feature across frontend and backend"
- "As developer, implement user authentication"
- "As architect, design the database schema"
- "As qa-engineer, review this code for quality"

## Available Agents

| File Name | How To Invoke | Specialization |
|-----------|---------------|----------------|
| **1-create-prd.md** | `As 1-create-prd, ...` | **Phase 1**: Create comprehensive Product Requirements Documents, define scope, requirements, and acceptance criteria for new projects |
| **2-generate-tasks.md** | `As 2-generate-tasks, ...` | **Phase 2**: Break down PRDs into granular, actionable task lists with dependencies, priorities, and estimates |
| **3-process-task-list.md** | `As 3-process-task-list, ...` | **Phase 3**: Implement tasks iteratively one-by-one with reviews, tests, and validation after each step |
| **orchestrator.md** | `As orchestrator, ...` | Coordinate multi-agent workflows, manage complex tasks, spawn parallel subagents, synthesize results |
| **developer.md** | `As developer, ...` | Code implementation, bug fixes, refactoring, test writing, following project conventions |
| **architect.md** | `As architect, ...` | System design, technology selection, API design, database modeling, scalability planning |
| **qa-engineer.md** | `As qa-engineer, ...` | Quality reviews, test strategy design, production readiness assessment, risk analysis |
| **product-manager.md** | `As product-manager, ...` | PRD creation, user stories, feature prioritization, roadmaps, stakeholder communication |
| **ux-designer.md** | `As ux-designer, ...` | UI/UX design, wireframes, accessibility, design systems, user flows, AI UI tool prompts |
| **devops-engineer.md** | `As devops-engineer, ...` | CI/CD pipelines, infrastructure as code, Docker/Kubernetes, monitoring, cloud deployments |
| **security-expert.md** | `As security-expert, ...` | Security audits, threat modeling, authentication/authorization, vulnerability scanning |
| **data-engineer.md** | `As data-engineer, ...` | Database design, ETL pipelines, data warehouses, analytics infrastructure, query optimization |
| **technical-writer.md** | `As technical-writer, ...` | API documentation, READMEs, tutorials, architecture docs, runbooks, ADRs |
| **debugger.md** | `As debugger, ...` | Systematic debugging, log analysis, performance profiling, incident investigation |
| **researcher.md** | `As researcher, ...` | Technology evaluation, best practices research, competitive analysis, codebase learning |
| **refactorer.md** | `As refactorer, ...` | Code quality improvement, design patterns, technical debt reduction, code smell elimination |

## Agent Behaviors

When I assume an agent persona:
- I adopt their specific expertise and focus area
- I follow their core principles and methodologies
- I use their preferred tools and approaches
- I maintain their communication style
- I stay in persona until the task is complete or you switch agents

## Multi-Agent Workflows

The **orchestrator** can coordinate multiple agents:
```
As orchestrator:
1. Have architect design the system
2. Spawn 3 developers in parallel for frontend, backend, and database
3. Have qa-engineer review the implementation
4. Have devops-engineer set up deployment
```

## Built-in Amp Capabilities

All agents have access to:
- **Task** - Spawn independent subagents for complex work
- **oracle** - Consult GPT-5 for expert planning and review
- **finder/xai_finder** - Search codebase by concept
- **librarian** - Analyze multi-repo GitHub codebases
- **web_search/read_web_page** - Research documentation and best practices

## Workflows

### Three-Phase Development Workflow
Use the 1-2-3 agents for structured project development:

```
# Phase 1: Define scope
As 1-create-prd, create a PRD for user authentication with OAuth

# Phase 2: Generate tasks (after PRD review)
As 2-generate-tasks, break down this PRD into actionable tasks

# Phase 3: Implement (after task list review)
As 3-process-task-list, implement tasks one by one, pausing for my review
```

### Single Agent Examples

**Implementation:**
```
As developer, implement JWT authentication in the backend
```

**Agent switching:**
```
As architect, design the API structure
[waits for design]
Now as developer, implement that API design
```

**Orchestrated workflow:**
```
As orchestrator, implement a complete user registration flow:
1. Design the architecture
2. Implement frontend, backend, database in parallel
3. Write comprehensive tests
4. Review for security
5. Set up CI/CD
```

---

Each agent definition is in `~/.amp/agents/{agent-name}.md` - open them to see detailed capabilities and principles.
