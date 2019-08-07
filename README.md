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
In order to take time measurements first it is necessary to create the following folder structure:
```
project   
└───config
│   └───common
│       └───qat
|           └───reporter
|                   | times.yml
```

The file times.yml contains the time measurements tag and description:
```bash
test_measure: This is a test measure
```
To start measuring an interaction:
```ruby
QAT::Reporter::Times.start(:test_measure)
```

To stop measuring an interaction:
```ruby
QAT::Reporter::Times.stop(:test_measure)
```

Or it can measure a block of code:
```ruby
QAT::Reporter::Times.measure(:test_measure) do
    code
    ...
    ...
  end
```

In the end of each test a time report is generated:

```ruby
Time Report:
| Interaction             | Start                    | End                      | Duration |
| ------------------------| ------------------------ | ------------------------ | -------- |
| This is a test measure  | 2019-08-06  5:30:50+0100 | 2019-08-06  5:31:59+0100 | 01m 08s  |
```

Also, it is possible to generate a Json file with the cucumber options:
```bash
--format QAT::Formatter::TimeMeasurements --out public/times.json
```
This will create a file ```times.json``` in the ```public/``` folder with the following strcture:
```bash
[
      {
        "feature": "Time measure",
        "scenario": "Take a time measurement",
        "status": "passed",
        "test_id": "test_1",
        "test_run_id": "test_1_123456789",
        "measurements": [
          {
            "id": "test_measure",
            "name": "This is a test measure",
            "time": {
              "duration": 1.234567890123456,
              "human_duration": "00m 01s"
            }
          }
        ]
      },
      {
        "feature": "Time measure",
        "scenario": "Take a time measurement 2",
        "status": "passed",
        "test_id": "test_2",
        "test_run_id": "test_2_123456789",
        "measurements": [
          {
            "id": "test_measure",
            "name": "This is a test measure",
            "time": {
              "duration": 1.234567890123456,
              "human_duration": "00m 01s"
            }
          }
        ]
      }
    ]
```
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/readiness-it/qat-reporter. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Code of Conduct

Everyone interacting in the QAT::Reporter project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/readiness-it/qat-reporter/blob/master/CODE_OF_CONDUCT.md).