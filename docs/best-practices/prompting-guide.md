# Prompting Guide for AI Coding Assistants

## TL;DR

1. **Be specific** - Include context, constraints, and expected output
2. **Reference existing code** - Point to patterns to follow
3. **Break down complex tasks** - Smaller prompts = better results
4. **Iterate** - Refine prompts based on results

## The Anatomy of a Good Prompt

```
[Context] + [Task] + [Constraints] + [Output Format]
```

### Example

```
# Bad prompt
Add authentication

# Good prompt
Looking at src/api/middleware/auth.ts, add JWT authentication
to the /api/users endpoints in src/api/routes/users.ts.
Use the existing authMiddleware pattern. Return 401 for
invalid tokens with error message format matching our API standards.
```

## Core Principles

### 1. Provide Context

Tell the AI what it needs to know:

```
# Context about the codebase
This is a Next.js 14 app using the App Router, Prisma ORM,
and NextAuth for authentication.

# Context about the task
We need to add rate limiting to prevent abuse of the API.

# Context about constraints
Must work with our existing Redis instance at process.env.REDIS_URL.
```

### 2. Be Specific About the Task

Vague requests get vague results:

| Vague | Specific |
|-------|----------|
| "Fix the bug" | "Fix the null reference error in UserProfile.tsx line 45 when user.email is undefined" |
| "Make it faster" | "Optimize the database query in getUsers() - it's doing N+1 queries" |
| "Add tests" | "Add unit tests for the calculateDiscount function covering: regular price, sale items, bulk discounts, and invalid inputs" |

### 3. Reference Existing Patterns

```
> Add a new API endpoint for products following the same pattern
> as src/api/routes/users.ts - including validation, error handling,
> and the response format.
```

### 4. Specify Output Format

```
> Create a function that returns an object with:
> - success: boolean
> - data: array of user objects (id, name, email)
> - pagination: { page, perPage, total }
```

### 5. Include Constraints

```
> Implement search functionality with these constraints:
> - Must be SQL injection safe
> - Results limited to 100 items max
> - Should handle empty search terms
> - Must complete in under 200ms for typical queries
```

## Prompt Patterns

### The Explanation Request

```
> Explain how [file/function] works, including:
> - What problem it solves
> - How data flows through it
> - Any edge cases it handles
> - Potential issues or improvements
```

### The Implementation Request

```
> Implement [feature] that:
> - Does X when Y happens
> - Handles these edge cases: [list]
> - Follows the pattern in [reference file]
> - Includes error handling for [scenarios]
```

### The Debugging Request

```
> I'm seeing [error/behavior] when [action].
> Expected behavior: [what should happen]
> Actual behavior: [what's happening]
> Relevant code: [file or selection]
> I've already tried: [attempts]
```

### The Refactoring Request

```
> Refactor [code] to:
> - [specific improvement]
> - Maintain the same external interface
> - Keep backward compatibility with [existing callers]
> - Add types for [specific areas]
```

### The Review Request

```
> Review this code for:
> - Security vulnerabilities
> - Performance issues
> - Code style consistency
> - Missing error handling
> - Test coverage gaps
```

## Tool-Specific Tips

### Claude Code

**Use plan mode for complex tasks:**
```
> /plan Add a complete user authentication system with:
> - Email/password registration
> - JWT tokens
> - Password reset flow
> - Rate limiting
```

**Reference multiple files:**
```
> Looking at src/models/User.ts and src/api/auth.ts,
> add email verification following our existing patterns
```

**Use skills for domain tasks:**
```
> /commit    # Smart commit message
> /review-pr # Detailed PR review
```

### GitHub Copilot

**Write detailed comments:**
```javascript
// Validate email format using RFC 5322 standard
// Return true if valid, false otherwise
// Handle edge cases: empty string, null, unicode characters
function validateEmail(email) {
```

**Use chat participants:**
```
> @workspace How is authentication handled?
> @terminal How do I run the test suite?
```

### Cursor

**Use @ mentions for context:**
```
> @api/users.ts @types/User.ts Refactor createUser
> to validate all fields before database insertion
```

**Use Composer for multi-file:**
```
> Create a complete "notifications" feature:
> - Component for notification list
> - API endpoint for fetching notifications
> - WebSocket handler for real-time updates
> - Database schema for storing notifications
```

## Iteration Strategies

### When Results Aren't Right

1. **Add more context**
   ```
   > That's close, but it should also handle the case where
   > the user is not authenticated. See how we do it in
   > src/middleware/auth.ts
   ```

2. **Be more specific**
   ```
   > The error handling isn't quite right. Use our standard
   > ApiError class from src/utils/errors.ts and return
   > HTTP 400 for validation errors, 500 for unexpected errors
   ```

3. **Show examples**
   ```
   > The output format should match this:
   > { "success": true, "data": [...], "meta": { "total": 100 } }
   ```

4. **Break it down**
   ```
   > Let's take this step by step:
   > 1. First, just create the database schema
   > 2. Then we'll add the API endpoint
   > 3. Finally, the frontend component
   ```

### When to Start Fresh

- Context has become confused
- Going in circles on the same issue
- Accumulated too many corrections
- Fundamental misunderstanding of the task

Use `/clear` (Claude Code) or start a new chat.

## Anti-Patterns to Avoid

### Don't: Ask Without Context

```
# Bad
> Fix the error

# Good
> Fix the TypeError in src/utils/format.ts line 23.
> The function receives undefined when user has no profile.
```

### Don't: Be Ambiguous

```
# Bad
> Make it better

# Good
> Improve the performance of getUserPosts by:
> - Adding database indexing suggestions
> - Implementing pagination (20 items per page)
> - Caching results for 5 minutes
```

### Don't: Request Too Much at Once

```
# Bad
> Build a complete e-commerce system

# Good
> Create the product listing API endpoint:
> - GET /api/products with pagination
> - Filter by category and price range
> - Sort by price, name, or date added
```

### Don't: Ignore Previous Context

```
# Bad
> Now do the same thing for orders
(AI doesn't know what "same thing" means)

# Good
> Now create a similar API endpoint for orders,
> following the same validation and response patterns
> we used for products in src/api/products.ts
```

## Prompt Templates

### Bug Fix Template

```
## Bug Report
**File**: [path/to/file.ts]
**Line**: [line number if known]

## Current Behavior
[What's happening]

## Expected Behavior
[What should happen]

## Steps to Reproduce
1. [Step 1]
2. [Step 2]

## Error Message (if any)
[Paste error]

## What I've Tried
- [Attempt 1]
- [Attempt 2]
```

### Feature Request Template

```
## Feature: [Name]

## Description
[What the feature does]

## Acceptance Criteria
- [ ] [Criterion 1]
- [ ] [Criterion 2]

## Technical Constraints
- [Constraint 1]
- [Constraint 2]

## Reference Implementation
See [existing file/pattern] for similar functionality
```

---

Next: [When to Use Which Tool](when-to-use-which-tool.md) | [Sample Prompts](../reference/sample-prompts.md)
