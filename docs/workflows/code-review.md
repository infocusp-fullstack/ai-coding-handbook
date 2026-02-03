# Code Review Workflow

## TL;DR

1. **AI first pass** - Automated checks for common issues
2. **Human review** - Architecture, business logic, context
3. **Iterate** - Address feedback, re-review as needed
4. **Document** - Capture decisions for future reference

## Review Process Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                      Code Review Pipeline                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  PR Created                                                     │
│      │                                                          │
│      ▼                                                          │
│  ┌─────────────┐                                               │
│  │  Automated  │  Linting, type checking, tests                │
│  │   Checks    │                                               │
│  └──────┬──────┘                                               │
│         │                                                       │
│         ▼                                                       │
│  ┌─────────────┐                                               │
│  │  AI Review  │  Security, performance, patterns              │
│  │ (Optional)  │                                               │
│  └──────┬──────┘                                               │
│         │                                                       │
│         ▼                                                       │
│  ┌─────────────┐                                               │
│  │   Human     │  Architecture, business logic, UX             │
│  │   Review    │                                               │
│  └──────┬──────┘                                               │
│         │                                                       │
│         ▼                                                       │
│  ┌─────────────┐                                               │
│  │  Approval   │  Merge when all checks pass                   │
│  │  & Merge    │                                               │
│  └─────────────┘                                               │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## For PR Authors

### Before Submitting

**Self-review with AI:**

```
> Review the changes I'm about to submit.
> Focus on:
> - Bugs or logic errors
> - Security issues
> - Missing error handling
> - Inconsistencies with existing patterns
```

**Claude Code:**
```
> Review the diff between this branch and main
```

**Cursor:**
```
> @git Review the changes on this branch compared to main
```

### Create Quality PRs

**Generate PR description:**

```
> Summarize the changes on this branch for a PR description.
> Include:
> - What changed and why
> - How to test
> - Any breaking changes
> - Screenshots if UI changed
```

**Or use Claude Code:**
```
> Create a PR for this branch with a descriptive summary
```

### Respond to Feedback

**Understand feedback:**
```
> The reviewer commented: "[reviewer comment]"
> on this code: [code snippet]
>
> Help me understand their concern and suggest how to address it.
```

**Implement suggestions:**
```
> The reviewer asked me to [feedback].
> Implement this change while maintaining [constraints].
```

## For Reviewers

### Initial Review

**Quick overview:**
```
> Give me an overview of what this PR does based on the changes.
```

**Focused review:**
```
> Review this PR focusing on:
> - Security implications
> - Performance impact
> - Error handling completeness
> - Test coverage
```

### Using Claude Code

**Review a GitHub PR:**
```
> /review-pr 123
```

**Review with specific focus:**
```
> Review PR #123 focusing on:
> - Authentication security
> - Rate limiting implementation
> - Error message exposure
```

### Using Cursor

**Review changed files:**
```
> @git Review the files changed in the latest commit.
> Check for common issues.
```

### Using Copilot

**In GitHub PR view:**
- Copilot suggests improvements inline
- Use Copilot code review (Enterprise)

**In VS Code:**
```
> @workspace /review Review the changes in this PR
```

## Review Checklists

### Standard Review

```markdown
## Functionality
- [ ] Code does what the PR claims
- [ ] Edge cases handled
- [ ] No obvious bugs

## Code Quality
- [ ] Follows project conventions
- [ ] No unnecessary complexity
- [ ] Appropriate abstractions
- [ ] No code duplication

## Security
- [ ] Input validation present
- [ ] No hardcoded secrets
- [ ] Auth/authz correct
- [ ] No SQL/XSS vulnerabilities

## Performance
- [ ] No N+1 queries
- [ ] No memory leaks
- [ ] Appropriate caching
- [ ] No blocking operations in async code

## Testing
- [ ] Tests included for new code
- [ ] Tests cover edge cases
- [ ] Existing tests still pass

## Documentation
- [ ] Code is self-documenting or commented
- [ ] API changes documented
- [ ] README updated if needed
```

### Security-Focused Review

```
> Review this code specifically for security issues:

## Input Handling
- [ ] All user input validated
- [ ] Input sanitized before use
- [ ] No direct SQL string building
- [ ] No eval() or similar

## Authentication
- [ ] Auth required on protected endpoints
- [ ] Tokens properly validated
- [ ] Session handling secure

## Authorization
- [ ] Resource ownership verified
- [ ] Role checks in place
- [ ] No privilege escalation paths

## Data Exposure
- [ ] No sensitive data in logs
- [ ] Appropriate data filtering
- [ ] Error messages don't leak info
```

### Performance-Focused Review

```
> Review this code for performance:

## Database
- [ ] Queries are indexed
- [ ] No N+1 query patterns
- [ ] Pagination implemented
- [ ] Connection pooling used

## Memory
- [ ] No unbounded arrays/objects
- [ ] Event listeners cleaned up
- [ ] Large objects not held unnecessarily

## Network
- [ ] Appropriate caching headers
- [ ] Payload sizes reasonable
- [ ] Batch operations where possible
```

## AI-Assisted Review Workflows

### Author Self-Review

```
1. Complete feature
2. Run: > Review my changes before I submit
3. Address issues found
4. Submit PR
```

### First-Pass AI Review

```
1. PR submitted
2. Reviewer runs: > /review-pr [number]
3. AI identifies issues
4. Human verifies AI findings
5. Human adds context-specific comments
```

### Collaborative Review

```
1. Human identifies concern
2. Ask AI: > Is this approach safe? [code snippet]
3. AI provides analysis
4. Human makes final decision
```

## Common Review Feedback

### Giving Feedback

**Be specific:**
```
# Vague
"This could be better"

# Specific
"Consider extracting this validation logic into a separate
function since it's duplicated in createUser and updateUser"
```

**Suggest alternatives:**
```
# Just criticism
"This is inefficient"

# With suggestion
"This loops through users twice. Consider combining into
a single pass: users.reduce((acc, user) => {...}, {})"
```

**Ask questions when unsure:**
```
"I'm not familiar with this pattern. Could you explain
why we're using a factory here instead of direct instantiation?"
```

### Receiving Feedback

**Understand before responding:**
```
> The reviewer said: "[feedback]"
> Help me understand if this is:
> 1. A valid concern I should address
> 2. A style preference
> 3. Based on a misunderstanding I should clarify
```

**Implement feedback:**
```
> Address this review comment: "[feedback]"
> In the context of: [code]
```

## Review Templates

### PR Review Template

```markdown
## Summary
[Brief summary of what the PR does]

## Review Focus
- [x] Functionality
- [x] Security
- [x] Performance
- [x] Code quality
- [ ] Tests (not included)

## Findings

### Must Fix
1. [Critical issue]

### Should Fix
1. [Important improvement]

### Consider
1. [Suggestion]

## Questions
1. [Question about approach]

## Verdict
- [ ] Approve
- [x] Request changes
- [ ] Needs discussion
```

### Quick Review Notes

```markdown
LGTM with minor suggestions:
- Line 45: Consider null check
- Line 78: Typo in error message
- General: Nice use of the repository pattern
```

---

Next: [Refactoring](refactoring.md) | [Code Review Best Practices](../best-practices/code-review-with-ai.md)
