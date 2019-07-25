require 'cucumber/formatter/console'
require 'cucumber/formatter/io'
require 'cucumber/formatter/duration'
require 'cucumber/formatter/duration_extractor'
require 'json'
require 'fileutils'
require 'qat/logger'
require 'qat/formatter/loggable'
require_relative '../../qat/reporter/times'

module QAT
  # Namespace for custom Cucumber formatters and helpers.
  #@since 0.1.0
  module Formatter
    # Namespace for Time Measurements formatter
    #@since 1.0.0
    class TimeMeasurements
      include ::Cucumber::Formatter::Io
      include ::Cucumber::Formatter::Duration
      include QAT::Formatter::Loggable
      include QAT::Logger

      #@api private
      def initialize(runtime, path_or_io, options)
        @io           = ensure_io(path_or_io)
        @options      = options
        @test_results = []

        # ensure_outputter 'TimeMeasurements' unless options[:dry_run]
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
        # @test_id       = tag_name.to_s
        # requirement_id = tag_name.to_s.split('#')[1] if tag_name.match(/@user_story#(\d+)/)
        # if @in_test_cases
        #   @test_requirement_ids << requirement_id
        # else
        #   @feature_requirement_ids << requirement_id
        # end
      end

      #@api private
      def before_test_case(test_case)
        @current_feature  = test_case.source[0]
        @current_scenario = test_case.source[1]
        # unless @current_scenario.is_a?(::Cucumber::Core::Ast::ScenarioOutline)
        #   @test_id              = nil
        #   @test_requirement_ids = []
        # end
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

        duration       = ::Cucumber::Formatter::DurationExtractor.new(status).result_duration
        human_duration = format_duration(duration)

        test_id     = QAT[:current_test_id]
        test_run_id = QAT[:current_test_run_id]
        begin
          measurements = QAT::Reporter::Times.generate_time_report QAT[:current_test_id]
        rescue
          measurements = nil
        end

        unless measurements.nil?
          measurements.each do |id, measure|
            @measurement_id   = id
            @measurement_name = measure[:name]
          end

          unless @measurement_id.nil?
            @test_results <<
              {
                feature:      @current_feature,
                scenario:     @current_scenario,
                status:       test_status,
                test_id:      test_id,
                test_run_id:  test_run_id,
                measurements: [
                                id:   @measurement_id,
                                name: @measurement_name,
                                time: {
                                  duration:       duration,
                                  human_duration: human_duration
                                }

                              ]

              }
          end
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
        content =  @test_results
        @io.puts(JSON.pretty_generate(content))
      end
    end
  end
end