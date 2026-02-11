# Cursor Browser Features

## Overview

Cursor includes built-in browser features for previewing web applications during development.

## Built-in Preview

### Opening the Preview

1. Start your development server
2. Use the preview panel in Cursor
3. AI can see and reference the preview

### Features

- **Live Reload**: See changes as you code
- **Device Simulation**: Preview mobile layouts
- **Developer Tools**: Inspect elements (limited)

## Using Browser Context in Chat

### Reference Visual Elements

```
> Looking at the preview, the header is misaligned.
> Fix the CSS to center it properly.
```

### Describe UI Issues

```
> The button in the preview doesn't look clickable.
> Add hover styles to make it more interactive.
```

### Compare to Design

```
> The card component in preview doesn't match our design system.
> Update it to use our standard spacing and shadows.
```

## Composer with Visual Feedback

### Workflow

1. Describe the UI change in Composer
2. Review proposed code changes
3. Check preview for visual verification
4. Accept or iterate

### Example

```
> In Composer:
> "Add a loading spinner to the data table that shows
> while fetching data"

> Check preview to verify spinner appears correctly
> Accept or request adjustments
```

## Limitations

- Limited programmatic control
- No automated form filling
- No screenshot capture to files
- Cannot navigate to external sites

## When to Use

**Good for:**
- Quick visual verification during development
- Responsive design testing
- Simple UI debugging

**Consider Playwright MCP for:**
- Automated testing
- Complex interactions
- Screenshot documentation
- External site browsing

## Tips

### Keep Preview Visible

- Split screen with preview panel
- Reference visual issues directly
- Iterate quickly on UI changes

### Use Device Modes

- Test responsive breakpoints
- Verify mobile layouts
- Check touch-friendly designs

### Combine with @mentions

```
> @components/Header.tsx The header in preview
> overlaps on mobile. Fix the responsive styles.
```

---

Next: [Claude Code Browser](claude-code-browser.md) | [Playwright MCP](playwright-mcp.md)
