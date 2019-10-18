@feature#12 @time_measures
Feature: Feature #12 Time Measurements should support multiples measurements
  As a user,
  In order to see my test's interactions times,
  I want to have a test interactions' time report

  @test#35
  Scenario: Take multiple time measurements
    Given I use the fixture "qat_project_json_measures_with_sla_limits"
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
                    "id": "label_with_limits",
                    "name": "Label 2",
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
                    "id": "label_without_limits",
                    "name": "No limit measure",
                    "timestamp": "2008-10-06T00:00:03+0000",
                    "time": {
                      "secs": 12.0,
                      "human": "0m 12s"
                    },
                    "sla": {
                      "warn": null,
                      "error": null,
                      "status": "Passed"
                    }
                  },
                  {
                    "id": "label_with_warn_limit",
                    "name": "Warn limit measure",
                    "timestamp": "2008-10-06T00:00:03+0000",
                    "time": {
                      "secs": 12.0,
                      "human": "0m 12s"
                    },
                    "sla": {
                      "warn": 10.0,
                      "error": null,
                      "status": "Warning"
                    }
                  },
                  {
                    "id": "label_with_error_limit",
                    "name": "Error limit measure",
                    "timestamp": "2008-10-06T00:00:03+0000",
                    "time": {
                      "secs": 12.0,
                      "human": "0m 12s"
                    },
                    "sla": {
                      "warn": null,
                      "error": 15.0,
                      "status": "Passed"
                    }
                  }
                ]
              },
              {
                "id": "test_1_2_1223337615",
                "timestamp": "2008-10-07T00:00:15+0000",
                "measurements": [
                  {
                    "id": "label_with_limits",
                    "name": "Label 2",
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
                    "id": "label_without_limits",
                    "name": "No limit measure",
                    "timestamp": "2008-10-07T00:01:10+0000",
                    "time": {
                      "secs": 79.0,
                      "human": "1m 19s"
                    },
                    "sla": {
                      "warn": null,
                      "error": null,
                      "status": "Passed"
                    }
                  },
                  {
                    "id": "label_with_warn_limit",
                    "name": "Warn limit measure",
                    "timestamp": "2008-10-07T00:01:10+0000",
                    "time": {
                      "secs": 79.0,
                      "human": "1m 19s"
                    },
                    "sla": {
                      "warn": 10.0,
                      "error": null,
                      "status": "Warning"
                    }
                  },
                  {
                    "id": "label_with_error_limit",
                    "name": "Error limit measure",
                    "timestamp": "2008-10-07T00:01:10+0000",
                    "time": {
                      "secs": 79.0,
                      "human": "1m 19s"
                    },
                    "sla": {
                      "warn": null,
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

  @test#36 @remote_logging
  Scenario: Time measure name is read from configuration and times.json is not created
    Given a code snippet that lasts "2" seconds is measured
    And a time interval of "2" seconds was measured
    And the execution time is formatted as "00m 02s"
    When the time report is sent to the remote server
    Then the time measure was recorded with name "This is a test measure"
    And a file named "public/times.json" should not exist


  @test#37
  Scenario: Take multiple time measurements with deprecated config
    Given I use the fixture "qat_project_json_measures_deprecated_without_sla_limits"
    And I set the environment variables to:
      | variable        | value                                                                       |
      | CUCUMBER_FORMAT |                                                                             |
      | CUCUMBER_OPTS   | --format QAT::Reporter::Formatter::TimeMeasurements --out public/times.json |
    When I run `rake test:run`
    Then the exit status should be 0
    And the stderr should contain "[WARN] DEPRECATED: Measurements definition without limits will be removed in a 7.0 version, please use following configuration instead:\nmeasure_id:\n  name: Test measure\n  sla_warn: 10\n  sla_error: 15"
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
                    },
                    "sla": {
                      "warn": null,
                      "error": null,
                      "status": "Passed"
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
                    },
                    "sla": {
                      "warn": null,
                      "error": null,
                      "status": "Passed"
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