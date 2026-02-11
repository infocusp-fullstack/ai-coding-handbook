# Rules and Memory: Overview

## TL;DR

Rules files tell AI coding assistants how to work with your codebase. Think of them as "README for AI agents."

- **Claude Code**: `CLAUDE.md` files
- **Cursor**: `.cursor/rules/*.mdc` files
- **Copilot**: `.github/copilot-instructions.md`
- **Universal**: `AGENTS.md` (emerging standard)

## Why Rules Matter

Without rules, AI assistants:
- Don't know your coding standards
- Miss project-specific patterns
- Generate inconsistent code
- Require repeated explanations

With good rules, AI assistants:
- Follow your team's conventions
- Match existing patterns automatically
- Generate consistent, reviewable code
- Work more autonomously

## The Mental Model

Think of rules as onboarding documentation for an AI team member:

```
┌─────────────────────────────────────────────────────┐
│                 Your Codebase                        │
├─────────────────────────────────────────────────────┤
│                                                      │
│   ┌─────────────┐     ┌─────────────────────────┐   │
│   │  Rules File │ ──▶ │    AI Assistant         │   │
│   │             │     │                         │   │
│   │ - Standards │     │ • Knows your patterns   │   │
│   │ - Patterns  │     │ • Follows conventions   │   │
│   │ - Context   │     │ • Generates consistent  │   │
│   │ - Commands  │     │   code                  │   │
│   └─────────────┘     └─────────────────────────┘   │
│                                                      │
└─────────────────────────────────────────────────────┘
```

## What to Include in Rules

### Essential (Start Here)

```markdown
# Project Overview
Brief description of what this project does.

# Tech Stack
- Language: TypeScript
- Framework: Next.js 14 (App Router)
- Database: PostgreSQL with Prisma
- Testing: Jest + React Testing Library

# Key Commands
- npm run dev - Start development server
- npm test - Run tests
- npm run lint - Check code style
```

### Intermediate (Add as Needed)

```markdown
# Code Conventions
- Use functional components with hooks
- Prefer named exports over default exports
- Use absolute imports (@/components, @/utils)

# Architecture
- src/app/ - Next.js app router pages
- src/components/ - React components
- src/lib/ - Shared utilities
- src/api/ - API routes and handlers

# Patterns
- Use React Query for server state
- Use Zustand for client state
- All API responses follow format: { success, data?, error? }
```

### Advanced (For Complex Projects)

```markdown
# Domain Context
This is an e-commerce platform. Key concepts:
- Products have variants (size, color)
- Orders go through states: pending → paid → shipped → delivered
- Users can be customers, admins, or vendors

# Security Requirements
- All endpoints require authentication except /public/*
- Validate all input with Zod schemas
- Never log sensitive data (passwords, tokens, PII)

# Performance Guidelines
- Pages must load in < 3 seconds
- Use incremental static regeneration for product pages
- Implement pagination for all list endpoints (max 100 items)
```

## Tool-Specific Locations

### Claude Code

```
project/
├── CLAUDE.md              # Main project rules (committed)
├── CLAUDE.local.md        # Personal rules (gitignored)
└── .claude/
    ├── rules/             # Organized rule files
    │   ├── typescript.md
    │   └── testing.md
    └── settings.json      # Permissions
```

**Hierarchy** (all are loaded):
1. `~/.claude/CLAUDE.md` - User-level (all projects)
2. `./CLAUDE.md` - Project-level
3. `./CLAUDE.local.md` - Local overrides
4. `./.claude/rules/*.md` - Organized rules
5. `./subdir/CLAUDE.md` - Module-level (loaded on-demand)

### Cursor

```
project/
├── .cursorrules           # Legacy (still works)
└── .cursor/
    └── rules/
        ├── general.mdc    # Always applied (alwaysApply: true)
        ├── typescript.mdc # For *.ts files (glob-based)
        └── testing.mdc    # For *.test.ts files
```

**Rule file format** (YAML frontmatter):
```markdown
---
description: TypeScript coding standards
globs: ["**/*.ts", "**/*.tsx"]
alwaysApply: false
---

# Your rules in markdown
```

### GitHub Copilot

```
project/
└── .github/
    ├── copilot-instructions.md    # Global instructions
    └── instructions/              # Path-specific (optional)
        ├── api.instructions.md    # For src/api/**
        └── tests.instructions.md  # For **/*.test.ts
```

## Best Practices

### 1. Keep Rules Concise

AI context windows are limited. Rules compete with your code for context space.

**Bad**: 500+ lines of verbose documentation
**Good**: < 150 lines of essential information

### 2. Be Specific and Actionable

**Bad**: "Write clean code"
**Good**: "Use camelCase for variables, PascalCase for components"

### 3. Include Examples

**Bad**: "Follow our error handling pattern"
**Good**:
```markdown
## Error Handling
Use ApiError class:
```typescript
throw new ApiError(400, 'Validation failed', { field: 'email' });
```

### 4. Evolve Over Time

Start minimal, add rules when you notice:
- AI keeps making the same mistakes
- You repeat the same instructions
- New team members need to learn patterns

### 5. Version Control Your Rules

- Commit team rules (CLAUDE.md, .cursor/rules/)
- Gitignore personal rules (CLAUDE.local.md)
- Review rule changes like code changes

## Cross-Tool Strategy

If your team uses multiple tools, consider:

1. **AGENTS.md as source of truth** - See [AGENTS.md Standard](agents-md-standard.md)
2. **Tool-specific files import from AGENTS.md**
3. **Keep tool-specific instructions separate**

Example structure:
```
project/
├── AGENTS.md              # Universal rules
├── CLAUDE.md              # "Follow @AGENTS.md" + Claude-specific
├── .github/
│   └── copilot-instructions.md  # Copilot-specific
└── .cursor/
    └── rules/
        └── general.mdc    # Cursor-specific
```

---

Next: [AGENTS.md Standard](agents-md-standard.md) | [Claude Code Memory](claude-code-memory.md) | [Cursor Rules](cursor-rules.md)
