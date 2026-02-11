# Understanding Context

## TL;DR

AI coding assistants have a finite context window. Everything competes for space:
- Your conversation history
- Rules files (CLAUDE.md, etc.)
- File contents Claude reads
- Tool outputs

**Rule of thumb**: More focused context = better results.

## What is Context?

### The Context Window

Think of it as the AI's "working memory":

```
┌──────────────────────────────────────────────────────┐
│                  Context Window                       │
│                                                      │
│  ┌────────────────────────────────────────────────┐  │
│  │ System Instructions                             │  │
│  │ (rules, permissions, capabilities)              │  │
│  └────────────────────────────────────────────────┘  │
│                                                      │
│  ┌────────────────────────────────────────────────┐  │
│  │ CLAUDE.md / Rules Files                         │  │
│  │ (project context, conventions)                  │  │
│  └────────────────────────────────────────────────┘  │
│                                                      │
│  ┌────────────────────────────────────────────────┐  │
│  │ Conversation History                            │  │
│  │ (your prompts + AI responses)                   │  │
│  └────────────────────────────────────────────────┘  │
│                                                      │
│  ┌────────────────────────────────────────────────┐  │
│  │ File Contents                                   │  │
│  │ (code Claude has read)                          │  │
│  └────────────────────────────────────────────────┘  │
│                                                      │
│  ┌────────────────────────────────────────────────┐  │
│  │ Tool Outputs                                    │  │
│  │ (command results, search results)               │  │
│  └────────────────────────────────────────────────┘  │
│                                                      │
└──────────────────────────────────────────────────────┘
```

### Context Limits

| Tool | Approximate Context |
|------|---------------------|
| Claude Code (Opus) | ~200K tokens |
| Claude Code (Sonnet) | ~200K tokens |
| Cursor | Varies by model |
| Copilot | Varies by model |

**200K tokens ≈ 150,000 words or ~500 pages of text**

Sounds like a lot, but it fills quickly with:
- Large codebases
- Long conversations
- Verbose tool outputs

## Why Context Matters

### More Context = More Confusion

```
Early in conversation:
You: "Fix the bug in auth.ts"
AI: [Reads auth.ts, understands perfectly, fixes correctly]

After many exchanges:
You: "Now fix the similar bug in payment.ts"
AI: [Context is cluttered, may misunderstand or miss patterns]
```

### Symptoms of Context Overload

1. **AI forgets earlier instructions**
   - "Didn't I already tell you to use TypeScript?"

2. **Responses become less accurate**
   - Starts hallucinating or missing obvious things

3. **AI gets confused about which file is which**
   - Mixes up similarly named files

4. **Performance slows down**
   - Responses take longer

## What Consumes Context

### High Context Consumers

| Item | Context Cost | Notes |
|------|--------------|-------|
| Large file reads | High | A 1000-line file uses significant context |
| Error outputs | High | Stack traces and logs are verbose |
| Search results | Medium-High | Many files returned |
| Conversation history | Cumulative | Grows with each exchange |
| Rules files | Fixed | Loaded every turn |

### Low Context Consumers

| Item | Context Cost | Notes |
|------|--------------|-------|
| Short prompts | Low | Concise is better |
| Targeted file reads | Low | Read just what's needed |
| Simple tool outputs | Low | Success/failure messages |

## Measuring Context Usage

### In Claude Code

Watch for signs:
- `/compact` suggestion appears
- Responses mention "earlier in our conversation"
- AI starts summarizing previous work

### Estimating Token Usage

Rough estimate:
- 1 token ≈ 4 characters
- 1 token ≈ 0.75 words
- 1 line of code ≈ 10-20 tokens

Example:
- 100-line file ≈ 1,500 tokens
- 1,000-line file ≈ 15,000 tokens
- Long conversation (50 exchanges) ≈ 50,000+ tokens

## Context Best Practices

### 1. Start Fresh for New Tasks

```
# Bad: Continue cluttered conversation
You: [50 exchanges later] "Now let's work on something completely different"

# Good: Clear and start new
> /clear
You: "Let's work on the authentication module..."
```

### 2. Be Specific in File References

```
# Bad: Loads entire codebase
You: "Look at all the API files and find bugs"

# Good: Targeted
You: "Review src/api/auth.ts for security issues"
```

### 3. Use Compact Strategically

```
> /compact
# Summarizes conversation, reduces context, maintains key info
```

### 4. Reference Instead of Repeat

```
# Bad: Repeat instructions every time
You: "Remember to use TypeScript, follow our patterns..."

# Good: Use rules files
# Put instructions in CLAUDE.md once
```

### 5. Break Large Tasks

```
# Bad: One mega-prompt
You: "Refactor the entire authentication system, add tests,
update documentation, and create a PR"

# Good: Incremental
You: "Let's refactor auth. First, show me the current structure."
You: "Good. Now refactor the token validation."
You: "Now add tests for what we changed."
```

## Next Steps

- [Managing Context](managing-context.md) - Practical strategies
- [Rules File Sizing](rules-file-sizing.md) - Keep rules lean
- [Subagent Patterns](subagent-patterns.md) - Delegate to preserve context

---

Next: [Managing Context](managing-context.md) | [Rules File Sizing](rules-file-sizing.md)
