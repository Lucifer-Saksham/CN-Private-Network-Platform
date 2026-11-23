# DNS evidence

```bash
dig @10.3.3.96 app.teamX.test +short
dig @10.3.3.96 app.teamX.test
```

Screenshot must show the **QUESTION** `app.teamX.test` and **ANSWER** `10.3.3.178`.

Packet capture: start Wireshark on `en0`, filter `udp.port == 53`, run the dig command, save `app-teamx-test.pcapng` here.

The file `../wireshark/tls-handshake.pcapng` is **not** this evidence; it contains public-name queries, not `app.teamX.test`.
