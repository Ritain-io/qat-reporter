@feature#12 @time_measures
Feature: Feature #12 Time Measurements should support multiples measurements
  As a user,
  In order to see my test's interactions times,
  I want to have a test interactions' time report

  @test#30
  Scenario: Take multiple time measurements
    Given I use the fixture "qat_project_bug_12_json_measures"
    And I set the environment variables to:
      | variable        | value                                                             |
      | CUCUMBER_FORMAT |                                                                   |
      | CUCUMBER_OPTS   | --format QAT::Formatter::TimeMeasurements --out public/times.json |
    When I run `rake test:run`
    Then the exit status should be 0
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
                "id": "test_1_1_1223265600",
                "timestamp": "2008-10-06T00:00:00+0000",
                "measurements": [
                  {
                    "id": "label_1",
                    "name": "Label one",
                    "timestamp": "2008-10-06T00:00:00+0000",
                    "time": {
                      "secs": 3.000000000,
                      "human": "0m 03s"
                    }
                  },
                  {
                    "id": "label_2",
                    "name": "Label 2",
                    "timestamp": "2008-10-06T00:00:03+0000",
                    "time": {
                      "secs": 0.000000000,
                      "human": "0m 02s"
                    }
                  }
                ]
              },
              {
                "id": "test_1_2_1223352005",
                "timestamp": "2008-10-07T00:00:05+0000",
                "measurements": [
                  {
                    "id": "label_1",
                    "name": "Label one",
                    "timestamp": "2008-10-07T00:00:05+0000",
                    "time": {
                      "secs": 5.000000000,
                      "human": "0m 05s"
                    }
                  },
                  {
                    "id": "label_2",
                    "name": "Label 2",
                    "timestamp": "2008-10-07T00:00:10+0000",
                    "time": {
                      "secs": 1.000000000,
                      "human": "0m 01s"
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