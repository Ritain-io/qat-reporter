@user_story#999999099
Feature: Tagged feature

  Background: a background
    Given some pre-settings

  @test#0
  Scenario: Some test
    Given I have a condition
    When I do an action action1
    Then I have a result passed

  @test#1
  Scenario Outline: Some test scenario
    Given I have a condition
    When I do an action <action>
    Then I have a result <result>

    Examples: example table of success test combinations
      | action  | result |
      | action1 | passed |
      | action2 | passed |

    Examples: example table of failure test combinations
      | action  | result |
      | action3 | failed |
      | action4 | failed |

  @test#2
  Scenario Outline: Some test
    Given I have a condition
    When I do an action <action>
    Then I have a result <result>

    Examples: example table of success test combinations
      | action  | result |
      | action1 | passed |
      | action2 | passed |

    Examples: example table of failure test combinations
      | action  | result |
      | action3 | failed |
      | action4 | failed |

  @test#3
  Scenario Outline: Some test
    Given I have a condition
    When I do an action <action>
    Then I have a result <result>

    Examples: example table of success test combinations
      | action  | result |
      | action1 | passed |
      | action2 | passed |

  @test#4
  Scenario: Some test
    Given I have a condition
    When I do an action action1
    Then I have a result passed