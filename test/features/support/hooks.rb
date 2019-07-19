require 'fileutils'

# After do
#   QAT::Config.clear
# end

Before '@time_measures' do
  QAT::Core.instance.instance_exec do
    @storage    = { tmp_folder: QAT[:tmp_folder] }
    @exceptions = []
  end
end

Before do
  @test_start_ts = Time.now.utc.iso8601(3)
end
