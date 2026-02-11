# Prompting Principles

## TL;DR

Good prompts = Good results. The formula:

```
Context + Task + Constraints + Output Format = Effective Prompt
```

## The Anatomy of a Good Prompt

### Bad Prompt
```
Add authentication
```

### Good Prompt
```
Looking at src/api/middleware/auth.ts, add JWT authentication
to the /api/users endpoints in src/api/routes/users.ts.
Use the existing authMiddleware pattern. Return 401 for
invalid tokens with our standard error format.
```

### Why It's Better

| Component | Bad | Good |
|-----------|-----|------|
| **Context** | None | "Looking at src/api/middleware/auth.ts" |
| **Task** | Vague | "Add JWT authentication to endpoints" |
| **Constraints** | None | "Use existing pattern, standard format" |
| **Location** | Unknown | Specific files referenced |

## Core Principles

### 1. Provide Context

AI doesn't know your codebase by default. Tell it:

```
# Project context
This is a Next.js 14 app using App Router, Prisma ORM,
and NextAuth for authentication.

# Task context
We need rate limiting because users are hitting the API
too frequently. Limit to 100 requests/minute.

# Constraint context
Must work with our existing Redis at process.env.REDIS_URL.
```

### 2. Be Specific

| Vague | Specific |
|-------|----------|
| "Fix the bug" | "Fix null reference at UserProfile.tsx:45 when user.email is undefined" |
| "Make it faster" | "Optimize getUsers() - currently doing N+1 queries, needs batch loading" |
| "Add tests" | "Add unit tests for calculateDiscount: regular price, sales, bulk, invalid" |

### 3. Reference Existing Patterns

```
> Add a new API endpoint for products following the same
> pattern as src/api/routes/users.ts - including validation,
> error handling, and response format.
```

AI learns from your codebase when you point it there.

### 4. Specify Output Format

```
> Create a function that returns:
> - success: boolean
> - data: array of user objects (id, name, email)
> - pagination: { page, perPage, total }
```

### 5. Include Constraints

```
> Implement search with constraints:
> - SQL injection safe
> - Max 100 results
> - Handle empty search terms
> - Complete in under 200ms typically
```

## Prompt Patterns

### Explanation Request

```
Explain how [file/function] works:
- What problem it solves
- How data flows through it
- Edge cases it handles
- Potential improvements
```

### Implementation Request

```
Implement [feature] that:
- Does X when Y happens
- Handles edge cases: [list]
- Follows pattern in [reference file]
- Includes error handling for [scenarios]
```

### Debugging Request

```
I'm seeing [error/behavior] when [action].
Expected: [what should happen]
Actual: [what's happening]
Relevant code: [file or selection]
Already tried: [attempts]
```

### Refactoring Request

```
Refactor [code] to:
- [specific improvement]
- Maintain same external interface
- Keep backward compatibility
- Add types for [areas]
```

### Review Request

```
Review this code for:
- Security vulnerabilities
- Performance issues
- Code style consistency
- Missing error handling
- Test coverage gaps
```

## Tool-Specific Tips

### Claude Code

```
# Use plan mode for complex tasks
> /plan Add user auth with JWT, password reset, rate limiting

# Reference multiple files
> Looking at src/models/User.ts and src/api/auth.ts,
> add email verification following existing patterns

# Use skills
> /commit    # Smart commit message
> /review-pr # Detailed PR review
```

### Cursor

```
# Use @ mentions
> @api/users.ts @types/User.ts Refactor createUser
> to validate all fields before database insertion

# Use Composer for multi-file
> Create a "notifications" feature with:
> - Component for notification list
> - API endpoint
> - WebSocket handler
> - Database schema
```

### Copilot

```javascript
// Detailed comments help Copilot
// Validate email using RFC 5322
// Return true if valid, false otherwise
// Handle: empty string, null, unicode
function validateEmail(email) {

// Use chat participants
// > @workspace How is authentication handled?
// > @terminal How do I run tests?
```

## Iteration Strategies

### When Results Aren't Right

**Add more context:**
```
That's close, but it should also handle unauthenticated users.
See how we do it in src/middleware/auth.ts
```

**Be more specific:**
```
Error handling isn't right. Use ApiError from src/utils/errors.ts.
Return 400 for validation, 500 for unexpected errors.
```

**Show examples:**
```
Output should match:
{ "success": true, "data": [...], "meta": { "total": 100 } }
```

**Break it down:**
```
Let's take this step by step:
1. First, just create the database schema
2. Then we'll add the API endpoint
3. Finally, the frontend component
```

### When to Start Fresh

- Context is confused
- Going in circles
- Fundamental misunderstanding
- Too many corrections accumulated

Use `/clear` (Claude Code) or start new chat.

## Anti-Patterns to Avoid

### No Context

```
# Bad
> Fix the error

# Good
> Fix TypeError in src/utils/format.ts:23.
> Function receives undefined when user has no profile.
```

### Ambiguous

```
# Bad
> Make it better

# Good
> Improve getUserPosts performance:
> - Add database indexing
> - Implement pagination (20/page)
> - Cache results for 5 minutes
```

### Too Much at Once

```
# Bad
> Build complete e-commerce system

# Good
> Create product listing endpoint:
> - GET /api/products with pagination
> - Filter by category and price
> - Sort by price, name, date
```

### Ignoring Context

```
# Bad
> Now do the same for orders
(AI doesn't know what "same" means)

# Good
> Create similar endpoint for orders,
> using same validation and response patterns
> as products in src/api/products.ts
```

---

Next: [Prompt Patterns](prompt-patterns.md) | [Good vs Bad Examples](examples/good-vs-bad.md)
