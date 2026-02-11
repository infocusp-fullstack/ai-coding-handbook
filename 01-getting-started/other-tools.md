# Other AI Coding Tools

Beyond Claude Code, Cursor, and GitHub Copilot, several other tools are worth knowing about.

## Windsurf (Codeium)

**What it is**: AI-native IDE built by Codeium, similar to Cursor.

**Best for**: Developers wanting an alternative to Cursor with different AI model options.

### Key Features

- Full IDE experience (VS Code-based)
- Cascade: Multi-step agentic coding
- Supercomplete: Predictive completions
- Multiple model support

### Setup

1. Download from [codeium.com/windsurf](https://codeium.com/windsurf)
2. Install and sign in
3. Import VS Code settings (optional)

### Pricing

- Free tier available
- Pro: $15/mo
- Teams: Custom pricing

---

## Codex CLI (OpenAI)

**What it is**: OpenAI's command-line coding agent.

**Best for**: Developers in the OpenAI ecosystem who prefer terminal workflows.

### Key Features

- Terminal-native (like Claude Code)
- Uses OpenAI models (GPT-4, etc.)
- Autonomous task execution
- AGENTS.md support

### Setup

```bash
# Install
npm install -g @openai/codex

# Authenticate
codex auth

# Start using
codex
```

### Pricing

- Requires OpenAI API credits
- Pay-per-use model

---

## Gemini CLI (Google)

**What it is**: Google's command-line AI coding assistant.

**Best for**: Google Cloud users and those wanting Gemini models.

### Key Features

- Terminal-native interface
- Gemini model family
- Google Cloud integration
- Multimodal capabilities (images, diagrams)

### Setup

```bash
# Install
npm install -g @google/gemini-cli

# Authenticate with Google
gemini auth

# Start using
gemini
```

### Pricing

- Google Cloud pricing
- Free tier with limits

---

## Aider

**What it is**: Open-source AI pair programming tool for the terminal.

**Best for**: Developers wanting maximum control and customization.

### Key Features

- Open-source and self-hostable
- Works with multiple LLM providers (OpenAI, Anthropic, local models)
- Git-aware with automatic commits
- Voice coding support
- AGENTS.md support

### Setup

```bash
# Install
pip install aider-chat

# With OpenAI
export OPENAI_API_KEY=your-key
aider

# With Anthropic
export ANTHROPIC_API_KEY=your-key
aider --model claude-3-5-sonnet

# With local models (Ollama)
aider --model ollama/codellama
```

### Why Choose Aider

- **Cost control**: Use your own API keys
- **Model flexibility**: Switch providers easily
- **Privacy**: Can run with local models
- **Transparency**: Open-source, auditable

### Pricing

- Free (open-source)
- Pay for API usage to your chosen provider

---

## Continue

**What it is**: Open-source AI code assistant that integrates with VS Code and JetBrains.

**Best for**: Developers wanting Copilot-like features with more control.

### Key Features

- VS Code and JetBrains extensions
- Multiple model support (OpenAI, Anthropic, local)
- Customizable with config files
- Context providers (codebase, docs, web)
- Slash commands

### Setup

1. Install extension from VS Code marketplace
2. Configure `~/.continue/config.json`:

```json
{
  "models": [
    {
      "title": "Claude",
      "provider": "anthropic",
      "model": "claude-3-5-sonnet",
      "apiKey": "your-key"
    }
  ]
}
```

### Why Choose Continue

- **Open-source**: Community-driven development
- **Provider flexibility**: Not locked to one vendor
- **Customization**: Extensive configuration options
- **Privacy**: Can use local models

### Pricing

- Free (open-source)
- Pay for API usage to your chosen provider

---

## Comparison Table

| Tool | Type | Models | Open Source | Best For |
|------|------|--------|-------------|----------|
| **Windsurf** | IDE | Codeium + others | No | Cursor alternative |
| **Codex CLI** | CLI | OpenAI | No | OpenAI users |
| **Gemini CLI** | CLI | Gemini | No | Google Cloud users |
| **Aider** | CLI | Any (OpenAI, Anthropic, local) | Yes | Maximum flexibility |
| **Continue** | Extension | Any (OpenAI, Anthropic, local) | Yes | VS Code customization |

## When to Consider Alternatives

### Choose Windsurf when:
- You want a Cursor-like experience with different pricing
- You prefer Codeium's AI models
- You want to evaluate alternatives

### Choose Codex CLI when:
- You're invested in the OpenAI ecosystem
- You need specific OpenAI model features
- Your team standardizes on OpenAI

### Choose Gemini CLI when:
- You're using Google Cloud extensively
- You need Gemini's multimodal capabilities
- You want Google's model quality

### Choose Aider when:
- You want maximum control over AI providers
- You need to use local models for privacy
- You want open-source transparency
- You're cost-conscious with API usage

### Choose Continue when:
- You want Copilot-like features in VS Code
- You need to use multiple model providers
- You want extensive customization
- You prefer open-source tools

## Using Multiple Tools

Many developers use different tools for different purposes:

```
Primary workflow: Claude Code or Cursor
Inline completions: Copilot or Continue
Experimentation: Aider (try different models)
Specific integrations: Platform-specific tools
```

The key is finding what works for your workflow rather than committing to a single tool.

---

Next: [Claude Code Setup](claude-code-setup.md) | [Choosing Your Tool](choosing-your-tool.md)
