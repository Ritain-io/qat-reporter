require 'timecop'

Timecop.freeze 2008, 10, 5

Before do
  Timecop.freeze(Time.now+ 60*60*24)
end
