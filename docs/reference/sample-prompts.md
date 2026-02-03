# Sample Prompts Library

A curated collection of effective prompts for common development tasks.

## Table of Contents

- [Code Generation](#code-generation)
- [Debugging](#debugging)
- [Code Review](#code-review)
- [Testing](#testing)
- [Documentation](#documentation)
- [Refactoring](#refactoring)
- [Git Operations](#git-operations)
- [Learning & Exploration](#learning--exploration)

---

## Code Generation

### API Endpoint

```
Create a REST API endpoint for [resource] with:
- GET /api/[resource] - List with pagination (page, limit params)
- GET /api/[resource]/:id - Get single item
- POST /api/[resource] - Create new item
- PUT /api/[resource]/:id - Update item
- DELETE /api/[resource]/:id - Delete item

Follow the patterns in @api/users.ts for:
- Input validation using [validation library]
- Error response format
- Authentication middleware
- Response structure
```

### React Component

```
Create a [ComponentName] React component that:
- Displays [what it shows]
- Accepts props: [list props with types]
- Handles loading and error states
- Is accessible (proper ARIA labels)
- Follows our component patterns in @components/Button.tsx

Use [styling approach: Tailwind/CSS modules/styled-components].
```

### Database Query

```
Write a database query to:
- [What data to fetch/modify]
- Filter by: [conditions]
- Sort by: [field] [direction]
- Include related: [relations]
- Paginate with: page, limit

Use [ORM/query builder] syntax.
Handle the case where [edge case].
```

### Form with Validation

```
Create a form for [purpose] with fields:
- [field1]: [type], required, [validation rules]
- [field2]: [type], optional, [validation rules]

Include:
- Client-side validation with error messages
- Submit handler that calls [API endpoint]
- Loading state during submission
- Success/error feedback to user
- Reset form on success
```

### Utility Function

```
Create a utility function that:
- Input: [describe input with types]
- Output: [describe output with types]
- Handles edge cases: [list edge cases]

Example:
  Input: [example input]
  Output: [example output]

Include TypeScript types and JSDoc documentation.
```

---

## Debugging

### Error Investigation

```
I'm getting this error:

[Paste full error with stack trace]

When I:
1. [Step to reproduce]
2. [Step to reproduce]

Expected: [what should happen]
Actual: [what actually happens]

Help me:
1. Understand what's causing this
2. Find where in the code it's happening
3. Suggest a fix
```

### Performance Issue

```
This [function/query/component] is slow:
- Current performance: [X seconds/ms]
- Expected: [Y seconds/ms]
- Called [frequency: once, every render, every request]

[Paste code]

Help me:
1. Identify what's causing the slowness
2. Profile or measure specific parts
3. Suggest optimizations
```

### Intermittent Bug

```
We have an intermittent issue where [description].
- Happens approximately [frequency]
- Seems more common when [condition]
- Error message (when captured): [error]

Relevant code: @path/to/file.ts

Help me:
1. Identify potential causes of intermittent failures
2. Add logging to capture more info
3. Suggest fixes for likely causes
```

### State Management Bug

```
The UI shows stale/incorrect data:
- Expected state: [description]
- Actual state: [description]
- Happens after: [action]

State is managed in: @path/to/state.ts
Component: @path/to/Component.tsx

Trace the state flow and find where the update is failing.
```

---

## Code Review

### General Review

```
Review this code for:
- Bugs or logic errors
- Security vulnerabilities
- Performance issues
- Code style and conventions
- Missing error handling
- Test coverage gaps

[Paste code or reference file]

For each issue, explain:
1. What the issue is
2. Why it matters
3. How to fix it
```

### Security Review

```
Security review this code:

[Paste code]

Check for:
- Injection vulnerabilities (SQL, NoSQL, command)
- XSS vulnerabilities
- Authentication/authorization flaws
- Sensitive data exposure
- CSRF vulnerabilities
- Insecure dependencies

Rate each finding: Critical / High / Medium / Low
```

### PR Review

```
Review PR #[number] focusing on:
- Does it solve the stated problem?
- Are there any bugs or edge cases?
- Is the code maintainable?
- Are tests adequate?
- Any security concerns?

Provide:
- Summary of changes
- Must-fix issues
- Suggestions for improvement
- Questions for the author
```

---

## Testing

### Unit Tests

```
Write unit tests for [function/class]:

[Paste code or reference file]

Cover:
- Happy path with valid inputs
- Edge cases: [list specific edge cases]
- Error cases: [list error scenarios]
- Boundary conditions

Use [testing framework: Jest/Vitest/pytest].
Follow our test patterns in @tests/example.test.ts
```

### Integration Tests

```
Write integration tests for [feature/API]:
- Test the full flow from [start] to [end]
- Include database interactions
- Mock external services: [list services]
- Verify side effects: [list side effects]

Setup:
- [Any required setup steps]

Cleanup:
- [Any required cleanup steps]
```

### Test Improvement

```
Review these tests and suggest improvements:

[Paste tests]

Check for:
- Missing test cases
- Weak assertions
- Flaky test patterns
- Test organization
- Setup/teardown issues
- Mocking best practices
```

### Generate Test Cases

```
For this function:

[Paste function]

Generate a comprehensive list of test cases:
- Input scenarios (valid, invalid, edge cases)
- Expected outputs for each
- Error conditions to verify

Format as a table:
| Input | Expected Output | Test Name |
```

---

## Documentation

### Function Documentation

```
Add documentation to this function:

[Paste function]

Include:
- Brief description of purpose
- @param for each parameter with type and description
- @returns description of return value
- @throws for any exceptions
- @example with usage example

Use [JSDoc/docstring/XML comments] format.
```

### README Section

```
Write a README section for [feature/module]:
- What it does
- How to use it (with code examples)
- Configuration options
- Common use cases
- Troubleshooting tips

Keep it concise and practical.
```

### API Documentation

```
Document this API endpoint:

[Paste endpoint code]

Include:
- Endpoint URL and method
- Request parameters (query, body, headers)
- Request body schema with examples
- Response schema with examples
- Error responses
- Authentication requirements

Format as [OpenAPI/Markdown/table].
```

---

## Refactoring

### Extract Function

```
Extract reusable logic from this code:

[Paste code]

Identify:
1. Code that can be extracted into functions
2. Good names for each function
3. Parameters each function needs
4. Return types

Show the refactored result.
```

### Simplify Complex Code

```
Simplify this code while preserving behavior:

[Paste code]

Current issues:
- [Issue 1: e.g., too many nested ifs]
- [Issue 2: e.g., unclear variable names]

Refactor to be more readable and maintainable.
Explain each change made.
```

### Modernize Code

```
Modernize this [language] code:

[Paste code]

Convert to use:
- [Modern feature 1: e.g., async/await]
- [Modern feature 2: e.g., destructuring]
- [Modern feature 3: e.g., optional chaining]

Preserve the same behavior and error handling.
```

### Add Types

```
Add TypeScript types to this JavaScript code:

[Paste code]

- Define interfaces for data structures
- Add parameter and return types
- Use strict types (avoid any)
- Handle null/undefined properly

Don't change runtime behavior.
```

---

## Git Operations

### Commit Message

```
Generate a commit message for these changes:

[Describe changes or paste diff]

Follow conventional commits format:
type(scope): description

Types: feat, fix, docs, style, refactor, test, chore

Include:
- Brief subject line (50 chars max)
- Blank line
- Detailed body if needed
```

### PR Description

```
Generate a PR description for:

Branch: [branch name]
Changes: [summary of changes]

Include:
## Summary
[What this PR does]

## Changes
- [Change 1]
- [Change 2]

## Testing
[How to test]

## Screenshots (if UI)
[Placeholder]
```

### Branch Name

```
Suggest a branch name for:
[Description of work]

Follow pattern: [type]/[description]
Types: feature, bugfix, hotfix, refactor, docs

Keep it short but descriptive.
```

---

## Learning & Exploration

### Explain Code

```
Explain this code:

[Paste code]

Cover:
- What it does overall
- Step-by-step breakdown
- Any patterns or techniques used
- Potential improvements
- When you would use this
```

### Architecture Overview

```
Explain the architecture of this codebase:
- @path/to/entry/point
- @path/to/key/modules

I want to understand:
- How the code is organized
- Key abstractions and patterns
- Data flow through the system
- How to add new features
```

### Compare Approaches

```
Compare these approaches for [problem]:

Approach A: [description]
Approach B: [description]

Consider:
- Performance
- Maintainability
- Scalability
- Team familiarity
- Trade-offs

Recommend which to use and why.
```

### Learn New Technology

```
I'm learning [technology].

Explain:
- Core concepts I need to understand
- How it compares to [similar tech I know]
- Common patterns and best practices
- Pitfalls to avoid
- Resources for learning more
```

---

## Quick Reference

### One-Liners

| Task | Prompt |
|------|--------|
| Explain code | "Explain what this code does" |
| Find bugs | "Review for bugs" |
| Add types | "Add TypeScript types" |
| Write tests | "Write unit tests for this" |
| Improve names | "Suggest better names" |
| Add docs | "Add documentation" |
| Optimize | "Optimize for performance" |
| Secure | "Check for security issues" |

### Context Hints

Always include:
- **Reference files**: "Following the pattern in @path/to/similar.ts"
- **Constraints**: "Must work with Node 18+"
- **Style**: "Using our standard error format"
- **Edge cases**: "Handle null inputs gracefully"

---

**Tip**: Save your most-used prompts as custom commands in `.claude/commands/` for quick access.
