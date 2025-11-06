.# Local LLM Setup with Ollama and Mistral 7B

## Quick Start

1. **Start the container**:
```bash
./start-ollama.sh
```

2. **Pull Mistral 7B model**:
```bash
docker compose exec ollama ollama pull mistral:7b
```

3. **Set context window (recommended)**:
```bash
docker compose exec ollama ollama run mistral:7b
>>> /set parameter num_ctx 8192
>>> /save mistral:7b-8k
>>> /bye
```

## Manual Setup

1. **Start Ollama container**:
```bash
docker compose up -d
```

2. **GPU vs CPU**: The default config uses GPU if available. For CPU-only, comment out the `deploy` section in `docker-compose.yml`.

3. **Change model**: Replace `mistral:7b` with any model from [Ollama library](https://ollama.com/library). Restart may be needed after changing models.

## Configuration

Copy `.env.example` to `.env` and modify as needed.

This following json in `~/.config/opencode/config.json` has worked for me so far
I, like many others have had issues getting the tools working in opencode using
local models.

I found out why agentic actions such as using opencode's provided tools didn't work.
It's because Ollama has set the context window at 4096 for the models.

Even though ollama says the context is larger, for example for qwen3 it
says context is around 40k, upon running the model via ollama, it will use a default
of 4k context, this **has** to be setup by yourself. Also make sure the model
you are planning to use actually supports *agentic* tools.

This was fixed by doing the following:

For example, after pulling `qwen3:8b`
```bash
$ docker compose exec ollama bash
$ ollama run qwen3:8b
>>> /set parameter num_ctx 16384
Set parameter 'num_ctx' to '16384'
>>> /save qwen3:8b-16k
Created new model 'qwen3:8b-16k'
>>> /bye
```

Then using the following `config.json`
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
        "qwen3:8b-16k": {
          "tools": true
        }
      }
    }
  }
}
```

First, to prove the magician's sleeves are empty

```bash
$ ls -la
total 8
drwxrwxr-x 2 lemonish lemonish 4096 Jul  1 17:21 .
drwxrwxr-x 3 lemonish lemonish 4096 Jul  1 17:21 ..
$ cat todo.md
cat: todo.md: No such file or directory
```

Run the command

```bash
$ opencode run "/no_think generate a todo.md file with the contents 'hello world, from qwen3' in it" --model ollama/qwen3:8b-16k

█▀▀█ █▀▀█ █▀▀ █▀▀▄ █▀▀ █▀▀█ █▀▀▄ █▀▀
█░░█ █░░█ █▀▀ █░░█ █░░ █░░█ █░░█ █▀▀
▀▀▀▀ █▀▀▀ ▀▀▀ ▀  ▀ ▀▀▀ ▀▀▀▀ ▀▀▀  ▀▀▀

>  /no_think generate a todo.md file with the contents 'hello world, from qwen3' in it

@  ollama/qwen3:8b-16k

|  Write    ollama/test/todo.md

<think>
</think>

<think>
</think>

</think>
</think>
</think>

Okay, I'll generate a todo.md file with the specified content. Let me create it for you

$ ls
todo.md
$ cat todo.md
hello world, from qwen3
```

ta-da!
