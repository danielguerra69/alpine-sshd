# Alpine ssh server

For X forwarding check
https://hub.docker.com/r/danielguerra/alpine-sshdx/

## Instructions

### Key based usage (prefered)

Create a key with ssh-keygen.
Copy the id_rsa.pub from your workstation to your dockerhost.

There are 2 options.

#### 1 Mount your pub file
The easy way is to use -v id_rsa.pub:/root/.ssh/authorized_keys
later on with start sshd service

#### 2 Create a volume for authorized_keys
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

ssh to your new docker environment, with an agent -i option is not needed
```bash
ssh -p 4848 -i id_rsa root@<dockerhost>
```

### Export

to export this host
``bash
docker export alpine-sshd -o alpine-sshd
```

### Vitualbox import
```bash
dd if=/dev/zero of=disk.img bs=1 count=0 seek=20
