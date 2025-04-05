## [Unreleased]

## [1.0.1] - 2025-04-01

- Initial release

## [1.1.0] - 2025-04-01

- Refactor with OOP

## [1.2.0] - 2025-04-02

- Refactor the matcher classes inheritance and add diagram

## [1.3.0] - 2025-04-02

- Refactor the matcher classes inheritance and update diagram
- Add rails supporting, allow to configure the way you want to convert data to compare
- Make query builder more efficient

## [1.3.1] - 2025-04-02

- Adjust the logic of array compare
- Let query operator could match the regular mongoid usage
- Change check validity behavior

## [1.3.2] - 2025-04-03
- Restrictions on the use of normalize
- Add collection matcher to treat array data

## [1.3.3] - 2025-04-05
- Replaced HashMatcher with ConditionMatcher as the field matcher dispatcher.
- KeyValueMatcher is removed and replaced with DigValueMatcher, now focused solely on record key traversal.
- Moved matcher dispatch logic into ConditionMatcher.
- DigValueMatcher now inherits MainMatcher for simpler reuse of match? behavior.