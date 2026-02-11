# Workflow: Jira Ticket to Code

## Overview

Automate the flow from Jira ticket to implemented feature using MCP and custom commands.

## Prerequisites

- Atlassian MCP configured (see [MCP Setup](../../03-mcp-servers/setup-guide.md))
- Custom command for workflow

## The Workflow

```
Read Jira Ticket → Understand Requirements → Plan Implementation → Code → PR
```

## Setup

### 1. Configure Atlassian MCP

```json
{
  "mcpServers": {
    "atlassian": {
      "type": "url",
      "url": "https://mcp.atlassian.com/v1/sse"
    }
  }
}
```

### 2. Create Command

**`.claude/commands/jira-implement.md`:**
```markdown
---
description: Implement a Jira ticket
---

# Jira Implementation Workflow

For ticket $ARGUMENTS:

## Step 1: Understand
1. Read the ticket details from Jira
2. Summarize: What needs to be built?
3. Identify acceptance criteria
4. Ask clarifying questions if needed

## Step 2: Explore
1. Find related code in the codebase
2. Identify files to modify/create
3. Understand existing patterns

## Step 3: Plan
1. Create implementation plan
2. Break into small, testable steps
3. Wait for approval before coding

## Step 4: Implement
For each step in the plan:
1. Implement the change
2. Write/update tests
3. Verify tests pass

## Step 5: Complete
1. Review all changes
2. Create commit with ticket reference
3. Prepare PR description

Reference ticket in commit: "[TICKET-ID] Description"
```

## Usage

```
> /jira-implement PROJ-1234
```

### What Happens

1. **AI reads ticket from Jira:**
   ```
   Fetching PROJ-1234...

   Title: Add user notification preferences
   Description: Users should be able to configure which
   notifications they receive...
   Acceptance Criteria:
   - [ ] User can toggle email notifications
   - [ ] User can toggle push notifications
   - [ ] Settings persist across sessions
   ```

2. **AI explores codebase:**
   ```
   Found related code:
   - src/features/settings/ (user settings)
   - src/services/notifications/ (notification service)
   - src/api/users/preferences (similar endpoint)
   ```

3. **AI proposes plan:**
   ```
   Implementation Plan:

   1. Database: Add notification_preferences to users table
   2. API: Create GET/PUT /api/users/notification-preferences
   3. UI: Add NotificationSettings component
   4. Integration: Wire up to existing settings page

   Approve this plan?
   ```

4. **You approve, AI implements**

5. **AI creates PR:**
   ```
   Created PR #45: [PROJ-1234] Add notification preferences

   Summary:
   - Added notification_preferences column
   - Created API endpoints
   - Added settings UI component
   - Added tests for all new code
   ```

## Tips

### Verify Understanding

Before approving the plan:
```
> What are the edge cases you'll handle?
> What happens if the database migration fails?
```

### Iterate on Plan

```
> In step 3, also add a "reset to defaults" button
```

### Manual Override

If AI misunderstands:
```
> Stop. The ticket is asking for X, not Y.
> Let me clarify: [explanation]
```

## Variations

### Quick Implementation

For simple tickets:
```
> /jira-implement PROJ-1234 --quick
# Skip detailed planning for small tasks
```

### Research Only

Just understand without implementing:
```
> Read PROJ-1234 and tell me what's needed
> Don't implement yet
```

---

Next: [PR Workflow](pr-workflow.md) | [Test Generation](test-generation.md)
