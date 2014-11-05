require 'chefspec'
require 'chefspec/berkshelf'
require 'simplecov'
require 'simplecov-csv'

SimpleCov.formatter = SimpleCov::Formatter::CSVFormatter
SimpleCov.coverage_dir(ENV["COVERAGE_REPORTS"])
SimpleCov.start

ChefSpec::Coverage.start!

RSpec.configure do |config|
  config.platform = 'redhat'
  config.version = '6.5'
end
