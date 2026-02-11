# Workflow: Pull Request Creation

## Overview

Streamlined PR creation with AI-generated descriptions and automated checks.

## The Command

**`.claude/commands/create-pr.md`:**
```markdown
---
description: Create a pull request
---

# Create Pull Request

## Step 1: Analyze Changes
1. Review all commits on this branch vs main
2. Understand what was changed and why
3. Identify breaking changes or migration needs

## Step 2: Run Checks
1. Run linting: npm run lint
2. Run type check: npm run typecheck
3. Run tests: npm test
4. Report any failures

## Step 3: Generate Description
Create PR description with:

## Summary
[2-3 sentence overview]

## Changes
- [Bullet points of what changed]

## Testing
- [How to test these changes]

## Checklist
- [ ] Tests added/updated
- [ ] Documentation updated (if needed)
- [ ] No breaking changes (or migration provided)

## Step 4: Create PR
1. Push branch if needed
2. Create PR with generated description
3. Request reviewers if specified in $ARGUMENTS
```

## Usage

### Basic PR

```
> /create-pr
```

### With Reviewers

```
> /create-pr --reviewers @alice @bob
```

### Draft PR

```
> /create-pr --draft
```

## Example Output

```
Analyzing branch feature/user-preferences...

Commits:
- Add notification_preferences column
- Create preferences API endpoints
- Add NotificationSettings component
- Add unit tests

Running checks...
✓ Linting passed
✓ Type check passed
✓ 45 tests passed

Creating PR...

---

## Summary
Adds user notification preferences, allowing users to control
which notifications they receive via email and push.

## Changes
- Added `notification_preferences` JSONB column to users table
- Created GET/PUT `/api/users/notification-preferences` endpoints
- Added `NotificationSettings` component to settings page
- Added 12 new unit tests for preferences functionality

## Testing
1. Go to Settings > Notifications
2. Toggle email notifications off
3. Verify setting persists after logout/login
4. Check email is not sent for disabled notifications

## Breaking Changes
None

## Migration
Run `npm run db:migrate` to add new column

---

PR #47 created: https://github.com/org/repo/pull/47
```

## Variations

### Hotfix PR

**`.claude/commands/hotfix-pr.md`:**
```markdown
---
description: Create hotfix PR to main
---

# Hotfix PR

CRITICAL: This is a hotfix for production.

1. Verify we're on a hotfix branch
2. Run ONLY critical tests
3. Create PR with HOTFIX label
4. Auto-request senior reviewer

Description format:
## 🚨 HOTFIX: [Issue]
**Production Impact**: [Description]
**Root Cause**: [Brief explanation]
**Fix**: [What this PR does]
```

### Feature PR from Ticket

```
> /create-pr --ticket PROJ-1234
# Includes ticket reference and acceptance criteria
```

## Best Practices

### 1. Run Checks First

Don't create PRs with failing tests:
```
# Good workflow
/create-pr
# Sees test failures
> Fix the failing tests
# Tests pass
/create-pr
```

### 2. Meaningful Descriptions

AI generates descriptions, but review them:
- Is the summary accurate?
- Are all changes listed?
- Are testing instructions clear?

### 3. Link to Context

```
> /create-pr --ticket PROJ-1234
# Links PR to ticket for traceability
```

---

Next: [Jira to Code](jira-to-code.md) | [Test Generation](test-generation.md)
