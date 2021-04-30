require 'cucumber/formatter/console'
require 'cucumber/formatter/io'
require 'cucumber/formatter/duration'
require 'cucumber/formatter/duration_extractor'
require 'json'
require 'qat/logger'
require 'qat/formatter/helper'
require 'qat/formatter/loggable'
require_relative '../../reporter/times'


module QAT
  # Namespace for custom Cucumber formatters and helpers.
  #@since 0.1.0
  module Reporter
    module Formatter
      # Namespace for Time Measurements formatter
      #@since 6.2.0
      class TimeMeasurements
        include ::Cucumber::Formatter::Io
        include ::Cucumber::Formatter::Duration
        include QAT::Formatter::Loggable
        include QAT::Logger
        include QAT::Formatter::Helper


        def initialize(config)
          @config         = config
          @io             = ensure_io(config.out_stream, config.error_stream)
          @ast_lookup     = ::Cucumber::Formatter::AstLookup.new(config)
          @feature_hashes = []
          config.on_event :test_case_started, &method(:on_test_case_started)
          config.on_event :test_case_finished, &method(:on_test_case_finished)
          # config.on_event :test_step_started, &method(:on_test_step_started)
          # config.on_event :test_step_finished, &method(:on_test_step_finished)
          # config.on_event :test_run_started, &method(:on_test_run_started)
          config.on_event :test_run_finished, &method(:on_test_run_finished)
          @json_content = []

          # @current_scenario_info = {}
        end

        # def on_test_run_started event
        #   test_case   = event.test_cases
        #   uri              = test_case.first.location.file
        #   feature          = @ast_lookup.gherkin_document(uri).feature
        #   feature(feature, uri)
        #   log.warn @feature_hash
        # end

        def on_test_case_started event
          return if @config.dry_run?
          @row_number = nil
          test_case   = event.test_case
          build(test_case, @ast_lookup)
          assign_print_feature unless @current_feature

          if @current_feature_info.nil?
            log.error "teste1"
            @current_feature_timestamp = Time.now.strftime("%FT%T%z")
            @current_feature_info      = {
              feature:   @feature_hash[:name],
              tags:      @feature_hash[:tags],
              timestamp: @current_feature_timestamp,
              scenarios: []
            }
          elsif @current_feature_info.values.include?(@feature_hash[:name])
            log.error "teste2"
          else
            log.error "teste3"
            process_scenarios

            @current_feature_info      = {
              feature:   @feature_hash[:name],
              tags:      @feature_hash[:tags],
              timestamp: @current_feature_timestamp,
              scenarios: []
            }
          end



          @current_scenario = @scenario
          scenario_name     = @current_scenario[:name]
          print_scenario_start @current_scenario[:keyword], scenario_name
          mdc_before_scenario! scenario_name, @current_scenario[:tags], @row_number, @examples_values

          @current_scenario[:tags] = @current_scenario[:tags] - @feature_hash[:tags] if @feature_hash[:tags]
          @current_scenario_info   = {
            name:      @current_scenario[:name],
            tags:      @current_scenario[:tags],
            timestamp: Time.now.strftime("%FT%T%z"),
            test_runs: []
          }
        end


        def on_test_case_finished event
          return if @config.dry_run?
          _test_case, result = *event.attributes
          @current_feature   = nil
          @current_feature_info[:scenarios] << @current_scenario_info


          test_run_id = QAT[:current_test_run_id]
          measurements = QAT::Reporter::Times.get_measures rescue []

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

          test_run_info = {
            id:           test_run_id,
            test_status:  test_status,
            timestamp:    QAT[:test_start_timestamp]&.strftime("%FT%T%z"),
            measurements: []
          }

          measurements.each do |id, measure|
            if id
              minutes, seconds = measure[:duration].divmod(60)
              test_run_info[:measurements] << {
                id:        id,
                name:      measure[:name],
                timestamp: measure[:start].strftime("%FT%T%z"),
                time:      {
                  secs:  measure[:duration],
                  human: "#{minutes}m #{'%02.0f' % seconds}s"
                },
                sla:       measure[:sla]
              }
            end
          end

          @current_scenario_info[:test_runs] << test_run_info
        end

        def on_test_run_finished event
          return if @config.dry_run?
          print_scenario_results @feature_hash[:keyword], @feature_hash[:name]
          process_scenarios

          @io.puts(JSON.pretty_generate(@json_content))
          log.error @json_content

        end


        def process_scenarios
          @indexes           = []
          @indexes_test_runs = []
          @scenarios         = @current_feature_info[:scenarios]

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
          log.error  @json_content
        end

      end
    end
  end
end