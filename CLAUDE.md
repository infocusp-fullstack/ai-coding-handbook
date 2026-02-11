# CLAUDE.md - Project Instructions for Claude Code

This file provides context and instructions to Claude Code when working in this repository.

## Project Overview

This is the **AI Coding Handbook** - a comprehensive guide for software engineering teams to effectively use AI coding assistants (Claude Code, GitHub Copilot, Cursor, and other tools).

## Repository Structure

```
ai-coding-handbook/
├── 01-getting-started/       # Tool setup and selection guides
├── 02-rules-and-memory/      # Configuration files (CLAUDE.md, .cursorrules, etc.)
├── 03-mcp-servers/           # Model Context Protocol setup
├── 04-prompting/             # Effective prompting techniques
├── 05-custom-commands-and-skills/  # Extending AI tools
├── 06-browser-use/           # Browser automation
├── 07-context-management/    # Context window optimization
├── 08-workflow-tips/         # Development workflows
├── 09-philosophy/            # AI coding mindset
├── resources/                # Glossary, links, community
├── .claude/                  # Claude Code config (commands, skills)
├── .cursor/                  # Cursor rules
└── .github/                  # Copilot instructions
```

## Writing Guidelines

When editing documentation in this repository:

1. **Be practical** - Include real, usable examples
2. **Be concise** - Developers scan, don't read walls of text
3. **Start with TL;DR** - Every guide should have a quick start section
4. **Use tables** - For comparisons and quick reference
5. **Include code blocks** - Show actual commands and prompts
6. **Link to sources** - Credit external resources with URLs

## File Naming Conventions

- Use kebab-case for file names: `feature-development.md`
- Markdown files use `.md` extension
- Cursor rules use `.mdc` extension
- Skills use `SKILL.md` naming
- Examples go in `examples/` subdirectories

## Content Standards

### Documentation Structure
- Title with `#`
- TL;DR section at top
- Sections with `##`
- Subsections with `###`
- Code examples in fenced blocks with language hints

### Code Examples
- Always specify language: ```typescript, ```bash, etc.
- Include comments explaining non-obvious parts
- Show both good and bad examples where helpful
- Keep examples minimal but complete

### Navigation
- Each file should end with `Next: [Link]` navigation
- Use relative links: `[Link](../section/file.md)`
- Keep link text short and descriptive

## Common Commands

```bash
# Preview markdown locally
npx serve .

# Check for broken links
npx markdown-link-check **/*.md

# List all markdown files
find . -name "*.md" -type f | head -20
```

## Key Topics Covered

- **Tool comparison**: Claude Code vs Copilot vs Cursor
- **Configuration**: AGENTS.md, CLAUDE.md, .cursorrules
- **MCP servers**: GitHub, Slack, databases
- **Prompting**: Research-Plan-Implement pattern
- **Context management**: /compact, /clear, subagents
- **Philosophy**: Martin Fowler's "big shift" perspective

## External References

When citing sources:
- Official documentation preferred
- Include date accessed for rapidly changing content
- Use footnote-style links for cleaner reading

## Do Not

- Add time estimates to documentation
- Include company-specific or sensitive information
- Create overly long single documents (split if > 500 lines)
- Use emojis unless specifically requested
