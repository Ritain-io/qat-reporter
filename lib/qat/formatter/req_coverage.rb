require 'cucumber/formatter/console'
require 'cucumber/formatter/io'
require 'cucumber/formatter/duration'
require 'cucumber/formatter/duration_extractor'
require 'json'
require 'fileutils'
require 'qat/logger'
require 'qat/formatter/loggable'

module QAT
  # Namespace for custom Cucumber formatters and helpers.
  #@since 0.1.0
  module Formatter
    # Namespace for ReqCoverage formatter
    #@since 1.0.0
    class ReqCoverage
      include ::Cucumber::Formatter::Io
      include ::Cucumber::Formatter::Duration
      include QAT::Formatter::Loggable
      include QAT::Logger

      #@api private
      def initialize(runtime, path_or_io, options)
        @io           = ensure_io(path_or_io)
        @options      = options
        @test_results = []

        ensure_outputter 'ReqCoverage' unless options[:dry_run]
      end

      #@api private
      def before_feature(*_)
        @feature_requirement_ids = []
        @test_requirement_ids    = []
        @in_test_cases           = false
        @row_counter             = 0
        @flag_tag                = nil
      end

      #@api private
      def feature_name(*_)
        @in_test_cases = true
      end

      #@api private
      def tag_name(tag_name)
        @test_id       = tag_name.to_s.split('#')[1] if tag_name.match(/@test#(\d+)/)
        requirement_id = tag_name.to_s.split('#')[1] if tag_name.match(/@user_story#(\d+)/)
        if @in_test_cases
          @test_requirement_ids << requirement_id
        else
          @feature_requirement_ids << requirement_id
        end
      end

      #@api private
      def before_test_case(test_case)
        @current_scenario = test_case.source[1]
        unless @current_scenario.is_a?(::Cucumber::Core::Ast::ScenarioOutline)
          @test_id              = nil
          @test_requirement_ids = []
        end
      end

      #@api private
      def after_test_case(_, status)
        test_status = if status.is_a? ::Cucumber::Core::Test::Result::Passed
                        "passed"
                      elsif status.is_a? ::Cucumber::Core::Test::Result::Failed
                        "failed"
                      else
                        "not_runned"
                      end

        if @current_scenario.is_a? ::Cucumber::Core::Ast::ScenarioOutline
          if @flag_tag == @test_id
            @row_counter += 1
          else
            @row_counter = 1
          end

          test_id = "#{@test_id}.#{@row_counter}".to_f
        else
          @row_counter = 1
          test_id      = @test_id.to_i
        end

        duration       = ::Cucumber::Formatter::DurationExtractor.new(status).result_duration
        human_duration = format_duration(duration)

        test_result = {
          test:           test_id,
          requirement:    (@feature_requirement_ids + @test_requirement_ids).uniq.compact,
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

        @test_requirement_ids = [] unless @current_scenario.is_a?(::Cucumber::Core::Ast::ScenarioOutline)
        @flag_tag             = @test_id if @flag_tag != @test_id
      end

      #@api private
      def after_features(*_)
        publish_result
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