# Claude Code Plugin Marketplace

## TL;DR

```bash
# Browse available plugins
/plugin > Discover

# Install a plugin from official marketplace
/plugin install frontend-design@claude-plugins-official

# Install from third-party marketplace
/plugin marketplace add obra/superpowers-marketplace
/plugin install superpowers@superpowers-marketplace
```

## What are Plugins?

Plugins extend Claude Code with additional capabilities:

- **Skills** - Domain knowledge and guided workflows
- **Agents** - Specialized AI agents for specific tasks
- **Commands** - Custom slash commands
- **Hooks** - Automated actions triggered by events
- **MCP Servers** - External tool integrations

## Official Anthropic Plugin Directory

Anthropic maintains an official plugin directory at [github.com/anthropics/claude-plugins-official](https://github.com/anthropics/claude-plugins-official).

### Directory Structure

```
claude-plugins-official/
├── plugins/              # Internal Anthropic plugins
└── external_plugins/     # Community & partner plugins
```

### Browse & Install

```bash
# Open the plugin discovery interface
/plugin > Discover

# Install from official directory
/plugin install {plugin-name}@claude-plugins-official
```

## Featured Official Plugins

Based on [claude.com/plugins](https://claude.com/plugins), here are the most popular plugins:

### Frontend Design (141k+ installs)

```bash
/plugin install frontend-design@claude-plugins-official
```

**What it does:**
- Creates distinctive, production-grade frontend interfaces
- Avoids generic "AI-generated" aesthetics
- Guides bold design choices, typography, animations
- Auto-invoked when working on frontend code

**Use cases:**
- Building landing pages
- Creating UI components
- Designing dashboards
- Prototyping interfaces

**Commands:**
- `/frontend-design` - Invoke for frontend guidance

---

### Code Review (68k+ installs)

```bash
/plugin install code-review@claude-plugins-official
```

**What it does:**
- Comprehensive AI code review using specialized agents
- Confidence-based scoring to filter false positives
- Multiple focused review perspectives

**Included agents:**
- `comment-analyzer` - Reviews code comments
- `pr-test-analyzer` - Analyzes test coverage
- `silent-failure-hunter` - Finds hidden error paths
- `type-design-analyzer` - Reviews type design
- `code-reviewer` - General code quality
- `code-simplifier` - Suggests simplifications

**Commands:**
- `/code-review:review-pr` - Full PR review
- `/code-review:quick-review` - Fast focused review

---

### Feature Dev (63k+ installs)

```bash
/plugin install feature-dev@claude-plugins-official
```

**What it does:**
- Guided feature development workflow
- Codebase exploration before implementation
- Architecture-focused design phase

**Included agents:**
- `code-explorer` - Deep codebase analysis
- `code-architect` - Feature design and planning
- `code-reviewer` - Implementation review

**Commands:**
- `/feature-dev` - Start guided feature development

---

### Superpowers (Popular Third-Party)

```bash
/plugin marketplace add obra/superpowers-marketplace
/plugin install superpowers@superpowers-marketplace
```

**What it does:**
- Teaches Claude structured development methodologies
- Enforces TDD Red-Green-Refactor cycles
- Systematic debugging with root cause analysis
- Socratic brainstorming before coding

**Key skills:**
- `/brainstorming` - Explore requirements before coding
- `/tdd` - Test-driven development workflow
- `/debugging` - Four-phase debugging methodology
- `/execute-plan` - Batched implementation with review

**Why it's popular:**
> "Enforces disciplined practices where tests must fail before implementation, requires root cause investigation before any fixes, and refines requirements through Socratic brainstorming before coding begins."

---

### Test-Driven Generation (TDG)

```bash
/plugin install tdg@claude-plugins-official
```

**What it does:**
- Systematic Red-Green-Refactor TDD cycle
- Auto-detects current phase (red/green/refactor)
- Language and framework detection

**Commands:**
- `/tdg:init` - Initialize configuration
- `/tdg:atomic-commit` - Commit after each phase

**Why TDD with plugins?**

Without specialized plugins, TDD in a single context window causes "context pollution" - implementation details bleed into test logic. The TDG plugin uses subagents to isolate each phase:
- Test writer focuses purely on test design
- Implementer sees only the failing test
- Refactorer evaluates clean implementation code

---

### Code Simplifier

Part of the **Code Review** plugin or available separately.

```bash
/plugin install code-simplifier@claude-plugins-official
```

**What it does:**
- Analyzes code for unnecessary complexity
- Suggests simplifications while preserving functionality
- Focuses on readability and maintainability

**Commands:**
- `/code-simplifier:simplify` - Simplify selected code

---

## Other Notable Plugins

| Plugin | Installs | Description |
|--------|----------|-------------|
| **Context7** | 93k+ | Upstash MCP server for live documentation lookup |
| **GitHub** | 65k+ | Official GitHub MCP server for repo management |
| **Playwright** | - | Browser automation for testing |
| **Supabase** | - | Supabase database integration |

## Installing Third-Party Marketplaces

Beyond the official directory, community marketplaces exist:

```bash
# Add a marketplace
/plugin marketplace add {owner}/{repo}

# Example: Add superpowers marketplace
/plugin marketplace add obra/superpowers-marketplace

# Then install from it
/plugin install {plugin}@{marketplace-name}
```

### Popular Marketplaces

| Marketplace | Repository | Focus |
|-------------|------------|-------|
| Everything Claude Code | `affaan-m/everything-claude-code` | Production configs |
| Superpowers | `obra/superpowers-marketplace` | Development methodologies |
| Claude Code Templates | `aitmpl` | Template collection |

## Plugin Structure

If you want to create your own plugins:

```
my-plugin/
├── .claude-plugin/
│   └── plugin.json      # Plugin metadata (required)
├── .mcp.json            # MCP server config (optional)
├── commands/            # Slash commands
├── agents/              # Agent definitions
├── skills/              # Skill definitions
└── README.md            # Documentation
```

### Example plugin.json

```json
{
  "name": "my-plugin",
  "version": "1.0.0",
  "description": "My custom plugin",
  "author": "Your Name",
  "commands": ["commands/"],
  "skills": ["skills/"],
  "agents": ["agents/"]
}
```

## Best Practices

### 1. Start with Official Plugins

The official plugins are well-maintained and tested:
- `frontend-design` for UI work
- `code-review` for PR reviews
- `feature-dev` for new features

### 2. Use TDD Plugins for Quality

For test-driven development:
- `superpowers` for full TDD methodology
- `tdg` for Red-Green-Refactor cycle

### 3. Combine Plugins

Plugins work together:
```
Feature Request
    │
    ▼
/feature-dev (explore & design)
    │
    ▼
/tdd (implement with tests)
    │
    ▼
/code-review (review before merge)
```

### 4. Check Plugin Reputation

Before installing third-party plugins:
- Check install count on claude.com/plugins
- Review the source repository
- Look for active maintenance

## Submitting Plugins

To submit your plugin to the official directory:

1. Create plugin following the structure above
2. Test thoroughly
3. Submit via [claude.com/plugins](https://claude.com/plugins) "Submit your plugin"
4. Or PR to [anthropics/claude-plugins-official](https://github.com/anthropics/claude-plugins-official)

## Troubleshooting

### Plugin not installing

```bash
# Check if marketplace is added
/plugin marketplace list

# Try adding the marketplace again
/plugin marketplace add claude-plugins-official
```

### Plugin commands not appearing

```bash
# Verify installation
/plugin list

# Reinstall if needed
/plugin uninstall {plugin}
/plugin install {plugin}@{marketplace}
```

### Plugin conflicts

If plugins conflict:
- Uninstall conflicting plugins
- Use one at a time for overlapping functionality
- Check plugin documentation for compatibility notes

## Resources

- [Official Plugin Directory](https://github.com/anthropics/claude-plugins-official)
- [Plugin Documentation](https://code.claude.com/docs/en/plugins)
- [Browse Plugins](https://claude.com/plugins)
- [Create Plugins Guide](https://code.claude.com/docs/en/plugins)
- [Superpowers Plugin](https://claude.com/plugins/superpowers)

---

Next: [Claude Code Setup](claude-code-setup.md) | [Sample Prompts](../reference/sample-prompts.md)
