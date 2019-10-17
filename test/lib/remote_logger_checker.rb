require 'httparty'
require 'json'
require 'retriable'
require 'yaml'
require 'active_support/core_ext/hash/keys'

class RemoteLoggerChecker
  def initialize
    @test_start_ts = Time.now.iso8601(3)
  end

  def remote_logging
    @remote_logging ||= QAT.configuration.dig(:remote_logging).symbolize_keys
  end

  def remote_logging_url
    URI::Generic.build(remote_logging)
  end

  def get_test_results
    url = "#{remote_logging_url}/#{remote_logging[:test_results]['index']}-#{Time.now.utc.strftime('%Y.%m.%d')}/_search"

    body = <<-JSON
{
  "query": {
    "bool": {
      "must": [
        {
          "query_string": {
            "default_field": "facility",
            "query": "#{remote_logging[:test_results]['facility']}"
          }
        },
        {
          "range": {
            "@timestamp": {
              "from": "#{@test_start_ts}",
              "to": "#{Time.now.iso8601(3)}"
            }
          }
        }
      ]
    }
  }
}
    JSON

    log_timestamp url, body
  end

  def get_test_times
    url = "#{remote_logging_url}/#{remote_logging[:test_times]['index']}-#{Time.now.utc.strftime('%Y.%m.%d')}/_search"

    body = <<-JSON
{
  "query": {
    "bool": {
      "must": [
        {
          "query_string": {
            "default_field": "facility",
            "query": "#{remote_logging[:test_times]['facility']}"
          }
        },
        {
          "range": {
            "@timestamp": {
              "from": "#{@test_start_ts}",
              "to": "#{Time.now.iso8601(3)}"
            }
          }
        }
      ]
    }
  }
}
    JSON

    log_timestamp url, body

  end

  private

  def log_timestamp (url, body)
    Log4r::Logger.log_internal {"ES Request:\nURL:#{url}\n#{body}"}

    obj = []
    opts = {
        body: body,
        headers: {
            'Content-Type' => 'application/json',
            'Accept' => 'application/json'
        }
    }

    if ENV['ES_USER'] and ENV['ES_PASSWD']
      opts[:basic_auth] = {username: ENV['ES_USER'], password: ENV['ES_PASSWD']}
    end

    Retriable.retriable on: [NoESLogFound],
                        tries: 30,
                        base_interval: 0.5,
                        multiplier: 1.0,
                        rand_factor: 0.0 do
      result = HTTParty.get(url, opts).body
      Log4r::Logger.log_internal {"Result: #{result}"}

      result = JSON.parse result

      obj = result['hits']['hits'] rescue []
      raise NoESLogFound.new("No Log was found with timestamp [#{@test_start_ts}, #{Time.now.iso8601(3)}]\nResult :#{result}") if obj == []
    end

    obj
  end

  class NoESLogFound < StandardError
  end
end