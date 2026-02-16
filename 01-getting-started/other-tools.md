# Other AI Coding Tools

Beyond Claude Code, Cursor, and GitHub Copilot, several other tools are worth knowing about.

## OpenCode

**What it is**: Open-source AI coding assistant with advanced agentic capabilities and local-first architecture.

**Best for**: Developers wanting a privacy-focused, locally-run AI coding assistant with powerful agent features.

### Key Features

- Local-first architecture (you can use locally running models as well if you configure)
- Advanced agentic capabilities with tool use
- Multi-file editing and refactoring
- Terminal integration
- Codebase-aware context
- Git operations integration

### Setup

```bash
# Install via npm
npm install -g @opencode/cli

# Or download from GitHub releases
# https://github.com/opencode-ai/opencode/releases

# Start using
opencode
```

### Configuration

Create `.opencode/config.json`:

```json
{
  "model": "claude-3-5-sonnet",
  "apiKey": "your-anthropic-key",
  "autoApprove": ["Read", "Edit", "Bash(git *)"]
}
```

### Why Choose OpenCode

- **Privacy-first**: Local execution, code never leaves your machine
- **Agentic workflows**: Advanced task planning and execution
- **Cost-effective**: Use your own API keys or local models
- **Open-source**: Transparent and community-driven

### Pricing

- Free (open-source)
- Pay for API usage if using cloud models
- You may get some free models usage as well, BEWARE that free models save your data on their system

---

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

## Other Notable Tools

Quick links to other tools in the ecosystem:

- **[Aider](https://aider.chat/)** - Open-source AI pair programming for terminal
- **[Continue](https://continue.dev/)** - Open-source AI assistant for VS Code/JetBrains
- **[Antigravity](https://antigravity.ai/)** - AI coding assistant with unique approach

---

## Comparison Table

| Tool | Type | Models | Open Source | Best For |
|------|------|--------|-------------|----------|
| **OpenCode** | CLI | Any (Claude, GPT, local) | Yes | Privacy-focused, agentic workflows |
| **Windsurf** | IDE | Codeium + others | No | Cursor alternative |
| **Codex CLI** | CLI | OpenAI | No | OpenAI ecosystem |
| **Gemini CLI** | CLI | Gemini | No | Google Cloud integration |
| **Aider** | CLI | Any | Yes | Terminal flexibility |
| **Continue** | Extension | Any | Yes | VS Code customization |

## When to Consider Alternatives

### Choose OpenCode when:
- Privacy is a top concern (local-first)
- You want advanced agentic capabilities
- You prefer open-source with modern architecture

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
- You want established open-source tooling

### Choose Continue when:
- You want Copilot-like features in VS Code
- You need to use multiple model providers
- You want IDE extension approach

## Using Multiple Tools

Many developers use different tools for different purposes:

```
Primary workflow: Claude Code, Opencode or Cursor
Inline completions: Copilot or Continue
Specific integrations: Platform-specific tools
```

The key is finding what works for your workflow rather than committing to a single tool.

---

Next: [Claude Code Setup](claude-code-setup.md) | [Choosing Your Tool](choosing-your-tool.md)
