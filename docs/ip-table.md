# Phase 1 — Network Inventory

## Network Configuration

All four devices are connected to the same private Wi-Fi network.

- Network: Private LAN / Wi-Fi
- Subnet Mask: 255.255.252.0
- Prefix: /22
- Default Gateway: 10.3.0.1
- Active Interface: en0

## Device IP Address Table

| Device | Team Member | Role | IPv4 Address | Subnet Mask | Gateway | Interface | MAC Address |
|---|---|---|---|---|---|---|---|
| Mac 1 | Saksham | Private DNS + Client | 10.3.3.96 | 255.255.252.0 | 10.3.0.1 | en0 | 42:00:5a:55:c0:03 |
| Mac 2 | Kavya | Nginx Edge / Load Balancer | 10.3.3.178 | 255.255.252.0 | 10.3.0.1 | en0 | 2a:dd:26:44:5e:28 |
| Mac 3 | Shubham | Backend A | 10.3.3.71 | 255.255.252.0 | 10.3.0.1 | en0 | fa:b0:b9:81:2f:96 |
| Mac 4 | Divyanshi | Backend B + Client | 10.3.3.104 | 255.255.252.0 | 10.3.0.1 | en0 | b6:ef:cf:b0:f9:28 |

## Connectivity Test

Ping tests were performed between the participating Macs.

- Mac 1 successfully pinged Mac 2, Mac 3, and Mac 4.
- Mac 2 successfully pinged Mac 1, Mac 3, and Mac 4.
- The recorded tests showed 0% packet loss.

## Network Stability Note

The addresses are currently assigned through DHCP. If the Wi-Fi or hotspot is restarted, addresses may change. The team will verify the addresses before each demonstration.
