When(/^the user starts a time measurement (with|without) configuration$/) do |configuration|
  if configuration.eql? 'with'
    @label = 'test_measure'
  else
    @label = 'no_test_measure'
  end

  QAT::Reporter::Times.start(@label)
end

And(/^executes a code snippet that lasts "([^"]*)" seconds$/) do |duration|
  sleep(duration.to_i)
end

And(/^the user stops the time measurement$/) do
  begin
    QAT::Reporter::Times.stop!(@label || 'test_measure')
  rescue => @error
    log.warn "Caught exception: [#{@error.class}] #{@error.message}\n#{@error.backtrace.join("\n")}"
  end
end

Then(/^a time interval of "([^"]*)" seconds was measured$/) do |duration|
  begin
    test_measure = QAT::Reporter::Times.get_duration(@label)
    assert_equal(duration.to_i, test_measure.to_i)
  rescue => @error
    log.warn "Caught exception: [#{@error.class}] #{@error.message}\n#{@error.backtrace.join("\n")}"
  end
end

And(/^the execution time is formatted as "([^"]*)"$/) do |formatted|
  test_measure = QAT::Reporter::Times.get_execution_time(@label)
  assert_equal(formatted, test_measure)
end

Then(/^"(good|bad)" result is achieved/) do |result|
  case result
  when 'good'
    assert true
  else
    assert false
  end
end