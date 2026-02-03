---
description: Generate documentation for code
---

Generate documentation for:

$ARGUMENTS

## Documentation Requirements

### For Functions/Methods
Generate JSDoc/docstring with:
- Brief description of purpose
- @param for each parameter (name, type, description)
- @returns description of return value
- @throws for any exceptions thrown
- @example with usage example

### For Classes
Generate documentation with:
- Class purpose and responsibility
- Constructor parameters
- Public methods summary
- Usage example

### For Modules/Files
Generate header documentation with:
- Module purpose
- Main exports
- Dependencies
- Usage patterns

### For APIs/Endpoints
Generate documentation with:
- Endpoint URL and method
- Request parameters
- Request body schema
- Response schema
- Error responses
- Authentication requirements
- Example request/response

## Format

Use the documentation format appropriate for the language:
- TypeScript/JavaScript: JSDoc
- Python: Docstrings (Google style)
- Go: Go doc comments
- Other: Language-appropriate format

## Quality Guidelines

- Be concise but complete
- Use clear, professional language
- Include types for all parameters
- Provide realistic examples
- Document edge cases and caveats
