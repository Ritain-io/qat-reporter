require 'cucumber/formatter/json'

module QAT
  # Namespace for custom Cucumber formatters and helpers.
  #@since 0.1.0
  module Formatter
    # Namespace for Json formatter
    #@since 6.1.0
    class Json < ::Cucumber::Formatter::Json

      #@api private
      def embed *_
      end
    end
  end
end