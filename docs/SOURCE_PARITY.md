# Reference source parity inventory

Reference: `mitul-bhatia/cn_project` at
`3fc79f339a00500c73689b5dfb71801e2c204a4b`.

Status key: **adapted** means imported and changed only for this team's identities,
paths, addresses, documentation accuracy, or a documented defect. **renamed** means
the reference role path has a one-to-one team-specific replacement. **identical**
means the file was imported without source-content changes. **excluded** means the
file was deliberately not imported for security or evidence integrity.

The reference contains 79 tracked files. This repository represents 78 of them. The
only excluded reference file is `pki/ca.crt`; Kavya must generate a new team-specific
CA. Additional files are attribution, certificate notice, this inventory, and the
archived authentic Phase 1 evidence.

| Reference file | Target/status |
|---|---|
| `.env.example` | same path, adapted |
| `.gitignore` | same path, adapted |
| `CN_Project_Doc.pdf` | same path, identical |
| `README.md` | same path, adapted |
| `admin/bootstrap-cloudflare.sh` | same path, adapted |
| `backends/server.py` | same path, adapted |
| `bin/collect-evidence` | same path, adapted |
| `bin/doctor` | same path, adapted |
| `bin/failure-demo` | same path, adapted; fixed non-zero `explain` exit |
| `bin/phase2` | same path, adapted |
| `bin/start` | same path, adapted |
| `bin/status` | same path, adapted |
| `bin/stop` | same path, adapted |
| `bin/teardown` | same path, adapted |
| `bin/test-all` | same path, adapted |
| `config/cloudflare/README.md` | same path, adapted |
| `config/dns/dnsmasq.conf.template` | same path, adapted |
| `config/nginx/nginx.conf.template` | same path, adapted |
| `config/project.example.env` | same path, adapted with recorded topology defaults |
| `docs/ARCHITECTURE.md` | same path, adapted |
| `docs/CLOUDFLARE_MODE.md` | same path, adapted |
| `docs/CN_Project_Doc.pdf` | same path, identical |
| `docs/FAILURE_DEMOS.md` | same path, adapted |
| `docs/LAN_MODE.md` | same path, adapted |
| `docs/PHASE1.md` | same path, adapted |
| `docs/PHASE1_VIDEO_DEMO_SCRIPT.md` | same path, rewritten for the authentic four-Mac demo |
| `docs/PHASE2.md` | same path, adapted |
| `docs/PHASE2_STORY.pptx` | same path, team/domain/IP text adapted; layout preserved |
| `docs/PROJECT_SUBMISSION_REPORT.md` | same path, rewritten to remove reference-team evidence claims |
| `docs/PROJECT_VISUAL.html` | same path, adapted and stale role paths fixed |
| `docs/REQUEST_FLOW.md` | same path, adapted |
| `docs/TROUBLESHOOTING.md` | same path, adapted |
| `docs/VIVA.md` | same path, adapted |
| `docs/diagrams.md` | same path, adapted |
| `evidence/README.md` | same path, identical policy/readme import |
| `logs/.gitkeep` | same path, identical |
| `macs/mac1-mitul/README.md` | `macs/mac1-saksham/README.md`, renamed and adapted |
| `macs/mac1-mitul/setup.sh` | `macs/mac1-saksham/setup.sh`, renamed and adapted |
| `macs/mac1-mitul/start.sh` | `macs/mac1-saksham/start.sh`, renamed and adapted |
| `macs/mac1-mitul/status.sh` | `macs/mac1-saksham/status.sh`, renamed and adapted |
| `macs/mac1-mitul/stop.sh` | `macs/mac1-saksham/stop.sh`, renamed and adapted |
| `macs/mac2-hardik/README.md` | `macs/mac2-kavya/README.md`, renamed and adapted |
| `macs/mac2-hardik/setup.sh` | `macs/mac2-kavya/setup.sh`, renamed and adapted |
| `macs/mac2-hardik/start.sh` | `macs/mac2-kavya/start.sh`, renamed and adapted |
| `macs/mac2-hardik/status.sh` | `macs/mac2-kavya/status.sh`, renamed and adapted |
| `macs/mac2-hardik/stop.sh` | `macs/mac2-kavya/stop.sh`, renamed and adapted |
| `macs/mac3-vaibhav/README.md` | `macs/mac3-shubham/README.md`, renamed and adapted |
| `macs/mac3-vaibhav/setup.sh` | `macs/mac3-shubham/setup.sh`, renamed and adapted |
| `macs/mac3-vaibhav/start.sh` | `macs/mac3-shubham/start.sh`, renamed and adapted |
| `macs/mac3-vaibhav/status.sh` | `macs/mac3-shubham/status.sh`, renamed and adapted |
| `macs/mac3-vaibhav/stop.sh` | `macs/mac3-shubham/stop.sh`, renamed and adapted |
| `macs/mac4-akshat/README.md` | `macs/mac4-divyanshi/README.md`, renamed and adapted |
| `macs/mac4-akshat/setup.sh` | `macs/mac4-divyanshi/setup.sh`, renamed and adapted |
| `macs/mac4-akshat/start.sh` | `macs/mac4-divyanshi/start.sh`, renamed and adapted |
| `macs/mac4-akshat/status.sh` | `macs/mac4-divyanshi/status.sh`, renamed and adapted |
| `macs/mac4-akshat/stop.sh` | `macs/mac4-divyanshi/stop.sh`, renamed and adapted |
| `pki/README.md` | same path, adapted |
| `pki/ca.crt` | excluded; generate a new certificate locally |
| `scripts/capture-packets.sh` | same path, adapted |
| `scripts/checks.sh` | same path, adapted |
| `scripts/common.sh` | same path, adapted; removed stale legacy person alias |
| `scripts/configure-client-dns.sh` | same path, adapted |
| `scripts/create-local-ca.sh` | same path, adapted |
| `scripts/install-ca.sh` | same path, adapted |
| `scripts/macos-network-info.sh` | same path, adapted |
| `scripts/phase2.sh` | same path, adapted; creates isolation state directories before rendering and rejects an isolation test when the intended edge path is down |
| `scripts/role.sh` | same path, adapted |
| `scripts/roles.sh` | same path, adapted |
| `scripts/testlib.sh` | same path, adapted |
| `scripts/verify-prerequisites.sh` | same path, adapted |
| `scripts/wait-for-port.sh` | same path, identical |
| `tests/test_backends.sh` | same path, adapted |
| `tests/test_cache.sh` | same path, adapted |
| `tests/test_dns.sh` | same path, adapted |
| `tests/test_http.sh` | same path, adapted |
| `tests/test_load_balancing.sh` | same path, adapted |
| `tests/test_phase2.sh` | same path, adapted |
| `tests/test_tcp.sh` | same path, adapted |
| `tests/test_tls.sh` | same path, adapted |

## Functional parity

The imported command surface matches the reference: `start`, `stop`, `status`,
`teardown`, `test-all`, `doctor`, `collect-evidence`, `failure-demo`, and `phase2`.
Phase 2 retains setup/start/stop/status/rollback, backup-DNS failover, TTL demo,
`pf` isolation, backend failover/recovery, encrypted standby-edge bundle, DNS cutover,
watch mode, edge selection, and hidden diagnostic drills. Cloudflare tunnel bootstrap,
WARP checks, credentials adoption, backend connectors, and tunnel documentation remain.

## Intentional non-parity

- No upstream CA certificate, private key, token, credentials JSON, runtime state, or
  collected evidence was imported.
- Original team evidence is stored separately at `evidence/phase1-original/`.
- Documentation that asserted the reference team's observed results was rewritten as
  this team's topology and an explicit unverified deployment status.
