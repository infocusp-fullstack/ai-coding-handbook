# AI Coding Handbook

A comprehensive guide for software engineering teams to effectively use AI coding assistants including **Claude Code**, **GitHub Copilot**, **Cursor**, and other emerging tools.

## Quick Start

| Tool | Best For | Setup |
|------|----------|-------|
| **Claude Code** | Terminal workflows, multi-file changes, complex reasoning | [Setup Guide](01-getting-started/claude-code-setup.md) |
| **GitHub Copilot** | IDE integration, quick autocomplete, inline suggestions | [Setup Guide](01-getting-started/copilot-setup.md) |
| **Cursor** | Full IDE experience, codebase-aware, visual workflows | [Setup Guide](01-getting-started/cursor-setup.md) |

**Not sure which to use?** See [Choosing Your Tool](01-getting-started/choosing-your-tool.md)

## Contents

### 1. Getting Started
- [Choosing Your Tool](01-getting-started/choosing-your-tool.md) - Decision framework
- [Claude Code Setup](01-getting-started/claude-code-setup.md)
- [Cursor Setup](01-getting-started/cursor-setup.md)
- [GitHub Copilot Setup](01-getting-started/copilot-setup.md)
- [Other Tools](01-getting-started/other-tools.md) - Windsurf, Codex CLI, Aider

### 2. Rules & Memory
- [Overview](02-rules-and-memory/overview.md) - Why rules matter
- [AGENTS.md Standard](02-rules-and-memory/agents-md-standard.md) - Universal AI config
- [Claude Code Memory](02-rules-and-memory/claude-code-memory.md) - CLAUDE.md deep dive
- [Cursor Rules](02-rules-and-memory/cursor-rules.md) - .mdc configuration
- [Copilot Instructions](02-rules-and-memory/copilot-instructions.md)
- [Cross-Tool Strategy](02-rules-and-memory/cross-tool-strategy.md)

### 3. MCP Servers
- [What is MCP?](03-mcp-servers/what-is-mcp.md) - Model Context Protocol
- [Setup Guide](03-mcp-servers/setup-guide.md) - Configuration
- [Popular Servers](03-mcp-servers/popular-servers.md) - GitHub, Slack, databases

### 4. Prompting
- [Prompting Principles](04-prompting/prompting-principles.md)
- [Prompt Patterns](04-prompting/prompt-patterns.md) - Research-Plan-Implement
- [Examples](04-prompting/examples/) - Good vs bad, real-world prompts

### 5. Custom Commands & Skills
- [Overview](05-custom-commands-and-skills/overview.md)
- [Claude Code Skills](05-custom-commands-and-skills/claude-code-skills.md)
- [Claude Code Plugins](05-custom-commands-and-skills/claude-code-plugins.md)
- [Cursor Customization](05-custom-commands-and-skills/cursor-custom.md)
- [Examples](05-custom-commands-and-skills/examples/) - Jira workflow, PR creation

### 6. Browser Use
- [Overview](06-browser-use/overview.md) - When AI uses the browser
- [Cursor Browser](06-browser-use/cursor-browser.md)
- [Claude Code Browser](06-browser-use/claude-code-browser.md)
- [Playwright MCP](06-browser-use/playwright-mcp.md)

### 7. Context Management
- [Understanding Context](07-context-management/understanding-context.md)
- [Managing Context](07-context-management/managing-context.md) - /clear, /compact
- [Rules File Sizing](07-context-management/rules-file-sizing.md)
- [Subagent Patterns](07-context-management/subagent-patterns.md)

### 8. Workflow Tips
- [Research-Plan-Implement](08-workflow-tips/research-plan-implement.md)
- [Plan Mode](08-workflow-tips/plan-mode.md)
- [Multi-Agent Patterns](08-workflow-tips/multi-agent.md)
- [Testing with AI](08-workflow-tips/testing-with-ai.md)
- [Permissions & Settings](08-workflow-tips/permissions-and-settings.md)
- [Debugging Tips](08-workflow-tips/debugging-tips.md)

### 9. Philosophy
- [The Big Shift](09-philosophy/the-big-shift.md) - Deterministic to non-deterministic
- [Review Your Code](09-philosophy/review-your-code.md)
- [Learning, Not Outsourcing](09-philosophy/learning-not-outsourcing.md)
- [Team Adoption](09-philosophy/team-adoption.md)

### Resources
- [Glossary](resources/glossary.md) - AI coding terminology
- [Official Links](resources/official-links.md) - Documentation, downloads
- [Community](resources/community.md) - Forums, Discord, learning

## Repository Structure

```
ai-coding-handbook/
├── 01-getting-started/       # Tool setup and selection
├── 02-rules-and-memory/      # Configuration files
├── 03-mcp-servers/           # External integrations
├── 04-prompting/             # Effective prompting
├── 05-custom-commands-and-skills/  # Extending tools
├── 06-browser-use/           # Browser automation
├── 07-context-management/    # Context optimization
├── 08-workflow-tips/         # Development workflows
├── 09-philosophy/            # Mindset and approach
├── resources/                # Links and glossary
├── .claude/                  # Claude Code config (commands, skills)
├── .cursor/                  # Cursor rules
└── .github/                  # Copilot instructions
```

## Key Principles

1. **AI as collaborator** - Review all generated code critically
2. **Context is king** - Better context = better results
3. **Use the right tool** - Each tool has strengths
4. **Safety first** - Never commit secrets, always review security
5. **Learn, don't outsource** - Understand what AI generates

## Popular Plugins

Install these essential Claude Code plugins:

```bash
# Frontend design (160k+ installs)
/plugin install frontend-design@claude-plugins-official

# Context7 for live documentation (104k+ installs)
/plugin install context7@claude-plugins-official

# Code review (79k+ installs)
/plugin install code-review@claude-plugins-official
```

See [Claude Code Plugins](05-custom-commands-and-skills/claude-code-plugins.md) for full details.

## Contributing

1. Share effective prompts and configurations
2. Document learnings and workflows
3. Update guides with new tool features
4. Report issues and improvements

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

MIT License - See [LICENSE](LICENSE) for details.

---

**Last Updated**: February 2026
