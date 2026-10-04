# Private Network Service Platform

Computer Networks Project — Phase 1

Infrastructure: Type 1 — Four physical macOS laptops connected to a shared private Wi-Fi/hotspot network.

## Project Overview

This project implements a private network service platform in which private DNS resolves an application domain to an Nginx edge server. Nginx terminates HTTPS and distributes requests to two REST backends.

## Team Members

| Member | Machine | Responsibility |
| --- | --- | --- |
| Saksham | Mac 1 | Private DNS |
| [Member 2] | Mac 2 | Nginx, HTTPS, Load Balancing |
| [Member 3] | Mac 3 | Backend A |
| [Member 4] | Mac 4 | Backend B |

## Network Inventory

| Machine | Role | Private IP |
| --- | --- | --- |
| Mac 1 | DNS | 10.3.3.96 |
| Mac 2 | Nginx | 10.3.3.178 |
| Mac 3 | Backend A | 10.3.3.71 |
| Mac 4 | Backend B | 10.3.3.104 |

## Architecture

To be added after the final topology is prepared.

## Technologies

- macOS
- dnsmasq
- Nginx
- HTTPS / TLS
- REST APIs
- Wireshark
- curl

## How to Run

Instructions will be added after implementation and testing.

## Testing

- LAN connectivity
- Private DNS resolution
- Backend API responses
- Nginx load balancing
- HTTPS certificate validation
- HTTP caching
- Wireshark packet analysis

## Evidence

See the `evidence/` directory.

## Demo Video

Google Drive link: To be added after final recording.

## Project Status

Phase 1 — In progress.
