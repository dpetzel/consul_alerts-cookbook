require_relative './spec_helper'

describe 'consul_alerts_test::default' do
  describe service('consul-alerts') do
    it { should_not be_enabled }
    it { should_not be_running }
  end

  describe service('consul-alerts-0.1.0') do
    it { should be_enabled }
    it { should be_running }
  end

  describe port(9000) do
    it { should_not be_listening }
  end
  describe port(9001) do
    it { should be_listening }
  end

  describe file('/tmp/consul_alerts/specific_version/consul-alerts') do
    it { should be_file }
  end

  describe file('/tmp/consul_alerts/should_get_deleted/consul-alerts') do
    it { should_not be_file }
  end
end
