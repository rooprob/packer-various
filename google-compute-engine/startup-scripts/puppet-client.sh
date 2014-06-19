#!/bin/bash
#
# General installation set up for a node being added to a Puppet Master.
# Configuration is determined via Facter Facts passed in to the gceutil
# addinstance.
#
# Author: Robert Fielding <fieldingrp@gmail.com>
# Date: 20140603

set -x

# read from metadata service
# gcutil addinstance --metadata='ENVIRONMENT:devel'
for var in ENVIRONMENT INSTALLATION LOCATION REGION ROLE PUPPET_MASTER PUPPET_CA; do
    eval $var=$(curl http://metadata/computeMetadata/v1beta1/instance/attributes/$var)
    export $var
done;

umask 0027

# Installation Errata
# kill any lingering
killall -9 puppet

# reinitialize puppet installation
rm -fr /var/lib/puppet
rm -fr /etc/puppet
mkdir -p /var/lib/puppet/ssl/certs
mkdir /etc/puppet

cat > /var/lib/puppet/ssl/certs/ca.pem<<EOF
# <Insert your site's PEM Encoded Certificate HERE>
EOF

cat > /etc/puppet/puppet.conf<<EOF
[main]
        logdir = /var/log/puppet
        vardir = /var/lib/puppet
        ssldir = /var/lib/puppet/ssl
        rundir = /var/run/puppet
        factpath = \$vardir/lib/facter
        templatedir = \$confdir/templates

[agent]
        http_compression= true
        environment = $ENVIRONMENT
        report = false
        pluginsync = true
        server = $PUPPET_MASTER
        ca_server = $PUPPET_CA
        configtimeout = 300
EOF

chown -R puppet:puppet /var/lib/puppet
chown -R puppet:puppet /etc/puppet

umask 0022
mkdir -p /etc/facter/facts.d
cat >/etc/facter/facts.d/etp_infra.yaml<<EOF
# This file has been provisioned automatically
"infra_installation": $INSTALLATION
"infra_region": $REGION
"infra_location": $LOCATION
"infra_roles": $ROLE
"infra_lifecycle": build
"infra_environment": $ENVIRONMENT
EOF

cat >/root/puppet-first-run.sh<<EOF
# Start three shots of the agent
# Your Action (as per your policy):
# Spin up a terminal to the puppet master to enable the IP address and puppet ca sign <fqdn>.

counter=3
while [ \$counter -gt 0 ]; do
    puppet agent --waitforcert 120 --no-daemonize --onetime --environment $ENVIRONMENT -t || \
        {
            rc=\$?
            logger -p user.info -t \$0 "puppet run returned: \$rc"
        }
        sleep 30
        ((counter --))
done;
EOF
chmod 0700 /root/puppet-first-run.sh

/root/puppet-first-run.sh
