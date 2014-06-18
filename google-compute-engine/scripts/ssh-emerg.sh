#!/bin/bash
#
# Install another SSH server on a high port. Use this for debugging an install.
# Also see cleanup.sh (userdel) to permit one password based user login.

# Should remove from production (however default security-groups will prevent
# leaving a port open).


cat > /etc/init/ssh-emerg.conf <<EOF
# ssh - OpenBSD Secure Shell server
#
# The OpenSSH server provides secure shell access to the system.

description     "Emergency OpenSSH server"

start on filesystem or runlevel [2345]
stop on runlevel [!2345]

respawn
respawn limit 10 5
umask 022

# 'sshd -D' leaks stderr and confuses things in conjunction with 'console log'
console none

pre-start script
  test -x /usr/sbin/sshd || { stop; exit 0; }

  mkdir -p -m0755 /var/run/sshd
end script

exec /usr/sbin/sshd -f /etc/ssh/sshd_config_emerg -D
EOF

# Emergency ssh access, with known password authentication
cat > /etc/ssh/sshd_config_emerg <<EOF
PasswordAuthentication yes

PermitRootLogin no
PermitTunnel no
AllowTcpForwarding yes
X11Forwarding no

ClientAliveInterval 420

UseDNS no
GSSAPIAuthentication no

Port 2022
HostKey /etc/ssh/ssh_host_rsa_emerg_key
HostKey /etc/ssh/ssh_host_dsa_emerg_key
UsePrivilegeSeparation yes

PidFile /var/run/sshd_emerg.pid
EOF

ssh-keygen -N '' -t dsa -f /etc/ssh/ssh_host_dsa_emerg_key
ssh-keygen -N '' -t rsa -f /etc/ssh/ssh_host_rsa_emerg_key
