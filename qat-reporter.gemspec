#encoding: utf-8

Gem::Specification.new do |gem|
  gem.name        = 'qat-reporter'
  gem.version     = '9.0.0'
  gem.summary     = %q{Utility for Test Reports.}
  gem.description = <<-DESC
  QAT Reporter is a collection of tool for generating test report information such as:
    - Requirement Coverage
    - Time Measurements
  DESC

  gem.email    = 'qatoolkit@readinessit.com'

  gem.homepage = 'https://www.ritain.io'

  gem.metadata    = {
      'source_code_uri'   => 'https://github.com/Ritain-io/qat-reporter'
  }
  gem.authors = ['QAT']
  gem.license = 'GPL-3.0'

  extra_files = %w[LICENSE]
  gem.files   = Dir.glob('{lib}/**/*') + extra_files

  gem.required_ruby_version = '~> 3.2'

  gem.add_dependency 'qat-cucumber', '~> 9'
  gem.add_dependency 'qat-logger', '~> 9'
  gem.add_dependency 'qat-core', '~> 9'

  gem.add_development_dependency 'qat-devel', '~> 9'
end
