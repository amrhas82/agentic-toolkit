 # Stop Teaching Your AI Agents - Make Them Unable to Fail Instead

## The Core Problem: Stateless Systems

AI agents operate in stateless sessions - every interaction starts fresh with no memory of previous corrections or conventions. This fundamental limitation requires a complete shift in collaboration strategy.

### Human vs AI Collaboration Patterns

**Human Developers:**
- You explain once → they remember
- They make mistakes → they learn
- Investment in the person persists

**AI Agents:**
- You explain → session ends → they forget
- They make mistakes → you correct → they repeat
- Investment in the agent evaporates

## The Solution: System-Level Enforcement

Stop trying to teach the agent. Instead, build systems that structurally enforce correct behavior.

### Three Core Tools for Stateless Systems

#### 1. Hooks (Automatic Execution)
- **Trigger:** External events (every prompt, before tool use)
- **Execution:** Shell scripts, no agent interpretation
- **Use Cases:** Context injection, validation, security
- **Pattern:** Set once, happens automatically forever

#### 2. Skills (Workflow Execution)
- **Trigger:** Task relevance (agent detects need)
- **Execution:** Agent reads and interprets instructions
- **Use Cases:** Multi-step procedures, complex logic
- **Pattern:** Reusable workflows across sessions

#### 3. MCP (Model Context Protocol)
- **Trigger:** Runtime data needs
- **Execution:** External data discovery and access
- **Use Cases:** Dynamic data from Drive, Slack, GitHub
- **Pattern:** Runtime discovery, no hardcoding

### Tool Selection Guide
| Need | Tool | Why | Example |
|------|------|-----|---------|
| Same thing every time | Hook | Automatic, fast | Git status on commit |
| Multi-step workflow | Skill | Agent decides, flexible | Post publishing workflow |
| External data access | MCP | Runtime discovery | Query Drive/Slack/GitHub |

## Four Principles for Effective AI Collaboration

### 1. Interface Explicit (Not Convention-Based)

**Problem:** Agents forget conventions between sessions.

**Solution:** Make interfaces impossible to misuse through explicit configuration and validation.

```typescript
// ✗ Implicit (agent forgets)
// "Ports go in src/ports/ with naming convention X"

// ✓ Explicit (system enforces)
export const PORT_CONFIG = {
  directory: 'src/ports/',
  pattern: '{serviceName}/adapter.ts',
  requiredExports: ['handler', 'schema']
} as const;

// Runtime validation catches violations immediately
validatePortStructure(PORT_CONFIG);
```

**MCP for Runtime Discovery:**
```typescript
// ✗ Agent hardcodes (forgets or gets wrong)
const WHISPER_PORT = 8770;

// ✓ MCP server provides (agent queries at runtime)
const services = await fetch('http://localhost:8772/api/services').then(r => r.json());
// Returns: { whisper: { endpoint: '/transcribe', port: 8772 } }
```

### 2. Context Embedded (Not External)

**Problem:** Agents ignore or forget external documentation.

**Solution:** Embed context and rationale directly in code artifacts.

```typescript
/**
 * WHY STRICT MODE:
 * - Runtime errors become compile-time errors
 * - Operational debugging cost → 0
 * - DO NOT DISABLE: Breaks type safety guarantees
 * 
 * Initial cost: +500 LOC type definitions
 * Operational cost: 0 runtime bugs caught by compiler
 */
{
  "compilerOptions": {
    "strict": true
  }
}
```

**Hooks for Automatic Context Injection:**
```bash
# UserPromptSubmit hook - runs before agent sees your prompt
# Automatically adds project context
cat << EOF
Project Context:
- TypeScript strict mode required
- Port naming: snake_case only
- API endpoints defined in src/ports/
EOF
```

### 3. Constraints Automated (Not Manual)

**Problem:** Agents can execute dangerous operations.

**Solution:** System-level constraints that block harmful actions automatically.

```bash
#!/bin/bash
# ToolUsePermission hook - validates all tool executions
if [[ "$1" == "bash" && "$2" == "rm"* ]] || [[ "$2" == "rm -rf"* ]]; then
  echo '{"permissionDecision": "deny", "reason": "Dangerous command blocked"}'
  exit 0
fi

echo '{"permissionDecision": "allow"}'
```

### 4. Iteration Protocol: Error → System Patch

**Problem:** Broken correction loop where agents repeat mistakes.

**Solution:** Fixed loop where system patches prevent future errors.

```typescript
// ✗ Temporary fix (tell the agent)
// "Port names should be snake_case"

// ✓ Permanent fix (update the system)
function validatePortName(name: string) {
  if (!/^[a-z_]+$/.test(name)) {
    throw new Error(
      `Port name must be snake_case: "${name}"
      
      Valid:   whisper_port
      Invalid: whisperPort, Whisper-Port, whisper-port`
    );
  }
}
```

**Skills for Reusable Workflows:**
```markdown
---
name: setup-typescript-project
description: Initialize TypeScript project with strict mode and validation
---

1. Run `npm init -y`
2. Install dependencies: `npm install -D typescript @types/node`
3. Create tsconfig.json with strict: true
4. Create src/ directory
5. Add validation script to package.json
```

## Real-World Example: AI-Friendly Architecture

```typescript
// Self-validating, self-documenting, self-discovering architecture

export const PORTS = {
  whisper: {
    endpoint: '/transcribe',
    method: 'POST' as const,
    input: z.object({ audio: z.string() }),
    output: z.object({ text: z.string(), duration: z.number() })
  },
  // ... other ports
} as const;

// Agent benefits:
// ✓ Endpoints enumerated (no typos) [MCP]
// ✓ Schemas auto-validate (no bad data) [Constraint]
// ✓ Types autocomplete (IDE guidance) [Interface]
// ✓ Methods constrained (correct HTTP verbs) [Validation]
```

**vs. Implicit Approach (Problematic):**
```typescript
// ✗ Agent must remember/guess everything
// "Whisper runs on port 8770"
// "Use POST to /transcribe"  
// "Send audio as base64 string"

// Result: Hardcoded wrong ports, typos, wrong data formats
```

## Implementation Guide

### Hooks Setup
Shell scripts in `.claude/hooks/` directory:
```bash
# .claude/hooks/commit.sh
echo "Git status: $(git status --short)"
```

### Skills Setup
Markdown workflows in `~/.claude/skills/{name}/SKILL.md`:
```markdown
---
name: publish-post
description: Publishing workflow
---
1. Read content
2. Scan past posts  
3. Adapt and post
```

### MCP Setup
Server configuration in `claude_desktop_config.json`:
```json
{
  "mcpServers": {
    "filesystem": {...},
    "github": {...}
  }
}
```

## How Tools Work Together

```
User: "Publish this post"
→ Hook adds git context (automatic)
→ Skill loads publishing workflow (agent detects task)
→ Agent follows steps, uses MCP if needed (external data)
→ Hook validates final output (automatic)
```

## Core Principles Summary

### Design for Amnesia
- Every session starts from zero
- Embed context in artifacts, not conversation
- Validate, don't trust

### Investment → System
- Don't teach the agent, change the system
- Replace implicit conventions with explicit enforcement
- Self-documenting code > external documentation

### Interface = Single Source of Truth
- Agent learns from: Types + Schemas + Runtime introspection (MCP)
- Agent cannot break: Validation + Constraints + Fail-fast (Hooks)
- Agent reuses: Workflows persist across sessions (Skills)

### Error = System Gap
- Agent error → system is too permissive
- Fix: Don't correct the agent, patch the system
- Goal: Make the mistake structurally impossible

## Mental Model Shift

**Old way:** AI agent = Junior developer who needs training

**New way:** AI agent = Stateless worker that needs guardrails

The agent isn't learning. The system is.

Every correction should harden the system, not educate the agent. Over time, you build architecture that's impossible to use incorrectly.

## TL;DR

Stop teaching your AI agents. They forget everything.

Instead:
- **Explicit interfaces** - MCP for runtime discovery, no hardcoding
- **Embedded context** - Hooks inject state automatically
- **Automated constraints** - Hooks validate, block dangerous actions
- **Reusable workflows** - Skills persist knowledge across sessions

**Payoff:** Initial cost high (building guardrails), operational cost → 0 (agent can't fail).

*Relevant for: Code generation, agent orchestration, LLM-powered workflows*

*Available in: Claude Code and Claude API (docs: https://docs.claude.com)*

