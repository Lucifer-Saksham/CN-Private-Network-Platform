# Four-Mac IP inventory

Network: private Wi-Fi/LAN
CIDR: `10.3.0.0/22`
Subnet mask: `255.255.252.0`
Gateway: `10.3.0.1`
Interface: `en0`

MAC addresses are **recorded interface addresses**, not guaranteed permanent hardware IDs (macOS private Wi-Fi addressing).

| Machine | Member | Role | IPv4 | Subnet mask | Gateway | Interface | Recorded en0 MAC |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Mac 1 | Saksham Miglani | DNS (dnsmasq) | 10.3.3.96 | 255.255.252.0 | 10.3.0.1 | en0 | 42:00:5a:55:c0:03 |
| Mac 2 | Kavya Mukhija | Nginx, TLS, load balancing | 10.3.3.178 | 255.255.252.0 | 10.3.0.1 | en0 | 2a:dd:26:44:5e:28 |
| Mac 3 | Shubham | Backend A | 10.3.3.71 | 255.255.252.0 | 10.3.0.1 | en0 | fa:b0:b9:81:2f:96 |
| Mac 4 | Divyanshi | Backend B | 10.3.3.104 | 255.255.252.0 | 10.3.0.1 | en0 | b6:ef:cf:b0:f9:28 |

Application names:

| Name | Type | Target |
| --- | --- | --- |
| app.teamX.test | A | 10.3.3.178 |
| api.teamX.test | A | 10.3.3.178 |

Do not edit this table from memory. Re-run `ifconfig en0` if a laptop rejoins the hotspot and the lease changes.
