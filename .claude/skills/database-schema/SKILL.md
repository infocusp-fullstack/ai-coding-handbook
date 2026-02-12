---
name: schema
description: Design database schemas and migrations
triggers:
  - schema
  - migration
  - database design
  - table
  - model
  - ERD
  - foreign key
---

# Database Schema Design Skill

You are helping design database schemas and migrations. Follow these guidelines:

## Schema Design Principles

### Naming Conventions
- Tables: plural, snake_case (`users`, `order_items`)
- Columns: singular, snake_case (`created_at`, `user_id`)
- Foreign keys: `{referenced_table_singular}_id`
- Indexes: `idx_{table}_{columns}`

### Required Columns
Every table should have:
- `id` - Primary key (UUID or auto-increment)
- `created_at` - Timestamp, default NOW()
- `updated_at` - Timestamp, auto-update on change

### Soft Deletes (when needed)
- `deleted_at` - Nullable timestamp
- Filter queries with `WHERE deleted_at IS NULL`

## Relationships

### One-to-Many
```sql
-- Parent table
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email VARCHAR(255) UNIQUE NOT NULL
);

-- Child table with foreign key
CREATE TABLE posts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  title VARCHAR(255) NOT NULL
);

CREATE INDEX idx_posts_user_id ON posts(user_id);
```

### Many-to-Many
```sql
-- Junction table
CREATE TABLE user_roles (
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  role_id UUID REFERENCES roles(id) ON DELETE CASCADE,
  PRIMARY KEY (user_id, role_id)
);
```

## Migration Best Practices

1. **One change per migration** - Easier to rollback
2. **Always write down migrations** - Never assume up-only
3. **Test migrations on production data copy**
4. **Avoid breaking changes** - Add columns as nullable first
5. **Index foreign keys** - Required for join performance

## Migration Safety Checklist

- [ ] Down migration tested
- [ ] No data loss in migration
- [ ] Indexes added for new foreign keys
- [ ] Large table migrations tested for lock time
- [ ] Backwards compatible with current code
