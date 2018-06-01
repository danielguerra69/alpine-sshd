# Alpine ssh server

## Instructions

### Key based usage (prefered)

Copy the id_rsa.pub from your workstation to your dockerhost.
On the dockerhost create a volume to keep your authorized_keys.
```bash
tar cv --files-from /dev/null | docker import - scratch
docker create -v /root/.ssh --name ssh-container scratch /bin/true
docker cp id_rsa.pub ssh-container:/root/.ssh/authorized_keys
```

For ssh key forwarding use ssh-agent on your workstation.
```bash
ssh-agent
ssh-add id_rsa
```

Then the start sshd service on the dockerhost (check the tags for alpine versions)
```bash
docker run -p 4848:22 --name alpine-sshd --hostname alpine-sshd --volumes-from ssh-container  -d danielguerra/alpine-sshd
```

### Password based

```bash
docker run -p 4848:22 --name alpine-sshd --hostname alpine-sshd -d danielguerra/alpine-sshd
docker exec -ti alpine-sshd passwd
```

### From your workstation

ssh to your new docker environment, with an agent the -i option is not needed
```bash
ssh -p 4848 -i id_rsa root@<dockerhost>
```
