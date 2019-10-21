@feature @feature_tag
Feature: Time measure

  @label @test#1 @user_story#2 @ola
  Scenario Outline: Take a time measurement
    When the user starts a time measurement with label "label_with_limits"
    And executes a code snippet that lasts "<time_1>" seconds
    And the user starts a time measurement with label "label_without_limits"
    And the user stops the time measurement with label "label_with_limits"
    And the user starts a time measurement with label "label_with_warn_limit"
    And the user starts a time measurement with label "label_with_error_limit"
    And executes a code snippet that lasts "<time_2>" seconds
    And the user stops the time measurement with label "label_without_limits"
    And the user stops the time measurement with label "label_with_warn_limit"
    And the user stops the time measurement with label "label_with_error_limit"
    Then a time interval of "<time_1>" seconds was measured for label "label_with_limits"
    And the execution time for label "label_with_limits" is formatted as "<format_1>"
    And a time interval of "<time_2>" seconds was measured for label "label_without_limits"
    And the execution time for label "label_without_limits" is formatted as "<format_2>"
    And a time interval of "<time_2>" seconds was measured for label "label_with_warn_limit"
    And the execution time for label "label_with_warn_limit" is formatted as "<format_2>"
    And a time interval of "<time_2>" seconds was measured for label "label_with_error_limit"
    And the execution time for label "label_with_error_limit" is formatted as "<format_2>"


    Examples:
      | time_1 | time_2 | format_1 | format_2 |
      | 03     | 12     | 00m 03s  | 00m 12s  |
      | 55     | 79     | 00m 55s  | 01m 19s  |