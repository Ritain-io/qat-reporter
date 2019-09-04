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

Then /^an? "([^"]*)" exception is raised$/ do |klass|
  refute_nil @error, "Expected a #{klass} exception to have occured, but none was found"
  log.debug @error
  assert_equal klass, @error.class.to_s
end


When(/^the time report is (?:generated|sent to the remote server)$/) do
  begin
    QAT::Reporter::Times.generate_time_report(QAT[:current_test_id])
  rescue => @error
  end
end


When(/^a code snippet that lasts "([^"]*)" seconds is measured$/) do |duration|
  if @label.eql? nil
    @label = 'test_measure'
  else
    @label
  end

  QAT::Reporter::Times.measure(@label) do
    sleep(duration)
  end
end


And(/^the user stops a "([^"]*)" time measurement$/) do |blocking|

  begin
    if blocking
      QAT::Reporter::Times.stop!(@label)
    else

      QAT::Reporter::Times.stop(@label)
    end
  rescue => @error
    log.warn "Caught exception: [#{@error.class}] #{@error.message}\n#{@error.backtrace.join("\n")}"
  end
end
