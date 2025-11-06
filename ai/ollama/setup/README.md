# Ollama Docker Setup for Local LLMs

A complete setup for running Ollama with Docker to use local LLMs with OpenCode or Droid CLI.

## Quick Start

### Option 1: Interactive Setup (Recommended)
Run the interactive setup script for a guided experience:
```bash
./ollama-setup.sh
```

### Option 2: Ubuntu Quick Start
For Ubuntu users who want automated setup:
```bash
./start-ollama.sh
```

### Option 3: Manual Setup
1. **Start the container**:
```bash
docker compose up -d
```

2. **Pull a model**:
```bash
docker compose exec ollama ollama pull mistral:7b
```

3. **Configure context window (recommended)**:
```bash
docker compose exec ollama ollama run mistral:7b
>>> /set parameter num_ctx 8192
>>> /save mistral:7b-8k
>>> /bye
```

## Available Scripts

- `ollama-setup.sh` - Interactive menu-driven setup with all features
- `start-ollama.sh` - Automated Ubuntu quick start
- `docker-compose.yml` - Docker configuration with GPU support

## Features

### ✅ Docker Installation & Management
- Automatic Docker installation for Ubuntu/Debian systems
- Docker daemon status checking
- User permission handling
- Service management

### ✅ Ollama Container Management
- Start/stop Ollama containers
- GPU/CPU mode selection
- Port conflict resolution
- Health checks

### ✅ Model Management
- Install models from Ollama library
- Configure context windows for better tool support
- List installed models
- Remove unwanted models
- Model information display

### ✅ OpenCode & Droid CLI Integration
- Automatic configuration generation
- Tool support verification
- Context window optimization

## Requirements

### System Requirements
- **OS**: Ubuntu, Debian, macOS, or other Linux distributions
- **RAM**: Minimum 4GB (8GB+ recommended for larger models)
- **Storage**: 10GB+ for models and Docker
- **Docker**: Latest version (auto-installed on Ubuntu)

### Optional Requirements
- **NVIDIA GPU**: For GPU acceleration
- **NVIDIA Docker Runtime**: For GPU support

## Configuration

### Environment Variables
Copy `.env.example` to `.env` and modify as needed:

```bash
# Ollama data directory (persists models and configuration)
# OLLAMA_DATA=./ollama-data

# Model context window size (adjust based on available RAM)
# CONTEXT_WINDOW=8192
```

### GPU Support
The default `docker-compose.yml` includes GPU support. If you have an NVIDIA GPU and have installed the NVIDIA Container Toolkit, the container will automatically use GPU acceleration.

For CPU-only systems, the setup scripts will automatically create a CPU-only configuration.

## Model Management

### Browse Models
Find models at: [Ollama Library](https://ollama.com/library)

### Install Models
```bash
# Interactive script
./ollama-setup.sh
# Select option 6: Install model

# Manual installation
docker compose exec ollama ollama pull <model_name>
```

### Configure Models for Tool Support
Many models need increased context windows for proper tool usage:

```bash
# Create model with 8192 token context
docker compose exec ollama ollama create <model_name>-8k -f <(echo "FROM <model_name>
PARAMETER num_ctx 8192")
```

### List Installed Models
```bash
docker compose exec ollama ollama list
```

### Remove Models
```bash
docker compose exec ollama ollama rm <model_name>
```

## OpenCode Configuration

Create or update `~/.config/opencode/config.json`:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "ollama": {
      "npm": "@ai-sdk/openai-compatible",
      "options": {
        "baseURL": "http://localhost:11434/v1"
      },
      "models": {
        "mistral:7b-8k": {
          "tools": true
        }
      }
    }
  }
}
```

### Tool-Compatible Models
Models that support tools (agentic capabilities):
- `qwen2.5:7b` - Good tool support
- `llama3.2:3b` - Lightweight with tools
- `deepseek-coder:6.7b` - Code-focused with tools

## Droid CLI Configuration

Add to your Droid Factory configuration:

```json
{
  "custom_models": [
    {
      "model_display_name": "Mistral 7B [Local]",
      "model": "mistral:7b-8k",
      "base_url": "http://localhost:11434/v1",
      "api_key": "not-needed",
      "provider": "generic-chat-completion-api",
      "max_tokens": 4000
    }
  ]
}
```

## Troubleshooting

### Common Issues

#### Docker Permission Issues
```bash
# Add user to docker group
sudo usermod -aG docker $USER
# Log out and log back in for changes to take effect
```

#### Port 11434 Already in Use
```bash
# Check what's using the port
sudo lsof -i :11434
# Kill the process
sudo kill -9 <PID>
```

#### Container Won't Start
```bash
# Check container logs
docker logs ollama
# Restart container
docker compose restart
```

#### Model Not Responding
```bash
# Test API directly
curl http://localhost:11434/api/generate -d '{
  "model": "mistral:7b",
  "prompt": "Hello",
  "stream": false
}'
```

#### Tool Support Not Working
1. Ensure model supports tools: `docker compose exec ollama ollama show <model>`
2. Increase context window to 8192+ tokens
3. Check OpenCode configuration includes `"tools": true`

#### Performance Issues
1. **CPU Mode**: Use smaller models (quantized versions)
2. **Memory**: Increase system RAM or use smaller models
3. **GPU**: Install NVIDIA Container Toolkit for GPU acceleration

### Health Checks

```bash
# Check if Ollama is running
curl http://localhost:11434/api/tags

# Check container status
docker ps | grep ollama

# Check GPU usage (if applicable)
nvidia-smi
```

## Advanced Usage

### Custom Docker Compose
Create `docker-compose.custom.yml`:

```yaml
services:
  ollama:
    image: ollama/ollama:latest
    container_name: ollama
    restart: unless-stopped
    volumes:
      - ./custom_data:/root/.ollama
    ports:
      - "11434:11434"
    environment:
      - OLLAMA_MAX_LOADED_MODELS=3
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: all
              capabilities: [gpu]

volumes:
  custom_data:
```

### Model Fine-tuning Context Windows
```bash
# Test different context sizes
for ctx in 4096 8192 16384 32768; do
  docker compose exec ollama ollama create "model-${ctx}" -f <(echo "FROM base:model
PARAMETER num_ctx $ctx")
done
```

### Batch Model Installation
```bash
# Install multiple models
models=("mistral:7b" "llama3.2:3b" "qwen2.5:7b")
for model in "${models[@]}"; do
  docker compose exec ollama ollama pull "$model"
done
```

## Uninstallation

### Complete Removal
```bash
# Stop and remove container
docker compose down
docker rm ollama

# Remove Docker volume
docker volume rm ollama_data

# Remove all Ollama images
docker rmi ollama/ollama:latest
```

### Interactive Uninstallation
```bash
./ollama-setup.sh
# Select option 11: Uninstall Ollama
```

## Support and Resources

- **Ollama Documentation**: [https://ollama.com/documentation](https://ollama.com/documentation)
- **Ollama Models**: [https://ollama.com/library](https://ollama.com/library)
- **OpenCode**: [https://opencode.ai](https://opencode.ai)
- **Docker Documentation**: [https://docs.docker.com](https://docs.docker.com)
- **NVIDIA Container Toolkit**: [https://docs.nvidia.com/datacenter/cloud-native/container-toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit)

## Contributing

Feel free to submit issues and enhancement requests!

## License

This project is provided as-is for educational and development purposes.