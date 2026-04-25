#!/bin/sh
set -eu

IMAGE="${1:-caddy-ingress:local}"

docker build -t "$IMAGE" .

docker run --rm "$IMAGE" caddy list-modules | grep -F "dns.providers.cloudflare"
docker run --rm "$IMAGE" sh -eu -c '
  command -v caddy
  command -v cryptsetup
  command -v mkfs.ext4
  command -v curl
  command -v wget
'

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT
cat > "$tmpdir/Caddyfile" <<'CADDY'
{
  email ops@enclava.dev
}

example.enclava.dev {
  tls {
    dns cloudflare {env.CF_API_TOKEN}
  }
  respond "ok"
}
CADDY

docker run --rm \
  -e CF_API_TOKEN=0123456789abcdef0123456789abcdef01234567 \
  -v "$tmpdir/Caddyfile:/etc/caddy/Caddyfile:ro" \
  "$IMAGE" caddy validate --config /etc/caddy/Caddyfile
