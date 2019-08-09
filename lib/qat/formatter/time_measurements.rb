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
    #@since 6.2.0
    class TimeMeasurements
      include ::Cucumber::Formatter::Io
      include ::Cucumber::Formatter::Duration

      def initialize(runtime, path_or_io, options)
        @io = ensure_io(path_or_io)
        @options = options
        @json_content = []
        @scenario_tags = []
        @test_runs = []
      end

      #@api private
      def before_feature(feature)
        @feature_requirement_ids = []
        @test_requirement_ids = []
        @in_test_cases = false
        @row_counter = 0
        @flag_tag = nil
        @same_feature = @current_feature.equal?(feature)
        @current_feature = feature
        @feature_tags = []
        @current_feature_timestamp = Time.now.strftime("%FT%T")

        @current_feature_info = {
            feature: @current_feature,
            tags: [],
            timestamp: @current_feature_timestamp,
            scenarios: []
        }

      end

      #@api private
      def feature_name(*_)
        @in_test_cases = true
      end

      #@api private
      def tag_name(tag_name)
        @test_id = tag_name.to_s
        requirement_id = tag_name.to_s.split('#')[1] if tag_name.match(/@user_story#(\d+)/)
        @current_feature_info[:tags] << tag_name unless @in_test_cases
        @current_scenario_info[:tags] << tag_name if @in_test_cases
        if @in_test_cases
          @test_requirement_ids << requirement_id
        else
          @feature_requirement_ids << requirement_id
        end
      end

      #@api private
      def before_test_case(test_case)
        @current_scenario = test_case.source[1]
        # unless @current_scenario.is_a?(::Cucumber::Core::Ast::ScenarioOutline)
        #   @test_id              = nil
        #   @test_requirement_ids = []
        # end
        @current_scenario_timestamp = Time.now.strftime("%FT%T")

        @current_scenario_info = {
            name: @current_scenario,
            tags: [],
            timestamp: @current_scenario_timestamp,
            test_run: []
        }
      end

      #@api private
      def after_test_case(_, status)
        # test_status = if status.is_a? ::Cucumber::Core::Test::Result::Passed
        #                 "passed"
        #               elsif status.is_a? ::Cucumber::Core::Test::Result::Failed
        #                 "failed"
        #               else
        #                 "not_runned"
        #               end

        duration = ::Cucumber::Formatter::DurationExtractor.new(status).result_duration
        human_duration = format_duration(duration)

        #test_id = QAT[:current_test_id]
        test_run_id = QAT[:current_test_run_id]
        begin
          measurements = QAT::Reporter::Times.generate_time_report QAT[:current_test_id]
        rescue
          measurements = []
        end

        #unless measurements.nil?
          measurements.each do |id, measure|
            @measurement_id = id
            @measurement_name = measure[:name]
          end

          #unless @measurement_id.nil?

            if @current_scenario.is_a?(::Cucumber::Core::Ast::ScenarioOutline)
            else
            end

            @current_scenario_info[:test_run] <<
                {
                    id: test_run_id,
                    timestamp: Time.now.strftime("%FT%T"), #TODO
                    measurements: [
                        {
                            id: @measurement_id,
                            name: @measurement_name,
                            timestamp: Time.now.strftime("%FT%T"), #TODO
                            time: {
                                duration: duration,
                                human_duration: human_duration
                            }
                        }
                    ]
                }
          #end

          @scenario_tags = [] unless @current_scenario.is_a?(::Cucumber::Core::Ast::ScenarioOutline)
        #end
      end

      #@api private
      def after_outline_table(*_)
        @scenario_tags = []
      end

      #@api private
      def after_feature_element(*_)
        @current_feature_info[:scenarios] << @current_scenario_info
      end

      #@api private
      def after_feature(*_)
        @json_content << @current_feature_info
      end

      #@api private
      def after_features(*_)
        publish_result
      end

      private

      # Writes results to a JSON file
      def publish_result
        @io.puts(JSON.pretty_generate(@json_content))
      end
    end
  end
end