# Cursor Setup Guide

## TL;DR

1. Download Cursor from [cursor.com](https://cursor.com)
2. Import your VS Code settings (optional)
3. Sign in for AI features
4. Use `Cmd/Ctrl+K` for inline edits, `Cmd/Ctrl+L` for chat

## What is Cursor?

Cursor is an AI-first code editor built on VS Code. Key features:

- **Codebase-aware AI** - Indexes your entire repository
- **Inline editing** - Edit code with natural language
- **Composer** - Multi-file editing in one conversation
- **Tab completions** - Context-aware autocomplete
- **Chat** - Ask questions about your code

## Installation

### Download

1. Visit [cursor.com](https://cursor.com)
2. Download for your OS (Windows, macOS, Linux)
3. Install and launch

### Import VS Code Settings

On first launch, Cursor offers to import:
- Extensions
- Keybindings
- Settings
- Themes

This makes the transition seamless if you're coming from VS Code.

### Sign In

1. Click the account icon
2. Sign in with Google, GitHub, or email
3. Choose a plan (Free tier available)

## Core Features

### 1. Chat (Cmd/Ctrl+L)

Ask questions about your code:

```
> How does authentication work in this project?
> What does this function do?
> Find all places where we handle user input
```

**Chat uses codebase context automatically.**

### 2. Inline Edit (Cmd/Ctrl+K)

Select code and describe changes:

1. Select code block
2. Press `Cmd/Ctrl+K`
3. Describe the change: "Add error handling"
4. Review and accept

### 3. Composer (Cmd/Ctrl+I)

Multi-file editing for larger changes:

1. Press `Cmd/Ctrl+I`
2. Describe the feature: "Add a user profile page with API endpoint"
3. Composer creates/edits multiple files
4. Review all changes before accepting

### 4. Tab Completions

Cursor predicts your next edit:

- Suggestions appear as you type
- Press `Tab` to accept
- Uses context from your codebase

### 5. @ Mentions

Reference specific context in chat:

| Symbol | What it references |
|--------|-------------------|
| `@file.ts` | Specific file |
| `@folder/` | Directory contents |
| `@codebase` | Search entire codebase |
| `@docs` | Documentation |
| `@web` | Web search |
| `@git` | Git history |

Example:
```
> @api/users.ts @models/User.ts Add input validation to createUser
```

## Rules Configuration

### Rule Types

Cursor uses a hierarchy of rules:

1. **User Rules** - Global, in Cursor settings
2. **Project Rules** - In `.cursor/rules/`
3. **Legacy `.cursorrules`** - Root file (deprecated but supported)

### Modern Project Rules (.mdc files)

Create `.cursor/rules/` directory with rule files:

```
.cursor/
└── rules/
    ├── general.mdc       # Always applied
    ├── typescript.mdc    # For *.ts files
    └── testing.mdc       # For *.test.ts files
```

Example `typescript.mdc`:

```markdown
---
description: TypeScript coding standards
globs: ["**/*.ts", "**/*.tsx"]
alwaysApply: false
---

# TypeScript Rules

- Use strict TypeScript settings
- Prefer interfaces over type aliases for objects
- Use explicit return types on exported functions
- Avoid `any` type - use `unknown` if type is truly unknown
- Use const assertions for literal types
```

### Rule File Structure

```markdown
---
description: Brief description of these rules
globs: ["pattern/**/*.ts"]    # When to auto-apply
alwaysApply: false            # true = always include
---

# Rule content in markdown

Your instructions to the AI go here.
```

### Legacy .cursorrules

Still supported in project root:

```markdown
# .cursorrules

You are an expert TypeScript developer.

## Code Style
- Use functional components with hooks
- Prefer named exports
- Use absolute imports from @/

## Patterns
- Use React Query for server state
- Use Zustand for client state
- Follow the repository pattern for data access
```

## Best Practices

### 1. Index Your Codebase

Ensure Cursor has indexed your project:

1. Open Settings
2. Go to "Features" > "Codebase Indexing"
3. Verify your project is indexed

### 2. Use Specific @ Mentions

Instead of vague questions:

```
# Less effective
> How do I add a new API endpoint?

# More effective
> @api/users.ts @types/api.ts How do I add a new endpoint
> following the pattern in users.ts?
```

### 3. Leverage Composer for Features

For multi-file changes, use Composer:

```
> Create a new "settings" feature with:
> - Settings page component
> - API route for user preferences
> - Database migration for preferences table
> - Types for the settings schema
```

### 4. Write Focused Rules

Keep rules specific and actionable:

```markdown
# Good rules
- Use camelCase for variables, PascalCase for components
- API responses must include `success` boolean and `data` or `error`
- All async functions must have try/catch with proper error logging

# Less effective rules
- Write clean code
- Follow best practices
- Be consistent
```

### 5. Split Large Rules

If rules exceed 500 lines, split into focused files:

```
.cursor/rules/
├── api.mdc           # API patterns
├── components.mdc    # React component patterns
├── testing.mdc       # Testing conventions
└── database.mdc      # Database patterns
```

## Keyboard Shortcuts

| Action | Shortcut |
|--------|----------|
| Open Chat | `Cmd/Ctrl+L` |
| Inline Edit | `Cmd/Ctrl+K` |
| Composer | `Cmd/Ctrl+I` |
| Accept suggestion | `Tab` |
| Reject suggestion | `Esc` |
| Toggle AI panel | `Cmd/Ctrl+Shift+L` |

## Configuration

### Settings Location

- **User settings**: `Cursor > Settings > Cursor Settings`
- **Project rules**: `.cursor/rules/*.mdc`
- **Legacy rules**: `.cursorrules` (root)

### Model Selection

Choose models in settings:
- **GPT-4** - Good general performance
- **Claude** - Strong reasoning
- **Cursor-small** - Fast for simple tasks

### Privacy Settings

Control what Cursor can access:
- Codebase indexing scope
- File exclusions
- Privacy mode for sensitive projects

## Troubleshooting

### "Cursor doesn't understand my codebase"

1. Check indexing status in settings
2. Re-index: `Cmd/Ctrl+Shift+P` > "Reindex"
3. Add project rules with context
4. Use specific @ mentions

### "Suggestions are slow"

1. Check your internet connection
2. Try a faster model (Cursor-small)
3. Reduce indexed file count with exclusions
4. Check Cursor status page

### "Rules aren't being applied"

1. Check file is in correct location (`.cursor/rules/`)
2. Verify glob patterns match your files
3. Check `alwaysApply` setting
4. Ensure valid YAML frontmatter

## Resources

- [Cursor Documentation](https://cursor.com/docs)
- [Rules Documentation](https://cursor.com/docs/context/rules)
- [Awesome Cursor Rules](https://github.com/PatrickJS/awesome-cursorrules)
- [Cursor Best Practices](https://github.com/digitalchild/cursor-best-practices)

---

Next: [Claude Code Setup](claude-code-setup.md) | [Copilot Setup](copilot-setup.md)
