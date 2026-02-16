---
name: unit-testing
description: Generate comprehensive unit tests following best practices
triggers:
  - test
  - testing
  - unit test
  - mock
  - jest
  - vitest
  - seed data
  - fixtures
---

# Unit Testing Skill

You are helping write unit tests. Follow these guidelines for high-quality, maintainable tests.

## Test Structure (AAA Pattern)

```typescript
describe('ComponentOrFunction', () => {
  describe('methodName', () => {
    it('should [expected behavior] when [condition]', () => {
      // Arrange - Set up test data and mocks
      const input = { name: 'Test' };

      // Act - Execute the code under test
      const result = functionUnderTest(input);

      // Assert - Verify the outcome
      expect(result).toEqual({ name: 'Test', processed: true });
    });
  });
});
```

## Naming Conventions

- Describe blocks: Name of component/function
- It blocks: `should [do something] when [condition]`
- Test files: `*.test.ts` or `*.spec.ts`

## What to Test

### Functions
- Happy path with valid inputs
- Edge cases (empty, null, undefined)
- Error conditions
- Boundary values

### Components
- Renders correctly with props
- User interactions (click, input, submit)
- Conditional rendering
- Loading and error states

## Mocking Guidelines

### When to Mock

✅ **Mock These:**
- External APIs and services
- Database calls
- File system operations
- Third-party libraries with side effects
- Time-based functions (Date, timers)
- Random number generators

❌ **Don't Mock:**
- The code being tested
- Pure utility functions
- Simple data transformations
- Internal helpers (test them directly)

### Mock Examples

```typescript
// Mock external dependencies
jest.mock('@/lib/api');
const mockApi = jest.mocked(api);

beforeEach(() => {
  jest.clearAllMocks();
});

it('handles API error', async () => {
  mockApi.fetchUser.mockRejectedValue(new Error('Network error'));
  // ... test error handling
});
```

### Partial Mocks

When you need to mock only part of a module:

```typescript
jest.mock('@/lib/utils', () => ({
  ...jest.requireActual('@/lib/utils'),
  generateId: jest.fn(() => 'mock-id-123')
}));
```

## Seed Data and Fixtures

### Factory Functions

Use factory functions for creating test data:

```typescript
// factories/user.ts
export const createUser = (overrides: Partial<User> = {}): User => ({
  id: 'user-123',
  email: 'test@example.com',
  name: 'Test User',
  role: 'user',
  createdAt: new Date('2024-01-01'),
  ...overrides
});

// In tests
const admin = createUser({ role: 'admin', name: 'Admin User' });
const deleted = createUser({ deletedAt: new Date() });
```

### Fixtures for Complex Data

For complex, reusable data structures:

```typescript
// fixtures/order.ts
export const validOrder = {
  id: 'order-123',
  items: [
    { productId: 'prod-1', quantity: 2, price: 29.99 },
    { productId: 'prod-2', quantity: 1, price: 49.99 }
  ],
  customer: {
    id: 'cust-456',
    email: 'customer@example.com'
  },
  total: 109.97
};

export const orderWithDiscount = {
  ...validOrder,
  discountCode: 'SAVE10',
  total: 98.97
};
```

### Test Data Guidelines

1. **Use realistic data**: Don't use "asdf" or "test" - use realistic names and values
2. **Make dependencies explicit**: Pass data as parameters, don't rely on global state
3. **Reset between tests**: Clear database, reset mocks in `beforeEach`
4. **Version your fixtures**: Update fixtures when schema changes

### Database Seed Data

For integration tests requiring database:

```typescript
// test/setup.ts
beforeEach(async () => {
  // Clear tables in correct order
  await db.query('DELETE FROM order_items');
  await db.query('DELETE FROM orders');
  await db.query('DELETE FROM users');
  
  // Seed test data
  await seedUsers();
  await seedProducts();
});

async function seedUsers() {
  await db.insert(users).values([
    createUser({ email: 'active@example.com', status: 'active' }),
    createUser({ email: 'inactive@example.com', status: 'inactive' })
  ]);
}
```

## Assertions

- Use specific matchers: `toEqual`, `toContain`, `toThrow`
- One logical assertion per test
- Test behavior, not implementation

## Coverage Targets

- Aim for 80%+ line coverage
- 100% coverage on critical paths
- Don't test trivial code (getters, simple wrappers)

## Testing Checklist

Before considering tests complete:

- [ ] Happy path covered
- [ ] Edge cases handled (null, undefined, empty)
- [ ] Error cases tested
- [ ] Mocks are appropriate (not over-mocked)
- [ ] Test data is realistic
- [ ] Tests are independent (no shared state)
- [ ] Tests run quickly (< 100ms each ideally)
