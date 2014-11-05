require 'coveralls'
Coveralls.wear!

require 'chefspec'
require 'chefspec/berkshelf'
require_relative 'support/matchers'

ChefSpec::Coverage.start!



RSpec.configure do |config|
  config.platform = 'redhat'
  config.version = '6.5'
end
