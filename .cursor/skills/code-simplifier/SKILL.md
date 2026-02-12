---
name: code-simplifier
description: Simplify and refine code for clarity, consistency, and maintainability
triggers:
  - simplify
  - clean up
  - refactor
  - improve readability
  - reduce complexity
---

# Code Simplifier Skill

You are helping simplify code while preserving functionality. Focus on clarity and maintainability.

## Simplification Principles

1. **Reduce cognitive load** - Code should be easy to understand at a glance
2. **Eliminate redundancy** - DRY, but don't over-abstract
3. **Prefer explicit over clever** - Clear beats concise
4. **Maintain consistency** - Match surrounding code style

## Common Simplifications

### Flatten Nested Conditionals
```typescript
// Before
if (user) {
  if (user.isActive) {
    if (user.hasPermission) {
      doSomething();
    }
  }
}

// After (early returns)
if (!user) return;
if (!user.isActive) return;
if (!user.hasPermission) return;
doSomething();
```

### Simplify Boolean Logic
```typescript
// Before
if (isValid === true) { return true; } else { return false; }

// After
return isValid;
```

### Use Modern Syntax
```typescript
// Before
const name = user && user.profile && user.profile.name;

// After
const name = user?.profile?.name;

// Before
const value = input !== null && input !== undefined ? input : 'default';

// After
const value = input ?? 'default';
```

### Extract Meaningful Names
```typescript
// Before
if (date.getTime() > Date.now() - 86400000 * 7) {

// After
const ONE_WEEK_MS = 7 * 24 * 60 * 60 * 1000;
const isWithinLastWeek = date.getTime() > Date.now() - ONE_WEEK_MS;
if (isWithinLastWeek) {
```

### Reduce Function Parameters
```typescript
// Before
function createUser(name, email, age, role, department, manager) {

// After
interface CreateUserParams {
  name: string;
  email: string;
  age: number;
  role: Role;
  department: string;
  manager?: string;
}
function createUser(params: CreateUserParams) {
```

## Complexity Checklist

- [ ] Functions under 30 lines
- [ ] Max 3 levels of nesting
- [ ] Max 4 function parameters
- [ ] No repeated code blocks
- [ ] Clear variable/function names
- [ ] Single responsibility per function

## What NOT to Simplify

- Performance-critical code (measure first)
- Well-tested legacy code without issues
- Code matching established team patterns
- Third-party integration code
