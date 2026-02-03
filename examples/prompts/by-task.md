# Example Prompts by Task

Real-world prompts that work well with AI coding assistants.

## Creating New Features

### Basic API Endpoint
```
Create a REST API endpoint for managing user notifications:

- GET /api/notifications - List user's notifications (paginated)
- GET /api/notifications/:id - Get single notification
- POST /api/notifications/mark-read - Mark notifications as read
- DELETE /api/notifications/:id - Delete a notification

Follow the patterns in @api/users.ts for:
- Input validation using Zod
- Error response format
- Auth middleware usage

Include TypeScript types for the notification model.
```

### React Component
```
Create a NotificationBell component that:

1. Shows an icon with unread count badge
2. Opens a dropdown with notification list on click
3. Marks notifications as read when opened
4. Has loading and empty states
5. Allows clicking a notification to navigate to related content

Use the patterns in @components/UserMenu.tsx for the dropdown.
Follow our Tailwind styling conventions.
```

### Database Migration
```
Create a database migration to add a notifications table:

Columns:
- id (uuid, primary key)
- user_id (uuid, foreign key to users)
- type (enum: 'info', 'warning', 'error', 'success')
- title (string, max 100 chars)
- message (text)
- read_at (timestamp, nullable)
- created_at (timestamp)
- metadata (jsonb, nullable)

Add index on user_id and created_at for the common query pattern.
Use Prisma schema format.
```

## Debugging

### Error Investigation
```
I'm getting this error when users try to upload files:

Error: ENOENT: no such file or directory, open '/tmp/uploads/abc123.jpg'

Stack trace:
  at Object.openSync (fs.js:498:3)
  at writeFileSync (fs.js:399:35)
  at uploadFile (src/services/upload.ts:45:5)

The upload worked in development but fails in production.
The /tmp/uploads directory exists and has correct permissions.

Help me understand:
1. Why this might fail in production but not development
2. What I should check
3. How to fix it
```

### Performance Issue
```
This query is taking 3+ seconds:

```sql
SELECT u.*, COUNT(p.id) as post_count
FROM users u
LEFT JOIN posts p ON p.user_id = u.id
WHERE u.created_at > '2024-01-01'
GROUP BY u.id
ORDER BY post_count DESC
LIMIT 20;
```

The users table has 500k rows, posts has 2M rows.
We have indexes on users.created_at and posts.user_id.

Help me:
1. Understand why it's slow
2. Suggest query optimizations
3. Suggest index changes if needed
```

## Code Review

### PR Review
```
Review PR #234 which adds password reset functionality.

Focus on:
1. Security of the reset token generation and storage
2. Expiration handling
3. Rate limiting to prevent abuse
4. Email content (no sensitive info leaked)
5. Error messages (don't reveal user existence)

Check against OWASP password reset guidelines.
```

### Security Review
```
Security review the authentication middleware in @middleware/auth.ts.

Check for:
- Token validation completeness
- Timing attack vulnerabilities
- Session fixation issues
- Proper error handling (no info leakage)
- Header validation

This is a critical path - be thorough.
```

## Refactoring

### Extract Common Logic
```
These three functions have duplicated validation logic:

- createUser (src/api/users.ts:45)
- updateUser (src/api/users.ts:89)
- createAdmin (src/api/admin.ts:23)

Extract the common email and name validation into a shared utility.
Keep the functions otherwise unchanged.
Maintain backward compatibility.
```

### Modernize Legacy Code
```
Modernize this callback-based code to use async/await:

```javascript
function fetchUserData(userId, callback) {
  db.query('SELECT * FROM users WHERE id = ?', [userId], (err, user) => {
    if (err) return callback(err);
    if (!user) return callback(new Error('User not found'));

    db.query('SELECT * FROM posts WHERE user_id = ?', [userId], (err, posts) => {
      if (err) return callback(err);
      callback(null, { user, posts });
    });
  });
}
```

Preserve the same functionality and error handling.
Add TypeScript types.
```

## Testing

### Unit Tests
```
Write unit tests for the calculateDiscount function in @utils/pricing.ts.

Test cases needed:
- No discount for orders under $50
- 10% discount for orders $50-$100
- 15% discount for orders over $100
- VIP customers get additional 5%
- Maximum discount is capped at 25%
- Negative amounts should throw
- Handle floating point precision

Use Jest and follow our test patterns in @tests/utils/
```

### Integration Tests
```
Write integration tests for the checkout flow:

1. User adds items to cart
2. User applies coupon code
3. User enters shipping address
4. User completes payment
5. Order is created and confirmation sent

Mock:
- Payment gateway (Stripe)
- Email service

Don't mock:
- Database
- Internal services

Test both success and failure scenarios.
```

## Documentation

### API Documentation
```
Document the /api/orders endpoints:

Include for each endpoint:
- HTTP method and path
- Request parameters (path, query, body)
- Request body schema with field descriptions
- Response schema with examples
- Error responses
- Authentication requirements
- Rate limits

Format as OpenAPI 3.0 YAML.
```

### Code Documentation
```
Add documentation to the PaymentService class in @services/payment.ts.

Add:
- Class overview with responsibility description
- JSDoc for each public method
- @param, @returns, @throws tags
- Usage examples for complex methods
- Note any side effects (API calls, database changes)
```

## Quick Tasks

### Generate Types from JSON
```
Generate TypeScript types from this API response:

{
  "user": {
    "id": "123",
    "email": "user@example.com",
    "profile": {
      "name": "John Doe",
      "avatar": "https://...",
      "bio": null
    },
    "settings": {
      "notifications": true,
      "theme": "dark"
    }
  },
  "posts": [
    {
      "id": "456",
      "title": "Hello World",
      "publishedAt": "2024-01-15T10:00:00Z"
    }
  ]
}

Make nullable fields explicit (like bio).
Use specific types where appropriate (not just string for everything).
```

### Write Commit Message
```
Write a commit message for these changes:

- Added password reset endpoint (POST /api/auth/reset-password)
- Added email template for password reset
- Added rate limiting (5 requests per hour per email)
- Added tests for the reset flow
- Updated API documentation

Use conventional commits format.
Keep subject under 50 chars, add body with details.
```

### Create README Section
```
Write a README section for the notification system we just built:

Cover:
- What it does
- How to set it up
- API endpoints available
- Configuration options
- Example usage

Keep it concise - developers should be able to get started quickly.
```
