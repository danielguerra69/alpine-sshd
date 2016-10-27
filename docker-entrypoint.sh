#!/bin/sh

if [ ! -f "/etc/ssh/ssh_host_rsa_key" ]; then
	# generate fresh rsa key
	ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa
fi
if [ ! -f "/etc/ssh/ssh_host_dsa_key" ]; then
	# generate fresh dsa key
	ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N '' -t dsa
fi

#prepare run dir
if [ ! -d "/var/run/sshd" ]; then
  mkdir -p /var/run/sshd
fi

# Prepare authorization_keys file from environment variable
if [ ! -z "$AUTHORIZED_KEYS" ]; then
  echo "Creating /root/.ssh/authorized_keys file..."

  mkdir -p /root/.ssh
  echo "$AUTHORIZED_KEYS" > /root/.ssh/authorized_keys
fi

exec "$@"
