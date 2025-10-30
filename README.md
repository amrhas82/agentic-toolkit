# Agentic Toolkit

**Ready-to-use AI subagents, frameworks, and development environment for vibecoders**

A comprehensive toolkit for non-coders, semi-technical users, and developers who want to maximize AI-powered development through proven agentic workflows.

🎯 **Primary Value**: Copy-paste subagent kits adapted from best practices  
🛠️ **Bonus**: Complete Ubuntu/Debian dev environment automation  
📚 **Resources**: Curated frameworks, workflows, and integrations

---

## 🚀 Quick Start

**Choose Your AI Tool:**

| Your AI Tool | Use This Kit | Installation |
|--------------|--------------|--------------|
| **Claude Code** | `claude` | `cp -r ai/subagents/claude/* ~/.claude/` |
| **OpenCode** | `opencode` | `cp -r ai/subagents/opencode/* ~/.config/opencode/` |
| **Amp** | `ampcode` | `cp -r ai/subagents/ampcode/* ~/.amp/` |

### Installation Steps

```bash
# 1. Clone the toolkit
git clone https://github.com/amrhas82/agentic-toolkit.git
cd agentic-toolkit

# 2. Copy YOUR kit (pick one)

# For Claude Code:
cp -r ai/subagents/claude/* ~/.claude/

# For OpenCode:
cp -r ai/subagents/opencode/* ~/.config/opencode/

# For Amp:
cp -r ai/subagents/ampcode/* ~/.amp/
```

📖 **[See full agent list & usage guide](ai/subagents/subagentic-manual.md)**
🤖 **[Explore 90+ specialized Droids](ai/droids/droid-comprehensive-table.md)** - Advanced AI orchestration system

- ⭐ **[Star this repo](https://github.com/amrhas82/agentic-toolkit)** to get notified of updates
- 💬 **[Join Discord](https://discord.gg/SDaSrH3J8d)** to get help with your vibecoding struggles

### Optional: Set Up Development Environment
```bash
cd tools
chmod +x dev_tools_menu.sh && ./dev_tools_menu.sh
```

---

## 🤖 Subagent Kits Overview

| Kit | Agents | AI Tool | Deploy To | Status |
|-----|--------|---------|-----------|--------|
| **claude** | 13 specialists + 22 tasks | Claude Code | `~/.claude/` | ✅ Production |
| **opencode** | 13 specialists + 22 tasks | OpenCode | `~/.config/opencode/` | ✅ Production |
| **ampcode** | 16 specialists | Amp | `~/.amp/` | ✅ Production |

**What You Get:**
- **3-Phase Workflow Agents**: PRD Creator → Task Generator → Task Processor
- **Role-Based Specialists**: Orchestrator, Developer, Architect, QA, Product Manager, UX Designer, and more
- **Reusable Tasks** (Claude/OpenCode only): 22 pre-built workflows for validation, testing, documentation
- **Zero Configuration**: Copy-paste and start using immediately

📖 **[Complete agent documentation](ai/subagents/subagentic-manual.md)**

---

## 🎯 Who Is This For?

This toolkit is designed for anyone wanting to maximize AI-powered development:

✅ **Vibecoders** - Non-coders building with AI  
✅ **Semi-technical users** - Some coding background, learning to leverage AI  
✅ **Technical non-coders** - Strong technical knowledge without coding experience  
✅ **Developers** - Wanting structured, proven AI workflows  
✅ **Teams** - Needing standardized AI collaboration patterns

### 📚 New to Vibecoding?

**[Vibecoding 101 Guide](docs/vibecoding-101.md)** - Comprehensive guide in development (7 of 12 sections complete)

Learn how to build software with AI without being a traditional coder. Covers tool selection, context management, pricing models, and avoiding common pitfalls like the $1,000 UI trap.

---

## 📁 What's Included

### ⭐ Your Toolkit (Original Adaptations)

#### **Subagent Kits** - Ready-to-Use AI Agents
Production-ready agents adapted from Simple + BMAD methods, optimized for context and immediate deployment:

Location: `ai/subagents/`
- **claude/** - 13 agents + 22 tasks for Claude Code
- **opencode/** - 13 agents + 22 tasks for OpenCode
- **ampcode/** - 16 agents for Amp

📖 **[Tools guide](tools/tools_guide.md)**

#### **Droid Factory CLI** - Intelligent Orchestration System
**Source**: [Droid-CLI-Orchestrator](https://github.com/aeitroc/Droid-CLI-Orchestrator) by aeitroc

Complete orchestration system with 90+ specialized AI droids for intelligent project coordination and execution:

Location: `ai/droids/`
- **90+ Specialized Droids**: Domain-specific AI agents for every development task
- **Smart Orchestrator**: Intelligent project planning and coordination
- **Learning System**: Adaptive execution with memory-based improvements
- **Proactive Usage**: Droids automatically engage when their expertise is needed

**Key Droid Categories:**
- **Orchestration**: Master coordinators for project analysis and planning
- **AI & ML**: LLM applications, RAG systems, prompt engineering
- **Backend**: 21 language-specific droids (Python, Go, Rust, Java, etc.)
- **Frontend**: React, Next.js, Flutter, mobile development
- **Security**: Backend, frontend, mobile security specialists
- **Database**: Architecture, optimization, administration
- **DevOps**: Infrastructure, CI/CD, cloud, Kubernetes
- **Documentation**: Technical writing, API docs, user guides
- **SEO & Marketing**: 10 specialized digital marketing droids
- **Testing**: Quality assurance, automation, debugging

📖 **[Complete Droid Documentation](ai/droids/comprehensive-droid-documentation.md)**
📊 **[Droid Reference Table](ai/droids/droid-comprehensive-table.md)**
⚙️ **[Droid CLI Setup Guide](ai/droids/README-Droid-CLI.md)**

#### **Development Tools** - Automation Scripts
- Automated installation for Tmux, Neovim, Lite XL
- Interactive dev tools menu for easy setup
- Configuration files and comprehensive guides

#### **Environment Setup** - Ubuntu/Debian Configuration
- **System Setup**: Backup, recovery, partition management
- **Development Environments**: Window managers (BSPWM, DWM, Openbox)
- **Productivity Tools**: ButterBash, ButterNotes, ButterScripts

---

### 📖 Referenced Frameworks (External Resources)

These are curated references to external projects - this repo provides links and guidance:

#### **Simple Workflow** (`ai/simple/`)
**Source**: Community-contributed 3-step methodology

**What it is**: Manual workflow without automation
- Step 1: Create PRD
- Step 2: Generate Tasks  
- Step 3: Process Task List

**Best for**: Learning the methodology, understanding the foundations

#### **BMAD Method** (`ai/bmad/`)
**Source**: [BMad-CORE by bmad-code-org](https://github.com/bmad-code-org/BMAD-METHOD)

**What it is**: Enterprise-grade Human-AI Collaboration Platform
- npm installable package
- Scale Adaptive Workflows (Levels 0-4)
- Multiple modules: BMM (software dev), BMB (agent builder), CIS (creative intelligence)
- Four-phase methodology: Analysis → Planning → Solutioning → Implementation

**Available in this repo:**
- Ready-to-deploy BMAD agents for Claude (`ai/bmad/bmad-claude/`)
- Ready-to-deploy BMAD agents for OpenCode (`ai/bmad/bmad-opencode/`)
- Shared core resources (`ai/bmad/bmad-core/`)
- Agent builder module (`ai/bmad/bmb/`)

#### **Task Master** (`ai/README-task-master.md`)
AI-powered task management system for structured workflows
- PRD-to-tasks automation with dependency awareness
- MCP integration for Cursor, Windsurf, VS Code, Claude Code

#### **Curated Resources**
- **[Awesome MCP Servers](integrations/awesome_mcp_servers.md)** - 200+ Model Context Protocol servers
- **[Awesome LLM Skills](ai/awesome-llm-SKILLS.md)** - [Source](https://github.com/Prat011/awesome-llm-skills)

---

## 📂 Directory Structure

```
agentic-toolkit/
├── ai/                          # AI workflows and agents
│   ├── subagents/               # ⭐ YOUR SUBAGENT KITS
│   │   ├── claude/              # 13 agents + 22 tasks for Claude Code
│   │   ├── opencode/            # 13 agents + 22 tasks for OpenCode
│   │   ├── ampcode/             # 16 agents for Amp
│   │   └── subagentic-manual.md # Complete agent documentation
│   ├── simple/                  # 📖 Referenced: 3-step workflow
│   ├── bmad/                    # 📖 Referenced: BMAD framework
│   │   ├── bmad-claude/         # Ready BMAD agents for Claude
│   │   ├── bmad-opencode/       # Ready BMAD agents for OpenCode
│   │   ├── bmad-core/           # Shared BMAD resources
│   │   └── bmb/                 # BMAD Builder module
│   ├── AGENT_RULES.md           # Generic AI collaboration guardrails
│   ├── README-task-master.md    # 📖 Task Master guide
│   ├── awesome_claude_tools     # 📖 Curated Claude Tools
│   └── awesome-llm-SKILLS.md    # 📖 Curated LLM resources

├── tools/                       # ⭐ Development utilities & scripts
│   ├── dev_tools_menu.sh        # Interactive installer
│   ├── master_tmux_setup.sh     # Tmux automation
│   ├── master_neovim_setup.sh   # Neovim automation
│   └── tools_guide.md           # Complete tools documentation
├── env/                         # ⭐ Environment configuration
│   ├── setup/                   # System setup & recovery
│   └── tools/                   # Window managers & productivity tools
├── integrations/                # 📖 External integrations
│   └── awesome_mcp_servers.md   # 200+ MCP server list
├── docs/                        # Documentation
│   └── vibecoding-101.md        # Vibecoding beginner's guide
└── README.md                    # This file

Legend: ⭐ Original content  📖 Referenced/curated content
```

---

## 💡 How to Use This Repo

### For Quick Setup (Most Users)
1. **Clone the repo**
2. **Copy the subagent kit** for your AI tool (Claude/OpenCode/Amp)
3. **Start using agents** - they're pre-configured and ready
4. **Optional**: Set up dev environment with `tools/dev_tools_menu.sh`

### For Learning
1. **Start with Simple workflow** (`ai/simple/`) to understand the 3-step method
2. **Explore subagent kits** to see how they implement the patterns
3. **Try BMAD** if you need enterprise-scale workflows

### For Deep Customization
1. **Use BMB (BMAD Builder)** to create custom agents
2. **Fork and modify** the subagent kits for your needs
3. **Contribute back** your improvements

---

## 🔄 Workflow Comparison

| Feature | Simple | Subagent Kits | BMAD Method |
|---------|--------|---------------|-------------|
| **Automation Level** | Manual | Semi-automated | Fully automated |
| **Setup** | Copy files | Copy folder | npm install |
| **Agents** | 3 workflow steps | 13-16 specialists | 20+ specialists |
| **Best For** | Learning, small tasks | Production dev | Enterprise projects |
| **Complexity** | Low | Medium | High |
| **Context Usage** | High | Optimized | Variable |
| **Installation Time** | 1 min | 2 min | 10-15 min |

---

## 📋 AI Agent Guidelines

This toolkit includes standardized guardrails for AI collaboration across any AI coding tool:

**[AGENT_RULES.md](ai/AGENT_RULES.md)** - Generic AI agent collaboration guidelines
- **Communication Protocols**: How AI agents should interact and clarify requirements
- **Tech Stack Preferences**: Node.js, TypeScript, React, PostgreSQL, Drizzle ORM
- **Testing Strategies**: Unit, Integration, E2E, Performance, Security testing frameworks
- **Development Principles**: Safety guardrails, simplicity advocacy, fact-based responses
- **Workflow Standards**: File impact analysis, change documentation, authentication protection

### How to Use

**Copy to your project** to establish AI collaboration standards:
```bash
cp ai/AGENT_RULES.md your-project/.claude/
# or
cp ai/AGENT_RULES.md your-project/.cursorrules
# or
cp ai/AGENT_RULES.md your-project/CLAUDE.md
```

**What it provides:**
- ✅ Sets expectations for AI agent behavior
- ✅ Defines preferred tech stack and tools
- ✅ Establishes comprehensive testing requirements
- ✅ Provides safety guardrails for critical operations
- ✅ Ensures consistent communication style

**Customizable**: Edit the file to match your project's specific stack and preferences.

---

## 🛡️ System Requirements

### For AI Subagents
- **AI Coding Tool**: Claude Code, OpenCode, or Amp
- **Storage**: 50MB for subagent files
- **No dependencies**: Copy-paste ready

### For Development Environment Setup
- **OS**: Ubuntu 20.04+ or Debian 11+
- **Prerequisites**: `git`, `curl`, `sudo` access
- **Memory**: 4GB+ RAM recommended
- **Storage**: 10GB+ free space

### For BMAD Method
- **Node.js**: v20+ required
- **Git**: For cloning repository

---

## 📖 Documentation

### Getting Started
- [This README](#-quick-start) - Start here
- [Vibecoding 101](docs/vibecoding-101.md) - Comprehensive beginner's guide (in development)
- [FAQ](docs/FAQ.md) - Frequently asked questions
- [Subagent Manual](ai/subagents/subagentic-manual.md) - Complete agent guide
- [Tools Guide](tools/tools_guide.md) - Development tools documentation

### AI Workflows
- [Subagent Kits](ai/subagents/subagentic-manual.md) - Your adapted agents
- [Simple Workflow](ai/simple/) - 3-step methodology
- [BMAD Method](ai/bmad/README.md) - Enterprise framework
- [Task Master](ai/README-task-master.md) - Task management system
- [Agent Guidelines](ai/AGENT_RULES.md) - Generic AI collaboration guardrails

### Tools & Environment
- [Development Tools](tools/tools_guide.md)
- [Environment Setup](env/)
- [MCP Integrations](integrations/awesome_mcp_servers.md)

### Contributing
- [Contributing Guide](docs/CONTRIBUTING.md)
- [FAQ](docs/FAQ.md)

---

## 🎉 What Makes the Subagent Kits Special?

### Adapted from Best Practices
The subagent kits combine the best of two proven methodologies:
- **Simple Method**: Clear 3-phase workflow (PRD → Tasks → Process)
- **BMAD Framework**: Role-based specialists with deep expertise

### Optimized for Real Use
- **Reduced context**: Compacted to minimize token usage
- **Tested**: Production-ready and validated
- **Zero config**: No setup required, just copy and use
- **Consistent**: Same agents across Claude, OpenCode, and Amp

### Immediately Deployable
```bash
# From clone to usage in 30 seconds
git clone https://github.com/amrhas82/agentic-toolkit.git
cd agentic-toolkit
cp -r ai/subagents/claude/* ~/.claude/
# Done! Start using agents in Claude Code
```

---

## 🆘 Support & Community

### Getting Help
- ⭐ **[Star this repo](https://github.com/amrhas82/agentic-toolkit)** for updates
- 💬 **[Join Discord](https://discord.gg/SDaSrH3J8d)** for vibecoding support and community
- 🐛 **[GitHub Issues](https://github.com/amrhas82/agentic-toolkit/issues)** for bug reports
- 💡 **[GitHub Discussions](https://github.com/amrhas82/agentic-toolkit/discussions)** for questions

### Common Questions

**Q: Which subagent kit should I use?**  
A: Use the one for your AI coding tool: Claude Code → claude, OpenCode → opencode, Amp → ampcode

**Q: What's the difference between the subagent kits and BMAD?**  
A: Subagent kits are ready-to-use, copy-paste agents. BMAD is a full framework with installer and more features. Start with subagents for simplicity.

**Q: Can I use multiple agent kits?**  
A: Yes! Each deploys to a different location and works with different AI tools.

**Q: Do I need the development environment setup?**  
A: No, it's optional. The subagents work independently of the environment tools.

---

## 🤝 Contributing

We welcome contributions! See **[CONTRIBUTING.md](docs/CONTRIBUTING.md)** for detailed guidelines.

### Quick Guide
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-improvement`)
3. Make your changes and test thoroughly
4. Submit a pull request

**What to contribute**: Subagent improvements, tool scripts, documentation, bug fixes

---

## 📄 License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Attribution & Credits

### Original Content (This Repository)
- ⭐ Subagent kit adaptations for Claude, OpenCode, and Amp
- ⭐ Development tools and automation scripts
- ⭐ Environment setup configurations

### Referenced External Projects
- **Simple Workflow** - Community-contributed 3-step methodology
- **BMAD Method** - [bmad-code-org](https://github.com/bmad-code-org/BMAD-METHOD) - BMad-CORE framework
- **Droid Factory CLI** - [aeitroc](https://github.com/aeitroc/Droid-CLI-Orchestrator) - 90+ specialized AI droids orchestration system
- **Awesome MCP Servers** - Curated MCP server collection
- **Awesome LLM Skills** - [Prat011](https://github.com/Prat011/awesome-llm-skills)
- **Task Master** - AI task management system

Special thanks to the vibecoding community and all contributors!

---

## 🔗 Related Resources

- [BMAD Framework](https://github.com/bmad-code-org/BMAD-METHOD) - Enterprise AI collaboration platform
- [Model Context Protocol](https://modelcontextprotocol.io) - MCP specifications
- [Claude Code](https://claude.ai/code) - Anthropic's coding assistant
- [Amp](https://ampcode.com) - AI coding assistant

---

## 📊 Project Status

- ✅ **Subagent Kits**: Production-ready for Claude, OpenCode, and Amp
- ✅ **Development Tools**: Complete with automated scripts
- ✅ **Environment Setup**: Full Ubuntu/Debian automation
- ✅ **BMAD Integration**: Ready-to-deploy agents included
- ✅ **Documentation**: Comprehensive guides and examples
- 🔄 **Continuous Improvement**: Actively maintained and updated

---

**Built with ❤️ for the vibecoding community**

Transform your AI-powered development workflow with proven, ready-to-use tools and agents.
