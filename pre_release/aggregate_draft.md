
# Mongory Aggregate System Draft (v2.0.0)

## 🎯 Goal

Introduce an aggregate pipeline system to Mongory with support for key MongoDB-style operators:

- `$match`: filter data using existing matchers
- `$group`: group and accumulate values
- `$project`: select or rename fields
- `$sort`: sort records by fields
- `$limit` / `$skip`: pagination
- `$unwind`: deconstruct array fields
- `$count`: count records
- `$sum`, `$avg`, `$max`, `$min`: accumulator operators

---

## 🧱 Module Breakdown

| Module             | Purpose                                   |
|--------------------|-------------------------------------------|
| `Aggregator`       | Main pipeline controller                  |
| `Stages::*`        | Each pipeline stage implementation        |
| `Accumulators::*`  | Accumulator functions for `$group` stage  |

---

## 🧬 DSL Examples

```ruby
# Method chaining style
q = Mongory.aggregate(records)
           .match(name: /foo/, age: { :$gte => 18 })
           .group(_id: :gender, total: { :$sum => 1 })
           .project(gender: :_id, total: 1)
           .sort(total: -1)
           .limit(10)

# Array-based pipeline
Mongory.aggregate(records, [
  { "$match" => { age: { :$gte => 18 } } },
  { "$group" => { _id: :gender, total: { :$sum => 1 } } }
])
```

---

## 🧩 Recommended Task Breakdown

1. Implement `Mongory::Aggregator` pipeline controller
2. Add `$match` support via QueryBuilder ✅
3. Add `$group`
   - `_id` supports symbol or hash keys
   - Use `Accumulators::Sum`, etc. internally
4. Add `$project`
5. Add `$sort` (re-use QueryBuilder logic)
6. Add `$limit`, `$skip`
7. Add `$unwind` (for array fields)
8. Add `$count`
9. Add stage-level `.explain` tracing
10. Build test fixtures & stubs
11. Document aggregate usage in README
12. Bundle with v2.0.0 release (breaking changes)

---

## 🤝 Integration with Matcher System

- `$match` uses existing QueryBuilder logic ✅
- `$group._id` and `$project` keys should be converted using KeyConverter
- Each stage can implement `#explain_tree` for debug output (optional)
