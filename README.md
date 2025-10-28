# Agentic Toolkit

A ready-to-use suite of tools for AI-driven development, featuring agent workflows, automation scripts, and easy environment setup to boost productivity and streamline project management. 
Complete Ubuntu/Debian development environment setup with AI-assisted workflows and agent-driven development.

## 🚀 Quick Start

### For Development Environment Setup:
```bash
<<<<<<< HEAD
git clone https://github.com/amrhas82/agentic-toolkit.git
cd agentic-toolkit
cp -r ai/subagents/claude/* ~/.claude/
```

**For OpenCode:**
```bash
cp -r ai/subagents/opencode/* ~/.config/opencode/
```

**For Amp:**
```bash
cp -r ai/subagents/ampcode/* ~/.amp/
```

📖 **[See full agent list & usage guide](ai/subagents/subagentic-manual.md)**

### Path 2: Explore Referenced Frameworks
- **Simple 3-Step**: Manual workflow in `ai/simple/`
- **BMAD Method**: Enterprise framework in `ai/bmad/`

### Path 3: Set Up Development Environment
```bash
cd tools
=======
git clone https://github.com/your-repo/agentic-toolkit.git
cd agentic-toolkit/tools
>>>>>>> parent of c8d280e (cleanup and reorganizing subagents + added ampcode subagents and updated README.md)
chmod +x dev_tools_menu.sh && ./dev_tools_menu.sh
```
- ⭐ **[Star this repo](https://github.com/amrhas82/agentic-toolkit)** to get notified of updates
- 💬 **[Join Discord](https://discord.gg/SDaSrH3J8d)** to get help with your vibecoding struggles

### For AI-Assisted Development:
- **Simple 3-step workflow**: See `ai/simple/`
- **Claude-optimized subagents**: See `ai/claude-subagents/`
- **Opencode-optimized subagents**: See `ai/opecode-subagents/`
- **BMAD framework**: See `ai/bmad/`
- **Task Master framework**: See `ai/claude-subagents/`

## 📁 What's Included

### 🤖 AI Workflows (`ai/`)
Four comprehensive approaches to AI-assisted development:

#### Simple Workflow (`ai/simple/`)
- **3-step process**: Create PRD → Generate Tasks → Process Task List
- Perfect for features, small projects, and quick iterations
- Streamlined agent guidance for rapid development

<<<<<<< HEAD
| Kit | Agents | Deploy To | Status |
|-----|--------|-----------|--------|
| **claude** | 13 specialists + 22 tasks | Claude Code (`~/.claude/`) | ✅ Production |
| **opencode** | 13 specialists + 22 tasks | OpenCode (`~/.config/opencode/`) | ✅ Production |
| **ampcode** | 16 specialists | Amp (`~/.amp/`) | ✅ Production |
=======
#### Claude Subagents (`ai/claude-subagents/`)
- **BMAD + Simple hybrid**: Claude-generated mix of BMAD and Simple workflows adapted for Claude
- **Context-optimized**: Compacted to save context while maintaining full functionality
- **Tested and proven**: Production-ready agents with validated workflows
- **Direct deployment**: Entire folder contents can be copied to `~/.claude` and invoked via `/agent_name`
- **Complete ecosystem**: All agents, teams, workflows, and dependencies included
>>>>>>> parent of c8d280e (cleanup and reorganizing subagents + added ampcode subagents and updated README.md)

#### OpenCode Subagents (`ai/opencode-subagents/`)
- **BMAD + Simple hybrid**: Same powerful agents as Claude subagents optimized for OpenCode
- **Context-optimized**: Compacted to save context while maintaining full functionality
- **Tested and proven**: Production-ready agents with validated workflows
- **Direct deployment**: Entire folder contents can be copied to `~/.config/opencode` and invoked naturally
- **Complete ecosystem**: All agents, teams, workflows, and dependencies included

#### BMAD Method (`ai/bmad/`)
BMAD framework with ready agents for Claude and OpenCode, supported by shared core files:

**a. BMAD-Claude (`ai/bmad/bmad-claude/`)**
- Ready-to-use BMAD agents adapted for Claude
- Complete agent teams with specialized roles
- Immediate deployment for Claude Code users

**b. BMAD-OpenCode (`ai/bmad/bmad-opencode/`)**
- Ready-to-use BMAD agents adapted for OpenCode
- Optimized configurations for OpenCode environment
- Plug-and-play agent definitions

**c. BMAD-Core (`ai/bmad/bmad-core/`)**
- Shared dependency folders, scripts, and workflows
- Core framework supporting both Claude and OpenCode agents
- Configurable templates and common resources

**d. BMB - BMAD Builder (`ai/bmad/bmb/`)**
- Build your own custom subagents
- Agent creation and management workflows
- Modular system for specialized agent development

#### Task Master (`ai/README-task-master.md`)
- **AI-powered task management system** for structured development workflows
- **PRD-to-tasks automation**: Parse requirements into actionable, dependency-aware tasks
- **MCP integration**: Works seamlessly with Cursor, Windsurf, VS Code, Claude Code
- **Smart task expansion**: AI-driven complexity analysis and subtask generation
- **Cross-platform CLI**: Works with multiple AI providers (Claude, GPT, Gemini, Perplexity, etc.)
- **Dependency management**: Automatic task ordering and validation
- Perfect for systematic feature development and maintaining development momentum

### 🛠️ Development Tools (`tools/`)
- **📖 Complete Tools Guide**: [`tools_guide.md`](tools/tools_guide.md) - Comprehensive documentation with examples and quick start commands
- **Automated installation scripts** for Tmux, Neovim, Lite XL
- **Interactive dev tools menu** for easy setup
- **Configuration files** and comprehensive guides
- **AI development utilities** and automation scripts

### 🖥️ Environment Setup (`env/`)

#### System Setup (`env/setup/`)
- **Backup & recovery** with Clonezilla guides
- **Partition management** and recovery procedures
- **System configuration** for optimal development environment
- **Hibernate setup** and power management

#### Development Environments (`env/tools/`)
- **Window managers**: BSPWM, DWM, Openbox configurations
- **Productivity tools**: ButterBash, ButterNotes, ButterScripts
- **Editor setups**: Neovim configuration and plugins
- **Shell environments**: Customized terminal setups

### 🔌 Integrations (`integrations/`)
- **MCP Servers**: [awesome_mcp_servers.md](integrations/awesome_mcp_servers.md) - 200+ comprehensive list of Model Context Protocol servers
- **External tool integrations** for enhanced AI capabilities
- **API connections** and service integrations
- **Extension packs** for specialized development workflows

## 🎯 Use Cases

This suite is designed for developers who want to:

### 🏗️ **Environment Setup**
- Set up a complete Ubuntu/Debian development environment from scratch
- Configure optimal development tools and workflows
- Automate system setup and maintenance tasks

### 🤖 **AI-Driven Development**
- Use AI agents to build features systematically with Task Master
- Implement role-based development workflows (BMAD Framework)
- Leverage specialized AI agents for different development phases
- Parse PRDs into actionable, dependency-aware task lists
- Integrate AI task management directly into your IDE (Cursor, VS Code, Windsurf)

### 🚀 **Productivity Enhancement**
- Streamline development workflows with automation
- Use proven configurations for popular tools
- Integrate AI capabilities into existing workflows

## 📚 Documentation Structure

### Getting Started
- [Quick Start Guide](#-quick-start)
- [Installation Instructions](tools/README.md)
- [Environment Configuration](env/)

<<<<<<< HEAD
```
agentic-toolkit/
├── ai/                          # AI workflows and agents
│   ├── subagents/               # ⭐ YOUR SUBAGENT KITS
│   │   ├── claude/    # 13 agents + 22 tasks for Claude Code
│   │   ├── opencode/  # 13 agents + 22 tasks for OpenCode
│   │   ├── ampcode/   # 16 agents for Amp
│   │   └── subagentic-manual.md # Complete agent documentation
│   ├── simple/                  # 📖 Referenced: 3-step workflow
│   ├── bmad/                    # 📖 Referenced: BMAD framework
│   │   ├── bmad-claude/         # Ready BMAD agents for Claude
│   │   ├── bmad-opencode/       # Ready BMAD agents for OpenCode
│   │   ├── bmad-core/           # Shared BMAD resources
│   │   └── bmb/                 # BMAD Builder module
│   ├── README-task-master.md    # 📖 Task Master guide
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
└── README.md                    # This file
=======
### AI Guided Development
- [Simple Workflow Guide](ai/simple/ai_dev_tasks.md)
- [Claude Subagents](ai/claude-subagents/) - BMAD+Simple hybrid tested and optimized for Claude
- [OpenCode Subagents](ai/opencode-subagents/) - BMAD+Simple hybrid tested and optimized for OpenCode
- [BMAD Method](ai/bmad/README.md)
  - [BMAD-Claude Agents](ai/bmad/bmad-claude/) - Ready-to-use Claude agents
  - [BMAD-OpenCode Agents](ai/bmad/bmad-opencode/) - Ready-to-use OpenCode agents
  - [BMAD-Core Framework](ai/bmad/bmad-core/) - Shared framework files
  - [BMB Agent Builder](ai/bmad/bmb/) - Create custom agents
- [Task Master](ai/README-task-master.md)
>>>>>>> parent of c8d280e (cleanup and reorganizing subagents + added ampcode subagents and updated README.md)

### Tools & Environment
- [Development Tools Guide](tools/guides/)
- [Window Manager Setup](env/tools/README.md)
- [System Administration](env/setup/)

### Integrations
- [MCP Server Integration](integrations/awesome_mcp_servers.md) - 200+ servers
- [External Tool Setup](integrations/README.md)

## 🛡️ System Requirements

- **OS**: Ubuntu 20.04+ or Debian 11+
- **Prerequisites**: `git`, `curl`, `sudo` access
- **Memory**: 4GB+ RAM recommended
- **Storage**: 10GB+ free space
- **Network**: Internet connection for AI services

## 🔄 Workflow Examples

### Agentic Directory - Invoke 13 Specialized subagents + 22 detailed tasks. [README](ai/subagentic-manual.md) 

```bash
<<<<<<< HEAD
# From clone to usage in 30 seconds
git clone https://github.com/amrhas82/agentic-toolkit.git
cd agentic-toolkit
cp -r ai/subagents/claude/* ~/.claude/
# Done! Start using agents in Claude Code
=======
# Those agents are the best of two worlds, simple+bmad readily tested, adapated and compacted for for context
# Agents below can be copy paste and used right away with Claude Code or Opencode
# clone repo
clone git https://github.com/amrhas82/agent-dev-suit

# Copy to Claude
cp -rv ~/agentic-toolkit/ai/claude-subagents/* ~/.claude

# copy to Opencode 
cp -rv ~/agentic-toolkit/ai/opencode-subagents/* ~/.config/opencode 
>>>>>>> parent of c8d280e (cleanup and reorganizing subagents + added ampcode subagents and updated README.md)
```


| Title | ID | When To Use |
|---|---|---|
| 1-Create PRD | 1-create-prd | 1. Define Scope: use to clearly outlining what needs to be built with a Product Requirement Document (PRD) |
| 2-Generate Tasks | 2-generate-tasks | 2. Detailed Planning: use to break down the PRD into a granular, actionable task list |
| 3-Process Task List | 3-process-task-list | 3. Iterative Implementation: use to guide the AI to tackle one task at a time, allowing you to review and approve each change |
| UX Expert | ux-expert | Use for UI/UX design, wireframes, prototypes, front-end specifications, and user experience optimization |
| Scrum Master | scrum-master | Use for story creation, epic management, retrospectives in party-mode, and agile process guidance |
| Test Architect & Quality Advisor | qa-test-architect | Use for comprehensive test architecture review, quality gate decisions, and code improvement. Provides thorough analysis including requirements traceability, risk assessment, and test strategy. Advisory only - teams choose their quality bar. |
| Product Owner | product-owner | Use for backlog management, story refinement, acceptance criteria, sprint planning, and prioritization decisions |
| Product Manager | product-manager | Use for creating PRDs, product strategy, feature prioritization, roadmap planning, and stakeholder communication |
| Full Stack Developer | full-stack-dev | Use for code implementation, debugging, refactoring, and development best practices |
| Master Orchestrator | orchestrator | Use for workflow coordination, multi-agent tasks, role switching guidance, and when unsure which specialist to consult |
| Master Task Executor | master | Use when you need comprehensive expertise across all domains, running 1 off tasks that do not require a persona, or just wanting to use the same agent for many things. |
| Architect | holistic-architect | Use for system design, architecture documents, technology selection, API design, and infrastructure planning |
| Business Analyst | business-analyst | Use for market research, brainstorming, competitive analysis, creating project briefs, initial project discovery, and documenting existing projects (brownfield) |


### Simple 3-Step Workflow
```bash
# 1. Create PRD
cd ai/simple
./1-create-prd.md

# 2. Generate Tasks
./2-generate-tasks.md

# 3. Process Task List
./3-process-task-list.md
```

### Claude Subagents (BMAD+Simple Hybrid)
```bash
# Deploy tested agents to Claude
cp -rv ai/claude-subagents/* ~/.claude/
# Invoke agents directly with /agent_name in Claude Code
```

### OpenCode Subagents (BMAD+Simple Hybrid)
```bash
# Deploy tested agents to OpenCode
cp -rv ai/opencode-subagents/* ~/.config/opencode/
# Invoke agents naturally with "As dev, ..." or role references
```

### BMAD Method
```bash
# Use ready-made Claude agents
cd ai/bmad/bmad-claude
# Copy to ~/.claude for immediate use

# Use ready-made OpenCode agents
cd ai/bmad/bmad-opencode
# See AGENTS.md for setup instructions

# Access shared core resources
cd ai/bmad/bmad-core
# Framework files used by both Claude and OpenCode agents

# Build custom agents
cd ai/bmad/bmb
./README.md
```

<<<<<<< HEAD
**Q: Which subagent kit should I use?**  
A: Use the one for your AI coding tool: Claude Code → claude, OpenCode → opencode, Amp → ampcode
=======
### Task Master
```bash
# Install globally
npm install -g task-master-ai
>>>>>>> parent of c8d280e (cleanup and reorganizing subagents + added ampcode subagents and updated README.md)

# Initialize in your project
task-master init

# Parse PRD and generate tasks
task-master parse-prd scripts/prd.txt

# Get next task and work on it
task-master next

# Or use via MCP in Cursor/VS Code
# See ai/README-task-master.md for setup
```

### Awesome LLM Skills
[Github Repo](https://github.com/Prat011/awesome-llm-skills) | [README](ai/awesome-llm-SKILLS.md)

```bash
# Clone repo
git clone https://github.com/Prat011/awesome-llm-skills.git

```

### Environment Setup
```bash
# Interactive tools setup
cd tools
./dev_tools_menu.sh

# Manual setup
./master_tmux_setup.sh
./master_neovim_setup.sh
```

## 🏗️ Architecture

```
agentic-toolkit/
├── ai/                          # AI workflows and agents
│   ├── simple/                  # 3-step workflow (PRD → Tasks → Process)
│   ├── claude-subagents/        # BMAD+Simple hybrid optimized for Claude subagents
│   ├── opencode-subagents/      # BMAD+Simple hybrid optimized for OpenCode subagents
│   ├── bmad/                    # BMAD method with ready agents
│   │   ├── bmad-claude/         # Ready-to-use Claude agents
│   │   ├── bmad-opencode/       # Ready-to-use OpenCode agents
│   │   ├── bmad-core/           # Shared framework files
│   │   └── bmb/                 # BMAD Builder for custom agents
|   ├── awesome-llm-SKILLS.md    # Awesome LLM Skills
│   └── README-task-master.md    # Task Master guide & setup
├── env/                         # Environment configuration
│   ├── setup/                   # System setup
│   └── tools/                   # Development environments
├── tools/                       # Development utilities
├── integrations/                # External integrations (MCP servers)
└── docs/                        # Comprehensive documentation
```

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

### Development Workflow
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

## 🔗 Related Projects

- [BMAD Framework](https://github.com/bmad-code-org/BMAD-METHOD) - Core AI development framework
- [MCP Protocol](https://modelcontextprotocol.io) - Model Context Protocol specifications
- [Zorin OS Development Environment](https://zorin.com/os/download/) - Ubuntu development setup

## 📊 Project Status

- ✅ **Environment Setup**: Complete with automated scripts
- ✅ **Simple AI Workflow**: Ready for production use
- ✅ **BMAD Framework**: Full implementation with all agents
- ✅ **Claude/Opencode subagents**: Fully adapted, optimized subagents ready to use
- ✅ **Task Master**: Integrated with MCP support for all major editors
- ✅ **Integration Support**: MCP servers and external tools
- 🔄 **Documentation**: Continuously improving
- 🚧 **New Features**: Actively developing

## 🆘 Support

### Getting Help
- **Documentation**: Check the relevant section in this README
- **Issues**: [GitHub Issues](https://github.com/your-repo/agentic-toolkit/issues)
- **Discussions**: [GitHub Discussions](https://github.com/your-repo/agentic-toolkit/discussions)

### Common Issues
- **Permission Errors**: Use `sudo` for system-level installations
- **AI Service Limits**: Check API key configurations
- **Environment Conflicts**: Use the provided setup scripts

## 🎉 What's New

### Version 2.0.0
- 🔄 **Reorganized Structure**: New logical folder organization
- 🤖 **Enhanced AI Workflows**: Improved simple and BMAD frameworks
- 🛠️ **Updated Tools**: Latest configurations and automation
- 📚 **Better Documentation**: Comprehensive guides and examples

### Recent Updates
- 🚀 **Claude/Opencode subagents**: Fully adapted and optimized subagents for Claude/Opencode
- 🎯 **Task Master Integration**: Full MCP support for Cursor, VS Code, Windsurf, and Claude Code
- 🔌 **MCP Server Integrations**: 200+ servers available
- 🤖 **Enhanced BMAD Framework**: New agents and workflows
- 🛠️ **Improved Environment Setup**: Updated scripts and automation
- 📚 **Comprehensive Documentation**: Streamlined guides and examples

---

**Built with ❤️ for the AI-driven development community**

Transform your development workflow with intelligent automation and AI assistance.