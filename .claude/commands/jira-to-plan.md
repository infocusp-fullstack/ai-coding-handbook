---
description: Read Jira ticket and create implementation plan
---

# Jira to Plan

Create an implementation plan for Jira ticket:

$ARGUMENTS

## Workflow

### Step 1: Read and Understand

1. Fetch ticket details from Jira using atlassian mcp
2. Extract key information:
   - Title and description
   - Acceptance criteria
   - Related tickets or dependencies
   - Comments with important context
   - Labels and priority

3. Summarize what needs to be built in 2-3 sentences

### Step 2: Explore Codebase

Use parallel subagents to explore relevant areas:

1. **Domain Exploration**: Find existing similar features
2. **Architecture**: Understand how components interact
3. **Patterns**: Identify conventions to follow

### Step 3: Identify Changes

Based on exploration, identify:

- Files to modify
- Files to create
- Database changes needed
- API changes needed
- Tests to write
- Documentation to update

### Step 4: Create Plan

Structure the plan as:

```markdown
## Implementation Plan for [TICKET-ID]: [Title]

### Overview
[2-3 sentence summary of what will be built]

### Acceptance Criteria Checklist
- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

### Implementation Steps

#### Step 1: [Name]
**Files**: [list files to create/modify]
**Description**: [what to implement]
**Testing**: [how to verify this step]
**Estimated Complexity**: Low/Medium/High

#### Step 2: [Name]
...

### Dependencies
- [ ] Depends on: [other tickets if any]
- [ ] Blocks: [tickets this will block]

### Open Questions
[Questions that need clarification before implementation]

### Risks and Considerations
- [Potential issues to watch for]
- [Performance implications]
- [Breaking changes]

### Definition of Done
- [ ] All acceptance criteria met
- [ ] Tests written and passing
- [ ] Code reviewed
- [ ] Documentation updated
```

### Step 5: Review with User

Present the plan and ask:

1. "Does this plan cover all requirements?"
2. "Are there any edge cases I'm missing?"
3. "Should we split this into multiple PRs?"
4. "Any concerns about the approach?"

Wait for approval before proceeding to implementation.

## Example Output

```markdown
## Implementation Plan for PROJ-123: Add User Notifications

### Overview
Implement a notification system allowing users to receive in-app and email notifications for important events.

### Acceptance Criteria Checklist
- [ ] Users can view notifications in a dropdown
- [ ] Unread count shown in navbar
- [ ] Clicking notification marks it as read
- [ ] Email sent for critical notifications

### Implementation Steps

#### Step 1: Database Schema
**Files**: 
- Create: `prisma/migrations/xxx_add_notifications/migration.sql`
- Modify: `prisma/schema.prisma`

**Description**:
Add `Notification` table with:
- id, userId, type, title, message, read, createdAt
- Index on userId + read for fast queries

**Testing**: Run migration, verify table created

#### Step 2: API Endpoints
**Files**:
- Create: `src/app/api/notifications/route.ts`
- Create: `src/app/api/notifications/[id]/read/route.ts`

**Description**:
- GET /api/notifications - List with pagination
- PATCH /api/notifications/:id/read - Mark as read
- Filter by user, sort by createdAt desc

**Testing**: Test endpoints with curl/Postman

#### Step 3: UI Components
**Files**:
- Create: `src/components/NotificationBell.tsx`
- Create: `src/components/NotificationList.tsx`
- Create: `src/components/NotificationItem.tsx`
- Modify: `src/components/Navbar.tsx`

**Description**:
- Bell icon with unread count badge
- Dropdown showing recent notifications
- Click to mark read and navigate

**Testing**: Visual testing, click interactions

#### Step 4: Email Integration
**Files**:
- Modify: `src/lib/notifications/email.ts`
- Modify: `src/lib/notifications/service.ts`

**Description**:
- Send email for 'critical' type notifications
- Use existing email service

**Testing**: Verify emails sent in staging

### Dependencies
- [ ] Depends on: PROJ-122 (Email service setup)

### Open Questions
1. How many notifications to show in dropdown? (suggest: 5)
2. Should we group similar notifications?
3. Email template design - use existing or new?

### Risks and Considerations
- High volume of notifications could impact performance
- Consider pagination from start
- Email rate limiting for bulk events

### Definition of Done
- [ ] All acceptance criteria met
- [ ] Unit tests for API endpoints
- [ ] Component tests for UI
- [ ] Manual testing in staging
- [ ] PR reviewed and approved
```

## Best Practices

### Keep Plans Focused
- Break large tickets into multiple smaller tickets
- Each plan should be implementable in 1-3 days
- Prefer 5 small PRs over 1 giant PR

### Consider Edge Cases
- What if the user has no notifications?
- What if the API is slow?
- What if the email service is down?

### Include Testing Strategy
Every step should specify:
- Unit tests
- Integration tests
- Manual testing steps

### Document Decisions
If you make assumptions:
- Document them in the plan
- Ask user to confirm
- Update plan based on feedback

## Usage Tips

### For Small Tickets
```
> /jira-to-plan PROJ-456
# Creates concise plan for simple features
```

### For Complex Tickets
```
> /jira-to-plan PROJ-789
# May suggest breaking into sub-tickets
```

### Iterating on Plan
```
> After seeing the plan, I think we should:
> 1. Add caching layer
> 2. Change step 2 to use batch operations
```

## Next Steps

After plan approval:
1. Use `/plan` mode to implement
2. Or implement step by step manually
3. Mark acceptance criteria as you complete them

---

**Note**: This command focuses on PLANNING only. For full implementation workflow, see `/jira-implement` command.
