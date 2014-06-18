#!/bin/bash
#
# This is an opinionated install of Puppet 2.7.x and associated modules for a
# Puppet Master. Only PUPPET and FACTER are required for a client.

apt-get install -y rubygems1.8 augeas-tools libaugeas-ruby1.8

[ -d /etc/facter/facts.d ] || mkdir -p /etc/facter/facts.d


FACTER_VER=$(facter --version 2>/dev/null)
if [ "$FACTER_VER" != "1.7.3" ]; then
    gem install -r --no-rdoc --no-ri facter --version 1.7.3
fi
PUPPET_VER=$(puppet --version 2>/dev/null)
if [ "$PUPPET_VER" != "2.7.23" ]; then
    gem install -r --no-rdoc --no-ri puppet --version 2.7.23
fi

if ! id puppet 2>&1 > /dev/null ; then
    puppet master --mkusers
    killall -9 puppet
fi
