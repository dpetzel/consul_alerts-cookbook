require_relative '../spec_helper'

describe 'consul_alerts::default' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(step_into: ['consul_alerts']) do |node|
      node.set[:consul_alerts][:version] = '0.1.1'
    end.converge(described_recipe)
  end

  it 'invokes the consul-alerts LWRP' do
    expect(chef_run).to create_consul_alerts('consul-alerts')
    expect(chef_run).to start_consul_alerts('consul-alerts')
  end

  it 'installs the tar package' do
    expect(chef_run).to install_package('tar')
  end

  it 'creates the service' do
    expect(chef_run).to create_service_factory('consul-alerts')
  end

  it 'starts the service' do
    expect(chef_run).to start_service('consul-alerts')
  end

  it 'creates the service user' do
    expect(chef_run).to create_user('consul-alerts')
  end

  it 'creates the service group' do
    expect(chef_run).to create_group('consul-alerts')
  end

  it 'creats the service directory' do
    expect(chef_run).to create_directory('/usr/local/consul-alerts')
  end

  it 'downloads the tarball' do
    expect(chef_run).to create_remote_file('consul-alerts-tar').with(path:
      ::File.join(Chef::Config[:file_cache_path], 'consul-alerts-0.1.1-linux-amd64.tar'))
  end

  it 'extracts the tarball' do
    expect(chef_run).to run_execute('untar_consul-alerts')
  end

  it 'sets configuration data into the key/value store' do
    expect(chef_run).to create_consul_kv(
      'checks/enabled').with(value: 'true')
    expect(chef_run).to create_consul_kv(
      'checks/change-threshold').with(value: '60')
    expect(chef_run).to create_consul_kv(
      'events/enabled').with(value: 'true')
    expect(chef_run).to create_consul_kv(
      'notifiers/log/enabled').with(value: 'true')
    expect(chef_run).to create_consul_kv(
      'notifiers/log/path').with(value: '/var/log/consul-notifications.log')
  end
end
