@user_story#7 @cucumber_patch
Feature: Cucumber patch feature
  As a user,
  In order to patch my cucumber.json output file,
  I want to have a new Json formatter

  @test#22
  Scenario: Generate cucumber.json file without test evidences
    Given I use the fixture "qat_project_embed_test_evidences"
    And I set the environment variables to:
      | variable        | value                                                              |
      | CUCUMBER_FORMAT |                                                                    |
      | CUCUMBER_OPTS   | --format QAT::Reporter::Formatter::Json --out public/cucumber.json |
    When I run `rake test:run`
    Then the exit status should be 0
    And a file named "public/cucumber.json" should exist
    And a file named "public/cucumber.json" should not contain:
    """
      "embeddings": [
    """          