# When to Use Which Tool

## TL;DR

| Need | Tool | Why |
|------|------|-----|
| Quick code completion while typing | **Copilot** | Lowest friction, inline |
| Complex multi-file refactoring | **Claude Code** | Best reasoning, terminal-native |
| Exploring large codebase | **Cursor** | Deep indexing, codebase search |
| Understanding unfamiliar code | **Any chat feature** | All handle Q&A well |
| Creating commits/PRs | **Claude Code** | Built-in Git workflows |
| Visual UI work | **Cursor Composer** | See changes in context |

## Tool Comparison Matrix

| Capability | Claude Code | GitHub Copilot | Cursor |
|------------|-------------|----------------|--------|
| **Inline completions** | No | Excellent | Good |
| **Multi-file editing** | Excellent | Good (Edits) | Excellent |
| **Codebase awareness** | Good | Moderate | Excellent |
| **Terminal integration** | Native | No | No |
| **Git operations** | Excellent | Basic | Basic |
| **IDE integration** | Terminal | Deep | Is the IDE |
| **Plan/think mode** | Yes | No | No |
| **Custom commands** | Yes | Slash commands | Limited |
| **Autonomous tasks** | Yes | Agent mode | Limited |
| **Pricing** | $20/mo (Pro) | $10-39/mo | $20/mo (Pro) |

## Detailed Use Cases

### Use Copilot When...

**You want frictionless completions while coding:**
```python
def calculate_compound_interest(principal, rate, time):
    # Just start typing, Copilot suggests the rest
```

**You need quick inline edits:**
- Press `Cmd/Ctrl+I` on selection
- Describe the change
- Accept or reject

**You're already in VS Code/JetBrains:**
- No context switching
- Works in the background
- Lightweight integration

**Best for:**
- Daily coding flow
- Boilerplate code
- Repetitive patterns
- Quick documentation
- Small, focused changes

### Use Claude Code When...

**You need complex reasoning:**
```
> Analyze this authentication flow and identify security
> vulnerabilities. Then propose and implement fixes.
```

**You want autonomous task completion:**
```
> Create a REST API for user management with:
> - CRUD operations
> - Input validation
> - Error handling
> - Tests
> Let me know when you're done.
```

**You need Git workflow automation:**
```
> /commit       # Smart commit with analysis
> /review-pr    # Detailed PR review
> Create a PR for this feature branch
```

**You prefer terminal-based workflow:**
- SSH into remote servers
- Use alongside other CLI tools
- Scriptable and automatable

**You want plan-before-execute:**
```
> /plan Refactor the authentication system to use OAuth2
```

**Best for:**
- Complex refactoring
- Multi-file changes
- Code review
- Architecture decisions
- Debugging complex issues
- CI/CD and DevOps tasks

### Use Cursor When...

**You need deep codebase understanding:**
```
> @codebase How does our payment processing work?
> Show me all places where we validate user input
```

**You're building new features visually:**
- Composer mode shows all file changes
- Visual diff before applying
- Easy to accept/reject per file

**You want inline editing with context:**
- Select code, press `Cmd/Ctrl+K`
- Cursor knows about related files
- Suggestions match your patterns

**You're exploring an unfamiliar codebase:**
```
> @codebase Explain the architecture of this project
> @git What changed in the last month?
```

**Best for:**
- Learning new codebases
- Multi-file feature development
- Visual review of AI changes
- Teams standardizing on one editor
- Projects with complex file relationships

## Decision Flowchart

```
Start
  │
  ├─ Quick completion while typing?
  │     └─ YES → Copilot
  │
  ├─ Need to understand large codebase?
  │     └─ YES → Cursor (@codebase)
  │
  ├─ Complex multi-file refactor?
  │     └─ YES → Claude Code or Cursor Composer
  │
  ├─ Creating commit/PR?
  │     └─ YES → Claude Code (/commit, /review-pr)
  │
  ├─ Autonomous task execution?
  │     └─ YES → Claude Code
  │
  ├─ Terminal/CLI workflow?
  │     └─ YES → Claude Code
  │
  ├─ Visual IDE experience?
  │     └─ YES → Cursor
  │
  └─ General coding assistance?
        └─ Use what you're already in
```

## Combining Tools

Many developers use multiple tools:

### Common Combinations

**Copilot + Claude Code:**
- Copilot for daily inline completions
- Claude Code for complex tasks, reviews, commits
- Switch to terminal when IDE isn't enough

**Cursor + Claude Code:**
- Cursor as primary IDE with AI features
- Claude Code for autonomous tasks, CI/CD work
- Use Cursor for visual, Claude for terminal

**All Three:**
- Copilot always on for completions
- Cursor for feature development
- Claude Code for DevOps, reviews, complex debugging

### Workflow Example

```
1. Start feature branch
2. Use Cursor Composer to scaffold the feature
3. Use Copilot for implementation details
4. Use Claude Code to review and create PR
```

## Team Considerations

### Standardization

**Option 1: Single Tool**
- Easier onboarding
- Consistent workflows
- Simpler billing

**Option 2: Primary + Secondary**
- Main tool for most work
- Secondary for specific use cases
- Document when to use each

**Option 3: Developer Choice**
- Most flexibility
- Harder to share workflows
- More varied documentation needs

### Cost Analysis

| Tool | Individual | Team/Business |
|------|------------|---------------|
| Claude Code | $20/mo (Pro) | API pricing |
| GitHub Copilot | $10/mo | $19/user/mo |
| Cursor | $20/mo | $40/user/mo |

**Combined cost per developer:** $30-60/month depending on combination

### Enterprise Features

| Feature | Claude Code | Copilot | Cursor |
|---------|-------------|---------|--------|
| SSO/SAML | Team plan | Business | Business |
| Admin controls | Limited | Yes | Yes |
| Audit logs | Limited | Yes | Limited |
| Custom models | API access | Enterprise | Yes |
| On-premise | No | Enterprise | No |

## Migration Paths

### From Copilot to Cursor

1. Install Cursor
2. Import VS Code settings
3. Keep Copilot extension initially
4. Gradually use Cursor's native AI
5. Disable Copilot when comfortable

### Adding Claude Code

1. Install alongside existing tools
2. Start with specific use cases (commits, reviews)
3. Expand to complex tasks
4. Create team commands/skills

### From Single Tool to Multi-Tool

1. Document current workflows
2. Identify gaps/pain points
3. Add tool for specific gaps
4. Create decision guide for team
5. Update documentation

---

Next: [Code Review with AI](code-review-with-ai.md) | [Sample Prompts](../reference/sample-prompts.md)
