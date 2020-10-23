---
title: Gateways
---

Varje gateway agerar även DHCP-server för de klienter och noder som
ansluter.

De är authorative för vardera 8192 IPv4-adresser och
18446744073709551616 IPv6-adresser.

Gateways tillhandahåller även ytterligare tjänster som
firmwareuppdateringar, ntp, register över noder, mm.

För närvarande existerar enbart gateway-01 och gateway-02.

Server|IPv4 MESH|IPv6 MESH|IPv4 DHCP från|IPv4 DHCP till|IPv6 DHCP
---|---|---|---|---|---
gateway-01.mesh.pjodd.se|10.46.0.1|fdec:910d:d05e::ff01|10.46.64.1 |10.46.95.254 |fdec:910d:d05e:0001::/64
gateway-02.mesh.pjodd.se|10.46.0.2|fdec:910d:d05e::ff02|10.46.96.1 |10.46.127.254|fdec:910d:d05e:0002::/64
gateway-03.mesh.pjodd.se|10.46.0.3|fdec:910d:d05e::ff03|10.46.128.1|10.46.159.254|fdec:910d:d05e:0003::/64
gateway-04.mesh.pjodd.se|10.46.0.4|fdec:910d:d05e::ff04|10.46.160.1|10.46.191.254|fdec:910d:d05e:0004::/64
gateway-05.mesh.pjodd.se|10.46.0.5|fdec:910d:d05e::ff05|10.46.192.1|10.46.223.254|fdec:910d:d05e:0005::/64
gateway-06.mesh.pjodd.se|10.46.0.6|fdec:910d:d05e::ff06|10.46.224.1|10.46.255.254|fdec:910d:d05e:0006::/64
