include_recipe 'consul'
# include_recipe 'consul_alerts'

# This should install whatever is currently the default. We don't
# care what version that is, simply that a version gets installed
consul_alerts 'default'

# This should install 0.1.0, we'll test that is the case
consul_alerts '0.1.0' do
  version '0.1.0'
  install_dir '/tmp/consul_alerts/specific_version'
  service_name 'consul-alerts-0.1.0'
  action [:create, :start]
  port 9001
end

consul_alerts 'delete_me_later' do
  user 'consul-alerts2'
  group 'consul-alerts2'
  service_name 'consul-alerts-delete'
end
consul_alerts 'delete_me_now' do
  install_dir '/tmp/consul_alerts/should_get_deleted'
  action :remove
  service_name 'consul-alerts-delete'
end
