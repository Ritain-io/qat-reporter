require_relative '../times'
require_relative '../times/report'

After do |_|
  begin
  if QAT::Reporter::Times.has_times?
    time_report = QAT::Reporter::Times.generate_time_report(QAT[:current_test_id])

    table = QAT::Reporter::Times::Report.table(time_report)
    log.debug "Time Report:\n#{table}"
  end
  rescue => @error
    log.warn "Caught exception: [#{@error.class}] #{@error.message}\n#{@error.backtrace.join("\n")}"
  end
end