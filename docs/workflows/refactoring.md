# Refactoring Workflow

## TL;DR

1. **Understand first** - Know what you're changing and why
2. **Test coverage** - Ensure tests exist before refactoring
3. **Small steps** - Make incremental, verifiable changes
4. **Preserve behavior** - Refactoring shouldn't change functionality

## Refactoring vs. Rewriting

| Refactoring | Rewriting |
|-------------|-----------|
| Small, incremental changes | Large-scale replacement |
| Preserves behavior | May change behavior |
| Low risk | High risk |
| Continuous process | One-time event |
| Tests guide changes | May need new tests |

**AI is excellent for refactoring but dangerous for rewrites.**

## Safe Refactoring Process

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│  1. Assess  │───▶│  2. Prepare │───▶│ 3. Refactor │───▶│  4. Verify  │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
      │                  │                  │                  │
      ▼                  ▼                  ▼                  ▼
  Understand         Add tests          Small, safe        Run tests
  the code          if missing          changes            continuously
```

## Phase 1: Assessment

### Understand What You're Refactoring

**Claude Code:**
```
> Explain the architecture of src/services/auth/.
> How do the files relate to each other?
> What would break if I changed the interface of AuthService?
```

**Cursor:**
```
> @services/auth Explain how this authentication module works
> and what depends on it.
```

### Identify Refactoring Opportunities

```
> Analyze src/services/auth/ for refactoring opportunities:
> - Code duplication
> - Complex conditionals
> - Long functions
> - Missing abstractions
> - Unclear naming

> Prioritize by impact vs. risk.
```

### Understand Dependencies

```
> What other code depends on AuthService?
> Show me all imports and usages.
```

## Phase 2: Preparation

### Ensure Test Coverage

**Check existing coverage:**
```
> What test coverage exists for AuthService?
> What behaviors are untested?
```

**Add missing tests:**
```
> Before refactoring, add tests for the current behavior of
> AuthService.login(). Cover:
> - Successful login
> - Invalid credentials
> - Locked account
> - Rate limiting
```

### Create a Branch

```bash
git checkout -b refactor/auth-service
```

### Document Current Behavior

```
> Document the public interface and expected behavior of
> AuthService. This will be our refactoring contract.
```

## Phase 3: Refactoring

### Refactoring Patterns

#### Extract Function

**Before:**
```javascript
function processOrder(order) {
  // Validate order
  if (!order.items || order.items.length === 0) {
    throw new Error('Order must have items');
  }
  if (!order.customer || !order.customer.email) {
    throw new Error('Order must have customer with email');
  }

  // ... more code
}
```

**Prompt:**
```
> Extract the validation logic from processOrder into a
> separate validateOrder function.
```

#### Simplify Conditionals

**Before:**
```javascript
if (user.role === 'admin' || user.role === 'superadmin' ||
    (user.role === 'manager' && user.department === 'IT')) {
  // ...
}
```

**Prompt:**
```
> Simplify this conditional by extracting a hasAdminAccess
> function with clear logic.
```

#### Replace Magic Numbers/Strings

**Prompt:**
```
> Find all magic numbers and strings in src/services/payment/
> and replace with named constants.
```

#### Consolidate Duplicate Code

**Prompt:**
```
> These three functions have similar logic:
> - createUser (src/api/users.ts:45)
> - createAdmin (src/api/admin.ts:23)
> - createGuest (src/api/guests.ts:12)
>
> Extract the common logic into a shared function.
```

### Make Small, Safe Changes

**Don't:**
```
> Completely refactor the auth module to use a new pattern
```

**Do:**
```
> Step 1: Extract the token generation logic into a separate function

> [run tests]

> Step 2: Extract the token validation logic

> [run tests]

> Step 3: Create a TokenService class with both functions

> [run tests]

> Step 4: Update AuthService to use TokenService

> [run tests]
```

### Preserve Interfaces

```
> Refactor the internal implementation of AuthService but
> keep the public interface exactly the same:
> - login(email, password): Promise<AuthResult>
> - logout(token): Promise<void>
> - verify(token): Promise<User>
```

## Phase 4: Verification

### Run Tests Continuously

```
> Run the auth service tests

# After each change
> Run tests again to verify nothing broke
```

### Compare Behavior

```
> Compare the behavior of the refactored code with the original.
> Are there any differences in:
> - Return values?
> - Error handling?
> - Side effects?
```

### Review Changes

```
> Review all the refactoring changes we made.
> Did we introduce any bugs or behavior changes?
```

## Tool-Specific Refactoring

### Claude Code

**Plan-based refactoring:**
```
> /plan Refactor the payment processing module to:
> - Separate gateway logic from business logic
> - Extract validation into shared utilities
> - Add proper error types
```

**Incremental refactoring:**
```
> Let's refactor src/services/payment.ts step by step.
> Start by identifying the first safe change we can make.
```

### Cursor Composer

**Multi-file refactoring:**
```
> Refactor the user module:
> - Extract types into types.ts
> - Extract validation into validation.ts
> - Keep API handlers in handlers.ts
> - Update all imports
```

### Copilot

**Inline refactoring:**
1. Select code block
2. `Cmd/Ctrl+I`
3. Type refactoring request

```
> Extract this into a reusable function
> Simplify this conditional
> Convert to async/await
```

## Common Refactoring Scenarios

### Legacy Code Modernization

```
> Modernize this callback-based code to use async/await.
> Preserve the same behavior and error handling.
```

### Performance Optimization

```
> This function is slow. Refactor for performance without
> changing the interface or behavior. Consider:
> - Reducing iterations
> - Caching computed values
> - Avoiding unnecessary object creation
```

### Type Safety Improvement

```
> Add TypeScript types to this JavaScript module.
> Start with the public interfaces, then work inward.
> Don't change any runtime behavior.
```

### Test Refactoring

```
> Refactor these tests to:
> - Remove duplication with shared setup
> - Make assertions clearer
> - Improve test names
> - Group related tests
```

### API Modernization

```
> Refactor this REST API endpoint to:
> - Use proper HTTP status codes
> - Return consistent response format
> - Add input validation
> - Improve error messages

> Keep backward compatibility for existing clients.
```

## Refactoring Anti-Patterns

### Don't Change Too Much at Once

```
# Bad - Too many changes
> Refactor the entire services directory to use a new architecture

# Good - Incremental
> Refactor just the AuthService, keeping its public interface
```

### Don't Mix Refactoring with Features

```
# Bad
> Refactor the user module and add email verification

# Good
> Refactor the user module (separate PR)
> Add email verification (separate PR)
```

### Don't Skip Tests

```
# Bad
> Just refactor it, we'll test later

# Good
> First, let's make sure we have tests for the current behavior
```

### Don't Ignore Warnings

```
> The refactored code has new TypeScript warnings.
> Fix these warnings - they might indicate bugs we introduced.
```

## Refactoring Prompts Library

### Code Organization

```
> Reorganize this file by:
> - Grouping related functions together
> - Ordering from high-level to low-level
> - Separating pure functions from side-effects
```

### Naming Improvement

```
> Suggest better names for:
> - Variables with unclear purpose
> - Functions that don't describe their action
> - Types that are too generic
```

### Complexity Reduction

```
> This function has cyclomatic complexity of [X].
> Reduce it by:
> - Extracting helper functions
> - Using early returns
> - Simplifying conditionals
```

### DRY (Don't Repeat Yourself)

```
> Find duplicated logic in src/handlers/ and
> extract into shared utilities.
```

---

Next: [Sample Prompts](../reference/sample-prompts.md) | [Resources](../reference/resources.md)
