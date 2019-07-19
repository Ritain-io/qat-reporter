And /^the test results were published:$/ do |table|
  lines = table.raw.size - 1

  Retriable.retriable on:            [Minitest::Assertion],
                      tries:         30,
                      base_interval: 0.5,
                      multiplier:    1.0,
                      rand_factor:   0.0 do
    hits = get_test_results
    @test_results = hits.map { |hit| hit['_source'] }.sort { |a, b| Time.parse(a['@timestamp']) <=> Time.parse(b['@timestamp']) } rescue hits
    assert @test_results.size == lines, "Insufficient test results were found in time interval [#{@test_start_ts}, #{Time.now.iso8601(3)}]\nResult :#{hits}"
  end

  table.hashes.each do |line|
    id = line['test']
    log.info { "Validating Test with id '#{id}'!" }
    test_result = @test_results.select { |element| element['test'].to_f == id.to_f }.first
    assert test_result, "No test result for test id #{id}!"
    line.each do |key, value|
      log.debug { "Key: #{key} => expected: #{value}, actual: #{test_result[key]}" }
      case key.to_s
      when /test/
        assert_equal value.to_f, test_result[key].to_f
      when 'requirement'
        assert_equal eval(value), test_result[key]
      else
        assert_equal value, test_result[key]
      end
    end
  end
end


And(/^the test results have the duration information$/) do
  duration_present = @test_results.all? do |test_result|
    test_result.key?('duration') && test_result['duration'].to_s.match(/\d+\.\d+/) &&
      test_result.key?('human_duration') && test_result['human_duration'].to_s.match(/\d+m\d{1,2}\.\d{1,3}s/)
  end

  assert duration_present, "Not all test results have the duration information present!\nResults:\n#{@test_results}"
end