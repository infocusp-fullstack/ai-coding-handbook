# GitHub Copilot Setup Guide

## TL;DR

1. Install the GitHub Copilot extension in VS Code
2. Sign in with your GitHub account (requires Copilot subscription)
3. Start coding - suggestions appear automatically
4. Press `Tab` to accept, `Esc` to dismiss

## What is GitHub Copilot?

GitHub Copilot is an AI pair programmer that provides:

- **Inline code completions** - Suggestions as you type
- **Copilot Chat** - Conversational AI in your editor
- **Copilot Edits** - Multi-file editing capabilities
- **Copilot Agent** - Autonomous task execution (Enterprise)

## Installation

### VS Code

1. Open VS Code
2. Go to Extensions (Ctrl+Shift+X)
3. Search for "GitHub Copilot"
4. Install both:
   - **GitHub Copilot** - Code completions
   - **GitHub Copilot Chat** - Chat interface

### JetBrains IDEs

1. Open Settings/Preferences
2. Go to Plugins
3. Search for "GitHub Copilot"
4. Install and restart IDE

### Neovim

```lua
-- Using lazy.nvim
{
  "github/copilot.vim",
  config = function()
    vim.g.copilot_no_tab_map = true
  end
}
```

## Authentication

1. After installing, you'll see a prompt to sign in
2. Click "Sign in to GitHub"
3. Authorize the GitHub Copilot application
4. Return to your editor

## Basic Usage

### Inline Completions

Just start typing - Copilot suggests completions in gray text:

```python
def calculate_fibonacci(n):
    # Copilot will suggest the implementation
```

**Keyboard shortcuts:**

| Action | Shortcut |
|--------|----------|
| Accept suggestion | `Tab` |
| Dismiss | `Esc` |
| Next suggestion | `Alt+]` |
| Previous suggestion | `Alt+[` |
| Accept word | `Ctrl+Right` |

### Copilot Chat

Open with `Ctrl+Shift+I` (VS Code) and ask questions:

```
> Explain this function
> How do I add error handling here?
> Write tests for the selected code
```

### Chat Participants

Use `@` to invoke specialized agents:

| Participant | Purpose |
|-------------|---------|
| `@workspace` | Questions about your codebase |
| `@vscode` | VS Code settings and features |
| `@terminal` | Terminal commands |
| `@github` | GitHub-related queries |

### Slash Commands in Chat

| Command | Description |
|---------|-------------|
| `/explain` | Explain selected code |
| `/fix` | Suggest fixes for problems |
| `/tests` | Generate unit tests |
| `/doc` | Add documentation |
| `/simplify` | Simplify complex code |

## Custom Instructions

### Repository-Wide Instructions

Create `.github/copilot-instructions.md` in your repository:

```markdown
# Copilot Instructions

## Code Style
- Use TypeScript for all new files
- Follow functional programming patterns
- Use named exports, not default exports

## Testing
- Use Jest for unit tests
- Follow AAA pattern (Arrange, Act, Assert)
- Mock external dependencies

## Documentation
- Add JSDoc comments to all public functions
- Include @param and @returns tags
```

### Path-Specific Instructions

Create `.github/instructions/` directory with targeted rules:

```
.github/
└── instructions/
    ├── api.instructions.md      # For src/api/**
    ├── components.instructions.md # For src/components/**
    └── tests.instructions.md    # For **/*.test.ts
```

Example `api.instructions.md`:

```markdown
---
applyTo: "src/api/**"
---

- All API handlers should validate input using zod
- Return consistent error responses with status codes
- Log all errors with request context
```

### Organization Instructions (Enterprise)

Organization admins can set instructions at:
`Settings > Copilot > Custom Instructions`

## Best Practices

### 1. Write Good Comments

Copilot uses comments as context:

```python
# Parse CSV file, skip header row, return list of dictionaries
# with keys: name, email, department
def parse_employee_csv(filepath):
    # Copilot generates better code with this context
```

### 2. Use Meaningful Names

```javascript
// Better context for Copilot
function calculateMonthlyPaymentWithInterest(principal, rate, years) {
    // vs
}
function calc(p, r, y) {
    // Less context, worse suggestions
}
```

### 3. Provide Examples

```typescript
// Format: "2024-01-15" -> "January 15, 2024"
// Examples:
//   "2024-12-25" -> "December 25, 2024"
//   "2023-01-01" -> "January 1, 2023"
function formatDate(isoDate: string): string {
```

### 4. Open Related Files

Copilot uses open files as context. When working on:
- API endpoint → open the related model and types
- Component → open related styles and tests
- New feature → open similar existing features

### 5. Review Suggestions Critically

Always review before accepting:
- Check for security issues
- Verify business logic correctness
- Ensure it matches your patterns
- Watch for hallucinated APIs

## Configuration

### VS Code Settings

```json
{
  "github.copilot.enable": {
    "*": true,
    "markdown": false,
    "plaintext": false
  },
  "github.copilot.advanced": {
    "inlineSuggestCount": 3
  }
}
```

### Disable for Specific Files

Add to `.gitignore`-style file `.github/copilot-ignore`:

```
# Don't use Copilot for sensitive files
.env*
**/secrets/**
**/credentials/**
```

## Troubleshooting

### No Suggestions Appearing

1. Check Copilot status in bottom-right of VS Code
2. Verify authentication: `GitHub Copilot: Sign Out` then sign back in
3. Check if file type is enabled in settings
4. Ensure you have an active Copilot subscription

### Suggestions Are Poor Quality

1. Add custom instructions in `.github/copilot-instructions.md`
2. Open related files for context
3. Write better comments describing intent
4. Use more descriptive variable/function names

### Copilot Chat Not Working

1. Ensure you have Copilot Chat extension installed
2. Check you have Copilot Chat access (included in most plans)
3. Try reloading VS Code window

## Resources

- [GitHub Copilot Documentation](https://docs.github.com/copilot)
- [Custom Instructions Guide](https://docs.github.com/copilot/customizing-copilot/adding-custom-instructions-for-github-copilot)
- [VS Code Copilot Guide](https://code.visualstudio.com/docs/copilot/overview)
- [Mastering Copilot Course](https://github.com/microsoft/Mastering-GitHub-Copilot-for-Paired-Programming)
- [Awesome Copilot](https://github.com/github/awesome-copilot)

---

Next: [Cursor Setup](cursor-setup.md) | [Prompting Guide](../best-practices/prompting-guide.md)
