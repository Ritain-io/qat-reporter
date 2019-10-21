@epic#601 @feature#602 @user_story#603
Feature: Feature 30 Status From Test Executions with SLA measurements
  In order to have traceability between test status with SLA measurements
  As a tester
  I want to have a request providing test requirement coverage

  @test#38
  Scenario: Run with requirement coverage formatter in project with measurement labels
    Given I use the fixture "qat_project_test_status_with_measurements"
    And I set the environment variables to:
      | variable        | value                                                                                 |
      | CUCUMBER_FORMAT |                                                                                       |
      | CUCUMBER_OPTS   | --format QAT::Reporter::Formatter::ReqCoverage --out public/requirement_coverage.json |
    When I run `rake test:run`
    Then the exit status should be 0
    And a file named "public/requirement_coverage.json" should exist
    And a file named "public/requirement_coverage.json" should match:
    """
    {
      "results": \[
        {
          "test": 1.1,
          "requirement": \[
            "1"
          \],
          "status": "passed",
          "duration": \d+.\d+,
          "human_duration": "\d+m\d.\d{3}s"
        },
        {
          "test": 1.2,
          "requirement": \[
            "1"
          \],
          "status": "passed with SLA Warning",
          "duration": \d+.\d+,
          "human_duration": "\d+m\d.\d{3}s"
        },
        {
          "test": 1.3,
          "requirement": \[
            "1"
          \],
          "status": "passed with SLA Error",
          "duration": \d+.\d+,
          "human_duration": "\d+m\d.\d{3}s"
        },
        {
          "test": 2.1,
          "requirement": \[
            "1"
          \],
          "status": "passed",
          "duration": \d+.\d+,
          "human_duration": "\d+m\d.\d{3}s"
        },
        {
          "test": 2.2,
          "requirement": \[
            "1"
          \],
          "status": "passed",
          "duration": \d+.\d+,
          "human_duration": "\d+m\d.\d{3}s"
        },
        {
          "test": 2.3,
          "requirement": \[
            "1"
          \],
          "status": "passed",
          "duration": \d+.\d+,
          "human_duration": "\d+m\d.\d{3}s"
        },
        {
          "test": 3.1,
          "requirement": \[
            "1"
          \],
          "status": "passed",
          "duration": \d+.\d+,
          "human_duration": "\d+m\d.\d{3}s"
        },
        {
          "test": 3.2,
          "requirement": \[
            "1"
          \],
          "status": "passed with SLA Warning",
          "duration": \d+.\d+,
          "human_duration": "\d+m\d.\d{3}s"
        },
        {
          "test": 3.3,
          "requirement": \[
            "1"
          \],
          "status": "passed with SLA Warning",
          "duration": \d+.\d+,
          "human_duration": "\d+m\d.\d{3}s"
        },
        {
          "test": 4.1,
          "requirement": \[
            "1"
          \],
          "status": "passed",
          "duration": \d+.\d+,
          "human_duration": "\d+m\d.\d{3}s"
        },
        {
          "test": 4.2,
          "requirement": \[
            "1"
          \],
          "status": "passed",
          "duration": \d+.\d+,
          "human_duration": "\d+m\d.\d{3}s"
        },
        {
          "test": 4.3,
          "requirement": \[
            "1"
          \],
          "status": "passed with SLA Error",
          "duration": \d+.\d+,
          "human_duration": "\d+m\d.\d{3}s"
        },
        {
          "test": 5.1,
          "requirement": \[
            "1"
          \],
          "status": "passed",
          "duration": \d+.\d+,
          "human_duration": "\d+m\d.\d{3}s"
        },
        {
          "test": 5.2,
          "requirement": \[
            "1"
          \],
          "status": "passed",
          "duration": \d+.\d+,
          "human_duration": "\d+m\d.\d{3}s"
        },
        {
          "test": 5.3,
          "requirement": \[
            "1"
          \],
          "status": "passed",
          "duration": \d+.\d+,
          "human_duration": "\d+m\d.\d{3}s"
        }
      \]
    }
    """