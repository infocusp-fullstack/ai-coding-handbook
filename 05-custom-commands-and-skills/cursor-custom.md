# Cursor Customization

## TL;DR

Customize Cursor with:
- **Rules** (`.cursor/rules/*.mdc`) - Automatic context per file type
- **Notepads** - Scratch space for session context
- **@ Commands** - Reference specific context

## Rules Files

### Structure

```
.cursor/
└── rules/
    ├── general.mdc      # alwaysApply: true
    ├── typescript.mdc   # globs: ["**/*.ts"]
    ├── testing.mdc      # globs: ["**/*.test.ts"]
    └── api.mdc          # globs: ["src/api/**"]
```

### Format

```markdown
---
description: Description shown in UI
globs: ["**/*.ts", "**/*.tsx"]
alwaysApply: false
---

# Rule Content

Your instructions in markdown.
```

### Rule Types

**Always Apply** - Loads every time:
```yaml
---
description: Project conventions
alwaysApply: true
---
```

**Glob-Based** - Loads for matching files:
```yaml
---
description: API patterns
globs: ["src/api/**/*.ts"]
alwaysApply: false
---
```

**Manual** - Invoke with @ruleName:
```yaml
---
description: Security checklist
alwaysApply: false
# No globs = manual only
---
```

## Example Rules

### General Rule

```markdown
---
description: Project-wide conventions
alwaysApply: true
---

# Project Conventions

## Tech Stack
- Next.js 14 (App Router)
- TypeScript (strict)
- Tailwind CSS
- Prisma ORM

## Code Style
- Functional components
- Named exports
- Absolute imports (@/)

## Commands
- npm run dev
- npm test
- npm run lint
```

### TypeScript Rule

```markdown
---
description: TypeScript standards
globs: ["**/*.ts", "**/*.tsx"]
---

# TypeScript

- Use strict mode
- No `any` type
- Explicit return types on exports
- Prefer interfaces for objects
- Use type guards for narrowing

```typescript
// Good
interface User {
  id: string;
  name: string;
}

function isUser(obj: unknown): obj is User {
  return typeof obj === 'object' && obj !== null && 'id' in obj;
}
```
```

### Testing Rule

```markdown
---
description: Testing conventions
globs: ["**/*.test.ts", "**/*.test.tsx", "**/*.spec.ts"]
---

# Testing

## Structure
```typescript
describe('Feature', () => {
  describe('method', () => {
    it('should [behavior] when [condition]', () => {
      // Arrange, Act, Assert
    });
  });
});
```

## Libraries
- Jest for runner
- React Testing Library for components
- MSW for API mocking

## Coverage
- 80% minimum for new code
- Test behavior, not implementation
```

### API Rule

```markdown
---
description: API development
globs: ["src/api/**", "src/app/api/**"]
---

# API Development

## Response Format
```json
{ "success": true, "data": { } }
{ "success": false, "error": { "code": "", "message": "" } }
```

## Validation
Use Zod for all inputs.

## Error Handling
```typescript
try {
  // operation
} catch (error) {
  return NextResponse.json(
    { success: false, error: { code: 'ERROR', message: error.message } },
    { status: 500 }
  );
}
```
```

## Notepads

### What They Are

Scratch space that persists during your session:
- Store context you reference repeatedly
- Quick access without file search
- Not committed to repo

### Use Cases

**Current Task Notes:**
```
Working on: User notification system
Key files:
- src/services/notifications.ts
- src/components/NotificationBell.tsx
- src/api/notifications/route.ts

Notes:
- Use existing toast system for UI
- WebSocket for real-time
```

**API Reference:**
```
Stripe API keys:
- Test: pk_test_xxx
- Webhooks: /api/webhooks/stripe

Endpoints we use:
- PaymentIntents.create
- Subscriptions.create
- Webhooks (checkout.session.completed)
```

**Design Decisions:**
```
Decided:
- Use Redis for caching (not in-memory)
- JWT expiry: 15 minutes
- Refresh token: 7 days

Still deciding:
- Rate limit strategy
```

## @ Commands

### Built-in References

| Command | Purpose |
|---------|---------|
| `@file.ts` | Reference specific file |
| `@folder/` | Reference directory |
| `@codebase` | Search entire project |
| `@docs` | Reference documentation |
| `@web` | Web search |
| `@git` | Git history |

### Usage Examples

**Reference files:**
```
@src/api/users.ts Add pagination following this pattern
```

**Search codebase:**
```
@codebase How do we handle authentication?
```

**Multiple references:**
```
@src/types/user.ts @src/api/users.ts Create a new endpoint
for updating user preferences using these patterns
```

**Git context:**
```
@git What changed in the authentication module last week?
```

## Composer Integration

### Multi-File Changes

Composer (Cmd/Ctrl+I) for changes across files:

```
Create a "favorites" feature:
- Add favorites table to schema
- Create API endpoints (list, add, remove)
- Add FavoriteButton component
- Add useFavorites hook

Use patterns from existing features.
```

### Review Before Accept

Composer shows all proposed changes:
1. Review each file change
2. Accept/reject per file
3. Edit if needed before accepting

## Best Practices

### 1. Layer Your Rules

```
general.mdc (alwaysApply)
    ├── typescript.mdc (*.ts)
    │   └── testing.mdc (*.test.ts)
    └── api.mdc (src/api/**)
```

### 2. Keep Rules Focused

Each rule file: one concern, < 200 lines

### 3. Use Notepads for Sessions

Don't clutter rules with temporary context.

### 4. Specific @ References

```
# Bad - too broad
@codebase fix the bug

# Good - targeted
@src/api/auth.ts fix the token validation bug on line 45
```

### 5. Commit Rules, Not Notepads

- `.cursor/rules/` → committed, team-shared
- Notepads → local, personal

---

Next: [Overview](overview.md) | [Claude Code Skills](claude-code-skills.md)
