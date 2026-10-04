# TCP evidence

The repository already has a pcap with SYN / SYN-ACK / ACK to port 443:

`../wireshark/tls-handshake.pcapng`

Add a Wireshark window screenshot of that three-way handshake (`tcp.flags.syn == 1` is a useful filter).

Optional: capture a new handshake during the HTTPS curl.
