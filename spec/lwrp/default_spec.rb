require_relative '../spec_helper'

describe 'consul_alerts::default' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(step_into: ['consul_alerts']) do |node|
      node.set[:consul_alerts][:version] = '0.1.1'
    end.converge(described_recipe)
  end

  it 'does something' do
    expect(chef_run).to create_remote_file('consul-alerts-tar').with(path:
      ::File.join(Chef::Config[:file_cache_path], 'consul-alerts-0.1.1-linux-amd64.tar'))
  end
end
