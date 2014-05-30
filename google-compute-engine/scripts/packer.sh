#!/bin/bash -eux

apt-get -q -y install unzip

packer_version=0.5.2
wget -q "https://dl.bintray.com/mitchellh/packer/${packer_version}_linux_amd64.zip" \
     -O /tmp/packer-${packer_version}.zip
(cd /tmp && unzip -o -qq packer-$packer_version.zip -d /usr/local/bin/)
rm -rf /tmp/packer-${packer_version}.zip