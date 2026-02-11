# Browser Use with AI Coding Tools

## TL;DR

AI coding tools can interact with web browsers for testing, design extraction, and automation:

| Tool | Browser Capability |
|------|-------------------|
| **Cursor** | Built-in browser preview |
| **Claude Code** | Chrome extension, MCP servers |
| **General** | Playwright MCP for automation |

## Use Cases

### 1. UI Testing and Validation

AI can navigate your app and verify UI behavior:
```
> Open the login page, fill in test credentials, and verify the dashboard loads correctly
```

### 2. Visual Regression

Compare screenshots before and after changes:
```
> Take a screenshot of the homepage before and after my CSS changes
```

### 3. Design-to-Code Validation

Verify implementation matches design:
```
> Compare this component to the Figma design and note any differences
```

### 4. Web Scraping for Context

Extract information from documentation or reference sites:
```
> Read the API documentation at [URL] and help me implement the integration
```

### 5. E2E Test Generation

Create end-to-end tests from user flows:
```
> Record my actions as I complete the checkout flow and generate Playwright tests
```

## Browser Integration Options

### 1. Playwright MCP Server

**Best for**: Headless automation, testing, scraping

The Playwright MCP server provides programmatic browser control:
- Navigate to URLs
- Fill forms
- Click elements
- Take screenshots
- Extract content

### 2. Built-in Browser Features

**Best for**: Quick previews during development

Some tools have built-in browser capabilities for live preview and basic interaction.

### 3. Chrome Extension

**Best for**: Interactive sessions, user-like browsing

Browser extensions allow AI to see and interact with web pages as a user would.

## Capabilities Overview

| Capability | Playwright MCP | Built-in | Extension |
|------------|---------------|----------|-----------|
| Page navigation | Yes | Varies | Yes |
| Screenshots | Yes | Limited | Yes |
| Form filling | Yes | No | Yes |
| Element interaction | Yes | No | Yes |
| JavaScript execution | Yes | No | Limited |
| Network inspection | Yes | No | Limited |
| Headless operation | Yes | N/A | No |
| Visual rendering | Limited | Yes | Yes |

## Getting Started

### Choose Your Approach

**For Automated Testing**:
→ Use Playwright MCP Server ([Setup Guide](playwright-mcp.md))

**For Cursor Users**:
→ Use built-in browser features ([Cursor Browser Guide](cursor-browser.md))

**For Claude Code Users**:
→ Use Chrome extension or Playwright MCP ([Claude Code Browser Guide](claude-code-browser.md))

### Quick Example

Using Playwright MCP with Claude Code:

1. Install Playwright MCP (see setup guide)

2. Ask AI to browse:
```
> Navigate to our staging site at https://staging.example.com
> Click the "Sign Up" button
> Fill the form with test data
> Submit and verify the success message appears
```

3. AI executes browser actions and reports results

## Security Considerations

### Authentication

- Don't use production credentials with AI browser access
- Create test accounts specifically for AI testing
- Use environment variables for sensitive URLs

### Data Access

- AI can see everything on visited pages
- Avoid pages with sensitive customer data
- Consider using staging/test environments

### Rate Limiting

- Automated browsing can trigger rate limits
- Add delays between actions if needed
- Check target site's terms of service

## Common Patterns

### Screenshot Documentation

```
> Navigate through the user onboarding flow and take screenshots
> at each step. Save them to docs/screenshots/onboarding/
```

### Form Testing

```
> Test the registration form with various inputs:
> - Valid data (should succeed)
> - Invalid email (should show error)
> - Weak password (should show requirements)
> Report results in a table.
```

### Content Extraction

```
> Read the changelog at [URL] and summarize what's new
> in the latest version that affects our integration.
```

### Visual Comparison

```
> Compare our production site to staging and note any
> visual differences on the homepage.
```

---

Next: [Cursor Browser](cursor-browser.md) | [Claude Code Browser](claude-code-browser.md) | [Playwright MCP](playwright-mcp.md)
