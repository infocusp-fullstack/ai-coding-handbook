# Claude Code Setup Guide

## TL;DR

```bash
# Install
npm install -g @anthropic-ai/claude-code

# Authenticate
claude login

# Start using
cd your-project
claude
```

## What is Claude Code?

Claude Code is Anthropic's official CLI tool for agentic coding. It lives in your terminal and can:

- Read and understand your entire codebase
- Make multi-file edits
- Run commands and tests
- Work autonomously on complex tasks

## Installation

### Prerequisites

- Node.js 18+ installed
- A Claude Pro, Team, or API account

### Install via npm

```bash
npm install -g @anthropic-ai/claude-code
```

### Authenticate

```bash
claude login
```

This opens a browser window to authenticate with your Anthropic account.

## First Steps

### 1. Navigate to Your Project

```bash
cd /path/to/your/project
```

### 2. Start Claude Code

```bash
claude
```

### 3. Try Exploratory Commands

```
> What design patterns are used in this codebase?
> How is authentication handled end-to-end?
> Explain how database migrations are managed
> What testing patterns are followed here?
> Trace how a request flows from API to database
```

## Key Concepts

### CLAUDE.md File

Create a `CLAUDE.md` file in your project root to give Claude context:

```markdown
# CLAUDE.md

## Project Overview
This is a [type] application built with [technologies].

## Architecture
- `src/` - Source code
- `tests/` - Test files
- `docs/` - Documentation

## Commands
- `npm run dev` - Start development server
- `npm test` - Run tests
- `npm run build` - Build for production

## Conventions
- Use TypeScript for all new code
- Follow ESLint configuration
- Write tests for new features
```

### Slash Commands

Built-in commands for common tasks:

| Command | Description |
|---------|-------------|
| `/help` | Show available commands |
| `/clear` | Clear conversation history |
| `/compact` | Summarize and compact context |
| `/commit` | Create a git commit |
| `/review-pr` | Review a pull request |

### Custom Commands

Create custom commands in `.claude/commands/`:

```
.claude/
└── commands/
    └── review.md
```

### Skills

Add domain-specific knowledge in `.claude/skills/`:

```
.claude/
└── skills/
    └── SKILL.md
```

## Best Practices

### 1. Use Plan Mode for Complex Tasks

For non-trivial changes, Claude can plan before implementing:

```
> /plan Add user authentication with JWT
```

### 2. Work in Git Branches

Always have Claude work in a new branch:

```
> Create a new branch called feature/user-auth and implement login
```

### 3. Provide Context

The more context you give, the better the results:

```
> Looking at src/api/users.ts, add input validation
> following the pattern in src/api/posts.ts
```

### 4. Use Parallel Sessions (Git Worktrees)

For maximum productivity, run multiple Claude sessions:

```bash
# Create worktrees
git worktree add ../project-feature-a feature-a
git worktree add ../project-feature-b feature-b

# Run Claude in each
cd ../project-feature-a && claude
cd ../project-feature-b && claude
```

## Configuration

### Settings File

Configure Claude Code in `~/.claude/settings.json`:

```json
{
  "theme": "dark",
  "autoCommit": false,
  "defaultModel": "claude-sonnet-4"
}
```

### Project Settings

Project-specific settings in `.claude/settings.json`:

```json
{
  "allowedCommands": ["npm test", "npm run lint"],
  "excludePatterns": ["node_modules", "dist", ".env"]
}
```

## Troubleshooting

### "Claude doesn't understand my project"

- Add or improve your `CLAUDE.md` file
- Use `/compact` to reset context if it seems confused
- Be more specific in your prompts

### "Changes aren't what I expected"

- Use plan mode first: `/plan [task]`
- Review the plan before approving
- Work in smaller increments

### "Command was blocked"

- Check `.claude/settings.json` for `allowedCommands`
- Some destructive commands require explicit approval

## Plugins

Extend Claude Code with official plugins from the [Anthropic Plugin Marketplace](https://claude.com/plugins):

```bash
# Browse available plugins
/plugin > Discover

# Install popular plugins
/plugin install frontend-design@claude-plugins-official
/plugin install code-review@claude-plugins-official
/plugin install feature-dev@claude-plugins-official
```

**Popular plugins:**
- **Frontend Design** (141k+) - Production-grade UI development
- **Code Review** (68k+) - Multi-agent PR review
- **Feature Dev** (63k+) - Guided feature development
- **Superpowers** - TDD methodology and debugging skills

See the full [Claude Code Plugins Guide](../05-custom-commands-and-skills/claude-code-plugins.md) for detailed installation and usage.

## Resources

- [Official Documentation](https://docs.anthropic.com/claude-code)
- [Best Practices](https://www.anthropic.com/engineering/claude-code-best-practices)
- [Plugin Marketplace](https://claude.com/plugins)
- [Official Plugin Directory](https://github.com/anthropics/claude-plugins-official)
- [Awesome Claude Code](https://github.com/hesreallyhim/awesome-claude-code)

---

Next: [Cursor Setup](cursor-setup.md) | [Copilot Setup](copilot-setup.md)
