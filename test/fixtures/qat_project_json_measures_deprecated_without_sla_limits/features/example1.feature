@feature @feature_tag
Feature: Time measure

  @label @test#1 @user_story#2 @ola
  Scenario Outline: Take a time measurement
    When the user starts a time measurement with configuration
    And executes a code snippet that lasts "<interval>" seconds
    And the user stops the time measurement
    Then a time interval of "<interval>" seconds was measured
    And the execution time is formatted as "00m 0<interval>s"

    Examples:
      | interval |
      | 2        |
      | 5        |