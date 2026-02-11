# Testing with AI

## TL;DR

AI excels at generating comprehensive tests:
- Provide the function/component to test
- Specify test cases you want covered
- Let AI generate the test code
- Review and adjust as needed

## Test Generation Workflow

### Basic Test Generation

**Claude Code:**
```
> Write tests for src/utils/formatPrice.ts
> Cover: valid inputs, edge cases, error conditions
```

**Cursor:**
```
> @src/utils/formatPrice.ts Generate comprehensive tests
> for this function using Jest
```

**Copilot:**
```typescript
// In formatPrice.test.ts
// Generate comprehensive tests for formatPrice
// including: valid inputs, zero, large numbers, negative (error)
```

### Specify Coverage Goals

```
> Write tests for UserService with:
> - 100% branch coverage on createUser
> - All error paths covered
> - Edge cases: empty strings, null values, max lengths
> - Integration with the mock database
```

## Test Types with AI

### Unit Tests

```
> Write unit tests for the calculateDiscount function.
> Mock any external dependencies.
> Test: valid discounts, boundary values, invalid inputs
```

**Generated Example:**
```typescript
describe('calculateDiscount', () => {
  describe('valid discounts', () => {
    it('applies percentage discount correctly', () => {
      expect(calculateDiscount(100, { type: 'percent', value: 10 }))
        .toBe(90);
    });

    it('applies fixed discount correctly', () => {
      expect(calculateDiscount(100, { type: 'fixed', value: 15 }))
        .toBe(85);
    });
  });

  describe('boundary values', () => {
    it('handles zero discount', () => {
      expect(calculateDiscount(100, { type: 'percent', value: 0 }))
        .toBe(100);
    });

    it('handles 100% discount', () => {
      expect(calculateDiscount(100, { type: 'percent', value: 100 }))
        .toBe(0);
    });

    it('caps discount at price (no negative totals)', () => {
      expect(calculateDiscount(100, { type: 'fixed', value: 150 }))
        .toBe(0);
    });
  });

  describe('error cases', () => {
    it('throws for negative discount', () => {
      expect(() => calculateDiscount(100, { type: 'percent', value: -10 }))
        .toThrow('Discount cannot be negative');
    });
  });
});
```

### Component Tests

```
> Write tests for the LoginForm component:
> - Renders correctly
> - Validates email format
> - Shows error on invalid credentials
> - Calls onSubmit with form data
> - Handles loading state
```

**Generated Example:**
```typescript
describe('LoginForm', () => {
  it('renders email and password fields', () => {
    render(<LoginForm onSubmit={jest.fn()} />);

    expect(screen.getByLabelText(/email/i)).toBeInTheDocument();
    expect(screen.getByLabelText(/password/i)).toBeInTheDocument();
  });

  it('validates email format', async () => {
    render(<LoginForm onSubmit={jest.fn()} />);

    const emailInput = screen.getByLabelText(/email/i);
    await userEvent.type(emailInput, 'invalid-email');
    await userEvent.tab();

    expect(screen.getByText(/invalid email/i)).toBeInTheDocument();
  });

  it('calls onSubmit with credentials', async () => {
    const handleSubmit = jest.fn();
    render(<LoginForm onSubmit={handleSubmit} />);

    await userEvent.type(screen.getByLabelText(/email/i), 'test@example.com');
    await userEvent.type(screen.getByLabelText(/password/i), 'password123');
    await userEvent.click(screen.getByRole('button', { name: /sign in/i }));

    expect(handleSubmit).toHaveBeenCalledWith({
      email: 'test@example.com',
      password: 'password123',
    });
  });

  it('shows loading state during submission', async () => {
    render(<LoginForm onSubmit={() => new Promise(() => {})} />);

    await userEvent.type(screen.getByLabelText(/email/i), 'test@example.com');
    await userEvent.type(screen.getByLabelText(/password/i), 'password123');
    await userEvent.click(screen.getByRole('button', { name: /sign in/i }));

    expect(screen.getByRole('button')).toBeDisabled();
    expect(screen.getByText(/signing in/i)).toBeInTheDocument();
  });
});
```

### Integration Tests

```
> Write integration tests for the user registration flow:
> - POST /api/users creates user in database
> - Duplicate email returns 409
> - Invalid data returns 400 with validation errors
> - New user receives welcome email
```

### E2E Tests

```
> Write Playwright E2E tests for the checkout flow:
> - User can add items to cart
> - User can proceed to checkout
> - User can enter shipping details
> - User can complete payment
> - Confirmation page shows order details
```

## Test Improvement Prompts

### Add Missing Coverage

```
> Look at src/services/paymentService.ts and its tests.
> What test cases are missing? Add them.
```

### Improve Test Quality

```
> Review these tests for quality:
> - Are assertions meaningful?
> - Are test names descriptive?
> - Is there duplication that could be refactored?
> - Are mocks appropriate?
```

### Make Tests More Robust

```
> These tests are flaky. Improve them by:
> - Removing timing dependencies
> - Using proper async/await
> - Isolating test data
```

## Test-Driven Development with AI

### Red-Green-Refactor

**Step 1: Write Failing Test (Red)**
```
> Write a failing test for a function that validates
> credit card numbers using the Luhn algorithm.
> Don't implement the function yet.
```

**Step 2: Implement to Pass (Green)**
```
> Now implement validateCreditCard to make this test pass.
> Minimum code needed.
```

**Step 3: Refactor**
```
> The test passes. Refactor the implementation for clarity
> while keeping tests green.
```

### Using TDG Plugin

```bash
/plugin install tdg@claude-plugins-official

> /tdg:init
# Initialize TDD workflow

> Write a credit card validator
# TDG manages red-green-refactor cycle
```

## Testing Patterns

### Test Data Factories

```
> Create a test data factory for User:
> - Default valid user
> - Builder pattern for customization
> - Realistic fake data
```

**Generated:**
```typescript
const createTestUser = (overrides: Partial<User> = {}): User => ({
  id: faker.string.uuid(),
  email: faker.internet.email(),
  name: faker.person.fullName(),
  createdAt: faker.date.past(),
  ...overrides,
});

// Usage
const user = createTestUser({ email: 'specific@email.com' });
```

### Mock Patterns

```
> Create proper mocks for the PaymentGateway:
> - Mock successful payments
> - Mock declined cards
> - Mock network errors
> - Mock timeout scenarios
```

### Snapshot Tests

```
> Add snapshot tests for the Dashboard components.
> Include tests for:
> - Default state
> - Loading state
> - Empty state
> - Error state
```

## Best Practices

### 1. Be Specific About Requirements

```
# Bad
> Write tests for this function

# Good
> Write tests for this function covering:
> - Valid inputs: positive numbers, zero
> - Invalid inputs: negative, NaN, undefined
> - Edge cases: very large numbers, decimals
> - Error messages should be descriptive
```

### 2. Reference Project Patterns

```
> Write tests for UserService following the patterns
> in __tests__/services/OrderService.test.ts
```

### 3. Request Rationale

```
> Write tests and explain why each test case is important.
> What bug would it catch?
```

### 4. Verify AI-Generated Tests

Always review generated tests:
- Do assertions actually test behavior?
- Are edge cases meaningful or arbitrary?
- Do mocks reflect real behavior?
- Are test names accurate?

```
> Review these generated tests. Are there any that:
> - Test implementation details instead of behavior?
> - Have weak assertions?
> - Are redundant?
```

### 5. Ask for Missing Cases

```
> What test cases are we missing for this feature?
> What could still break that we're not testing?
```

## Common Issues

### AI Generates Weak Assertions

```
# Bad assertion
expect(result).toBeDefined();

# Good assertion
expect(result).toEqual({ id: '123', status: 'success' });
```

**Fix:**
```
> These assertions are too weak. Make them more specific.
> Test the actual values, not just that something exists.
```

### Tests Are Too Tightly Coupled

```
# Tightly coupled to implementation
expect(mockDb.query).toHaveBeenCalledWith(
  'SELECT * FROM users WHERE id = ?', ['123']
);

# Better: Test behavior
expect(result.user.id).toBe('123');
```

**Fix:**
```
> These tests are coupled to implementation details.
> Refactor to test behavior instead of internal calls.
```

### Missing Async Handling

```
# Will pass even if async fails
it('creates user', () => {
  createUser(data); // Missing await
});

# Correct
it('creates user', async () => {
  await createUser(data);
  expect(await getUser(data.id)).toBeDefined();
});
```

**Fix:**
```
> Review async handling in these tests.
> Ensure all promises are properly awaited.
```

## Test Commands Reference

**Claude Code:**
```
> /generate-tests src/utils/formatPrice.ts
> Run tests for the user module
> What's our current test coverage?
```

**Cursor:**
```
> @file.ts Generate tests following our test patterns
> Run npm test and show me failures
```

**Copilot Chat:**
```
> /tests Write tests for the selected code
> /fix Make these tests pass
```

---

Next: [Multi-Agent Patterns](multi-agent.md) | [Debugging Tips](debugging-tips.md)
