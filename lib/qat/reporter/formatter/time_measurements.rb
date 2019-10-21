require 'cucumber/formatter/console'
require 'cucumber/formatter/io'
require 'cucumber/formatter/duration'
require 'cucumber/formatter/duration_extractor'
require 'json'
require 'qat/logger'
require 'qat/formatter/loggable'
require_relative '../times'

module QAT
  # Namespace for QAT Reporter
  module Reporter
    # Namespace for custom Cucumber formatters and helpers.
    #@since 6.1.7
    module Formatter
      # Namespace for Time Measurements formatter
      #@since 6.1.7
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
          @outline_tags = []
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
              test_runs: []
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
              @outline_tags << tag_name
            else
              @current_scenario_info[:tags] << tag_name
            end
          end
        end

        #@api private
        def before_test_case(test_case)
          @current_scenario = test_case.source[1]
          @current_scenario_timestamp = Time.now.strftime("%FT%T%z")

          unless @current_scenario.is_a?(::Cucumber::Core::Ast::ScenarioOutline)
            @current_scenario_info = {
                name: @current_scenario,
                tags: [],
                timestamp: @current_scenario_timestamp,
                test_runs: []
            }
          end
        end

        #@api private
        def before_outline_table(*_)
          @outline = true
          @outline_scenario_info = {
              name: @current_scenario,
              tags: [],
              timestamp: @current_scenario_timestamp,
              test_runs: []
          }
        end

        #@api private
        def after_test_case(_, status)
          test_run_id = QAT[:current_test_run_id]
          measurements = QAT::Reporter::Times.get_measures rescue []

          test_run_info = {
              id: test_run_id,
              timestamp: QAT[:test_start_timestamp]&.strftime("%FT%T%z"),
              measurements: []
          }

          measurements.each do |id, measure|
            if id
              minutes, seconds = measure[:duration].divmod(60)
              test_run_info[:measurements] << {
                  id: id,
                  name: measure[:name],
                  timestamp: measure[:start].strftime("%FT%T%z"),
                  time: {
                      secs: measure[:duration],
                      human: "#{minutes}m #{'%02.0f' % seconds}s"
                  },
                  sla: measure[:sla]
              }
            end
          end

          if @current_scenario.is_a?(::Cucumber::Core::Ast::ScenarioOutline)
            @outline_scenario_info[:test_runs] << test_run_info
          else
            @current_scenario_info[:test_runs] << test_run_info
          end
        end

        #@api private
        def after_examples_array(*_)
          @outline_scenario_info[:tags] = @outline_tags
          @current_feature_info[:scenarios] << @outline_scenario_info
          @outline = true
          @outline_tags = []
        end

        #@api private
        def after_feature_element(*_)
          #After outline run, here cucumber changes for non outline, flag needed for outlines scenarios
          if @outline == true
            @outline = false
          else
            @current_feature_info[:scenarios] << @current_scenario_info
          end
          @in_test_cases = true
        end

        #@api private
        def after_feature(*_)
          @indexes = []
          @indexes_test_runs = []
          @scenarios = @current_feature_info[:scenarios]

          @scenarios.each_with_index do |key, value|
            test_run = key[:test_runs]
            #Verifies if exist measures in a test_run
            test_run.each_with_index do |key, value|
              if key[:measurements].empty?
                @indexes << value
              end
            end
            #Deletes the empty measures
            @indexes.reverse!.each do |v|
              test_run.delete_at(v)
            end
            #Verifies if exist test_runs in a scenarios
            if key[:test_runs].empty?
              @indexes_test_runs << value
            end
          end
          #Delete empty test runs:
          @indexes_test_runs.reverse!.each do |v|
            @current_feature_info[:scenarios].delete_at(v)
          end

          @json_content << @current_feature_info unless @scenarios.empty?
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
end