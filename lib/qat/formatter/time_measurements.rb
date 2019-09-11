warn "[WARN] DEPRECATED: QAT::Formatter::TimeMeasurements will be removed in a 7.0 version, please use QAT::Reporter::Formatter::TimeMeasurements"
require_relative '../reporter/formatter/time_measurements'

module QAT
  # Namespace for custom Cucumber formatters and helpers.
  #@since 0.1.0
  module Formatter
    TimeMeasurements = QAT::Reporter::Formatter::TimeMeasurements
  end
end