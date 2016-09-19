FROM alpine:3.4
MAINTAINER Daniel Guerra <daniel.guerra69@gmail.com>

RUN apk add --update openssh
ADD docker-entrypoint.sh /usr/sbin
#make sure we get fresh keys
RUN rm -rf /etc/ssh/ssh_host_rsa_key /etc/ssh/ssh_host_dsa_key
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["/usr/sbin/sshd","-D"]
