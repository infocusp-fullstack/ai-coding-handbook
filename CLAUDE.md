# CLAUDE.md - Project Instructions for Claude Code

This file provides context and instructions to Claude Code when working in this repository.

## Project Overview

This is an AI Tools Onboarding repository containing documentation, guides, and configuration templates for using AI coding assistants (Claude Code, GitHub Copilot, Cursor) effectively.

## Repository Structure

- `docs/` - Documentation organized by category (getting-started, best-practices, workflows, reference)
- `.claude/commands/` - Custom slash commands for Claude Code
- `.claude/skills/` - Domain-specific skills
- `templates/` - Configuration templates for new projects
- `examples/prompts/` - Sample prompts organized by use case

## Writing Guidelines

When editing documentation in this repository:

1. **Be practical** - Include real, usable examples
2. **Be concise** - Developers scan, don't read walls of text
3. **Use tables** - For comparisons and quick reference
4. **Include code blocks** - Show actual commands and prompts
5. **Link to sources** - Credit external resources

## File Naming Conventions

- Use kebab-case for file names: `feature-development.md`
- Markdown files use `.md` extension
- Cursor rules use `.mdc` extension
- Skills use `SKILL.md` naming

## Common Commands

```bash
# Preview markdown locally
npx serve docs

# Check for broken links
npx markdown-link-check docs/**/*.md
```

## Content Standards

- All guides should include a "Quick Start" or "TL;DR" section at the top
- Include the source/reference URL when content is adapted from external resources
- Use consistent heading hierarchy (# for title, ## for sections, ### for subsections)
- Keep line length reasonable for readability in terminals
