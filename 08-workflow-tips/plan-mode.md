# Plan Mode

## TL;DR

Plan mode is a structured approach where AI designs the implementation before coding. Available in:
- **Claude Code**: Built-in `/plan` command
- **Cursor**: Use Composer with explicit planning prompts
- **Copilot**: Use Chat with planning instructions

## What is Plan Mode?

Plan mode separates **thinking** from **doing**:

```
Normal Mode:
> Build X → [AI immediately writes code]

Plan Mode:
> /plan Build X → [AI creates plan] → [You approve] → [AI implements]
```

## Claude Code Plan Mode

### Starting Plan Mode

```bash
# Explicit plan mode
> /plan Add user notification preferences

# Claude enters plan mode:
# - Explores relevant code
# - Designs implementation approach
# - Presents plan for approval
# - Waits for your input
```

### What Happens in Plan Mode

1. **Analysis Phase**
   - Claude reads relevant files
   - Identifies patterns and conventions
   - Notes dependencies and integrations

2. **Planning Phase**
   - Creates step-by-step implementation plan
   - Lists files to create/modify
   - Explains design decisions

3. **Approval Phase**
   - Presents plan for review
   - Accepts modifications
   - Waits for explicit approval

4. **Implementation Phase**
   - Executes plan step by step
   - Checkpoints after each major step
   - Allows mid-course corrections

### Example Session

```
> /plan Add a "forgot password" feature

Claude:
I'll analyze the codebase and create an implementation plan.

[Analyzing...]

## Implementation Plan: Forgot Password

### Overview
Add password reset functionality with email verification.

### New Files
1. `src/lib/password-reset.ts` - Token generation and validation
2. `src/api/auth/forgot-password/route.ts` - Request handler
3. `src/api/auth/reset-password/route.ts` - Reset handler
4. `src/emails/password-reset.tsx` - Email template
5. `src/app/reset-password/page.tsx` - Reset form UI

### Modified Files
1. `src/app/login/page.tsx` - Add "forgot password" link
2. `prisma/schema.prisma` - Add PasswordReset model

### Implementation Steps
1. Add database model for reset tokens
2. Create token generation utility
3. Create forgot-password API endpoint
4. Create email template
5. Create reset-password API endpoint
6. Create reset password UI page
7. Add link to login page
8. Write tests

### Design Decisions
- Tokens expire in 1 hour
- One active token per user
- Rate limit: 3 requests per hour
- Follows existing email pattern in src/emails/

Approve this plan? (yes/no/modify)

> yes, but change token expiry to 30 minutes

Updated. Beginning implementation...
```

## Cursor Plan Mode

Cursor doesn't have explicit plan mode, but you can achieve similar results:

### Using Composer for Planning

```
> Before implementing anything, create a detailed plan for
> adding forgot password functionality.
>
> Include:
> - Files to create/modify
> - Implementation order
> - Design decisions
>
> Don't write any code yet - just the plan.
```

### Explicit Planning Workflow

```
# Step 1: Plan
> @codebase Create a plan for adding notification preferences.
> List files to create, files to modify, and implementation steps.

# Step 2: Review and refine
> Modify the plan: use WebSockets instead of polling

# Step 3: Implement
> Now implement step 1 from the plan
```

## Copilot Plan Mode

Use Copilot Chat with explicit planning prompts:

```
> /help I need to add user settings. Before we start coding,
> help me plan:
>
> 1. What existing code should we follow as a pattern?
> 2. What files will we need to create or modify?
> 3. What's the best order to implement this?
>
> Don't write code yet - just help me plan.
```

## When to Use Plan Mode

### Use Plan Mode For

| Scenario | Why |
|----------|-----|
| New features | Need to understand scope and approach |
| Multi-file changes | Coordination across components |
| Unfamiliar areas | Learn codebase while planning |
| Complex logic | Think through edge cases |
| Team review | Share plan before implementation |

### Skip Plan Mode For

| Scenario | Why |
|----------|-----|
| Bug fixes | Usually localized, quick fixes |
| Typo corrections | Trivial changes |
| Small refactors | Limited scope |
| Adding tests | Clear pattern to follow |

## Plan Mode Best Practices

### 1. Review Plans Carefully

Don't rubber-stamp plans. Look for:
- Missing edge cases
- Security implications
- Performance concerns
- Pattern violations

```
> I see the plan, but:
> - What happens if the user requests reset twice?
> - How do we prevent brute force token guessing?
> - Should we log reset attempts for security?
```

### 2. Iterate on Plans

Plans aren't final:
```
> The plan looks good, but let's modify step 3:
> Instead of a separate page, use a modal dialog.
```

### 3. Break Large Plans

For complex features:
```
> This feature is large. Let's break it into phases:
> Phase 1: Core functionality
> Phase 2: Admin interface
> Phase 3: Analytics
>
> Create a detailed plan just for Phase 1.
```

### 4. Save Plans for Reference

Copy plans to your task tracker or notes:
```markdown
## Task: PROJ-123 Forgot Password

### Plan
[Paste plan here]

### Status
- [x] Step 1: Database model
- [x] Step 2: Token utility
- [ ] Step 3: API endpoint
...
```

### 5. Use Plans for Code Review

Plans help reviewers understand intent:
```
PR Description:

## Implementation
Following the approved plan:
1. Added PasswordReset model (step 1)
2. Created token utility (step 2)
...

## Design Decisions
- 30-minute token expiry (discussed in plan)
- Rate limited to 3/hour (security requirement)
```

## Common Plan Mode Patterns

### Feature Plan

```
> /plan Add [feature] with:
> - [Requirement 1]
> - [Requirement 2]
> - [Requirement 3]
```

### Refactor Plan

```
> /plan Refactor [module] to:
> - [Goal 1]
> - [Goal 2]
>
> Ensure no functionality changes.
```

### Migration Plan

```
> /plan Migrate from [old system] to [new system]:
> - Maintain backwards compatibility
> - Include rollback strategy
> - Minimize downtime
```

### Integration Plan

```
> /plan Integrate [external service]:
> - Handle authentication
> - Add error handling
> - Include retry logic
> - Add monitoring
```

## Plan Mode vs Direct Implementation

| Aspect | Plan Mode | Direct |
|--------|-----------|--------|
| **Speed** | Slower start, faster overall | Quick start, may need rework |
| **Quality** | Higher (reviewed approach) | Variable |
| **Learning** | Better understanding | Less context |
| **Risk** | Lower (validated approach) | Higher for complex tasks |
| **Best for** | Complex, unfamiliar | Simple, familiar |

## Troubleshooting

### "Plan is too vague"

```
> This plan needs more detail. For step 3, specify:
> - Exact file paths
> - Function signatures
> - Error handling approach
```

### "Plan misses requirements"

```
> The plan is missing:
> - Mobile responsive design
> - Accessibility requirements
> - Performance targets
>
> Please revise.
```

### "Plan is too complex"

```
> Let's simplify. Start with MVP:
> - Core functionality only
> - No admin interface yet
> - Basic error handling
>
> Revise the plan for this scope.
```

---

Next: [Research-Plan-Implement](research-plan-implement.md) | [Multi-Agent Patterns](multi-agent.md)
