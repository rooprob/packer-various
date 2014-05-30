#!/bin/bash

apt-get install -y rubygems1.8 augeas-tools libaugeas-ruby1.8

[ -d /etc/facter/facts.d ] || mkdir -p /etc/facter/facts.d

HIERA_VER=$(hiera --version 2>/dev/null)
if [ "$HIERA_VER" != "1.2.1" ]; then
    gem install -r --no-rdoc --no-ri hiera --version 1.2.1
    gem install -r --no-rdoc --no-ri hiera-puppet --version 1.0.0
    gem install -r --no-rdoc --no-ri deep_merge --version 1.0.0
    gem install -r --no-rdoc --no-ri ya2yaml --version 0.31
fi

FACTER_VER=$(facter --version 2>/dev/null)
if [ "$FACTER_VER" != "1.7.3" ]; then
    gem install -r --no-rdoc --no-ri facter --version 1.7.3
fi
PUPPET_VER=$(puppet --version 2>/dev/null)
if [ "$PUPPET_VER" != "2.7.23" ]; then
    gem install -r --no-rdoc --no-ri puppet --version 2.7.23
fi
EYAML_VER=$(eyaml --version 2>/dev/null)
if [ "$EYAML_VER" != "Hiera-eyaml version 1.3.8" ]; then
    gem install -r --no-rdoc --no-ri hiera-eyaml --version 1.3.8
    gem install -r --no-rdoc --no-ri hiera-eyaml-gpg --version 0.2
fi

if ! id puppet 2>&1 > /dev/null ; then
    groupadd puppet
    useradd -g puppet -s /sbin/puppet -d /var/lib/puppet puppet
fi
