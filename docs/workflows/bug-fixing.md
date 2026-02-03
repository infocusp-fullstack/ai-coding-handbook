# Bug Fixing Workflow

## TL;DR

1. **Reproduce first** - Confirm and understand the bug
2. **Gather context** - Collect error messages, logs, steps
3. **Locate the issue** - Use AI to find relevant code
4. **Understand root cause** - Don't just fix symptoms
5. **Fix and verify** - Test the fix thoroughly

## Bug Fixing Process

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│  Reproduce  │───▶│   Locate    │───▶│    Fix      │───▶│   Verify    │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
      │                  │                  │                  │
      ▼                  ▼                  ▼                  ▼
  Confirm the        Find the           Implement         Test and
  bug exists         root cause         the fix           prevent
```

## Phase 1: Reproduce the Bug

### Document What You Know

Before asking AI for help, gather:

```markdown
## Bug Report

### Expected Behavior
[What should happen]

### Actual Behavior
[What actually happens]

### Steps to Reproduce
1. [Step 1]
2. [Step 2]
3. [Step 3]

### Error Message (if any)
[Paste full error]

### Environment
- Browser/Node version
- OS
- Relevant configuration
```

### Ask AI to Help Reproduce

```
> I'm investigating a bug where [description].
> The error message is: [error]
> What should I look at to reproduce this?
```

## Phase 2: Locate the Issue

### Share Context with AI

**Claude Code:**
```
> I'm seeing this error:

[Paste error with stack trace]

> Steps to reproduce:
> 1. [Step 1]
> 2. [Step 2]

> Help me find where this is happening and why.
```

**Cursor:**
```
> @codebase I'm getting this error: [error]
> When I [action]. Where should I look?
```

### Follow the Stack Trace

```
> Looking at this stack trace:

TypeError: Cannot read property 'email' of undefined
    at getUserEmail (src/utils/user.ts:45)
    at handleLogin (src/api/auth.ts:23)
    at processRequest (src/middleware/handler.ts:12)

> Walk me through what's happening and where the bug likely is.
```

### Search for Related Code

```
> Find all places in the codebase where we access user.email
> without checking if user exists first.
```

### Understand the Flow

```
> Explain the data flow when a user logs in.
> I need to understand how user data gets from the
> login form to getUserEmail().
```

## Phase 3: Understand Root Cause

### Don't Just Fix Symptoms

**Bad approach:**
```
> Just add a null check to fix this error
```

**Better approach:**
```
> This is failing because user is undefined.
> Help me understand:
> 1. Why is user undefined at this point?
> 2. Where should user be set?
> 3. What condition causes it to be missing?
```

### Ask "Why" Questions

```
> Why would user be undefined when getUserEmail is called?
> Looking at the login flow, when should user be populated?
```

### Check for Similar Issues

```
> Are there other places in the code that might have
> the same issue of accessing user properties without
> checking if user exists?
```

## Phase 4: Implement the Fix

### Propose Before Implementing

```
> Based on our analysis, I think the fix is to:
> [Proposed solution]
>
> Does this address the root cause, or are we just
> masking the symptom?
```

### Implement Carefully

**Simple fix:**
```
> Fix the null reference in getUserEmail by adding
> appropriate null checking and returning a meaningful
> error when user is not found.
```

**Complex fix:**
```
> The root cause is that the session middleware isn't
> running before this endpoint. Let's fix this by:
> 1. First, check the middleware ordering
> 2. Then add the session middleware to this route
> 3. Finally, add defensive coding in getUserEmail
```

### Consider Edge Cases

```
> What edge cases should I test for this fix?
> What other scenarios might break similarly?
```

## Phase 5: Verify the Fix

### Write a Regression Test

```
> Write a test that would have caught this bug.
> The test should:
> - Reproduce the original failure condition
> - Verify the fix prevents the issue
> - Serve as a regression test going forward
```

### Test Related Functionality

```
> What other functionality might be affected by this change?
> Let's make sure we didn't break anything else.
```

### Review the Fix

```
> Review this fix for:
> - Correctness: Does it address root cause?
> - Completeness: Are there similar issues elsewhere?
> - Side effects: Could this break anything?
> - Performance: Any performance implications?
```

## Tool-Specific Debugging

### Claude Code

**Full debugging session:**
```
> I'm debugging an issue where [description].

> Error: [paste error]

> Let me share relevant files:
> - src/api/auth.ts (the failing code)
> - src/utils/user.ts (related utility)

> Help me:
> 1. Understand the flow
> 2. Find the root cause
> 3. Propose a fix
```

**Using plan mode for complex bugs:**
```
> /plan Debug and fix the authentication timeout issue
> that occurs when users have slow connections
```

### Cursor

**Codebase search:**
```
> @codebase Find all error handling for API failures
> I'm debugging why errors aren't being logged properly
```

**Inline debugging:**
1. Select the problematic code
2. Press `Cmd/Ctrl+K`
3. Type: "Debug why this fails when user is null"

### Copilot Chat

**Explain and fix:**
```
> /explain Why does this code throw when user is undefined?

> /fix Handle the case where user might be undefined
```

## Common Bug Patterns

### Null/Undefined Reference

```
> Find all places where we access nested properties
> without null checks. For example:
> - user.profile.email (user or profile could be null)
> - response.data.items[0] (data or items could be missing)
```

### Race Condition

```
> I suspect a race condition where [operation A] and
> [operation B] are both modifying [shared state].
> Help me:
> 1. Confirm this is a race condition
> 2. Find where the concurrent access happens
> 3. Suggest a fix (mutex, queue, etc.)
```

### State Management Issue

```
> The UI shows stale data after [action].
> Walk me through the state update flow:
> 1. Where is this state stored?
> 2. What triggers updates?
> 3. Why might it not update in this case?
```

### API/Network Error

```
> Users report intermittent [error] when [action].
> Help me add:
> 1. Better error logging to capture details
> 2. Retry logic for transient failures
> 3. Graceful degradation when service is down
```

### Memory Leak

```
> The app slows down over time. I suspect a memory leak.
> Look at [component/module] and check for:
> - Event listeners not being cleaned up
> - Intervals/timeouts not being cleared
> - Subscriptions not being unsubscribed
> - Growing arrays or objects
```

## Debug Prompt Templates

### General Bug

```
## Bug: [Title]

### Symptom
[What users see / what error occurs]

### Error Message
[Full error with stack trace]

### Steps to Reproduce
1. [Step 1]
2. [Step 2]

### What I've Tried
- [Attempt 1]
- [Attempt 2]

### Questions
1. What's the likely root cause?
2. Where should I look first?
3. How can I verify the fix?
```

### Performance Bug

```
## Performance Issue: [Title]

### Symptom
[What's slow, how slow]

### Metrics
- Current: [X] seconds
- Expected: [Y] seconds

### Suspected Area
[What code/feature seems slow]

### Questions
1. How can I profile this?
2. What's causing the slowdown?
3. What optimization would help most?
```

### Intermittent Bug

```
## Intermittent Bug: [Title]

### Symptom
[What happens, how often]

### Conditions
[When it seems to happen more]

### Failed Attempts to Reproduce
- [Attempt 1]
- [Attempt 2]

### Questions
1. What conditions might cause this intermittently?
2. What logging should I add to capture it?
3. What patterns cause intermittent bugs like this?
```

---

Next: [Code Review](code-review.md) | [Refactoring](refactoring.md)
