# Ollama Ubuntu Setup Tool

Automated installation and configuration of Ollama on Ubuntu systems with Docker support. This tool provides a simple, one-command setup for Ollama with GPU/CPU detection and prepares users for step 2 manual configuration on OpenCode/Droid CLI.

## Quick Start

```bash
# Clone and run the setup
git clone <repository-url>
cd ollama-ubuntu-setup
./setup-ollama.sh

# Test your installation
curl http://localhost:11434/api/tags
```

## Alternative: Docker Compose

If you prefer using docker-compose instead of the automated script:

```bash
# For GPU support (requires NVIDIA Docker runtime)
docker-compose --profile gpu up -d

# For CPU-only mode
docker-compose --profile cpu up -d

# Stop services
docker-compose down

# View logs
docker-compose logs -f
```

## After Installation

### 1. Install Your Preferred Model

Choose and install the model you want to use:

```bash
# Popular models
ollama pull llama2
ollama pull codellama
ollama pull mistral
ollama pull deepseek-r1:8b

# List available models
ollama list

# Test a model
ollama run mistral
```

### 2. Configure OpenCode/Droid CLI

**OpenCode Configuration:**
Create `opencode.json`:
```json
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "ollama": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "Ollama (local)",
      "options": {
        "baseURL": "http://localhost:11434/v1"
      },
      "models": {
        "mistral": {
          "name": "Mistral 7B"
        }
      }
    }
  }
}
```

**Droid CLI Configuration:**
```json
{
  "custom_models": [
    {
      "model_display_name": "Mistral 7B [Local]",
      "model": "mistral",
      "base_url": "http://localhost:11434/v1",
      "api_key": "not-needed",
      "provider": "generic-chat-completion-api",
      "max_tokens": 4000
    }
  ]
}
```

### 3. Test Integration

```bash
# Test API endpoint
curl http://localhost:11434/api/tags

# Test model response
curl http://localhost:11434/api/generate \
  -d '{"model": "mistral", "prompt": "Hello, how are you?"}'
```

## Model Management

### Common Commands

```bash
# List all installed models
ollama list

# Show model details
ollama show mistral

# Remove a model
ollama rm mistral

# Remove all models
ollama rm -all

# Free up space (manual cleanup)
rm -rfv ~/.ollama/models/mistral*
```

### Model Capabilities

Check if a model supports tools:

```bash
ollama show qwen3:8b
```

Look for "tools" in the Capabilities section.

### Setting Model Parameters

```bash
ollama run mistral
>>> /set parameter num_ctx 16384
>>> /save mistral
>>> /bye
```

## Troubleshooting

### Port Conflicts

If port 11434 is already in use:

```bash
# Check what's using the port
sudo lsof -i :11434

# Stop existing Ollama
docker stop ollama

# Or use different port
docker-compose up -d --scale ollama=1
```

### Docker Issues

```bash
# Check Docker status
sudo systemctl status docker

# Add user to docker group
sudo usermod -aG docker $USER
# Then log out and log back in
```

### GPU Support

```bash
# Check NVIDIA GPU
nvidia-smi

# Use GPU profile
docker-compose --profile gpu up -d

# Use CPU profile
docker-compose --profile cpu up -d
```

## Manual Installation Alternative

If you prefer manual setup or encounter issues:

```bash
# Install Ollama directly
curl -fsSL https://ollama.com/install.sh | sh

# Start Ollama service
sudo systemctl start ollama
sudo systemctl enable ollama

# Pull and run a model
ollama run mistral
```

## Integration Resources

- [OpenCode Ollama Integration](https://github.com/p-lemonish/ollama-x-opencode)
- [Ollama Model Library](https://ollama.com/library)
- [Droid Factory BYOK Ollama](https://docs.factory.ai/cli/byok/ollama)
- [Visual Tutorial](https://www.youtube.com/watch?v=RIvM-8Wg640&t=6s)

## Requirements

- Ubuntu 18.04+ (or Ubuntu-based distributions)
- Docker (automatically installed if missing)
- 4GB+ RAM
- 10GB+ disk space
- Sudo access for Docker installation

## License

MIT License - see LICENSE file for details.

---

**Note:** This tool handles the infrastructure setup (Step 1). Users choose their own models and configure their development tools manually (Step 2) as per their specific needs.