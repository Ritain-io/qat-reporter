# -*- encoding : utf-8 -*-
# Code coverage
require 'simplecov'
require 'minitest'
require 'active_support/core_ext/date_time/calculations'
require 'active_support/core_ext/time/calculations'
require 'active_support/core_ext/date/calculations'
require 'active_support/core_ext/hash/keys'
require 'aruba/cucumber'
require 'retriable'
require 'httparty'
require 'gelf'
require 'nokogiri'
require_relative '../../lib/remote_logger_checker'
require 'qat/cucumber'
require 'qat/reporter'

old_jenkins_url = ENV['JENKINS_URL']

at_exit do
  ENV['JENKINS_URL'] = old_jenkins_url
end

ENV['JENKINS_URL'] = nil

Aruba.configure do |config|
  config.command_search_paths = config.command_search_paths << ::File.absolute_path(::File.join(::File.dirname(__FILE__), '..', '..', '..', 'bin'))
  config.exit_timeout         = 6000
end

World do
  RemoteLoggerChecker.new
end