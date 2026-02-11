# Claude Code Memory System

## TL;DR

Claude Code uses a hierarchy of memory files to understand your projects:

```
~/.claude/CLAUDE.md           → User-level (all projects)
./CLAUDE.md                   → Project-level (committed, shared)
./CLAUDE.local.md             → Local project (gitignored, personal)
./.claude/rules/*.md          → Organized rule files
./subdir/CLAUDE.md            → Module-level (loaded on-demand)
```

## Memory Hierarchy

### 1. User-Level (~/.claude/CLAUDE.md)

Applies to ALL projects on your machine.

**Good for:**
- Personal coding preferences
- Global shortcuts and aliases
- Tools you always want available

```markdown
# ~/.claude/CLAUDE.md

## My Preferences
- Use TypeScript when possible
- Prefer functional programming patterns
- Always run tests before committing

## Common Aliases
- "tc" means TypeScript config
- "rq" means React Query
```

### 2. Project-Level (./CLAUDE.md)

The main project memory file. Committed to version control and shared with the team.

**Good for:**
- Project overview and architecture
- Team coding standards
- Build and test commands
- Domain-specific context

```markdown
# CLAUDE.md

## Project Overview
Analytics dashboard built with Next.js and TypeScript.

## Architecture
- src/app/ - Next.js app router pages
- src/components/ - React components
- src/lib/ - Shared utilities

## Commands
- npm run dev - Start development
- npm test - Run tests
- npm run lint - Check code style

## Conventions
- Use functional components
- Follow existing patterns in codebase
```

### 3. Local Project (./CLAUDE.local.md)

Personal overrides that aren't committed. Add to `.gitignore`.

**Good for:**
- Personal working notes
- Environment-specific paths
- Experiments and temporary rules

```markdown
# CLAUDE.local.md (gitignored)

## My Notes
Currently working on user authentication refactor.
Focus area: src/lib/auth/

## Local Environment
Database is running on port 5433 (not default 5432)
```

### 4. Organized Rules (./.claude/rules/*.md)

Split rules into focused files for larger projects.

```
.claude/
└── rules/
    ├── api-conventions.md
    ├── testing-standards.md
    └── security-requirements.md
```

Each file is automatically loaded. Example `api-conventions.md`:

```markdown
# API Conventions

## Response Format
All API endpoints return:
```json
{ "success": boolean, "data"?: T, "error"?: { "code": string, "message": string } }
```

## HTTP Status Codes
- 200: Success
- 400: Validation error
- 401: Unauthorized
- 404: Not found
- 500: Server error
```

### 5. Module-Level (./subdir/CLAUDE.md)

Loaded on-demand when Claude works in that directory.

**Good for:**
- Microservice-specific rules in monorepos
- Feature-specific context
- Package-specific conventions

```
monorepo/
├── CLAUDE.md                  # Shared rules
├── packages/
│   ├── web/
│   │   └── CLAUDE.md          # Web app rules
│   ├── api/
│   │   └── CLAUDE.md          # API rules
│   └── shared/
│       └── CLAUDE.md          # Shared library rules
```

## Auto-Memory (Claude's Memory for Itself)

Claude Code can also maintain memory about your sessions.

**Location**: `~/.claude/projects/*/memory/`

**What it stores:**
- Patterns Claude discovered about your codebase
- Corrections you've made
- Preferences Claude learned

**Commands:**
- `/memory` - View and manage memory files
- `/memory clear` - Clear session memory

**Opt-in setting** (may require):
```bash
export CLAUDE_CODE_DISABLE_AUTO_MEMORY=0
```

## /init Command

Bootstrap a CLAUDE.md for new projects:

```bash
claude
> /init
```

Claude analyzes your project and generates an initial CLAUDE.md with:
- Detected tech stack
- Project structure
- Common commands (from package.json, Makefile, etc.)

## Best Practices

### 1. Keep CLAUDE.md Minimal

Only include what Claude needs EVERY session:
- Project overview (1-2 sentences)
- Key commands
- Essential conventions

**Recommended**: < 150 lines

### 2. Reference External Docs

Don't copy documentation into CLAUDE.md. Reference it:

```markdown
## Documentation
For API details, see @docs/api-reference.md
For architecture decisions, see @docs/adr/
```

Claude loads referenced files on-demand.

### 3. Use Rules Files for Complex Projects

Split by concern:
```
.claude/rules/
├── coding-standards.md
├── api-patterns.md
├── testing-requirements.md
└── security-policies.md
```

### 4. Layer Your Memory

```
User-level (~/.claude/CLAUDE.md)
    └── Personal preferences (applies everywhere)

Project-level (./CLAUDE.md)
    └── Team standards (committed, shared)

Local (./CLAUDE.local.md)
    └── Personal notes (gitignored)

Module-level (./subdir/CLAUDE.md)
    └── Context for specific areas
```

### 5. Update Incrementally

When Claude makes mistakes:
1. Correct Claude in the conversation
2. If it's recurring, add to CLAUDE.md
3. Review CLAUDE.md periodically to remove stale rules

## Import and Reference Syntax

### @file Reference

Reference files to include their content:

```markdown
# CLAUDE.md

Follow the conventions in @AGENTS.md.
See @docs/architecture.md for system design.
```

### Maximum Import Depth

Files can import other files up to 5 levels deep.

```markdown
# CLAUDE.md references
@rules/api.md
    # which references
    @rules/shared/validation.md
        # which references
        @rules/shared/types.md
            # etc. up to 5 levels
```

## Permissions Configuration

Settings file: `.claude/settings.json` or `~/.claude/settings.json`

```json
{
  "permissions": {
    "allow": [
      "Bash(npm run lint)",
      "Bash(npm test)",
      "Bash(git diff)",
      "Bash(git status)",
      "Read",
      "Grep",
      "Glob"
    ],
    "deny": [
      "Bash(rm -rf *)",
      "Bash(git push --force)",
      "Bash(npm publish)"
    ]
  }
}
```

## Common Patterns

### Monorepo Setup

```markdown
# Root CLAUDE.md

This is a monorepo with packages for web, api, and shared.

## Structure
- packages/web/ - Next.js frontend (@web/CLAUDE.md)
- packages/api/ - Express backend (@api/CLAUDE.md)
- packages/shared/ - Shared types and utilities

## Commands (from root)
- npm run dev - Start all services
- npm test - Run all tests
- npm run build - Build all packages
```

### Team Standards

```markdown
# CLAUDE.md

## Code Review Standards
All changes must:
- Have tests for new functionality
- Pass linting (npm run lint)
- Follow patterns in existing code

## PR Guidelines
Use conventional commits: feat, fix, docs, refactor, test
Include description of what and why
```

### Feature Flags

```markdown
# CLAUDE.md

## Feature Flags
We use LaunchDarkly for feature flags.

Flags in use:
- new-checkout-flow: New payment UI (50% rollout)
- ai-recommendations: Product recommendations (beta)

Check flags with: isFeatureEnabled('flag-name')
```

## Troubleshooting

### "Claude doesn't know my project"

1. Check CLAUDE.md exists in project root
2. Run `/init` to generate one
3. Add more context about architecture

### "Claude forgets previous instructions"

1. Add important rules to CLAUDE.md (persists across sessions)
2. Use `/compact` to summarize without losing key context
3. Reference files instead of explaining inline

### "Rules aren't being applied"

1. Verify file location (project root for CLAUDE.md)
2. Check for syntax errors in markdown
3. Ensure rules are specific and actionable

## Resources

- **Official Docs**: [code.claude.com/docs/en/memory](https://code.claude.com/docs/en/memory)
- **Best Practices**: [dometrain.com/blog/creating-the-perfect-claudemd-for-claude-code](https://dometrain.com/blog/creating-the-perfect-claudemd-for-claude-code/)
- **Memory Deep Dive**: [cuong.io/blog/2025/06/15-claude-code-best-practices-memory-management](https://cuong.io/blog/2025/06/15-claude-code-best-practices-memory-management)

---

Next: [Cursor Rules](cursor-rules.md) | [Cross-Tool Strategy](cross-tool-strategy.md)
