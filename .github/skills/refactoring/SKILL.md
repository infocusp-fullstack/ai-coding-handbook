---
name: refactoring
description: Refactor code for clarity and maintainability without changing behavior
---

# Refactoring Skill

You are helping refactor code. The goal is to improve code quality without changing external behavior.

## Core Principles

1. **Preserve behavior** - Tests must pass before and after
2. **Small steps** - One refactoring at a time
3. **Verify often** - Run tests after each change
4. **No feature changes** - Refactoring only

## Common Refactorings

### Extract Function
```typescript
// Before
function processOrder(order) {
  // 20 lines calculating discount
  // 10 lines applying discount
  // 15 lines sending notification
}

// After
function processOrder(order) {
  const discount = calculateDiscount(order);
  const total = applyDiscount(order, discount);
  sendOrderNotification(order, total);
}
```

### Extract Variable
```typescript
// Before
if (user.age >= 18 && user.hasVerifiedEmail && !user.isBanned) {

// After
const isEligible = user.age >= 18 && user.hasVerifiedEmail && !user.isBanned;
if (isEligible) {
```

### Replace Conditionals with Polymorphism
```typescript
// Before
function getArea(shape) {
  if (shape.type === 'circle') return Math.PI * shape.radius ** 2;
  if (shape.type === 'rectangle') return shape.width * shape.height;
}

// After
interface Shape { getArea(): number; }
class Circle implements Shape { getArea() { return Math.PI * this.radius ** 2; } }
class Rectangle implements Shape { getArea() { return this.width * this.height; } }
```

### Simplify Conditionals
```typescript
// Before
if (condition) {
  return true;
} else {
  return false;
}

// After
return condition;
```

## Code Smells to Fix

| Smell | Refactoring |
|-------|-------------|
| Long function (>30 lines) | Extract Function |
| Duplicate code | Extract Function/Class |
| Long parameter list | Introduce Parameter Object |
| Feature envy | Move Method |
| Data clumps | Extract Class |
| Primitive obsession | Replace with Value Object |

## Refactoring Checklist

- [ ] Tests exist and pass
- [ ] Identified specific smell to fix
- [ ] Applied single refactoring
- [ ] Tests still pass
- [ ] Code more readable
- [ ] No behavior change
