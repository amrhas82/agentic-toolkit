# Agentic Toolkit

**Your Gateway to Vibecoding: AI-Powered Development Made Simple**

Discover proven tools and structured frameworks to start vibecoding as a non-technical or semi-technical user. Get essential scripts for Linux environments, learn through Vibecoding 101, and deploy ready-made AI subagents to accelerate your development workflow.

Featuring structured thinking frameworks, skills, and plugins that guide your AI collaboration for better results.

👉 [Start Learning Vibecoding 101](docs/vibecoding-101-guide.md) - Essential guide for beginners

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

### ⭐ Subagent Kits & Agentic Package - Ready-to-Use AI Agents
- **Author-Created Content**: Adapted and compacted BMAD+Simple subagents with skills/commands and detailed role-based flows to save context
- **Token-Efficient Design**: 14 agents use **progressive disclosure** - only ~967 tokens for stubs in base conversation, full content (889-3.5k tokens) loads only when invoked. 22 skills (~3.1k tokens as metadata) expand on-demand (163-6.3k tokens when activated)
- **Orchestrator-First**: Orchestrator (~2k tokens) automatically routes requests to optimal specialist workflows with conditional questions, minimizing context overhead
- **3-Phase Workflow**: 1-Create PRD, 2-Generate Tasks, 3-Process Task List
- **Role-Based Agents**: PO, PM, QA, Dev, Architect, UX, Master, Orchestrator
- **Two Installation Options**:
  - **Subagent Kits**: `/ai/subagentic/` - Manual copy (e.g., `cp -rv ai/subagentic/claude/* ~/.claude/`)
  - **Agentic Package**: `npx agentic-kit` - NPM installable version ([repo](https://github.com/amrhas82/agentic-kit))
- **Benefits of Package**: No cloning needed, always latest, easy updates
- **Example**: Ask "As full-stack-dev, build a login page" - agents handle the workflow automatically
- **[Subagentic Manual](ai/subagentic/subagentic-manual.md)** - Complete guide with token loads and progressive disclosure details

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

### 🔗 Framework Lineage: Superpowers + Agentic Toolkit

This toolkit complements [Superpowers](https://github.com/obra/superpowers) - a lightweight framework with 1 agent and 14 behavioral skills that auto-trigger based on context.

**Why both?** Different strengths, combined power:

| Aspect | Superpowers | Agentic Toolkit |
|--------|-------------|-----------------|
| Philosophy | Behavioral constraints | Rich personas |
| Agents | 1 (code-reviewer) | 14 specialists |
| Skills | 14 auto-triggering | 22 on-demand |
| Workflow definition | Prose with principles | Digraph state machines |
| Invocation | Auto-trigger on context | Orchestrator routing |
| Context strategy | Fresh subagent per task | Accumulated with isolation |

**Superpowers excels at**: Enforcement (TDD, verification gates), context isolation via fresh subagents, minimal cognitive overhead.

**Agentic Toolkit excels at**: Explicit workflow visualization (digraphs), persona specialization, orchestrated multi-agent coordination.

**Combined approach**: Use Agentic Toolkit's digraph agents for complex workflows. Layer Superpowers' behavioral skills (TDD, verification-before-completion) as universal constraints. Get structured workflows with enforced discipline.

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
