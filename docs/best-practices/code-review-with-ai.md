# Code Review with AI

## TL;DR

- AI reviews complement, not replace, human reviews
- Use AI for first-pass checks (style, bugs, security)
- Focus human reviewers on architecture and business logic
- Always verify AI suggestions before applying

## AI Review Capabilities

### What AI Reviews Well

| Category | Examples |
|----------|----------|
| **Code style** | Naming conventions, formatting, consistency |
| **Common bugs** | Null references, off-by-one, race conditions |
| **Security** | SQL injection, XSS, hardcoded secrets |
| **Performance** | N+1 queries, unnecessary loops, memory leaks |
| **Best practices** | Error handling, type safety, documentation |

### What Requires Human Review

| Category | Why |
|----------|-----|
| **Business logic** | AI doesn't know your domain rules |
| **Architecture** | Long-term implications need context |
| **Trade-offs** | Product decisions require stakeholder input |
| **Edge cases** | Domain-specific scenarios AI might miss |

## Tool-Specific Review Approaches

### Claude Code

**Review a PR:**
```
> /review-pr 123
```

Or manually:
```
> Review the changes in this PR. Focus on:
> - Security vulnerabilities
> - Performance implications
> - Error handling gaps
> - Code consistency with our patterns
```

**Review specific files:**
```
> Review src/api/auth.ts for security issues
```

**Review with checklist:**
```
> Review this code against our checklist:
> - [ ] Input validation
> - [ ] Error handling
> - [ ] Logging
> - [ ] Tests included
> - [ ] Types are correct
```

### GitHub Copilot

**Chat review:**
```
> @workspace /review Review the selected code for issues
```

**Specific concerns:**
```
> Check this function for:
> - SQL injection vulnerabilities
> - Proper error handling
> - Edge cases
```

**Enterprise: Copilot Code Review**

For Copilot Enterprise users:
1. Request review on PR
2. Copilot adds inline comments
3. Review suggestions
4. Accept or dismiss

### Cursor

**Inline review:**
1. Select code
2. Press `Cmd/Ctrl+K`
3. Type "review this code"

**Chat review with context:**
```
> @file.ts Review this file for:
> - Security issues
> - Performance problems
> - Missing error handling
```

## Review Workflow Integration

### Pre-Commit Review

Before committing:

```bash
# Claude Code
claude "Review staged changes for issues before I commit"
```

### PR Creation Review

When creating a PR:

```
> Review all changes on this branch compared to main.
> Identify any issues that should be fixed before merge.
```

### PR Comment Response

When you receive AI review comments:

1. **Evaluate each suggestion** - Not all are valid
2. **Check context** - AI might miss domain knowledge
3. **Test fixes** - Verify suggestions work
4. **Document decisions** - Explain why you accept/reject

## Review Prompts Library

### Security Review

```
Review this code for security vulnerabilities:
- SQL/NoSQL injection
- XSS vulnerabilities
- Authentication/authorization flaws
- Sensitive data exposure
- CSRF vulnerabilities
- Insecure dependencies
- Hardcoded secrets

For each issue found, explain:
1. The vulnerability
2. Potential impact
3. Recommended fix
```

### Performance Review

```
Analyze this code for performance issues:
- N+1 database queries
- Unnecessary iterations
- Memory leaks
- Missing indexes (for queries)
- Blocking operations
- Large payload sizes

Suggest optimizations with expected impact.
```

### Error Handling Review

```
Review error handling in this code:
- Are all async operations wrapped in try/catch?
- Are errors logged with sufficient context?
- Are user-facing errors appropriate (no stack traces)?
- Are errors properly propagated?
- Are there any swallowed exceptions?
```

### Type Safety Review

```
Check type safety in this TypeScript code:
- Any use of 'any' type
- Missing return types
- Implicit any in parameters
- Type assertions that could be avoided
- Proper null/undefined handling
```

### Test Coverage Review

```
Review the test coverage for this code:
- Are happy paths tested?
- Are error cases tested?
- Are edge cases covered?
- Are mocks appropriate?
- Are assertions meaningful?

Suggest additional test cases if needed.
```

## Review Checklist Template

Create `.claude/commands/review-checklist.md`:

```markdown
---
description: Review code against team checklist
---

Review the following code against our team checklist:

## Functionality
- [ ] Code does what the PR description says
- [ ] Edge cases are handled
- [ ] No obvious bugs

## Security
- [ ] Input is validated and sanitized
- [ ] No hardcoded secrets
- [ ] Authentication/authorization correct
- [ ] SQL/injection safe

## Performance
- [ ] No N+1 queries
- [ ] Appropriate caching
- [ ] No unnecessary loops/iterations

## Code Quality
- [ ] Follows our style guide
- [ ] Functions are focused (single responsibility)
- [ ] Naming is clear and consistent
- [ ] No dead code

## Error Handling
- [ ] Errors are caught and handled
- [ ] Errors are logged appropriately
- [ ] User-facing errors are friendly

## Testing
- [ ] Unit tests for new logic
- [ ] Edge cases tested
- [ ] Existing tests still pass

## Documentation
- [ ] Complex logic is commented
- [ ] Public APIs are documented
- [ ] README updated if needed

For each failed check, explain the issue and suggest a fix.
```

## Best Practices

### 1. Use AI as First Pass

```
1. Author runs AI review before PR
2. Fix obvious issues
3. Submit for human review
4. Human focuses on architecture, business logic
```

### 2. Create Consistent Review Prompts

Store prompts in `.claude/commands/` or team documentation:

```
.claude/
└── commands/
    ├── review-security.md
    ├── review-performance.md
    └── review-checklist.md
```

### 3. Document False Positives

Track when AI gives bad advice:

```markdown
## Known False Positives

### Security
- AI flags all string concatenation as SQL injection,
  even when using parameterized queries

### Performance
- AI suggests caching for functions that should
  always return fresh data
```

### 4. Verify Before Applying

Never blindly apply AI suggestions:

```
# Bad workflow
AI suggests fix → Apply immediately

# Good workflow
AI suggests fix → Understand the issue →
Verify fix is correct → Test → Apply
```

### 5. Combine with Linting

AI catches what linters miss, but use both:

```yaml
# .github/workflows/pr.yml
jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npm run lint
      - run: npm run typecheck

  # AI review is manual, triggered by humans
```

## Team Integration

### Review Assignment

```
Human reviewer: Architecture, business logic, UX
AI reviewer: Style, bugs, security, performance
```

### Review SLA

```
1. Author self-reviews with AI
2. Author fixes AI-found issues
3. PR submitted
4. Human review within 24h
5. AI re-reviews if significant changes
```

### Training

1. Share effective review prompts
2. Document common issues AI finds
3. Track review quality metrics
4. Iterate on prompts based on results

---

Next: [Safety and Security](safety-and-security.md) | [Sample Prompts](../reference/sample-prompts.md)
