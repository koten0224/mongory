## [Unreleased]

...

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
