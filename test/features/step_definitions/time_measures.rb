When(/^the user starts a time measurement (with|without) configuration$/) do |configuration|
  if configuration.eql? 'with'
    @label = 'test_measure'
  else
    @label = 'no_test_measure'
  end

  QAT::Reporter::Times.start(@label)
end

And(/^executes a code snippet that lasts "([^"]*)" seconds$/) do |duration|
  if Timecop.frozen?
    Timecop.freeze(Time.now + duration.to_i)
  else
    sleep duration.to_i
  end
end

And(/^the user stops (?:a|the)( blocking)? time measurement$/) do |blocking|
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

Then(/^a time interval of "([^"]*)" seconds was measured$/) do |duration|
  begin
    test_measure = QAT::Reporter::Times.get_duration(@label)
    assert_equal(duration, test_measure.to_i)
  rescue => @error
    log.warn "Caught exception: [#{@error.class}] #{@error.message}\n#{@error.backtrace.join("\n")}"
  end
end

And(/^the execution time is formatted as "([^"]*)"$/) do |formatted|
  test_measure = QAT::Reporter::Times.get_execution_time(@label)
  assert_equal(formatted, test_measure)
end

When(/^a code snippet that lasts "([^"]*)" seconds is measured$/) do |duration|
  if @label.eql? nil
    @label = 'test_measure'
  else
    @label
  end

  QAT::Reporter::Times.measure(@label) do
    if Timecop.frozen?
      Timecop.freeze(Time.now + duration.to_i)
    else
      sleep duration.to_i
    end
  end
end

And(/^the time measure was recorded with name "([^"]*)"$/) do |name|
  Retriable.retriable on:            [Minitest::Assertion],
                      tries:         30,
                      base_interval: 0.5,
                      multiplier:    1.0,
                      rand_factor:   0.0 do
    hits = get_test_results
    @test_results = hits.map { |hit| hit['_source'] }.sort { |a, b| Time.parse(a['@timestamp']) <=> Time.parse(b['@timestamp']) } rescue hits
    assert @test_results.size == 1, "Insufficient test results were found in time interval [#{@test_start_ts}, #{Time.now.iso8601(3)}]\nResult :#{hits}"
  end

  test_result = @test_results.select { |element| element['name'] == name }.first
  assert test_result, "No time measure with name #{name}!"
end

And(/^the test results have the name information$/) do
  name = @test_results.all? do |test_result|
    test_result.key?('name') && test_result['name'].to_s.match(/\d+\.\d+/) &&
      test_result.key?('human_duration') && test_result['human_duration'].to_s.match(/\d+m\d{1,2}\.\d{1,3}s/)
  end

  assert name, "Not all test results have the name information present!\nResults:\n#{@test_results}"
end

When(/^the time report is (?:generated|sent to the remote server)$/) do
  begin
    QAT::Reporter::Times.generate_time_report(QAT[:current_test_id])
  rescue => @error
  end
end

Given(/^the user sets the (start|stop) time as "([^"]*)"$/) do |method, time_string|
  @label = 'test_measure'

  QAT::Reporter::Times.method(method.to_sym).call(@label, Time.parse(time_string))
end

Given(/^the measure extra information is defined as:$/) do |table|
  info = table.hashes.first
  info.transform_keys! { |key| key.parameterize(separator: '_').downcase.to_sym }
  info.each do |key, value|
    QAT::Reporter::Times.method("#{key}=").call value if value
  end
end

Then(/^the time measure was recorded with information:$/) do |table|
  Retriable.retriable on:            [Minitest::Assertion],
                      tries:         30,
                      base_interval: 0.5,
                      multiplier:    1.0,
                      rand_factor:   0.0 do
    hits = get_test_results
    @test_results = hits.map { |hit| hit['_source'] }.sort { |a, b| Time.parse(a['@timestamp']) <=> Time.parse(b['@timestamp']) } rescue hits
    assert @test_results.size == 1, "Insufficient test results were found in time interval [#{@test_start_ts}, #{Time.now.iso8601(3)}]\nResult :#{hits}"
  end

  table.hashes.each do |line|
    test_result = @test_results.select { |element| element }.first
    assert test_result, "No test results found!"
    line.each do |key, value|
      key_parameter = key.parameterize(separator: '_')
      log.debug { "Key: #{key} => expected: #{value}, actual: #{test_result[key_parameter.split('_').first][key_parameter.split('_').last]}" }
      assert_equal value, test_result[key_parameter.split('_').first][key_parameter.split('_').last]
    end
  end
end


Then(/^the key "([^"]*)" for "([^"]*)" does not exist$/) do |key, info|
  test_result = @test_results.select { |element| element }.first
  assert test_result, "No test results found!"
  keys = test_result["#{info}"].keys
  refute keys.include?(key)
end


When(/^the execution time is evaluated for code snippet:$/) do |text|
  @block_result = QAT::Reporter::Times.measure('test_measure') do
    eval(text)
  end
  log.debug "Result: #{@block_result} (#{@block_result.class})"
end

Then(/^the block return value is (.*)$/) do |expected|

  assert_equal(eval(expected.to_s), @block_result)
end