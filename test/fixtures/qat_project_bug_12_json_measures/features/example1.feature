@feature @feature_tag
Feature: Time measure

  @label @test#1 @user_story#2 @ola
  Scenario Outline: Take a time measurement
    When the user starts a time measurement with label "label_1"
    And executes a code snippet that lasts "<time_1>" seconds
    And the user starts a time measurement with label "label_2"
    And the user stops the time measurement with label "label_1"
    And executes a code snippet that lasts "<time_2>" seconds
    And the user stops the time measurement with label "label_2"
    Then a time interval of "<time_1>" seconds was measured for label "label_1"
    And the execution time for label "label_1" is formatted as "<format_1>"
    And a time interval of "<time_2>" seconds was measured for label "label_2"
    And the execution time for label "label_2" is formatted as "<format_2>"

    Examples:
      | time_1 | time_2 | format_1 | format_2 |
      | 03     | 12     | 00m 03s  | 00m 12s  |
      | 55     | 79     | 00m 55s  | 01m 19s  |

  @no_label
  Scenario: Failed time measurement without configuration
    Given the user starts a time measurement without configuration
    And executes a code snippet that lasts "2" seconds
    And the user starts another measure
    And the user stops the time measurement
    And the user stops another measurement
    When the time report is generated
    Then an "QAT::Reporter::Times::NoLabelInConfig" exception is raised


  @no_start_time
  Scenario: Failed time measurement without start time
    When executes a code snippet that lasts "2" seconds
    And the user stops the time measurement