---
description: Generate comprehensive tests for code
---

Generate tests for:

$ARGUMENTS

## Test Requirements

### Coverage Types
- **Happy path**: Normal, expected usage
- **Edge cases**: Boundary conditions, empty inputs, max values
- **Error cases**: Invalid inputs, failures, exceptions
- **Integration**: If applicable, test component interactions

### Test Structure
- Use descriptive test names: "should [action] when [condition]"
- Follow AAA pattern: Arrange, Act, Assert
- Group related tests with describe blocks
- Keep tests independent (no shared state between tests)

### Mocking Guidelines
- Mock external dependencies (APIs, databases, file system)
- Don't mock the code being tested
- Use realistic mock data
- Reset mocks between tests

## Output Format

1. First, analyze the code to identify what needs testing
2. List the test cases to be created
3. Generate the test code with clear comments

## Test Cases to Consider

Based on the code provided, generate tests for:
- Normal inputs with expected outputs
- Null/undefined handling
- Empty collections/strings
- Invalid input types
- Boundary values (0, -1, max int, empty string)
- Error conditions and exception handling
- Async operations (if applicable)
- State changes (if applicable)

Use the testing framework and patterns consistent with the project.
