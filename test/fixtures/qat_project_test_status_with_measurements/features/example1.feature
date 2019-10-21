@feature @feature_tag
Feature: Time measure

  @label @test#1 @user_story#1 @ola
  Scenario Outline: Take a time measurement with a label with limits
    Given the user starts a time measurement with label "label_with_limits"
    When executes a code snippet that lasts "<secs>" seconds
    Then the user stops the time measurement with label "label_with_limits"
    Examples:
      | secs |
      | 05   |
      | 11   |
      | 16   |

  @label @test#2 @user_story#1 @ola
  Scenario Outline: Take a time measurement with a label without limits
    Given the user starts a time measurement with label "label_without_limits"
    When executes a code snippet that lasts "<secs>" seconds
    Then the user stops the time measurement with label "label_without_limits"
    Examples:
      | secs |
      | 05   |
      | 11   |
      | 16   |

  @label @test#3 @user_story#1 @ola
  Scenario Outline: Take a time measurement with a label with warn limits
    Given the user starts a time measurement with label "label_with_warn_limit"
    When executes a code snippet that lasts "<secs>" seconds
    Then the user stops the time measurement with label "label_with_warn_limit"
    Examples:
      | secs |
      | 05   |
      | 11   |
      | 16   |

  @label @test#4 @user_story#1 @ola
  Scenario Outline: Take a time measurement with a label with error limits
    Given the user starts a time measurement with label "label_with_error_limit"
    When executes a code snippet that lasts "<secs>" seconds
    Then the user stops the time measurement with label "label_with_error_limit"
    Examples:
      | secs |
      | 05   |
      | 11   |
      | 16   |

  @label @test#5 @user_story#1 @ola
  Scenario Outline: Take a time measurement without label
    When executes a code snippet that lasts "<secs>" seconds
    Examples:
      | secs |
      | 05   |
      | 11   |
      | 16   |