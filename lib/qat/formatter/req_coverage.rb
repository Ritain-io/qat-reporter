warn "[WARN] DEPRECATED: QAT::Formatter::ReqCoverage will be removed in a 7.0 version, please use QAT::Reporter::Formatter::ReqCoverage"
require_relative '../reporter/formatter/req_coverage'

module QAT
  # Namespace for custom Cucumber formatters and helpers.
  #@since 0.1.0
  module Formatter
    # Namespace for ReqCoverage formatter
    #@since 1.0.0
    ReqCoverage = QAT::Reporter::Formatter::ReqCoverage
  end
end