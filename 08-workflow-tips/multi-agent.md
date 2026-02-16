# Multi-Agent Patterns

## TL;DR

Multi-agent workflows use specialized AI "agents" for different tasks:
- **Explorer agents** - Understand codebases
- **Architect agents** - Design solutions
- **Implementer agents** - Write code
- **Reviewer agents** - Check quality

## Why Multi-Agent?

### Single Agent Limitations

One AI context trying to do everything:
- Context gets polluted with mixed concerns
- Test knowledge bleeds into implementation
- Design decisions get lost in code details
- Quality degrades over long sessions

### Multi-Agent Benefits

Specialized agents for specialized tasks:
- Each agent focuses on one thing
- Fresh context for each phase
- Better separation of concerns
- Parallel execution where possible

## Claude Code Subagents

### Built-in Subagents

Claude Code spawns subagents automatically for complex tasks:

```
> Explore how authentication works in this codebase

[Claude spawns an explorer agent that:]
- Searches for auth-related files
- Reads and analyzes code
- Summarizes findings
- Returns to main conversation
```

### Explicit Subagent Patterns

**Research Agent:**
```
> Use a subagent to thoroughly explore the payment processing code.
> I want to understand all the edge cases before we make changes.
```

**Parallel Agents:**
```
> Run these analyses in parallel:
> 1. Find all security vulnerabilities in src/api/
> 2. Check for performance issues in src/lib/
> 3. Review test coverage in __tests__/
```

### Plugin Agents

The feature-dev plugin provides specialized agents:

```bash
# Install the plugin
/plugin install feature-dev@claude-plugins-official
```

**code-explorer agent:**
```
> /feature-dev
# Starts guided workflow with explorer agent first
```

**code-architect agent:**
```
# After exploration, architect agent designs the solution
```

**code-reviewer agent:**
```
# After implementation, reviewer agent checks quality
```

## Multi-Agent Workflow Example

### Scenario: Add Search Functionality

**Step 1: Exploration Agent**
```
> Before we add search, I need a subagent to thoroughly explore:
> 1. Existing search implementations (if any)
> 2. Database query patterns
> 3. API endpoint patterns
> 4. Frontend state management patterns
>
> Spawn an exploration agent and report back.
```

Agent returns:
```
Exploration complete:

1. No existing search - this is new functionality
2. Database: Prisma with PostgreSQL, uses repository pattern
3. API: REST endpoints in src/app/api/, uses Zod validation
4. Frontend: React Query for data fetching, Zustand for state

Key files to reference:
- src/repositories/userRepository.ts (query pattern)
- src/app/api/users/route.ts (API pattern)
- src/hooks/useUsers.ts (data fetching pattern)
```

**Step 2: Architect Agent**
```
> Based on the exploration, design the search feature:
> - Full-text search across products
> - Filters for category, price range
> - Autocomplete suggestions
>
> Create a detailed architecture document.
```

Agent produces:
```
## Search Architecture

### Components
1. SearchService - Core search logic
2. SearchIndex - Elasticsearch integration
3. SearchAPI - REST endpoints
4. useSearch - Frontend hook
5. SearchBar - UI component

### Data Flow
User Input → SearchBar → useSearch → SearchAPI → SearchService → SearchIndex

### Files to Create
...
```

**Step 3: Implementation Agent**
```
> Implement the SearchService from the architecture.
> Follow the patterns identified in exploration.
```

**Step 4: Review Agent**
```
> Review the implemented search functionality:
> - Check for SQL injection risks
> - Verify proper error handling
> - Ensure consistent with existing patterns
> - Check test coverage
```

## TDD with Multi-Agent

Test-Driven Development benefits from context isolation:

### Without Multi-Agent (Context Pollution)

```
> Write a test for the payment processor
> [Test written]
> Now implement the payment processor
> [Implementation influenced by test details - bias creep]
```

### With Multi-Agent (Clean Separation)

```
# Agent 1: Test Writer
> Write comprehensive tests for a payment processor that:
> - Processes valid payments
> - Rejects invalid cards
> - Handles network timeouts
> [Tests written in isolation]

# Agent 2: Implementer (fresh context)
> Here are the failing tests. Implement code to make them pass.
> [Implementer only sees tests, not test-writing rationale]

# Agent 3: Refactorer
> Tests pass. Review and refactor for clarity.
> [Fresh perspective on code quality]
```

### Using TDG Plugin

```bash
/plugin install tdg@claude-plugins-official

# TDG manages the multi-agent TDD cycle:
> /tdg:init
> Write a payment processor

# Red phase: Test agent writes failing test
# Green phase: Implement agent makes it pass
# Refactor phase: Reviewer agent cleans up
```

## Parallel Agent Patterns

### Independent Analysis

Run multiple analyses simultaneously:

```
> Run these in parallel:
>
> Agent A: Security audit of src/api/
> Agent B: Performance profiling of src/lib/
> Agent C: Dependency vulnerability scan
>
> Compile results when all complete.
```

### Feature Development Parallel Tracks

```
> For the new dashboard feature, run in parallel:
>
> Backend Agent: Design and implement API endpoints
> Frontend Agent: Design and implement UI components
>
> We'll integrate after both complete their designs.
```

### Competitive Solutions

```
> I want two different approaches to implementing caching:
>
> Agent A: Design a Redis-based solution
> Agent B: Design an in-memory solution
>
> Compare pros/cons when both complete.
```

## Agent Communication Patterns

### Sequential Handoff

```
Explorer → Architect → Implementer → Reviewer
   │           │            │           │
   └─ Report ──┘─ Design ───┘─ Code ────┘─ Feedback
```

### Hub and Spoke

```
         ┌── Agent A (API) ──┐
         │                   │
Main ────┼── Agent B (UI) ───┼── Compile
Context  │                   │
         └── Agent C (DB) ───┘
```

### Review Loop

```
Implementer ─── Code ───▶ Reviewer
     ▲                        │
     │                        │
     └─── Feedback ───────────┘
```

## Best Practices

### 1. Clear Agent Responsibilities

```
# Good: Specific scope
> Explorer agent: Find all database query patterns

# Bad: Vague scope
> Agent: Look around the code
```

### 2. Explicit Handoff

```
> [To Architect] Based on the explorer's findings:
> [Paste relevant findings]
>
> Design a solution considering these patterns.
```

### 3. Fresh Context When Needed

```
> Start a fresh context for the implementation.
> Here's the spec: [paste architecture]
> Don't carry over exploration details.
```

### 4. Validate Agent Output

```
> Before we proceed to implementation,
> verify the architecture makes sense:
> - Does it follow our patterns?
> - Any missing edge cases?
> - Performance concerns?
```

### 5. Document Agent Outputs

Save key outputs for reference:
```markdown
## Feature: Search

### Exploration Summary
[From explorer agent]

### Architecture
[From architect agent]

### Implementation Notes
[From implementer agent]

### Review Findings
[From reviewer agent]
```

## Anti-Patterns

### 1. Too Many Agents

```
# Bad: Over-engineered
Explorer → Analyzer → Planner → Designer → Architect →
Implementer → Tester → Reviewer → Optimizer

# Good: Right-sized
Explorer → Architect → Implementer → Reviewer
```

### 2. Insufficient Context Passing

```
# Bad: Agent works blind
> Agent B: Implement based on what Agent A found

# Good: Explicit context
> Agent B: Implement based on these findings: [paste]
```

### 3. No Verification Between Agents

```
# Bad: Assume agents are always right
Explorer → Architect → Implement

# Good: Verify at each step
Explorer → [Verify] → Architect → [Verify] → Implement
```

## Tool Support

| Tool | Multi-Agent Support |
|------|-------------------|
| **Claude Code** | Built-in subagents, plugin agents |
| **Cursor** | Manual via separate conversations |
| **Copilot** | Manual via separate chat sessions |

---

Next: [Plan Mode](plan-mode.md) | [Testing with AI](testing-with-ai.md) | [CI/CD Integration](ci-cd-integration.md)
