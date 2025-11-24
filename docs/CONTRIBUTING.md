# Contributing to Agentic Toolkit

Thank you for your interest in contributing! This toolkit is built for the vibecoding community, and we welcome all contributions.

## Ways to Contribute

### 1. Subagent Improvements
- Better agent prompts and personas
- New specialized agents
- Context optimizations
- Agent workflow enhancements

### 2. Tool Scripts
- New automation scripts
- Installation improvements
- Bug fixes in existing scripts
- Cross-platform support

### 3. Documentation
- Clarity improvements
- Usage examples
- Tutorial content
- Translation to other languages

### 4. Bug Reports
- Issues with installation scripts
- Agent behavior problems
- Documentation errors

## Getting Started

### Fork & Clone
```bash
# Fork on GitHub, then:
git clone https://github.com/YOUR-USERNAME/agentic-toolkit.git
cd agentic-toolkit
git remote add upstream https://github.com/amrhas82/agentic-toolkit.git
```

### Make Changes
```bash
# Create a feature branch
git checkout -b feature/my-improvement

# Make your changes
# Test thoroughly

# Commit with clear messages
git add .
git commit -m "Add: description of what you added/fixed"
```

### Submit Pull Request
```bash
# Push to your fork
git push origin feature/my-improvement

# Create PR on GitHub
# Describe what you changed and why
```

## Contribution Guidelines

### Code Quality
- **Test your changes**: Run scripts before submitting
- **Follow existing patterns**: Match the style of surrounding code
- **No bloat**: Keep binaries and large files out of the repo
- **Document changes**: Update relevant docs

### Commit Messages
Use clear, descriptive commit messages:
- `Add: new security-expert agent for Amp`
- `Fix: installation script permission error`
- `Update: README with clearer quick start`
- `Remove: unused dependencies from ampcode`

### Agent Contributions
When creating or modifying agents:
- Follow the existing agent template format
- Test with the target AI tool (Claude/OpenCode/Amp)
- Keep context usage minimal
- Document the agent's purpose and capabilities

### Documentation Contributions
- Use clear, concise language
- Include code examples
- Test all commands and paths
- Keep formatting consistent

## What We're Looking For

### High Priority
- Bug fixes in installation scripts
- Agent improvements for better responses
- Missing documentation
- Cross-platform compatibility

### Welcome Additions
- New specialized agents
- Workflow improvements
- Integration guides
- Tutorial content

### Not Accepting
- Large binary files
- Vendor-specific lock-in
- Over-complicated solutions
- Undocumented changes

## Testing Your Changes

### For Subagent Changes
```bash
# Copy to your local AI tool and test
cp -r ai/subagents/claude/* ~/.claude/
# Try invoking the agent and verify behavior
```

### For Tool Scripts
```bash
# Run the script to verify it works
cd tools
./your-script.sh

# Check for errors
# Verify it completes successfully
```

### For Documentation
- Read through your changes
- Verify all links work
- Check formatting renders correctly
- Test any code examples

## Code of Conduct

- Be respectful and constructive
- Help others in discussions and issues
- Focus on making the toolkit better for everyone
- Share knowledge and learn together

## Questions?

- **Discord**: [Join the community](https://discord.gg/SDaSrH3J8d)
- **Discussions**: [GitHub Discussions](https://github.com/amrhas82/agentic-toolkit/discussions)
- **Issues**: [GitHub Issues](https://github.com/amrhas82/agentic-toolkit/issues)

---

Thank you for contributing to the vibecoding community! 🙏
