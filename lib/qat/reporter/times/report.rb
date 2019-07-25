require 'qat/logger'
require_relative 'helpers'
require_relative '../formatters/ascii_table'

module QAT
  module Reporter
    # namespace for time report measures
    class Times
      # Namespace for Times Report outputs
      module Report
        include QAT::Logger
        extend Helpers

        # Builds an ascii table time report for console output
        # @return [String]
        def self.table(data)
          if data.any?
            table_data = data.map do |_, measure|
              {
                'Interaction' => measure[:name],
                'Start'       => measure[:start].strftime('%Y-%m-%d %H:%M:%S %z'),
                'End'         => measure[:end].strftime('%Y-%m-%d %H:%M:%S %z'),
                'Duration'    => human_formatted_time(measure[:duration]),
              }
            end

            QAT::Reporter::Formatters::AsciiTable.new(table_data).to_s
          else
            "No time measure was recorded!"
          end
        end
      end
    end
  end
end