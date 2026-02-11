# Claude Code Browser Integration

## Overview

Claude Code can interact with browsers through:
1. Chrome extension for interactive browsing
2. Playwright MCP for automated testing
3. Web fetch for reading page content

## Chrome Extension

### What It Does

The Claude Code Chrome extension allows Claude to:
- See web page content
- Navigate between pages
- Interact with elements (with user permission)

### Installation

1. Install Chrome extension from Claude Code settings
2. Grant necessary permissions
3. Enable browser tools in Claude Code

### Usage

```
> Look at the error page at http://localhost:3000/dashboard
> and help me debug why it's showing a 404
```

Claude can see the page content and provide debugging assistance.

### Limitations

- Requires user interaction for some actions
- Cannot run headlessly
- Limited to one browser window

## Using Playwright MCP

For automated browser tasks, use the Playwright MCP server.

### Configuration

Add to your MCP settings:

```json
{
  "mcpServers": {
    "playwright": {
      "command": "npx",
      "args": ["-y", "@playwright/mcp-server"]
    }
  }
}
```

### Capabilities

- **Navigate**: Open URLs
- **Interact**: Click, type, select
- **Capture**: Screenshots, content
- **Automate**: Run sequences of actions

### Example Usage

```
> Using the browser, navigate to our app at localhost:3000
> Log in with the test account
> Go to the settings page
> Take a screenshot of the current state
```

## Web Fetch for Content

For simply reading web pages:

```
> Fetch the API documentation at https://api.example.com/docs
> and summarize the authentication requirements
```

This uses Claude Code's built-in web fetch capability.

## Common Workflows

### Debug UI Issues

```
> Open localhost:3000/broken-page in the browser
> Inspect the console for errors
> Help me fix the issues you find
```

### Generate E2E Tests

```
> Navigate through the checkout flow:
> 1. Add item to cart
> 2. Go to checkout
> 3. Fill payment form
> 4. Submit order
>
> Generate Playwright tests for this flow
```

### Visual Documentation

```
> Take screenshots of each step in the onboarding flow
> and save them to docs/screenshots/
```

### Accessibility Testing

```
> Open the login page
> Check for accessibility issues:
> - Missing alt text
> - Insufficient color contrast
> - Missing form labels
> Report findings
```

## Best Practices

### Use Test Environments

- Don't browse production with real user data
- Set up test accounts for AI access
- Use staging environments

### Handle Errors Gracefully

```
> If the page fails to load, try refreshing once.
> If it still fails, report the error and move on.
```

### Clean Up After Sessions

```
> After testing, clear any test data created
> and log out of the test account
```

## Comparison: Chrome Extension vs Playwright MCP

| Feature | Chrome Extension | Playwright MCP |
|---------|-----------------|----------------|
| Interactive use | Yes | Limited |
| Headless operation | No | Yes |
| CI/CD compatible | No | Yes |
| Real browser rendering | Yes | Yes |
| User action required | Sometimes | No |
| Multiple pages | Manual | Automated |

**Choose Chrome Extension when:**
- You need to see what's happening
- Debugging visual issues
- One-off explorations

**Choose Playwright MCP when:**
- Running automated tests
- CI/CD pipelines
- Generating test scripts
- Taking batch screenshots

---

Next: [Playwright MCP](playwright-mcp.md) | [Overview](overview.md)
