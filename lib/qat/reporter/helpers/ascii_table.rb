module QAT
  module Reporter
    # Namespace for custom Report output formatters
    #@since 6.1.7
    module Helpers
      # Namespace for AsciiTable formatter
      #@since 6.1.7
      class AsciiTable

        attr_reader :content

        def initialize(content)
          @content = content
        end

        def to_s
          return @ascii if @ascii

          # conver to 2D array
          table  = set_table(content)
          widths = calculate_widths(table)

          # header separator
          table.insert(1, widths.map { |n| '-' * n })

          format = widths.collect { |n| "%-#{n}s" }.join(" | ")

          @ascii ||= table.map do |line|
            sprintf "| #{format} |\n", *line
          end.join
        end

        private

        def set_table(content)
          [content.first.keys] + content.map(&:values)
        end

        def calculate_widths(table)
          widths ||= []
          table.each do |line|
            col_index = 0
            line.each do |col|
              col               = col.to_s
              widths[col_index] = (widths[col_index] && widths[col_index] > col.length) ? widths[col_index] : col.length
              col_index         += 1
            end
          end
          widths
        end
      end
    end
  end
end
