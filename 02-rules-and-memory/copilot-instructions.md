# GitHub Copilot Instructions

## TL;DR

Copilot uses `.github/copilot-instructions.md` for repository-wide instructions:

```markdown
# Copilot Instructions

## Code Style
- Use TypeScript for all new files
- Follow functional programming patterns
- Use named exports

## Testing
- Use Jest for unit tests
- Follow AAA pattern (Arrange, Act, Assert)
```

## Instruction Types

### 1. Repository Instructions

**File**: `.github/copilot-instructions.md`

Applies to the entire repository. Committed and shared with team.

### 2. Path-Specific Instructions

**Directory**: `.github/instructions/`

Target specific file patterns with YAML frontmatter:

```markdown
---
applyTo: "src/api/**"
---

API-specific instructions here.
```

### 3. Organization Instructions (Enterprise)

Set by admins at: Settings > Copilot > Custom Instructions

Applies to all repositories in the organization.

## File Format

### Basic Structure

`.github/copilot-instructions.md`:

```markdown
# Copilot Instructions

## Project Overview
Brief description of the project.

## Code Style
- Convention 1
- Convention 2

## Patterns
- Pattern 1
- Pattern 2
```

### Path-Specific Format

`.github/instructions/api.instructions.md`:

```markdown
---
applyTo: "src/api/**"
---

# API Development Instructions

These instructions apply to files in src/api/.

## Response Format
All endpoints return { success, data?, error? }

## Validation
Use Zod for input validation.
```

## Example Instructions

### General Repository Instructions

```markdown
# Copilot Instructions

## Project Overview
E-commerce platform built with Next.js, TypeScript, and PostgreSQL.

## Tech Stack
- **Framework**: Next.js 14 (App Router)
- **Language**: TypeScript (strict mode)
- **Database**: PostgreSQL with Prisma
- **Testing**: Jest + React Testing Library
- **Styling**: Tailwind CSS

## Code Style

### General
- Use TypeScript for all new files
- Prefer functional programming patterns
- Use named exports, not default exports
- Maximum function length: 50 lines

### Naming
- Variables/functions: camelCase
- Components/classes: PascalCase
- Constants: UPPER_SNAKE_CASE
- Files: kebab-case.ts

### Imports
- Use absolute imports from @/
- Group imports: external, internal, relative
- Sort alphabetically within groups

## Testing

### Unit Tests
- Use Jest for all tests
- Follow AAA pattern (Arrange, Act, Assert)
- Mock external dependencies
- Aim for 80%+ coverage

### Test Naming
```typescript
describe('ComponentName', () => {
  it('should [expected behavior] when [condition]', () => {});
});
```

## Documentation

### Functions
- Add JSDoc to all exported functions
- Include @param, @returns, @throws
- Add @example for complex functions

### Comments
- Explain "why", not "what"
- Keep comments up to date
- Remove commented-out code

## Security

- Never hardcode secrets
- Validate all user input
- Use parameterized queries
- Sanitize output to prevent XSS

## Error Handling

- Catch all async errors
- Log errors with context
- Return user-friendly messages
- Use custom error classes
```

### Path-Specific: API Routes

`.github/instructions/api.instructions.md`:

```markdown
---
applyTo: "src/api/**"
---

# API Route Instructions

## Response Format

All API endpoints must return:

```typescript
// Success
{
  success: true,
  data: T
}

// Error
{
  success: false,
  error: {
    code: 'ERROR_CODE',
    message: 'User-friendly message'
  }
}
```

## Status Codes

- 200: Successful GET, PUT, PATCH
- 201: Successful POST (created)
- 204: Successful DELETE (no content)
- 400: Validation error
- 401: Unauthorized
- 403: Forbidden
- 404: Not found
- 500: Server error

## Validation

Use Zod for all input validation:

```typescript
import { z } from 'zod';

const createUserSchema = z.object({
  email: z.string().email(),
  name: z.string().min(2).max(50),
});

export async function POST(req: Request) {
  const body = await req.json();
  const validated = createUserSchema.parse(body);
  // ...
}
```

## Authentication

- All routes require auth except /api/public/*
- Use getSession() from auth library
- Return 401 for missing auth, 403 for insufficient permissions
```

### Path-Specific: Tests

`.github/instructions/tests.instructions.md`:

```markdown
---
applyTo: "**/*.test.ts"
---

# Test File Instructions

## Structure

```typescript
import { render, screen } from '@testing-library/react';
import { ComponentName } from './ComponentName';

describe('ComponentName', () => {
  // Setup
  beforeEach(() => {
    // Reset mocks, set up common data
  });

  describe('rendering', () => {
    it('renders correctly with default props', () => {});
    it('renders loading state', () => {});
    it('renders error state', () => {});
  });

  describe('interactions', () => {
    it('calls onSubmit when form is submitted', () => {});
    it('validates input on blur', () => {});
  });
});
```

## Assertions

- Use specific assertions over generic ones
- One concept per test
- Test behavior, not implementation

```typescript
// Good
expect(screen.getByRole('button')).toBeDisabled();

// Avoid
expect(button.disabled).toBe(true);
```

## Mocking

- Mock external dependencies (API calls, DB)
- Use realistic test data
- Reset mocks in beforeEach

```typescript
jest.mock('@/lib/api');
const mockApi = jest.mocked(api);

beforeEach(() => {
  mockApi.fetchUser.mockReset();
});
```
```

### Path-Specific: Components

`.github/instructions/components.instructions.md`:

```markdown
---
applyTo: "src/components/**"
---

# Component Instructions

## File Structure

```typescript
// 1. Imports (external, then internal)
import { useState, useEffect } from 'react';
import { cn } from '@/lib/utils';

// 2. Types
interface Props {
  title: string;
  onAction?: () => void;
}

// 3. Component
export function MyComponent({ title, onAction }: Props) {
  // a. Hooks
  const [state, setState] = useState();

  // b. Derived state
  const isValid = state !== null;

  // c. Effects
  useEffect(() => {}, []);

  // d. Handlers
  const handleClick = () => {};

  // e. Render
  return <div />;
}
```

## Styling

Use Tailwind with cn() for conditional classes:

```typescript
<button
  className={cn(
    'px-4 py-2 rounded',
    isActive && 'bg-blue-500 text-white',
    isDisabled && 'opacity-50 cursor-not-allowed'
  )}
>
```

## Accessibility

- Use semantic HTML elements
- Add ARIA labels to interactive elements
- Ensure keyboard navigation works
- Maintain focus management
```

## Directory Structure

```
.github/
├── copilot-instructions.md      # Repository-wide
└── instructions/                # Path-specific
    ├── api.instructions.md
    ├── components.instructions.md
    ├── tests.instructions.md
    └── database.instructions.md
```

## Best Practices

### 1. Be Specific and Actionable

```markdown
# Bad
- Write good code
- Follow best practices

# Good
- Use camelCase for variable names
- Add JSDoc comments to exported functions
- Handle all async errors with try/catch
```

### 2. Include Examples

```markdown
## Error Handling

```typescript
// Good
try {
  const user = await fetchUser(id);
  return { success: true, data: user };
} catch (error) {
  logger.error('Failed to fetch user', { id, error });
  return { success: false, error: { code: 'FETCH_ERROR', message: 'Failed to fetch user' } };
}
```
```

### 3. Keep Instructions Focused

Copilot has context limits. Include only what helps with code generation:
- Coding standards
- Common patterns
- Required conventions

Don't include:
- Project history
- Team member info
- Deployment processes

### 4. Update When Patterns Change

When your team adopts new patterns:
1. Update instructions file
2. Review with team
3. Commit changes

### 5. Layer Instructions

```
Organization (admins set)
    └── Company-wide standards

Repository (.github/copilot-instructions.md)
    └── Project-specific conventions

Path-specific (.github/instructions/*.instructions.md)
    └── Area-specific patterns
```

## Copilot Ignore File

Exclude files from Copilot suggestions:

`.github/copilot-ignore`:

```
# Sensitive files
.env*
**/secrets/**
**/credentials/**
*.pem
*.key

# Generated files
dist/
build/
coverage/

# Large files
*.min.js
*.bundle.js
```

## Troubleshooting

### "Instructions aren't being followed"

1. Verify file location: `.github/copilot-instructions.md`
2. Check file is committed and pushed
3. Reload VS Code window
4. Check organization settings don't override

### "Path-specific instructions not applying"

1. Verify `applyTo` pattern matches files
2. Check file is in `.github/instructions/`
3. Ensure `.instructions.md` extension

### "Suggestions don't match our style"

1. Add more specific examples
2. Include anti-patterns ("Don't do this...")
3. Reference existing code patterns

## Resources

- **Custom Instructions Guide**: [docs.github.com/copilot/customizing-copilot/adding-custom-instructions-for-github-copilot](https://docs.github.com/copilot/customizing-copilot/adding-custom-instructions-for-github-copilot)
- **5 Tips for Instructions**: [github.blog/ai-and-ml/github-copilot/5-tips-for-writing-better-custom-instructions-for-copilot](https://github.blog/ai-and-ml/github-copilot/5-tips-for-writing-better-custom-instructions-for-copilot/)
- **Copilot Documentation**: [docs.github.com/copilot](https://docs.github.com/copilot)

---

Next: [Cross-Tool Strategy](cross-tool-strategy.md) | [AGENTS.md Standard](agents-md-standard.md)
