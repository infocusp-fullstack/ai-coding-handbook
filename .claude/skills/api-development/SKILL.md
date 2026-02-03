---
name: api
description: Guidelines for developing REST APIs
triggers:
  - API
  - endpoint
  - REST
  - route
  - handler
---

# API Development Skill

You are helping develop REST APIs. Follow these guidelines:

## Endpoint Structure

Use RESTful conventions:
- `GET /resources` - List resources (with pagination)
- `GET /resources/:id` - Get single resource
- `POST /resources` - Create resource
- `PUT /resources/:id` - Update resource (full)
- `PATCH /resources/:id` - Update resource (partial)
- `DELETE /resources/:id` - Delete resource

## Request Validation

Always validate incoming requests:

```typescript
import { z } from 'zod';

const CreateUserSchema = z.object({
  email: z.string().email(),
  name: z.string().min(2).max(100),
  role: z.enum(['user', 'admin']).default('user'),
});

// Validate in handler
const result = CreateUserSchema.safeParse(req.body);
if (!result.success) {
  return res.status(400).json({
    success: false,
    error: 'Validation failed',
    details: result.error.issues,
  });
}
```

## Response Format

Use consistent response structure:

```typescript
// Success response
{
  success: true,
  data: { ... },
  meta: { page: 1, perPage: 20, total: 100 } // for lists
}

// Error response
{
  success: false,
  error: "Human-readable error message",
  code: "ERROR_CODE", // machine-readable
  details: { ... } // optional additional info
}
```

## HTTP Status Codes

- `200 OK` - Successful GET, PUT, PATCH
- `201 Created` - Successful POST
- `204 No Content` - Successful DELETE
- `400 Bad Request` - Validation errors
- `401 Unauthorized` - Authentication required
- `403 Forbidden` - Authorization failed
- `404 Not Found` - Resource not found
- `409 Conflict` - Duplicate or conflict
- `500 Internal Server Error` - Unexpected errors

## Error Handling

```typescript
try {
  // ... operation
} catch (error) {
  // Log full error for debugging
  logger.error('Failed to create user', { error, userId: req.user.id });

  // Return safe error to client
  return res.status(500).json({
    success: false,
    error: 'Failed to create user',
    code: 'USER_CREATE_FAILED',
  });
}
```

## Security Checklist

- [ ] Authentication middleware applied
- [ ] Authorization checks for resource ownership
- [ ] Input validation on all parameters
- [ ] Rate limiting configured
- [ ] No sensitive data in logs
- [ ] Parameterized database queries
