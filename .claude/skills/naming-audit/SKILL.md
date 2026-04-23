---
name: naming-audit
description: Find identifiers whose names lie about what the code does — getters that write, predicates that throw, "parse" that mutates, stale names that drifted after refactors. Use when the user says "naming-audit", "audit names", "check names", or asks to review naming in a file/diff/PR. Language-agnostic; works on any codebase.
---

# Naming Audit

Hunt for identifiers where **the name promises one thing and the implementation does another**. A lying name misleads every future reader — linters don't catch this because it requires reading the body and comparing intent to behavior.

## Scope — what to audit

Pick the target based on how the user invoked the skill:

1. **Explicit path** (`naming-audit src/auth/login.ts`) → audit that file or directory recursively.
2. **Diff / branch / PR** (`naming-audit diff`, `naming-audit branch`) → audit only identifiers **introduced or renamed** in the diff vs. the main/default branch. Use `git diff --name-only <base>...HEAD` to get files, then focus on added/modified functions.
3. **No argument** → audit the current branch's changes vs. main/default. If there are no changes, audit the most recently modified files (`git log -n 10 --name-only --pretty=format:`).

Prefer scanning **functions, methods, and booleans** first — they lie the most. Then variables and classes.

## What counts as a lying name

Flag any of these patterns. For each hit, show file:line, the name, a one-line quote of the offending behavior, and which category it falls under.

### 1. Query/command mismatch (CQS violations)
Names that sound pure but mutate, or sound like mutations but are queries.
- `get*`, `find*`, `fetch*`, `read*`, `is*`, `has*`, `can*` → should not mutate state, write to DB, send network calls, or modify arguments.
- `parse*`, `format*`, `calculate*`, `compute*`, `to*` → should not mutate inputs or global state.
- `validate*` → if it only returns bool, fine; if it throws, flag as "validate-that-throws" unless explicitly `validateOrThrow`.

### 2. Predicates that don't return a clean bool
- `is*`, `has*`, `can*`, `should*` that throw instead of returning false.
- Predicates that return non-boolean (null/undefined/object) without the name hinting at tri-state.
- Negated names (`isNotEmpty`, `hasNoErrors`) — call out as readability smells; double-negatives in callers are bug magnets.

### 3. Scope or lifetime lies
- `temp*`, `scratch*`, `draft*` that persist beyond the function.
- `global*`, `shared*` that are actually local.
- `cache*` that never evicts, or `*Cache` that isn't cached (re-fetches every call).

### 4. Type or shape lies
- `*List` / `*Array` that's a Map/Set/Dict.
- `count` / `length` / `size` that's a string or nullable.
- `*Id` that's the whole entity object, or vice versa.
- `*s` (plural) holding a single item; singular holding a collection.

### 5. Async/sync mismatch
- `Async` suffix on a synchronous function, or a name with no hint of async on a function that returns a Promise/Task and does I/O.
- `sync*` prefix on something that awaits internally.

### 6. Stale names (drift)
- Function name describes a subset of what it now does: `updateUserEmail` that also updates phone and address.
- Name references removed behavior: `sendEmailAndLog` that no longer logs.
- Use `git log -L :<name>:<file>` or `git blame` to confirm drift when suspicious.

### 7. Misleading booleans
- Flags whose `true` value means the *opposite* of the name (`disabled = true` vs. `enabled = false` is fine; `isEnabled` that's true when disabled is not).
- Double-negative config keys: `disableFooOff`, `notNoValidation`.

### 8. "Manager", "Helper", "Utils", "Handler", "Processor"
- These names don't lie outright, but they're name-shaped holes — they describe nothing. Flag as **low severity** with a suggestion to rename based on the one thing the class actually owns. Skip if the user told you to ignore low-severity.

## Output format

Group findings by severity. Keep each entry to 2–3 lines max.

```
🔴 LIES — name contradicts behavior
  src/users/repo.ts:42  getUserById
    Also writes: calls `auditLog.insert(...)` and sets `lastAccessedAt`.
    Suggest: loadUserByIdAndTouch, or split into getUserById + recordAccess.

🟡 MISLEADING — name is partial or ambiguous
  src/cart/pricing.ts:88  calculateTotal
    Mutates input: assigns `item.discountedPrice` on each cart item.
    Suggest: applyPricing (mutation intent clear) or return a new priced-cart.

⚪ VAGUE — name describes nothing (low severity)
  src/infra/UserManager.ts  class UserManager
    Owns: password reset emails only. Suggest: PasswordResetSender.
```

If nothing is wrong, say so in one line. Do not invent findings to fill the report.

## Rules of engagement

- **Read the body before flagging.** A name is only a lie if the implementation contradicts it. Never flag on the name alone.
- **Don't flag names just because they could be shorter or prettier.** This skill is about *dishonesty*, not style.
- **Respect conventions.** `useXyz` in React, `UseXyz` in C# middleware, `xyz_` suffix for private in some projects — check nearby code before flagging as weird.
- **Test files get a pass on most categories** — test helpers often mutate and throw by design. Only flag tests for category #6 (drift) and #7 (misleading booleans).
- **Generated code is out of scope.** Skip files under `*.g.*`, `*Generated*`, `dist/`, `build/`, `node_modules/`, `bin/`, `obj/`.
- **Don't edit code.** This skill only reports. If the user asks for fixes afterward, offer to rename in a follow-up pass so they can review findings first.
- **Be confident or silent.** A soft "this might be misleading" is worse than nothing. Either you can name the lie concretely (quote the offending behavior) or you drop the finding.

## When the user asks for a fix

After reporting, if the user says "fix them" or "rename these":
1. Start with 🔴 findings only unless told otherwise.
2. Rename across all usages (grep for the identifier, update call sites).
3. One rename per commit is ideal, but batch is OK if the user says so.
4. Never auto-rename public API surface (exported functions, HTTP routes, DB columns) — flag those and ask.
