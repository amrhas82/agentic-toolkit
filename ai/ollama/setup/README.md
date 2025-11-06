# Ollama Ubuntu Setup Tool

An automated installation and configuration tool for Ollama on Ubuntu systems with Docker support. This tool provides a seamless setup experience with GPU/CPU detection, error handling, and integration with OpenCode and Droid CLI.

## Features

- 🚀 **Automated Installation**: One-command setup of Ollama with Docker
- 🎯 **GPU/CPU Detection**: Automatic hardware detection with fallback support
- 🛡️ **Error Handling**: Comprehensive error recovery and troubleshooting
- 📊 **Health Monitoring**: Built-in health checks and status monitoring
- 🔧 **Configuration Management**: Flexible configuration with templates
- 🎨 **User-Friendly Interface**: Progress indicators and clear messaging
- 🔗 **Integration Ready**: Pre-configured templates for OpenCode and Droid CLI
- ✅ **Thoroughly Tested**: Comprehensive unit and integration tests

## Quick Start

### Prerequisites

- Ubuntu 18.04+ or derivative (Linux Mint, Pop!_OS, etc.)
- Minimum 4GB RAM
- 10GB available disk space
- Internet connection
- Sudo access (for Docker installation)

### Installation

```bash
# Clone the repository
git clone https://github.com/your-org/ollama-ubuntu-setup.git
cd ollama-ubuntu-setup

# Run the setup tool
./setup-ollama.sh
```

### Usage Examples

```bash
# Default installation with auto GPU detection
./setup-ollama.sh

# Verbose output with detailed logs
./setup-ollama.sh --verbose

# Force GPU mode
./setup-ollama.sh --gpu enabled

# Force CPU mode
./setup-ollama.sh --gpu disabled

# Custom installation directory
./setup-ollama.sh --dir /opt/ollama

# Custom port
./setup-ollama.sh --port 8080

# Dry run (preview installation steps)
./setup-ollama.sh --dry-run

# Show help
./setup-ollama.sh --help
```

## Development

This project uses a robust development workflow with automated testing, linting, and formatting.

### Development Setup

```bash
# Clone the repository
git clone https://github.com/your-org/ollama-ubuntu-setup.git
cd ollama-ubuntu-setup

# Set up development environment
make setup

# Or run the setup script manually
./scripts/install-dev.sh

# Install pre-commit hooks
make install-pre-commit
```

### Development Tools

- **ShellCheck**: Bash linting and static analysis
- **shfmt**: Bash code formatting
- **BATS**: Bash Automated Testing System
- **pre-commit**: Git hooks for code quality
- **Make**: Development task automation

### Development Commands

```bash
# Show all available commands
make help

# Run linting checks
make lint

# Format code
make format

# Run tests
make test

# Run tests with coverage
make test-coverage

# Run all checks (lint + test)
make check

# Validate project structure
make validate

# Clean temporary files
make clean
```

### Running Tests

```bash
# Run all tests
./tests/run-tests.sh

# Run specific test file
./tests/run-tests.sh --file test-error-handler.sh

# Run with verbose output
./tests/run-tests.sh --verbose

# Run with coverage analysis
./tests/run-tests.sh --coverage

# Clean up old test results
./tests/run-tests.sh --clean
```

### Code Quality

This project enforces high code quality standards:

- **Linting**: All shell scripts must pass ShellCheck
- **Formatting**: Code must be formatted with shfmt (4-space indentation)
- **Testing**: All components must have unit tests
- **Documentation**: All functions must be documented
- **Error Handling**: All functions must handle errors appropriately

### Project Structure

```
ollama-ubuntu-setup/
├── setup-ollama.sh              # Main installation script
├── lib/                         # Core libraries
│   ├── error-handler.sh         # Error handling and logging
│   ├── config-manager.sh        # Configuration management
│   ├── ui-helper.sh             # User interface components
│   ├── system-checks.sh         # System validation
│   ├── docker-manager.sh        # Docker installation/management
│   ├── ollama-installer.sh      # Ollama container setup
│   └── health-checker.sh        # Health monitoring
├── config/                      # Configuration templates
│   ├── docker-compose.yml       # Docker Compose template
│   └── docker-compose-cpu.yml   # CPU-only template
├── templates/                   # Integration templates
│   ├── opencode-config.json     # OpenCode integration
│   └── droid-config.env         # Droid CLI integration
├── tests/                       # Test suite
│   ├── test-*.sh               # Unit tests
│   ├── test-integration.sh      # Integration tests
│   └── run-tests.sh            # Test runner
├── scripts/                     # Utility scripts
│   └── install-dev.sh          # Development setup
├── docs/                       # Documentation
│   ├── README.md               # This file
│   └── TROUBLESHOOTING.md      # Troubleshooting guide
├── .pre-commit-config.yaml     # Pre-commit hooks
├── .editorconfig               # Editor configuration
├── Makefile                    # Development tasks
└── .github/workflows/          # CI/CD workflows
    └── ci.yml                  # GitHub Actions
```

## Configuration

The tool uses a comprehensive configuration system that can be customized:

### Default Configuration

- **Port**: 11434
- **Host**: 0.0.0.0
- **GPU Mode**: Auto-detection
- **Installation Directory**: `~/.ollama`
- **Log Level**: INFO
- **Max Loaded Models**: 3
- **Parallel Requests**: 2

### Configuration Files

- Main config: `~/.ollama/config/ollama.conf`
- Docker Compose: `~/.ollama/config/docker-compose.yml`
- Environment: `~/.ollama/config/ollama.env`

### Environment Variables

You can override configuration with environment variables:

```bash
export OLLAMA_PORT=8080
export OLLAMA_HOST=127.0.0.1
export GPU_MODE=disabled
./setup-ollama.sh
```

## Integration

### OpenCode Integration

After installation, use the generated OpenCode configuration:

```bash
# Copy configuration to OpenCode
cp ~/.ollama/templates/opencode-config.json ~/.opencode/config/
```

### Droid CLI Integration

Use the generated Droid CLI configuration:

```bash
# Source the configuration
source ~/.ollama/templates/droid-config.env

# Or copy to your project
cp ~/.ollama/templates/droid-config.env .env
```

## Troubleshooting

### Common Issues

1. **Docker Permission Denied**
   ```bash
   sudo usermod -aG docker $USER
   # Log out and back in
   ```

2. **Port Already in Use**
   ```bash
   # Check what's using the port
   sudo netstat -tlnp | grep 11434

   # Use a different port
   ./setup-ollama.sh --port 8080
   ```

3. **GPU Not Detected**
   ```bash
   # Check NVIDIA drivers
   nvidia-smi

   # Force CPU mode
   ./setup-ollama.sh --gpu disabled
   ```

### Health Checks

```bash
# Check Ollama status
curl http://localhost:11434/api/tags

# Check Docker container
docker ps | grep ollama

# Check logs
docker logs ollama
```

### Log Files

- Installation log: `/tmp/ollama-setup-*.log`
- Ollama container logs: `docker logs ollama`
- Configuration: `~/.ollama/config/`

## Contributing

We welcome contributions! Please follow our development guidelines:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Ensure all tests pass
6. Submit a pull request

### Development Guidelines

- Follow the existing code style (4-space indentation)
- Add comprehensive tests for new features
- Update documentation as needed
- Ensure all code passes ShellCheck
- Format code with shfmt before committing

### Testing

```bash
# Run all tests
make test

# Run with coverage
make test-coverage

# Run specific tests
./tests/run-tests.sh --file test-your-feature.sh
```

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

- **Issues**: [GitHub Issues](https://github.com/your-org/ollama-ubuntu-setup/issues)
- **Documentation**: [Wiki](https://github.com/your-org/ollama-ubuntu-setup/wiki)
- **Discussions**: [GitHub Discussions](https://github.com/your-org/ollama-ubuntu-setup/discussions)

## Acknowledgments

- [Ollama](https://github.com/ollama/ollama) - The amazing LLM runner
- [Docker](https://www.docker.com/) - Container platform
- [ShellCheck](https://www.shellcheck.net/) - Shell script analysis
- [BATS](https://bats-core.readthedocs.io/) - Bash testing framework
- [shfmt](https://github.com/mvdan/sh) - Shell formatter

---

**Note**: This tool is designed for Ubuntu and its derivatives. It may work on other Linux distributions with modifications.