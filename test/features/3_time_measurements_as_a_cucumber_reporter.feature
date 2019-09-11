@feature#3 @user_story#3 @time_measures
Feature: Feature #3 Time Measurements Report
  As a user,
  In order to see my test's interactions times,
  I want to have a test interactions' time report

  @test#29
  Scenario: Take a time measurement
    Given I use the fixture "qat_project_time_measures"
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
                "id": "test_1_1_1223164800",
                "timestamp": "2008-10-06T00:00:00+0000",
                "measurements": [
                  {
                    "id": "test_measure",
                    "name": "This is a test measure",
                    "timestamp": "2008-10-06T00:00:00+0000",
                    "time": {
                      "secs": 2.000000000,
                      "human": "0m 02s"
                    }
                  }
                ]
              },
              {
                "id": "test_1_2_1223251202",
                "timestamp": "2008-10-07T00:00:02+0000",
                "measurements": [
                  {
                    "id": "test_measure",
                    "name": "This is a test measure",
                    "timestamp": "2008-10-07T00:00:02+0000",
                    "time": {
                      "secs": 5.000000000,
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
                "id": "test_2_1_1223510411",
                "timestamp": "2008-10-10T00:00:11+0000",
                "measurements": [
                  {
                    "id": "test_measure",
                    "name": "This is a test measure",
                    "timestamp": "2008-10-10T00:00:11+0000",
                    "time": {
                      "secs": 7.000000000,
                      "human": "0m 07s"
                    }
                  }
                ]
              },
              {
                "id": "test_2_2_1223596818",
                "timestamp": "2008-10-11T00:00:18+0000",
                "measurements": [
                  {
                    "id": "test_measure",
                    "name": "This is a test measure",
                    "timestamp": "2008-10-11T00:00:18+0000",
                    "time": {
                      "secs": 4.000000000,
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
                "id": "test_3_1223683222",
                "timestamp": "2008-10-12T00:00:22+0000",
                "measurements": [
                  {
                    "id": "test_measure",
                    "name": "This is a test measure",
                    "timestamp": "2008-10-12T00:00:22+0000",
                    "time": {
                      "secs": 2.000000000,
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
                "id": "test_4_1223769624",
                "timestamp": "2008-10-13T00:00:24+0000",
                "measurements": [
                  {
                    "id": "label_1",
                    "name": "Label one",
                    "timestamp": "2008-10-13T00:00:24+0000",
                    "time": {
                      "secs": 2.000000000,
                      "human": "0m 02s"
                    }
                  },
                  {
                    "id": "label_2",
                    "name": "Label 2",
                    "timestamp": "2008-10-13T00:00:28+0000",
                    "time": {
                      "secs": 3.000000000,
                      "human": "0m 3s"
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

    @test#29
    Scenario: Take a time measurement on project with no requirement ids
      Given I use the fixture "qat_project_no_requirement_ids"
      And I set the environment variables to:
        | variable        | value                                                             |
        | CUCUMBER_FORMAT |                                                                   |
        | CUCUMBER_OPTS   | --format QAT::Formatter::TimeMeasurements --out public/times.json |
      When I run `rake test:run`
      Then the exit status should be 0
      And a file named "public/times.json" should exist
      And a file named "public/times.json" should match:
      """
      \[

      \]
      """