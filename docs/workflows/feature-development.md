# Feature Development Workflow

## TL;DR

1. **Plan first** - Use AI to understand scope and approach
2. **Branch always** - Isolate AI work
3. **Incremental development** - Build in small, testable chunks
4. **Review continuously** - Don't wait until the end

## Workflow Overview

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│  1. Plan    │───▶│  2. Setup   │───▶│  3. Build   │───▶│  4. Review  │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
      │                  │                  │                  │
      ▼                  ▼                  ▼                  ▼
 Understand          Create            Implement          Test &
 requirements        branch            features           iterate
```

## Phase 1: Planning

### Understand the Feature

**Claude Code:**
```
> I need to implement [feature description].

> First, help me understand:
> 1. What existing code relates to this feature?
> 2. What patterns should I follow?
> 3. What files will need to be created/modified?
> 4. What are the potential challenges?
```

**Cursor:**
```
> @codebase I need to add [feature]. What existing code
> should I look at for similar patterns?
```

### Create a Plan

**Claude Code (Plan Mode):**
```
> /plan Implement [feature] with:
> - [Requirement 1]
> - [Requirement 2]
> - [Requirement 3]
```

Review the plan, refine if needed, then approve.

### Break Down into Tasks

```
> Break this feature into implementation tasks, ordered by dependency:
> 1. Database/model changes
> 2. API endpoints
> 3. Business logic
> 4. Frontend components
> 5. Tests
```

## Phase 2: Setup

### Create Feature Branch

```bash
git checkout -b feature/[feature-name]
```

**Or with Claude Code:**
```
> Create a new branch called feature/[feature-name]
```

### Scaffold Structure

**If creating new files:**
```
> Create the file structure for this feature:
> - src/features/[name]/
>   - components/
>   - hooks/
>   - api/
>   - types.ts
>   - index.ts
```

### Set Up Types/Interfaces First

```
> Based on the requirements, create the TypeScript types
> and interfaces for this feature in src/features/[name]/types.ts
```

## Phase 3: Building

### Implement Incrementally

**Don't do this:**
```
> Build the entire user management feature with all CRUD operations,
> validation, error handling, and UI components
```

**Do this instead:**
```
# Step 1
> Create the User model and database migration

# Step 2 (after reviewing step 1)
> Now add the createUser API endpoint with validation

# Step 3 (after reviewing step 2)
> Add the getUser and listUsers endpoints

# And so on...
```

### Use Context Effectively

**Claude Code:**
```
> Looking at src/features/posts/api/createPost.ts as a reference,
> create a similar createUser endpoint in src/features/users/api/
```

**Cursor:**
```
> @features/posts/api/createPost.ts Create a similar endpoint
> for users following this pattern
```

**Copilot:**
```javascript
// Create user endpoint following the pattern in createPost.ts
// Validates: email (required, valid format), name (required, 2-50 chars)
// Returns: { success: boolean, user?: User, error?: string }
export async function createUser(data: CreateUserInput) {
  // Copilot will suggest based on comment context
```

### Test As You Build

```
> Now write tests for the createUser function we just built.
> Include:
> - Valid input creates user
> - Missing email returns error
> - Invalid email format returns error
> - Duplicate email returns error
```

### Handle Edge Cases

```
> Review createUser for edge cases we might have missed:
> - What if the database is unavailable?
> - What if email validation passes but DB rejects the format?
> - What about concurrent requests with the same email?
```

## Phase 4: Review & Iterate

### Self-Review with AI

```
> Review all the code we've written for this feature.
> Check for:
> - Security issues
> - Performance problems
> - Missing error handling
> - Inconsistencies with project patterns
```

### Run Tests

```
> Run the tests for the users feature and fix any failures
```

### Integration Testing

```
> Test the integration between the user API and frontend:
> - Create user from UI
> - Display in user list
> - Handle errors gracefully
```

### Prepare for PR

```
> Summarize the changes made for this feature,
> suitable for a PR description
```

## Tool-Specific Workflows

### Claude Code Workflow

```bash
# Start session
claude

# Plan
> /plan [feature description]

# Approve plan, then build step by step
> Implement step 1: [description]

# Review each step
> Review what we just built

# Continue
> Implement step 2: [description]

# When done
> /commit
> Create a PR for this feature
```

### Cursor Composer Workflow

1. Open Composer (`Cmd/Ctrl+I`)
2. Describe the complete feature
3. Review proposed file changes
4. Accept/reject per file
5. Iterate with follow-up requests

```
# Initial request
> Create a user settings page with:
> - Form to update profile (name, email, avatar)
> - API endpoint to save changes
> - Validation on both client and server
> - Success/error notifications

# Follow-up
> Add email verification when email is changed
```

### Copilot-Focused Workflow

1. Create files with descriptive names
2. Write detailed comments describing intent
3. Let Copilot complete the implementation
4. Use Chat for complex logic

```typescript
// src/features/users/api/updateUser.ts

import { db } from '@/lib/database';
import { validateUserUpdate } from './validation';
import { UserUpdateInput, UserUpdateResult } from './types';

/**
 * Updates user profile information
 *
 * Validates input, checks permissions, and updates the database.
 * If email is changed, triggers email verification flow.
 *
 * @param userId - The ID of the user to update
 * @param input - The fields to update
 * @returns Result with updated user or error
 */
export async function updateUser(
  userId: string,
  input: UserUpdateInput
): Promise<UserUpdateResult> {
  // Copilot will suggest implementation based on this context
```

## Common Patterns

### Database First

```
1. Design schema/migrations
2. Create models/types
3. Build repository/data access
4. Add API layer
5. Build UI
6. Add tests throughout
```

### API First

```
1. Define API contract (OpenAPI/types)
2. Create mock responses
3. Build frontend against mocks
4. Implement real API
5. Connect and test
```

### UI First (Prototype)

```
1. Build static UI components
2. Add interactivity with mock data
3. Define API needs from UI
4. Build API to match
5. Connect and test
```

## Tips for Success

### 1. Keep Context Fresh

If AI seems confused:
```
> /compact  # Claude Code
# Or start new conversation in other tools
```

### 2. Provide Examples

```
> Create a new endpoint similar to this example:
> [paste or reference working code]
```

### 3. Explain the "Why"

```
> We need to add rate limiting because:
> - Users are hitting the API too frequently
> - We want to limit to 100 requests per minute
> - Should return 429 with retry-after header
```

### 4. Checkpoint Progress

After each significant piece:
```
> Let's commit what we have so far before continuing

# Claude Code
> /commit
```

### 5. Know When to Stop

If the AI is struggling:
- Break the problem down further
- Provide more context
- Try a different approach
- Do it manually and use AI for review

---

Next: [Bug Fixing](bug-fixing.md) | [Refactoring](refactoring.md)
