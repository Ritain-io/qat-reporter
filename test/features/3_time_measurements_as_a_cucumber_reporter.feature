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
        "scenario": "Take a time measurement",
        "status": "passed",
        "test_id": "test_\d+",
        "test_run_id": "test_\d+_\d+",
        "measurements": \[
          {
            "id": "test_measure",
            "name": "This is a test measure",
            "time": {
              "duration": \d+.\d+,
              "human_duration": "\d+m\d.\d{3}s"
            }
          }
        \]
      },
      {
        "feature": "Time measure",
        "scenario": "Take a time measurement 2",
        "status": "passed",
        "test_id": "test_\d+",
        "test_run_id": "test_\d+_\d+",
        "measurements": \[
          {
            "id": "test_measure",
            "name": "This is a test measure",
            "time": {
              "duration": \d+.\d+,
              "human_duration": "\d+m\d.\d{3}s"
            }
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