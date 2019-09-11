require 'fileutils'
require 'timecop'

# After do
#   QAT::Config.clear
# end

Before '@time_measures' do
  QAT::Core.instance.instance_exec do
    @storage    = { tmp_folder: QAT[:tmp_folder] }
    @exceptions = []
  end
end

Before '@time_measures ~@remote_logging' do
  Timecop.freeze 2008, 10, 5
end

After do
  Timecop.return
end

Before do
  @test_start_ts = Time.now.utc.iso8601(3)
end
