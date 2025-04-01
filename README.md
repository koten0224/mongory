# Mongory

A Mongo-like in-memory query DSL for Ruby
You can filter your in-memory record more way fasion just like mongoid do.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add mongory

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install mongory

## Usage

```RUBY
record = [
  { 'name' => 'Jack', 'age' => 18, 'gender' => 'M' },
  { 'name' => 'Jill', 'age' => 15, 'gender' => 'F' },
  { 'name' => 'Bob', 'age' => 21, 'gender' => 'M' },
  { 'name' => 'Mary', 'age' => 18, 'gender' => 'F' }
]

result = Mongory::QueryBuilder.new(record)
  .where(:age.gte => 18)
  .or({ :name => /J/ }, { :name.eq => 'Bob' })
  .desc(:age)
  .only(:name, :age)
  .limit(2)
  .to_a

puts "Filtered Result:\n#{result.to_a}"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/koten0224/mongory. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/koten0224/mongory/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Mongory project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/koten0224/mongory/blob/main/CODE_OF_CONDUCT.md).
