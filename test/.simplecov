# -*- encoding : utf-8 -*-
# Code coverage
require 'simplecov-json'
require 'simplecov-rcov'
require 'rubygems/specification'

gemspec  = Dir.glob(File.join(Dir.pwd, '..', '*.gemspec')).first
gem_spec = Gem::Specification.load(gemspec)
project  = gem_spec.name

SimpleCov.formatters = [
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::JSONFormatter,
  SimpleCov::Formatter::RcovFormatter
]

ENV['SIMPLECOV_COVERAGE_DIR'] ||= ::File.join(SimpleCov.root, 'coverage')
ENV['SIMPLECOV_EVAL_DIR'] = ::File.realpath(::File.join(SimpleCov.root, '..', 'lib'))

deprecated = [
    File.join('qat', 'formatter', 'json.rb'),
    File.join('qat', 'formatter', 'req_coverage.rb'),
    File.join('qat', 'formatter', 'time_measurements.rb'),
    File.join('qat', 'reporter', 'formatters', 'ascii_table.rb'),
].map do |file|
  File.join ENV['SIMPLECOV_EVAL_DIR'], file
end

SimpleCov.start do
  project_name project
  coverage_dir(ENV['SIMPLECOV_COVERAGE_DIR'])
  command_name(project)
  profiles.delete(:root_filter)
  filters.clear
  track_files File.join(ENV['SIMPLECOV_EVAL_DIR'], '**', '*.rb')
  add_filter do |src|
    src.filename !~ /#{ENV['SIMPLECOV_EVAL_DIR']}/
  end
  add_filter do |src|
    deprecated.include? src.filename
  end
  minimum_coverage 90
end