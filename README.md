# EVPN Linux Lab



## Intro

This lab was created to help network engineers understand how EVPN works without vendor (Cisco, Arista, Aruba, Juniper, etc) approach and with FRR and Linux only.

For those not aware of FRR, here is a little introduction: [FRR article](docs/FRR-article/README.md)



## Usage

###  Prerequisites

Installation of [VirtualBox](https://www.virtualbox.org/wiki/Downloads), [Packer](https://www.packer.io/downloads), [Vagrant](https://www.vagrantup.com/downloads), [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html), libvirt with the appropriate methods based on your OS.

### Building up

If local Vagrant on MacOS :

```
vagrant up
vagrant ssh
```

On the Linux instance:

```
sudo su
git clone https://github.com/jmanteau/evpn-frr-containerlab.git
cd evpn-frr-containerlab/docker-build
docker build --rm -f Dockerfile_host -t evpnlab-host:latest .
docker build --rm -f Dockerfile_net -t evpnlab-net:latest .
```

```
cd ..
containerlab deploy --topo evpnlab.yml

INFO[0000] Parsing & checking topology file: evpnlab.yml
INFO[0000] Destroying container lab: evpnlab
INFO[0001] Removed container: clab-evpnlab-leaf3
INFO[0001] Removed container: clab-evpnlab-leaf2
INFO[0001] Removed container: clab-evpnlab-h0
INFO[0001] Removed container: clab-evpnlab-spline1
INFO[0002] Removed container: clab-evpnlab-h31
INFO[0002] Removed container: clab-evpnlab-firewall
INFO[0002] Removed container: clab-evpnlab-core
INFO[0002] Removed container: clab-evpnlab-h13
INFO[0002] Removed container: clab-evpnlab-h21
INFO[0002] Removed container: clab-evpnlab-leaf1
INFO[0002] Removed container: clab-evpnlab-borderleaf
INFO[0002] Removed container: clab-evpnlab-h11
INFO[0002] Removed container: clab-evpnlab-h12
INFO[0002] Removed container: clab-evpnlab-h22
INFO[0002] Removed container: clab-evpnlab-spline2
INFO[0002] Removing container entries from /etc/hosts file
INFO[0002] Deleting docker network 'clab'...
INFO[0003] Removing /home/vagrant/evpn-frr-containerlab/clab-evpnlab directory...
INFO[0003] Creating lab directory: /home/vagrant/evpn-frr-containerlab/clab-evpnlab
INFO[0003] Creating docker network: Name='clab', IPv4Subnet='172.20.20.0/24', IPv6Subnet='2001:172:20:20::/80', MTU='1500'
INFO[0003] Creating container: spline1
INFO[0003] Creating container: borderleaf
INFO[0003] Creating container: spline2
INFO[0003] Creating container: h13
INFO[0003] Creating container: h31
INFO[0003] Creating container: h12
INFO[0003] Creating container: core
INFO[0003] Creating container: h21
INFO[0003] Creating container: leaf1
INFO[0003] Creating container: h22
INFO[0003] Creating container: h11
INFO[0003] Creating container: firewall
INFO[0003] Creating container: h0
INFO[0003] Creating container: leaf2
INFO[0003] Creating container: leaf3
INFO[0010] Creating virtual wire: h11:eth1 <--> leaf1:eth1
INFO[0010] Creating virtual wire: borderleaf:swp1 <--> spline1:swp4
INFO[0010] Creating virtual wire: h22:eth1 <--> leaf3:eth2
INFO[0010] Creating virtual wire: leaf1:swp1 <--> spline1:swp1
INFO[0010] Creating virtual wire: leaf2:swp2 <--> spline2:swp2
INFO[0010] Creating virtual wire: h12:eth1 <--> leaf2:eth1
INFO[0010] Creating virtual wire: h13:eth1 <--> leaf3:eth1
INFO[0010] Creating virtual wire: leaf3:swp2 <--> spline2:swp3
INFO[0010] Creating virtual wire: core:swp2 <--> firewall:swp2
INFO[0010] Creating virtual wire: h31:eth1 <--> leaf3:eth3
INFO[0010] Creating virtual wire: h0:eth1 <--> core:eth1
INFO[0010] Creating virtual wire: leaf1:swp2 <--> spline2:swp1
INFO[0010] Creating virtual wire: leaf2:swp1 <--> spline1:swp2
INFO[0010] Creating virtual wire: borderleaf:swp2 <--> spline2:swp4
INFO[0010] Creating virtual wire: core:swp1 <--> borderleaf:swp3
INFO[0010] Creating virtual wire: firewall:swp1 <--> borderleaf:swp4
INFO[0010] Creating virtual wire: h21:eth1 <--> leaf1:eth2
INFO[0010] Creating virtual wire: leaf3:swp1 <--> spline1:swp3
INFO[0011] Writing /etc/hosts file
+----+-------------------------+--------------+---------------------+-------+-------+---------+-----------------+-----------------------+
| #  |          Name           | Container ID |        Image        | Kind  | Group |  State  |  IPv4 Address   |     IPv6 Address      |
+----+-------------------------+--------------+---------------------+-------+-------+---------+-----------------+-----------------------+
|  1 | clab-evpnlab-borderleaf | c4440aded8a5 | evpnlab-net:latest  | linux |       | running | 172.20.20.5/24  | 2001:172:20:20::5/80  |
|  2 | clab-evpnlab-core       | 2dd17d8e1ae6 | evpnlab-net:latest  | linux |       | running | 172.20.20.4/24  | 2001:172:20:20::4/80  |
|  3 | clab-evpnlab-firewall   | 07b6fb83e599 | evpnlab-net:latest  | linux |       | running | 172.20.20.15/24 | 2001:172:20:20::f/80  |
|  4 | clab-evpnlab-h0         | 42826f68a833 | evpnlab-host:latest | linux |       | running | 172.20.20.13/24 | 2001:172:20:20::d/80  |
|  5 | clab-evpnlab-h11        | c8e44bbc661b | evpnlab-host:latest | linux |       | running | 172.20.20.11/24 | 2001:172:20:20::b/80  |
|  6 | clab-evpnlab-h12        | 189844cac7f6 | evpnlab-host:latest | linux |       | running | 172.20.20.9/24  | 2001:172:20:20::9/80  |
|  7 | clab-evpnlab-h13        | 726400b938cc | evpnlab-host:latest | linux |       | running | 172.20.20.10/24 | 2001:172:20:20::a/80  |
|  8 | clab-evpnlab-h21        | a295a1248afe | evpnlab-host:latest | linux |       | running | 172.20.20.3/24  | 2001:172:20:20::3/80  |
|  9 | clab-evpnlab-h22        | eef33cdbe573 | evpnlab-host:latest | linux |       | running | 172.20.20.14/24 | 2001:172:20:20::e/80  |
| 10 | clab-evpnlab-h31        | 384154762ad3 | evpnlab-host:latest | linux |       | running | 172.20.20.16/24 | 2001:172:20:20::10/80 |
| 11 | clab-evpnlab-leaf1      | 24e143253e51 | evpnlab-net:latest  | linux |       | running | 172.20.20.7/24  | 2001:172:20:20::7/80  |
| 12 | clab-evpnlab-leaf2      | 2e67e4ff473e | evpnlab-net:latest  | linux |       | running | 172.20.20.8/24  | 2001:172:20:20::8/80  |
| 13 | clab-evpnlab-leaf3      | 34fc83c8defe | evpnlab-net:latest  | linux |       | running | 172.20.20.12/24 | 2001:172:20:20::c/80  |
| 14 | clab-evpnlab-spline1    | 766df70d841d | evpnlab-net:latest  | linux |       | running | 172.20.20.6/24  | 2001:172:20:20::6/80  |
| 15 | clab-evpnlab-spline2    | 33c47fb69ef8 | evpnlab-net:latest  | linux |       | running | 172.20.20.2/24  | 2001:172:20:20::2/80  |
+----+-------------------------+--------------+---------------------+-------+-------+---------+-----------------+-----------------------+
```

```
#  docker exec -it clab-evpnlab-leaf1 /bin/bash
/ # vtysh
% Can't open configuration file /etc/frr/vtysh.conf due to 'No such file or directory'.

Hello, this is FRRouting (version 7.5).
Copyright 1996-2005 Kunihiro Ishiguro, et al.

leaf1# show
babel             debugging         interface         logging           nexthop-group     router-id         version           work-queues
bfd               dmvpn             ip                mac               openfabric        rpki              vnc               yang
bgp               error             ipv6              memory            pbr               running-config    vrf               zebra
bmp               evpn              isis              modules           route-map         startup-config    vrrp
daemons           fpm               l2vpn             mpls              route-map-unused  thread            watchfrr
leaf1# show interface
brief          eth0           eth2           nexthop-group  swp2
description    eth1           lo             swp1           vrf
leaf1# show interface
  <cr>
  IFNAME         Interface name
     eth0 eth1 eth2 lo swp1 swp2
  brief          Interface status and configuration summary
  description    Interface description
  nexthop-group  Show Nexthop Groups
  vrf            Specify the VRF
leaf1# show interface brief
Interface       Status  VRF             Addresses
---------       ------  ---             ---------
eth0            up      default         172.20.20.7/24
                                        + 2001:172:20:20::7/80
eth1            up      default
eth2            up      default
lo              up      default
swp1            up      default
swp2            up      default
```

```
containerlab destroy --topo
```

```
for vni in 10 20 30; do
    # Create VXLAN interface
    ip link add vxlan${vni} type vxlan
    # Create companion bridge
    brctl addbr br${vni}
    brctl addif br${vni} vxlan${vni}
    brctl stp br${vni} off
    ip link set up dev br${vni}
    ip link set up dev vxlan${vni}

```





### Draft

```

docker import cEOS-lab.tar.xz ceosimage:4.21.0F
docker exec -it ceos1 Cli
```

![img](../epvn-linux-lab/README.assets/3d.jpg)

### Linux networking ressources

[Linux Network interfaces Intro](docs/Linux-interfaces/README.md)

[Iproute2-cheatsheet](docs/Iproute2-cheatsheet/README.md) (latest version [here](https://baturin.org/docs/iproute2/))



## Done with the following ressources

https://gitlab.com/cumulus-consulting/tools/topology_converter

https://github.com/bobfraser1/packer-alpine

https://cumulusnetworks.com/blog/evpn-underlay-routing-protocol/ -> 1 one AS per leaf

https://learningnetwork.cisco.com/s/blogs/a0D3i000002eebCEAQ/vxlan-ebgp-evpn-the-incarnation-of-a-hybrid-guest-post -> Multi-AS vs. Dual-AS

https://learningnetwork.cisco.com/s/blogs/a0D3i000002eeaAEAQ/the-magic-of-superspines-and-rfc7938-with-overlays-guest-post

https://netdevconf.info/2.2/slides/prabhu-linuxbridge-tutorial.pdf

https://techbloc.net/archives/2449

https://docs.frrouting.org/en/latest/basic.html

https://gitlab.com/cumulus-consulting/goldenturtle/cumulus_ansible_modules/-/tree/master/roles

https://metal.equinix.com/developers/docs/networking/route-bgp-with-frr/

https://www.jasonvanpatten.com/2018/08/16/evpn-and-vxlan-on-cumulus/

https://git.proxmox.com/?p=pve-docs.git;a=blob_plain;f=vxlan-and-evpn.adoc;hb=HEAD

https://github.com/FRRouting/frr/issues/5113

https://icicimov.github.io/blog/virtualization/Overlay-SDN-with-VxLAN-BGP-EVPN-and-FRR/

https://vincent.bernat.ch/fr/blog/2017-vxlan-bgp-evpn

https://www.arista.com/assets/data/pdf/Whitepapers/Arista_Design_Guide_DCI_with_VXLAN.pdf

