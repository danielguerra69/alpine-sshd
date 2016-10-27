# Instructions

## Key based usage (prefered)

### Your public key only in the authorization_keys

```docker run -dtP -e "AUTHORIZED_KEYS=`cat ~/.ssh/id_rsa.pub`" danielguerra/alpine-sshd```

### Use a sample authorized_keys in the container

docker run -dtP -e "AUTHORIZED_KEYS=`cat ~/.ssh/authorized_keys`" danielguerra/alpine-sshd

### Use a container volume

Copy the id_rsa.pub from your workstation to your dockerhost.
On the dockerhost create a volume to keep your authorized_keys.
```bash
tar cv --files-from /dev/null | docker import - scratch
docker create -v /root/.ssh --name ssh-container scratch /bin/true
docker cp id_rsa.pub ssh-container:/root/.ssh/authorized_keys
```

Then the start sshd service on the dockerhost (check the tags for alpine versions)
```bash
docker run -p 4848:22 --name alpine-sshd --hostname alpine-sshd --volumes-from ssh-container  -d danielguerra/alpine-sshd
```

## Password based

```bash
docker run -p 4848:22 --name alpine-sshd --hostname alpine-sshd -d danielguerra/alpine-sshd
docker exec -ti docker-sshd passwd
```

## From your workstation

For ssh key forwarding use ssh-agent
```bash
ssh-agent
ssh-add id_rsa
```

ssh to your new docker environment, with an agent -i option is not needed
```bash
ssh -p 4848 -i id_rsa root@<dockerhost>
```
