Feature: Time measure 2

  @label @test#2 @user_story#3 @outline
  Scenario Outline: Take a time measurement 2.1
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

  @label @test#3 @user_story#3 @outline
  Scenario Outline: Take a time measurement 2.2
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