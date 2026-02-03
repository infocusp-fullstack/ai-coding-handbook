# Resources & References

A curated collection of official documentation, community resources, and tools for AI-assisted development.

## Official Documentation

### Claude Code

| Resource | URL | Description |
|----------|-----|-------------|
| Official Docs | [docs.anthropic.com/claude-code](https://docs.anthropic.com/claude-code) | Complete Claude Code documentation |
| Best Practices | [anthropic.com/engineering/claude-code-best-practices](https://www.anthropic.com/engineering/claude-code-best-practices) | Official best practices from Anthropic |
| Skills Documentation | [code.claude.com/docs/en/skills](https://code.claude.com/docs/en/skills) | How to create and use skills |
| **Plugin Marketplace** | [claude.com/plugins](https://claude.com/plugins) | Browse and install official plugins |
| Plugin Documentation | [code.claude.com/docs/en/plugins](https://code.claude.com/docs/en/plugins) | How to create and use plugins |
| Official Plugin Directory | [github.com/anthropics/claude-plugins-official](https://github.com/anthropics/claude-plugins-official) | Anthropic-managed plugin repository |

### GitHub Copilot

| Resource | URL | Description |
|----------|-----|-------------|
| Official Docs | [docs.github.com/copilot](https://docs.github.com/copilot) | Complete Copilot documentation |
| VS Code Integration | [code.visualstudio.com/docs/copilot/overview](https://code.visualstudio.com/docs/copilot/overview) | VS Code specific features |
| Custom Instructions | [docs.github.com/copilot/customizing-copilot/adding-custom-instructions-for-github-copilot](https://docs.github.com/copilot/customizing-copilot/adding-custom-instructions-for-github-copilot) | How to customize Copilot |
| Prompt Tips | [github.blog/ai-and-ml/github-copilot/5-tips-for-writing-better-custom-instructions-for-copilot](https://github.blog/ai-and-ml/github-copilot/5-tips-for-writing-better-custom-instructions-for-copilot/) | Writing better prompts |
| Agent Mode | [github.blog/ai-and-ml/github-copilot/github-copilot-coding-agent-101-getting-started-with-agentic-workflows-on-github](https://github.blog/ai-and-ml/github-copilot/github-copilot-coding-agent-101-getting-started-with-agentic-workflows-on-github/) | Agentic workflows guide |

### Cursor

| Resource | URL | Description |
|----------|-----|-------------|
| Official Docs | [cursor.com/docs](https://cursor.com/docs) | Complete Cursor documentation |
| Rules Documentation | [cursor.com/docs/context/rules](https://cursor.com/docs/context/rules) | How to configure rules |

## Community Resources

### Awesome Lists

| Resource | URL | Description |
|----------|-----|-------------|
| Awesome Claude Code | [github.com/hesreallyhim/awesome-claude-code](https://github.com/hesreallyhim/awesome-claude-code) | Skills, hooks, commands, and tools |
| Everything Claude Code | [github.com/affaan-m/everything-claude-code](https://github.com/affaan-m/everything-claude-code) | Production-ready configs |
| Awesome Cursor Rules | [github.com/PatrickJS/awesome-cursorrules](https://github.com/PatrickJS/awesome-cursorrules) | Language/framework-specific rules |
| Cursor Best Practices | [github.com/digitalchild/cursor-best-practices](https://github.com/digitalchild/cursor-best-practices) | Comprehensive Cursor guide |
| Awesome Copilot | [github.com/github/awesome-copilot](https://github.com/github/awesome-copilot) | Community prompts and configs |
| Claude Code Best Practices | [github.com/awattar/claude-code-best-practices](https://github.com/awattar/claude-code-best-practices) | Examples and commands |

### Learning Resources

| Resource | URL | Description |
|----------|-----|-------------|
| Mastering Copilot Course | [github.com/microsoft/Mastering-GitHub-Copilot-for-Paired-Programming](https://github.com/microsoft/Mastering-GitHub-Copilot-for-Paired-Programming) | Multi-module learning course |
| Pair Programming with AI | [github.com/LinkedInLearning/pair-programming-with-ai-4401992](https://github.com/LinkedInLearning/pair-programming-with-ai-4401992) | LinkedIn Learning course repo |
| AI Coding Workflows | [graphite.com/guides/programming-with-ai-workflows-claude-copilot-cursor](https://graphite.com/guides/programming-with-ai-workflows-claude-copilot-cursor) | Comprehensive workflow guide |

### Guides & Articles

| Resource | URL | Description |
|----------|-----|-------------|
| Creating CLAUDE.md | [dometrain.com/blog/creating-the-perfect-claudemd-for-claude-code](https://dometrain.com/blog/creating-the-perfect-claudemd-for-claude-code/) | CLAUDE.md best practices |
| Claude Code Complete Guide | [siddharthbharath.com/claude-code-the-complete-guide](https://www.siddharthbharath.com/claude-code-the-complete-guide/) | Comprehensive usage guide |
| Claude Code Features | [blog.sshh.io/p/how-i-use-every-claude-code-feature](https://blog.sshh.io/p/how-i-use-every-claude-code-feature) | Feature deep-dive |
| Beyond Prompt Crafting | [github.blog/ai-and-ml/github-copilot/beyond-prompt-crafting-how-to-be-a-better-partner-for-your-ai-pair-programmer](https://github.blog/ai-and-ml/github-copilot/beyond-prompt-crafting-how-to-be-a-better-partner-for-your-ai-pair-programmer/) | Better AI collaboration |

## Claude Code Plugin Marketplace

### Official Plugins (Most Popular)

| Plugin | Installs | Description | Install Command |
|--------|----------|-------------|-----------------|
| **Frontend Design** | 141k+ | Production-grade frontend with distinctive design | `/plugin install frontend-design@claude-plugins-official` |
| **Code Review** | 68k+ | AI code review with specialized agents, confidence scoring | `/plugin install code-review@claude-plugins-official` |
| **Feature Dev** | 63k+ | Guided feature development with exploration & architecture | `/plugin install feature-dev@claude-plugins-official` |
| **Context7** | 93k+ | Upstash MCP server for live documentation lookup | `/plugin install context7@claude-plugins-official` |
| **GitHub** | 65k+ | Official GitHub MCP server for repository management | `/plugin install github@claude-plugins-official` |

### TDD & Quality Plugins

| Plugin | Description | Install Command |
|--------|-------------|-----------------|
| **Superpowers** | Full TDD methodology, debugging, brainstorming skills | `/plugin marketplace add obra/superpowers-marketplace` then `/plugin install superpowers` |
| **TDG (Test-Driven Generation)** | Red-Green-Refactor cycle with phase detection | `/plugin install tdg@claude-plugins-official` |
| **Code Simplifier** | Analyzes and simplifies complex code (part of code-review) | Included in code-review plugin |

### Third-Party Marketplaces

| Marketplace | Repository | Focus |
|-------------|------------|-------|
| Everything Claude Code | [affaan-m/everything-claude-code](https://github.com/affaan-m/everything-claude-code) | Hackathon-winning production configs |
| Superpowers | [obra/superpowers-marketplace](https://github.com/obra/superpowers-marketplace) | Development methodologies & TDD |
| Claude Code Templates | [aitmpl.com](https://www.aitmpl.com/plugins) | Template collection with UI |

> **See also:** [Claude Code Plugins Guide](../getting-started/claude-code-plugins.md) for detailed setup and usage.

## Tools & Extensions

### Claude Code Tools

| Tool | Description |
|------|-------------|
| [Claude Code Showcase](https://github.com/ChrisWiles/claude-code-showcase) | Comprehensive config examples |
| [Claude Code Hooks Mastery](https://github.com/disler/claude-code-hooks-mastery) | Hooks tutorial and examples |
| [Claude Squad](https://github.com/) | Multi-workspace agent management |
| [Claude Task Master](https://github.com/) | AI-driven task management |

### Cursor Tools

| Tool | Description |
|------|-------------|
| [cursor101.com](https://cursor101.com) | Cursor tips and rules |
| [dotcursorrules.com](https://dotcursorrules.com) | Cursor rules collection |

### Terminal & CLI

| Tool | URL | Description |
|------|-----|-------------|
| Aider | [github.com/Aider-AI/aider](https://github.com/Aider-AI/aider) | AI pair programming in terminal |

## Comparison Resources

| Resource | URL | Description |
|----------|-----|-------------|
| Copilot vs Claude Code | [learn.ryzlabs.com](https://learn.ryzlabs.com/ai-coding-assistants/github-copilot-vs-claude-code-which-ai-coding-assistant-is-right-for-you-in-2026) | Feature comparison |
| Best AI Coding Agents | [faros.ai/blog/best-ai-coding-agents-2026](https://www.faros.ai/blog/best-ai-coding-agents-2026) | Agent comparison |
| AI Assistants Comparison | [playcode.io/blog/best-ai-coding-assistants-2026](https://playcode.io/blog/best-ai-coding-assistants-2026) | Comprehensive comparison |
| Cursor vs Copilot | [digitalocean.com/resources/articles/github-copilot-vs-cursor](https://www.digitalocean.com/resources/articles/github-copilot-vs-cursor) | Deep-dive comparison |

## Security Resources

| Resource | Description |
|----------|-------------|
| OWASP Top 10 | Web application security risks |
| GitHub Security Best Practices | Secure coding with AI tools |
| Gitleaks | Git secret scanning |

## Configuration Examples

### Claude Code Examples

```
.claude/
├── settings.json           # Project settings
├── commands/               # Custom slash commands
│   ├── review.md
│   └── test.md
└── skills/                 # Domain skills
    └── SKILL.md
```

### Copilot Examples

```
.github/
├── copilot-instructions.md     # Global instructions
└── instructions/               # Path-specific
    ├── api.instructions.md
    └── tests.instructions.md
```

### Cursor Examples

```
.cursor/
└── rules/
    ├── general.mdc         # Always applied
    ├── typescript.mdc      # For *.ts files
    └── testing.mdc         # For *.test.ts
```

## Community Channels

| Platform | Description |
|----------|-------------|
| GitHub Discussions | Tool-specific discussions |
| Discord Servers | Community chat for each tool |
| Reddit r/ClaudeAI | Claude discussions |
| Reddit r/cursor | Cursor discussions |
| X/Twitter | Tool announcements and tips |

## Books & Courses

| Resource | Description |
|----------|-------------|
| Microsoft Copilot Course | [github.com/microsoft/Mastering-GitHub-Copilot-for-Paired-Programming](https://github.com/microsoft/Mastering-GitHub-Copilot-for-Paired-Programming) |
| LinkedIn Learning | Various AI coding courses |
| Pluralsight | AI-assisted development paths |

## Staying Updated

### Official Blogs

- [Anthropic Engineering Blog](https://www.anthropic.com/engineering)
- [GitHub Blog - AI/ML](https://github.blog/ai-and-ml/)
- [Cursor Blog](https://cursor.com/blog)

### Newsletters

- GitHub Changelog
- Anthropic Newsletter
- AI coding tool newsletters

---

## Contributing

Found a great resource? Add it by:
1. Creating a PR to this file
2. Including: Name, URL, brief description
3. Categorizing appropriately

---

*Last updated: February 2026*
