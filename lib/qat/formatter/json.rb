warn "[WARN] DEPRECATED: QAT::Formatter::Json will be removed in a 7.0 version, please use QAT::Reporter::Formatter::Json"
require_relative '../reporter/formatter/json'

module QAT
  # Namespace for custom Cucumber formatters and helpers.
  #@since 0.1.0
  module Formatter
    # Namespace for Json formatter
    #@since 6.1.0
    Json = QAT::Reporter::Formatter::Json
  end
end