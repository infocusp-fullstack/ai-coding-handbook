# Rules File Sizing

## TL;DR

Keep rules files lean:
- **CLAUDE.md**: < 150 lines
- **Per rule file**: < 500 lines
- Include only what's needed **every session**
- Use references for detailed docs

## The Size Problem

Rules files load into context on every turn. Large rules mean:
- Less space for your actual work
- Slower responses
- Rules competing with code for "attention"

### Context Budget

```
Total context window: ~200K tokens

Reserved for:
├── System instructions: ~5K tokens
├── Rules files: ~??? (your control)
├── Conversation: ~??? (grows)
├── Code files: ~??? (varies)
└── Tool outputs: ~??? (varies)
```

**Your rules files directly reduce space for everything else.**

## Sizing Guidelines

### CLAUDE.md

**Target**: < 150 lines, < 3,000 tokens

**Include:**
- Project overview (1-2 sentences)
- Tech stack (bullet list)
- Key commands (5-10 most used)
- Critical conventions (must-follow rules)

**Exclude:**
- Detailed architecture docs
- Full API documentation
- Historical context
- Verbose examples

### Example - Lean CLAUDE.md

```markdown
# CLAUDE.md

## Overview
E-commerce platform: Next.js frontend, Express API, PostgreSQL.

## Commands
- npm run dev - Start all services
- npm test - Run tests
- npm run lint - Check style

## Conventions
- TypeScript strict mode
- Functional components, named exports
- API format: { success, data?, error? }
- Tests required for new features

## Key Paths
- apps/web/src/ - Frontend
- apps/api/src/ - Backend
- packages/shared/ - Shared types
```

**~30 lines, ~500 tokens**

### Per Rule File (.claude/rules/*.md)

**Target**: < 500 lines each

Split by concern:
```
.claude/rules/
├── api-patterns.md      (~100 lines)
├── testing-standards.md (~150 lines)
├── security-rules.md    (~100 lines)
└── component-patterns.md (~150 lines)
```

### Cursor Rules (.cursor/rules/*.mdc)

Same principle: split by concern, keep each file focused.

## What to Include vs Reference

### Include Directly

Things AI needs on every turn:
- Core conventions (naming, formatting)
- Critical patterns (error handling)
- Frequently violated rules

### Reference with @

Things AI can load on-demand:
```markdown
# CLAUDE.md
For API documentation, see @docs/api-reference.md
For architecture decisions, see @docs/adr/
```

### Put in External Docs

Things for humans, not AI:
- Onboarding guides
- Team processes
- Meeting notes
- Historical context

## Measuring Impact

### Check Your Current Size

```bash
# Line count
wc -l CLAUDE.md

# Approximate tokens (chars / 4)
wc -c CLAUDE.md
```

### Before/After Comparison

After trimming rules:
1. Note response speed
2. Check AI accuracy
3. Verify critical rules still followed

## Trimming Strategies

### 1. Remove Verbose Examples

**Before:**
```markdown
## Error Handling

Here's how we handle errors. When you encounter an error,
you should use our standard ApiError class. This class takes
several parameters including the status code, message, and
optional details object. Here's a full example:

```typescript
// In your API route
try {
  const user = await db.user.findUnique({ where: { id } });
  if (!user) {
    throw new ApiError(404, 'User not found', { userId: id });
  }
  // ... more code
} catch (error) {
  if (error instanceof ApiError) {
    return res.status(error.status).json({
      success: false,
      error: {
        code: error.code,
        message: error.message,
        details: error.details
      }
    });
  }
  // ... more handling
}
```
```

**After:**
```markdown
## Errors
Use ApiError class: `throw new ApiError(status, message, details?)`
```

### 2. Convert Prose to Lists

**Before:**
```markdown
When working on this project, you should know that we use
TypeScript in strict mode for all code. We prefer functional
components over class components in React. All exports should
be named exports rather than default exports. For state
management, we use React Query for server state and Zustand
for client state.
```

**After:**
```markdown
## Conventions
- TypeScript strict mode
- Functional components
- Named exports only
- State: React Query (server), Zustand (client)
```

### 3. Remove Obvious Instructions

**Remove:**
```markdown
- Write clean, readable code
- Follow best practices
- Test your code before committing
```

AI knows these already.

### 4. Consolidate Similar Rules

**Before:**
```markdown
## API Responses
All API responses should include a success field.
All API responses should include either data or error.
All API responses should use standard HTTP status codes.
```

**After:**
```markdown
## API Format
{ success: boolean, data?: T, error?: { code, message } }
```

### 5. Use Tables for Patterns

**Before:**
```markdown
For 200 status, return success response with data.
For 201 status, return success response after creation.
For 400 status, return error for validation failures.
For 401 status, return error for authentication failures.
```

**After:**
```markdown
| Status | Use |
|--------|-----|
| 200 | Success |
| 201 | Created |
| 400 | Validation error |
| 401 | Unauthorized |
```

## The Reference Pattern

For detailed docs, use references:

```markdown
# CLAUDE.md

## Quick Reference
- API patterns: @docs/api-patterns.md
- Component guidelines: @docs/components.md
- Testing guide: @docs/testing.md

Load these when working on related tasks.
```

AI loads referenced files only when needed, saving context.

## Validation Checklist

Before committing rules changes:

- [ ] Total < 150 lines for CLAUDE.md
- [ ] Each rule file < 500 lines
- [ ] No verbose examples (1-2 line max)
- [ ] No prose (use bullets/tables)
- [ ] No obvious instructions
- [ ] Detailed docs referenced, not included
- [ ] Tested AI still follows critical rules

---

Next: [Subagent Patterns](subagent-patterns.md) | [Managing Context](managing-context.md)
