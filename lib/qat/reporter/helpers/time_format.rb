module QAT
  module Reporter
    # namespace for time report measures
    module Helpers
      # Namespace for Times Helpers
      module TimeFormat
        # Gets a human formatted time
        # @param time [Time] measure name
        # @return [Time]
        def human_formatted_time(time)
          ::Time.at(time).utc.strftime("%Mm %Ss")
        end
      end
    end
  end
end