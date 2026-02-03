# Troubleshooting Guide

Common issues and solutions when using AI coding assistants.

## Table of Contents

- [Claude Code Issues](#claude-code-issues)
- [GitHub Copilot Issues](#github-copilot-issues)
- [Cursor Issues](#cursor-issues)
- [General AI Tool Issues](#general-ai-tool-issues)

---

## Claude Code Issues

### Installation & Authentication

#### "Command not found: claude"

**Cause**: Claude Code not installed or not in PATH.

**Solution**:
```bash
# Reinstall
npm install -g @anthropic-ai/claude-code

# Verify installation
which claude
claude --version

# If using nvm, ensure global packages are accessible
```

#### "Authentication failed"

**Cause**: Invalid or expired credentials.

**Solution**:
```bash
# Log out and back in
claude logout
claude login

# Check account status at anthropic.com
```

#### "Rate limit exceeded"

**Cause**: Too many requests in a short period.

**Solution**:
- Wait a few minutes before retrying
- Use `/compact` to reduce context size
- Consider upgrading your plan
- Break large tasks into smaller chunks

### Context & Understanding

#### "Claude doesn't understand my codebase"

**Cause**: Insufficient context or missing CLAUDE.md.

**Solution**:
1. Create or improve your CLAUDE.md file:
   ```markdown
   # CLAUDE.md

   ## Project Overview
   [Brief description of your project]

   ## Tech Stack
   - [Framework/Language]
   - [Key libraries]

   ## Architecture
   - src/ - Source code
   - tests/ - Test files

   ## Commands
   - npm run dev - Start development
   - npm test - Run tests
   ```

2. Be explicit in prompts:
   ```
   > Looking at src/api/users.ts, explain how user
   > authentication works in this project
   ```

#### "Claude forgets previous context"

**Cause**: Context was compacted or conversation is too long.

**Solution**:
- Use `/compact` strategically (saves context but summarizes)
- Reference files explicitly: `Looking at src/file.ts...`
- Break long sessions into focused tasks
- Start fresh for new tasks: `/clear`

#### "Claude makes changes to wrong files"

**Cause**: Ambiguous instructions or file name confusion.

**Solution**:
- Use full file paths: `src/components/Button.tsx`
- Be specific: "Edit the Button component in src/components/, not in tests/"
- Review proposed changes before accepting

### Commands & Operations

#### "Command was blocked"

**Cause**: Command not in allowed list or flagged as dangerous.

**Solution**:
1. Check `.claude/settings.json`:
   ```json
   {
     "permissions": {
       "allowedCommands": ["npm test", "npm run lint"]
     }
   }
   ```

2. Add command to allowed list if safe
3. For one-time use, approve when prompted

#### "/commit creates wrong message"

**Cause**: Insufficient understanding of changes.

**Solution**:
- Review changes first: `git diff`
- Provide context: "Commit these changes with focus on [aspect]"
- Edit the message before confirming

---

## GitHub Copilot Issues

### Setup & Connection

#### "Copilot not providing suggestions"

**Cause**: Not authenticated, disabled, or file type excluded.

**Solution**:
1. Check status icon in VS Code (bottom right)
2. Verify authentication:
   - `GitHub Copilot: Sign Out`
   - `GitHub Copilot: Sign In`
3. Check file type settings:
   ```json
   {
     "github.copilot.enable": {
       "*": true,
       "markdown": true
     }
   }
   ```
4. Verify subscription is active

#### "Copilot Chat not available"

**Cause**: Extension not installed or not included in plan.

**Solution**:
1. Install "GitHub Copilot Chat" extension separately
2. Verify your plan includes Chat (most do)
3. Restart VS Code

### Suggestion Quality

#### "Suggestions are irrelevant"

**Cause**: Insufficient context.

**Solution**:
1. Open related files (models, types, similar code)
2. Add descriptive comments:
   ```javascript
   // Calculate monthly payment for a loan
   // using compound interest formula
   // principal: loan amount, rate: annual rate, months: term
   function calculatePayment(principal, rate, months) {
   ```
3. Use meaningful variable names
4. Add custom instructions in `.github/copilot-instructions.md`

#### "Suggestions don't match our style"

**Cause**: No custom instructions configured.

**Solution**:
Create `.github/copilot-instructions.md`:
```markdown
## Code Style
- Use TypeScript strict mode
- Prefer functional components
- Use named exports
- Add JSDoc comments to public functions

## Patterns
- Use React Query for API calls
- Use Zod for validation
- Follow repository pattern for data access
```

#### "Suggestions are slow"

**Cause**: Network issues or server load.

**Solution**:
- Check internet connection
- Check Copilot status: [githubstatus.com](https://githubstatus.com)
- Reduce file size (close unneeded files)
- Restart VS Code

### Chat Issues

#### "@workspace doesn't find files"

**Cause**: Workspace not indexed or file excluded.

**Solution**:
1. Ensure workspace is open (not just a file)
2. Check if file is in `.gitignore` (may be excluded)
3. Try being more specific: `@path/to/specific/file.ts`
4. Reload VS Code window

---

## Cursor Issues

### Indexing Problems

#### "Cursor doesn't understand my codebase"

**Cause**: Codebase not indexed.

**Solution**:
1. Check indexing status:
   - Settings > Features > Codebase Indexing
2. Trigger re-index:
   - `Cmd/Ctrl+Shift+P` > "Reindex Codebase"
3. Wait for indexing to complete (check status bar)
4. Exclude large directories:
   - node_modules, .git, dist, build

#### "Indexing is very slow"

**Cause**: Large codebase or many files.

**Solution**:
1. Add exclusions in settings:
   ```
   node_modules/
   dist/
   build/
   .git/
   *.log
   ```
2. Index only relevant directories
3. Wait for initial index (subsequent updates are faster)

### Rules Not Applied

#### ".cursorrules not working"

**Cause**: Deprecated format or syntax error.

**Solution**:
1. Migrate to new format (`.cursor/rules/*.mdc`)
2. Check file location (must be in project root)
3. Verify syntax:
   ```markdown
   ---
   description: My rules
   globs: ["**/*.ts"]
   alwaysApply: true
   ---

   # Rules content here
   ```

#### "Rules only apply sometimes"

**Cause**: Glob patterns don't match or `alwaysApply` is false.

**Solution**:
1. Check glob patterns match your files
2. Set `alwaysApply: true` for global rules
3. Create file-specific rules with targeted globs

### Composer Issues

#### "Composer changes wrong files"

**Cause**: Ambiguous request.

**Solution**:
1. Be specific about which files:
   ```
   > Create a new settings page. Create new files in
   > src/pages/settings/ - don't modify existing files.
   ```
2. Review proposed changes before accepting
3. Accept/reject per file

#### "Composer creates too many files"

**Cause**: Request too broad.

**Solution**:
- Break into smaller requests
- Specify exactly what files you want
- Use "only modify existing files" in prompt

---

## General AI Tool Issues

### Poor Code Quality

#### "Generated code has bugs"

**All tools**:
1. Always review generated code
2. Run tests after AI changes
3. Be more specific in prompts:
   ```
   > Handle the case where user is null
   > Include input validation
   > Add error handling for network failures
   ```

#### "Generated code doesn't follow our patterns"

**All tools**:
1. Configure tool-specific instructions:
   - Claude: CLAUDE.md
   - Copilot: .github/copilot-instructions.md
   - Cursor: .cursor/rules/*.mdc
2. Reference existing code: "Follow the pattern in @file.ts"
3. Be explicit about conventions

### Security Concerns

#### "AI generated insecure code"

**All tools**:
1. Always review security-sensitive code
2. Add security requirements to prompts:
   ```
   > Use parameterized queries (no string concatenation)
   > Sanitize all user input
   > Don't log sensitive data
   ```
3. Use security-focused review prompts
4. Run security linters (e.g., Semgrep)

#### "AI exposed secrets"

**Prevention**:
1. Never paste code containing secrets
2. Use environment variables
3. Configure exclusions for .env files
4. Use pre-commit hooks (gitleaks)

### Context Issues

#### "AI gives inconsistent answers"

**Cause**: Context changed or conversation too long.

**Solution**:
- Start fresh for new topics
- Provide explicit context each time
- Use file references instead of pasting code
- Keep conversations focused on one task

#### "AI hallucinates APIs/functions"

**Cause**: AI doesn't know your codebase or invents plausible-sounding code.

**Solution**:
1. Reference real files: `@path/to/file.ts`
2. Be skeptical of unfamiliar APIs
3. Verify suggestions against documentation
4. Ask AI to confirm: "Does this function exist in our codebase?"

### Performance Issues

#### "Tool is very slow"

**All tools**:
1. Check internet connection
2. Reduce context (close unnecessary files)
3. Use more specific prompts
4. Check service status pages
5. Restart the tool

#### "Running out of context/tokens"

**Solution**:
1. Start fresh conversations for new tasks
2. Use `/compact` (Claude) to summarize
3. Reference files instead of pasting content
4. Break large tasks into smaller pieces

---

## Quick Fixes

| Issue | Quick Fix |
|-------|-----------|
| Tool not responding | Restart the tool |
| Poor suggestions | Add more context/instructions |
| Wrong file edited | Use full file paths |
| Forgot context | Reference files explicitly |
| Generated bugs | Be more specific, add test requirement |
| Security issues | Add security requirements to prompt |
| Slow performance | Reduce context, check connection |

---

## Getting Help

### Tool-Specific Support

- **Claude Code**: [anthropic.com/support](https://anthropic.com/support)
- **Copilot**: [github.com/community](https://github.com/community)
- **Cursor**: [cursor.com/support](https://cursor.com/support)

### Community Help

- GitHub Discussions for each tool
- Stack Overflow with tool-specific tags
- Reddit communities (r/ClaudeAI, r/cursor)
- Discord servers

### Reporting Issues

When reporting issues:
1. Tool and version
2. OS and environment
3. Steps to reproduce
4. Expected vs actual behavior
5. Error messages (full text)
6. What you've already tried
