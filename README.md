# EVPN Linux Lab



## Intro

This lab was created to help network engineers understand how EVPN works without vendor (Cisco, Arista, Aruba, Juniper, etc) approach and with FRR and Linux only.

For those not aware of FRR, here is a little introduction: [FRR article](docs/FRR-article/README.md)



## Usage

###  Prerequisites

Installation of [VirtualBox](https://www.virtualbox.org/wiki/Downloads), [Packer](https://www.packer.io/downloads), [Vagrant](https://www.vagrantup.com/downloads), [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html), libvirt with the appropriate methods based on your OS.

### Building up

If local Vagrant on Mac os :

```
vagrant up
vagrant ssh
```

On the Linux instance:

```
cd docker-build
docker build --rm -f Dockerfile_host -t evpnlab-host:latest .
docker build --rm -f Dockerfile_net -t evpnlab-net:latest .
```





### Configuration

```

FROM alpine:latest
MAINTAINER Julien MANTEAU
LABEL Name=alpine-netlab Version=1.0.0
RUN apk update
RUN apk add sudo
RUN apk add nmap tshark tcpdump frr frr-pythontools mtr iperf iperf3 htop bind-tools fping curl openssh supervisor bash tini --no-cache && rm -f /var/cache/apk/*
COPY ./docker-entrypoint.sh /
ENTRYPOINT [ "/sbin/tini", "--", "docker-entrypoint.sh" ]


docker build -t alpine-netlab:latest .
docker run -it --rm alpine-netlab /bin/ash


docker import cEOS-lab.tar.xz ceosimage:4.21.0F


containerlab deploy --topo lab.yml


 docker exec -it ceos1 Cli
 
 docker exec -it clab-evpnlab-leaf1 /bin/ash
```

![img](../epvn-linux-lab/README.assets/3d.jpg)

### Linux networking ressources

[Linux Network interfaces Intro](docs/Linux-interfaces/README.md)

[Iproute2-cheatsheet](docs/Iproute2-cheatsheet/README.md) (latest version [here](https://baturin.org/docs/iproute2/))



## Done with the following ressources

https://gitlab.com/cumulus-consulting/tools/topology_converter

https://github.com/bobfraser1/packer-alpine

https://ahmet.im/blog/minimal-init-process-for-containers/





