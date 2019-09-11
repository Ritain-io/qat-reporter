@bug#23 @deprecated_regression
Feature: Deprecate formatters
  As a QAT Reporter legacy user,
  In order to maintain my code without refactoring,
  I want the deprecated classes to still work as previously expected

  @test#31
  Scenario: Run deprecated requirement coverage formatter with success
    Given I use the fixture "qat_project_requirement_ids"
    And I set the environment variables to:
      | variable        | value                                                                       |
      | CUCUMBER_FORMAT |                                                                             |
      | CUCUMBER_OPTS   | --format QAT::Formatter::ReqCoverage --out public/requirement_coverage.json |
    When I run `rake test:run`
    Then the exit status should be 0
    And the stderr should contain "[WARN] DEPRECATED: QAT::Formatter::ReqCoverage will be removed in a 7.0 version, please use QAT::Reporter::Formatter::ReqCoverage"
    And a file named "public/requirement_coverage.json" should exist
    And a file named "public/requirement_coverage.json" should match:
    """
    {
      "results": \[
        {
          "test": 1,
          "requirement": \[
            "99996033"
          \],
          "status": "passed",
          "duration": \d+.\d+,
          "human_duration": "\d+m\d.\d{3}s"
        },
        {
          "test": 2,
          "requirement": \[
            "99996033"
          \],
          "status": "passed",
          "duration": \d+.\d+,
          "human_duration": "\d+m\d.\d{3}s"
        },
        {
          "test": 3.1,
          "requirement": \[
            "99996033"
          \],
          "status": "passed",
          "duration": \d+.\d+,
          "human_duration": "\d+m\d.\d{3}s"
        },
        {
          "test": 3.2,
          "requirement": \[
            "99996033"
          \],
          "status": "passed",
          "duration": \d+.\d+,
          "human_duration": "\d+m\d.\d{3}s"
        }
      \]
    }
    """

  @test#32
  Scenario: Run deprecated json formatter with success
    Given I use the fixture "qat_project_embed_test_evidences"
    And I set the environment variables to:
      | variable        | value                                                    |
      | CUCUMBER_FORMAT |                                                          |
      | CUCUMBER_OPTS   | --format QAT::Formatter::Json --out public/cucumber.json |
    When I run `rake test:run`
    Then the exit status should be 0
    And the stderr should contain "[WARN] DEPRECATED: QAT::Formatter::Json will be removed in a 7.0 version, please use QAT::Reporter::Formatter::Json"
    And a file named "public/cucumber.json" should exist
    And a file named "public/cucumber.json" should not contain:
    """
      "embeddings": [
    """

  @test#33 @time_measures
  Scenario: Run deprecated json time measurements formatter with success
    Given I use the fixture "qat_project_time_measures"
    And I set the environment variables to:
      | variable        | value                                                             |
      | CUCUMBER_FORMAT |                                                                   |
      | CUCUMBER_OPTS   | --format QAT::Formatter::TimeMeasurements --out public/times.json |
    When I run `rake test:run`
    Then the exit status should be 0
    And the stderr should contain "[WARN] DEPRECATED: QAT::Formatter::TimeMeasurements will be removed in a 7.0 version, please use QAT::Reporter::Formatter::TimeMeasurements"
    And a file named "public/times.json" should exist
    And a file named "public/times.json" should contain exactly:
    """
    [
      {
        "feature": "Time measure",
        "tags": [
          "@feature",
          "@feature_tag"
        ],
        "timestamp": "2008-10-05T00:00:00+0000",
        "scenarios": [
          {
            "name": "Take a time measurement",
            "tags": [
              "@label",
              "@test#1",
              "@user_story#2",
              "@ola"
            ],
            "timestamp": "2008-10-05T00:00:00+0000",
            "test_runs": [
              {
                "id": "test_1_1_1223251200",
                "timestamp": "2008-10-06T00:00:00+0000",
                "measurements": [
                  {
                    "id": "test_measure",
                    "name": "This is a test measure",
                    "timestamp": "2008-10-06T00:00:00+0000",
                    "time": {
                      "secs": 2.0,
                      "human": "0m 02s"
                    }
                  }
                ]
              },
              {
                "id": "test_1_2_1223337602",
                "timestamp": "2008-10-07T00:00:02+0000",
                "measurements": [
                  {
                    "id": "test_measure",
                    "name": "This is a test measure",
                    "timestamp": "2008-10-07T00:00:02+0000",
                    "time": {
                      "secs": 5.0,
                      "human": "0m 05s"
                    }
                  }
                ]
              }
            ]
          }
        ]
      },
      {
        "feature": "Time measure 2",
        "tags": [

        ],
        "timestamp": "2008-10-09T00:00:11+0000",
        "scenarios": [
          {
            "name": "Take a time measurement 2.1",
            "tags": [
              "@label",
              "@test#2",
              "@user_story#3",
              "@outline"
            ],
            "timestamp": "2008-10-09T00:00:11+0000",
            "test_runs": [
              {
                "id": "test_2_1_1223596811",
                "timestamp": "2008-10-10T00:00:11+0000",
                "measurements": [
                  {
                    "id": "test_measure",
                    "name": "This is a test measure",
                    "timestamp": "2008-10-10T00:00:11+0000",
                    "time": {
                      "secs": 7.0,
                      "human": "0m 07s"
                    }
                  }
                ]
              },
              {
                "id": "test_2_2_1223683218",
                "timestamp": "2008-10-11T00:00:18+0000",
                "measurements": [
                  {
                    "id": "test_measure",
                    "name": "This is a test measure",
                    "timestamp": "2008-10-11T00:00:18+0000",
                    "time": {
                      "secs": 4.0,
                      "human": "0m 04s"
                    }
                  }
                ]
              }
            ]
          },
          {
            "name": "Take a time measurement 2.2",
            "tags": [
              "@label",
              "@test#3",
              "@user_story#3"
            ],
            "timestamp": "2008-10-11T00:00:22+0000",
            "test_runs": [
              {
                "id": "test_3_1223769622",
                "timestamp": "2008-10-12T00:00:22+0000",
                "measurements": [
                  {
                    "id": "test_measure",
                    "name": "This is a test measure",
                    "timestamp": "2008-10-12T00:00:22+0000",
                    "time": {
                      "secs": 2.0,
                      "human": "0m 02s"
                    }
                  }
                ]
              }
            ]
          },
          {
            "name": "Take a time measurement 2.3",
            "tags": [
              "@label",
              "@test#4",
              "@user_story#3"
            ],
            "timestamp": "2008-10-12T00:00:24+0000",
            "test_runs": [
              {
                "id": "test_4_1223856024",
                "timestamp": "2008-10-13T00:00:24+0000",
                "measurements": [
                  {
                    "id": "label_1",
                    "name": "Label one",
                    "timestamp": "2008-10-13T00:00:24+0000",
                    "time": {
                      "secs": 4.0,
                      "human": "0m 04s"
                    }
                  },
                  {
                    "id": "label_2",
                    "name": "Label 2",
                    "timestamp": "2008-10-13T00:00:28+0000",
                    "time": {
                      "secs": 3.0,
                      "human": "0m 03s"
                    }
                  }
                ]
              }
            ]
          }
        ]
      }
    ]
    """

  @test#34
  Scenario: Requiring old AsciiTable has a deprecated Warning
    Given a file named "test.rb" with:
    """
    require 'qat/reporter/formatters/ascii_table.rb'
    """
    When I run `ruby test.rb`
    Then the exit status should be 0
    And the stderr should contain exactly "[WARN] DEPRECATED: QAT::Reporter::Formatters::AsciiTable will be removed in a 7.0 version, please use QAT::Reporter::Helpers::AsciiTable"