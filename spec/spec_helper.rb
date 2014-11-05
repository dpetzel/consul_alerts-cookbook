require 'chefspec'
require 'chefspec/librarian'
ChefSpec::Coverage.start!

RSpec.configure do |config|
  config.platform = 'redhat'
  config.version = '6.5'
end
