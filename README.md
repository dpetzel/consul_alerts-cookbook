# Consul-Alerts Cookbook
This cookbook provides an LWRP as well as a sample recipe for managing
[consul-alerts](https://github.com/AcalephStorage/consul-alerts)

[![Build Status](https://api.shippable.com/projects/54597b1aa85d45d063d9033a/badge?branchName=master)](https://app.shippable.com/projects/54597b1aa85d45d063d9033a/builds/latest)


## Requirements
* Chef 11+
* A working [Consul](https://consul.io/) installation

## Supported Platforms
The following is a list of platforms that the cookbook is regularly tested on.
It is likely it runs on other platform combinations as well, but only those
that are regularly tested on will be declared *supported*:

* EL6 (tested using Centos)
* EL5 (tested using Centos)

## Usage
The simplest way to get started is to add `recipe[consul-alerts]` to a node's
run_list that already has consul installed. This will invoke the default
recipe which simply calls the LWRP with a very minimal set of options. Odd's
are that you environment is a little more complex, and you'll likely want to
write a wrapper cookbook/recipe that invokes the LWRP with settings appropriate
for your environment

## LWRP
The cookbook provides a `consul_alert` LWRP which is used to install and manage
the `consul-alerts` daemon

### Actions
* `:create` - This will install the necessary components to run the daemon.
* `:remove` - This will remove any components that were installed by the LWRP.
* `:start` - This will start the daemon on the host. It will also be configured
  to start on boot.
* `:stop` - This will stop the daemon on the host. It will also **disable**
  start on boot.

### Attributes
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>version</tt></td>
    <td>String</td>
    <td>Which version of `consul-alerts` to install</td>
    <td><tt>0.1.1</tt></td>
  </tr>
  <tr>
    <td><tt>install_dir</tt></td>
    <td>String</td>
    <td>The directory into which `consul-alerts` will be installed</td>
    <td><tt>/usr/local/consul-alerts</tt></td>
  </tr>
  <tr>
    <td><tt>user</tt></td>
    <td>String</td>
    <td>The user account under which the daemon will be run</td>
    <td><tt>consul-alerts</tt></td>
  </tr>
  <tr>
    <td><tt>group</tt></td>
    <td>String</td>
    <td>The group under which the daemon will be run</td>
    <td><tt>consul-alerts</tt></td>
  </tr>
  <tr>
    <td><tt>service_name</tt></td>
    <td>String</td>
    <td>The name of the service to give the daemon</td>
    <td><tt>consul-alerts</tt></td>
  </tr>
  <tr>
    <td><tt>consul_addr</tt></td>
    <td>String</td>
    <td>The address of the consul HTTP API</td>
    <td><tt>127.0.0.1:8500</tt></td>
  </tr>  
  <tr>
    <td><tt>consul_dc</tt></td>
    <td>String</td>
    <td>The consul datacenter to use</td>
    <td><tt>dc1</tt></td>
  </tr>
  <tr>
    <td><tt>port</tt></td>
    <td>Fixnum</td>
    <td>The TCP port on which the daemon will listen</td>
    <td><tt>9000</tt></td>
  </tr>
  <tr>
    <td><tt>base_url</tt></td>
    <td>String</td>
    <td>The base URL from which `consul-alerts` can be downloaded</td>
    <td><tt>http://dl.bintray.com/darkcrux/generic</tt></td>
  </tr>
  <tr>
    <td><tt>checksums</tt></td>
    <td>Hash</td>
    <td>A Hash of known Checksums for the various downloadable files.
      It is unlikely you need (or want) to adjust this, however if for some 
      reason you need to override, or add additional checksums, you can do so 
      here.
    </td>
    <td>Refer to the `resource/default.rb`</td>
  </tr>
  <tr>
    <td><tt>config</tt></td>
    <td>Hash</td>
    <td>A Hash of configuration key/value pairs that will be inserted into the
      Consul Key/Value store.
    </td>
    <td><tt>
      'checks/enabled' => 'true',
      'checks/change-threshold' => '60',
      'events/enabled' => 'true',
      'notifiers/log/enabled' => 'true',
      'notifiers/log/path' => '/var/log/consul-notifications.log'    
    </tt></td>
  </tr>
</table>

## Contributing
1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Testing

This cookbook currently uses [test-kitchen](https://github.com/opscode/test-kitchen)
along with [ChefSpec](https://docs.getchef.com/chefspec.html).

Test Kitchen: `kitchen test`

ChefSpec: `bundle exec rspec`

## Releasing
This cookbook uses an 'even number' release strategy. The version number in master
will always be an odd number indicating development, and an even number will
be used when an official build is released.

Come release time here is the checklist:

* Ensure the `metadata.rb` reflects the proper *even* numbered release
* Ensure there is a *dated* change log entry in `CHANGELOG.md`
* Commit all the changes
* Use stove to release (`bundle exec stove`)
* Bump the version in metadata.rb to the next *patch level* odd number

## Authors
- Author: David Petzel (<davidpetzel@gmail.com>)

