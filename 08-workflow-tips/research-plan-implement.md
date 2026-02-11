# Research-Plan-Implement Pattern

## TL;DR

The most effective AI-assisted development follows a three-phase pattern:
1. **Research** - Understand the codebase before changing it
2. **Plan** - Design the approach with AI help
3. **Implement** - Execute in small, reviewed steps

## Why This Pattern Works

### The Problem with "Just Build It"

```
# Bad approach
> Build a user authentication system with OAuth, session management,
> and password reset functionality
```

This leads to:
- AI making incorrect assumptions about your codebase
- Code that doesn't match existing patterns
- Missed edge cases
- Rework when integration fails

### The Solution

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│   RESEARCH   │────▶│     PLAN     │────▶│  IMPLEMENT   │
│              │     │              │     │              │
│ - Understand │     │ - Design     │     │ - Small steps│
│ - Explore    │     │ - Verify     │     │ - Review     │
│ - Ask        │     │ - Approve    │     │ - Test       │
└──────────────┘     └──────────────┘     └──────────────┘
```

## Phase 1: Research

### Goal
Understand the existing codebase before making changes.

### Techniques

**Ask the AI to explore:**
```
> I need to add OAuth authentication. Before we start,
> help me understand:
> 1. How is authentication currently handled?
> 2. What patterns do we use for middleware?
> 3. Where are user sessions stored?
> 4. Are there any existing OAuth-related files?
```

**Request a codebase tour:**
```
> Walk me through how a user currently logs in.
> What files are involved? What's the data flow?
```

**Find similar implementations:**
```
> Find existing features similar to what we need.
> Look for patterns we should follow.
```

### What to Discover

- Existing patterns and conventions
- Files that will need modification
- Dependencies and integrations
- Potential conflicts or complications
- Similar code to use as reference

### Claude Code Research Example

```
> /explore How does authentication work in this codebase?

# Or more specifically:
> Search for all files related to authentication.
> Summarize what each one does.
```

## Phase 2: Plan

### Goal
Design the implementation approach before writing code.

### Techniques

**Use plan mode (Claude Code):**
```
> /plan Add OAuth authentication with Google

# Claude will:
# 1. Analyze codebase context
# 2. Propose implementation steps
# 3. Identify files to create/modify
# 4. Wait for your approval
```

**Request explicit plan:**
```
> Before implementing, create a detailed plan:
> 1. What files will we create?
> 2. What files will we modify?
> 3. What's the order of implementation?
> 4. What are the key design decisions?
```

**Validate the plan:**
```
> Looking at this plan, what are the risks?
> What edge cases might we miss?
> Does this follow our existing patterns?
```

### Plan Components

A good implementation plan includes:

```markdown
## Implementation Plan: OAuth Authentication

### New Files
1. `src/lib/oauth.ts` - OAuth provider configuration
2. `src/api/auth/google/route.ts` - OAuth callback handler
3. `src/components/GoogleSignInButton.tsx` - UI component

### Modified Files
1. `src/lib/auth.ts` - Add OAuth session handling
2. `src/types/auth.ts` - Add OAuth user types
3. `src/app/login/page.tsx` - Add OAuth button

### Implementation Order
1. Types first (so everything else compiles)
2. OAuth library configuration
3. Backend callback handler
4. Frontend component
5. Integration and testing

### Design Decisions
- Store OAuth tokens in session (not database)
- Use existing user table (add oauth_provider column)
- Reuse current session middleware
```

### Approval Checkpoint

**Never skip this step.** Review and approve the plan:

```
> This plan looks good, but:
> - Let's use the database for token storage instead
> - Add refresh token handling
> - Include error boundary in the component
```

## Phase 3: Implement

### Goal
Execute the plan in small, reviewable increments.

### Techniques

**One step at a time:**
```
# Step 1
> Implement step 1 from the plan: Create the OAuth types

# Review, then continue
> That looks good. Now implement step 2: OAuth configuration

# And so on...
```

**Verify after each step:**
```
> Run the type checker to make sure this compiles
> Run the tests related to auth
```

**Request tests alongside implementation:**
```
> Now implement the callback handler.
> Include unit tests for the happy path and error cases.
```

### Review Checkpoints

After each implementation step:

1. **Read the generated code** - Don't blindly accept
2. **Check for patterns** - Does it match existing code?
3. **Run tests** - Catch issues early
4. **Commit if good** - Create atomic, meaningful commits

```
> Review what we just implemented.
> Check for security issues, edge cases, and pattern consistency.
```

## Complete Example

### Scenario: Add Rate Limiting

**Phase 1 - Research:**
```
> I want to add rate limiting to our API.
> First, help me understand:
> 1. What middleware do we currently use?
> 2. How are API routes structured?
> 3. Do we have Redis or similar for storage?
> 4. Are there any existing rate limiting attempts?
```

AI explores and responds:
```
I found:
- Middleware in src/middleware/ using Next.js middleware pattern
- API routes in src/app/api/ using route handlers
- Redis is configured in src/lib/redis.ts
- No existing rate limiting, but there's a TODO comment mentioning it
```

**Phase 2 - Plan:**
```
> /plan Add rate limiting using Redis with:
> - 100 requests per minute for authenticated users
> - 20 requests per minute for anonymous users
> - Return 429 with retry-after header when exceeded
```

AI proposes plan, you review and adjust:
```
> The plan looks good. A few changes:
> - Also add rate limiting to WebSocket connections
> - Include a bypass for internal service calls
> - Add monitoring/alerting for rate limit hits
```

**Phase 3 - Implement:**
```
> Implement step 1: Rate limiter utility with Redis

# After review:
> Looks good. Run the tests.

# Tests pass:
> Implement step 2: API middleware integration

# Continue step by step...
```

## Pattern Variations

### Quick Tasks

For small changes, compress the phases:
```
> I need to add a loading spinner to the submit button.
> Look at how we handle loading states elsewhere,
> then make this change following that pattern.
```

### Complex Features

For large features, iterate on plans:
```
> Let's break this into phases:
> Phase 1: Backend API
> Phase 2: Basic UI
> Phase 3: Advanced features
>
> Create a detailed plan for Phase 1 first.
```

### Exploratory Work

When requirements are unclear:
```
> I'm not sure exactly what we need yet.
> Let's explore the options for [feature].
> Don't implement anything - just research and summarize choices.
```

## Anti-Patterns to Avoid

### 1. Skipping Research

```
# Bad
> Build a caching layer

# Good
> Before we add caching, what caching do we already have?
> What patterns does this codebase use?
```

### 2. Vague Plans

```
# Bad plan
1. Add caching
2. Test it
3. Deploy

# Good plan
1. Create CacheService class in src/lib/cache.ts
2. Add Redis adapter in src/lib/cache/redis.ts
3. Modify UserService to use CacheService for user lookups
4. Add cache invalidation in user update handlers
5. Write integration tests for cache hit/miss scenarios
```

### 3. Big Bang Implementation

```
# Bad
> Implement the entire authentication system

# Good
> Implement step 1: The basic session model
> [Review]
> Implement step 2: The login endpoint
> [Review]
> Continue...
```

## Benefits

| Benefit | How Pattern Achieves It |
|---------|------------------------|
| **Accuracy** | Research ensures AI understands context |
| **Consistency** | Planning aligns with existing patterns |
| **Quality** | Incremental review catches issues early |
| **Learning** | You understand every change made |
| **Reversibility** | Small commits are easy to revert |

---

Next: [Plan Mode](plan-mode.md) | [Multi-Agent Patterns](multi-agent.md)
