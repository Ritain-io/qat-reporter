require 'cucumber/formatter/json'

module QAT
  # Namespace for QAT Reporter
  module Reporter
    # Namespace for custom Cucumber formatters and helpers.
    #@since 6.1.7
    module Formatter
      # Namespace for Json formatter
      #@since 6.1.7
      class Json < ::Cucumber::Formatter::Json
        #@api private
        def attach *_
        end
      end
    end
  end
end