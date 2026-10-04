# DNS (dnsmasq) — Mac 1

Saksham Miglani, `10.3.3.96`.

Records:

- `app.teamX.test` → `10.3.3.178`
- `api.teamX.test` → `10.3.3.178`

`dnsmasq.conf` also lists optional upstream resolvers so public names can still resolve if a client uses Mac 1 as its DNS. Comment the `server=` lines for a local-only resolver.

## Install and run (Homebrew)

```bash
brew install dnsmasq
# copy dns/dnsmasq.conf to the path brew reports, then:
dnsmasq --test
sudo brew services start dnsmasq
```

Stop: `sudo brew services stop dnsmasq`

## Tests that do not change Wi-Fi DNS

```bash
dig @10.3.3.96 app.teamX.test +short
nslookup app.teamX.test 10.3.3.96
```

Pointing macOS Wi-Fi DNS at `10.3.3.96` can interrupt ordinary internet lookups if this service is down. Do that only for a short demo, then restore the previous DNS servers.

## Troubleshooting

See `docs/troubleshooting.md`. Confirm listen address with `lsof -nP -iUDP:53`.
