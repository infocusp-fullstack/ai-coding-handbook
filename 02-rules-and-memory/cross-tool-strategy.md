# Cross-Tool Strategy

## TL;DR

If your team uses multiple AI tools, use AGENTS.md as a single source of truth:

```
project/
├── AGENTS.md                    # Universal rules (source of truth)
├── CLAUDE.md                    # "Follow @AGENTS.md" + Claude-specific
├── .github/
│   └── copilot-instructions.md  # Points to AGENTS.md + Copilot-specific
└── .cursor/
    └── rules/
        └── general.mdc          # Points to AGENTS.md + Cursor-specific
```

## The Problem

Teams using multiple tools end up with:
- Duplicated instructions across formats
- Inconsistent AI behavior between tools
- Maintenance burden keeping files in sync

## The Solution: Single Source of Truth

### Step 1: Create AGENTS.md

Write your universal conventions once:

```markdown
# AGENTS.md

## Project Overview
E-commerce platform with Next.js frontend and Express API.

## Tech Stack
- TypeScript (strict mode)
- Next.js 14 (App Router)
- Express.js API
- PostgreSQL with Prisma
- Jest for testing

## Code Conventions
- Functional components only
- Named exports (no default)
- Absolute imports from @/
- camelCase variables, PascalCase components

## Commands
- npm run dev - Development
- npm test - Run tests
- npm run lint - Check style

## API Response Format
{
  "success": boolean,
  "data"?: T,
  "error"?: { "code": string, "message": string }
}
```

### Step 2: Configure Each Tool to Reference AGENTS.md

#### Claude Code

`CLAUDE.md`:
```markdown
# CLAUDE.md

Strictly follow @AGENTS.md for all project conventions.

## Claude-Specific Instructions

### Workflows
- Use /plan for features touching multiple files
- Use /commit for all commits
- Run tests after implementation

### Permissions
Allow: npm test, npm run lint, git diff, git status
Block: npm publish, git push --force
```

#### Cursor

`.cursor/rules/general.mdc`:
```markdown
---
description: Project conventions from AGENTS.md
alwaysApply: true
---

Follow all conventions defined in @AGENTS.md.

## Cursor-Specific

### Composer Usage
- Use Composer for multi-file changes
- Review all proposed changes before accepting
- Accept/reject changes per file

### Context
- Use @codebase for project-wide questions
- Use @file for specific file context
- Use @docs for documentation
```

#### GitHub Copilot

`.github/copilot-instructions.md`:
```markdown
# Copilot Instructions

Follow all project conventions defined in AGENTS.md in the repository root.

## Copilot-Specific

### Completions
- Suggest code matching existing patterns
- Include JSDoc comments for functions
- Add type annotations

### Chat
- Use @workspace for project context
- Reference similar files when suggesting patterns
```

### Step 3: Keep Tool-Specific Instructions Separate

**In AGENTS.md (universal):**
- Project overview
- Code conventions
- Architecture
- Commands
- Patterns

**In tool-specific files:**
- Workflows unique to that tool
- Tool features and commands
- Permissions (Claude Code)
- UI behaviors (Cursor)

## Implementation Pattern

### Layered Configuration

```
┌─────────────────────────────────────────────┐
│               AGENTS.md                      │
│         (Universal Source of Truth)          │
│                                              │
│  • Project context                           │
│  • Code conventions                          │
│  • Architecture                              │
│  • Commands                                  │
│  • Patterns                                  │
└─────────────────────────────────────────────┘
                    │
        ┌───────────┼───────────┐
        ▼           ▼           ▼
┌─────────────┐ ┌─────────────┐ ┌─────────────┐
│  CLAUDE.md  │ │.cursor/rules│ │  .github/   │
│             │ │             │ │copilot-inst.│
│ • Import    │ │ • Import    │ │             │
│   AGENTS.md │ │   AGENTS.md │ │ • Reference │
│ • Claude    │ │ • Cursor    │ │   AGENTS.md │
│   workflows │ │   UI        │ │ • Copilot   │
│ • Permiss-  │ │   behavior  │ │   tips      │
│   ions      │ │             │ │             │
└─────────────┘ └─────────────┘ └─────────────┘
```

### Minimal Tool Files

Each tool file should be minimal, just:
1. Import/reference AGENTS.md
2. Add tool-specific instructions only

**Bad** (duplicates content):
```markdown
# CLAUDE.md

## Code Style (same as AGENTS.md)
- Functional components
- Named exports
...hundreds of lines duplicated...
```

**Good** (references source):
```markdown
# CLAUDE.md

Follow @AGENTS.md for all conventions.

## Claude-Specific
Only Claude-specific instructions here.
```

## Workflow Example

### When Onboarding a New Tool

1. Ensure AGENTS.md exists with core conventions
2. Create minimal tool-specific config
3. Add import/reference to AGENTS.md
4. Add only tool-specific instructions
5. Test AI behavior matches expectations

### When Updating Conventions

1. Update AGENTS.md (source of truth)
2. Tool-specific files inherit automatically
3. Review AI behavior in each tool
4. Update tool-specific files only if needed

### When Adding New Developer

1. Clone repository (gets all config files)
2. Install preferred AI tool(s)
3. AI immediately knows project conventions
4. No manual explanation needed

## Common Patterns

### Monorepo with Multiple Teams

```
monorepo/
├── AGENTS.md                # Shared conventions
├── CLAUDE.md                # "Follow @AGENTS.md"
├── .cursor/
│   └── rules/
│       ├── general.mdc      # alwaysApply: true
│       ├── frontend.mdc     # globs: ["packages/frontend/**"]
│       └── backend.mdc      # globs: ["packages/backend/**"]
├── .github/
│   └── copilot-instructions.md
└── packages/
    ├── frontend/
    │   └── AGENTS.md        # Frontend-specific additions
    └── backend/
        └── AGENTS.md        # Backend-specific additions
```

### Team with Tool Preferences

```
# Developer A uses Claude Code
# Developer B uses Cursor
# Developer C uses Copilot

All developers share:
- AGENTS.md (universal conventions)

Each developer's tool reads AGENTS.md and behaves consistently.
```

### Gradual Tool Adoption

```
Phase 1: Create AGENTS.md
         └── Core conventions documented

Phase 2: Add Claude Code
         └── CLAUDE.md imports AGENTS.md

Phase 3: Some devs try Cursor
         └── .cursor/rules/ imports AGENTS.md

Phase 4: Enable Copilot Enterprise
         └── copilot-instructions.md references AGENTS.md
```

## Benefits

### Consistency

- Same conventions across all tools
- AI generates consistent code regardless of tool
- Code reviews are simpler

### Maintainability

- Update conventions in one place
- No drift between tool configs
- Less maintenance burden

### Flexibility

- Developers can use preferred tools
- Easy to try new tools
- No lock-in to specific vendor

### Onboarding

- New developers immediately productive
- AI "knows" the project from day one
- Less tribal knowledge needed

## Troubleshooting

### "Different tools give different suggestions"

1. Check all tools reference AGENTS.md
2. Ensure no conflicting tool-specific rules
3. Test with same prompt in each tool

### "Tool doesn't read AGENTS.md"

Some tools need explicit import:
- Claude Code: Use `@AGENTS.md` syntax
- Cursor: Reference with `@AGENTS.md`
- Copilot: Describe in instructions text

### "Conventions changed but tool didn't update"

1. Verify AGENTS.md was updated
2. Restart AI tool / clear context
3. Check tool-specific file still imports AGENTS.md

## Best Practices

### 1. AGENTS.md is King

All universal conventions go in AGENTS.md. Tool files only add tool-specific instructions.

### 2. Keep Tool Files Minimal

```markdown
# Good CLAUDE.md
Follow @AGENTS.md.

## Claude Commands
/plan, /commit, /review-pr

# Bad CLAUDE.md (duplicates AGENTS.md)
## Project Overview... (same as AGENTS.md)
## Code Style... (same as AGENTS.md)
```

### 3. Review Cross-Tool

When changing conventions:
1. Update AGENTS.md
2. Test in Claude Code
3. Test in Cursor
4. Test in Copilot
5. Ensure consistent behavior

### 4. Document Tool-Specific Features

Each tool has unique features. Document them in the tool-specific file:
- Claude: /plan, /commit, skills, hooks
- Cursor: Composer, @mentions, notepads
- Copilot: @workspace, slash commands

---

Next: [AGENTS.md Standard](agents-md-standard.md) | [Claude Code Memory](claude-code-memory.md)
