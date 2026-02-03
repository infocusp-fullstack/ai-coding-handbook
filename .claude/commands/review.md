---
description: Review code for bugs, security, and quality issues
---

Review the following code thoroughly:

$ARGUMENTS

## Review Checklist

### Functionality
- Does the code do what it's supposed to do?
- Are edge cases handled?
- Is the logic correct?

### Security
- Are inputs validated and sanitized?
- Are there any injection vulnerabilities?
- Is authentication/authorization correct?
- Are secrets properly handled?

### Performance
- Are there any N+1 queries?
- Are there unnecessary loops or iterations?
- Is there appropriate caching?

### Code Quality
- Is the code readable and maintainable?
- Are names clear and consistent?
- Is there unnecessary complexity?
- Is there code duplication?

### Error Handling
- Are errors caught and handled appropriately?
- Are error messages helpful?
- Is logging sufficient for debugging?

### Testing
- Are there tests for this code?
- Are edge cases tested?
- Are the tests meaningful?

## Output Format

For each issue found:
1. **Location**: File and line number
2. **Severity**: Critical / High / Medium / Low
3. **Issue**: What the problem is
4. **Impact**: Why it matters
5. **Fix**: How to resolve it

If no issues found, confirm the code looks good and note any positive aspects.
