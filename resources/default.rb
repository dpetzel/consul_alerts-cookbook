actions :create, :remove, :start, :stop
default_action :create

attribute :version,
          kind_of: String,
          default: '0.1.1'

attribute :install_dir,
          kind_of: String,
          default: '/usr/local/consul-alerts'

attribute :user,
          kind_of: String,
          default: 'consul-alerts'

# The group which the consul-alerts daemon will run as
attribute :group,
          kind_of: String,
          default: 'consul-alerts'

attribute :service_name,
          kind_of: String,
          default: 'consul-alerts'

attribute :consul_addr,
          kind_of: String,
          default: '127.0.0.1:8500'

attribute :consul_dc,
          kind_of: String,
          default: 'dc1'

attribute :port,
          kind_of: Fixnum,
          default: 9000

attribute :bind_addr,
          kind_of: String,
          default: '0.0.0.0'

attribute :base_url,
          kind_of: String,
          default: 'http://dl.bintray.com/darkcrux/generic'

attribute :checksums,
          kind_of: Hash,
          default: {
            'consul-alerts-0.1.0-darwin-amd64.tar' =>
              'c8741ca8ec843a663c34a26f038e32ee25b89b0e063a08e1b234870dff923ab1',
            'consul-alerts-0.1.0-linux-386.tar' =>
              '4253b3d091f4810e938fc79715254c0498bb71fcbc70156f1ea4a7b371d77e86',
            'consul-alerts-0.1.0-linux-amd64.tar' =>
              '438ac92588affa856069d7b117f7aee9528b8319b27e54b969d4cd6ef25c1cc0',
            'consul-alerts-0.1.1-darwin-amd64.tar' =>
              'a936bc4c71a7768ceec40ddb4539fe3332bcf2e1cba61d9ef867911780a5a59b',
            'consul-alerts-0.1.1-linux-386.tar' =>
              '4e3e697ead0509d04fb43e5056692bab8d037f706ad682e64aba8083dcabdec4',
            'consul-alerts-0.1.1-linux-amd64.tar' =>
              'c6a4a39f4c17770bd2d9b552e0baad07fe8c8a7d153ec29efcad41b595210a62'
          }
attribute :config,
          kind_of: Hash,
          default: {
            'checks/enabled' => 'true',
            'checks/change-threshold' => '60',
            'events/enabled' => 'true',
            'notifiers/log/enabled' => 'true',
            'notifiers/log/path' => '/var/log/consul-notifications.log'
          }

attr_accessor :tarfile_url, :tarfile_name

def tarfile_name
  "consul-alerts-#{version}-#{node[:os]}-#{arch}.tar"
end

def arch
  node[:kernel][:machine] =~ /x86_64/ ? 'amd64' : '386'
end

def tarfile_url
  "#{base_url}/#{tarfile_name}"
end

def tarfile_checksum
  checksums[tarfile_name]
end

def validate_platform!
  valid = false

  case node[:platform_family]
  when 'rhel'
    valid = valid_rhel_version?
  when 'debian'
    valid = valid_debian_version?
  end

  if valid == false
    Chef::Application.fatal!('consul-alerts LWRP not supported on' \
      " #{node[:platform]} #{node[:platform_version]}")
  end
  true
end

def validate_chef_version!
  return true if Chef::Version.new(Chef::VERSION).major >= 11
  Chef::Application.fatal!(
    'The consul-alerts LWRP is only supported on Chef 11 or newer')
end

private

def valid_rhel_version?
  valid = false
  major_ver = node[:platform_version].to_i
  valid = true if major_ver == 6 || major_ver == 5
  valid
end

def valid_debian_version?
  valid = false
  major_ver = node[:platform_version].to_i
  valid = true if node[:platform] == 'ubuntu' && major_ver >= 14
  valid
end
