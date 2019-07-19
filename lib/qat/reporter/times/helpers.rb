module QAT
  module Reporter
    # namespace for time report measures
    class Times
      # Namespace for Times Helpers
      module Helpers
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