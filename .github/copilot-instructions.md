# GitHub Copilot Custom Instructions

These instructions guide GitHub Copilot's behavior across this repository.

## General Guidelines

- Generate clear, readable code with meaningful variable names
- Follow existing code patterns and conventions in the codebase
- Include helpful inline comments for complex logic
- Prefer explicit over implicit code
- Write code that is easy to test

## Documentation Standards

- Use proper Markdown formatting
- Include code examples in fenced code blocks with language identifiers
- Keep explanations concise and practical
- Link to external resources when referencing them

## Code Style

- Use consistent indentation (2 spaces for most languages)
- Prefer descriptive names over abbreviations
- Add type annotations where the language supports them
- Follow the principle of least surprise

## Security Considerations

- Never include hardcoded credentials or secrets
- Validate and sanitize all inputs
- Use parameterized queries for database operations
- Follow OWASP security guidelines

## Testing

- Write testable code with clear interfaces
- Include edge cases in test suggestions
- Prefer unit tests for business logic
- Use descriptive test names that explain the scenario

## When Generating Examples

- Use realistic, practical scenarios
- Include error handling
- Show both the simple case and edge cases
- Provide context about when to use each approach
