# AI Tools Onboarding Guide

A comprehensive guide for software engineering teams to efficiently use AI coding assistants including **Claude Code**, **GitHub Copilot**, and **Cursor**.

## Quick Start

| Tool | Setup Guide | Config File |
|------|-------------|-------------|
| Claude Code | [Setup Guide](docs/getting-started/claude-code-setup.md) | `CLAUDE.md` |
| GitHub Copilot | [Setup Guide](docs/getting-started/copilot-setup.md) | `.github/copilot-instructions.md` |
| Cursor | [Setup Guide](docs/getting-started/cursor-setup.md) | `.cursor/rules/*.mdc` |

## Repository Structure

```
ai-tools-onboarding/
├── README.md                          # This file
├── CLAUDE.md                          # Claude Code project instructions
├── .github/
│   └── copilot-instructions.md        # GitHub Copilot custom instructions
├── .cursor/
│   └── rules/
│       └── team-standards.mdc         # Cursor AI rules
│
├── docs/
│   ├── getting-started/               # Tool setup guides
│   ├── best-practices/                # Prompting, safety, workflows
│   ├── workflows/                     # Task-specific guides
│   └── reference/                     # Prompts library, troubleshooting
│
├── .claude/
│   ├── commands/                      # Custom slash commands
│   └── skills/                        # Domain-specific skills
│
├── examples/
│   └── prompts/                       # Real-world prompt examples
│
└── templates/                         # Templates for new projects
```

## Tool Selection Guide

Choose the right tool for the task:

| Task | Recommended Tool | Reason |
|------|------------------|--------|
| Quick inline completions | **Copilot** | Lowest friction, always-on autocomplete |
| Complex multi-file refactoring | **Claude Code** | Superior reasoning, terminal-native |
| Large codebase exploration | **Cursor** | Deep codebase indexing and awareness |
| Debugging complex issues | **Claude Code** or **Cursor** | Strong context + explanation |
| Code review | **Claude Code** | `/review-pr` skill, detailed analysis |
| Learning unfamiliar code | **Any** | All support conversational Q&A |
| Architecture planning | **Claude Code** | Plan mode, structured thinking |
| Rapid prototyping | **Cursor** | Composer mode, visual feedback |

## Documentation

### Getting Started
- [Claude Code Setup](docs/getting-started/claude-code-setup.md)
- [Claude Code Plugins](docs/getting-started/claude-code-plugins.md) - Official marketplace & popular plugins
- [GitHub Copilot Setup](docs/getting-started/copilot-setup.md)
- [Cursor Setup](docs/getting-started/cursor-setup.md)

### Best Practices
- [Prompting Guide](docs/best-practices/prompting-guide.md) - Write effective prompts
- [When to Use Which Tool](docs/best-practices/when-to-use-which-tool.md) - Tool selection strategies
- [Code Review with AI](docs/best-practices/code-review-with-ai.md)
- [Safety and Security](docs/best-practices/safety-and-security.md)

### Workflows
- [Feature Development](docs/workflows/feature-development.md)
- [Bug Fixing](docs/workflows/bug-fixing.md)
- [Code Review](docs/workflows/code-review.md)
- [Refactoring](docs/workflows/refactoring.md)

### Reference
- [Sample Prompts Library](docs/reference/sample-prompts.md)
- [Troubleshooting](docs/reference/troubleshooting.md)
- [Resources & References](docs/reference/resources.md)

## Popular Claude Code Plugins

Install these from the [official Anthropic plugin marketplace](https://claude.com/plugins):

| Plugin | Description | Install |
|--------|-------------|---------|
| **Frontend Design** (141k+) | Production-grade UI with distinctive design | `/plugin install frontend-design@claude-plugins-official` |
| **Code Review** (68k+) | Multi-agent PR review with confidence scoring | `/plugin install code-review@claude-plugins-official` |
| **Feature Dev** (63k+) | Guided feature development with exploration | `/plugin install feature-dev@claude-plugins-official` |
| **Superpowers** | TDD methodology, debugging, brainstorming | `/plugin marketplace add obra/superpowers-marketplace` |
| **TDG** | Test-Driven Generation (Red-Green-Refactor) | `/plugin install tdg@claude-plugins-official` |

See [Claude Code Plugins Guide](docs/getting-started/claude-code-plugins.md) for full details.

## Key Principles

1. **AI as a collaborator, not replacement** - Review all generated code critically
2. **Context is king** - Better context = better suggestions
3. **Use the right tool** - Each tool has strengths; leverage them
4. **Safety first** - Never commit secrets, always review security implications
5. **Iterate and learn** - Refine prompts based on results

## Configuration Templates

Copy these templates to your projects:

- [`templates/CLAUDE.md.template`](templates/CLAUDE.md.template) - Claude Code project config
- [`templates/copilot-instructions.template`](templates/copilot-instructions.template) - GitHub Copilot instructions
- [`templates/cursorrules.template`](templates/cursorrules.template) - Cursor rules

## Contributing

1. Share effective prompts in `examples/prompts/`
2. Document learnings in relevant guides
3. Update troubleshooting when you solve issues
4. Propose new custom commands or skills

## License

MIT License - See [LICENSE](LICENSE) for details.

---

**Maintained by**: Engineering Team
**Last Updated**: February 2026
