# Git Worktrees for AI-Driven Development

## TL;DR

Git worktrees allow you to work on multiple branches simultaneously without stashing or committing incomplete work. Essential for AI-driven parallel development.

```bash
# Create worktree for feature branch
git worktree add ../project-feature-branch feature-branch

# Switch between worktrees (each has its own files and branch)
cd ../project-feature-branch  # Work on feature
cd ../project                 # Back to main
```

## Why Worktrees Are Essential for AI Development

### The Problem

Traditional workflow with AI tools:
```
1. Start feature A with Claude
2. Boss asks for urgent fix on main
3. Stash or commit WIP changes
4. Switch to main
5. Do the fix
6. Switch back, unstash
7. Claude lost context, confused about state
```

### The Worktree Solution

```
~/projects/
├── myapp/                    # Main worktree (main branch)
├── myapp-feature-auth/       # Feature worktree (auth branch)
├── myapp-hotfix-login/       # Hotfix worktree (hotfix branch)
└── myapp-refactor-db/        # Refactor worktree (refactor branch)

Each worktree:
- Has its own branch
- Has its own working directory
- Has its own installed dependencies
- Has its own running dev server (different port)
- Maintains its own Claude context
```

## Basic Commands

### Creating Worktrees

```bash
# From existing branch
git worktree add ../myapp-feature-auth feature/auth

# Create new branch and worktree
git worktree add -b feature/payments ../myapp-payments

# From specific commit/SHA
git worktree add ../myapp-experiment abc123

# From tag
git worktree add ../myapp-v2 v2.0.0
```

### Listing Worktrees

```bash
git worktree list

# Output:
/home/user/projects/myapp              1234abc [main]
/home/user/projects/myapp-feature-auth 5678def [feature/auth]
/home/user/projects/myapp-hotfix       9abcdef [hotfix/login]
```

### Removing Worktrees

```bash
# Remove worktree (safe - doesn't delete branch)
git worktree remove ../myapp-feature-auth

# Force remove (if unclean)
git worktree remove -f ../myapp-feature-auth

# Remove and delete branch
git worktree remove -f ../myapp-feature-auth
git branch -D feature/auth
```

## AI Development Workflow with Worktrees

### Scenario 1: Parallel Feature Development

```bash
# Main project
cd ~/projects/myapp
git status  # On main, clean

# Create worktree for feature A
git worktree add -b feature/user-profiles ../myapp-profiles
cd ../myapp-profiles
# Start Claude: "Implement user profiles..."
# npm run dev (port 3000)

# In another terminal - create worktree for feature B
git worktree add -b feature/notifications ../myapp-notifications
cd ../myapp-notifications
# Start Claude: "Implement notifications..."
# npm run dev (port 3001)

# Original worktree stays on main for hotfixes
cd ~/projects/myapp
# Available for urgent fixes
```

### Scenario 2: Code Review While Developing

```bash
# You're working on a feature
cd ~/projects/myapp-feature
git status  # Feature branch, uncommitted changes

# Teammate asks for review on their PR
git worktree add ../myapp-review colleague/feature
cd ../myapp-review
# Review code without disturbing your work

# When done
git worktree remove ../myapp-review

# Back to your feature
cd ~/projects/myapp-feature
# Everything exactly as you left it
```

### Scenario 3: Long-Running Refactor

```bash
# Main worktree for daily work
cd ~/projects/myapp
git checkout main

# Refactor worktree for big changes
git worktree add -b refactor/architecture ../myapp-refactor
cd ../myapp-refactor
# Work on refactor over several days

# Meanwhile, in main worktree
cd ~/projects/myapp
# Continue normal development
# Merge main into refactor periodically
cd ../myapp-refactor
git merge main
```

## Advanced Patterns

### Worktree Organization

Recommended directory structure:
```
~/code/
├── project/                    # Main worktree (always main/master)
├── project-wt-/                # Worktrees directory prefix
│   ├── feature-auth/          # Feature branches
│   ├── feature-payments/
│   ├── hotfix-2024-01/        # Hotfixes
│   ├── experiment-nextjs14/   # Experiments
│   └── review-sarah/          # Code reviews
```

### Automated Worktree Creation

Create a helper function in your shell:

```bash
# Add to ~/.bashrc or ~/.zshrc
wt() {
  local branch=$1
  local dir="../$(basename $PWD)-wt-$branch"
  
  if git worktree add -b "$branch" "$dir"; then
    echo "Created worktree: $dir"
    echo "cd $dir"
    # if you start claude from this directory, you can even add commands to copy your skills etc here as well depending on the target directory you are creating worktrees at
  else
    echo "Failed to create worktree"
  fi
}

# Usage:
# wt feature/new-login
# cd ../myapp-wt-feature-new-login
```

### Cleaning Up Old Worktrees

```bash
# Remove all worktrees except main
git worktree list | grep -v "$(pwd)$" | awk '{print $1}' | xargs -I {} git worktree remove -f {}

# Or safer - list first, then remove manually
git worktree list
# Remove specific ones
git worktree remove ../myapp-old-feature
```

## Best Practices

### 1. Keep Main Worktree Clean

Always keep your main worktree on main/master:
```bash
cd ~/projects/myapp
git checkout main  # Main worktree always on main

# Do all feature work in separate worktrees
git worktree add -b feature/x ../myapp-x
```

### 2. Different Ports for Each Worktree

When running dev servers, use different ports:
```bash
# In main worktree
npm run dev  # Port 3000 (default)

# In feature worktree
PORT=3001 npm run dev

# In another feature
PORT=3002 npm run dev
```

### 3. Separate Dependencies

Each worktree has its own `node_modules`:
```bash
cd ../myapp-feature
npm install  # Separate install

# Changes in one don't affect others
```

### 4. Sync with Main Regularly

When working on long-running features:
```bash
cd ../myapp-feature
git fetch origin
git merge origin/main
# Resolve conflicts in worktree, main stays clean
```

### 5. Use Descriptive Names

```bash
# Good - clear what it is
git worktree add ../myapp-feature-stripe-integration

# Bad - what is this?
git worktree add ../myapp-branch2
```

## Integration with Claude Code

### Parallel AI Sessions

You can run multiple Claude instances:
```bash
# Terminal 1
cd ~/projects/myapp-feature-a
claude
# Working on auth feature

# Terminal 2
cd ~/projects/myapp-feature-b
claude
# Working on notifications feature

# Terminal 3
cd ~/projects/myapp
claude
# Available for hotfixes
```

## Common Workflows

### Daily Standup Prep

```bash
# Check all active worktrees
git worktree list

# Quick status on each
for dir in ../myapp-wt-*; do
  echo "=== $dir ==="
  (cd "$dir" && git status --short)
done
```

### End of Day Cleanup

```bash
# List all worktrees
git worktree list

# Remove merged worktrees
git worktree remove ../myapp-feature-merged

# Keep active ones for tomorrow
```

### Starting New Task

```bash
# Always start from main
cd ~/projects/myapp
git checkout main
git pull origin main

# Create worktree for new task
git worktree add -b feature/new-thing ../myapp-new-thing
cd ../myapp-new-thing

# Start Claude
claude
# "Let's implement the new feature..."
```


## Tips for Success

1. **Always use main worktree as reference** - Keep it clean and up-to-date
2. **Delete merged worktrees** - Don't accumulate old worktrees
3. **Use consistent naming** - Makes it easy to find worktrees
4. **Sync regularly** - Merge main into feature worktrees often
5. **Different ports** - Avoid conflicts between running servers
6. **Separate node_modules** - Each worktree is independent

## Resources

- **Git Docs**: [git-scm.com/docs/git-worktree](https://git-scm.com/docs/git-worktree)
- **Pro Git Book**: Chapter on worktrees
- **Video Tutorial**: Search "git worktree workflow"

---

**Bottom Line**: Worktrees are the biggest productivity boost for AI-driven development. Start using them today.
