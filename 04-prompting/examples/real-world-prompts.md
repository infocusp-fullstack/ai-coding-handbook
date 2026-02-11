# Real-World Prompts

Practical prompts people actually use, organized by task.

## Feature Development

### Starting a New Feature

```
I need to add user notification preferences to our app.

Before coding, explore:
1. How are user settings currently stored?
2. What notification types exist?
3. Where would this fit in the UI?

Return a summary, then we'll plan the implementation.
```

### Multi-File Feature

```
Create a "saved searches" feature:

Database:
- saved_searches table (id, user_id, name, query, created_at)

API:
- GET /api/saved-searches - list user's saved searches
- POST /api/saved-searches - create new
- DELETE /api/saved-searches/:id - delete

UI:
- Save button on search results page
- Dropdown to select saved search
- Manage saved searches in settings

Follow existing patterns. Start with database, then API, then UI.
```

### Adding to Existing Feature

```
Our checkout flow needs address validation.

Current: User enters address, we save it directly
New: Validate against postal service API before saving

Look at src/api/checkout.ts and add:
- validateAddress() using USPS API
- Call validation before saving
- Show validation errors to user
- Allow override for "use anyway"
```

## Bug Fixes

### From Error Report

```
Production error:

TypeError: Cannot read property 'map' of undefined
  at OrderList (src/components/OrderList.tsx:23)

Users report it happens when they have no orders.

Fix it to show "No orders yet" message instead of crashing.
```

### Intermittent Issue

```
Intermittent bug: Sometimes login fails with "Invalid token"
even with correct credentials.

Happens ~10% of the time. Seems more common under load.

1. Add logging to identify when this occurs
2. Find the race condition or timing issue
3. Propose a fix
```

### Performance Bug

```
The product list page is slow:
- 5+ seconds to load
- 2MB response size
- Happens with large catalogs (1000+ products)

Investigate and fix:
1. Check for N+1 queries
2. Add pagination if missing
3. Reduce response payload
```

## Code Review

### PR Review

```
Review PR #234 "Add payment retry logic"

Focus on:
- Race conditions (concurrent retries)
- Error handling (partial failures)
- Idempotency (same charge twice)
- Audit logging (compliance)

This is payment-critical code, be thorough.
```

### Security Review

```
Security review for src/api/auth/:

Check for:
- Password handling (hashing, comparison)
- Token generation (entropy, expiration)
- Session management (fixation, hijacking)
- Input validation (injection)
- Rate limiting (brute force)

Flag anything concerning with severity level.
```

## Testing

### Generate Tests for Function

```
Write comprehensive tests for processPayment() in
src/services/payment.ts:

Test cases:
- Successful payment
- Declined card
- Expired card
- Network timeout
- Idempotency (same request twice)
- Concurrent requests
- Refund after payment

Use Jest. Mock the Stripe API.
```

### E2E Test Generation

```
Generate Playwright E2E tests for checkout:

Flow:
1. Add product to cart
2. Go to checkout
3. Fill shipping address
4. Select shipping method
5. Enter payment info
6. Place order
7. Verify confirmation page

Test both success and common error cases.
```

## Documentation

### API Documentation

```
Generate API documentation for src/api/users/:

For each endpoint:
- HTTP method and path
- Request parameters
- Request body schema (with examples)
- Response schema (success and error)
- Authentication requirements
- Rate limits

Format as markdown.
```

### Code Documentation

```
Add JSDoc documentation to all exported functions in
src/utils/format.ts:

Include:
- Function description
- @param for each parameter
- @returns description
- @throws for errors
- @example with usage

Focus on why, not just what.
```

## Refactoring

### Extract Module

```
src/services/user.ts is 800 lines. Split it:

- userAuth.ts - login, logout, password reset
- userProfile.ts - get/update profile
- userPreferences.ts - settings, notifications
- userValidation.ts - shared validation logic

Keep the same external interface. Update imports
in dependent files.
```

### Modernize Code

```
Modernize src/api/legacy/orders.ts:

Current:
- Callback-based async
- var declarations
- string concatenation for queries

Convert to:
- async/await
- const/let
- Template literals
- Parameterized queries

Don't change behavior. Add tests if missing.
```

## Architecture

### Design Discussion

```
We need to add real-time notifications.

Options:
1. WebSockets (socket.io)
2. Server-Sent Events
3. Polling

Our stack: Next.js, Express, PostgreSQL, hosted on Vercel

Compare options for our use case. Consider:
- Scalability
- Complexity
- Vercel compatibility
- Cost

Recommend one with rationale.
```

### Data Modeling

```
Design the database schema for a booking system:

Requirements:
- Users can book appointments
- Appointments have time slots
- Some slots are recurring (weekly)
- Users can cancel/reschedule
- Providers set availability

Show:
- Table definitions
- Relationships
- Indexes needed
- Edge cases to handle
```

## DevOps

### Docker Setup

```
Create Docker configuration for our app:

Stack:
- Next.js frontend
- Express API
- PostgreSQL database
- Redis for caching

Include:
- Dockerfile for each service
- docker-compose.yml for local dev
- Environment variable handling
- Volume mounts for persistence
```

### CI Pipeline

```
Create GitHub Actions workflow:

On PR:
- Run linting
- Run type checking
- Run unit tests
- Run E2E tests
- Build and check bundle size

On merge to main:
- All above plus
- Deploy to staging
- Run smoke tests

Use caching for dependencies.
```

---

Next: [Good vs Bad Examples](good-vs-bad.md) | [Prompting Principles](../prompting-principles.md)
