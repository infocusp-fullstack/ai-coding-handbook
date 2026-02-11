# Review Your Code

## TL;DR

AI-generated code requires **more** review, not less. Every piece of code AI writes should be treated like a PR from a productive but unreliable contributor.

## Why Review Matters More Now

### AI Generates Code Fast

Speed is AI's strength—and its risk:
- 100 lines in seconds
- But are they the right 100 lines?
- With the right error handling?
- Following your patterns?
- Without security issues?

### AI Makes Confident Mistakes

AI doesn't say "I'm not sure about this." It generates code that looks correct and professional, even when it's wrong:

```javascript
// AI-generated: Looks correct, has a bug
async function getUser(id) {
  const user = await db.users.find(id);  // Should be findOne()
  return user;
}
```

### AI Doesn't Know Your Context

AI doesn't know:
- Your production edge cases
- Your users' actual behavior
- Your team's tribal knowledge
- Why previous solutions failed

## The Review Checklist

### Before Every Accept

1. **Read the code** - Don't just skim
2. **Understand the logic** - Could you explain it?
3. **Check requirements** - Does it solve the actual problem?
4. **Look for bugs** - Off-by-one, null refs, race conditions
5. **Verify security** - Input validation, auth, data exposure
6. **Confirm patterns** - Matches your codebase style
7. **Run tests** - All passing, including new tests

### Specific Checks

#### Logic Errors

```javascript
// Common AI mistake: Wrong comparison
if (user.age > 18) {  // Should be >= for "18 and older"
  allowAccess();
}
```

#### Missing Edge Cases

```javascript
// AI often misses null checks
function getEmail(user) {
  return user.email;  // What if user is null?
}
```

#### Security Issues

```javascript
// AI sometimes generates SQL injection vulnerabilities
const query = `SELECT * FROM users WHERE id = ${id}`;  // Dangerous!

// Should be
const query = 'SELECT * FROM users WHERE id = ?';
db.query(query, [id]);
```

#### Hallucinated APIs

```javascript
// AI may invent APIs that don't exist
await user.saveWithHistory();  // This method doesn't exist in your ORM
```

#### Inconsistent Patterns

```javascript
// AI may use different patterns than your codebase
// Your codebase: async/await
// AI generated: callbacks
db.users.find(id, (err, user) => {  // Should use await
  callback(err, user);
});
```

## Review Strategies

### 1. Read the Diff

Don't accept without reading. Every time.

```bash
# In Claude Code, AI shows changes
# Actually read them before accepting

# Or review with git
git diff
```

### 2. Trace the Logic

Walk through the code mentally:
- What happens with valid input?
- What happens with invalid input?
- What happens with null/undefined?
- What happens at boundaries?

### 3. Check Against Requirements

Does the code actually solve the stated problem?

```
Requirement: "Users can update their email"
AI solution: Allows updating any user's email
           (Missing: current user authorization)
```

### 4. Run It

Don't trust visual inspection alone:
```bash
npm test
npm run lint
npm run typecheck
```

### 5. Manual Testing

For UI or critical paths:
- Actually click through the flow
- Try edge cases manually
- Test error conditions

## When to Be Extra Careful

### High-Risk Areas

- Authentication and authorization
- Payment processing
- Data encryption
- User data handling
- Admin functionality
- Public APIs
- Database migrations

### Signs of AI Confusion

- Code that looks overly complex
- Unusual patterns for your codebase
- Comments that don't match code
- Multiple approaches mixed together

### After Long Conversations

- AI context may be degraded
- Earlier instructions may be forgotten
- Cross-file consistency may suffer

## Common AI Mistakes to Watch For

### 1. Wrong Function/Method Names

```javascript
// AI
await user.save();

// Reality: Your ORM uses
await user.persist();
```

### 2. Missing Async/Await

```javascript
// AI forgot await
const user = db.getUser(id);  // Returns Promise, not User
console.log(user.name);        // undefined
```

### 3. Incorrect Error Handling

```javascript
// AI catches and swallows errors
try {
  await riskyOperation();
} catch (e) {
  console.log(e);  // Logs but doesn't handle
}                  // Execution continues as if success
```

### 4. Hardcoded Values

```javascript
// AI may hardcode instead of configure
const API_URL = 'https://api.production.com';  // Should be env var
```

### 5. Missing Validation

```javascript
// AI trusts input
function transfer(amount, toAccount) {
  // Missing: Is amount positive?
  // Missing: Does toAccount exist?
  // Missing: Does user have sufficient balance?
  db.transfer(amount, toAccount);
}
```

## Building Review Habits

### Create Review Checkpoints

```
After AI generates code:
□ Read every line
□ Check logic for edge cases
□ Verify security
□ Run tests
□ Manual test if UI
```

### Use AI for Review

```
> Review the code you just generated for:
> - Security issues
> - Missing edge cases
> - Inconsistencies with our patterns
```

AI reviewing AI isn't perfect, but catches some issues.

### Time-Box Acceptance

Don't accept immediately:
1. Generate code
2. Wait 30 seconds
3. Read through completely
4. Then decide to accept or iterate

### Review in Batches

For large changes:
1. Generate in small pieces
2. Review each piece
3. Don't let changes accumulate

## The Cost of Not Reviewing

### Short Term
- Bugs ship to production
- Security vulnerabilities deployed
- Technical debt accumulates

### Long Term
- You don't understand your codebase
- Debugging becomes impossible
- Maintenance costs explode
- Team knowledge erodes

## The Reward of Good Review

- Fewer production bugs
- Better security posture
- Understanding of your code
- Sustainable velocity
- Professional growth

---

**Remember**: AI generates, you validate. Every time.

---

Next: [Learning, Not Outsourcing](learning-not-outsourcing.md) | [Team Adoption](team-adoption.md)
