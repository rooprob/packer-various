#!/bin/bash
#
# This is an opinionated install of Puppet 2.7.x and associated modules for a
# Puppet Master. This puppet master uses Hiera and EYAML.

# You must install puppet-client.sh script first.

HIERA_VER=$(hiera --version 2>/dev/null)
if [ "$HIERA_VER" != "1.2.1" ]; then
    gem install -r --no-rdoc --no-ri hiera --version 1.2.1
    gem install -r --no-rdoc --no-ri hiera-puppet --version 1.0.0
    gem install -r --no-rdoc --no-ri deep_merge --version 1.0.0
    gem install -r --no-rdoc --no-ri ya2yaml --version 0.31
fi
EYAML_VER=$(eyaml --version 2>/dev/null)
if [ "$EYAML_VER" != "Hiera-eyaml version 1.3.8" ]; then
    gem install -r --no-rdoc --no-ri hiera-eyaml --version 1.3.8
    gem install -r --no-rdoc --no-ri hiera-eyaml-gpg --version 0.2
fi

