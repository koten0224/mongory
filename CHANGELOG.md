## [1.7.0] - 2025-04-13

### Added

- `QueryBuilder#explain` prints a tree-structured matcher breakdown using `PP`, useful for debugging.
- Matchers now support `#render_tree` and `#tree_title`, enabling structured introspection.
- `QueryBuilder#any_of` added as a semantic alias for `.and('$or' => [...])`.

### Changed

- Filter logic restructured to use immediately-parsed matchers (`set_matcher`) instead of building on `result`.
- `.each` now directly filters via matcher tree evaluation, removing dependency on an internal condition hash.
- Removed legacy `.result` method.
- `.or(...)` now wraps existing conditions intelligently when merging mixed operator states.
- `.pluck` and `.sort_by_keys` no longer convert keys to strings, fixing inconsistency with native Mongoid behavior.

### Deprecated

- `.asc` and `.desc` now emit deprecation warnings; they will be removed in v2.0.0.

## [1.6.4] - 2025-04-11

### Fixed

- `MongoidPatch` now references `Mongory::Converters::KeyConverter` directly instead of lazily accessing it through `.condition_converter`.
- Restored missing `Mongory.configure` method accidentally removed in earlier documentation refactor.
- Ensured all `.configure` entrypoints are consistently available for all converters.

## [1.6.1] - 2025-04-11

### Added

- **Rails Integration via Railtie**  
  Mongory now auto-integrates with Rails if present, using a new `Mongory::Railtie` and `RailsPatch` module.

- **Mongoid Integration Module**  
  Added `mongory/mongoid` which registers `Mongoid::Criteria::Queryable::Key` for symbolic query operators (e.g. `:age.gt`).

- **Conditional Auto-Require**  
  `mongory.rb` now conditionally requires `rails` and `mongoid` integration modules when Rails or Mongoid is detected.

- **YARD Documentation**  
  Improved YARD docstrings for all public APIs, including `QueryOperator`, `InstallGenerator`, and matchers.

### Changed

- **Generator Initializer Cleanup**  
  Removed direct Mongoid-specific converter registration from generator output. This logic is now encapsulated in `mongory/mongoid.rb`.

- **Improved Symbol DSL Activation**  
  Symbol snippets (`:age.gt => 30`) are now opt-in, via `Mongory.enable_symbol_snippets!`, and properly isolated from default runtime.

- **Safer Core Patch for present?/blank?**  
  When in Rails, Mongory will use `Object#present?` and `Object#blank?` instead of internal implementations, for better semantic consistency.

## [1.6.0] - 2025-04-11

### Added
- **Custom Operator: `$every`**
  Added support for `$every`, a new matcher that succeeds only if *all* elements in an array satisfy the condition.
- **Custom Error Class: `Mongory::TypeError`**
  Replaces Ruby's `TypeError` for internal validation, enabling cleaner and safer error handling.
- **Internal API: `SingletonBuilder`**
  Introduced a unified abstraction for building singleton converters and utilities (used by `Debugger`, all Converters, etc.).

### Changed
- **Unified Matcher Construction**
  All matchers now use `.build(...)` instead of `.new(...)` for consistent instantiation.
- **Simplified Matcher Dispatch**
  Multi-matchers (`$and`, `$or`, etc.) now unwrap themselves when only one submatcher is present.
- **Centralized Matcher Responsibility**
  `ConditionMatcher` replaces `DefaultMatcher` as the default dispatcher for query conditions.
- **Consistent Data Conversion**
  All nested matchers (e.g. `DigValueMatcher`, `ElemMatchMatcher`) now apply `data_converter` at match-time.

### Fixed
- **Validation Improvements**
  Introduced `deep_check_validity!` to ensure all nested matchers are properly verified.
- **Edge Case Consistency**
  Cleaner fallback handling and key traversal behavior under complex or mixed-type query structures.

---

## [1.5.0] - 2025-04-09

### Added
- **YARD Documentation**: Added `.yardopts` configuration file for generating documentation.
- **Converters Module**: Introduced `Mongory::Converters` module with `DataConverter` and `ConditionConverter` classes for better data and condition normalization.
- **Debugger**: Exposed `Utils::Debugger` for better debug control and query tracing.

### Changed
- **QueryBuilder Refactor**: Simplified `build_query` method to use `QueryBuilder` directly without namespace.
- **Data and Condition Converters**: Directly exposed `data_converter` and `condition_converter` via `Mongory` module for easier access and configuration.
- **Removed Config Class**: Removed `Config` class and replaced with direct configuration in `Mongory`.

### Fixed
- **Bug Fixes**: Corrected issues with array comparisons and query operator behaviors.

---

## [Prior Versions Summary]

- `1.0.1`: Initial release
- `1.1.0 ~ 1.3.3`: Refactored matcher architecture, added class inheritance structure, separated key/value matcher logic.
- `1.4.x`: Skipped
