warn "[WARN] DEPRECATED: QAT::Reporter::Formatters::AsciiTable will be removed in a 7.0 version, please use QAT::Reporter::Helpers::AsciiTable"
require_relative '../helpers/ascii_table'

module QAT
  module Reporter
    # Namespace for custom Report output formatters
    #@since 3.1.0
    module Formatters
      # Namespace for AsciiTable formatter
      #@since 3.1.0
      AsciiTable = QAT::Reporter::Helpers::AsciiTable
    end
  end
end
