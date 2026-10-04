# LAN evidence

On each Mac:

```bash
ifconfig en0
```

Save four screenshots showing IPv4, netmask, and that the address matches `docs/ip-table.md`.

From Mac 1:

```bash
ping -c 2 10.3.3.178
ping -c 2 10.3.3.71
ping -c 2 10.3.3.104
```

Or: `bash scripts/check-lan.sh`

Filenames: `mac1-ifconfig.png`, `mac2-ifconfig.png`, `mac3-ifconfig.png`, `mac4-ifconfig.png`, `ping-peers.png`
