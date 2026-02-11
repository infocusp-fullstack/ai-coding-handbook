# Subagent Patterns

## TL;DR

Subagents are isolated AI instances that handle specific tasks, then return results. They:
- Keep your main conversation clean
- Allow parallel exploration
- Prevent context pollution

```
Main Agent
    │
    ├── Subagent 1: "Explore auth module" → Returns summary
    ├── Subagent 2: "Explore API patterns" → Returns summary
    └── Subagent 3: "Check test coverage" → Returns summary
    │
    └── Main agent continues with clean context + summaries
```

## Why Use Subagents

### Problem: Context Pollution

Exploring a large codebase pollutes context:

```
You: "Understand how auth works"
AI: [Reads 20 files, 5000 lines of code...]
# Your context is now full of auth code
# Later work suffers from reduced context space
```

### Solution: Subagent Isolation

```
You: "Use a subagent to explore the auth module"
Subagent: [Reads files in isolated context]
Subagent: Returns: "Auth summary: JWT-based, 3 main components..."
# Main context only has the summary, not all the code
```

## When to Use Subagents

### Good Use Cases

| Scenario | Why Subagent Helps |
|----------|-------------------|
| Exploring unfamiliar code | Keep exploration separate from implementation |
| Parallel investigations | Search multiple areas simultaneously |
| Code review | Review without polluting working context |
| Research tasks | Gather info without cluttering conversation |
| Large refactoring | Plan in isolation, implement with clean context |

### Skip Subagents When

- Task is simple and quick
- You need continuous interaction
- Context is already small
- You want to follow along step-by-step

## Subagent Patterns

### Pattern 1: Exploration Subagent

```
> Use a subagent to explore src/services/payment/
> Return:
> - Main components and their responsibilities
> - Key functions and their signatures
> - External dependencies
> - Potential issues or tech debt
```

Result: Concise summary in main context.

### Pattern 2: Parallel Investigation

```
> Launch subagents to explore:
> 1. Authentication flow (src/auth/)
> 2. Database schema (prisma/schema.prisma)
> 3. API routes (src/api/)
>
> Each should return a brief summary of how they interact.
```

Results: Three summaries, main context stays clean.

### Pattern 3: Research Subagent

```
> Use a subagent to research how we should implement
> rate limiting. Look at:
> - Current patterns in our codebase
> - Industry best practices
> - Options that fit our stack (Express + Redis)
>
> Return recommendations with pros/cons.
```

Result: Informed decision without research polluting context.

### Pattern 4: Review Subagent

```
> Use a code review subagent to review the changes
> in this PR for:
> - Security issues
> - Performance problems
> - Pattern violations
>
> Return only significant findings (confidence > 80%).
```

Result: Actionable review findings, not verbose analysis.

### Pattern 5: Plan Subagent

```
> Use a subagent to create a detailed implementation
> plan for the user notification system.
>
> Consider:
> - Database changes needed
> - API endpoints required
> - Frontend components
> - Background job requirements
>
> Return the plan in checklist format.
```

Result: Implementation checklist without planning clutter.

## Using Subagents in Claude Code

### Automatic Subagents

Claude Code uses subagents automatically for:
- **Plan mode** (`/plan`)
- **Explore tool**
- **Multi-file searches**

### Explicit Subagent Requests

```
> Spawn a subagent to [task]

> Use an explore agent to understand [area]

> Launch parallel subagents to investigate [multiple areas]
```

### Plugin-Based Subagents

Plugins like Feature Dev use subagents:
- `code-explorer` - Explores codebase
- `code-architect` - Designs features
- `code-reviewer` - Reviews implementation

## Best Practices

### 1. Be Specific About Return Format

```
# Bad: Vague return
> Explore the auth module

# Good: Specific return
> Explore auth module. Return:
> - Entry points (max 5)
> - Critical functions (max 10)
> - Security concerns (if any)
> Keep summary under 500 words.
```

### 2. Scope Appropriately

```
# Bad: Too broad
> Explore the entire codebase

# Good: Focused
> Explore src/services/payment/ focusing on
> Stripe integration patterns
```

### 3. Use for Isolated Tasks

```
# Good: Isolated research
> Subagent: Research caching strategies for our API

# Less ideal: Continuous interaction
> Subagent: Build the feature step by step
# (Use main agent for interactive work)
```

### 4. Combine Results Thoughtfully

```
> I received these subagent results:
> - Auth: [summary]
> - DB: [summary]
> - API: [summary]
>
> Now synthesize: How do these interact for user login?
```

## Anti-Patterns

### Subagent for Simple Tasks

```
# Overkill
> Use a subagent to read package.json

# Just do it
> What dependencies do we have in package.json?
```

### Too Many Parallel Subagents

```
# Likely confusing
> Launch 10 subagents to explore different aspects...

# More manageable
> Launch 3 subagents for the main areas:
> auth, data, and presentation layers
```

### Ignoring Subagent Results

```
# Wasteful
> Use subagent to explore auth
> [Ignores result]
> Anyway, let me implement auth my way...

# Use the insight
> Based on the auth exploration, the key integration
> point is the TokenService. Let's start there.
```

## Context Comparison

### Without Subagents

```
Conversation start
├── Explore auth (loads 20 files)
├── Explore API (loads 15 files)
├── Explore DB (loads 10 files)
└── Try to implement feature...
    └── Context: 50% exploration, 50% available
```

### With Subagents

```
Conversation start
├── Subagent → Auth summary (200 words)
├── Subagent → API summary (200 words)
├── Subagent → DB summary (200 words)
└── Implement feature...
    └── Context: 5% summaries, 95% available
```

---

Next: [Understanding Context](understanding-context.md) | [Managing Context](managing-context.md)
