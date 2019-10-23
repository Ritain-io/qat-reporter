require 'qat/logger'
require 'qat/cucumber'
require 'qat/core_ext/object/deep_compact'
require_relative 'helpers'
require_relative 'hooks/time_reporter'

module QAT
  module Reporter
    # namespace for time report measures
    class Times
      include QAT::Logger
      extend QAT::Reporter::Helpers::TimeFormat

      # Starts a time measure
      # @param loading_name [String] measure name
      # @param time [Time] start time (default: Time.now)
      # @return [Time]
      def self.start(loading_name, time = Time.now)
        if QAT::Core.instance.instance_variable_get(:@storage).key?("#{loading_name}_start".to_sym)
          log.warn "Time measurement '#{measure_description(loading_name) rescue loading_name}' already exists..."
          nil
        else
          QAT.store "#{loading_name}_start".to_sym, time
        end
      end

      # Stops a time measure
      # @param measure_key [String] measure key
      # @param time [Time] stop time (default: Time.now)
      # @return [Time/Nil] returns time or gives warning message
      def self.stop(measure_key, time = Time.now)
        if QAT::Core.instance.instance_variable_get(:@storage).key?("#{measure_key}_start".to_sym)
          if QAT::Core.instance.instance_variable_get(:@storage).key?("#{measure_key}_end".to_sym)
            log.warn "Time measurement '#{measure_description(measure_key) rescue measure_key}' already exists..."
            nil
          else
            QAT.store "#{measure_key}_end".to_sym, time
          end
        else
          log.warn "No Start time was found for '#{measure_description(measure_key) rescue measure_key}'!"
          nil
        end
      end

      # Stops a time measure
      # @param measure_key [String] measure name
      # @param time [Time] stop time (default: Time.now)
      # @raise [NoStartTimeError] When a start time value does not exist
      # @return [Time]
      def self.stop!(measure_key, time = Time.now)
        stop_time = self.stop(measure_key, time)
        raise NoStartTimeError.new 'No Start time was found!' unless stop_time
        stop_time
      end

      # Measures the execution time of a block of code
      # @param name [String] measure name
      # @yield
      # @return [String] measured execution time
      def self.measure(name)
        raise(ArgumentError, 'No block given') unless block_given?
        start(name)
        result = yield
        stop(name)
        log.debug "Total time at #{name}: #{get_execution_time(name)}"
        result
      end

      # Defines OS name
      # @param name [String] OS name
      # @return [String]
      def self.os_name=(name)
        QAT.store_permanently :os_name, name
      end

      # Defines OS version
      # @param version [String] OS version
      # @return [String]
      def self.os_version=(version)
        QAT.store_permanently :os_version, version
      end

      # Defines browser name
      # @param name [String] browser name
      # @return [String]
      def self.browser_name=(name)
        QAT.store_permanently :browser_name, name
      end

      # Defines browser version
      # @param version [String] browser version
      # @return [String]
      def self.browser_version=(version)
        QAT.store_permanently :browser_version, version
      end

      # Generates the time report of a test using the names stored in QAT
      # @param test_id [String] test ID
      # @return [String]
      def self.generate_time_report(test_id)
        measures = get_measures

        measures.each do |id, measure|
          log.info build_measure(test_id, id, measure)
        end

        measures
      end

      # Gets formatted execution time
      # @param name [String] measure name
      # @return [Time]
      def self.get_execution_time(name)
        human_formatted_time(get_duration(name))
      end

      # Gets duration execution time
      # @param name [String] measure name
      # @return [Float]
      def self.get_duration(name)
        end_key = "#{name}_end".to_sym
        QAT[end_key] ||= Time.now
        QAT[end_key].to_f - QAT["#{name}_start".to_sym].to_f
      end

      # Verifies if QAT Storage has times
      # @return [Boolean]
      def self.has_times?
        QAT::Core.instance.instance_variable_get(:@storage).keys.any? {|key| key.match(/_start$/)}
      end


      private

      # Returns all time measure start keys
      # @return [Array]
      def self.get_time_keys
        QAT::Core.instance.instance_variable_get(:@storage).select do |key, value|
          key.to_s.end_with? '_start' and value.is_a? ::Time
        end
      end

      # Calculates time duration for all measures
      # @return [Hash]
      def self.get_measures
        time_keys = get_time_keys

        return {} unless time_keys.any?

        time_keys.inject({}) do |list, (key, start_time)|
          label = key.to_s.gsub(/\_start$/, '')

          end_time = QAT["#{label}_end".to_sym] || Time.now

          measure_duration = end_time.to_f - start_time.to_f

          warn_sla, error_sla, status_sla = sla_info(label, measure_duration)

          list[label] = {
              name: measure_description(label),
              start: start_time,
              end: end_time,
              duration: measure_duration,
              sla: {
                  warn: warn_sla,
                  error: error_sla,
                  status: status_sla
              }
          }

          list
        end
      end

      def self.build_measure(test_id, id, measure)
        duration = measure[:duration]

        {
            "message" => "partial time execution",
            "_test_id" => test_id,
            "_id" => id,
            "_name" => measure[:name],
            "_time" => {
                "secs" => duration,
                "human" => human_formatted_time(duration)
            },
            "_os" => {
                "name" => QAT[:os_name],
                "version" => QAT[:os_version]
            },
            "_browser" => {
                "name" => QAT[:browser_name],
                "version" => QAT[:browser_version]
            }
        }.deep_compact
      end


      def self.measure_description(key)
        description = if QAT.configuration.dig(:qat, :reporter, :times, key).is_a?(Hash)
                        QAT.configuration.dig(:qat, :reporter, :times, key, :name)
                      else
                        warn "[WARN] DEPRECATED: Measurements definition without limits will be removed in a 7.0 version, please use following configuration instead:\nmeasure_id:\n  name: Test measure\n  sla_warn: 10\n  sla_error: 15"
                        QAT.configuration.dig(:qat, :reporter, :times, key)
                      end

        raise NoLabelInConfig.new "No description was found in configuration file for key '#{key}'!" unless description
        description
      end

      def self.sla_info(key, duration)
        if QAT.configuration.dig(:qat, :reporter, :times, key).is_a?(Hash)
          warn_sla = QAT.configuration.dig(:qat, :reporter, :times, key, :sla_warn)&.to_f
          error_sla = QAT.configuration.dig(:qat, :reporter, :times, key, :sla_error)&.to_f
        end

        #If no measure end found, returns measure with status error
        unless QAT["#{key}_end".to_sym]
          return warn_sla, error_sla, "Error"
        end

        status = if error_sla && duration > error_sla
                   "Error"
                 elsif warn_sla && duration > warn_sla
                   "Warning"
                 else
                   "Passed"
                 end

        return warn_sla, error_sla, status
      end


      def self.test_sla_status
        measures = get_measures rescue []
        status_results = []
        measures&.each do |measure_key, info|
          sla_status = info.dig(:sla, :status)
          log.debug "SLA status for measure with key: #{measure_key} is '#{sla_status}'"
          status_results << sla_status
        end

        if status_results.include? 'Error'
          return "passed with SLA Error"
        elsif status_results.include? 'Warning'
          return "passed with SLA Warning"
        else
          return "passed"
        end
      end

      #No start time value error class
      class NoStartTimeError < StandardError
      end
      #No end time value error class
      class NoEndtTimeError < StandardError
      end
      #No label in yml configuration error class
      class NoLabelInConfig < StandardError
      end
    end
  end
end