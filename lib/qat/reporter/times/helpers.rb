warn "[WARN] DEPRECATED: QAT::Reporter::Times::Helpers will be removed in a 7.0 version, please use QAT::Reporter::Helpers::TimeFormat"
require_relative '../helpers/time_format'

module QAT
  module Reporter
    # namespace for time report measures
    class Times
      # Namespace for Times Helpers
      Helpers = QAT::Reporter::Helpers::TimeFormat
    end
  end
end