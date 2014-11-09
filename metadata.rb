name 'consul_alerts'
maintainer 'The Authors'
maintainer_email 'davidpetzel@gmail.com'
license 'apache2'
description 'Installs/Configures consul-alerts'
long_description 'Installs/Configures consul-alerts'
version '1.0.0'

depends 'service_factory', '~> 0.1.4'
depends 'consul_kv', '~> 1.0.0'

%w(redhat centos).each do |name|
  supports name, '~> 6.0'
  supports name, '~> 5.0'
end
