Feature: Time measure 2

  @label @test#2 @user_story#3 @outline
  Scenario Outline: Take a time measurement 2.1
    When the user starts a time measurement with configuration
    And executes a code snippet that lasts "<interval>" seconds
    And the user stops the time measurement
    Then a time interval of "<interval>" seconds was measured
    And the execution time is formatted as "00m 0<interval>s"

    Examples:
      | interval |
      | 7        |
      | 4        |

  @label @test#3 @user_story#3
  Scenario: Take a time measurement 2.2
    When the user starts a time measurement with configuration
    And executes a code snippet that lasts "2" seconds
    And the user stops the time measurement
    Then a time interval of "2" seconds was measured
    And the execution time is formatted as "00m 02s"

  @label @test#4 @user_story#3
  Scenario: Take a time measurement 2.3
    When the user starts a time measurement with label "label_1"
    And executes a code snippet that lasts "4" seconds
    And the user stops the time measurement
    Then a time interval of "4" seconds was measured
    And the execution time is formatted as "00m 04s"
    When the user starts a time measurement with label "label_2"
    And executes a code snippet that lasts "3" seconds
    And the user stops the time measurement
    Then a time interval of "3" seconds was measured
    And the execution time is formatted as "00m 03s"