# The Big Shift: AI and Software Development

## TL;DR

AI coding assistants represent a fundamental shift in software development—comparable to the move from assembly language to high-level languages. But unlike that transition, we're moving from **deterministic** to **non-deterministic** computing.

## The Assembly-to-High-Level Comparison

Martin Fowler (ThoughtWorks, 2025):

> "The comparable thing would be the shift from assembly language to the very first high-level languages."

But with a crucial difference:
- Assembly → High-level: Still deterministic (same input = same output)
- Traditional code → AI-assisted: **Non-deterministic** (same prompt may give different results)

## What This Means in Practice

### Deterministic (Traditional Code)

```javascript
function add(a, b) {
  return a + b;
}

add(2, 3); // Always returns 5
```

### Non-Deterministic (AI-Assisted)

```
> "Write a function to add two numbers"

# Run 1: Returns simple function
# Run 2: Returns function with type checking
# Run 3: Returns function with overflow handling
```

**Same prompt, different outputs.** This is the fundamental shift.

## Implications

### 1. Review Becomes Critical

Fowler's advice:
> "You've got to treat every slice as a PR from a rather dodgy collaborator who's very productive in the lines-of-code sense."

AI generates code fast. But speed without review is dangerous:
- Code may look correct but have subtle bugs
- AI may misunderstand requirements
- Generated patterns may not fit your architecture

### 2. Testing Becomes More Important, Not Less

Counter-intuitive: AI should reduce testing burden, right?

**Wrong.** Testing is now your forcing function:
- Tests verify AI understood the requirement
- Tests catch AI's subtle mistakes
- Tests document expected behavior
- Tests are your safety net for non-deterministic output

**TDD becomes more valuable:**
```
1. Write test (human defines expected behavior)
2. AI generates implementation
3. Test verifies AI got it right
4. Iterate if needed
```

### 3. Understanding Remains Essential

The temptation: Let AI do everything, don't worry about understanding.

The reality: If you can't explain the code, you can't:
- Debug it when it breaks
- Extend it correctly
- Review others' AI-generated code
- Make architectural decisions

Fowler:
> "AI's killer app so far: understanding legacy systems"

Use AI to **understand** code, not to avoid understanding.

### 4. Vibe Coding Has Its Place

"Vibe coding" = Letting AI generate code without deep review.

**Appropriate for:**
- Prototypes and experiments
- Learning and exploration
- Personal projects
- Throwaway code

**Not appropriate for:**
- Production systems
- Security-sensitive code
- Code others will maintain
- Anything you'll regret later

## The New Development Loop

### Traditional

```
Think → Code → Test → Debug → Deploy
```

### AI-Assisted

```
Think → Prompt → Review → Test → Iterate → Deploy
         ↓         ↓
        AI      Human
      generates  validates
```

**Review and validation are now explicit steps**, not optional.

## Practical Guidelines

### Always Review

Every piece of AI-generated code:
1. Read and understand it
2. Check it solves the actual problem
3. Verify it follows your patterns
4. Look for edge cases and errors
5. Run tests

### Write Tests First

For important code:
```
1. Define test cases (human decision)
2. Write failing tests
3. Ask AI to make tests pass
4. Review implementation
5. Refactor if needed
```

### Maintain Understanding

Periodically ask yourself:
- Could I explain this code to a colleague?
- Could I debug it without AI?
- Do I know why it's structured this way?

If not, spend time understanding before moving on.

### Use AI to Learn

Best use of AI isn't avoiding work—it's learning faster:
```
> Explain how this authentication flow works
> What patterns is this code using?
> Why might this approach have been chosen?
> What are the tradeoffs of this design?
```

## Warning Signs

### You're Over-Relying on AI When:

- You accept code you don't understand
- You skip reviews because "AI wrote it"
- You can't debug AI-generated code
- You stop thinking about design
- Your test coverage decreases
- You avoid legacy code because AI can't help

### Healthy AI Usage Looks Like:

- AI accelerates, you validate
- Tests catch AI mistakes
- You understand what you commit
- AI helps you learn, not avoid learning
- Your skills grow, not atrophy

## Research to Consider

### METR Study (2025)

AI tools increased task completion time by 19% for experienced developers when used carelessly. Why?
- Time spent reviewing AI output
- Fixing AI mistakes
- Debugging hallucinated code

### GitClear Analysis (2024)

8x increase in code duplication across AI-assisted codebases.
- AI doesn't know your abstractions
- Copies patterns instead of reusing
- Human review catches this—if you're reviewing

### Developer Surveys

67% of developers report spending more time debugging AI-generated code than writing it manually for complex tasks.

## The Bottom Line

AI coding assistants are transformative tools. But they transform **how** we work, not **what** we're responsible for.

You're still responsible for:
- Understanding the code
- Ensuring quality
- Maintaining security
- Making design decisions
- The code that ships

AI is a powerful collaborator. But you're still the engineer.

## Resources

- **Martin Fowler on LLMs**: [martinfowler.com/articles/2025-nature-abstraction.html](https://martinfowler.com/articles/2025-nature-abstraction.html)
- **Pragmatic Engineer Podcast**: [newsletter.pragmaticengineer.com/p/martin-fowler](https://newsletter.pragmaticengineer.com/p/martin-fowler)

---

Next: [Review Your Code](review-your-code.md) | [Learning, Not Outsourcing](learning-not-outsourcing.md)
