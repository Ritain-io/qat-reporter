require 'cucumber/formatter/console'
require 'cucumber/formatter/io'
require 'cucumber/formatter/duration'
require 'cucumber/formatter/duration_extractor'
require 'json'
require 'fileutils'
require 'qat/logger'
require 'qat/formatter/helper'
require 'qat/formatter/loggable'
require_relative '../../reporter/times'

module QAT
  # Namespace for QAT Reporter
  module Reporter
    # Namespace for custom Cucumber formatters and helpers.
    #@since 6.1.7
    module Formatter
      # Namespace for ReqCoverage formatter
      #@since 6.1.7
      class ReqCoverage
        include ::Cucumber::Formatter::Io
        include ::Cucumber::Formatter::Duration
        include QAT::Formatter::Loggable
        include QAT::Logger
        include QAT::Formatter::Helper


        def initialize(config)
          @config = config
          @io     = ensure_io(config.out_stream, config.error_stream)
          ensure_outputter 'ReqCoverage' unless @config.dry_run?
          @ast_lookup     = ::Cucumber::Formatter::AstLookup.new(config)
          @feature_hashes = []
          config.on_event :test_case_started, &method(:on_test_case_started)
          config.on_event :test_case_finished, &method(:on_test_case_finished)
          config.on_event :test_run_finished, &method(:on_test_run_finished)
          @test_results            = []
          @feature_requirement_ids = []
          @test_requirement_ids    = []
          @row_counter             = 0
          @flag_tag                = nil
        end


        #@api private
        def tag_name(tag_name)
          @test_id       = tag_name.to_s.split('#')[1] if tag_name.match(/@test#(\d+)/)
          requirement_id = tag_name.to_s.split('#')[1] if tag_name.match(/@user_story#(\d+)/)
          @test_requirement_ids << requirement_id
        end

        #@api private
        def on_test_case_started(event)
          return if @config.dry_run?
          @row_number = nil
          @examples   = nil
          test_case   = event.test_case
          build(test_case, @ast_lookup)
          @test_id              = nil
          @test_requirement_ids = []
          @scenario[:tags].each do |tag|
            tag_name tag
          end


        end

        def on_test_case_finished event
          return if @config.dry_run?
          _test_case, result = *event.attributes
          @current_feature   = nil

          test_status = if result.passed?
                          if QAT::Reporter.const_defined?('Times')
                            QAT::Reporter::Times.test_sla_status
                          else
                            "passed"
                          end
                        elsif result.failed?
                          "failed"
                        else
                          "not_runned"
                        end

          if @examples_values
            if @flag_tag == @test_id
              @row_counter += 1
            else
              @row_counter = 1
            end
            test_id = "#{@test_id}.#{@scenario[:id].split('').last}".to_f
          else
            @row_counter = 1
            test_id      = @test_id.to_i
          end

          duration       = ::Cucumber::Formatter::DurationExtractor.new(result).result_duration
          human_duration = format_duration(duration)

          test_result = {
            test:           test_id,
            requirement:    @test_requirement_ids.uniq.compact,
            status:         test_status,
            duration:       duration,
            human_duration: human_duration
          }

          if test_result[:test]
            @test_results << test_result

            log.info({
                       'message'         => 'test execution',
                       '_test'           => test_result[:test],
                       '_requirement'    => test_result[:requirement],
                       '_status'         => test_result[:status],
                       '_duration'       => duration,
                       '_human_duration' => human_duration
                     })
          end

          @test_requirement_ids = [] if @examples_values
          @flag_tag             = @test_id if @flag_tag != @test_id
        end


        def on_test_run_finished event
          return if @config.dry_run?
          publish_result
          @test_id              = nil
          @test_requirement_ids = []
        end

        private

        # Writes results to a JSON file
        def publish_result
          content = {
            results: @test_results
          }
          @io.puts(JSON.pretty_generate(content))
        end
      end
    end
  end
end