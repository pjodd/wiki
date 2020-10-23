---
title: Installera en ny Gateway
---

## Installation av en Pjodd-gateway

Denna template utgår från
<https://www.freemesh.ie/wiki/index.php?title=Generic_Freemesh_Gateway>

***Also one little side note:*** This guide has IPv6 NAT configuration
in it. I strongly recommend against it. With the use of Mullvad or
AirVPN tunnels, it's the only way IPv6 connectivity can be made, so it
was used in this case. It will break stuff the same way as IPv4 NAT
breaks stuff and shouldn't be needed, as IPv6 is available in vast
amounts. Also, IPv6 NAT requires kernel 3.9 as a minimum specification.

### Systemkrav

-   2 kärnor
-   512 MB RAM
-   512 MB swap-disk
-   4 GB root-disk
-   Linuxkärnan måste kunna modifieras, OpenVZ fungerar inte. KVM går
    bra.

### Installation

-   Installera en minimal "Debian jessie"
-   Använd ett vettigt root-lösenord.
-   Sätt host/domainname:

```
hostname gateway-0x
echo "127.0.1.1 gateway-0x.mesh.pjodd.se gateway-0x" >>/etc/hosts
echo gateway-0x > /etc/hostname
```

#### apt-get

```
apt-get install screen htop iftop traceroute mtr-tiny mc speedtest-cli openvpn bash-completion nano joe ca-certificates haveged bridge-utils ntp unbound isc-dhcp-server radvd iptables-persistent apt-transport-https joe postfix pdns-server bridge-utils sudo git apt-transport-https`
```

Välj `local only` för Postfix.

#### B.A.T.M.A.N. och fastd

Lägg till jessie-backports till din `/etc/apt/sources.list`:

```
echo "deb http://ftp.debian.org/debian jessie-backports main" >> /etc/apt/sources.list
apt-get update
apt-get install batctl fastd
# om nyckeln är gammal använd: apt-get -y --force-yes
```

Lägg till batman-adv som kärnmodul:

```
echo "batman-adv" >> /etc/modules
modprobe batman-adv
```

Klona våra fastd-peers:

```
cd /etc/fastd/vpn
git clone https://github.com/pjodd/gluon-gateway-peers.git peers
```

Generera en uppsättning fastd-nycklar för gatewayen:

```
fastd --generate-key > /root/fastd-keys.pub.sec
```

Spara en backup av `/root/fastd-keys.pub.sec` på ett säkert ställe.
Dessa kommer användas för både server- och klientbyggen.

Skapa en fastd-konfiguration och starta om fastd:

```
nano /etc/fastd/vpn/fastd.conf

log to syslog level debug;
bind any:10006 interface "eth0"; # Ditt nätverksinterface ut mot internet
method "salsa2012+umac";
mtu 1560;
secret "xxx";  # Din secret-nyckel i /root/fastd-keys.pub.sec
include peers from "peers";
on verify "true";   # Tillåter vem som helst att ansluta till gatewayen
on up "
  /sbin/ifup bat0
  /bin/ip link set dev tap0 address 00:91:0d:d0:5e:0${GATEWAY_NUMBER}
  /bin/ip link set dev tap0 up
";

service fastd restart
```

#### Nätverksinställningar

Slå på IP-forwarding i `/etc/sysctl.conf`:

```
# Uncomment the next line to enable packet forwarding for IPv4
net.ipv4.ip_forward=1

# Uncomment the next line to enable packet forwarding for IPv6
#  Enabling this option disables Stateless Address Autoconfiguration
#  based on Router Advertisements for this host
net.ipv6.conf.all.forwarding=1
```

Ladda om systctl.conf:

```
sysctrl -p
```

Redigera `/etc/network/interfaces`:

```
# The loopback network interface
    auto lo
iface lo inet loopback

# Batman
    auto br-pjodd
    allow-hotplug bat0

# The primary network interface
auto eth0
iface eth0 inet static/dhcp
    # låt vara som den är

iface eth0 inet6 static/dhcp
    # låt vara som den är

# Batman
    up /sbin/brctl addbr br-pjodd

iface br-pjodd inet static
    address 10.46.0.${GATEWAY-NUMBER}
    netmask 255.255.0.0
    bridge-ports none

iface br-pjodd inet6 static
    address fdec:910d:d05e::ff0${GATEWAY_NUMBER}
    netmask 64

# batman interface
iface bat0 inet6 manual
   pre-up /usr/sbin/batctl if add tap0
   up /bin/ip link set dev bat0 up
   post-up /sbin/brctl addif br-pjodd bat0
   post-up /usr/sbin/batctl it 10006
   post-up /usr/sbin/batctl gw_mode server
   post-up /sbin/ip rule add from all fwmark 0x1 table 42
   post-up /sbin/ip -6 rule add from all fwmark 0x1 table 42
   pre-down /sbin/brctl delif br-pjodd bat0 || true
   down /bin/ip link set dev bat0 down

   # this is for adding the gateway to the map later, not necessarily necessary.
   # post-up start-stop-daemon -b --start --exec /usr/local/sbin/alfred -- -i br-pjodd -b bat0 -m
   # post-up start-stop-daemon -b --start --exec /usr/local/sbin/batadv-vis -- -i bat0 -s

source /etc/network/interfaces.d/*
```

Starta om nätverket

```
service networking restart
```

Sätt ny IP4 och IPv6 till bryggan:

```
ifconfig br-pjodd 10.46.0.${GATEWAY_NUMBER}
ip a a fdec:910d:d05e::ff0${GATEWAY_NUMBER}/64 dev br-pjodd
```

#### DHCP och DNS

##### DHCP radvd IPv6

Redigera `/etc/radvd.conf`

```
interface br-pjodd {
  AdvSendAdvert on;
  #
  # Please uncomment if you don't want an IPv6 default route to be broadcasted.
  #
  # AdvDefaultLifetime 0; 
  IgnoreIfMissing on;
  AdvManagedFlag off;
  AdvOtherConfigFlag on;
  MaxRtrAdvInterval 200;
  
  prefix fdec:910d:d05e::/64 {
     AdvOnLink on;
     AdvAutonomous on;
     AdvRouterAddr on;
     AdvPreferredLifetime 14400;
     AdvValidLifetime 86400;
  };

  RDNSS fdec:910d:d05e::ff0${GATEWAY_NUMBER} {
  };
  
  route fc00::/7
  {
     AdvRouteLifetime 1200;
  };
};
```

Starta om radvd

```
service radvd restart
```

##### DHCP isc-dhcp-server IPv4 och IPv6

Se sidan [Gateways](gateways.html) för information om vilka adressrymder
olika gateways ansvarar för.

isc-dhcp-server kan inte hantera IPv4 och IPv6 samtidigt, så du måste
skapa två instanser.

Redigera `/etc/dhcp/dhcpd.conf` för IPv4

```
ddns-update-style none;
option domain-name ".pjodd";
option domain-name-servers 10.46.0.${GATEWAY_NUMBER}
default-lease-time 300;
max-lease-time 3600;
log-facility local7;
subnet 10.46.0.0 netmask 255.255.0.0
{
  authorative;
  range 10.46.${ADDRESS_SPACE_FROM}.1 10.46.${ADDRESS_SPACE_TO}.254;    
  option routers 10.46.0.${GATEWAY_NUMBER};
}

include "/etc/dhcp/static.conf";`
```

Skapa en tom static.conf-fil. I denna kan du senare lägga till IP för
klienter om du vill.

```
touch /etc/dhcp/static.conf
```

Redigera `/etc/dhcp/dhcpd6.conf` för IPv6:

```
log-facility local7;

subnet6 fdec:910d:d05e:000${GATEWAY_NUMBER}::/64 { 
   option dhcp6.name-servers fdec:910d:d05e::ff0${GATEWAY_NUMBER}
   option dhcp6.domain-search "pjodd";
}
```

Redigera `/etc/default/isc-dhcp-server`:

```
nano /etc/default/isc-dhcp-server

# Additional options to start dhcpd with.
#   Don't use options -cf or -pf here; use DHCPD_CONF/ DHCPD_PID instead
OPTIONS="-4"
# On what interfaces should the DHCP server (dhcpd) serve DHCP requests?
# Separate multiple interfaces with spaces, e.g. "eth0 eth1".
INTERFACES="br-pjodd"
```

Skapa `/etc/default/isc-dhcp6-server`:

```
nano /etc/default/isc-dhcp6-server

# Path to dhcpd's config file (default: /etc/dhcp/dhcpd.conf).
DHCPD_CONF=/etc/dhcp/dhcpd6.conf
# Path to dhcpd's PID file (default: /var/run/dhcpd.pid).
DHCPD_PID=/var/run/dhcpd6.pid
# Additional options to start dhcpd with.
#   Don't use options -cf or -pf here; use DHCPD_CONF/ DHCPD_PID instead
OPTIONS="-6"
# On what interfaces should the DHCP server (dhcpd) serve DHCP requests?
#   Separate multiple interfaces with spaces, e.g. "eth0 eth1".
INTERFACES="br-pjodd"
```

Exekvera sedan:

```
touch /var/lib/dhcp/dhcpd6.leases
cp /etc/init.d/isc-dhcp-server /etc/init.d/isc-dhcp6-server
```

Redigera `/etc/init.d/isc-dhcp6-server` på följande platser:

Ersätt

```
# Provides:          isc-dhcp-server
```

med

```
# Provides:          isc-dhcp6-server
```

Ersätt

```
DHCPD_DEFAULT="${DHCPD_DEFAULT:-/etc/default/isc-dhcp-server}"
```

med

```
DHCPD_DEFAULT="${DHCPD_DEFAULT:-/etc/default/isc-dhcp6-server}"
```

Autostarta DHCPd för IPv6:

```
update-rc.d isc-dhcp6-server defaults
```

Starta om all DHCPd:

```
service isc-dhcp-server restart
service isc-dhcp6-server restart
```

##### powerdns

For DNS, my personal preference is on powerdns, but you can use whatever
dns you'd like to use. Edit the following sections of the configuration
in `/etc/powerdns/pdns.conf`

```
#################################
# allow-recursion       List of subnets that are allowed to recurse
#
allow-recursion=127.0.0.0/8,10.129.0.0/16,::1/128,fe80::/10,fddf:bf7:10::/48
#################################
# local-address Local IP addresses to which we bind
#
local-address=10.46.0.${GATEWAY_NUMBER}
#################################
# local-ipv6    Local IP address to which we bind
#
local-ipv6=fdec:910d:d05e::ff0${GATEWAY_NUMBER}
#################################
# recursor      If recursion is desired, IP address of a recursing nameserver
#
recursor=8.8.8.8                  # using Google DNS as recursor, as the local one can be buggy
```

Ta hem Pjodds DNS-zon:

```
cd /etc/powerdns
git clone https://github.com/pjodd/dns_pjodd
```

Redigera `/etc/powerdns/bindbackend.conf` och lägg till:

```
include "/etc/powerdns/dns_pjodd/named.conf.local";
```

Starta om powerdns:

```
service pdns restart
```

#### Routing till Internet

Du vill troligen inte släppa ut trafiken från ditt eget nät, utan i
stället använda ett VPN av något slag. Alla Pjodds egna gateways
använder sig av Mullvad, som dessutom gett oss tillstånd att använda
deras tjänst för detta ändamål

##### Utan VPN

Om du inte vill använda VPN för utgående trafik behöver du bara lägga
till följande i `/etc/network/interfaces` i din eth0-sektion:

```
  up /sbin/iptables -t nat -A POSTROUTING -s 10.46.0.0/16 ! -d 10.46.0.0/16 -j SNAT -o eth0 --to-source ${DITT_PUBLIKA_IP}
  up /sbin/ip6tables -t nat -A POSTROUTING -o eth0 -s fdec:910d:d05e/64 -j MASQUERADE
```

Placera detta direkt efter `up /sbin/brctl addbr br-pjodd`

##### Med VPN

Skapa /root/bin

```
mkdir /root/bin
```

Skapa ett brandväggsskript för att tunnla ut trafiken:

```
nano /root/bin/iptables_pjodd.sh

#!/bin/sh
/sbin/ip route add default via ${DITT_PUBLIKA_IP} table 42
/sbin/ip route add 10.46.0.0/16 dev br-pjodd src 10.46.0.${GATEWAY_NUMBER} table 42 
/sbin/ip route add fdec:910d:d05e::/64 dev br-pjodd table 42
/sbin/ip route add 0/1 dev tun0 table 42
/sbin/ip route add 128/1 dev tun0 table 42
/sbin/ip route del default via ${DITT_PUBLIKA_IP} table 42
/sbin/ip -6 route add default dev tun0 table 42
/sbin/iptables -t nat -I POSTROUTING -s 0/0 -d 0/0 -j MASQUERADE
/sbin/iptables -t nat -D POSTROUTING -s 0/0 -d 0/0 -o tun0 -j MASQUERADE
/sbin/iptables -t mangle -I PREROUTING -s 10.46.0.0/16 -j MARK --set-mark 0x1
/sbin/iptables -t mangle -I OUTPUT -s 10.46.0.0/16 -j MARK --set-mark 0x1
/sbin/ip6tables -t nat -A POSTROUTING -o tun0 -s fdec:910d:d05e::ff0${GATEWAY_NUMBER} -j MASQUERADE
/sbin/ip6tables -t mangle -I PREROUTING -s fdec:910d:d05e::ff0${GATEWAY_NUMBER} -j MARK --set-mark 0x1
/sbin/ip6tables -t mangle -I OUTPUT -s fdec:910d:d05e::ff0${GATEWAY_NUMBER}/64 -j MARK --set-mark 0x1
```

Gör skriptet exekverbart.

```
chmod +x /root/bin/iptables_pjodd.sh
```

Skapa ett skript som exekveras efter det att VPNet har startat och gör
det exekverbart:

```
nano /root/bin/mullvad_up.sh'

#!/bin/sh
ip route replace 0.0.0.0/1 via $5 table 42
ip route replace 128.0.0.0/1 via $5 table 42
chmod +x /root/bin/mullvad_up.sh
service ssh restart
exit 0
```

Skapa ett skript som exekveras efter det att VPNet har startat och gör
det exekverbart:

```
nano /root/bin/mullvad_up.sh'

#!/bin/sh
ip route replace 0.0.0.0/1 via $5 table 42
ip route replace 128.0.0.0/1 via $5 table 42
chmod 700 /root/bin/mullvad_up.sh
service ssh restart
exit 0
```

Surfa till Mullvad och tanka hem en konfigurationsfil för OpenVPN:

[`https://www.mullvad.net/download/config/`](https://www.mullvad.net/download/config/)

Spara den som `/etc/openvpn/Mullvad_whatnot.conf` annars startas den
inte automatiskt.

Redigera filen, lägg till följande precis före `<ca>`-sektionen:

```
# custom
route-noexec
up /root/bin/mullvad_up.sh
up /root/bin/iptables_pjodd.sh
```

Kommentera ut:

```
# Needed to make OpenVPN work on iOS9`
# redirect-gateway ipv6
```

Boota om och allt skall fungera.

Glöm inte att släppa in fastd på port 10006 i din firewall om något
sitter före gatewayen. Både UDP och TCP:

```
# gateway-02.mesh.pjodd.se, fastd tunnel port 10006, UDP and TCP
iptables -t nat -I PREROUTING -p tcp -i $EXTIF --dport 10006 -j DNAT --to 10.40.4.2:10006
iptables -A FORWARD -p tcp -d 10.40.4.2 --dport 10006 -m state --state NEW -j ACCEPT

iptables -t nat -I PREROUTING -p udp -i $EXTIF --dport 10006 -j DNAT --to 10.40.4.2:10006
iptables -A FORWARD -p udp -d 10.40.4.2 --dport 10006 -m state --state NEW -j ACCEPT
```
