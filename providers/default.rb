def whyrun_supported?
  true
end

use_inline_resources

def initialize(new_resource, run_context)
  new_resource.validate_chef_version!
  new_resource.validate_platform!
  super
end

def bin_path
  ::File.join(new_resource.install_dir, 'consul-alerts')
end

action :create do
  package 'tar'

  archive_dl_path = ::File.join(Chef::Config[:file_cache_path], new_resource.tarfile_name)
  remote_file 'consul-alerts-tar' do
    action :create
    path archive_dl_path
    source new_resource.tarfile_url
    checksum new_resource.tarfile_checksum
  end

  unless ::File.directory?(new_resource.install_dir)
    directory new_resource.install_dir do
      recursive true
      action :create
      mode '0755'
      owner new_resource.user
      group new_resource.group
    end
    new_resource.updated_by_last_action(true)
  end

  unless ::File.exist?(bin_path)
    execute 'untar_consul-alerts' do
      command "cd #{new_resource.install_dir} && tar -xf #{archive_dl_path}"
    end
    new_resource.updated_by_last_action(true)
  end

  grp = group new_resource.group do
    action :create
  end
  new_resource.updated_by_last_action(grp.updated_by_last_action?)

  usr = user new_resource.user do
    system true
    gid new_resource.group
  end
  new_resource.updated_by_last_action(usr.updated_by_last_action?)

  configure_service

  # Populate the key/value store with the configuration data
  new_resource.config.each_pair do |key, value|
    path = config_key_path(key)
    consul_kv key do
      action :create
      value value
      path path
      consul_addr new_resource.consul_addr
    end
  end

end

action :remove do
  configure_service(:delete)

  directory new_resource.install_dir do
    action :delete
    recursive true
  end

  # Populate the key/value store with the configuration data
  new_resource.config.keys do |key|
    path = config_key_path(key)
    consul_kv key do
      action :delete
      path path
      consul_addr new_resource.consul_addr
    end
  end
end

action :start do
  svc = service new_resource.service_name do
    action [:start, :enable]
  end
  new_resource.updated_by_last_action(svc.updated_by_last_action?)
end

action :stop do
  svc = service service new_resource.service_name do
    action [:stop, :disable]
  end
  new_resource.updated_by_last_action(svc.updated_by_last_action?)
end

def configure_service(action = :create)  # rubocop:disable Metrics/AbcSize
  svc = service_factory new_resource.service_name do
    service_desc 'A simple daemon to send notifications based on Consul health checks'
    exec bin_path
    action action
    run_user new_resource.user
    run_group new_resource.group
    log_what :std_all
    exec_args [
      'start',
      "--alert-addr=#{new_resource.bind_addr}:#{new_resource.port}",
      "--consul-addr=#{new_resource.consul_addr}",
      "--consul-dc=#{new_resource.consul_dc}"
    ]
  end
  new_resource.updated_by_last_action(svc.updated_by_last_action?)
end

private

# Return the full key path for a configuration entry in the k/v store
# simply prepends `consul-alerts/config` to the partial path supplied
#
# @param [String] The partial path relative to `consul-alerts/config` at which
#   the configuration key will be created
def config_key_path(partial_path)
  "consul-alerts/config/#{partial_path}"
end
