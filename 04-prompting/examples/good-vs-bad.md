# Good vs Bad Prompts: Side-by-Side

Real examples showing why specificity matters.

## Example 1: Feature Implementation

### Bad

```
Add a login page
```

**Problems:**
- No tech stack context
- No design requirements
- No behavior specifications
- No reference to existing patterns

### Good

```
Create a login page for our React app using the existing
AuthContext from src/contexts/auth.tsx. Use shadcn/ui form
components. Include email/password fields with Zod validation.
On success, redirect to /dashboard. Match styling patterns
in src/pages/signup.tsx.
```

**Why it works:**
- References existing code (AuthContext, signup.tsx)
- Specifies components (shadcn/ui)
- Defines validation (Zod)
- Describes behavior (redirect on success)
- Points to style reference

---

## Example 2: Bug Fix

### Bad

```
Fix the bug
```

**Problems:**
- What bug?
- Where is it?
- What should happen?

### Good

```
Users report 500 error when submitting checkout form
with empty shipping address. Error is in
src/api/orders.ts around line 45. The address
validation should return 400 with clear error message
instead of throwing unhandled exception.
```

**Why it works:**
- Describes symptom (500 error)
- Locates issue (file and line)
- Specifies expected behavior (400 with message)
- Explains root cause (unhandled exception)

---

## Example 3: Asking for Help

### Bad

```
Make it work
```

**Problems:**
- What's "it"?
- What's broken?
- What does "work" mean?

### Good

```
This test fails with 'TypeError: Cannot read property
of undefined'. Before fixing, ask me clarifying
questions about expected behavior if anything is
ambiguous.
```

**Why it works:**
- Shares specific error
- Invites clarification
- Prevents excessive exploration
- Establishes collaboration

---

## Example 4: Code Review

### Bad

```
Review this
```

**Problems:**
- Review for what?
- What's the context?
- What matters most?

### Good

```
Review this PR for our payment processing endpoint:
- Security vulnerabilities (especially input validation)
- Error handling completeness
- Compliance with our API response format
- Edge cases we might have missed

This handles real money, so be thorough.
```

**Why it works:**
- Specifies focus areas
- Provides context (payment = critical)
- Sets expectations (thorough)
- Lists specific concerns

---

## Example 5: Test Generation

### Bad

```
Add tests
```

**Problems:**
- What tests?
- For what code?
- What scenarios?

### Good

```
Write unit tests for calculateDiscount() in
src/utils/pricing.ts. Cover:
- Regular price (no discount)
- Percentage discount (10%, 50%, 100%)
- Fixed amount discount
- Discount exceeds price (should cap at 0)
- Invalid inputs (negative, null, undefined)

Use Jest and follow patterns in src/utils/__tests__/
```

**Why it works:**
- Specifies function
- Lists all scenarios
- Includes edge cases
- References existing test patterns

---

## Example 6: API Endpoint

### Bad

```
Create an API for users
```

**Problems:**
- What operations?
- What data format?
- What authentication?

### Good

```
Create REST endpoints for user management:

GET    /api/users     - List with pagination (page, limit)
GET    /api/users/:id - Get single user
POST   /api/users     - Create (validate email, name)
PUT    /api/users/:id - Update (partial updates allowed)
DELETE /api/users/:id - Soft delete (set deletedAt)

Follow patterns in src/api/products.ts for:
- Input validation (Zod)
- Error responses ({ success: false, error: {...} })
- Authentication (requireAuth middleware)
```

**Why it works:**
- Specifies all endpoints
- Defines behaviors (soft delete, partial update)
- References existing patterns
- Lists validation requirements

---

## Example 7: Debugging Performance

### Bad

```
It's slow
```

**Problems:**
- What's slow?
- How slow?
- What's acceptable?

### Good

```
getUserPosts() in src/services/users.ts is slow:
- Currently: 3 seconds for 100 users
- Expected: under 200ms

Suspect N+1 query issue - it queries posts
separately for each user.

Suggest optimizations. Show me before/after
query comparison.
```

**Why it works:**
- Identifies function
- Quantifies problem (3s vs 200ms)
- Hypothesizes cause (N+1)
- Asks for comparison

---

## Example 8: Refactoring

### Bad

```
Clean this up
```

**Problems:**
- Clean what?
- How?
- What should be preserved?

### Good

```
Refactor src/components/Dashboard.tsx (currently 500 lines):

Extract into:
- DashboardHeader (logo, nav, user menu)
- DashboardSidebar (navigation links)
- DashboardMain (content area)

Requirements:
- Keep same visual appearance
- Maintain all existing functionality
- Each component under 100 lines
- Add prop types for each component
```

**Why it works:**
- Identifies what to extract
- Preserves requirements (visual, functional)
- Sets constraints (100 lines)
- Specifies deliverables (prop types)

---

## Quick Reference

| Aspect | Bad | Good |
|--------|-----|------|
| **Context** | None | Files, stack, patterns |
| **Task** | Vague verb | Specific action + location |
| **Constraints** | None | Clear requirements |
| **Examples** | None | Reference existing code |
| **Output** | Undefined | Specified format |
| **Edge cases** | Ignored | Listed explicitly |

---

Next: [Real-World Prompts](real-world-prompts.md) | [Prompting Principles](../prompting-principles.md)
