#encoding: utf-8
# require File.expand_path(File.join(File.dirname(__FILE__), 'lib', 'qat', 'version.rb'))

Gem::Specification.new do |gem|
  gem.name        = 'qat-reporter'
  gem.version     = '6.1.0'
  gem.summary     = %q{Utility for Test Reports.}
  gem.description = <<-DESC
  QAT Reporter is a collection of tool for generating test report information such as:
    - Requirement Coverage
  DESC

  gem.email    = 'qatoolkit@readinessit.com'

  gem.homepage = 'https://www.readinessit.com'

  gem.metadata    = {
      'source_code_uri'   => 'https://github.com/readiness-it/qat-reporter'
  }
  gem.authors = ['QAT']
  gem.license = 'GPL-3.0'

  extra_files = %w[LICENSE]
  gem.files   = Dir.glob('{lib}/**/*') + extra_files

  gem.required_ruby_version = '~> 2.3'

  gem.add_dependency 'qat-cucumber', '~> 6.0'
  gem.add_dependency 'qat-logger', '~> 6.0'
  gem.add_dependency 'qat-core', '~> 6.0'

  gem.add_development_dependency 'qat-devel', '~> 6.0'
end
