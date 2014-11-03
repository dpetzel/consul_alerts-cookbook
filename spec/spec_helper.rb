require 'chefspec'
require 'chefspec/berkshelf'
ChefSpec::Coverage.start!

RSpec.configure do |config|
  config.platform = 'redhat'
  config.version = '6.5'
end
