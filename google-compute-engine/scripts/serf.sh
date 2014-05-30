#!/bin/bash -eux

apt-get -q -y install unzip

serf_version=0.5.0
wget -q "https://dl.bintray.com/mitchellh/serf/${serf_version}_linux_amd64.zip" \
     -O /tmp/packer-${serf_version}.zip
(cd /tmp && unzip -o -qq serf-$serf_version.zip -d /usr/local/bin/)
rm -rf /tmp/serf-${serf_version}.zip