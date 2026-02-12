# AGENTS.md: The Universal Standard

## TL;DR

AGENTS.md is the emerging cross-tool standard for giving instructions to AI coding agents. It's plain markdown, supported by most major tools, and works hierarchically through your codebase.

```markdown
# AGENTS.md

This is a Next.js e-commerce application.

## Code Style
- Use TypeScript strict mode
- Prefer functional components

## Commands
- `npm run dev` - Start development
- `npm test` - Run tests
```

## Why AGENTS.md?

### The Problem

Every AI tool has its own config format:
- Claude Code: `CLAUDE.md`
- Cursor: `.cursorrules`, `.cursor/rules/*.mdc`
- Copilot: `.github/copilot-instructions.md`
- Others: Various proprietary formats

Teams using multiple tools end up duplicating instructions across formats.

### The Solution

AGENTS.md provides a single source of truth that most tools understand natively or can easily import.

## Adoption Status

| Tool | Native Support | Fallback |
|------|---------------|----------|
| OpenAI Codex | Yes (Primary) | Also reads AGENTS.override.md |
| Google Jules | Yes | - |
| Cursor | Yes | Also reads .cursor/rules/*.mdc |
| GitHub Copilot | Yes | Also reads .github/copilot-instructions.md |
| Aider | Yes | - |
| Factory AI | Yes | - |
| RooCode | Yes | - |
| Zed | Yes | - |
| **Claude Code** | **No** | Import via `@AGENTS.md` in CLAUDE.md |

**GitHub stats**: 20,000+ repositories already use AGENTS.md

**ThoughtWorks Technology Radar**: Rated "Trial" (November 2025)

## Format Specification

### Basic Structure

AGENTS.md is plain markdown. No special syntax required.

```markdown
# AGENTS.md

Project description and high-level context.

## Section 1
Instructions for this topic.

## Section 2
More instructions.

### Subsection
Detailed guidance.
```

### Hierarchy

AGENTS.md files work hierarchically:

```
project/
├── AGENTS.md           # Project-wide rules
├── src/
│   ├── AGENTS.md       # Rules for src/
│   └── api/
│       └── AGENTS.md   # Rules for src/api/
└── tests/
    └── AGENTS.md       # Rules for tests/
```

**Rule**: The nearest AGENTS.md file wins for its directory and subdirectories.

### Recommended Sections

```markdown
# AGENTS.md

## Overview
Brief project description (1-2 sentences).

## Tech Stack
- Language and version
- Framework
- Key libraries

## Architecture
Directory structure and purpose of each.

## Code Style
Conventions, naming patterns, formatting rules.

## Commands
How to build, test, lint, deploy.

## Patterns
Common patterns used in this codebase.

## Security
Security requirements and restrictions.

## Testing
Testing conventions and requirements.
```

## Using AGENTS.md with Claude Code

Claude Code doesn't natively read AGENTS.md, but you can bridge with a simple CLAUDE.md:

### Option 1: Import Reference

```markdown
# CLAUDE.md

Strictly follow @AGENTS.md for all project conventions and guidelines.
```

The `@` syntax tells Claude Code to read and follow that file.

### Option 2: Combined File

```markdown
# CLAUDE.md

Follow the conventions in @AGENTS.md.

## Claude-Specific Instructions

These instructions are specific to Claude Code workflows:

### Permissions
- Allowed: npm test, npm run lint
- Blocked: npm publish, git push --force

### Preferred Workflows
- Use /plan for features with multiple files
- Use /commit for all commits
```

## Example AGENTS.md

### Minimal Example

```markdown
# AGENTS.md

A React dashboard for analytics data.

## Stack
TypeScript, React 18, Vite, TanStack Query, Tailwind CSS

## Commands
- `npm run dev` - Start dev server
- `npm test` - Run tests
- `npm run build` - Production build

## Style
- Functional components only
- Use named exports
- CSS with Tailwind utilities
```

### Comprehensive Example

```markdown
# AGENTS.md

## Overview

E-commerce platform for digital products. Handles user accounts,
product listings, shopping cart, checkout, and order management.

## Tech Stack

- **Language**: TypeScript 5.x (strict mode)
- **Runtime**: Node.js 20+
- **Framework**: Next.js 14 (App Router)
- **Database**: PostgreSQL 15 with Prisma ORM
- **Auth**: NextAuth.js with JWT
- **Payments**: Stripe
- **Testing**: Jest, React Testing Library, Playwright

## Architecture

src/
├── app/           # Next.js App Router pages
├── components/    # React components
│   ├── ui/        # Generic UI components
│   └── features/  # Feature-specific components
├── lib/           # Shared utilities
│   ├── db/        # Database client and queries
│   ├── auth/      # Authentication utilities
│   └── api/       # API helpers
├── hooks/         # Custom React hooks
└── types/         # TypeScript type definitions

## Code Style

- **Components**: Functional with hooks, PascalCase names
- **Files**: kebab-case (user-profile.tsx)
- **Exports**: Named exports, no default exports
- **Imports**: Absolute from @/ (e.g., @/components/Button)
- **State**: TanStack Query for server, Zustand for client
- **Styling**: Tailwind CSS utility classes

## API Conventions

All API routes return consistent response format:

Success: { success: true, data: T }
Error: { success: false, error: { code: string, message: string } }

HTTP status codes:
- 200: Success
- 400: Validation error
- 401: Unauthorized
- 403: Forbidden
- 404: Not found
- 500: Server error

## Commands

- npm run dev - Start development (localhost:3000)
- npm test - Run unit tests
- npm run test:e2e - Run Playwright tests
- npm run lint - ESLint check
- npm run typecheck - TypeScript check
- npm run db:migrate - Run Prisma migrations
- npm run db:seed - Seed test data

## Security Requirements

- Validate ALL input with Zod schemas
- Use parameterized queries only (Prisma handles this)
- Never log sensitive data (passwords, tokens, PII)
- Auth required on all routes except /auth/* and /public/*
- Rate limit: 100 requests/minute per IP

## Testing Requirements

- Unit tests for all utility functions
- Component tests for user interactions
- E2E tests for critical paths (checkout, auth)
- Minimum 80% coverage for new code
```

## Cross-Tool Workflow

### Step 1: Create AGENTS.md

Write your universal instructions once.

### Step 2: Tool-Specific Files (Optional)

**For Claude Code** (`CLAUDE.md`):
```markdown
Follow @AGENTS.md for all conventions.

## Claude-Specific
- Use /plan for multi-file changes
- Run tests after implementation
```

**For Cursor** (`.cursor/rules/agents.mdc`):
```markdown
---
description: Load AGENTS.md conventions
alwaysApply: true
---

Follow the conventions defined in @AGENTS.md.
```

**For Copilot** (`.github/copilot-instructions.md`):
```markdown
Follow the project conventions in AGENTS.md.

Additional Copilot guidance:
- Prefer inline suggestions for small changes
- Use Chat for explanations
```

### Step 3: Keep AGENTS.md as Source of Truth

When patterns change:
1. Update AGENTS.md
2. Tool-specific files inherit automatically (via @import)

## Best Practices

### 1. Start with AGENTS.md

Even if you only use one tool, AGENTS.md is future-proof.

### 2. Keep It Focused

Include only what AI needs to know:
- Project context and structure
- Code conventions
- Common patterns
- Build/test commands

Don't include:
- Human onboarding details
- Historical context
- Meeting notes

### 3. Use Hierarchy for Large Projects

```
monorepo/
├── AGENTS.md              # Shared conventions
├── packages/
│   ├── web/
│   │   └── AGENTS.md      # Web-specific
│   ├── api/
│   │   └── AGENTS.md      # API-specific
│   └── shared/
│       └── AGENTS.md      # Shared library rules
```

### 4. Review Like Code

AGENTS.md changes affect AI behavior. Review changes carefully:
- Does this improve AI output quality?
- Is it specific enough to be actionable?
- Does it conflict with other instructions?

## Resources

- **Official Site**: [agents.md](https://agents.md/)
- **GitHub**: [github.com/agentsmd/agents.md](https://github.com/agentsmd/agents.md)
- **ThoughtWorks Radar**: [thoughtworks.com/radar/techniques/agents-md](https://www.thoughtworks.com/radar/techniques/agents-md)
- **Builder.io Guide**: [builder.io/blog/agents-md](https://www.builder.io/blog/agents-md)
- **Factory.ai Docs**: [docs.factory.ai/cli/configuration/agents-md](https://docs.factory.ai/cli/configuration/agents-md)
- **OpenAI Codex Guide**: [developers.openai.com/codex/guides/agents-md/](https://developers.openai.com/codex/guides/agents-md/)
- **InfoQ Coverage**: [infoq.com/news/2025/08/agents-md/](https://www.infoq.com/news/2025/08/agents-md/)

---

Next: [Claude Code Memory](claude-code-memory.md) | [Cross-Tool Strategy](cross-tool-strategy.md)
