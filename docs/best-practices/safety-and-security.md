# Safety and Security Guidelines

## TL;DR

1. **Never commit secrets** - AI can accidentally expose them
2. **Review all AI code** - Especially for security-sensitive areas
3. **Use branches** - Isolate AI work for easy rollback
4. **Validate inputs** - AI may forget input sanitization
5. **Check permissions** - Review command permissions carefully

## Security Risks with AI Tools

### Data Exposure Risks

| Risk | Description | Mitigation |
|------|-------------|------------|
| **Secrets in prompts** | Pasting code with API keys | Use environment variables |
| **Training data** | Code sent to AI providers | Check data policies, use local models for sensitive code |
| **Context leakage** | AI remembers previous conversations | Clear context between sensitive sessions |
| **File inclusion** | AI reads files with secrets | Configure exclusions |

### Code Generation Risks

| Risk | Description | Mitigation |
|------|-------------|------------|
| **SQL injection** | AI generates unsafe queries | Always use parameterized queries |
| **XSS vulnerabilities** | Unsafe HTML rendering | Sanitize all user input |
| **Auth bypass** | Flawed security logic | Security review for auth code |
| **Hardcoded secrets** | AI includes example credentials | Scan for secrets before commit |

### Command Execution Risks

| Risk | Description | Mitigation |
|------|-------------|------------|
| **Destructive commands** | `rm -rf`, `DROP TABLE` | Require approval for destructive ops |
| **Data modification** | Unintended database changes | Use read-only connections for exploration |
| **System changes** | Config modifications | Sandbox or containerize |

## Tool-Specific Security Settings

### Claude Code

**Configure allowed commands:**

```json
// .claude/settings.json
{
  "permissions": {
    "allowedCommands": [
      "npm test",
      "npm run lint",
      "npm run build",
      "git status",
      "git diff",
      "git log"
    ],
    "blockedCommands": [
      "rm -rf",
      "git push --force",
      "DROP",
      "DELETE FROM"
    ]
  }
}
```

**Exclude sensitive files:**

```json
{
  "excludePatterns": [
    ".env*",
    "*.pem",
    "*.key",
    "**/secrets/**",
    "**/credentials/**",
    ".git/config"
  ]
}
```

### GitHub Copilot

**Create ignore file:**

```
# .github/copilot-ignore
.env*
*.pem
*.key
secrets/
credentials/
config/production.json
```

**VS Code settings:**

```json
{
  "github.copilot.enable": {
    "*": true,
    "env": false,
    "properties": false
  }
}
```

### Cursor

**Privacy mode:**
- Settings > Privacy > Enable for sensitive projects
- Limits data sent to AI providers

**Exclude from indexing:**
- Settings > Features > Codebase Indexing > Ignored Files
- Add patterns for sensitive directories

## Git Safety Practices

### Always Work in Branches

```bash
# Before AI work
git checkout -b feature/ai-generated-auth

# After review, merge
git checkout main
git merge feature/ai-generated-auth
```

### Review Before Commit

```bash
# See what AI changed
git diff

# Stage selectively
git add -p

# Never auto-commit AI changes
```

### Use Pre-Commit Hooks

```yaml
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/gitleaks/gitleaks
    rev: v8.18.0
    hooks:
      - id: gitleaks

  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.5.0
    hooks:
      - id: detect-private-key
      - id: detect-aws-credentials
```

### Configure Git

```bash
# Prevent accidental pushes to main
git config --local branch.main.pushRemote no_push

# Require signed commits
git config --local commit.gpgsign true
```

## Secure Code Review Checklist

When reviewing AI-generated code, check for:

### Input Validation

```javascript
// Bad - AI might generate
function getUser(id) {
  return db.query(`SELECT * FROM users WHERE id = ${id}`);
}

// Good - Parameterized
function getUser(id) {
  return db.query('SELECT * FROM users WHERE id = ?', [id]);
}
```

### Authentication/Authorization

```javascript
// Bad - No auth check
app.delete('/api/users/:id', async (req, res) => {
  await User.delete(req.params.id);
  res.json({ success: true });
});

// Good - With auth and authorization
app.delete('/api/users/:id', authenticate, async (req, res) => {
  if (req.user.id !== req.params.id && !req.user.isAdmin) {
    return res.status(403).json({ error: 'Forbidden' });
  }
  await User.delete(req.params.id);
  res.json({ success: true });
});
```

### Sensitive Data Handling

```javascript
// Bad - Logs sensitive data
console.log('User login:', { email, password });

// Good - Redact sensitive fields
console.log('User login:', { email, password: '[REDACTED]' });
```

### Error Handling

```javascript
// Bad - Exposes internals
app.use((err, req, res, next) => {
  res.status(500).json({ error: err.stack });
});

// Good - Generic error to client
app.use((err, req, res, next) => {
  console.error(err); // Log full error server-side
  res.status(500).json({ error: 'Internal server error' });
});
```

## Environment Configuration

### Secrets Management

**Never do this:**
```javascript
// AI might generate this in examples
const API_KEY = 'sk-1234567890abcdef';
```

**Always do this:**
```javascript
const API_KEY = process.env.API_KEY;
if (!API_KEY) {
  throw new Error('API_KEY environment variable required');
}
```

### Environment Files

```bash
# .gitignore
.env
.env.local
.env.*.local
*.pem
*.key
```

```bash
# .env.example (commit this, not .env)
API_KEY=your-api-key-here
DATABASE_URL=postgresql://user:pass@localhost/db
```

## Dangerous Operations Checklist

Before allowing AI to run these, verify intent:

### Database Operations

| Operation | Risk Level | Require Approval |
|-----------|------------|------------------|
| SELECT | Low | No |
| INSERT | Medium | Review data |
| UPDATE | High | Always |
| DELETE | Critical | Always |
| DROP | Critical | Always |
| TRUNCATE | Critical | Always |

### File System Operations

| Operation | Risk Level | Require Approval |
|-----------|------------|------------------|
| Read | Low | No (except secrets) |
| Create | Medium | Review path |
| Modify | High | Review changes |
| Delete | Critical | Always |
| Move | High | Always |

### Git Operations

| Operation | Risk Level | Require Approval |
|-----------|------------|------------------|
| status/diff/log | Low | No |
| checkout branch | Medium | Review branch |
| commit | Medium | Review changes |
| push | High | Review destination |
| push --force | Critical | Always |
| reset --hard | Critical | Always |

## Incident Response

### If Secrets Are Exposed

1. **Rotate immediately** - Generate new credentials
2. **Revoke old** - Disable exposed secrets
3. **Audit usage** - Check for unauthorized access
4. **Clean history** - Remove from git history if committed

```bash
# Remove secrets from git history (use with caution)
git filter-branch --force --index-filter \
  'git rm --cached --ignore-unmatch path/to/secret' \
  --prune-empty --tag-name-filter cat -- --all
```

### If Bad Code Is Deployed

1. **Rollback** - Revert to known good state
2. **Assess** - Determine impact
3. **Fix** - Patch the vulnerability
4. **Review** - Understand how it passed review
5. **Improve** - Update review process

## Team Policies

### Required Reviews

```markdown
## AI-Generated Code Review Policy

All AI-generated code MUST be reviewed by a human before merge.

### High-Risk Areas (require senior review)
- Authentication/Authorization
- Payment processing
- Data encryption
- Admin functionality
- Database migrations

### Standard Areas (peer review)
- API endpoints
- UI components
- Utility functions
- Tests
```

### Training Requirements

1. Complete security awareness training
2. Read this guide
3. Understand tool-specific security settings
4. Know how to report security issues

---

Next: [Troubleshooting](../reference/troubleshooting.md) | [Resources](../reference/resources.md)
