## [Unreleased] - v2.0.0

### ⚠️ Breaking Changes
- Changed behavior of `nil` matching to include missing fields
- `$exists: false` now conforms to MongoDB semantics
- deprecate QueryBuilder#asc and #desc