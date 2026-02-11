# Popular MCP Servers

A curated list of MCP servers organized by category.

## Project Management & Collaboration

### Atlassian (Jira + Confluence)

| | |
|---|---|
| **Use Case** | Read tickets, create issues, search docs |
| **Type** | Remote (SSE) |
| **Link** | [mcp.atlassian.com](https://mcp.atlassian.com) |

**Capabilities**:
- Read Jira tickets and projects
- Create and update issues
- Search Confluence pages
- Access project metadata

**Configuration**:
```json
{
  "atlassian": {
    "type": "url",
    "url": "https://mcp.atlassian.com/v1/sse"
  }
}
```

---

### Linear

| | |
|---|---|
| **Use Case** | Issue tracking, project management |
| **Type** | Local (stdio) |
| **Link** | Community MCP |

**Configuration**:
```json
{
  "linear": {
    "command": "npx",
    "args": ["-y", "mcp-server-linear"],
    "env": {
      "LINEAR_API_KEY": "${LINEAR_API_KEY}"
    }
  }
}
```

---

### Notion

| | |
|---|---|
| **Use Case** | Knowledge base access, documentation |
| **Type** | Local (stdio) |
| **Link** | Community MCP |

**Configuration**:
```json
{
  "notion": {
    "command": "npx",
    "args": ["-y", "mcp-server-notion"],
    "env": {
      "NOTION_TOKEN": "${NOTION_TOKEN}"
    }
  }
}
```

---

## Code & Version Control

### GitHub

| | |
|---|---|
| **Use Case** | Repository management, issues, PRs |
| **Type** | Local (stdio) |
| **Link** | [Official MCP](https://github.com/modelcontextprotocol/servers/tree/main/src/github) |

**Capabilities**:
- List repositories, issues, PRs
- Create and update issues
- Create pull requests
- Read file contents from repos

**Configuration**:
```json
{
  "github": {
    "command": "npx",
    "args": ["-y", "@modelcontextprotocol/server-github"],
    "env": {
      "GITHUB_TOKEN": "${GITHUB_TOKEN}"
    }
  }
}
```

---

### GitLab

| | |
|---|---|
| **Use Case** | GitLab repository management |
| **Type** | Local (stdio) |
| **Link** | Community MCP |

**Configuration**:
```json
{
  "gitlab": {
    "command": "npx",
    "args": ["-y", "mcp-server-gitlab"],
    "env": {
      "GITLAB_TOKEN": "${GITLAB_TOKEN}",
      "GITLAB_URL": "https://gitlab.com"
    }
  }
}
```

---

## Design

### Figma (Official)

| | |
|---|---|
| **Use Case** | Design-to-code, extract variables |
| **Type** | Local (stdio) |
| **Link** | [mcp.figma.com](https://mcp.figma.com) |

**Capabilities**:
- Extract design tokens (colors, typography)
- Read component structures
- Access file metadata
- Get image assets

**Configuration**:
```json
{
  "figma": {
    "command": "npx",
    "args": [
      "-y",
      "figma-developer-mcp",
      "--figma-api-key=${FIGMA_API_KEY}",
      "--stdio"
    ]
  }
}
```

---

### Framelink (Figma Alternative)

| | |
|---|---|
| **Use Case** | Simplified Figma context for coding |
| **Type** | Local (stdio) |
| **Link** | Community MCP |

**Configuration**:
```json
{
  "framelink": {
    "command": "npx",
    "args": ["-y", "framelink-figma-mcp"],
    "env": {
      "FIGMA_ACCESS_TOKEN": "${FIGMA_ACCESS_TOKEN}"
    }
  }
}
```

---

## Databases

### PostgreSQL

| | |
|---|---|
| **Use Case** | Query database, inspect schemas |
| **Type** | Local (stdio) |
| **Link** | [Official MCP](https://github.com/modelcontextprotocol/servers/tree/main/src/postgres) |

**Capabilities**:
- Execute read queries
- List tables and schemas
- Inspect table structures
- Describe relationships

**Configuration**:
```json
{
  "postgres": {
    "command": "npx",
    "args": ["-y", "@modelcontextprotocol/server-postgres"],
    "env": {
      "DATABASE_URL": "${DATABASE_URL}"
    }
  }
}
```

**Security Note**: Consider using read-only credentials.

---

### Supabase

| | |
|---|---|
| **Use Case** | Supabase database and auth |
| **Type** | Local (stdio) |
| **Link** | Community MCP |

**Configuration**:
```json
{
  "supabase": {
    "command": "npx",
    "args": ["-y", "mcp-server-supabase"],
    "env": {
      "SUPABASE_URL": "${SUPABASE_URL}",
      "SUPABASE_KEY": "${SUPABASE_SERVICE_KEY}"
    }
  }
}
```

---

### SQLite

| | |
|---|---|
| **Use Case** | Local SQLite database access |
| **Type** | Local (stdio) |
| **Link** | [Official MCP](https://github.com/modelcontextprotocol/servers/tree/main/src/sqlite) |

**Configuration**:
```json
{
  "sqlite": {
    "command": "npx",
    "args": ["-y", "@modelcontextprotocol/server-sqlite", "/path/to/database.db"]
  }
}
```

---

## Infrastructure & DevOps

### Docker

| | |
|---|---|
| **Use Case** | Container management |
| **Type** | Local (stdio) |
| **Link** | Official Docker MCP |

**Capabilities**:
- List containers and images
- Start/stop containers
- Read container logs
- Inspect configurations

**Configuration**:
```json
{
  "docker": {
    "command": "npx",
    "args": ["-y", "@modelcontextprotocol/server-docker"]
  }
}
```

---

### Kubernetes

| | |
|---|---|
| **Use Case** | Kubernetes cluster management |
| **Type** | Local (stdio) |
| **Link** | Community MCP |

**Configuration**:
```json
{
  "kubernetes": {
    "command": "npx",
    "args": ["-y", "mcp-server-kubernetes"],
    "env": {
      "KUBECONFIG": "${KUBECONFIG}"
    }
  }
}
```

---

## Utilities

### Filesystem

| | |
|---|---|
| **Use Case** | Extended file access |
| **Type** | Local (stdio) |
| **Link** | [Official MCP](https://github.com/modelcontextprotocol/servers/tree/main/src/filesystem) |

**Configuration**:
```json
{
  "filesystem": {
    "command": "npx",
    "args": [
      "-y",
      "@modelcontextprotocol/server-filesystem",
      "/allowed/path/one",
      "/allowed/path/two"
    ]
  }
}
```

---

### Memory

| | |
|---|---|
| **Use Case** | Persistent context across sessions |
| **Type** | Local (stdio) |
| **Link** | [Official MCP](https://github.com/modelcontextprotocol/servers/tree/main/src/memory) |

**Capabilities**:
- Store key-value pairs
- Create knowledge graphs
- Persist information across sessions

**Configuration**:
```json
{
  "memory": {
    "command": "npx",
    "args": ["-y", "@modelcontextprotocol/server-memory"]
  }
}
```

---

### Playwright (Browser Automation)

| | |
|---|---|
| **Use Case** | Browser automation, testing |
| **Type** | Local (stdio) |
| **Link** | Official Microsoft MCP |

**Capabilities**:
- Navigate web pages
- Take screenshots
- Fill forms
- Extract page content

**Configuration**:
```json
{
  "playwright": {
    "command": "npx",
    "args": ["-y", "@playwright/mcp-server"]
  }
}
```

---

### Desktop Commander

| | |
|---|---|
| **Use Case** | Terminal access, process management |
| **Type** | Local (stdio) |
| **Link** | Community MCP |

**Configuration**:
```json
{
  "desktop": {
    "command": "npx",
    "args": ["-y", "desktop-commander-mcp"]
  }
}
```

---

## Recommended Combinations

### Web Development

```json
{
  "mcpServers": {
    "github": { /* GitHub config */ },
    "figma": { /* Figma config */ },
    "postgres": { /* Database config */ }
  }
}
```

### Enterprise Development

```json
{
  "mcpServers": {
    "atlassian": { /* Atlassian config */ },
    "github": { /* GitHub config */ },
    "postgres": { /* Database config */ }
  }
}
```

### Full-Stack Development

```json
{
  "mcpServers": {
    "github": { /* GitHub config */ },
    "figma": { /* Figma config */ },
    "postgres": { /* Database config */ },
    "docker": { /* Docker config */ }
  }
}
```

## Finding More Servers

### Official Sources

- **MCP Servers Repo**: [github.com/modelcontextprotocol/servers](https://github.com/modelcontextprotocol/servers)
- **MCP Specification**: [modelcontextprotocol.io](https://modelcontextprotocol.io)

### Community Lists

- **awesome-mcp-servers**: [github.com/punkpeye/awesome-mcp-servers](https://github.com/punkpeye/awesome-mcp-servers)
- **PulseMCP**: [pulsemcp.com](https://www.pulsemcp.com)
- **Awesome Claude**: [awesomeclaude.ai/top-mcp-servers](https://awesomeclaude.ai/top-mcp-servers)

### Building Custom Servers

If you need a server that doesn't exist:
- [MCP Server Development Guide](https://modelcontextprotocol.io/docs/server-development)
- [MCP TypeScript SDK](https://github.com/modelcontextprotocol/typescript-sdk)

---

Next: [Setup Guide](setup-guide.md) | [What is MCP?](what-is-mcp.md)
