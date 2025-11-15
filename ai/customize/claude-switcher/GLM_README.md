# Claude Code GLM Model Customization

This guide provides instructions for configuring Claude Code to use GLM LLMs from z.ai models and MCP websearch and vision for running Claude Code. This can help you continue working with when you hit you Pro/Max plan with a comparable models like GLM 4.6. You can also customize and only use MCP which would also save you a great deal on your precious tokens.

## 1. Add GLM Models to Claude Code

[Reference Documentation](https://docs.z.ai/devpack/tool/claude#for-first-time-use-in-scripts-mac%2Flinux)

### Automatic Installation

Run the following command in your terminal:

```bash
curl -O "https://cdn.bigmodel.cn/install/claude_code_zai_env.sh" && bash ./claude_code_zai_env.sh
```

### Manual Configuration

Configure `~/.claude/settings.json` with the following content:

```json
{
    "env": {
        "ANTHROPIC_AUTH_TOKEN": "YOUR_API_KEY",
        "ANTHROPIC_BASE_URL": "https://api.z.ai/api/anthropic",
        "API_TIMEOUT_MS": "3000000",
        "ANTHROPIC_DEFAULT_HAIKU_MODEL": "glm-4.5-air",
        "ANTHROPIC_DEFAULT_SONNET_MODEL": "glm-4.6",
        "ANTHROPIC_DEFAULT_OPUS_MODEL": "glm-4.6"
    }
}
```

### Model Mapping

| Claude Code Variable | GLM Model |
|----------------------|-----------|
| `ANTHROPIC_DEFAULT_OPUS_MODEL` | GLM-4.6 |
| `ANTHROPIC_DEFAULT_SONNET_MODEL` | GLM-4.6 |
| `ANTHROPIC_DEFAULT_HAIKU_MODEL` | GLM-4.5-Air |

---

## 2. Add MCP Web Search

[Reference Documentation](https://docs.z.ai/devpack/mcp/search-mcp-server)

### Automatic Installation

Replace `YOUR_API_KEY` with your actual API Key:

```bash
claude mcp add -s user -t http web-search-prime https://api.z.ai/api/mcp/web_search_prime/mcp --header "Authorization: Bearer YOUR_API_KEY"
```

### Manual Configuration

Edit Claude Desktop's configuration file `~/.claude.json` mcpServers content (replace `your_api_key` with your API Key):

```json
{
  "mcpServers": {
    "web-search-prime": {
      "type": "http",
      "url": "https://api.z.ai/api/mcp/web_search_prime/mcp",
      "headers": {
        "Authorization": "Bearer your_api_key"
      }
    }
  }
}
```
**Note:** If you forgot to replace the API Key, uninstall the old MCP Server first:

```bash
claude mcp list
claude mcp remove zai-mcp-server
```
---

## 3. Add Vision MCP Server

[Reference Documentation](https://docs.z.ai/devpack/mcp/vision-mcp-server#claude-desktop)

### Prerequisites
- NPM Package: `@z_ai/mcp-server`
- Node.js >= v22.0.0

### Automatic Installation

Replace `YOUR_API_KEY` with your actual API Key:

```bash
claude mcp add -s user zai-mcp-server --env Z_AI_API_KEY=YOUR_API_KEY Z_AI_MODE=ZAI -- npx -y "@z_ai/mcp-server"
```

**Note:** If you forgot to replace the API Key, uninstall the old MCP Server first:

```bash
claude mcp list
claude mcp remove zai-mcp-server
```

### Manual Configuration

Edit Claude Desktop's configuration file `~/.claude.json` mcpServers content (replace `your_api_key` with your API Key):

```json
{
  "mcpServers": {
    "zai-mcp-server": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@z_ai/mcp-server"],
      "env": {
        "Z_AI_API_KEY": "your_api_key",
        "Z_AI_MODE": "ZAI"
      }
    }
  }
}
```

