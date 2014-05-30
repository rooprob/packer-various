#!/bin/bash -eux

# Prepare puppetlabs repo
wget http://apt.puppetlabs.com/puppetlabs-release-saucy.deb
dpkg -i puppetlabs-release-saucy.deb
apt-get -y update

# Install puppet/facter
apt-get -y install puppet facter
rm -f puppetlabs-release-saucy.deb