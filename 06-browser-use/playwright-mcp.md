# Playwright MCP Server

## Overview

Playwright MCP provides programmatic browser control for AI coding assistants. It's ideal for automated testing, screenshots, and browser-based workflows.

## Installation

### Prerequisites

- Node.js 18+
- Browsers installed (Playwright installs them automatically)

### Add to Configuration

**Claude Code** (`~/.claude/settings.json` or `.mcp.json`):

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

**Cursor** (`.cursor/mcp.json`):

```json
{
  "servers": {
    "playwright": {
      "command": "npx",
      "args": ["-y", "@playwright/mcp-server"]
    }
  }
}
```

### Verify Installation

```
> List available browser tools
```

AI should show available Playwright actions.

## Capabilities

### Navigation

```
> Navigate to https://example.com
> Click the "Sign In" link
> Go back to the previous page
> Refresh the current page
```

### Interaction

```
> Fill the email field with "test@example.com"
> Click the submit button
> Select "Option 2" from the dropdown
> Check the "Remember me" checkbox
```

### Content Extraction

```
> Get the text content of the main heading
> Extract all links from the navigation
> Read the error message if present
```

### Screenshots

```
> Take a screenshot of the current page
> Capture just the login form element
> Take a full-page screenshot
```

### Waiting

```
> Wait for the loading spinner to disappear
> Wait until the results table is visible
> Wait for the network to be idle
```

## Common Workflows

### Automated UI Testing

```
> Test the login flow:
> 1. Navigate to /login
> 2. Enter email "test@example.com"
> 3. Enter password "testpass123"
> 4. Click "Sign In"
> 5. Verify the dashboard heading is visible
> 6. Report success or failure
```

### Screenshot Documentation

```
> Document the user settings pages:
> 1. Navigate to /settings
> 2. Take screenshot as "settings-overview.png"
> 3. Click "Profile" tab
> 4. Take screenshot as "settings-profile.png"
> 5. Click "Security" tab
> 6. Take screenshot as "settings-security.png"
```

### Form Validation Testing

```
> Test form validation on /register:
>
> Test 1: Empty submission
> - Click submit without filling fields
> - Capture error messages shown
>
> Test 2: Invalid email
> - Fill email with "notanemail"
> - Click submit
> - Capture error message
>
> Test 3: Valid submission
> - Fill all fields correctly
> - Click submit
> - Verify success message
>
> Report all results in a table.
```

### E2E Test Generation

```
> I'll perform actions on the checkout flow.
> Watch what I do and generate Playwright test code:
>
> 1. Go to /products
> 2. Click first product
> 3. Click "Add to Cart"
> 4. Click cart icon
> 5. Click "Checkout"
> 6. Fill shipping form
> 7. Click "Place Order"
>
> Generate the test file with proper assertions.
```

### Accessibility Auditing

```
> Check accessibility on the homepage:
> 1. Navigate to /
> 2. Check all images have alt text
> 3. Verify form inputs have labels
> 4. Check heading hierarchy (h1 -> h2 -> h3)
> 5. Verify links have descriptive text
> 6. Report all issues found
```

## Advanced Usage

### Multiple Browsers

```
> Run the same test in Chrome and Firefox:
>
> For each browser:
> 1. Navigate to /responsive-test
> 2. Take screenshot at 1920x1080
> 3. Take screenshot at 375x667 (mobile)
> 4. Compare results between browsers
```

### Network Interception

```
> Test error handling:
> 1. Navigate to /dashboard
> 2. Intercept the /api/data request
> 3. Return a 500 error
> 4. Verify the error message is shown
> 5. Take screenshot of error state
```

### Authentication Flow

```
> Set up authenticated session:
> 1. Navigate to /login
> 2. Fill credentials from environment
> 3. Submit and wait for redirect
> 4. Store session cookies
> 5. Use this session for subsequent requests
```

## Configuration Options

### Headless Mode

By default, Playwright runs headless. For debugging:

```json
{
  "mcpServers": {
    "playwright": {
      "command": "npx",
      "args": ["-y", "@playwright/mcp-server", "--headed"]
    }
  }
}
```

### Browser Selection

```json
{
  "mcpServers": {
    "playwright": {
      "command": "npx",
      "args": ["-y", "@playwright/mcp-server", "--browser=firefox"]
    }
  }
}
```

Options: `chromium`, `firefox`, `webkit`

## Best Practices

### Use Reliable Selectors

```
> Click the element with data-testid="submit-button"
```

Better than:
```
> Click the blue button at the bottom
```

### Add Waits for Stability

```
> Click submit and wait for the success message to appear
> before taking a screenshot
```

### Handle Flaky Elements

```
> Try to click the dropdown menu.
> If it's not visible after 5 seconds, report that it's missing.
```

### Clean Test State

```
> After the test, delete any test data created
> and ensure we're logged out.
```

## Troubleshooting

### "Browser not found"

Install Playwright browsers:
```bash
npx playwright install
```

### "Element not found"

- Check selector is correct
- Add waits for dynamic content
- Verify element exists in the page

### "Timeout errors"

- Increase timeout for slow operations
- Add explicit waits
- Check for network issues

### "Screenshots are blank"

- Wait for page to fully load
- Check for loading spinners
- Verify content is visible

## Resources

- **Playwright Docs**: [playwright.dev](https://playwright.dev)
- **MCP Server**: [@playwright/mcp-server](https://www.npmjs.com/package/@playwright/mcp-server)
- **Selectors Guide**: [playwright.dev/docs/selectors](https://playwright.dev/docs/selectors)

---

Next: [Overview](overview.md) | [Claude Code Browser](claude-code-browser.md)
