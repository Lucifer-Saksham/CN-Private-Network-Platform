# Phase 1 video demonstration script

Use only results observed during the real four-Mac run. Do not describe a PASS result
that has not been produced on the LAN.

## 1. Introduce the topology

Saksham runs private DNS at `10.3.3.96`. Kavya runs the TLS edge at
`10.3.3.178:8443`. Shubham runs Backend A at `10.3.3.71:3001`. Divyanshi runs
Backend B at `10.3.3.104:3002`. All four Macs use the `10.3.0.0/22` LAN through
gateway `10.3.0.1`.

Show `docs/ARCHITECTURE.md`, then show each Mac's current network information:

```bash
scripts/macos-network-info.sh
```

## 2. Start the services

Run each command on its owner Mac:

```bash
./macs/mac3-shubham/setup.sh
./macs/mac4-divyanshi/setup.sh
./macs/mac2-kavya/setup.sh
./macs/mac1-saksham/setup.sh
```

Kavya generates the team's new CA and server certificate. Clients install only that
public CA after checking its fingerprint.

## 3. DNS, TCP, and TLS

```bash
dig @10.3.3.96 +noall +answer app.teamX.test
nc -vz 10.3.3.178 8443
openssl s_client -connect 10.3.3.178:8443 -servername app.teamX.test -CAfile pki/ca.crt
```

DNS returns an address, TCP reaches a process on a port, and TLS verifies the requested
hostname before HTTP is sent.

## 4. Load balancing and caching

```bash
./bin/test-all
for i in 1 2 3 4 5 6; do curl -sS https://app.teamX.test:8443/api/status; echo; done
curl -i https://app.teamX.test:8443/api/cacheable
```

Show both backend identities. Re-send the cacheable request with the returned ETag in
`If-None-Match` and show the `304` response.

## 5. Reversible failure

On Shubham's Mac, stop Backend A, repeat several requests, and show Backend B serving
them. Restore Backend A immediately:

```bash
./macs/mac3-shubham/stop.sh
./macs/mac3-shubham/start.sh
```

## 6. Packet evidence and shutdown

```bash
scripts/capture-packets.sh 60
```

Finish with `./bin/status`, save authentic outputs using `./bin/collect-evidence`, and
run `./bin/stop` on each Mac when the demonstration ends.
