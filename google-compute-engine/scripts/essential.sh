#!/bin/bash
# Opinionated essential packages

apt-get -y install git git-core vim python rsync


cat > /etc/motd <<EOF
*****************************************************
*           m a c h i n e   b u i l d               *
*****************************************************
EOF
