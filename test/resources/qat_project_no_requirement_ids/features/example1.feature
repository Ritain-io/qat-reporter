Feature: Tagged feature

  Background: a background
    Given some pre-settings


  @test#1
  Scenario: scenario 1
    Given some conditions
    When some actions are made
    Then a result is achieved

  @test#2
  Scenario: scenario 2
    Given some conditions
    When some actions are made
    Then a result is achieved

  @test#3
  Scenario Outline: scenario 3
    Given some conditions
    When some "<action>" action made
    Then "<result>" result is achieved

    Examples:
      | action | result |
      | good   | good   |
      | good   | good   |
