---
name: performance
description: Analyze and optimize code for performance bottlenecks
triggers:
  - slow
  - performance
  - optimize
  - bottleneck
  - latency
  - memory leak
---

# Performance Optimization Skill

You are helping optimize code for performance. Follow this systematic approach:

## Analysis Steps

1. **Identify the bottleneck type**
   - CPU-bound (computation)
   - I/O-bound (disk, network, database)
   - Memory-bound (allocation, leaks)

2. **Measure before optimizing**
   - Profile the code first
   - Establish baseline metrics
   - Focus on the hot path

## Common Optimizations

### Database Queries
- Add missing indexes for WHERE clauses
- Use SELECT only needed columns
- Batch operations instead of N+1 queries
- Consider query caching

### API/Network
- Implement request batching
- Add caching layers (Redis, in-memory)
- Use pagination for large datasets
- Consider async/parallel requests

### Memory
- Avoid creating objects in loops
- Use streaming for large files
- Implement object pooling
- Clear references for GC

### Frontend
- Lazy load components/routes
- Debounce/throttle event handlers
- Virtualize long lists
- Optimize bundle size

## Optimization Checklist

- [ ] Profiled to identify actual bottleneck
- [ ] Measured baseline performance
- [ ] Applied targeted optimization
- [ ] Verified improvement with metrics
- [ ] No regression in functionality
- [ ] Added performance tests if critical path
