# Agentic Toolkit

**Your Gateway to Vibecoding: AI-Powered Development Made Simple**

Discover proven tools and structured frameworks to start vibecoding as a non-technical or semi-technical user. Get essential scripts for Linux environments, learn through Vibecoding 101, and deploy ready-made AI subagents to accelerate your development workflow.

Featuring structured thinking frameworks, skills, and plugins that guide your AI collaboration for better results.

👉 [Start Learning Vibecoding 101](docs/vibecoding-101-guide.md) - Essential guide for beginners

---

## Core Value: Structured AI Development Made Simple

**Lightweight, structured subagents that enforce sequential task execution with built-in verification** - not just natural language prompting.

### Feature Overview

| Category | Component | Description |
|----------|-----------|-------------|
| **Agents** | 14 Role-Based Specialists | PO, PM, QA, Dev, Architect, UX, Master, Orchestrator plus 3-phase workflow agents (1-create-prd, 2-generate-tasks, 3-process-task-list) |
| **Skills** | 11 Core Workflows | systematic-debugging, test-driven-development, verification-before-completion, testing-anti-patterns, root-cause-tracing, condition-based-waiting, brainstorming, code-review, skill-creator, docs-builder, subagent-spawning |
| **Commands** | 9 Development Tools | debug, explain, git-commit, optimize, refactor, review, security, ship, test-generate |
| **Workflows** | 3-Phase Development | PRD Creation → Task Generation → Sequential Execution with automatic routing through digraph state machines |
| **Architecture** | Token Efficient | Progressive disclosure loads ~950 tokens for agent stubs, expands only when invoked |
| **Installation** | Multiple Options | Manual copy-paste (`cp -r ai/subagentic/claude/* ~/.claude/`) or NPM (`npx agentic-kit`) |
| **Verification** | Built-in Quality Gates | TDD enforcement, verification gates before completion, systematic debugging frameworks |

### Complete & Self-Sufficient

Works standalone out of the box. Optional: Add [Superpowers](https://github.com/obra/superpowers) framework for auto-triggering behavioral constraints if desired.

**[Full Subagent Manual](ai/subagentic/subagentic-manual.md)** | **[Install Now](#-quick-start)**

---

## 🚀 Quick Start

1. **Clone the Toolkit**: `git clone https://github.com/amrhas82/agentic-toolkit.git && cd agentic-toolkit`
2. **Set Up Environment**: Run `/tools/dev_tools_menu.sh` for Linux tool installation scripts.
3. **Learn Basics**: Read `/docs/vibecoding101.md` to understand vibecoding.
4. **Deploy Subagents**: Copy from `/ai/subagentic` or install with `npx agentic-kit` for ready-to-use AI agents.
5. **Start Vibecoding**: Use your AI tool with the deployed agents.

🚀 [Install Development Tools](tools/dev_tools_menu.sh) | 🤖 [Deploy Subagents](ai/subagentic/) | 🤖 [Install via NPM](https://github.com/amrhas82/agentic-kit)

---

## 📁 What's Included

### ⭐ Development Tools - Essential Scripts
- **Interactive Installer**: `/tools/dev_tools_menu.sh` - Choose and install Linux tools (Tmux, Neovim, etc.) with one command
- **Automation Scripts**: Pre-configured setups for development environments
- **Guides**: `/tools/tools_guide.md` - Complete documentation for all tools

### ⭐ Vibecoding 101 Guide - Your Learning Path
- **Beginner's Course**: `/docs/vibecoding101.md` - Step-by-step guide for non-technical users
- **Core Concepts**: Tool selection, AI collaboration, avoiding common pitfalls
- **Practical Examples**: Real-world vibecoding scenarios and best practices

### ⭐ Subagent Kits & Agentic Package - Installation & Platform Support
- **14 Role-Based Agents**: PO, PM, QA, Dev, Architect, UX, Master, Orchestrator (1-create-prd, 2-generate-tasks, 3-process-task-list, etc.)
- **11 Core Skills**: systematic-debugging, test-driven-development, verification-before-completion, testing-anti-patterns, root-cause-tracing, condition-based-waiting, brainstorming, code-review, skill-creator, docs-builder, subagent-spawning
- **Installation Options**:
  - **Manual**: Copy from `/ai/subagentic/` (e.g., `cp -rv ai/subagentic/claude/* ~/.claude/`)
  - **NPM Package**: `npx agentic-kit` - Auto-updates, no cloning ([repo](https://github.com/amrhas82/agentic-kit))
- **Usage**: Ask "As code-developer, build a login page" or "Create PRD for user auth" - agents route to optimal workflows
- **[📖 Subagentic Manual](ai/subagentic/subagentic-manual.md)** - Token loads, progressive disclosure, complete reference

| Bash     | Subagents                | Commands/Skills | Available in Kit   | Global Config      |
|----------|--------------------------|-----------------|--------------------|--------------------|
| claude   | @product-manager         | /command        | subagents, skills  | ~/.claude          |
| opencode | @product-manager         | /command        | subagents, command | ~/.config/opencode |
| droid    | as product manager droid | /command        | droids, commands   | ~/.factory         |
| amp      | as product manager       | /command        | subagents, commands | ~/.config/amp      |

*Both Agentic Kit and Subagent Kit provide identical content - choose based on your preferred installation method. Subagents are adapted, token-efficient role-based BMAD+Simple agents, commands/skills provide additional functionality.*

### 📖 Curated Resources
- **AI Marketplace** (`/ai/marketplace/`): Subagents (droids), plugins, skills, 200+ MCP servers, workflows ([explore](https://claude-plugins.dev/))
- **Ollama Local LLM Config** (`/ai/customize/ollama`): Ollama for Opencode/Droid ([get started](/ai/customize/ollama))
- **Claude Code Switcher** (`/ai/customize/claude-switcher`): Use GLM LLM/MCP on Claude Code ([get started](/ai/customize/claude-switcher))
- **BYOK Opencode/Droid** (`/ai/customize/byok`): Use Synthetic, GLM on Opencode/Droid Config ([get started](/ai/customize/byok))
- **Agents Best Practices** (`/ai/customize/config`): Agent tweaks and best practices ([get started](/ai/customize/config))

### 🔗 Optional Enhancement: Superpowers Integration

Agentic Toolkit is **complete and self-sufficient** out of the box. For users who want **auto-triggering behavioral constraints**, you can optionally layer [Superpowers](https://github.com/obra/superpowers) - a complementary framework with 14 auto-triggering skills that enforce discipline through context detection.

| Aspect | Agentic Toolkit (Standalone) | + Superpowers (Optional) |
|--------|------------------------------|--------------------------|
| **Workflow execution** | Digraph state machines with explicit routing | Same, plus auto-triggered constraints |
| **Agents** | 14 role-based specialists | Same 14, plus 1 code-reviewer |
| **Skills** | 11 on-demand workflow skills | Same 11, plus 14 auto-triggering behavioral skills |
| **Invocation** | Orchestrator routing | Same, plus context-based auto-triggers |
| **Use case** | Structured multi-agent workflows | Same, plus enforced TDD/verification gates |

**Use Agentic Toolkit alone for**: Structured development with role-based agents and explicit workflow control.

**Add Superpowers if you want**: Auto-triggering enforcement (TDD must run first, verification before claiming done), fresh subagent isolation per task, behavioral constraints without explicit invocation.

---

## 📂 Directory Structure

```
agentic-toolkit/
├── ai/                          # AI workflows and agents
│   ├── subagentic/              # ⭐ SUBAGENTIC KITS
│   │   ├── claude/              # subagents + skills for Claude Code
│   │   ├── opencode/            # subagents + command for OpenCode
│   │   ├── droid/               # droids + commands for Droid
│   │   └── ampcode/             # subagents + commands for Ampcode
│   ├── Customize/               # ⭐ Agent Customization KITS
│   │   ├── byok/                # Ollama Config for Droid, Ampcode
│   │   ├── claude-swticher/     # Claude Code Switcher/GLM LLM/MCP on Claude
│   │   ├── config/              # Agent tweaks and Best Practices
│   │   ├── memcp/               # Memory MCP in json + vector search
│   │   ├── ollama/              # Local LLM Ollama for Opencode/Ampcode
│   │   └── skill-to-command/    # Convert Claude skills to /commands
│   ├── marketplace/             # 📖 Curated subagents, plugins, skills, MCP servers
│   │   ├── agents/              # 90+ Resuable spcialiazed subagents (droids)
│   │   └── Workflows/           # 3-steps (simple), BMAD (role-based), Taskmaster
├── tools/                       # ⭐ Development utilities & scripts
│   ├── dev_tools_menu.sh        # Interactive installer
│   ├── master_tmux_setup.sh     # Tmux automation
│   ├── master_neovim_setup.sh   # Neovim automation
│   └── tools_guide.md           # Complete tools documentation
├── env/                         # Environment configuration
├── docs/                        # Documentation
│   └── vibecoding-101.md        # ⭐ Vibecoding beginner's guide
└── README.md                    # This file

⭐ Developed and adpated tools. Everything else is curated from best repos.
```

---

## 🎯 Who Is This For?

This toolkit is designed for anyone wanting to maximize AI-powered development:

✅ **Vibecoders** - Non-coders building with AI  
✅ **Semi-technical users** - Some coding background, learning to leverage AI  
✅ **Technical non-coders** - Strong technical knowledge without coding experience  
✅ **Developers** - Wanting structured, proven AI workflows  
✅ **Teams** - Needing standardized AI collaboration patterns

**[Vibecoding 101 Guide](docs/vibecoding-101.md)** - Learn how to build software with AI without being a traditional coder.

---

## 📖 Documentation

### Getting Started
- [This README](#-quick-start) - Start here
- [Vibecoding 101](docs/vibecoding-101.md) - Comprehensive beginner's guide
- [Tools Guide](tools/tools_guide.md) - Development tools documentation
- [Subagent Manual](ai/subagentic/subagentic-manual.md) - Complete agent guide

### AI Workflows
- [Subagent Kits](ai/subagentic/) - Your adapted agents
- [Agent Guidelines](ai/customize/config/AGENT_RULES.md) - AI collaboration guardrails

---

## 🆘 Support & Community

### Getting Help
- ⭐ **[Star this repo](https://github.com/amrhas82/agentic-toolkit)** for updates
- 💬 **[Join Discord](https://discord.gg/SDaSrH3J8d)** for vibecoding support
- 🐛 **[GitHub Issues](https://github.com/amrhas82/agentic-toolkit/issues)** for bug reports
- 💡 **[GitHub Discussions](https://github.com/amrhas82/agentic-toolkit/discussions)** for questions

### Common Questions

**Q: Which subagent kit should I use?**  
A: Use the one for your AI coding tool: Claude Code → claude, OpenCode → opencode, Amp → ampcode

**Q: What's the difference between the subagent kits and BMAD?**  
A: Subagent kits are ready-to-use, copy-paste agents. BMAD is a full framework - start with subagents for simplicity.

**Q: Can I use multiple agent kits?**  
A: Yes! Each deploys to a different location and works with different AI tools.

---

## 🤝 Contributing

We welcome contributions! See **[CONTRIBUTING.md](docs/CONTRIBUTING.md)** for guidelines.

### Quick Guide
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

**What to contribute**: Subagent improvements, tool scripts, documentation

---

## 📄 License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

---

**Built with ❤️ for the vibecoding community** | [LinkedIn](https://linkedin.com/in/hamr)

Ready to vibecode? Follow the Quick Start above!
