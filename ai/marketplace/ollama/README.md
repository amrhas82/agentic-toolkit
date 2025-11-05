# Ollama Setup and Usage Guide

## Overview

This guide covers setting up and using Ollama for local AI model inference. For a visual tutorial, see: [YouTube Tutorial](https://www.youtube.com/watch?v=RIvM-8Wg640&t=6s)

## Installation

### Install Ollama

```bash
curl -fsSL https://ollama.com/install.sh | sh
```

### Download and Run a Model

Choose a model from [Ollama Library](https://ollama.com/library/deepseek-r1) and run it:

```bash
ollama run deepseek-r1:8b
```

After downloading, test the model by asking a question at the prompt:
```
>>> can you confirm model name and your context window?
```

## Model Management Commands

### Install a Model
```bash
ollama run deepseek-r1:8b
```

### List All Models
```bash
ollama list
```

### Show Model Details
```bash
ollama show deepseek-r1:8b
```

### Remove Specific Model
```bash
ollama rm deepseek-r1:8b
```

### Remove All Models
```bash
ollama rm -all
```

### Free Up Space
Ollama stores models in `~/.ollama/models` (Linux/Mac). You can manually clean up:
```bash
rm -rfv ~/.ollama/models/deepseek-r1:8b*
```

## Integration with AI Tools

### OpenCode Configuration

Create an `opencode.json` file with the following structure:

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
        "qwen3:8b": {
          "name": "Qwen 3b"
        }
      }
    }
  }
}
```

**Note:** Cannot add child nodes with measure functions to nodes that have children.

### Droid Factory Configuration

Configure custom models in your Droid Factory settings:

```json
{
  "custom_models": [
    {
      "model_display_name": "Llama 3.2 [Local]",
      "model": "llama3.2",
      "base_url": "http://localhost:11434/v1",
      "api_key": "not-needed",
      "provider": "generic-chat-completion-api",
      "max_tokens": 4000
    }
  ]
}
```

## Troubleshooting

### Model Tool Support

Some models don't support tools. For tool-compatible models, use ones that have "tools" capability. Example with Qwen3:8b:

```bash
ollama show qwen3:8b
```

Output shows:
- **Architecture:** qwen3
- **Parameters:** 8.2B
- **Context Length:** 40960
- **Capabilities:** completion, tools, thinking
- **License:** Apache License 2.0

### Setting Model Parameters

To set parameters like context length:

```bash
$ ollama run qwen3:8b
>>> /set parameter num_ctx 16384
Set parameter 'num_ctx' to '16384'
>>> /save qwen3:8b
Created new model 'qwen3:8b'
>>> /bye
```

### Additional Resources

- [OpenCode Ollama Integration](https://github.com/p-lemonish/ollama-x-opencode)
- [Ollama Library](https://ollama.com/library)
- [Droid Factory BYOK Ollama](https://docs.factory.ai/cli/byok/ollama)
