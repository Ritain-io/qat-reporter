[![Build Status](https://travis-ci.org/readiness-it/qat-reporter.svg?branch=master)](https://travis-ci.org/readiness-it/qat-reporter)
# QAT::Reporter

- Welcome to the QAT Reporter gem!

## Table of contents 
- This gem have functionalities such as:
    - Status from test executions;
    - Time measurements.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'qat-reporter'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install qat-reporter
    
# Usage
```ruby
require 'qat/reporter'
```

## Status from test executions:
In order to check status from test executions it is necessary to run the following task:
```ruby
rake test:run 
```
With the cucumber options:
```bash
--format QAT::Formatter::ReqCoverage --out public/requirement_coverage.json
```
This will create a file ```requirement_coverage.json``` in the ```public/``` folder.

## Time measurements:
In order to take time measurements it is necessary to run the following task:
```ruby
rake test:run 
```
With the cucumber options:
```bash
-t @label
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/qa-toolkit/qat-reporter. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Code of Conduct

Everyone interacting in the Qat::Reporter project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/readiness-it/qat-reporter/blob/master/CODE_OF_CONDUCT.md).