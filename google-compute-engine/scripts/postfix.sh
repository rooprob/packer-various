#!/bin/bash


debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Local only'"
DEBIAN_FRONTEND=noninteractive apt-get -y install postfix
