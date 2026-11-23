# Certificate status

Kavya's setup creates a team-specific local CA and server certificate for
`app.teamX.test` and `api.teamX.test`. Only the generated public `pki/ca.crt` may be committed.
Private keys remain under `~/.config/cn-phase1/tls/` and must never enter Git.
