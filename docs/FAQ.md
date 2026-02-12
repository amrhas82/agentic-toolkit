# Frequently Asked Questions

## General Questions

### What is vibecoding?
Building software using AI agents without being a traditional coder. You guide the AI, and the AI writes the code.

### Who is this toolkit for?
- **Vibecoders**: Non-coders building with AI
- **Semi-technical users**: Some coding background, leveraging AI
- **Developers**: Want structured AI workflows
- Anyone wanting to maximize AI coding assistant effectiveness

### Do I need coding experience?
No. The toolkit is designed for varying technical levels, from non-coders to experienced developers.

---

## Subagent Kits

### Which subagent kit should I use?
Use the kit that matches your AI coding tool:
- **Claude Code** → `claude` kit
- **OpenCode** → `opencode` kit
- **Amp** → `ampcode` kit

### What's the difference between the kits?
- **claude** and **opencode**: 13 agents + 22 reusable tasks
- **ampcode**: 16 agents (includes 6 additional technical subagents, no pre-built tasks)
- All share the same 3-phase workflow agents

### Can I use multiple kits?
Yes! Each deploys to a different location:
- claude → `~/.claude/`
- opencode → `~/.config/opencode/`
- ampcode → `~/.amp/`

### How do I invoke agents?
- **Claude Code**: `@agent-name` or `As agent-name, ...`
- **OpenCode**: `As agent-name, ...`
- **Amp**: `As agent-name, ...`

### What agents are available in each kit?
See [subagentic-manual.md](../ai/subagentic/subagentic-manual.md) for the complete agent availability matrix.

---

## Workflows & Frameworks

### What's the difference between Simple, Subagents, and BMAD?

| Aspect | Simple | Subagent Kits | BMAD Method |
|--------|--------|---------------|-------------|
| **What** | Manual 3-step process | Ready-to-use agents | Enterprise framework |
| **Setup** | Copy files | Copy folder | npm install |
| **Automation** | None | Semi-automated | Fully automated |
| **Best For** | Learning | Production dev | Enterprise |
| **Complexity** | Low | Medium | High |

### Should I start with Simple or Subagents?
**Start with Subagents** - they're copy-paste ready and include the Simple 3-step workflow plus specialist agents.

### What is BMAD?
BMAD (BMad-CORE) is an external enterprise-grade Human-AI Collaboration Platform. This toolkit includes ready-to-deploy BMAD agents for Claude and OpenCode.

### Do I need BMAD?
No. Start with the subagent kits. Use BMAD if you need enterprise-scale features like Scale Adaptive Workflows and modular agent systems.

---

## Installation & Setup

### Do I need the development environment setup?
No, it's optional. The subagents work independently of the environment tools. Environment setup is a bonus for Ubuntu/Debian users.

### How long does installation take?
- **Subagents**: 30 seconds (copy-paste)
- **Dev environment**: 5-15 minutes (automated)
- **BMAD**: 10-15 minutes (npm install)

### What if I'm not on Ubuntu/Debian?
The subagent kits work on any OS. The environment setup tools are Ubuntu/Debian specific.

### Do I need to install all three kits?
No. Install only the kit for your AI tool. Installing multiple kits won't conflict but is unnecessary unless you use multiple AI tools.

---

## Technical Questions

### What is AGENT_RULES.md?
Generic AI collaboration guidelines with:
- Tech stack preferences (Node.js, TypeScript, React, PostgreSQL)
- Testing strategies
- Safety guardrails
- Communication protocols

Copy it to your project to set AI agent behavior standards.

### What are the 22 tasks in Claude/OpenCode kits?
Pre-built workflows for common development activities like validation, testing, documentation, story creation, and quality gates. See [subagentic-manual.md](../ai/subagentic/subagentic-manual.md#-reusable-tasks-claude--opencode-only).

### Why doesn't Amp have the 22 tasks?
Amp has a different architecture and uses its built-in capabilities (Task, oracle, finder) instead of pre-built task files.

### Can I customize the agents?
Yes! The agent files are markdown - edit them to match your preferences, tech stack, or communication style.

---

## Troubleshooting

### Agents not recognized by my AI tool
1. Verify you copied to the correct location
2. Restart your AI tool
3. Check file permissions: `chmod -R 644 ~/.claude/agents/*`

### Agent not behaving as expected
1. Verify the agent file isn't corrupted
2. Re-copy from the toolkit
3. Check your invocation syntax

### Tasks not working (Claude/OpenCode)
1. Ensure you copied the entire folder structure
2. Tasks may depend on templates and checklists
3. Verify all subdirectories were copied

### Installation script fails
1. Check you have sudo access
2. Verify prerequisites installed (git, curl)
3. Check the specific error message
4. Ask for help on Discord or GitHub Issues

---

## Community & Support

### Where do I get help?
- **Discord**: [Join community](https://discord.gg/SDaSrH3J8d)
- **GitHub Issues**: [Report bugs](https://github.com/hamr0/agentic-toolkit/issues)
- **Discussions**: [Ask questions](https://github.com/hamr0/agentic-toolkit/discussions)

### How do I report a bug?
1. Check if it's already reported in Issues
2. Provide clear steps to reproduce
3. Include error messages and system info
4. Tag appropriately (bug, documentation, etc.)

### Can I request new agents or features?
Yes! Open a GitHub Issue with the "enhancement" tag describing what you'd like to see.

### How do I stay updated?
- Star the repo on GitHub
- Join Discord for announcements
- Watch GitHub releases

---

## Best Practices

### Getting Started
1. Pick your AI tool (Claude/OpenCode/Amp)
2. Copy the matching subagent kit
3. Start with the 3-phase workflow (1-create-prd → 2-generate-tasks → 3-process-task-list)
4. Use specialist agents as needed

### Cost Management
- Start with free tiers when learning
- Use subscription models ($20/month) over pay-as-you-go
- Reset context proactively (75% rule)
- See [Vibecoding 101](vibecoding-101.md) for pricing strategies (in development)

### Avoiding Common Pitfalls
- **UI trap**: Build core functionality first, UI last
- **Context pollution**: Reset context at 75% usage
- **Tool lock-in**: Use multiple tools, don't depend on one
- **GitHub from Day 1**: Version control everything

---

Have a question not answered here? [Open a discussion](https://github.com/hamr0/agentic-toolkit/discussions) or ask in [Discord](https://discord.gg/SDaSrH3J8d)!
