---
name: fe-responsiveness
description: Audit and fix frontend responsiveness across all device widths using Browser MCP
---

Systematically test a frontend page at every standard breakpoint — including all interactive elements — screenshot issues, and fix them.

> **Browser automation:** This command uses the **Browser MCP** tools (`browser_resize`, `browser_take_screenshot`, `browser_click`, `browser_press_key`, `browser_snapshot`, etc.). All interactions go through MCP tool calls.

## Usage

```
/fe-responsiveness /app/transactions        # Audit a specific page
/fe-responsiveness /app/reporting --fix     # Audit + auto-fix issues
```

**A route is required.** Always pass the page path as `$ARGUMENTS`.

## Prerequisites

- `browser-mcp` skill available (Playwright MCP server with `browser_navigate`, `browser_resize`, `browser_take_screenshot`, `browser_click`, `browser_press_key`, `browser_snapshot`)
- Frontend dev server running at `http://localhost:3000/`

## Breakpoints

Test at these viewport widths (Tailwind defaults):

| Name | Width | Typical Device |
|------|-------|----------------|
| **base** | 375px | iPhone SE / small phone |
| **sm** | 640px | Large phone / small tablet portrait |
| **md** | 768px | Tablet portrait (iPad Mini) |
| **lg** | 1024px | Tablet landscape / small laptop |
| **xl** | 1280px | Laptop / desktop |
| **2xl** | 1536px | Large desktop / external monitor |

Always test with a fixed height of **900px** to keep screenshots consistent.

## Step 1: Setup

Parse the route from `$ARGUMENTS`. If no route is provided, ask the user for one — do not auto-discover routes.

1. `browser_navigate` to `http://localhost:3000/`

If redirected to login:
- Pause and ask user to login/signup first (only if the user doesn't want to verify login page)

2. `browser_navigate` to `http://localhost:3000{route}`
3. `browser_wait_for` until page is fully loaded

## Step 2: Discover Interactive Elements

Before starting the viewport sweep, catalog every interactive element on the page at the default viewport (xl/1280px). Use an accessibility snapshot to identify them.

1. `browser_resize` with `width: 1280, height: 900`
2. `browser_snapshot` to get the accessibility tree

Build a checklist of interactive elements to exercise at each breakpoint:

### Elements to Discover
- **Buttons** — primary actions, secondary actions, icon buttons, toggle buttons
- **Dropdowns / Selects** — filter dropdowns, sort selectors, multi-selects
- **Modals / Dialogs** — any button that opens a modal or dialog (create, edit, delete, confirm)
- **Drawers / Sheets** — side panels, bottom sheets
- **Popovers / Tooltips** — info icons, hover cards, popover menus
- **Tabs** — tab bars, segmented controls
- **Accordions / Expandable sections** — collapsible panels
- **Forms** — input fields, textareas, date pickers, file uploads
- **Tables** — sortable columns, row actions, expandable rows, pagination controls
- **Menus** — context menus, overflow menus (three-dot/kebab), dropdown menus
- **Search / Filter bars** — search inputs, filter chips, clear buttons
- **Navigation** — sidebar links, breadcrumbs, back buttons

Record the list. You'll exercise each one during the sweep.

## Step 3: Systematic Viewport Sweep + Interactive Testing

For each breakpoint, do the following:

### 3a. Static Layout Check

Resize the viewport, wait for layout to settle, take a screenshot.

1. `browser_resize` with `width: {bp_width}, height: 900`
2. `browser_wait_for` with `time: 500` — let layout settle
3. `browser_take_screenshot`

Run each breakpoint as a **separate step** so you can analyze each screenshot before moving on.

### 3b. Interactive Element Exercise

At each breakpoint (especially **base**, **sm**, and **md** where issues are most common), exercise the interactive elements discovered in Step 2:

1. **Open every dropdown/select** — use `browser_click` on the trigger, then `browser_take_screenshot` while open to check overflow/clipping
2. **Open every modal/dialog** — use `browser_click` on the trigger, then `browser_take_screenshot` to check sizing and content
3. **Open every popover/tooltip** — use `browser_hover` on the trigger, then `browser_take_screenshot` to check positioning
4. **Expand accordions / toggle tabs** — use `browser_click`, then `browser_take_screenshot` to verify content reflows
5. **Click overflow/kebab menus** — use `browser_click`, then `browser_take_screenshot` to check menu positioning
6. **Focus form inputs** — use `browser_click` on inputs, check scroll behavior
7. **Interact with tables** — use `browser_click` for sorting, pagination; `browser_take_screenshot` each state
8. **Trigger search/filter** — use `browser_type` for search input, `browser_take_screenshot` filtered state

After each interaction, close overlays before moving on:
- Use `browser_press_key` with `key: "Escape"` to close modals, dropdowns, and popovers

**You don't need to exercise every element at every breakpoint.** Use this priority:
- **base (375px):** Exercise ALL interactive elements — this is where most issues surface
- **sm (640px):** Exercise elements that looked tight at base
- **md (768px):** Exercise modals, drawers, and tables (layout transition breakpoint)
- **lg+ (1024px+):** Only exercise elements that had issues at smaller sizes

## Step 4: Identify Issues

After each screenshot (static and interactive), check for these categories:

### Layout Issues
- [ ] **Horizontal overflow** — content spills beyond viewport, horizontal scrollbar appears
- [ ] **Overlapping elements** — text/buttons/cards overlap each other
- [ ] **Broken grid** — columns don't stack properly at smaller widths
- [ ] **Fixed-width elements** — elements with hardcoded `w-[Npx]` that don't adapt
- [ ] **Sidebar behavior** — sidebar should collapse or become a drawer on mobile

### Typography Issues
- [ ] **Text overflow** — long text breaks out of its container
- [ ] **Text too small** — body text below 14px on mobile
- [ ] **Truncation** — important content truncated without tooltip or expand option
- [ ] **Heading sizes** — headings that are oversized on mobile

### Interactive Element Issues (Static)
- [ ] **Touch targets** — buttons/links smaller than 44x44px on mobile
- [ ] **Click target spacing** — interactive elements too close together on mobile
- [ ] **Tables** — data tables with no horizontal scroll or responsive strategy

### Interactive Element Issues (Opened/Expanded)
- [ ] **Dropdown overflow** — dropdown menu extends beyond viewport edge
- [ ] **Dropdown clipping** — dropdown gets cut off by parent `overflow: hidden`
- [ ] **Modal sizing** — modal too wide for viewport, content overflows
- [ ] **Modal scroll** — long modal content has no internal scroll
- [ ] **Popover positioning** — popover appears off-screen or behind other elements
- [ ] **Drawer width** — drawer covers entire screen with no way to close on mobile
- [ ] **Menu positioning** — context/overflow menu extends beyond viewport
- [ ] **Accordion content** — expanded content overflows its container
- [ ] **Tab content** — content under non-default tabs doesn't reflow properly
- [ ] **Form layout** — form fields don't stack or resize on narrow viewports
- [ ] **Date picker** — calendar popup overflows or is unusable on mobile
- [ ] **Table actions** — row action buttons overlap or are unreachable

### Component-Specific Issues
- [ ] **Cards** — not stacking vertically on narrow viewports
- [ ] **Navigation** — nav items wrapping or overflowing
- [ ] **Forms** — form fields not full-width on mobile
- [ ] **Filters/toolbars** — filter bars that don't wrap or collapse
- [ ] **Charts/graphs** — visualizations that don't resize

### Empty Space Issues
- [ ] **Excessive padding** — large padding values that waste space on mobile
- [ ] **Wasted whitespace** — content centered in a narrow column on wide screens
- [ ] **Max-width too narrow** — content area doesn't expand on 2xl screens

## Step 5: Log Findings

Also check for console errors that surfaced during viewport changes:
- `browser_console_messages` — check for React rendering errors during resize

Record issues in a structured format, noting whether they were found in static or interactive testing:

```
Page: /app/transactions
Breakpoint: base (375px)
Issues:
  1. [Layout] Table overflows horizontally — no scroll wrapper
  2. [Interactive/Static] Filter buttons overlap — needs flex-wrap
  3. [Interactive/Opened] Status dropdown menu extends past right edge of viewport
  4. [Interactive/Opened] "Create Transaction" modal — form fields overflow on mobile
  5. [Typography] Page title truncated — needs text-sm on mobile
```

## Step 6: Fix (if requested or obvious wins)

### Fix Patterns (Tailwind)

**Responsive grid stacking:**
```tsx
// Always 3 columns (bad)
<div className="grid grid-cols-3 gap-4">

// Stack on mobile, 2 cols tablet, 3 cols desktop (good)
<div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
```

**Responsive text sizing:**
```tsx
// Fixed large heading (bad)
<h1 className="text-3xl">

// Scales down on mobile (good)
<h1 className="text-xl md:text-2xl lg:text-3xl">
```

**Responsive padding/spacing:**
```tsx
// Fixed large padding (bad)
<div className="p-8">

// Less padding on mobile (good)
<div className="p-4 md:p-6 lg:p-8">
```

**Table horizontal scroll:**
```tsx
// Table overflows container (bad)
<table className="w-full">

// Scrollable wrapper (good)
<div className="overflow-x-auto">
  <table className="w-full min-w-[600px]">
```

**Flex wrapping:**
```tsx
// Items overflow on narrow screens (bad)
<div className="flex gap-2">

// Wrap on narrow screens (good)
<div className="flex flex-wrap gap-2">
```

**Hide/show elements by breakpoint:**
```tsx
// Full label on desktop, icon-only on mobile
<Button>
  <PlusIcon />
  <span className="hidden sm:inline">Add Item</span>
</Button>
```

**Responsive dialog/modal sizing:**
```tsx
// Full-screen on mobile, constrained on desktop
<DialogContent className="w-full max-w-lg sm:max-w-xl">
```

**Responsive popover/dropdown positioning:**
```tsx
// Use portal + collision-aware positioning
<DropdownMenuContent align="end" sideOffset={4}>
  {/* Radix handles viewport collision automatically */}
</DropdownMenuContent>

// For custom popovers, constrain width on mobile
<PopoverContent className="w-[calc(100vw-2rem)] sm:w-80">
```

**Sidebar collapse pattern:**
```tsx
// Sidebar hidden on mobile, visible on desktop
<aside className="hidden lg:block w-64">
  {/* sidebar content */}
</aside>

// Mobile menu trigger
<Button className="lg:hidden" aria-label="Open menu">
  <MenuIcon />
</Button>
```

**Responsive form layout:**
```tsx
// Side-by-side fields on all screens (bad)
<div className="flex gap-4">
  <Input /> <Input />
</div>

// Stack on mobile, side-by-side on tablet+ (good)
<div className="flex flex-col sm:flex-row gap-4">
  <Input className="w-full" /> <Input className="w-full" />
</div>
```

### Fix Rules

- Use Tailwind responsive prefixes (`sm:`, `md:`, `lg:`, `xl:`, `2xl:`) — never CSS media queries
- Mobile-first: base styles are for the smallest width, add prefixes for larger screens
- Prefer `flex-wrap`, `grid` auto-fit, `overflow-x-auto` over hiding content
- Only hide non-essential content (decorative labels, secondary actions) — never hide primary data
- Test that fixes at one breakpoint don't break other breakpoints

## Step 7: Verify Fixes

After applying fixes, re-run the viewport sweep for the fixed page:

1. **Wait for HMR** — `browser_wait_for` with `time: 1000` for Vite to hot-reload
2. **Re-screenshot** each breakpoint where issues were found:
   - `browser_resize` with the problem breakpoint width
   - `browser_take_screenshot`
3. **Re-exercise** interactive elements that had issues:
   - `browser_click` the trigger element
   - `browser_take_screenshot` to verify the fix
   - `browser_press_key` with `key: "Escape"` to close
4. **Compare** before/after — confirm issues are resolved without regressions
5. **Spot-check** adjacent breakpoints to ensure no new problems were introduced

## Step 8: Report

```
Responsiveness audit: /app/<page>

Results per breakpoint:
  base (375px):  Pass | N issues [fixed/remaining]
  sm (640px):  Pass | N issues [fixed/remaining]
  md (768px):  Pass | N issues [fixed/remaining]
  lg (1024px): Pass | N issues [fixed/remaining]
  xl (1280px): Pass | N issues [fixed/remaining]
  2xl (1536px):Pass | N issues [fixed/remaining]

Interactive elements tested:
  - [Element] Status at each breakpoint
  - ...

Files modified:
  - frontend/src/pages/<Page>/Component.tsx (N fixes)
  - ...

Fixes applied:
  - [Category] Description of fix
  - ...

Remaining issues (manual review):
  - [Issue] Why it needs manual attention
  - ...
```

## Key Principles

1. **Mobile-first mindset.** If it works at 375px, wider screens are usually fine with minor tweaks.
2. **Screenshot every breakpoint.** Don't assume — visual verification catches issues code review misses.
3. **Exercise interactive elements.** Dropdowns, modals, and menus often break at narrow widths even when the static layout looks fine.
4. **Fix at the source.** Use Tailwind responsive utilities, don't add CSS media queries or JS resize listeners.
5. **Don't over-hide.** Prefer reflowing content (wrapping, stacking, scrolling) over hiding it.
6. **Verify after fixing.** A fix at one breakpoint can break another — always re-sweep.

## Reference Files

- Tailwind config: `<project>/tailwind.config.ts`
- Route definitions: `<project>/src/Routes.tsx`
- shadcn components (DO NOT EDIT): `<project>/src/components/ui/`
- Page components: `<project>/src/pages/`