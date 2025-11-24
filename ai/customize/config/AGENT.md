# 🎯 Business Analyst Consultation: Codebase Context Management

Based on official Anthropic recommendations and industry best practices, here's the strategic approach to lightweight, token-efficient codebase memory.

## 1. CLAUDE.md Files (Primary Recommendation)

This is Anthropic's official approach - Claude automatically loads CLAUDE.md files at the start of each session.

### Best Practices

- Keep under 100 lines per file
- Place at repository root (shared with team)
- Use cascading structure for monorepos (parent/child directories)
- Document:
  - Project structure & architecture decisions
  - Common commands and workflows
  - Code style & naming conventions
  - Non-obvious component relationships
  - Project-specific quirks and gotchas
  - Testing instructions

### What NOT to include

- Generic advice ("write clean code")
- Information needed only occasionally
- Detailed documentation (put in /docs instead)

## 2. Token-Efficient Context Strategies

### Tiered Documentation Approach

```
CLAUDE.md (auto-loaded)
├─ Essential info needed every session
└─ Under 100 lines

docs/ (reference with @)
├─ ARCHITECTURE.md
├─ KNOWLEDGE_BASE.md (like your existing one!)
├─ API_REFERENCE.md
└─ Reference only when needed
```

Use @ references to pull in docs on-demand:

- `@docs/KNOWLEDGE_BASE.md` - loads only when relevant
- Saves tokens by not loading unnecessary context every session

## 3. Slash Commands for Repeated Workflows

Store in `.claude/commands/` directory:

```
.claude/commands/
├─ explain-architecture.md
├─ run-tests.md
└─ debug-workflow.md
```

Access via / menu - extremely token-efficient for common tasks.

## 4. Session Start Hooks

For this repository, you could create a `.claude/hooks/session-start.sh` that:

- Displays current variant configuration
- Shows available agents
- Reminds about key documentation locations

## 5. Recommended Structure for Your Agentic Kit

Based on your KNOWLEDGE_BASE.md (which is excellent!), I recommend:

### Create: CLAUDE.md at root

```markdown
# Agentic Kit Context

## Architecture
- Plugin system for Claude Code with 13 agents, 14 skills
- 3 variants: Lite (3 agents), Standard (8 agents), Pro (13 agents)
- Location: packages/{opencode, claude, ampcode, droid}
- Main docs: @docs/KNOWLEDGE_BASE.md

## Common Commands
- Check variant: cat packages/*/variants.json
- Test agents: npm run test:agents
- Build: npm run build

## Key Patterns
- Agents: Invoked via @AgentName syntax
- Skills: Executable via /skill-name
- Config: .claude-plugin/plugin-*.json per variant

## Important Notes
- All agent files use YAML frontmatter
- Dependencies defined in resources/ directory
- See @docs/KNOWLEDGE_BASE.md for complete reference
```

Keep detailed docs in `docs/KNOWLEDGE_BASE.md` (already exists - perfect!)

## 6. Advanced: MCP Servers

For external knowledge bases or large codebases, consider MCP (Model Context Protocol) servers that provide context on-demand without token overhead.

## Strategic Recommendation

### Immediate Actions

- Create minimal CLAUDE.md at repository root (~50-80 lines)
- Keep comprehensive docs in your existing docs/KNOWLEDGE_BASE.md
- Add slash commands for common workflows (testing, building)
- Use @docs/ references when deep diving into specific areas

This gives you:

- ✅ Persistent lightweight memory (CLAUDE.md)
- ✅ On-demand detailed context (@docs/)
- ✅ Quick access to workflows (slash commands)
- ✅ Minimal token waste

### Token Impact

- CLAUDE.md: ~2,000 tokens per session (acceptable)
- @docs references: 0 tokens until explicitly referenced
- Slash commands: ~100 tokens when invoked

**The key insight:** Front-load only what's needed every time; make everything else pull-based rather than push-based.

---

## Context Initializer Subagent

### How to initialize your CLAUDE.md using subagent @context-initializer

**Location:** `packages/*/agents/context-initializer.md`

A specialized agent that helps initialize Claude Code context for projects through intelligent elicitation. It:

✅ Discovers existing documentation automatically  
✅ Asks intelligent questions about your project (elicitation-driven)  
✅ Organizes docs into /docs directory  
✅ Creates CLAUDE.md (lightweight, <100 lines, auto-loaded every session)  
✅ Creates KNOWLEDGE_BASE.md (comprehensive index, on-demand with @docs/)  
✅ Optimizes tokens (~13K tokens saved per session!)

### Complete Usage Guide

**Location:** `docs/CONTEXT_INITIALIZER_GUIDE.md`

Comprehensive documentation with:

- Quick start examples
- All commands explained
- Token optimization strategies
- Real-world usage examples
- Best practices
- Troubleshooting

### Context-initializer Commands

```
@context-initializer *init              # New project setup
@context-initializer *assess            # Existing project analysis
@context-initializer *organize          # Organize scattered docs
@context-initializer *create-claude-md  # Generate CLAUDE.md
@context-initializer *create-kb         # Generate KNOWLEDGE_BASE.md
@context-initializer *elicit            # Advanced elicitation
@context-initializer *audit             # Optimize existing setup
```

### How It Works (Elicitation Approach)

When you invoke the agent, it:

1. Scans your project structure
2. Asks questions like:
   - "Is this new or existing project?"
   - "What's your tech stack?"
   - "What do you reference most often?"
   - "What should Claude always know?"
3. Proposes organization strategy
4. Creates optimal CLAUDE.md and KNOWLEDGE_BASE.md
5. Teaches you the maintenance workflow

### Token Efficiency Example

**Before:**
- No context → Agent explores blindly every session (~10K tokens)
- Scattered docs → Repeated searches (~5K tokens)
- Total: ~15K tokens wasted per session

**After:**
- CLAUDE.md auto-loads essentials (~2K tokens once)
- KNOWLEDGE_BASE.md referenced on-demand (~0K baseline)
- Total: ~2K tokens per session

**Savings: ~13K tokens per session! 🚀**


