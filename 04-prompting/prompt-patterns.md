# Prompt Patterns

## TL;DR

### Key Principles (Use These Always)

1. **Ask Questions Early** - Include "ask clarifying questions before starting" to prevent excessive planning based on wrong assumptions

2. **Use Parallel Sub-Agents** - Use multiple sub-agents to explore different areas simultaneously for faster results

### Workflow Patterns

| Workflow | Pattern |
|----------|---------|
| New feature | Research → Plan → Implement |
| Bug fix | Reproduce → Locate → Fix → Verify |
| Large task | Plan mode → Approve → Implement |

## The Research-Plan-Implement Pattern

Best for: Features, refactoring, architectural changes

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  RESEARCH   │ ──→ │    PLAN     │ ──→ │  IMPLEMENT  │
│             │     │             │     │             │
│ • Explore   │     │ • Outline   │     │ • Code in   │
│   codebase  │     │   approach  │     │   small PRs │
│ • Read docs │     │ • Get human │     │ • Test each │
│ • Ask Qs    │     │   approval  │     │   change    │
│   early     │     │ • Iterate   │     │ • Review    │
│             │     │   until     │     │   diffs     │
│             │     │   solid     │     │             │
└─────────────┘     └─────────────┘     └─────────────┘
```

### Step 1: Research

```
> I need to implement user notifications.
> Before we start, help me understand:
> 1. How is messaging currently handled?
> 2. What patterns should I follow?
> 3. What files will we need to create/modify?
```

### Step 2: Plan

```
> /plan Implement user notifications with:
> - In-app notification bell
> - Email for important notifications
> - User preferences for notification types
```

Review the plan, ask questions:
```
> Why store notifications in a separate table?
> Would Redis pub/sub work better for real-time?
```

Iterate until satisfied.

### Step 3: Implement

Implement in small, reviewable chunks:
```
> Step 1: Create the notifications database table
[Review, test, commit]

> Step 2: Add the notification service
[Review, test, commit]

> Step 3: Create the API endpoints
[Review, test, commit]
```

## The Plan Mode Pattern

Best for: Complex features, multi-file changes

### Using Plan Mode

```
> /plan [Feature description with requirements]
```

AI creates a plan with:
- Files to create/modify
- Implementation steps
- Potential issues
- Testing approach

### Review and Refine

```
> In the plan, step 3 seems risky. Can we do X instead?
> What if the user has no email configured?
> How does this handle concurrent notifications?
```

### Approve and Execute

Once plan is solid:
```
> Plan looks good. Implement step 1.
```

## The Ask-Questions-Early Pattern

Best for: Ambiguous requirements, unfamiliar code

**Don't:**
```
> Implement the feature
[AI explores for 10 minutes, makes wrong assumptions]
```

**Do:**
```
> Before implementing, ask me clarifying questions
> about anything that's ambiguous.

AI: "A few questions:
1. Should notifications persist after being read?
2. What's the retention period?
3. Should users be able to disable notifications?"

> Great questions. 1. Yes. 2. 30 days. 3. Yes, per type.
> Now implement with these answers.
```

## The Parallel Sub-Agent Pattern

Best for: Multi-area exploration, speeding up research, keeping context clean

### Why Use Parallel Sub-Agents?

**Without Parallel Agents (Sequential)**:
```
Explore auth module      → 5 min, loads 20 files
Explore API layer        → 5 min, loads 15 files
Explore database         → 5 min, loads 10 files
Total: 15 min, context full of 45 files
```

**With Parallel Agents**:
```
Launch 3 sub-agents simultaneously → 5 min total
Receive 3 summaries (600 words total)
Context stays clean, ready for implementation
```

### Common Use Cases

**Understanding a Feature Across Layers**:
```
> Launch parallel subagents:
> 1. Explore frontend components for user profile
> 2. Explore API endpoints for user data
> 3. Explore database schema for users
>
> Return: How these connect and key integration points
```

**Code Review**:
```
> Launch parallel subagents to review this PR:
> 1. Check for security issues
> 2. Check for performance problems
> 3. Verify test coverage
>
> Return: Only critical findings (confidence > 80%)
```

**Research**:
```
> Research caching strategies by exploring:
> 1. Current caching implementation in our codebase
> 2. Best practices from popular open source projects
> 3. Options compatible with our stack (Node + Redis)
>
> Return: Recommendations with pros/cons
```

### Best Practices

1. **Be Specific About Scope**: "Explore auth module focusing on JWT implementation"
2. **Limit Return Size**: "Return max 200 words per area"
3. **Combine Results**: After getting summaries, ask for synthesis
4. **Use for Isolated Tasks**: Don't use for interactive work that needs back-and-forth

## The Incremental Pattern

Best for: Large changes, reducing risk

### Small Steps

```
> Let's build this incrementally.
> First: Just the data model
[Review, approve]

> Next: Just the read operations
[Review, approve]

> Next: The write operations
[Review, approve]

> Next: The UI component
[Review, approve]
```

### Benefits

- Easier to review
- Easier to catch mistakes
- Easy rollback point
- Maintains clean git history

## The Reference Pattern

Best for: Consistent code, following existing patterns

```
> Create a UserSettings component following the pattern
> in src/components/UserProfile.tsx:
> - Same prop structure
> - Same error handling approach
> - Same styling conventions
```

```
> Add an orders endpoint matching the implementation
> in src/api/products.ts:
> - Same validation approach
> - Same response format
> - Same error handling
```

## The Exploration Pattern

Best for: Understanding unfamiliar code

### Use Parallel Sub-Agents for Speed

Instead of exploring sequentially, launch multiple sub-agents in parallel:

```
> Launch parallel subagents to explore:
> 1. Authentication flow (src/auth/) - return key files and patterns
> 2. Database schema (prisma/schema.prisma) - return entities and relationships
> 3. API routes (src/api/) - return endpoints structure
>
> Each should return a brief summary in under 200 words.
```

Benefits:
- 3x faster exploration
- Main context stays clean (only summaries, not all files)
- Can compare results across different areas
- No context pollution from deep exploration

### Single Area Exploration

For focused exploration of one area:

```
> Use an explore agent to understand src/services/payment/
> Return:
> - Main entry points
> - External dependencies
> - Data flow overview
> - Key functions
```

### Follow-up Questions

```
> How does payment retry logic work?
> What happens if Stripe is down?
> Where are webhook handlers?
```

## The Debug Pattern

Best for: Bug investigation and fixing

### Structured Bug Report

```
## Bug: [Title]

### Symptom
[What users see]

### Error
[Full error message]

### Reproduce
1. [Step 1]
2. [Step 2]

### Expected
[Correct behavior]

### Actual
[Current behavior]
```

### Investigation

```
> Given this bug, help me:
> 1. Understand the likely cause
> 2. Locate the problematic code
> 3. Propose a fix
```

### Fix with Test

```
> Before fixing, write a test that reproduces the bug.
> Then fix it so the test passes.
```

## The Review Pattern

Best for: Code review, PR review

### Pre-Commit Review

```
> Review my staged changes for:
> - Bugs or logic errors
> - Security issues
> - Missing error handling
> - Pattern inconsistencies
```

### PR Review

```
> /review-pr 123
```

Or manually:
```
> Review PR #123:
> - Does it solve the stated problem?
> - Are there edge cases?
> - Security concerns?
> - Test coverage adequate?
```

## The Refactoring Pattern

Best for: Code improvement without behavior change

**Tip**: Use the `code-simplifier` plugin for automated refactoring:
```
> /plugin install code-simplifier@claude-plugins-official
> /code-simplifier src/utils/format.ts
```

### Safe Refactoring

```
> Refactor src/utils/format.ts to:
> - Improve readability
> - Add TypeScript types
> Keep the same external interface.
> Don't change behavior.
```

### With Tests First

```
> Before refactoring, ensure tests exist for current behavior.
> Show me current test coverage for this module.
```

Then:
```
> Now refactor. Tests must still pass.
```

## Pattern Selection Guide

| Situation | Pattern |
|-----------|---------|
| New feature | Research → Plan → Implement |
| Complex change | Plan mode |
| Unclear requirements | Ask questions early |
| Large change | Incremental |
| Need consistency | Reference |
| Unfamiliar code | Exploration |
| Bug | Debug pattern |
| Review | Review pattern |
| Improvement | Refactoring |

---

Next: [Good vs Bad Examples](examples/good-vs-bad.md) | [Real-World Prompts](examples/real-world-prompts.md)
