---
description: Initialize CLAUDE.md for the current project
---

# /init Command

## What It Does

The `/init` command analyzes your project and generates an initial `CLAUDE.md` file with:

- Detected tech stack and frameworks
- Project structure overview
- Common commands (from package.json, Makefile, etc.)
- Key conventions found in the codebase

## Usage

```bash
claude
> /init
```

## How It Works

1. **Scans project files** to identify:
   - Language/framework (TypeScript, Python, Go, etc.)
   - Build tools (npm, yarn, pnpm, pip, go modules)
   - Testing frameworks
   - Configuration files
   - Project structure

2. **Generates CLAUDE.md** with sections for:
   - Project overview
   - Tech stack
   - Common commands
   - Directory structure
   - Development guidelines

3. **You review and customize** the generated file

## Example Output

The `/init` command generates a CLAUDE.md file like this:

**Project Overview**: Web application built with Next.js 14 and TypeScript.

**Tech Stack**:
- Framework: Next.js 14 (App Router)
- Language: TypeScript
- Styling: Tailwind CSS
- Database: PostgreSQL with Prisma
- Testing: Jest + React Testing Library

**Common Commands**:
- `npm run dev` - Start development server
- `npm run build` - Production build
- `npm run lint` - Run ESLint
- `npm run typecheck` - TypeScript type checking
- `npm test` - Run all tests
- `npx prisma migrate dev` - Run migrations

**Project Structure**:
- src/app/ - Next.js app router
- src/components/ - React components
- src/lib/ - Utilities
- src/types/ - TypeScript types
- prisma/ - Database schema
- tests/ - Test files

**Conventions**:
- Use functional components
- Follow existing patterns in codebase
- Run lint before committing

## Best Practices

### 1. Run /init Early

Create CLAUDE.md at project start or when joining a new project:

```bash
> /init
```

### 2. Iterate Over Time

CLAUDE.md should evolve as you learn about the project:

```markdown
# Iteration workflow:
1. Claude makes mistake
2. You correct it
3. If it's recurring, add rule to CLAUDE.md
4. Test the rule with next task
5. Refine if needed
```

### 3. Add What Claude Gets Wrong

When Claude generates incorrect output until you add specific guidance:

**Example:**
- Claude keeps generating API responses in wrong format
- You add: "All API responses must use { success: boolean, data: T } pattern"
- Now Claude always uses correct format

### 4. Keep It Concise

Focus on what Claude needs EVERY session:

✅ **Good:**
```markdown
## API Response Format
Always wrap responses: { success: boolean, data?: T, error?: { code, message } }
```

❌ **Too verbose:**
```markdown
## API Response Format
In our application, we have decided to use a specific format for all API 
responses. This format includes a success boolean field that indicates 
whether the request was successful or not. Then we have a data field...
```

### 5. Use for Sub-Folders Too

For monorepos or microservices:

```
project/
├── CLAUDE.md              # Root rules
├── packages/
│   ├── web/
│   │   └── CLAUDE.md      # Web-specific rules
│   └── api/
│       └── CLAUDE.md      # API-specific rules
```

Claude loads the appropriate CLAUDE.md based on working directory.

## What to Add After /init

### Team Conventions

```markdown
## Code Style
- Use 2-space indentation
- Max line length: 100 characters
- Prefer const over let
- Use async/await, avoid callbacks
```

### Domain Knowledge

```markdown
## Business Logic
- "Order" means confirmed purchase
- "Cart" means items pending checkout
- "User" = authenticated, "Visitor" = not authenticated
```

### Common Mistakes to Avoid

```markdown
## Gotchas
- Don't use Date.now() for timestamps, use server time
- Always validate user permissions before DB queries
- Never commit .env files
```

## When to Update CLAUDE.md

### Immediate Updates

Add rules when:
- Claude makes the same mistake twice
- You find yourself repeating instructions
- New patterns are established
- Onboarding new team members

### Periodic Reviews

Review monthly to:
- Remove outdated rules
- Consolidate related rules
- Check if rules are still needed

## /init vs Manual Creation

| Approach | Best For |
|----------|----------|
| `/init` | New projects, quick start |
| Manual | Existing complex projects |
| Copy template | Consistent team standards |

## Next Steps After /init

1. ✅ Review generated CLAUDE.md
2. ✅ Add team-specific conventions
3. ✅ Test with a real task
4. ✅ Iterate based on results
5. ✅ Commit to version control

---

**Pro Tip:** The `/init` command is just the starting point. The most effective CLAUDE.md files are built incrementally by adding rules based on actual interactions with Claude.
