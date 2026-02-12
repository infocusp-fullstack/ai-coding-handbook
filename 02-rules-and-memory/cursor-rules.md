# Cursor Rules Configuration

## TL;DR

Cursor uses `.cursor/rules/*.mdc` files with YAML frontmatter to configure AI behavior:

```markdown
---
description: TypeScript coding standards
globs: ["**/*.ts", "**/*.tsx"]
alwaysApply: false
---

# TypeScript Rules

- Use strict mode
- Prefer interfaces over type aliases
- No `any` type
```

## Rule Types

### 1. User Rules (Global)

Set in Cursor settings, applies to all projects.

**Location**: Settings > Rules > User Rules

**Good for:**
- Personal preferences
- Cross-project conventions
- Default behaviors

### 2. Project Rules (Modern)

Files in `.cursor/rules/` directory with `.mdc` extension.

**Location**: `.cursor/rules/*.mdc`

**Good for:**
- Team standards (committed to repo)
- Project-specific conventions
- Technology-specific rules

### 3. Legacy .cursorrules

Single file in project root. Still works but deprecated.

**Location**: `.cursorrules`

**Recommendation**: Migrate to `.cursor/rules/*.mdc` for better organization.

## Rule File Format

### Structure

```markdown
---
description: Brief description (shown in Cursor UI)
globs: ["pattern/**/*.ts"]    # When to auto-apply
alwaysApply: false            # true = always include
---

# Rule content in markdown

Your instructions to Cursor go here.
```

### Frontmatter Options

| Field | Type | Description |
|-------|------|-------------|
| `description` | string | Brief description, shown in UI |
| `globs` | string[] | File patterns for auto-activation |
| `alwaysApply` | boolean | Always include (true) or pattern-based (false) |

### Glob Pattern Examples

| Pattern | Matches |
|---------|---------|
| `**/*.ts` | All TypeScript files |
| `**/*.tsx` | All TSX files |
| `**/*.test.ts` | All test files |
| `src/api/**` | All files in src/api |
| `*.config.js` | Config files in root |
| `**/*.{ts,tsx}` | TS and TSX files |

## Example Rules

### Always-Applied General Rules

```markdown
---
description: General project conventions
alwaysApply: true
---

# Project Conventions

## Tech Stack
- Next.js 14 with App Router
- TypeScript in strict mode
- Tailwind CSS for styling
- React Query for server state

## Code Style
- Functional components only
- Named exports (no default exports)
- Absolute imports from @/

## Commands
- `npm run dev` - Development server
- `npm test` - Run tests
- `npm run lint` - Lint code
```

### TypeScript-Specific Rules

```markdown
---
description: TypeScript coding standards
globs: ["**/*.ts", "**/*.tsx"]
alwaysApply: false
---

# TypeScript Standards

## Type Definitions
- Prefer `interface` over `type` for objects
- Use explicit return types on exported functions
- Never use `any` - use `unknown` if type is truly unknown

## Patterns
// Good
interface User {
  id: string;
  name: string;
}

// Avoid
type User = {
  id: string;
  name: string;
}

## Null Handling
- Use optional chaining: `user?.profile?.email`
- Use nullish coalescing: `value ?? defaultValue`
- Prefer early returns for null checks
```

### API Development Rules

```markdown
---
description: API endpoint conventions
globs: ["src/api/**", "src/app/api/**"]
alwaysApply: false
---

# API Development

## Response Format
All endpoints return:
{ "success": true, "data": { ... } }
// or
{ "success": false, "error": { "code": "VALIDATION_ERROR", "message": "Email is required" } }

## Status Codes
- 200: Success
- 201: Created
- 400: Validation error
- 401: Unauthorized
- 403: Forbidden
- 404: Not found
- 500: Server error

## Validation
- Use Zod for all input validation
- Validate early, fail fast
- Return specific error messages
```

### Testing Rules

```markdown
---
description: Testing conventions
globs: ["**/*.test.ts", "**/*.test.tsx", "**/*.spec.ts"]
alwaysApply: false
---

# Testing Standards

## Structure
- Use describe() for grouping related tests
- Use it() for individual test cases
- Follow AAA pattern: Arrange, Act, Assert

## Naming
describe('UserService', () => {
  describe('createUser', () => {
    it('creates user with valid data', () => {});
    it('throws on invalid email', () => {});
    it('handles duplicate email', () => {});
  });
});

## Mocking
- Mock external dependencies (DB, APIs)
- Use realistic test data
- Clean up after tests

## Assertions
- One concept per test
- Use specific assertions (not just truthy/falsy)
- Test edge cases and error conditions
```

### React Component Rules

```markdown
---
description: React component patterns
globs: ["src/components/**/*.tsx", "src/app/**/*.tsx"]
alwaysApply: false
---

# React Components

## Structure
// Imports
import { useState } from 'react';
import { Button } from '@/components/ui';

// Types
interface Props {
  title: string;
  onSubmit: (data: FormData) => void;
}

// Component
export function MyComponent({ title, onSubmit }: Props) {
  // Hooks first
  const [value, setValue] = useState('');

  // Handlers
  const handleSubmit = () => {
    onSubmit({ value });
  };

  // Render
  return (
    <div>
      {/* JSX */}
    </div>
  );
}

## Patterns
- Functional components only (no classes)
- Named exports
- Co-locate types with components
- Extract hooks for complex logic

## Styling
- Use Tailwind utility classes
- Extract repeated patterns to components
- Use cn() for conditional classes
```

## Directory Structure

```
.cursor/
└── rules/
    ├── general.mdc         # alwaysApply: true
    ├── typescript.mdc      # globs: ["**/*.ts", "**/*.tsx"]
    ├── api.mdc             # globs: ["src/api/**"]
    ├── components.mdc      # globs: ["src/components/**"]
    ├── testing.mdc         # globs: ["**/*.test.ts"]
    └── database.mdc        # globs: ["src/lib/db/**"]
```

## Best Practices

### 1. Keep Rules Under 500 Lines

If a rule file gets too long, split it:

```
# Instead of one large file
rules/everything.mdc (1000 lines)

# Split by concern
rules/general.mdc (100 lines)
rules/typescript.mdc (150 lines)
rules/testing.mdc (100 lines)
```

### 2. Use Specific Globs

```markdown
# Bad - too broad
globs: ["**/*"]

# Good - targeted
globs: ["src/api/**/*.ts", "src/routes/**/*.ts"]
```

### 3. Be Actionable, Not Vague

```markdown
# Bad
- Write clean code
- Follow best practices

# Good
- Use camelCase for variables, PascalCase for components
- Maximum function length: 50 lines
- All API calls must have error handling
```

### 4. Include Examples

```markdown
## Error Handling

// Good
try {
  const result = await api.fetchUser(id);
  return result;
} catch (error) {
  logger.error('Failed to fetch user', { userId: id, error });
  throw new ApiError(500, 'Failed to fetch user');
}

// Bad
const result = await api.fetchUser(id);  // No error handling
return result;
```

### 5. Commit to Version Control

`.cursor/rules/` should be committed so the team shares the same AI behavior.

Add personal overrides to user rules in Cursor settings (not committed).

## Migration from .cursorrules

If you have a `.cursorrules` file:

1. Create `.cursor/rules/` directory
2. Split content by topic into `.mdc` files
3. Add appropriate frontmatter
4. Test that rules apply correctly
5. Delete `.cursorrules`

## Troubleshooting

### "Rules aren't applying"

1. Check file is in `.cursor/rules/` directory
2. Check `.mdc` extension
3. Verify YAML frontmatter syntax
4. Check glob patterns match your files
5. For `alwaysApply: false`, verify globs

### "Rules conflict with each other"

1. Check for overlapping glob patterns
2. More specific globs take precedence
3. Consider consolidating conflicting rules

### "Cursor seems slow"

1. Reduce total rules content
2. Use specific globs instead of `alwaysApply: true`
3. Remove unnecessary rules

## Resources

- **Cursor Rules Docs**: [cursor.com/docs/context/rules](https://cursor.com/docs/context/rules)
- **Awesome Cursorrules**: [github.com/PatrickJS/awesome-cursorrules](https://github.com/PatrickJS/awesome-cursorrules)
- **Cursor Best Practices**: [github.com/digitalchild/cursor-best-practices](https://github.com/digitalchild/cursor-best-practices)
- **Kirill Markin's Guide**: [kirill-markin.com/articles/cursor-ide-rules-for-ai/](https://kirill-markin.com/articles/cursor-ide-rules-for-ai/)

---

Next: [Copilot Instructions](copilot-instructions.md) | [Cross-Tool Strategy](cross-tool-strategy.md)
