Issue 1: Implement Aggregator pipeline controller
**Title:** Implement Mongory::Aggregator base pipeline system

**Description:**
Create the main entrypoint class `Mongory::Aggregator` to process aggregate pipeline stages in order. This class will be responsible for receiving input data and applying stages sequentially.

- Accept both DSL and array-based pipeline input
- Internally dispatch each stage to its corresponding class
- Prepare for `.explain` support later

**Labels:** enhancement, aggregate
===========================================================
Issue 2: Add $match support using QueryBuilder
**Title:** Add `$match` stage support via QueryBuilder

**Description:**
Integrate `$match` stage into the aggregator using existing Mongory::QueryBuilder. This will allow users to filter records as the first stage in the pipeline.

- Reuse condition parsing and matcher dispatch logic
- Ensure it works in both chaining and array pipeline mode
- Should preserve trace/explain consistency

**Labels:** feature, matcher, aggregate
===========================================================
Issue 3: Add $group stage with accumulator support
**Title:** Implement `$group` stage with accumulators

**Description:**
Introduce the `$group` stage to support grouping records by `_id` and applying accumulator operations such as `$sum`.

- Grouping key `_id` supports symbol or hash
- Supports at least `$sum`, `$count` to start with
- Use accumulator classes under `Accumulators::` namespace

**Labels:** feature, aggregate, accumulator
===========================================================
Issue 4: Implement $project stage
**Title:** Add `$project` stage for field projection

**Description:**
Implement the `$project` stage to allow inclusion, exclusion, or renaming of fields in the result set.

- Supports 1 or 0 to include/exclude fields
- Supports field renaming (e.g. `gender: :_id`)
- Works after `$group` or `$match`

**Labels:** feature, aggregate
===========================================================
Issue 5: Add $sort stage (reusing QueryBuilder logic)
**Title:** Implement `$sort` stage

**Description:**
Add support for sorting results using `$sort` stage. Can reuse QueryBuilder’s sort logic where appropriate.

- Supports ascending (1) and descending (-1)
- Compatible with field projections and grouped results

**Labels:** feature, aggregate
===========================================================
Issue 6: Add $limit and $skip for pagination
**Title:** Support `$limit` and `$skip` stages for pagination

**Description:**
Implement pagination-related pipeline stages for limiting and skipping records in the result set.

- `$limit` applies a maximum number of records
- `$skip` offsets the result

**Labels:** enhancement, aggregate
===========================================================
Issue 7: Implement $unwind for array fields
**Title:** Implement `$unwind` stage for array flattening

**Description:**
Add support for deconstructing array fields into multiple documents using `$unwind`.

- Accepts a field name (e.g. `"$unwind" => "$tags"`)
- Each element in the array becomes a new record

**Labels:** feature, aggregate
===========================================================
Issue 8: Add $count stage
**Title:** Add `$count` stage for result counting

**Description:**
Provide a `$count` stage to return the number of documents in the pipeline at that point.

- Returns single record with `count: <number>`
- Can be used after `$match`, `$group`, etc.

**Labels:** feature, aggregate
===========================================================
Issue 9: Add .explain support for aggregate pipeline
**Title:** Add `.explain` support for aggregate pipelines

**Description:**
Enable tracing the internal structure and flow of an aggregate pipeline by implementing `.explain_tree` for each stage.

- Each stage should return its explain node
- Aggregator collects and renders full trace tree
- Integrates with existing matcher trace if `$match` is used

**Labels:** enhancement, trace, aggregate
===========================================================
Issue 10: Write test fixtures and stub stages
**Title:** Add aggregate system test fixtures and stubs

**Description:**
Create initial test records and stubbed stage classes to support integration and unit testing of the aggregate pipeline.

- Test coverage for all implemented stages
- Include edge cases for nested group, sort, projection

**Labels:** test, aggregate
===========================================================
Issue 11: Add aggregate usage guide to README
**Title:** Add aggregate usage documentation to README

**Description:**
Document the aggregate DSL, supported stages, and examples in the Mongory README file.

- Include both chainable and array formats
- Show common use cases like `$match + $group + $project`
- Mention `.explain` if available

**Labels:** docs, aggregate
===========================================================
Issue 12: Release aggregate system as part of v2.0.0
**Title:** Bundle aggregate system into v2.0.0 major release

**Description:**
Tag and release aggregate support along with other planned breaking changes as part of Mongory v2.0.0.

- Ensure all breaking changes are documented
- Update version number and changelog

**Labels:** release, breaking-change, aggregate
