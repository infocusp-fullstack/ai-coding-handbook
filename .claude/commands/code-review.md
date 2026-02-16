---
description: Code review with comprehensive checklist for common issues
---

# Code Review

Perform a comprehensive code review of:

$ARGUMENTS

## Review Philosophy

This review checks for issues that commonly appear in our codebase. Keep adding new checks here as you encounter repetitive issues in reviews.

## Critical Issues (Must Fix)

### Security
- [ ] No hardcoded secrets or credentials
- [ ] Input validation on all user inputs
- [ ] SQL queries use parameterized statements
- [ ] Output encoding to prevent XSS
- [ ] Proper authorization checks
- [ ] No sensitive data in logs or error messages

### Logic Errors
- [ ] No infinite loops
- [ ] No null/undefined dereferences
- [ ] Error handling for async operations
- [ ] Race conditions addressed
- [ ] Resource leaks (connections, file handles)

## Common Issues (Should Fix)

### Code Quality
- [ ] Functions are focused and under 30 lines
- [ ] Variable names are clear and descriptive
- [ ] No commented-out code
- [ ] No console.log statements left in production code
- [ ] No TODO comments without ticket numbers
- [ ] Consistent code style with existing codebase

### Error Handling
- [ ] Errors are caught and handled appropriately
- [ ] Error messages are user-friendly
- [ ] Stack traces not exposed to users
- [ ] Failures don't leave system in inconsistent state

### Performance
- [ ] No N+1 queries
- [ ] No unnecessary re-renders (React)
- [ ] Large lists are virtualized or paginated
- [ ] Expensive operations are memoized
- [ ] No memory leaks in useEffect cleanup

### Testing
- [ ] New code has tests
- [ ] Tests cover happy path and error cases
- [ ] Tests don't rely on external state
- [ ] Mock data is realistic
- [ ] Test names describe behavior

## Style Issues (Nice to Fix)

### Consistency
- [ ] Follows existing naming conventions
- [ ] Uses existing utility functions
- [ ] Follows established patterns
- [ ] Import ordering is consistent

### Documentation
- [ ] Complex logic has comments explaining why
- [ ] Public APIs have JSDoc comments
- [ ] TypeScript types are specific (avoid `any`)

## Project-Specific Checks

### Database
- [ ] Migrations are backwards compatible
- [ ] Indexes added for new queries
- [ ] Soft deletes used where appropriate
- [ ] Transactions used for multi-step operations

### API Design
- [ ] REST conventions followed
- [ ] Consistent error response format
- [ ] Pagination for list endpoints
- [ ] Proper HTTP status codes

### Frontend
- [ ] Accessibility (ARIA labels, keyboard nav)
- [ ] Responsive design considerations
- [ ] Loading states handled
- [ ] Error states handled

## Output Format

For each issue found:

### [Issue Category]: [Brief Description]
**Location**: `file.ts:line`
**Severity**: Critical / High / Medium / Low
**Issue**: [Detailed explanation]
**Suggestion**: [How to fix it]
**Example**:
```typescript
// Current
[problematic code]

// Suggested
[improved code]
```

## Review Summary

After reviewing, provide:

1. **Issue Count by Severity**:
   - Critical: X
   - High: X
   - Medium: X
   - Low: X

2. **Top 3 Most Important Issues**:
   - [Brief description with location]

3. **Positive Aspects**:
   - [What was done well]

4. **Overall Verdict**:
   - ✅ Approved - Ready to merge
   - ⚠️ Approved with minor comments
   - ❌ Changes required

## Adding New Checks

When you find yourself commenting on the same issue repeatedly:

1. Add it to this checklist under appropriate section
2. Include example of the problem
3. Include example of the fix
4. Test the command to ensure it catches the issue

## Tips for Reviewers

- **Be constructive**: Suggest improvements, don't just criticize
- **Explain why**: Help the author understand the reasoning
- **Prioritize**: Focus on critical issues first
- **Context matters**: Some "rules" can be bent in specific situations
- **Learn together**: Use reviews to share knowledge
