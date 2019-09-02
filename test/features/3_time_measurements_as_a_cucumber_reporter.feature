@feature#3 @user_story#3 @time_measures
Feature: Feature #3 Time Measurements Report
  As a user,
  In order to see my test's interactions times,
  I want to have a test interactions' time report

  @test#29
  Scenario: Take a time measurement
    Given I copy the directory named "../../resources/qat_project_time_measures" to "project"
    And I cd to "project"
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
      {
        "feature": "Time measure",
        "tags": \[
          "@feature",
          "@feature_tag"
        \],
        "timestamp": "\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}[\+|\-]\d{4}",
        "scenarios": \[
          {
            "name": "Take a time measurement",
            "tags": \[
              "@label",
              "@test#1",
              "@user_story#2",
              "@ola"
            \],
            "timestamp": "\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}[\+|\-]\d{4}",
            "test_run": \[
              {
                "id": "test_\d+_\d+_\d+",
                "timestamp": "\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}[\+|\-]\d{4}",
                "measurements": \[
                  {
                    "id": "test_measure",
                    "name": "This is a test measure",
                    "timestamp": "\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}[\+|\-]\d{4}",
                    "time": {
                      "secs": \d+.\d+,
                      "human": "\d+m\d.\d{3}s"
                    }
                  }
                \]
              },
              {
                "id": "test_\d+_\d+_\d+",
                "timestamp": "\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}[\+|\-]\d{4}",
                "measurements": \[
                  {
                    "id": "test_measure",
                    "name": "This is a test measure",
                    "timestamp": "\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}[\+|\-]\d{4}",
                    "time": {
                      "secs": \d+.\d+,
                      "human": "\d+m\d.\d{3}s"
                    }
                  }
                \]
              }
            \]
          },
          {
            "name": "Take a time measurement 1",
            "tags": \[
              "@no_start_time"
            \],
            "timestamp": "\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}[\+|\-]\d{4}",
            "test_run": \[
              {
                "id": "test_\d+_\d+",
                "timestamp": "\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}[\+|\-]\d{4}",
                "measurements": \[
                  {
                    "id": "test_measure",
                    "name": "This is a test measure",
                    "timestamp": "\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}[\+|\-]\d{4}",
                    "time": {
                      "secs": \d+.\d+,
                      "human": "\d+m\d.\d{3}s"
                    }
                  }
                \]
              }
            \]
          },
          {
            "name": "Take a time measurement 2",
            "tags": \[
              "@no_start_time"
            \],
            "timestamp": "\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}[\+|\-]\d{4}",
            "test_run": \[
              {
                "id": "test_\d+_\d+",
                "timestamp": "\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}[\+|\-]\d{4}",
                "measurements": \[
                  {
                    "id": "test_measure",
                    "name": "This is a test measure",
                    "timestamp": "\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}[\+|\-]\d{4}",
                    "time": {
                      "secs": \d+.\d+,
                      "human": "\d+m\d.\d{3}s"
                    }
                  }
                \]
              }
            \]
          }
        \]
      },
      {
        "feature": "Time measure 2",
        "tags": \[

        \],
        "timestamp": "\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}[\+|\-]\d{4}",
        "scenarios": \[
          {
            "name": "Take a time measurement 2.1",
            "tags": \[
              "@label",
              "@test#2",
              "@user_story#3",
              "@outline"
            \],
            "timestamp": "\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}[\+|\-]\d{4}",
            "test_run": \[
              {
                "id": "test_\d+_\d+_\d+",
                "timestamp": "\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}[\+|\-]\d{4}",
                "measurements": \[
                  {
                    "id": "test_measure",
                    "name": "This is a test measure",
                    "timestamp": "\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}[\+|\-]\d{4}",
                    "time": {
                      "secs": \d+.\d+,
                      "human": "\d+m\d.\d{3}s"
                    }
                  }
                \]
              },
              {
                "id": "test_\d+_\d+_\d+",
                "timestamp": "\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}[\+|\-]\d{4}",
                "measurements": \[
                  {
                    "id": "test_measure",
                    "name": "This is a test measure",
                    "timestamp": "\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}[\+|\-]\d{4}",
                    "time": {
                      "secs": \d+.\d+,
                      "human": "\d+m\d.\d{3}s"
                    }
                  }
                \]
              }
            \]
          },
          {
            "name": "Take a time measurement 2.2",
            "tags": \[
              "@label",
              "@test#3",
              "@user_story#3",
              "@outline"
            \],
            "timestamp": "\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}[\+|\-]\d{4}",
            "test_run": \[
              {
                "id": "test_\d+_\d+_\d+",
                "timestamp": "\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}[\+|\-]\d{4}",
                "measurements": \[
                  {
                    "id": "test_measure",
                    "name": "This is a test measure",
                    "timestamp": "\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}[\+|\-]\d{4}",
                    "time": {
                      "secs": \d+.\d+,
                      "human": "\d+m\d.\d{3}s"
                    }
                  }
                \]
              },
              {
                "id": "test_\d+_\d+_\d+",
                "timestamp": "\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}[\+|\-]\d{4}",
                "measurements": \[
                  {
                    "id": "test_measure",
                    "name": "This is a test measure",
                    "timestamp": "\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}[\+|\-]\d{4}",
                    "time": {
                      "secs": \d+.\d+,
                      "human": "\d+m\d.\d{3}s"
                    }
                  }
                \]
              }
            \]
          }
        \]
      }
    \]
    """

    @test#29
    Scenario: Take a time measurement on project with no requirement ids
      Given I copy the directory named "../../resources/qat_project_no_requirement_ids" to "project"
      And I cd to "project"
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