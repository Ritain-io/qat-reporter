@user_story#21 @time_measures
Feature: User Story #21 - Test's interactions time report

  As a user,
  In order to see my test's interactions times,
  I want to have a test interactions' time report


  @test#10
  Scenario: Take a time measurement using start and stop
    When the user starts a time measurement with configuration
    And executes a code snippet that lasts "2" seconds
    And the user stops the time measurement
    Then a time interval of "2" seconds was measured
    And the execution time is formatted as "00m 02s"


  @test#11
  Scenario: Take a time measurement using just stop with non-blocking measure
    When executes a code snippet that lasts "2" seconds
    And the user stops the time measurement
    Then no exception is raised


  @test#18
  Scenario: Take a time measurement using just stop with blocking measure
    When executes a code snippet that lasts "2" seconds
    And the user stops a blocking time measurement
    Then an "QAT::Reporter::Times::NoStartTimeError" exception is raised


  @test#12
  Scenario: Take a time measurement using just start
    When the user starts a time measurement with configuration
    And executes a code snippet that lasts "2" seconds
    Then a time interval of "2" seconds was measured
    And the execution time is formatted as "00m 02s"


  @test#13
  Scenario: Take a time measurement using measure
    When a code snippet that lasts "2" seconds is measured
    Then a time interval of "2" seconds was measured
    And the execution time is formatted as "00m 02s"


  @test#14 @remote_logging
  Scenario: Time measure name is read from configuration
    Given a code snippet that lasts "2" seconds is measured
    And a time interval of "2" seconds was measured
    And the execution time is formatted as "00m 02s"
    When the time report is sent to the remote server
    Then the time measure was recorded with name "This is a test measure"


  @test#15
  Scenario: Take a time measure with given start and stop times
    Given the user sets the start time as "2019-02-02 13:45:23"
    And the user sets the stop time as "2019-02-02 13:48:43"
    Then a time interval of "200" seconds was measured
    And the execution time is formatted as "03m 20s"


  @test#16
  Scenario: A time report is printed on stdout
    Given I use the fixture "qat_project_time_measures"
    And I set the environment variables to:
      | variable        | value     |
      | CUCUMBER_FORMAT |           |
      | CUCUMBER_OPTS   | -t @label |
    When I run `rake test:run`
    Then the exit status should be 0
    And the output should match /\|\sInteraction\s*\|\sStart\s*|\sEnd\s*\|\sDuration\|/
    And the output should match /\|\sThis is a test measure\s*|\s*\d{4}-\d{2}-\d{2}\s\d{2}:\d{2}:\d{2}+\d{4}\s*\|\s*\d{4}-\d{2}-\d{2}\s\d{2}:\d{2}:\d{2}+\d{4}\s*\|\s\d{2}m\s\d{2}s\s*\|/


  @test#17 @remote_logging
  Scenario: Time measure with extra information
    Given the measure extra information is defined as:
      | OS Name | OS Version | Browser Name | Browser Version |
      | Linux   | CentOS 7   | Firefox      | 67.0.0          |
    And a code snippet that lasts "2" seconds is measured
    And a time interval of "2" seconds was measured
    And the execution time is formatted as "00m 02s"
    When the time report is sent to the remote server
    Then the time measure was recorded with information:
      | OS Name | OS Version | Browser Name | Browser Version |
      | Linux   | CentOS 7   | Firefox      | 67.0.0          |


  @test#19 @remote_logging
  Scenario: Time measure with extra empty/nil information
    Given the measure extra information is defined as:
      | OS Name | Browser Name |
      | Linux   | Firefox      |
    And a code snippet that lasts "2" seconds is measured
    And a time interval of "2" seconds was measured
    And the execution time is formatted as "00m 02s"
    When the time report is sent to the remote server
    Then the time measure was recorded with information:
      | OS Name | Browser Name |
      | Linux   | Firefox      |
    And the key "version" for "os" does not exist
    And the key "version" for "browser" does not exist


  @test#20
  Scenario: Take a time measurement without label in config - no time report, test is not affected
    Given I use the fixture "qat_project_time_measures"
    And I set the environment variables to:
      | variable        | value        |
      | CUCUMBER_FORMAT |              |
      | CUCUMBER_OPTS   | -t @no_label |
    When I run `rake test:run`
    Then the exit status should be 0
    And the output should not match /\|\sInteraction\s*\|\sStart\s*|\sEnd\s*\|\sDuration\|/
    And the output should not match /\|\sThis is a test measure\s*|\s*\d{4}-\d{2}-\d{2}\s\d{2}:\d{2}:\d{2}+\d{4}\s*\|\s*\d{4}-\d{2}-\d{2}\s\d{2}:\d{2}:\d{2}+\d{4}\s*\|\s\d{2}m\s\d{2}s\s*\|/
    And the output should match /Caught exception: \[QAT::Reporter::Times::NoLabelInConfig\] No description was found in configuration file for key 'no_test_measure'!/


  @test#21
  Scenario: An exception is raised generating time report without a label in config for a time measurement
    Given the user starts a time measurement without configuration
    And executes a code snippet that lasts "2" seconds
    And the user stops the time measurement
    When the time report is generated
    Then an "QAT::Reporter::Times::NoLabelInConfig" exception is raised


  @bug#29
  Scenario Outline: Time measurement block returns the result value of the evaluated code
    When the execution time is evaluated for code snippet:
      """
      expected = <code>
      """
    Then the block return value is <expected>

    Examples:
      | code          | expected    |
      | 'my result'   | 'my result' |
      | 1 + 1         | 2           |
      | [1,2] + [3,4] | [1,2,3,4]   |


  @bug#28
  Scenario: Take a time measurement without label in config - no time report, test is not affected
    Given I use the fixture "qat_project_time_measures"
    And I set the environment variables to:
      | variable        | value             |
      | CUCUMBER_FORMAT |                   |
      | CUCUMBER_OPTS   | -t @no_start_time |
    When I run `rake test:run`
    Then the exit status should be 0
    And the output should match /\[WARN \] QAT::Reporter::Times: No Start time was found for 'This is a test measure'!/


  @bug#30
  Scenario: Take a time measurement using start and 2 stop methods
    When the user starts a time measurement with configuration
    And executes a code snippet that lasts "2" seconds
    And the user stops a time measurement
    And executes a code snippet that lasts "4" seconds
    And the user stops a time measurement
    Then a time interval of "2" seconds was measured
    And the execution time is formatted as "00m 02s"


  @bug#31
  Scenario: Take a time measurement using 2 start and 2 stop methods with the same label name
    When the user starts a time measurement with configuration
    And executes a code snippet that lasts "2" seconds
    And the user stops the time measurement
    When the user starts a time measurement with configuration
    And executes a code snippet that lasts "4" seconds
    And the user stops the time measurement
    Then a time interval of "2" seconds was measured
    And the execution time is formatted as "00m 02s"
