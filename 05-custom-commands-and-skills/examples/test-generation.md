# Workflow: Test Generation

## Overview

Generate comprehensive tests for existing code using AI.

## The Command

**`.claude/commands/generate-tests.md`:**
```markdown
---
description: Generate tests for code
---

# Test Generation

For the specified file or function:

## Step 1: Analyze
1. Read and understand the code
2. Identify all code paths
3. Find edge cases and boundary conditions
4. Note external dependencies to mock

## Step 2: Plan Test Cases
List all test cases:
- Happy path scenarios
- Error conditions
- Edge cases (null, empty, boundary values)
- Integration points

## Step 3: Generate Tests
Following our test patterns in __tests__/:
- Use describe/it structure
- Follow AAA pattern (Arrange, Act, Assert)
- Mock external dependencies
- Use meaningful test names

## Step 4: Verify
1. Run the new tests
2. Check coverage
3. Fix any issues
```

## Usage

### Test a Function

```
> /generate-tests src/utils/formatPrice.ts
```

### Test a Component

```
> /generate-tests src/components/UserProfile.tsx
```

### Test an API Endpoint

```
> /generate-tests src/api/users/route.ts
```

## Example: Utility Function

**Source: `src/utils/formatPrice.ts`**
```typescript
export function formatPrice(cents: number, currency = 'USD'): string {
  if (cents < 0) throw new Error('Price cannot be negative');
  const dollars = cents / 100;
  return new Intl.NumberFormat('en-US', {
    style: 'currency',
    currency,
  }).format(dollars);
}
```

**Generated: `src/utils/__tests__/formatPrice.test.ts`**
```typescript
import { formatPrice } from '../formatPrice';

describe('formatPrice', () => {
  describe('valid inputs', () => {
    it('formats cents to USD by default', () => {
      expect(formatPrice(1000)).toBe('$10.00');
    });

    it('formats zero cents', () => {
      expect(formatPrice(0)).toBe('$0.00');
    });

    it('formats cents with decimal values', () => {
      expect(formatPrice(1050)).toBe('$10.50');
    });

    it('formats large values', () => {
      expect(formatPrice(1000000)).toBe('$10,000.00');
    });
  });

  describe('different currencies', () => {
    it('formats EUR', () => {
      expect(formatPrice(1000, 'EUR')).toBe('€10.00');
    });

    it('formats GBP', () => {
      expect(formatPrice(1000, 'GBP')).toBe('£10.00');
    });
  });

  describe('error cases', () => {
    it('throws for negative values', () => {
      expect(() => formatPrice(-100)).toThrow('Price cannot be negative');
    });
  });
});
```

## Example: React Component

**Source: `src/components/Button.tsx`**
```typescript
interface Props {
  children: React.ReactNode;
  onClick?: () => void;
  disabled?: boolean;
  variant?: 'primary' | 'secondary';
}

export function Button({ children, onClick, disabled, variant = 'primary' }: Props) {
  return (
    <button
      onClick={onClick}
      disabled={disabled}
      className={`btn btn-${variant}`}
    >
      {children}
    </button>
  );
}
```

**Generated Tests:**
```typescript
import { render, screen, fireEvent } from '@testing-library/react';
import { Button } from '../Button';

describe('Button', () => {
  describe('rendering', () => {
    it('renders children', () => {
      render(<Button>Click me</Button>);
      expect(screen.getByText('Click me')).toBeInTheDocument();
    });

    it('applies primary variant by default', () => {
      render(<Button>Click</Button>);
      expect(screen.getByRole('button')).toHaveClass('btn-primary');
    });

    it('applies secondary variant when specified', () => {
      render(<Button variant="secondary">Click</Button>);
      expect(screen.getByRole('button')).toHaveClass('btn-secondary');
    });
  });

  describe('interactions', () => {
    it('calls onClick when clicked', () => {
      const handleClick = jest.fn();
      render(<Button onClick={handleClick}>Click</Button>);

      fireEvent.click(screen.getByRole('button'));

      expect(handleClick).toHaveBeenCalledTimes(1);
    });

    it('does not call onClick when disabled', () => {
      const handleClick = jest.fn();
      render(<Button onClick={handleClick} disabled>Click</Button>);

      fireEvent.click(screen.getByRole('button'));

      expect(handleClick).not.toHaveBeenCalled();
    });
  });

  describe('disabled state', () => {
    it('has disabled attribute when disabled', () => {
      render(<Button disabled>Click</Button>);
      expect(screen.getByRole('button')).toBeDisabled();
    });
  });
});
```

## Tips

### Specify Coverage Goals

```
> /generate-tests src/services/payment.ts
> Focus on error handling - we need better coverage there
```

### Request Specific Cases

```
> /generate-tests src/utils/validate.ts
> Make sure to test:
> - Unicode characters in email
> - Very long inputs
> - SQL injection attempts
```

### Integration Tests

```
> /generate-tests src/api/checkout/route.ts --integration
> Include database setup/teardown
```

## Verification

After generating:

1. **Run tests:**
   ```bash
   npm test -- --coverage
   ```

2. **Review generated tests:**
   - Are test names meaningful?
   - Do assertions test the right things?
   - Are mocks appropriate?

3. **Add missing cases:**
   ```
   > Add a test for when the API returns a 429 rate limit error
   ```

---

Next: [Jira to Code](jira-to-code.md) | [PR Workflow](pr-workflow.md)
