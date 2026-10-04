# Wireshark evidence

Present: `tls-handshake.pcapng` (12 KB). Contents confirmed with tcpdump:

- ARP for 10.3.3.178 / 2a:dd:26:44:5e:28
- TCP handshake 10.3.3.96:52396 ↔ 10.3.3.178:443
- Follow-on TLS/TCP payload
- Later DNS for public hostnames (not app.teamX.test)

Add screenshots of the TCP and TLS packet list. Add a **new** pcap for the application DNS name under `../dns/`.
