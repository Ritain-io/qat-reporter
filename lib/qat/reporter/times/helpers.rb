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