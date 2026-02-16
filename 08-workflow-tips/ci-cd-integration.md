# CI/CD Integration

## TL;DR

| Tool | Quick Setup |
|------|-------------|
| **Claude Code** | Run `/install-github-app` in terminal, then tag `@claude` in issues/PRs |
| **Copilot** | Use Copilot coding agent - assign issues or mention `@copilot` in PRs |

## Why CI/CD with AI?

Traditional CI/CD pipelines:
```
Run tests → Run linting → Deploy (if passing)
```

With AI-powered CI/CD:
```
Run tests → Run linting → AI code review → Security audit → Auto-fix issues → Deploy
```

AI can handle:
- Automated code reviews on every PR
- Security vulnerability scanning
- Issue-to-PR implementation
- Documentation sync checks
- Bug detection before merge

---

## Claude Code GitHub Actions

Claude Code provides an official GitHub Action that integrates AI into your workflow.

### Quick Setup

Run this in your terminal:

```bash
claude
> /install-github-app
```

This command guides you through:
1. Installing the Claude GitHub App
2. Adding your API key as a secret
3. Configuring repository permissions

### Manual Setup

If you prefer manual setup:

1. **Install the GitHub App**: [github.com/apps/claude](https://github.com/apps/claude)
2. **Add secrets**: Go to Repository Settings → Secrets → Actions → Add `ANTHROPIC_API_KEY`
3. **Copy the workflow file**: Create `.github/workflows/claude.yml`

### Basic Workflow

```yaml
name: Claude Code
on:
  issue_comment:
    types: [created]
  pull_request_review_comment:
    types: [created]
jobs:
  claude:
    runs-on: ubuntu-latest
    steps:
      - uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
```

**Usage**: Tag `@claude` in any issue or PR comment:
```
@claude implement user authentication for this feature
@claude fix the TypeError in src/utils.ts
@claude review this PR for security issues
```

### Automated Code Review

```yaml
name: Code Review
on:
  pull_request:
    types: [opened, synchronize]
jobs:
  review:
    runs-on: ubuntu-latest
    steps:
      - uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
          prompt: "/review"
          claude_args: "--max-turns 5"
```

### Issue Automation

```yaml
name: Issue Handler
on:
  issues:
    types: [opened, assigned]
jobs:
  implement:
    runs-on: ubuntu-latest
    steps:
      - uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
          prompt: "Implement the feature described in this issue"
          claude_args: "--max-turns 15"
```

### Headless Mode

Use the `-p` flag for non-interactive automation:

```bash
# Run Claude in headless mode
claude -p "Generate a summary of changes in this PR"
```

```yaml
# Example: Scheduled daily report
name: Daily Report
on:
  schedule:
    - cron: "0 9 * * *"
jobs:
  report:
    runs-on: ubuntu-latest
    steps:
      - uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
          prompt: "Generate a summary of yesterday's commits and open issues"
          claude_args: "--model opus"
```

### Configuration Options

| Parameter | Description |
|-----------|-------------|
| `prompt` | Instructions for Claude (or skill like `/review`) |
| `claude_args` | CLI arguments (e.g., `--max-turns 5`) |
| `anthropic_api_key` | Your Claude API key |
| `trigger_phrase` | Custom trigger (default: `@claude`) |

Common `claude_args`:
- `--max-turns N` - Maximum conversation turns
- `--model claude-sonnet-4-20250514` - Specific model
- `--append-system-prompt "..."` - Additional instructions

---

## GitHub Copilot in CI

Copilot coding agent works directly in GitHub to handle tasks autonomously.

### How It Works

Copilot coding agent:
- Runs in a GitHub Actions-powered environment
- Responds to issue assignments or `@copilot` mentions
- Creates branches, commits, and PRs automatically
- Requests your review when done

### Setup

No installation needed - it's built into GitHub Copilot. Ensure:
- Copilot is enabled for your repository
- You have sufficient Copilot subscription (Pro/Business/Enterprise)

### Using Copilot Coding Agent

**From an Issue:**
1. Assign the issue to Copilot
2. Or add `@copilot` in a comment

**From a PR:**
```
@copilot implement user login feature
@copilot add tests for the auth module
@copilot refactor this function to use async/await
```

**From GitHub Interface:**
- Use the Agents panel on any GitHub page
- Use the agents panel in VS Code with GitHub extension

### Custom Agents

Define custom agents in `.github/agents/`:

```yaml
# .github/agents/security-reviewer.agent.md
name: Security Reviewer
description: Specializes in finding security vulnerabilities
instructions: |
  Review code for security issues including:
  - SQL injection risks
  - XSS vulnerabilities
  - Authentication bypass
  - Sensitive data exposure
tools:
  - github
  - filesystem
```

Place agents in:
- Project: `.github/agents/`
- Organization: `{org}/.github/agents/`
- Global: `~/.copilot/agents/`

### Environment Customization

Create `.github/workflows/copilot-setup-steps.yml` to preinstall dependencies:

```yaml
name: Setup
runs-on: ubuntu-latest
steps:
  - name: Install dependencies
    run: |
      npm ci
      pip install -r requirements.txt
  - name: Setup database
    run: npm run db:migrate
```

---

## Enterprise: AWS Bedrock & Google Vertex

### Claude Code with AWS Bedrock

```yaml
- uses: anthropics/claude-code-action@v1
  with:
    use_bedrock: "true"
    claude_args: '--model us.anthropic.claude-sonnet-4-20250514'
```

Required secrets:
- `AWS_ROLE_TO_ASSUME` - IAM role ARN

### Claude Code with Google Vertex AI

```yaml
- uses: anthropics/claude-code-action@v1
  with:
    use_vertex: "true"
    claude_args: '--model claude-sonnet-4-20250514'
  env:
    ANTHROPIC_VERTEX_PROJECT_ID: ${{ steps.auth.outputs.project_id }}
    CLOUD_ML_REGION: us-east5
```

Required secrets:
- `GCP_WORKLOAD_IDENTITY_PROVIDER`
- `GCP_SERVICE_ACCOUNT`

---

## Security Best Practices

### API Keys
- Never commit API keys - use GitHub Secrets
- Add keys at: Repository Settings → Secrets and variables → Actions
- Reference in workflows: `${{ secrets.ANTHROPIC_API_KEY }}`

### Permissions
- Grant minimum required permissions
- Claude GitHub App needs: Contents (read/write), Issues (read/write), PRs (read/write)

### Review Before Merge
- Always review AI-generated changes
- AI can make mistakes - human oversight is essential

---

## Cost Management

### Tips to Control Spend

1. **Use `--max-turns`** - Limit conversation iterations
   ```yaml
   claude_args: "--max-turns 5"
   ```

2. **Set workflow timeouts**
   ```yaml
   timeout-minutes: 15
   ```

3. **Use concurrency controls**
   ```yaml
   concurrency:
     group: ${{ github.workflow }}-${{ github.ref }}
     cancel-in-progress: true
   ```

4. **Choose appropriate models**
   - Sonnet: Fast, cost-effective for routine tasks
   - Opus: Complex reasoning, important reviews

### Cost Breakdown

| Component | Cost |
|-----------|------|
| GitHub Actions minutes | Standard pricing |
| Claude API tokens | Based on input/output size |
| Copilot | Included in subscription |

---

## Troubleshooting

### Claude not responding to @claude

- Verify GitHub App is installed
- Check workflow is enabled
- Confirm API key is set in secrets
- Ensure comment contains `@claude` (not `/claude`)

### CI not running on AI commits

- Use GitHub App token (not GITHUB_TOKEN)
- Check workflow triggers include correct events
- Verify app has necessary permissions

### Authentication errors

- Confirm API key is valid
- For Bedrock/Vertex: verify credentials configuration
- Check secret names are correct

---

## Resources

- [Claude Code GitHub Actions Documentation](https://code.claude.com/docs/en/github-actions)
- [Claude Code Action Repository](https://github.com/anthropics/claude-code-action)
- [Copilot Coding Agent Documentation](https://docs.github.com/en/copilot/concepts/agents/coding-agent/about-coding-agent)
- [Copilot Coding Agent How-To](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/coding-agent)
- [GitHub Copilot Documentation](https://docs.github.com/en/copilot)

---

Next: [Debugging Tips](debugging-tips.md) | [Multi-Agent Patterns](multi-agent.md)
