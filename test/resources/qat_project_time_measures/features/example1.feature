@feature @feature_tag
Feature: Time measure

  @label @test#1 @user_story#2 @ola
  Scenario Outline: Take a time measurement
    When the user starts a time measurement with configuration
    And executes a code snippet that lasts "2" seconds
    And the user stops the time measurement
    Then a time interval of "2" seconds was measured
    And the execution time is formatted as "00m 02s"
    Then "<result>" result is achieved

    Examples:
      | action | result |
      | good   | good   |
      | good   | good   |

  @no_start_time
  Scenario: Failed time measurement without configuration
    Given the user starts a time measurement without configuration
    And executes a code snippet that lasts "2" seconds
    And the user stops the time measurement
    When the time report is generated
    Then an "QAT::Reporter::Times::NoLabelInConfig" exception is raised


  @no_start_time
  Scenario: Failed time measurement without start time
    When executes a code snippet that lasts "2" seconds
    And the user stops a "blocking" time measurement
    Then an "QAT::Reporter::Times::NoStartTimeError" exception is raised