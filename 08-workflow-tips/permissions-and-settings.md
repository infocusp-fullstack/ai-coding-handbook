# Permissions and Settings

## TL;DR

Configure AI tool permissions to balance:
- **Productivity** - Allow common safe commands
- **Safety** - Require approval for risky operations
- **Workflow** - Match your development style

## Claude Code Settings

### Location

```
# Global settings
~/.claude/settings.json

# Project settings (higher priority)
.claude/settings.json
```

### Permission Levels

```json
{
  "permissions": {
    "defaultBehavior": "ask",  // "allow", "ask", or "deny"
    "allowedCommands": [
      "npm test",
      "npm run lint",
      "npm run build"
    ],
    "deniedCommands": [
      "rm -rf",
      "git push --force"
    ]
  }
}
```

### Common Permission Patterns

**Conservative (Recommended for Production):**
```json
{
  "permissions": {
    "defaultBehavior": "ask",
    "allowedCommands": [
      "npm test",
      "npm run lint",
      "npm run typecheck",
      "git status",
      "git diff"
    ]
  }
}
```

**Liberal (For Prototyping):**
```json
{
  "permissions": {
    "defaultBehavior": "allow",
    "deniedCommands": [
      "rm -rf *",
      "git push --force",
      "git reset --hard",
      "drop database"
    ]
  }
}
```

**Strict (For Sensitive Projects):**
```json
{
  "permissions": {
    "defaultBehavior": "deny",
    "allowedCommands": [
      "npm test -- --watch",
      "git diff"
    ]
  }
}
```

### File Operations

```json
{
  "permissions": {
    "fileOperations": {
      "write": "ask",     // Creating/modifying files
      "delete": "deny",   // Deleting files
      "execute": "ask"    // Running executables
    }
  }
}
```

### Network Operations

```json
{
  "permissions": {
    "network": {
      "fetch": "ask",           // HTTP requests
      "install": "ask",         // Package installation
      "externalServices": "deny" // Third-party APIs
    }
  }
}
```

## Cursor Settings

### Settings Location

```
Settings → Features → AI
Settings → Features → Codebase
Settings → Privacy
```

### Key Settings

**Codebase Indexing:**
```
Features > Codebase Indexing: ON

Exclusions:
- node_modules/
- .git/
- dist/
- build/
- *.log
- .env*
```

**Privacy Mode:**
```
Privacy > Privacy Mode: ON
# Prevents code from being used for training
```

**Auto-Apply:**
```
Features > Composer > Auto-apply: OFF
# Review changes before applying
```

### Cursor Rules Configuration

**Rule priority (highest to lowest):**
1. File-specific rules (matched by glob)
2. Always-apply rules
3. Manual rules (invoked with @)

**Example configuration:**
```
.cursor/
└── rules/
    ├── general.mdc      # alwaysApply: true
    ├── typescript.mdc   # globs: ["**/*.ts"]
    └── security.mdc     # Manual invocation only
```

## GitHub Copilot Settings

### VS Code Settings

```json
{
  // Enable/disable Copilot
  "github.copilot.enable": {
    "*": true,
    "yaml": true,
    "markdown": true,
    "plaintext": false
  },

  // Inline suggestions
  "github.copilot.inlineSuggest.enable": true,

  // Chat settings
  "github.copilot.chat.enabled": true,

  // Telemetry
  "github.copilot.advanced.telemetry": false
}
```

### Organization Policies

Admins can set organization-wide policies:

```
Organization Settings → Copilot → Policies

- Allow/block for all members
- Repository-specific rules
- Content exclusion patterns
```

### Content Exclusions

```json
// .github/copilot-content-exclusions.json
{
  "excludePatterns": [
    "**/secrets/**",
    "**/.env*",
    "**/credentials/**",
    "**/*.pem",
    "**/*.key"
  ]
}
```

## Security Best Practices

### 1. Never Auto-Approve Destructive Commands

Always require approval for:
```
git push --force
git reset --hard
rm -rf
drop database
truncate table
```

### 2. Exclude Sensitive Files

All tools:
```
# Files to exclude from AI context
.env
.env.local
.env.production
credentials.json
*.pem
*.key
secrets/
config/production/
```

### 3. Review File Operations

```json
{
  "permissions": {
    "fileOperations": {
      // Require approval for files outside project
      "outsideProject": "deny",

      // Require approval for config files
      "configFiles": "ask",

      // Require approval for scripts
      "executableFiles": "ask"
    }
  }
}
```

### 4. Audit Commands

Enable command logging:
```json
{
  "logging": {
    "commands": true,
    "fileChanges": true,
    "location": ".claude/logs/"
  }
}
```

### 5. Network Restrictions

```json
{
  "permissions": {
    "network": {
      "allowedDomains": [
        "registry.npmjs.org",
        "api.github.com"
      ],
      "deniedDomains": [
        "*" // Block all others
      ]
    }
  }
}
```

## Team Settings

### Shared Configuration

Commit shared settings to repo:
```
.claude/settings.json          # Claude Code
.github/copilot-instructions.md # Copilot
.cursor/rules/                  # Cursor
```

### Environment-Specific Settings

```json
// .claude/settings.json
{
  "environments": {
    "development": {
      "permissions": {
        "defaultBehavior": "allow"
      }
    },
    "production": {
      "permissions": {
        "defaultBehavior": "deny"
      }
    }
  }
}
```

### Onboarding Checklist

For new team members:

```markdown
## AI Tools Setup Checklist

1. [ ] Install tools (Claude Code, Cursor, Copilot)
2. [ ] Clone repo and verify settings are applied
3. [ ] Review project's CLAUDE.md / copilot-instructions.md
4. [ ] Understand permission model (what requires approval)
5. [ ] Know what files are excluded from AI
6. [ ] Practice workflow with a test task
```

## Troubleshooting

### "Command was denied"

Check your settings:
```bash
# Claude Code
cat .claude/settings.json | jq '.permissions'
```

Either add to allowed list or approve when prompted.

### "Files not being read"

Check exclusions:
- Is file in .gitignore?
- Is file type excluded?
- Is file too large?

### "Settings not applying"

Order of precedence:
1. Project settings (`.claude/settings.json`)
2. User settings (`~/.claude/settings.json`)
3. Defaults

Check for syntax errors:
```bash
# Validate JSON
cat .claude/settings.json | jq .
```

### "Different behavior across team"

Ensure settings are committed:
```bash
git status .claude/
git status .github/
git status .cursor/
```

Everyone should pull latest.

## Settings Reference

### Claude Code Full Settings

```json
{
  "permissions": {
    "defaultBehavior": "ask",
    "allowedCommands": [],
    "deniedCommands": [],
    "fileOperations": {
      "write": "ask",
      "delete": "ask",
      "execute": "ask"
    },
    "network": {
      "fetch": "ask",
      "install": "ask"
    }
  },
  "context": {
    "maxFileSize": 100000,
    "excludePatterns": [],
    "includePatterns": []
  },
  "logging": {
    "enabled": true,
    "level": "info",
    "location": ".claude/logs/"
  }
}
```

### Copilot Full Settings

```json
{
  "github.copilot.enable": {
    "*": true
  },
  "github.copilot.inlineSuggest.enable": true,
  "github.copilot.chat.enabled": true,
  "github.copilot.advanced": {
    "length": 500,
    "temperature": 0.1,
    "top_p": 1
  }
}
```

---

Next: [Debugging Tips](debugging-tips.md) | [Testing with AI](testing-with-ai.md)
