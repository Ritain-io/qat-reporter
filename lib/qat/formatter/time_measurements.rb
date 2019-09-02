require 'cucumber/formatter/console'
require 'cucumber/formatter/io'
require 'cucumber/formatter/duration'
require 'cucumber/formatter/duration_extractor'
require 'json'
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
      end

      #@api private
      def before_feature(feature)
        @in_test_cases = false
        @current_feature = feature
        @current_feature_timestamp = Time.now.strftime("%FT%T%z")
        @current_feature_info = {
            feature: @current_feature,
            tags: [],
            timestamp: @current_feature_timestamp,
            scenarios: []
        }

        @outline_scenario_info = {
            name: [],
            tags: [],
            timestamp: [],
            test_run: []
        }
      end

      #@api private
      def feature_name(*_)
        @in_test_cases = true
      end

      #@api private
      def tag_name(tag_name)
        @test_id = tag_name.to_s
        @current_feature_info[:tags] << tag_name unless @in_test_cases

        if @in_test_cases
          if @current_scenario.is_a?(::Cucumber::Core::Ast::ScenarioOutline)
            @outline_scenario_info[:tags] << tag_name
          else
            @current_scenario_info[:tags] << tag_name
          end
        end
      end

      #@api private
      def before_test_case(test_case)
        @current_scenario = test_case.source[1]
        @current_scenario_timestamp = Time.now.strftime("%FT%T%z")

        if @current_scenario.is_a?(::Cucumber::Core::Ast::ScenarioOutline)
          if @outline_end #Not to set the flags/test_un to nil after a outline execution
            @outline_scenario_info = {
                name: @current_scenario,
                tags: [],
                timestamp: @current_scenario_timestamp,
                test_run: []
            }
            @outline_end = false
          end
        else
          @current_scenario_info = {
              name: @current_scenario,
              tags: [],
              timestamp: @current_scenario_timestamp,
              test_run: []
          }
        end
      end

      #@api private
      def before_outline_table(*_)
        @outline_scenario_info = {
            name: @current_scenario,
            tags: @outline_scenario_info[:tags],
            timestamp: @current_scenario_timestamp,
            test_run: []
        }
      end

      #@api private
      def after_test_case(_, status)
        duration = ::Cucumber::Formatter::DurationExtractor.new(status).result_duration
        human_duration = format_duration(duration)

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

        test_run_info = {
            id: test_run_id,
            timestamp: Time.now.strftime("%FT%T%z"),
            measurements: [
                {
                    id: @measurement_id,
                    name: @measurement_name,
                    timestamp: Time.now.strftime("%FT%T%z"),
                    time: {
                        secs: duration,
                        human: human_duration
                    }
                }
            ]
        }

        if @current_scenario.is_a?(::Cucumber::Core::Ast::ScenarioOutline)
          @outline_scenario_info[:test_run] << test_run_info
        else
          @current_scenario_info[:test_run] << test_run_info
        end
        #end
        #end
      end

      #@api private
      def after_examples_array(*_)
        @current_feature_info[:scenarios] << @outline_scenario_info
        @in_test_cases = false
        @outline_end = true
      end

      #@api private
      def after_feature_element(*_)
        @current_feature_info[:scenarios] << @current_scenario_info unless @current_scenario.is_a?(::Cucumber::Core::Ast::ScenarioOutline)
        @in_test_cases = true
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