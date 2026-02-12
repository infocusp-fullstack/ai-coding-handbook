---
name: unit-testing
description: Generate comprehensive unit tests following best practices
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

## Assertions

- Use specific matchers: `toEqual`, `toContain`, `toThrow`
- One logical assertion per test
- Test behavior, not implementation

## Coverage Targets

- Aim for 80%+ line coverage
- 100% coverage on critical paths
- Don't test trivial code (getters, simple wrappers)
