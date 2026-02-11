# Claude Code Skills Deep Dive

## TL;DR

Skills are domain expertise files that Claude loads when working on relevant code. They live in `.claude/skills/*/SKILL.md`.

## Skill Structure

```
.claude/
└── skills/
    ├── api-development/
    │   └── SKILL.md
    ├── testing/
    │   └── SKILL.md
    └── frontend/
        └── SKILL.md
```

## Skill File Format

### Basic Structure

```markdown
---
trigger: "when to activate this skill"
---

# Skill Name

## Section 1
Content...

## Section 2
Content...
```

### Frontmatter

```yaml
---
trigger: "condition for activation"
# Optional:
priority: 10  # Higher = loads first if multiple match
---
```

### Trigger Examples

```yaml
# File path triggers
trigger: "working on files in src/api/"
trigger: "editing files matching **/*.test.ts"
trigger: "working on authentication or auth files"

# Content triggers
trigger: "working with database queries or Prisma"
trigger: "implementing React components"
trigger: "writing API endpoints"
```

## Example Skills

### API Development Skill

```markdown
---
trigger: "working on API endpoints, routes, or REST handlers"
---

# API Development

## Response Format

All endpoints return:
```typescript
interface ApiResponse<T> {
  success: boolean;
  data?: T;
  error?: {
    code: string;
    message: string;
    details?: unknown;
  };
}
```

## HTTP Status Codes

| Code | Use |
|------|-----|
| 200 | Success (GET, PUT, PATCH) |
| 201 | Created (POST) |
| 204 | No Content (DELETE) |
| 400 | Validation Error |
| 401 | Unauthorized |
| 403 | Forbidden |
| 404 | Not Found |
| 500 | Server Error |

## Validation

Use Zod for all input validation:
```typescript
import { z } from 'zod';

const createUserSchema = z.object({
  email: z.string().email(),
  name: z.string().min(2).max(50),
});

// In handler
const validated = createUserSchema.parse(req.body);
```

## Error Handling

```typescript
import { ApiError } from '@/lib/errors';

try {
  const result = await operation();
  return { success: true, data: result };
} catch (error) {
  if (error instanceof ApiError) {
    return {
      success: false,
      error: { code: error.code, message: error.message }
    };
  }
  throw error; // Let error middleware handle
}
```

## Authentication

```typescript
// Protected route
import { requireAuth } from '@/middleware/auth';

router.get('/profile', requireAuth, async (req, res) => {
  const user = req.user; // Set by requireAuth
  // ...
});
```
```

### Testing Skill

```markdown
---
trigger: "writing tests or working on test files"
---

# Testing Guidelines

## Test Structure

```typescript
describe('FeatureName', () => {
  // Setup
  beforeEach(() => {
    // Reset state
  });

  describe('functionName', () => {
    it('should [expected behavior] when [condition]', () => {
      // Arrange
      const input = { ... };

      // Act
      const result = functionName(input);

      // Assert
      expect(result).toEqual(expected);
    });
  });
});
```

## Test Naming

Use descriptive names:
- `should return user when valid ID provided`
- `should throw error when email is invalid`
- `should create order with correct totals`

## Mocking

```typescript
// Mock module
jest.mock('@/lib/database');

// Mock implementation
const mockDb = jest.mocked(database);
mockDb.users.findOne.mockResolvedValue({ id: '1', name: 'Test' });

// Reset between tests
beforeEach(() => {
  jest.resetAllMocks();
});
```

## Testing React Components

```typescript
import { render, screen, fireEvent } from '@testing-library/react';

describe('Button', () => {
  it('calls onClick when clicked', () => {
    const handleClick = jest.fn();
    render(<Button onClick={handleClick}>Click me</Button>);

    fireEvent.click(screen.getByRole('button'));

    expect(handleClick).toHaveBeenCalledTimes(1);
  });
});
```

## Test Coverage

Aim for:
- 80% coverage for new code
- 100% for critical paths (auth, payments)
- Focus on behavior, not implementation
```

### Frontend Skill

```markdown
---
trigger: "working on React components or frontend code"
---

# Frontend Development

## Component Structure

```typescript
// Imports
import { useState } from 'react';
import { cn } from '@/lib/utils';

// Types
interface Props {
  title: string;
  onAction?: () => void;
}

// Component
export function ComponentName({ title, onAction }: Props) {
  // Hooks
  const [state, setState] = useState();

  // Handlers
  const handleClick = () => { ... };

  // Render
  return (
    <div className="...">
      {/* JSX */}
    </div>
  );
}
```

## Styling (Tailwind)

Use utility classes:
```tsx
<button className={cn(
  "px-4 py-2 rounded font-medium",
  variant === "primary" && "bg-blue-500 text-white",
  variant === "secondary" && "bg-gray-200 text-gray-800",
  disabled && "opacity-50 cursor-not-allowed"
)}>
```

## State Management

- **Server state**: React Query
- **Client state**: Zustand
- **Form state**: React Hook Form

## Data Fetching

```typescript
import { useQuery } from '@tanstack/react-query';

export function useUser(id: string) {
  return useQuery({
    queryKey: ['user', id],
    queryFn: () => api.getUser(id),
  });
}
```

## Error Boundaries

Wrap feature sections:
```tsx
<ErrorBoundary fallback={<ErrorFallback />}>
  <FeatureComponent />
</ErrorBoundary>
```
```

## Commands vs Skills

### Commands

- Explicitly invoked: `/review`, `/test`
- One-time actions
- User-initiated

### Skills

- Automatically activated
- Persistent context
- Condition-triggered

### When to Use Each

| Use Case | Type |
|----------|------|
| Code review workflow | Command |
| API patterns | Skill |
| Generate tests | Command |
| Testing conventions | Skill |
| Create PR | Command |
| Frontend patterns | Skill |

## Combining Commands and Skills

Commands can reference skills:

**`.claude/commands/api-endpoint.md`:**
```markdown
---
description: Create new API endpoint
---

Using the patterns from our API development skill,
create a new endpoint for $ARGUMENTS.

Include:
- Route handler
- Input validation
- Error handling
- Response formatting
```

## Plugin Skills

Plugins bundle skills that work together:

**feature-dev plugin includes:**
- `code-explorer` - Codebase exploration
- `code-architect` - Feature design
- `code-reviewer` - Code review

These skills activate during the feature development workflow.

## Best Practices

### 1. Focused Triggers

```yaml
# Bad - too broad
trigger: "when coding"

# Good - specific
trigger: "when working on files in src/api/ or writing REST endpoints"
```

### 2. Actionable Content

```markdown
# Bad
Write good API code following best practices.

# Good
Use Zod for validation:
```typescript
const schema = z.object({ email: z.string().email() });
```
```

### 3. Real Examples

Include actual code from your codebase:
```markdown
See src/api/users.ts for example implementation.
```

### 4. Keep Updated

Skills should evolve with your codebase. Review periodically.

---

Next: [Claude Code Plugins](claude-code-plugins.md) | [Cursor Custom](cursor-custom.md)
