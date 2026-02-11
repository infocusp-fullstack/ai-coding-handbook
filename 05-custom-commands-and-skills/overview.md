# Custom Commands, Skills, and Plugins

## TL;DR

Extend AI tools with custom functionality:

| Tool | Extension Type | Location |
|------|---------------|----------|
| Claude Code | Skills, Commands, Plugins | `.claude/skills/`, `.claude/commands/` |
| Cursor | Notepads, Rules | `.cursor/rules/`, Notepads |
| Copilot | Custom Instructions | `.github/instructions/` |

## Concepts

### Commands

Reusable prompts you invoke with a slash:
```
> /review      # Run your review command
> /test        # Run your test command
> /deploy      # Run your deploy command
```

### Skills

Domain knowledge that loads automatically when relevant:
```
Working on API code? → API skill loads automatically
Working on tests? → Testing skill loads automatically
```

### Plugins

Bundles of commands, skills, and agents that others can install:
```
/plugin install feature-dev@claude-plugins-official
```

### Subagents

Specialized AI agents that handle specific tasks:
```
code-explorer → Explores codebase
code-reviewer → Reviews code
code-architect → Designs features
```

## Claude Code Extensions

### Commands (`.claude/commands/`)

Create reusable prompts:

**`.claude/commands/review.md`:**
```markdown
---
description: Review code for issues
---

Review the selected code for:
- Bugs and logic errors
- Security vulnerabilities
- Performance issues
- Missing error handling
- Pattern inconsistencies

Rate each finding: Critical / High / Medium / Low
```

**Usage:**
```
> /review
```

### Skills (`.claude/skills/*/SKILL.md`)

Domain expertise that activates contextually:

**`.claude/skills/api-development/SKILL.md`:**
```markdown
---
trigger: "working on API endpoints, routes, or handlers"
---

# API Development Guidelines

## Response Format
{ success: boolean, data?: T, error?: { code, message } }

## Status Codes
- 200: Success
- 400: Validation error
- 401: Unauthorized
- 500: Server error

## Validation
- Use Zod for input validation
- Validate early, fail fast
```

### Plugins

Install pre-built functionality:

```bash
# Official plugins
/plugin install frontend-design@claude-plugins-official
/plugin install code-review@claude-plugins-official
/plugin install feature-dev@claude-plugins-official

# Third-party
/plugin marketplace add obra/superpowers-marketplace
/plugin install superpowers@superpowers-marketplace
```

## Cursor Extensions

### Rules Files

Create `.cursor/rules/*.mdc` for automatic context:

```markdown
---
description: API development rules
globs: ["src/api/**"]
---

# API Rules

When working on API endpoints:
- Use Zod for validation
- Follow REST conventions
- Return consistent responses
```

### Notepads

Cursor's scratch space for context:
- Store frequently referenced information
- Quick access during development
- Not committed to repo

### @ Commands

Custom context references:
- `@file` - Reference specific file
- `@folder` - Reference directory
- `@codebase` - Search entire project
- `@docs` - Reference documentation

## Copilot Extensions

### Path-Specific Instructions

**`.github/instructions/api.instructions.md`:**
```markdown
---
applyTo: "src/api/**"
---

When working on API code:
- Use Express Router patterns
- Add request logging
- Handle all errors
```

### Chat Participants

Built-in specializations:
- `@workspace` - Project context
- `@terminal` - Terminal help
- `@vscode` - Editor commands

## Practical Examples

### Code Review Command

**`.claude/commands/review.md`:**
```markdown
---
description: Comprehensive code review
---

Review the current changes for:

## Security
- [ ] Input validation
- [ ] Authentication/authorization
- [ ] Data exposure risks

## Quality
- [ ] Logic correctness
- [ ] Error handling
- [ ] Edge cases

## Style
- [ ] Naming conventions
- [ ] Code organization
- [ ] Pattern consistency

Provide specific line references for issues.
```

### Test Generation Command

**`.claude/commands/test.md`:**
```markdown
---
description: Generate tests for selected code
---

Generate comprehensive tests for the selected code:

1. Analyze the function/component
2. Identify test cases:
   - Happy path
   - Edge cases
   - Error conditions
   - Boundary values

3. Write tests following our patterns in __tests__/
4. Use Jest and React Testing Library
5. Include setup/teardown as needed
```

### API Skill

**`.claude/skills/api/SKILL.md`:**
```markdown
---
trigger: "working on src/api/ or API endpoints"
---

# API Development

## Patterns
Use the router pattern from src/api/example.ts

## Response Format
```typescript
interface ApiResponse<T> {
  success: boolean;
  data?: T;
  error?: { code: string; message: string };
}
```

## Validation
```typescript
import { z } from 'zod';

const schema = z.object({
  email: z.string().email(),
});
```

## Error Handling
```typescript
try {
  // operation
} catch (error) {
  throw new ApiError(500, 'Operation failed');
}
```
```

## Best Practices

### 1. Start Simple

Begin with one or two commands for tasks you repeat:
- `/review` - Code review
- `/test` - Test generation
- `/commit` - Commit workflow

### 2. Be Specific

```markdown
# Bad - too vague
Review this code

# Good - specific guidance
Review for:
- Security (SQL injection, XSS)
- Performance (N+1 queries)
- Error handling completeness
```

### 3. Include Examples

```markdown
## Response Format

Example success:
```json
{ "success": true, "data": { "id": 1 } }
```

Example error:
```json
{ "success": false, "error": { "code": "NOT_FOUND", "message": "User not found" } }
```
```

### 4. Share with Team

- Commit commands/skills to repo
- Document what each does
- Iterate based on feedback

---

Next: [Claude Code Skills](claude-code-skills.md) | [Cursor Custom](cursor-custom.md)
