require 'simplecov'

require 'timecop'

#Jump one day between each scenario run
#MUST EXECUTE BEFORE REGULAR QAT HOOKS! KEEP BEFORE REQUIRING QAT/CUCUMBER
Before do
  Timecop.freeze(Time.now+ 60*60*24)
end

#Lock on UTC timezone
require 'qat/cucumber'
require 'qat/reporter/times'

#Fix first timestamp
Timecop.freeze 2008, 10, 5