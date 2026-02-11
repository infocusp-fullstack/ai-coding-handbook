# Managing Context

## TL;DR

| Situation | Action |
|-----------|--------|
| Starting new task | `/clear` or `/new` |
| Context getting bloated | `/compact` |
| Switching topics | Start fresh |
| Long exploration | Use subagents |

## Context Commands

### /clear (or /new)

Starts a completely fresh conversation.

**When to use:**
- Starting a new, unrelated task
- AI seems confused or "stuck"
- After completing a major feature
- When changing projects

**Example:**
```
> /clear
> Now let's work on the payment integration...
```

### /compact

Summarizes the current conversation to reduce context while preserving key information.

**When to use:**
- Conversation is long but you need continuity
- AI starts forgetting recent instructions
- Before a complex task that needs context space

**Example:**
```
> /compact
# AI summarizes: "We've been refactoring the auth module.
# Completed: token validation, session management.
# Current: working on password reset."
```

**Important**: After compacting, verify AI retained critical context:
```
> What are we currently working on?
> What patterns should we follow?
```

### /context (if available)

Shows current context usage.

```
> /context
# Shows: tokens used, files loaded, rules active
```

## Strategic Context Management

### The Clear-Build-Clear Pattern

For large tasks:

```
1. /clear
2. Load only needed context
3. Complete focused subtask
4. /clear
5. Load context for next subtask
6. Repeat
```

**Example - Refactoring a Module:**

```
# Phase 1: Understand
> /clear
> Explain the architecture of src/services/auth/

# Phase 2: Plan
> /clear
> Create a refactoring plan for auth module.
> Focus only on the plan, don't implement yet.

# Phase 3: Implement (per component)
> /clear
> Implement part 1 of the plan: token validation refactor.
> Reference src/services/auth/tokens.ts

# Phase 4: Next component
> /clear
> Implement part 2: session management refactor.
```

### The Compact-Continue Pattern

For continuous work that needs history:

```
1. Work on task
2. When context feels heavy, /compact
3. Verify retained context
4. Continue working
5. Repeat as needed
```

**Example:**
```
> [Work on feature for 20 exchanges]
> /compact
> What's our current status? # Verify context
> Continue with the next component...
```

## Reducing Context Consumption

### File References

**Bad:** Reading entire directories
```
> Read all files in src/
```

**Good:** Targeted reads
```
> Read src/api/auth.ts and src/types/user.ts
```

### Error Outputs

**Bad:** Including full stack traces
```
> Here's the error: [500 lines of stack trace]
```

**Good:** Relevant excerpt
```
> Error at src/api/auth.ts:45: "Cannot read property 'email' of undefined"
```

### Search Results

**Bad:** Broad searches
```
> Find all files that might be related to users
```

**Good:** Specific searches
```
> Find functions named createUser or updateUser
```

### Conversation Style

**Bad:** Verbose explanations
```
> I was thinking that maybe we could possibly consider
> perhaps looking at potentially refactoring the
> authentication module if that seems like it might
> be a good idea...
```

**Good:** Concise requests
```
> Refactor src/auth/tokens.ts to use async/await
```

## Context-Efficient Prompts

### Include Just Enough

```
# Too little context
> Fix the bug

# Too much context
> There's a bug in our React application that uses TypeScript
> and Next.js 14 with the App Router and Prisma for the
> database and we're seeing an issue where... [continues for
> 500 words]

# Just right
> Fix null reference error in src/api/users.ts:45
> when user.profile is undefined
```

### Reference Files Instead of Pasting

```
# Bad: Pastes entire file
> Here's my file: [500 lines of code]

# Good: References
> In src/components/UserProfile.tsx, fix the useEffect
> that causes infinite re-renders
```

### Use Rules Files for Repeated Context

Instead of saying "use TypeScript strict mode" in every prompt, put it in CLAUDE.md once.

## Monitoring Context Health

### Signs of Healthy Context

- AI remembers recent instructions
- Responses are accurate and focused
- AI correctly references earlier work
- No confusion about file names/locations

### Signs of Overloaded Context

- AI forgets recent instructions
- Responses contradict earlier decisions
- AI mixes up similar files
- Increasing inaccuracy
- AI summarizes instead of acting

### Recovery Steps

1. **Light overload**: `/compact`
2. **Moderate overload**: `/clear` and reload essential context
3. **Severe confusion**: `/clear` and start completely fresh

## Tool-Specific Tips

### Claude Code

```
# Use plan mode to isolate planning from implementation
> /plan Implement user authentication

# Plan is stored, then you can /clear and implement with fresh context
```

### Cursor

- Use specific @mentions instead of @codebase
- Break Composer requests into smaller pieces
- Start new chat for unrelated questions

### Copilot

- Keep chat focused on current file
- Use @workspace sparingly
- Start new chat for new topics

---

Next: [Rules File Sizing](rules-file-sizing.md) | [Subagent Patterns](subagent-patterns.md)
