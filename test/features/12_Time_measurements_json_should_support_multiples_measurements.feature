@feature#12 @time_measures
Feature: Feature #12 Time Measurements should support multiples measurements
  As a user,
  In order to see my test's interactions times,
  I want to have a test interactions' time report

  @test#30
  Scenario: Take multiple time measurements
    Given I use the fixture "qat_project_bug_12_json_measures"
    And I set the environment variables to:
      | variable        | value                                                                       |
      | CUCUMBER_FORMAT |                                                                             |
      | CUCUMBER_OPTS   | --format QAT::Reporter::Formatter::TimeMeasurements --out public/times.json |
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
                "id": "test_1_1_1223251200",
                "timestamp": "2008-10-06T00:00:00+0000",
                "measurements": [
                  {
                    "id": "label_1",
                    "name": "Label one",
                    "timestamp": "2008-10-06T00:00:00+0000",
                    "time": {
                      "secs": 3.0,
                      "human": "0m 03s"
                    },
                    "sla": {
                      "warn": 10.0,
                      "error": 15.0,
                      "status": "Passed"
                    }
                  },
                  {
                    "id": "label_2",
                    "name": "Label 2",
                    "timestamp": "2008-10-06T00:00:03+0000",
                    "time": {
                      "secs": 12.0,
                      "human": "0m 12s"
                    },
                    "sla": {
                      "warn": 10.0,
                      "error": 15.0,
                      "status": "Warning"
                    }
                  }
                ]
              },
              {
                "id": "test_1_2_1223337615",
                "timestamp": "2008-10-07T00:00:15+0000",
                "measurements": [
                  {
                    "id": "label_1",
                    "name": "Label one",
                    "timestamp": "2008-10-07T00:00:15+0000",
                    "time": {
                      "secs": 55.0,
                      "human": "0m 55s"
                    },
                    "sla": {
                      "warn": 10.0,
                      "error": 15.0,
                      "status": "Error"
                    }
                  },
                  {
                    "id": "label_2",
                    "name": "Label 2",
                    "timestamp": "2008-10-07T00:01:10+0000",
                    "time": {
                      "secs": 79.0,
                      "human": "1m 19s"
                    },
                    "sla": {
                      "warn": 10.0,
                      "error": 15.0,
                      "status": "Error"
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