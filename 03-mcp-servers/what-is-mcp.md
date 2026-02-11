# What is MCP (Model Context Protocol)?

## TL;DR

MCP (Model Context Protocol) lets AI coding assistants connect to external tools and services. Instead of copying data into your prompt, the AI can directly read from Jira, query databases, access Figma designs, and more.

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  AI Agent   │────▶│ MCP Server  │────▶│  External   │
│ (Claude,    │     │             │     │  Service    │
│  Cursor)    │◀────│ (Translator)│◀────│ (Jira, DB,  │
│             │     │             │     │  Figma...)  │
└─────────────┘     └─────────────┘     └─────────────┘
```

## Why MCP Matters

### Before MCP
```
You: "Implement JIRA-1234"
AI: "I don't have access to Jira. Please paste the ticket details."
You: *copies entire ticket content*
AI: *finally understands context*
```

### With MCP
```
You: "Implement JIRA-1234"
AI: *reads ticket directly from Jira*
AI: "I see this is a bug fix for user login. Let me implement it..."
```

## Core Concepts

### MCP Server
A program that translates between AI assistants and external services.

Examples:
- Atlassian MCP → Reads Jira tickets, Confluence pages
- GitHub MCP → Manages issues, PRs, repositories
- Figma MCP → Extracts design variables, components
- PostgreSQL MCP → Queries databases

### MCP Client
The AI tool that connects to MCP servers.

Clients include:
- Claude Code (native support)
- Cursor (native support)
- VS Code with extensions

### Transport Types

**stdio** - Local process communication
```json
{
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/server-github"]
}
```

**SSE (Server-Sent Events)** - HTTP-based, for remote servers
```json
{
  "type": "url",
  "url": "https://mcp.example.com/sse"
}
```

## What MCP Servers Can Do

### Resources
Read-only access to external data:
- Jira tickets and projects
- Confluence documentation
- Figma designs and assets
- Database schemas and data
- File system contents

### Tools
Actions the AI can perform:
- Create Jira issues
- Commit to GitHub
- Run database queries
- Generate files
- Execute commands

### Prompts
Pre-defined workflows the AI can trigger:
- "Create PR from Jira ticket"
- "Generate tests for endpoint"
- "Sync design tokens from Figma"

## Common Use Cases

### 1. Ticket-to-Code Workflow
```
Read Jira ticket → Plan implementation → Write code → Create PR
```

With MCP:
- Atlassian MCP reads ticket details
- AI plans implementation
- AI writes code
- GitHub MCP creates PR with ticket reference

### 2. Design-to-Code
```
Read Figma design → Extract tokens → Generate components
```

With MCP:
- Figma MCP reads design file
- Extracts colors, typography, spacing
- AI generates matching components

### 3. Database-Aware Development
```
Query schema → Understand relationships → Write safe queries
```

With MCP:
- PostgreSQL MCP reads schema
- AI understands table relationships
- Generates correct queries with proper types

### 4. Documentation-Driven Coding
```
Read Confluence docs → Follow patterns → Implement feature
```

With MCP:
- Atlassian MCP reads architecture docs
- AI follows documented patterns
- Generates consistent code

## Tool Support

| Tool | MCP Support | Configuration |
|------|-------------|---------------|
| **Claude Code** | Native | `~/.claude/settings.json` or `.mcp.json` |
| **Cursor** | Native | `.cursor/mcp.json` or Settings |
| **VS Code** | Via extensions | Extension settings |
| **Copilot** | Limited | Experimental |

## Security Considerations

### Authentication
MCP servers often need credentials:
- API tokens (Jira, GitHub, Figma)
- Database passwords
- OAuth tokens

**Never commit credentials**. Use environment variables:
```json
{
  "env": {
    "GITHUB_TOKEN": "${GITHUB_TOKEN}"
  }
}
```

### Permissions
MCP servers have different permission levels:
- **Read-only**: Safe for exploration
- **Write**: Can modify external data
- **Admin**: Full access (dangerous)

Start with minimal permissions.

### Data Exposure
AI sees data from MCP servers. Consider:
- Sensitive data in Jira tickets
- PII in databases
- Proprietary designs in Figma

Use MCP servers only for appropriate data.

## Getting Started

### 1. Choose Servers for Your Workflow

Common combinations:
- **Web development**: GitHub + Figma + Database
- **Enterprise**: Atlassian + GitHub + Database
- **Full-stack**: All of the above

### 2. Install and Configure

See [Setup Guide](setup-guide.md) for detailed instructions.

### 3. Test the Connection

```
# In Claude Code
> What Jira tickets are assigned to me?

# AI uses Atlassian MCP to query and respond
```

## Next Steps

- [Setup Guide](setup-guide.md) - Configure MCP servers
- [Popular Servers](popular-servers.md) - Curated server list
- [Examples](examples/) - Configuration examples

## Resources

- **MCP Specification**: [modelcontextprotocol.io](https://modelcontextprotocol.io)
- **Official Servers**: [github.com/modelcontextprotocol/servers](https://github.com/modelcontextprotocol/servers)
- **Community Servers**: [github.com/punkpeye/awesome-mcp-servers](https://github.com/punkpeye/awesome-mcp-servers)

---

Next: [Setup Guide](setup-guide.md) | [Popular Servers](popular-servers.md)
