# Certificate status

No certificate from the reference repository was imported. Kavya's setup creates a
new team-specific local CA and server certificate for `app.teamX.test` and
`api.teamX.test`. Only the newly generated public `pki/ca.crt` may be committed.
Private keys remain under `~/.config/cn-phase1/tls/` and must never enter Git.
