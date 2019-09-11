@epic#601 @feature#602 @user_story#603 @announce
Feature: Feature #602: Requirement Coverage Report:
  User Story #603: Collect relationship test status and requirements from test execution
  In order to have traceability between requirements and test status
  As a tester
  I want to have a request providing test requirement coverage

  Changed by:

  User Story #1328: Test scenario with multiple user story coverage
  In order to report coverage of multiple user stories
  as a tester,
  I want to associate multiple user stories in one test scenario

  @test#1
  Scenario: Run requirement coverage formatter with success
    Given I use the fixture "qat_project_no_requirement_ids"
    And I set the environment variables to:
      | variable        | value                                                                       |
      | CUCUMBER_FORMAT |                                                                             |
      | CUCUMBER_OPTS   | --format QAT::Formatter::ReqCoverage --out public/requirement_coverage.json |
    When I run `rake test:run`
    Then the exit status should be 0


  @test#2
  Scenario: Run with requirement coverage formatter in project with untagged tests
    Given I use the fixture "qat_project_no_requirement_ids"
    And I set the environment variables to:
      | variable        | value                                                                       |
      | CUCUMBER_FORMAT |                                                                             |
      | CUCUMBER_OPTS   | --format QAT::Formatter::ReqCoverage --out public/requirement_coverage.json |
    When I run `rake test:run`
    Then the exit status should be 0
    And a file named "public/requirement_coverage.json" should exist
    And a file named "public/requirement_coverage.json" should match:
    """
    {
      "results": \[
        {
          "test": 1,
          "requirement": \[

          \],
          "status": "passed",
          "duration": \d+.\d+,
          "human_duration": "\d+m\d.\d{3}s"
        },
        {
          "test": 2,
          "requirement": \[

          \],
          "status": "passed",
          "duration": \d+.\d+,
          "human_duration": "\d+m\d.\d{3}s"
        },
        {
          "test": 3.1,
          "requirement": \[

          \],
          "status": "passed",
          "duration": \d+.\d+,
          "human_duration": "\d+m\d.\d{3}s"
        },
        {
          "test": 3.2,
          "requirement": \[

          \],
          "status": "passed",
          "duration": \d+.\d+,
          "human_duration": "\d+m\d.\d{3}s"
        }
      \]
    }
    """


  @test#3 @user_story#1328
  Scenario: Run requirement coverage formatter in project with tests passing
    Given I use the fixture "qat_project_requirement_ids"
    And I set the environment variables to:
      | variable        | value                                                                       |
      | CUCUMBER_FORMAT |                                                                             |
      | CUCUMBER_OPTS   | --format QAT::Formatter::ReqCoverage --out public/requirement_coverage.json |
    When I run `rake test:run`
    Then the exit status should be 0
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


  @test#4 @user_story#1328
  Scenario: Run requirement coverage formatter in project with mixed test results
    Given I use the fixture "qat_project_mixed_tags_mixed_results"
    And I set the environment variables to:
      | variable        | value                                                                       |
      | CUCUMBER_FORMAT |                                                                             |
      | CUCUMBER_OPTS   | --format QAT::Formatter::ReqCoverage --out public/requirement_coverage.json |
    When I run `rake test:run`
    Then the exit status should be 1
    And a file named "public/requirement_coverage.json" should exist
    And a file named "public/requirement_coverage.json" should match:
    """
    {
      "results": \[
        {
          "test": 1,
          "requirement": \[
            "99996032"
          \],
          "status": "passed",
          "duration": \d+.\d+,
          "human_duration": "\d+m\d.\d{3}s"
        },
        {
          "test": 2,
          "requirement": \[
            "99996032",
            "999960323"
          \],
          "status": "failed",
          "duration": \d+.\d+,
          "human_duration": "\d+m\d.\d{3}s"
        },
        {
          "test": 3.1,
          "requirement": \[
            "99996032",
            "999960322"
          \],
          "status": "failed",
          "duration": \d+.\d+,
          "human_duration": "\d+m\d.\d{3}s"
        },
        {
          "test": 3.2,
          "requirement": \[
            "99996032",
            "999960322"
          \],
          "status": "failed",
          "duration": \d+.\d+,
          "human_duration": "\d+m\d.\d{3}s"
        },
        {
          "test": 4,
          "requirement": \[
            "99996032"
          \],
          "status": "failed",
          "duration": \d+.\d+,
          "human_duration": "\d+m\d.\d{3}s"
        }
      \]
    }
    """


  @test#5 @user_story#1328
  Scenario: Run requirement coverage formatter in project with background pending
    Given I use the fixture "qat_project_background_pending"
    And I set the environment variables to:
      | variable        | value                                                                       |
      | CUCUMBER_FORMAT |                                                                             |
      | CUCUMBER_OPTS   | --format QAT::Formatter::ReqCoverage --out public/requirement_coverage.json |
    When I run `rake test:run`
    Then the exit status should be 0
    And a file named "public/requirement_coverage.json" should exist
    And a file named "public/requirement_coverage.json" should match:
    """
    {
      "results": \[
        {
          "test": 1,
          "requirement": \[
            "99996031"
          \],
          "status": "not_runned",
          "duration": \d+.\d+,
          "human_duration": "\d+m\d.\d{3}s"
        },
        {
          "test": 2,
          "requirement": \[
            "99996031"
          \],
          "status": "not_runned",
          "duration": \d+.\d+,
          "human_duration": "\d+m\d.\d{3}s"
        },
        {
          "test": 3.1,
          "requirement": \[
            "99996031"
          \],
          "status": "not_runned",
          "duration": \d+.\d+,
          "human_duration": "\d+m\d.\d{3}s"
        },
        {
          "test": 3.2,
          "requirement": \[
            "99996031"
          \],
          "status": "not_runned",
          "duration": \d+.\d+,
          "human_duration": "\d+m\d.\d{3}s"
        }
      \]
    }
    """


  @test#6 @user_story#1328
  Scenario: Run dummy QAT project with reqCoverage formatter - check if test results are published
    Given I use the fixture "qat_project_mixed_tags_mixed_results"
    And I set the environment variables to:
      | variable        | value                                                                       |
      | CUCUMBER_FORMAT |                                                                             |
      | CUCUMBER_OPTS   | --format QAT::Formatter::ReqCoverage --out public/requirement_coverage.json |
    When I run `rake test:run`
    Then the exit status should be 1
    And the test results were published:
      | test | requirement               | status |
      | 1    | ["99996032"]              | passed |
      | 2    | ["99996032", "999960323"] | failed |
      | 3.1  | ["99996032", "999960322"] | failed |
      | 3.2  | ["99996032", "999960322"] | failed |
      | 4    | ["99996032"]              | failed |
    And the test results have the duration information


  @bug#636 @test#7 @user_story#1328
  Scenario: Run requirement coverage formatter in project with multiple test tables
    Given I use the fixture "qat_project_multiple_example_tables"
    And I set the environment variables to:
      | variable        | value                                                                       |
      | CUCUMBER_FORMAT |                                                                             |
      | CUCUMBER_OPTS   | --format QAT::Formatter::ReqCoverage --out public/requirement_coverage.json |
    When I run `rake test:run`
    Then the exit status should be 1
    And a file named "public/requirement_coverage.json" should exist
    And a file named "public/requirement_coverage.json" should match:
    """
    {
      "results": \[
        {
          "test": 0,
          "requirement": \[
            "999999099"
          \],
          "status": "passed",
          "duration": \d+.\d+,
          "human_duration": "\d+m\d.\d{3}s"
        },
        {
          "test": 1.1,
          "requirement": \[
            "999999099"
          \],
          "status": "passed",
          "duration": \d+.\d+,
          "human_duration": "\d+m\d.\d{3}s"
        },
        {
          "test": 1.2,
          "requirement": \[
            "999999099"
          \],
          "status": "passed",
          "duration": \d+.\d+,
          "human_duration": "\d+m\d.\d{3}s"
        },
        {
          "test": 1.3,
          "requirement": \[
            "999999099"
          \],
          "status": "failed",
          "duration": \d+.\d+,
          "human_duration": "\d+m\d.\d{3}s"
        },
        {
          "test": 1.4,
          "requirement": \[
            "999999099"
          \],
          "status": "failed",
          "duration": \d+.\d+,
          "human_duration": "\d+m\d.\d{3}s"
        },
        {
          "test": 2.1,
          "requirement": \[
            "999999099"
          \],
          "status": "passed",
          "duration": \d+.\d+,
          "human_duration": "\d+m\d.\d{3}s"
        },
        {
          "test": 2.2,
          "requirement": \[
            "999999099"
          \],
          "status": "passed",
          "duration": \d+.\d+,
          "human_duration": "\d+m\d.\d{3}s"
        },
        {
          "test": 2.3,
          "requirement": \[
            "999999099"
          \],
          "status": "failed",
          "duration": \d+.\d+,
          "human_duration": "\d+m\d.\d{3}s"
        },
        {
          "test": 2.4,
          "requirement": \[
            "999999099"
          \],
          "status": "failed",
          "duration": \d+.\d+,
          "human_duration": "\d+m\d.\d{3}s"
        },
        {
          "test": 3.1,
          "requirement": \[
            "999999099"
          \],
          "status": "passed",
          "duration": \d+.\d+,
          "human_duration": "\d+m\d.\d{3}s"
        },
        {
          "test": 3.2,
          "requirement": \[
            "999999099"
          \],
          "status": "passed",
          "duration": \d+.\d+,
          "human_duration": "\d+m\d.\d{3}s"
        },
        {
          "test": 4,
          "requirement": \[
            "999999099"
          \],
          "status": "passed",
          "duration": \d+.\d+,
          "human_duration": "\d+m\d.\d{3}s"
        }
      ]
    }
    """


  @bug#1222 @test#8 @user_story#1328
  Scenario: Bug#1222 - Feature requirement id is lost if other tags exist after user story id tag.
    Given I use the fixture "qat_project_bug_1222_feature"
    And I set the environment variables to:
      | variable        | value                                                                       |
      | CUCUMBER_FORMAT |                                                                             |
      | CUCUMBER_OPTS   | --format QAT::Formatter::ReqCoverage --out public/requirement_coverage.json |
    When I run `rake test:run`
    Then the exit status should be 0
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


  @bug#1222 @test#9 @user_story#1328
  Scenario: Bug#1222 - Feature requirement id is lost if other tags exist after user story id tag.
    Given I use the fixture "qat_project_bug_1222_scenario"
    And I set the environment variables to:
      | variable        | value                                                                       |
      | CUCUMBER_FORMAT |                                                                             |
      | CUCUMBER_OPTS   | --format QAT::Formatter::ReqCoverage --out public/requirement_coverage.json |
    When I run `rake test:run`
    Then the exit status should be 0
    And a file named "public/requirement_coverage.json" should exist
    And a file named "public/requirement_coverage.json" should match:
    """
    {
      "results": \[
        {
          "test": 1,
          "requirement": \[
            "99996033",
            "999960331"
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