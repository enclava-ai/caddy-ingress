# caddy-ingress

Tenant ingress image for Enclava confidential workloads.

This image is the Caddy sidecar used by CAP-generated tenant pods. It includes:

- Caddy with the Cloudflare DNS module, used by tenant TLS automation.
- `cryptsetup` and `e2fsprogs`, used by the mounted secure-PV bootstrap script.
- `curl` and `wget`, used by bootstrap health/resource fetch paths.

Published image:

```text
ghcr.io/enclava-ai/caddy-ingress
```

The Kubernetes command is supplied by CAP. In production the container runs Caddy through the mounted `/secure-pv/bootstrap.sh` script so Caddy's ACME state lives on the encrypted `tls-data` volume.

## Local Smoke Test

```sh
./scripts/smoke.sh
```

The smoke test verifies that the image builds, the Cloudflare DNS module is present, required secure-PV tools exist, and a Caddyfile using `dns cloudflare` validates.
