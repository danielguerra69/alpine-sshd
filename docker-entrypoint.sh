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

#prepare sshd config
 sed -i "s/UsePrivilegeSeparation/#UsePrivilegeSeparation/g" /etc/ssh/sshd_config \
 && sed -i "s/#UsePAM/UsePAM/g" /etc/ssh/sshd_config \
 && sed -i "s/#PermitRootLogin/PermitRootLogin/g" /etc/ssh/sshd_config \
 && sed -i "s/#RSAAuthentication/RSAAuthentication/g" /etc/ssh/sshd_config \
 && sed -i "s/#PubkeyAuthentication/PubkeyAuthentication/g" /etc/ssh/sshd_config \
 && sed -i "s/#AuthorizedKeysFile/AuthorizedKeysFile/g" /etc/ssh/sshd_config

exec "$@"
