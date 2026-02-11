# Debugging Tips

## TL;DR

Effective AI-assisted debugging:
1. **Provide full context** - Error messages, stack traces, steps to reproduce
2. **Ask "why" not just "fix"** - Understand root cause
3. **Verify fixes don't mask issues** - Address the cause, not symptoms
4. **Add regression tests** - Prevent recurrence

## The Debugging Process

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│  Reproduce  │───▶│   Locate    │───▶│ Understand  │───▶│    Fix      │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
      │                  │                  │                  │
      ▼                  ▼                  ▼                  ▼
 Document the        Find the          Why does          Implement
 exact issue       relevant code     this happen?       and verify
```

## Sharing Context with AI

### The Effective Bug Report

```markdown
## Bug: [Brief title]

### What should happen
[Expected behavior]

### What actually happens
[Actual behavior]

### Steps to reproduce
1. [Step 1]
2. [Step 2]
3. [Step 3]

### Error message
```
[Full error with stack trace]
```

### Environment
- OS: [macOS/Windows/Linux]
- Node: [version]
- Browser: [if relevant]

### What I've tried
- [Attempt 1]
- [Attempt 2]
```

### Example Debugging Prompt

**Claude Code:**
```
> I'm getting this error when users try to reset their password:

Error: Invalid token
    at verifyResetToken (src/lib/auth.ts:45)
    at resetPassword (src/api/auth/reset.ts:12)

Steps to reproduce:
1. Request password reset
2. Click email link immediately
3. Enter new password
4. Error appears

This works in dev but fails in production.
Help me understand why and fix it.
```

**Cursor:**
```
> @src/lib/auth.ts @src/api/auth/reset.ts

I'm debugging a token verification error. The verifyResetToken
function at line 45 fails in production but works in dev.
What could cause environment-specific behavior here?
```

## Understanding Root Causes

### Don't Just Fix Symptoms

```
# Bad: Surface-level fix
> Add a try-catch to hide this error

# Good: Find root cause
> Why is the token invalid? Walk me through the token
> lifecycle from creation to verification.
```

### Ask Probing Questions

```
> Help me understand:
> 1. Where is the token created?
> 2. How is it stored?
> 3. What validation happens?
> 4. What's different between dev and prod?
```

### Request Flow Analysis

```
> Trace the data flow for password reset:
> 1. User requests reset → what happens?
> 2. Token is created → where is it stored?
> 3. Email is sent → what's in the link?
> 4. User clicks link → how is token validated?
```

## Common Bug Patterns

### Null/Undefined Reference

```
TypeError: Cannot read property 'email' of undefined

> This user.email access fails. Help me find:
> 1. Where should user be set?
> 2. What code path leads to it being undefined?
> 3. Should we add validation, or fix the source?
```

### Race Condition

```
> I suspect a race condition:
> - Sometimes data saves correctly
> - Sometimes old data appears
> - More common under load
>
> What concurrent operations might cause this?
> Look at [relevant files] for shared state.
```

### Memory Leak

```
> The app slows down over time. Check for:
> - Event listeners not removed
> - Intervals not cleared
> - Subscriptions not unsubscribed
> - Growing caches without eviction
>
> Focus on [component/module].
```

### State Management

```
> UI shows stale data after [action].
>
> Walk me through:
> 1. Where is this state stored?
> 2. What triggers updates?
> 3. Why might update be skipped?
```

## Debugging by Tool

### Claude Code

**Full debugging session:**
```
> I'm debugging [issue]. Here's what I know:
>
> Error: [error message]
> Stack: [stack trace]
> Steps: [how to reproduce]
>
> Help me:
> 1. Find the root cause
> 2. Understand why it happens
> 3. Propose a proper fix
```

**Use plan mode for complex bugs:**
```
> /plan Debug and fix the authentication timeout
> that affects slow connections
```

### Cursor

**Reference relevant files:**
```
> @src/api/auth.ts @src/lib/session.ts
>
> Debug: Users get logged out randomly.
> Error from logs: "Session expired unexpectedly"
```

**Inline debugging:**
1. Select problematic code
2. Press `Cmd/Ctrl+K`
3. Ask: "Why might this fail when X is null?"

### Copilot Chat

```
> /explain Why does this code throw when user is undefined?

> @workspace Search for places where session.user
> might not be set before access
```

## Advanced Debugging Techniques

### Binary Search Debugging

```
> The bug appeared sometime recently. Help me:
> 1. What commits touched [relevant area]?
> 2. Let's bisect: does it work in commit [X]?
```

### Logging for Diagnosis

```
> Add strategic logging to trace this issue:
> - Log inputs to [function]
> - Log state at decision points
> - Include timestamps for timing issues
>
> Make logs easy to remove later.
```

### Hypothesis Testing

```
> I have three hypotheses:
> 1. Token expires too quickly
> 2. Clock skew between servers
> 3. Token not saved before redirect
>
> Help me write tests to confirm/eliminate each.
```

### Reproducing Intermittent Bugs

```
> This bug happens randomly (~10% of time).
>
> Help me:
> 1. Add logging to capture exact state when it occurs
> 2. Create conditions that make it more likely
> 3. Write a test that exercises the timing
```

## Fixing Bugs Properly

### Verify the Fix

```
> Before we commit this fix:
> 1. Does it address root cause or just symptom?
> 2. Could it break anything else?
> 3. Write a regression test that would catch this bug
```

### Regression Test

```
> Write a test that:
> 1. Would have failed before our fix
> 2. Passes now
> 3. Prevents this bug from returning
```

### Document the Fix

```
> Create a commit message that explains:
> - What was broken
> - Why it was broken
> - How this fix addresses it
```

## Bug Hunting Prompts

### General Bug

```
## Bug: [Title]

### Symptom
[What users see]

### Error
[Error message and stack trace]

### Reproduction
1. [Step 1]
2. [Step 2]

### Questions
1. What's the root cause?
2. Where should I look first?
3. How do I verify the fix?
```

### Performance Bug

```
## Performance: [What's slow]

### Metrics
- Current: X seconds
- Expected: Y seconds

### Conditions
[When it's slow]

### Questions
1. How can I profile this?
2. What's causing the slowdown?
3. What optimization would help most?
```

### Intermittent Bug

```
## Intermittent: [What happens]

### Frequency
[How often, under what conditions]

### Attempts to Reproduce
- [What I tried]
- [Results]

### Questions
1. What conditions might cause this intermittently?
2. What logging should I add?
3. What patterns cause intermittent bugs?
```

## Anti-Patterns to Avoid

### 1. Insufficient Context

```
# Bad
> Why is this broken?

# Good
> This function returns undefined when called with
> { user: null, timestamp: Date.now() }
> Expected: Error thrown
> Actual: Returns undefined, causes crash later
```

### 2. Accepting First Fix

```
# Bad
> Fix this null error

# Good
> Why is this null? Should we:
> A) Add null check here
> B) Ensure it's never null upstream
> C) Both?
```

### 3. Ignoring Side Effects

```
# Bad
> This works now, ship it

# Good
> This fix changes behavior of X.
> What else depends on X?
> Will this break anything?
```

### 4. No Regression Test

```
# Bad
> Bug fixed, moving on

# Good
> Write a test that would have caught this bug.
> Ensure it prevents regression.
```

## Quick Reference

| Issue Type | First Question to Ask |
|------------|----------------------|
| Null error | "Where should this value come from?" |
| Type error | "What type was expected vs received?" |
| Race condition | "What concurrent operations exist?" |
| Memory leak | "What's being created but not cleaned up?" |
| Slow code | "What's the algorithmic complexity?" |
| Intermittent | "What external factors vary?" |

---

Next: [Testing with AI](testing-with-ai.md) | [Permissions](permissions-and-settings.md)
