# Consul-Alerts Cookbook
This cookbook provides an LWRP as well as a sample recipe for managing
[consul-alerts](https://github.com/AcalephStorage/consul-alerts)

## Requirements
* Chef 11+
* A working [Consul](https://consul.io/) installation

## Supported Platforms
The following is a list of platforms that the cookbook is regularly tested on.
It is likely it runs on other platform combinations as well, but only those
that are regularly tested on will be declared *supported*:

* EL6 (tested using Centos)
* Ubuntu 14.04

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
* `version` - Which version of `consul-alerts` to install
    * Default: 0.1.1
* `install_dir` - The directory into which `consul-alerts` will be installed
    * Default: /usr/local/consul-alerts
* `user` - The user account under which the daemon will be run
    * Default: consul-alerts
* `group` - The group under which the daemon will be run
    * Default: consul-alerts
* `service_name` - The name of the service to give the daemon
    * Default: consul-alerts
* `consul_addr` - The address of the consul HTTP API
    * Default: localhost:8500
* `consul_dc` - The consul datacenter to use
    * Default: dc1
* `port` - The TCP port on which the daemon will listen
    * Default: 9000
* `base_url` - The base URL from which `consul-alerts` can be downloaded
    * Default: http://dl.bintray.com/darkcrux/generic
* `checksums` - A Hash of known Checksums for the various downloadable files.
  It is unlikely you need (or want) to adjust this, however if for some reason
  you need to override, or add additional checksums, you can do so here.


