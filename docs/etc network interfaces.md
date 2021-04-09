

Well, let’s separate it into pieces, to make it easier to understand `/etc/network/interfaces`:

**[Link layer](http://en.wikipedia.org/wiki/Link_Layer)+interface type options (generally the first of each interface stanza and called address family + method by [`interfaces(5)`](https://manpages.debian.org/stretch/ifupdown/interfaces.5.en.html) manpages):**

`auto *interface*` – Start the interface(s) at boot. That’s why the `lo` interface uses this kind of linking configuration.

```
allow-auto *interface*` – Same as `auto
```

`allow-hotplug *interface*` – Start the interface when a "hotplug" event is detected. In the real world, this is used in the same situations as `auto` but the difference is that it will wait for an event like "being detected by udev hotplug api" or "cable linked". See "[Related Stuff(hotplug)](https://unix.stackexchange.com/q/192671/34720)" for additional info.

These options are pretty much "layer 2" options, setting up link  states on interfaces, and are not related with "layer 3" (routing and  addressing). As an example you could have a link aggregation where the  bond0 interface needs to be up whatever the link state is, and its  members could be up after a link state event:

```
auto bond0
iface bond0 inet manual
        down ip link set $IFACE down
        post-down rmmod bonding
        pre-up modprobe bonding mode=4 miimon=200
        up ip link set $IFACE up mtu 9000
        up udevadm trigger

allow-hotplug eth0
iface eth0 inet manual
        up ifenslave bond0 $IFACE
        down ifenslave -d bond0 $IFACE 2> /dev/null

allow-hotplug eth1
iface eth1 inet manual
        up ifenslave bond0 $IFACE
        down ifenslave -d bond0 $IFACE 2> /dev/null
```

So, this way I create a [link aggregation](http://en.wikipedia.org/wiki/Link_Aggregation) and the interfaces will be added to it and removed on cable link states.

**Most common interface types:**

All options below are a suffix to a defined interface (`iface <Interface_family>`). Basically the `iface eth0` creates a [stanza](https://en.wikipedia.org/wiki/Stanza_(computing)) called `eth0` on an Ethernet device. `iface ppp0` should create a [point-to-point](http://en.wikipedia.org/wiki/Point-to-Point_Protocol) interface, and it could have different ways to acquire addresses like `inet wvdial` that will forward the configuration of this interface to `wvdialconf` script. The tuple `inet`/`inet6` + `option` will define the version of the [IP protocol](http://en.wikipedia.org/wiki/Internet_Protocol) that will be used and the way this address will be configured (`static`, `dhcp`, `scripts`...). The [online Debian manuals](https://www.debian.org/doc/manuals/debian-reference/ch05.en.html) will give you more details about this.

Options on Ethernet interfaces:

`inet static` – Defines a static IP address.

`inet manual` – Does not define an IP address for an  interface. Generally used by interfaces that are bridge or aggregation  members, interfaces that need to operate in promiscuous mode (*e.g. port mirroring or network TAPs*), or have a VLAN device configured on them. It's a way to keep the interface up without an IP address.

`inet dhcp` – Acquire IP address through DHCP protocol.

`inet6 static` – Defines a static IPv6 address.

Example:

```
# Eth0
auto eth0
iface eth0 inet manual
    pre-up modprobe 8021q
    pre-up ifconfig eth0 up
    post-down ifconfig eth0 down

# Vlan Interface
auto vlan10
iface vlan10 inet static
        address 10.0.0.1
        netmask 255.255.255.0
        gateway 10.0.0.254
        vlan-raw-device eth0
        ip_rp_filter 0
```

This example will bring `eth0` up, and create a [VLAN interface](http://en.wikipedia.org/wiki/802.1q) called `vlan10` that will process the tag number 10 on an Ethernet frame.

**Common options inside an interface stanza(layer 2 and 3):**

`address` – IP address for a static IP configured interface

`netmask` – Network mask. Can be ommited if you use cidr address. Example:

```
iface eth1 inet static
    address 192.168.1.2/24
    gateway 192.168.1.1
```

`gateway` – The default gateway of a server. Be careful to use only one of this guy.

`vlan-raw-device` – On a VLAN interface, defines its "father".

`bridge_ports` – On a bridge interface, define its members.

`down` – Use the following command to down the interface instead of `ifdown`.

`post-down` – Actions taken right after the interface is down.

`pre-up` – Actions before the interface is up.

`up` – Use the following command to up the interface instead of `ifup`. It is up to your imagination to use any option available on `iputils`. As an example we could use `up ip link set $IFACE up mtu 9000` to enable [jumbo frames](https://en.wikipedia.org/wiki/Jumbo_frame) during the `up` operation(instead of using the `mtu` option itself). You can also call any other software like `up sleep 5; mii-tool -F 100baseTx-FD $IFACE` to force 100Mbps Full duplex 5 seconds after the interface is up.

`hwaddress ether 00:00:00:00:00:00` - Change the mac  address of the interface instead of using the one that is hardcoded into rom, or generated by algorithms. You can use the keyword `random` to get a randomized mac address.

`dns-nameservers` – IP addresses of nameservers. Requires the `resolvconf` package. It’s a way to concentrate all the information in `/etc/network/interfaces` instead of using `/etc/resolv.conf` for DNS-related configurations. Do not edit the `resolv.conf` configuration file manually as it will be dynamically changed by programs in the system.

```
dns-search example.net` – Append example.net as domain to queries of host, creating the FQDN.  Option `domain` of `/etc/resolv.conf
```

`wpa-ssid` – Wireless: Set a wireless WPA SSID.

`mtu` - [MTU](https://en.wikipedia.org/wiki/Maximum_transmission_unit) size. `mtu 9000` = Jumbo Frame. Useful if your Linux box is connected with switches that support larger MTU sizes. Can break some protocols(I had bad  experiences with snmp and jumbo frames).

`wpa-psk` – Wireless: Set a hexadecimal encoded PSK for your SSID.

`ip_rp_filter 1` - [Reverse path filter](http://www.slashroot.in/linux-kernel-rpfilter-settings-reverse-path-filtering) enabled. Useful in situations where you have 2 routes to a host, and  this will force the packet to come back from where it came(same  interface, using its routes). Example: You are connected on your lan(`192.168.1.1/24`) and you have a dlna server with one interface on your lan(`192.168.1.10/24`) and other interface on dmz to execute administrative tasks(`172.16.1.1/24`). During a ssh session from your computer to dlna dmz ip, the information needs to come back to you, but will hang forever because your dlna  server will try to deliver the response directly through it's lan  interface. With rp_filter enabled, it will ensure that the connection  will come back from where it came from. More information [here](https://access.redhat.com/solutions/53031).

Some of those options are not optional. Debian will warn you if you  put an IP address on an interface without a netmask, for example.

You can find more good examples of network configuration [here](https://wiki.debian.org/NetworkConfiguration).

**Related Stuff**:

Links that have information related to `/etc/network/interfaces` network configuration file:

- [HOWTO: Wireless Security - WPA1, WPA2, LEAP, etc](https://ubuntuforums.org/showthread.php?t=318539). 
- [How can I bridge two interfaces with ip/iproute2?](https://unix.stackexchange.com/q/255484/34720).
- [What is a hotplug event from the interface?](https://unix.stackexchange.com/q/192671/34720)