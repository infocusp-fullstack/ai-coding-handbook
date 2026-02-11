# Glossary

## AI Coding Terms

### Agent
An AI system that can take actions autonomously. In AI coding tools, agents can explore codebases, make decisions, and execute multi-step tasks without constant human input.

### Autocomplete
Real-time code suggestions as you type. The most basic form of AI coding assistance, pioneered by GitHub Copilot.

### Chat Interface
Conversational UI for interacting with AI. Used for asking questions, requesting explanations, and complex code generation tasks.

### Context Window
The maximum amount of text an AI model can process at once. Measured in tokens. Larger context windows allow the AI to understand more of your codebase simultaneously.

### Embedding
A numerical representation of text that captures semantic meaning. Used for semantic code search and similarity matching.

### Fine-tuning
Training a base AI model on specific data to improve performance for particular tasks. Some tools offer fine-tuning on your codebase.

### Hallucination
When an AI generates plausible-sounding but incorrect information. Common examples include inventing non-existent APIs or functions.

### Inline Suggestions
Code completions that appear directly in your editor as you type, which you can accept with Tab or dismiss.

### LLM (Large Language Model)
The underlying AI technology powering coding assistants. Examples: GPT-4, Claude, Gemini.

### MCP (Model Context Protocol)
Anthropic's open protocol for connecting AI assistants to external data sources and tools. Enables Claude Code to interact with GitHub, databases, and other services.

### Plan Mode
A workflow where AI designs an implementation approach before writing code. Separates planning from execution for better results.

### Prompt
The input text given to an AI model. In coding contexts, this includes your question plus any context about your code.

### RAG (Retrieval-Augmented Generation)
A technique that retrieves relevant information (like code snippets) before generating a response. Improves accuracy by grounding AI in actual codebase content.

### Skill
In Claude Code, a domain-specific knowledge file that automatically activates when working on relevant code. Provides contextual expertise.

### Subagent
A specialized AI agent spawned for a specific task. Used to isolate concerns and maintain fresh context for different phases of work.

### Token
The basic unit of text processing for AI models. Roughly 4 characters or 0.75 words in English. Code often uses more tokens than natural language.

## Tool-Specific Terms

### AGENTS.md
A universal configuration file for AI coding agents. Placed in repository root, provides context to any AI tool that reads it.

### CLAUDE.md
Claude Code's project-specific memory file. Contains instructions, patterns, and context that persist across sessions.

### Composer (Cursor)
Cursor's multi-file editing interface. Allows AI to propose changes across multiple files simultaneously.

### Copilot Chat
GitHub Copilot's conversational interface. Distinct from inline autocomplete suggestions.

### Custom Command
User-defined slash commands in AI tools. Created by writing markdown files that define prompts and workflows.

### Ghost Text
Semi-transparent code suggestions shown inline before acceptance. The signature UX of AI autocomplete.

### Hook
In Claude Code, an automated action triggered by specific events. Can run shell commands before/after AI operations.

### Notepads (Cursor)
Scratch space for storing context during a coding session. Persists within session but not committed to repo.

### Plugin
An extension package for AI tools. Can include skills, agents, commands, and MCP servers.

### Rules File
Configuration files that define how AI should behave in your project. Different tools use different formats (.cursorrules, CLAUDE.md, etc.).

## Development Workflow Terms

### AAA Pattern
Arrange, Act, Assert - the standard structure for unit tests. AI tools commonly generate tests in this format.

### CI/CD Integration
Using AI tools in continuous integration pipelines. Common for automated code review and documentation generation.

### Context Pollution
When unrelated information accumulates in an AI's context window, degrading response quality. Solved by clearing context or using subagents.

### Deterministic Code
Code that produces the same output for the same input every time. Traditional programming is deterministic.

### Non-Deterministic Computing
Systems where outputs may vary for the same input. AI-assisted coding introduces non-determinism that must be managed through review.

### Red-Green-Refactor
The TDD cycle: write a failing test (red), make it pass (green), then improve the code (refactor). AI tools can assist each phase.

### Research-Plan-Implement
A recommended workflow for AI-assisted development: understand the codebase, design the approach, then execute in small steps.

### Rubber Ducking
Explaining a problem to clarify your thinking. AI assistants serve as effective rubber ducks that can also respond.

## Security Terms

### Content Exclusion
Configuring files or patterns that AI tools should ignore. Used to prevent exposure of secrets or sensitive code.

### Prompt Injection
An attack where malicious input causes an AI to ignore instructions or behave unexpectedly. A security concern for AI-generated code.

### Secret Detection
Automated scanning for accidentally committed credentials. AI tools should be configured to exclude secret files.

## Metrics & Quality

### Code Coverage
The percentage of code executed during testing. AI can help identify uncovered paths and generate tests to improve coverage.

### Confidence Score
Some AI tools report confidence in their suggestions. Lower confidence indicates the AI is less certain about correctness.

### False Positive
When an AI reports a problem that isn't actually an issue. Common in AI code review, addressed through confidence thresholds.

### Token Usage
The amount of context consumed by a request. Important for understanding costs and context window limits.

## Community Terms

### AI-Native Development
Building software from the start with AI assistance, rather than retrofitting AI into existing workflows.

### Human-in-the-Loop
Development approach where AI assists but humans make final decisions. Contrasted with fully autonomous AI agents.

### Vibe Coding
Using AI to quickly prototype by describing what you want in natural language. Emphasis on speed over precision.

---

Next: [Official Links](official-links.md) | [Community](community.md)
