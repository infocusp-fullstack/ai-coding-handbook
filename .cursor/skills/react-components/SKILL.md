---
name: react-components
description: Build React components following modern patterns
triggers:
  - component
  - react
  - tsx
  - jsx
  - hook
  - useState
  - useEffect
---

# React Components Skill

You are helping build React components. Follow these modern patterns and best practices.

## Component Structure

```typescript
// 1. Imports (external, then internal)
import { useState, useCallback } from 'react';
import { cn } from '@/lib/utils';
import { Button } from '@/components/ui';

// 2. Types
interface CardProps {
  title: string;
  description?: string;
  onAction?: () => void;
  children: React.ReactNode;
}

// 3. Component
export function Card({ title, description, onAction, children }: CardProps) {
  // Hooks first
  const [isExpanded, setIsExpanded] = useState(false);

  // Handlers
  const handleToggle = useCallback(() => {
    setIsExpanded(prev => !prev);
  }, []);

  // Render
  return (
    <div className="rounded-lg border p-4">
      <h3>{title}</h3>
      {description && <p>{description}</p>}
      {children}
    </div>
  );
}
```

## Key Principles

### Props
- Use TypeScript interfaces for props
- Destructure in function signature
- Provide sensible defaults
- Use `children` for composition

### State
- Keep state minimal
- Lift state only when needed
- Use `useReducer` for complex state
- Derive values instead of storing

### Effects
- Specify all dependencies
- Clean up subscriptions/timers
- Avoid effects for derived state
- Consider if effect is needed

## Patterns

### Conditional Rendering
```typescript
{isLoading && <Spinner />}
{error && <ErrorMessage error={error} />}
{data && <DataDisplay data={data} />}
```

### Event Handlers
```typescript
// Inline for simple cases
<button onClick={() => setCount(c => c + 1)}>

// Named for complex logic or reuse
const handleSubmit = useCallback((e: FormEvent) => {
  e.preventDefault();
  // ... logic
}, [dependencies]);
```

### Composition over Props
```typescript
// Prefer
<Card>
  <CardHeader />
  <CardBody />
</Card>

// Over
<Card header={...} body={...} footer={...} />
```

## Styling with Tailwind

```typescript
<div
  className={cn(
    'base-styles here',
    isActive && 'active-styles',
    variant === 'primary' && 'primary-styles'
  )}
>
```

## Accessibility

- Use semantic HTML (`button`, `nav`, `main`)
- Add `aria-label` for icon-only buttons
- Manage focus for modals/dialogs
- Support keyboard navigation
