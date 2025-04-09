
# Mongory

A Mongo-like in-memory query DSL for Ruby.

Mongory lets you filter and query in-memory collections using syntax and semantics similar to MongoDB. It is designed for expressive chaining, symbolic operators, and composable matchers.

## Installation

Add to your Gemfile:

```bash
bundle add mongory
```

Or install manually:

```bash
gem install mongory
```

## Basic Usage

```ruby
records = [
  { 'name' => 'Jack', 'age' => 18, 'gender' => 'M' },
  { 'name' => 'Jill', 'age' => 15, 'gender' => 'F' },
  { 'name' => 'Bob',  'age' => 21, 'gender' => 'M' },
  { 'name' => 'Mary', 'age' => 18, 'gender' => 'F' }
]

result = records.mongory
  .where(:age.gte => 18)
  .or({ :name => /J/ }, { :name.eq => 'Bob' })
  .desc(:age)
  .limit(2)
  .to_a

puts result
```

## Supported Operators

| Category     | Operators                           |
|--------------|-------------------------------------|
| Comparison   | `$eq`, `$ne`, `$gt`, `$gte`, `$lt`, `$lte` |
| Set          | `$in`, `$nin`                       |
| Boolean      | `$and`, `$or`, `$not`               |
| Pattern      | `$regex`                            |
| Presence     | `$exists`, `$present`               |
| Nested Match | `$elemMatch`                        |

Operators can be chained from symbols:

```ruby
{ :age.gte => 18, :status.in => %w[active archived] }
```

## Query API Reference

- `.where(cond)` → adds `$and` condition
- `.or(*conds)` → adds `$or` conditions
- `.not(cond)` → wraps condition in `$not`
- `.asc(*keys)` / `.desc(*keys)` → sorts results
- `.limit(n)` → restricts result size
- `.pluck(:field1, :field2)` → extract fields from each record

Internally, the query is compiled into a matcher tree using the `QueryMatcher` and `ConditionConverter`.

## Configuration

You can configure custom conversion rules for keys or values:

```ruby
Mongory.configure do |mc|
  mc.data_converter.configure do |dc|
    dc.register(MyDateLikeObject) { iso8601_format(self) }
  end

  mc.condition_converter.key_converter.configure do |kc|
    kc.register(Symbol) { |value| { to_s => value } }
  end

  mc.condition_converter.value_converter.configure do |vc|
    vc.register(MyType) { normalize(self) }
  end
end
```

This configuration is frozen after `configure` is called.

## Debugging

Enable match trace to inspect evaluation flow:

```ruby
Mongory.debugger.enable

records.mongory
  .where(:age => 18)
  .to_a

Mongory.debugger.disable
```

Matcher output will be indented with visual feedback.

## Architecture Overview

Mongory is built from modular components:

- **QueryBuilder**: chainable query API
- **ConditionConverter**: transforms flat conditions into matcher trees
- **Converters**: normalize keys and values
- **Matchers**: perform evaluation per operator
- **Debugger**: optional trace during matching

## Development

- After cloning the repo, install dependencies:

  ```bash
  bundle install
  ```

- Run tests with RSpec:

  ```bash
  bundle exec rspec
  ```

- To generate YARD documentation:

  ```bash
  yard doc
  ```

- For an interactive console, run:

  ```bash
  bin/console
  ```

## Contributing

Contributions are welcome! Here's how you can help:

1. **Fork the repository**.
2. **Create a new branch** for each significant change.
3. **Write tests** for your changes.
4. **Send a pull request**.

Please ensure your code adheres to the project's style guide and that all tests pass before submitting.

## Code of Conduct

Everyone interacting in the Mongory project's codebases, issue trackers, chat rooms, and mailing lists is expected to follow the [code of conduct](https://github.com/koten0224/mongory/blob/main/CODE_OF_CONDUCT.md).

## License

MIT. See LICENSE file.
