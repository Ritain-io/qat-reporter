Feature: Time measure

  @label
  Scenario: Take a time measurement
    When the user starts a time measurement with configuration
    And executes a code snippet that lasts "2" seconds
    And the user stops the time measurement
    Then a time interval of "2" seconds was measured
    And the execution time is formatted as "00m 02s"

  @no_label
  Scenario: Take a time measurement
    When the user starts a time measurement without configuration
    And executes a code snippet that lasts "2" seconds
    And the user stops the time measurement
    Then a time interval of "2" seconds was measured
    And the execution time is formatted as "00m 02s"

  @no_start_time
  Scenario: Take a time measurement 2
    And executes a code snippet that lasts "2" seconds
    And the user stops the time measurement