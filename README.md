# Agentic Toolkit

**Your Gateway to Vibecoding: AI-Powered Development Made Simple**

Discover proven tools and structured frameworks to start vibecoding as a non-technical or semi-technical user. Get essential scripts for Linux environments, learn through Vibecoding 101, and deploy ready-made AI subagents to accelerate your development workflow.

Featuring structured thinking frameworks, skills, and plugins that guide your AI collaboration for better results.

👉 [Start Learning Vibecoding 101](docs/vibecoding101.md) - Essential guide for beginners

---

## 🚀 Quick Start

1. **Clone the Toolkit**: `git clone https://github.com/amrhas82/agentic-toolkit.git && cd agentic-toolkit`

2. **Set Up Environment**: Run `/tools/dev_tools_menu.sh` for Linux tool installation scripts.

3. **Learn Basics**: Read `/docs/vibecoding101.md` to understand vibecoding.

4. **Deploy Subagents**: Copy from `/ai/subagents` or install with `npx agentic-kit` for ready-to-use AI agents.

5. **Start Vibecoding**: Use your AI tool with the deployed agents.

🚀 [Install Development Tools](tools/dev_tools_menu.sh) | 🤖 [Deploy Subagents](ai/subagents/) | 🤖 [Install via NPM](https://github.com/amrhas82/agentic-kit)

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
- **3-Phase Workflow**: 1-Create PRD, 2-Generate Tasks, 3-Process Task List
- **Role-Based Agents**: PO, PM, QA, Dev, Architect, Master, Orchestrator
- **Two Installation Options**:
  - **Subagent Kits**: `/ai/subagents/` - Manual copy (e.g., `cp -r ai/subagents/claude/* ~/.claude/`)
  - **Agentic Package**: `npx agentic-kit` - NPM installable version ([repo](https://github.com/amrhas82/agentic-kit))
- **Benefits of Package**: No cloning needed, always latest, easy updates
- **Example**: Ask "As full-stack-dev, build a login page" - agents handle the workflow automatically

| Bash     | Subagents (How to Invoke) | Commands/Skills (How to Invoke) | Available in Kit | Global Config |
|----------|---------------------------|---------------------------------|------------------|---------------|
| claude   | > @product-manager        | /                               | Subagents       | ~/.claude     |
| droid    | as product manager droid  | /                               | Droids          | ~/.factory    |
| amp      | >as product manager       | /command                        | Subagents       | ~/.config/amp |
| opencode | @product-manager          | /commands                       | Subagents       | ~/.config/opencode |

*Both Agentic Kit and Subagent Kit provide identical content - choose based on your preferred installation method. Subagents are role-based BMAD+Simple agents, commands/skills provide additional functionality.*

### 📖 Curated Resources
- **AI Marketplace** (`/ai/marketplace/`): Subagents (droids), plugins, skills, 200+ MCP servers ([explore](https://claude-plugins.dev/))
- **BMAD Framework** (`/ai/bmad/`): Role-based agentic framework (PO, PM, QA, Dev, Architect, Master, Orchestrator) ([learn more](https://github.com/bmad-code-org/BMAD-METHOD))
- **Simple Framework** (`/ai/simple/`): 3-step framework - 1-Create PRD, 2-Generate Tasks, 3-Process Task List
- **Droid Factory**: 90+ specialized AI agents ([get started](https://github.com/aeitroc/Droid-CLI-Orchestrator))

---

## 📂 Directory Structure

```
agentic-toolkit/
├── ai/                          # AI workflows and agents
│   ├── subagents/               # ⭐ YOUR SUBAGENT KITS
│   │   ├── claude/              # Agents for Claude Code
│   │   ├── opencode/            # Agents for OpenCode
│   │   └── ampcode/             # Agents for Amp
│   ├── marketplace/             # 📖 Curated subagents (droids), plugins, skills, MCP servers
│   ├── bmad/                    # 📖 BMAD role-based framework
│   ├── simple/                  # 📖 3-step workflow framework
│   ├── AGENT_RULES.md           # AI collaboration guidelines
│   └── README-task-master.md    # Task management guide
├── tools/                       # ⭐ Development utilities & scripts
│   ├── dev_tools_menu.sh        # Interactive installer
│   ├── master_tmux_setup.sh     # Tmux automation
│   ├── master_neovim_setup.sh   # Neovim automation
│   └── tools_guide.md           # Complete tools documentation
├── env/                         # Environment configuration
├── docs/                        # Documentation
│   └── vibecoding-101.md        # ⭐ Vibecoding beginner's guide
└── README.md                    # This file
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
- [Subagent Manual](ai/subagents/subagentic-manual.md) - Complete agent guide

### AI Workflows
- [Subagent Kits](ai/subagents/) - Your adapted agents
- [Agent Guidelines](ai/AGENT_RULES.md) - AI collaboration guardrails

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
