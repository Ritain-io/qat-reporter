require 'cucumber/formatter/json'

module QAT
  # Namespace for QAT Reporter
  module Reporter
    # Namespace for custom Cucumber formatters and helpers.
    module Formatter
      # Namespace for Json formatter
      class Json < ::Cucumber::Formatter::Json
        #@api private
        def attach *_
        end
      end
    end
  end
end