# MCP Server Setup Guide

## TL;DR

1. Choose your MCP servers
2. Add configuration to your tool's settings file
3. Provide required credentials via environment variables
4. Test the connection

## Configuration Locations

### Claude Code

**User-level** (all projects): `~/.claude/settings.json`

**Project-level**: `.mcp.json` in project root

```json
{
  "mcpServers": {
    "server-name": {
      "command": "npx",
      "args": ["-y", "package-name"],
      "env": { "API_KEY": "..." }
    }
  }
}
```

### Cursor

**User-level**: Settings > Features > MCP Servers

**Project-level**: `.cursor/mcp.json`

```json
{
  "servers": {
    "server-name": {
      "command": "npx",
      "args": ["-y", "package-name"],
      "env": { "API_KEY": "..." }
    }
  }
}
```

### VS Code

Via extension settings or `settings.json`:

```json
{
  "mcp.servers": {
    "server-name": {
      "command": "npx",
      "args": ["-y", "package-name"]
    }
  }
}
```

## Server Types

### Local Process (stdio)

Most common type. Runs as a local process.

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "ghp_xxxxxxxxxxxx"
      }
    }
  }
}
```

### Remote Server (SSE)

HTTP-based, for cloud-hosted servers.

```json
{
  "mcpServers": {
    "atlassian": {
      "type": "url",
      "url": "https://mcp.atlassian.com/v1/sse"
    }
  }
}
```

### Docker Container

For isolated execution:

```json
{
  "mcpServers": {
    "postgres": {
      "command": "docker",
      "args": ["run", "-i", "--rm", "mcp/postgres"],
      "env": {
        "DATABASE_URL": "postgresql://..."
      }
    }
  }
}
```

## Setting Up Common Servers

### GitHub MCP

**Purpose**: Repository management, issues, PRs

**Setup**:
1. Create a GitHub Personal Access Token (PAT)
   - Settings > Developer settings > Personal access tokens
   - Select scopes: `repo`, `read:org`

2. Configure:
```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "ghp_your_token_here"
      }
    }
  }
}
```

3. Test:
```
> List my open PRs
> What issues are assigned to me?
```

### Atlassian (Jira + Confluence)

**Purpose**: Read tickets, search docs, create issues

**Setup**:
1. No local install needed - uses hosted service

2. Configure:
```json
{
  "mcpServers": {
    "atlassian": {
      "type": "url",
      "url": "https://mcp.atlassian.com/v1/sse"
    }
  }
}
```

3. Authenticate when prompted

4. Test:
```
> Show me ticket PROJ-1234
> Search Confluence for "authentication flow"
```

### Figma

**Purpose**: Design-to-code, extract variables

**Setup**:
1. Get Figma API key
   - Figma > Settings > Personal access tokens

2. Configure:
```json
{
  "mcpServers": {
    "figma": {
      "command": "npx",
      "args": [
        "-y",
        "figma-developer-mcp",
        "--figma-api-key=YOUR_API_KEY",
        "--stdio"
      ]
    }
  }
}
```

3. Test:
```
> Extract design tokens from [Figma file URL]
> What colors are used in this design?
```

### PostgreSQL

**Purpose**: Query databases, inspect schemas

**Setup**:
1. Ensure database is accessible

2. Configure:
```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "DATABASE_URL": "postgresql://user:pass@localhost:5432/dbname"
      }
    }
  }
}
```

3. Test:
```
> Show me the database schema
> What tables have user data?
```

### Filesystem

**Purpose**: Extended file access beyond workspace

**Setup**:
```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "/path/to/allowed/directory"
      ]
    }
  }
}
```

### Memory (Persistent Context)

**Purpose**: Save and retrieve information across sessions

**Setup**:
```json
{
  "mcpServers": {
    "memory": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-memory"]
    }
  }
}
```

## Environment Variables

### Using Environment Variables

Never hardcode secrets. Use environment variables:

**In config file**:
```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN}"
      }
    }
  }
}
```

**Set the variable**:
```bash
# In shell profile (.bashrc, .zshrc)
export GITHUB_TOKEN="ghp_xxxxxxxxxxxx"

# Or in .env file (ensure it's gitignored)
GITHUB_TOKEN=ghp_xxxxxxxxxxxx
```

### Multiple Environments

For different environments (dev, staging, prod):

```bash
# .env.local (gitignored)
DATABASE_URL=postgresql://localhost/dev_db

# CI/CD environment
DATABASE_URL=postgresql://prod-server/prod_db
```

## Troubleshooting

### "Server not connecting"

1. Check server is installed:
```bash
npx -y @modelcontextprotocol/server-github --version
```

2. Verify configuration syntax (valid JSON)

3. Check environment variables are set:
```bash
echo $GITHUB_TOKEN
```

4. Test server directly:
```bash
npx -y @modelcontextprotocol/server-github
# Should start without errors
```

### "Permission denied"

1. Check API token has required scopes
2. Verify token hasn't expired
3. Ensure network access to service

### "Server crashes"

1. Check logs for error messages
2. Update to latest server version:
```bash
npx -y @modelcontextprotocol/server-github@latest
```
3. Check system requirements (Node.js version, etc.)

### "Data not accessible"

1. Verify you have permission to access the resource
2. Check resource exists (correct ticket ID, file path, etc.)
3. Test API access directly (curl, browser)

## Security Best Practices

### 1. Minimal Permissions

Request only needed scopes:
```
# GitHub - if only reading
repo:read

# GitHub - if creating PRs
repo
```

### 2. Separate Tokens

Use different tokens for:
- Development (broader access)
- Production (minimal access)
- CI/CD (specific permissions)

### 3. Rotate Regularly

Set reminders to rotate tokens:
- Every 90 days for sensitive access
- Immediately if compromised

### 4. Audit Access

Review what MCP servers can access:
- What data can they read?
- What actions can they perform?
- Is this appropriate for AI access?

## Full Configuration Example

Claude Code `~/.claude/settings.json`:

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN}"
      }
    },
    "atlassian": {
      "type": "url",
      "url": "https://mcp.atlassian.com/v1/sse"
    },
    "figma": {
      "command": "npx",
      "args": [
        "-y",
        "figma-developer-mcp",
        "--figma-api-key=${FIGMA_API_KEY}",
        "--stdio"
      ]
    },
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "DATABASE_URL": "${DATABASE_URL}"
      }
    }
  },
  "permissions": {
    "allow": [
      "mcp:github:*",
      "mcp:atlassian:read",
      "mcp:figma:read",
      "mcp:postgres:query"
    ]
  }
}
```

---

Next: [Popular Servers](popular-servers.md) | [What is MCP?](what-is-mcp.md)
