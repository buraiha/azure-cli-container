#!/usr/bin/env bash
set -euo pipefail
root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)
temporary=$(mktemp -d)
trap 'rm -rf "$temporary"' EXIT
mkdir -p "$temporary/bin" "$temporary/work space"
export AZ_CONTAINER_CONFIG_DIR="$temporary/cache space"
export AZ_CONTAINER_ENGINE=docker
export TEST_ARGS="$temporary/args"
export TEST_STDIN="$temporary/stdin"
cat > "$temporary/bin/docker" <<'MOCK'
#!/usr/bin/env bash
printf '%s\0' "$@" > "$TEST_ARGS"
cat > "$TEST_STDIN"
exit "${TEST_EXIT:-0}"
MOCK
chmod +x "$temporary/bin/docker"
ln -s docker "$temporary/bin/podman"
export PATH="$temporary/bin:$PATH"
cd "$temporary/work space"
printf payload | "$root/bin/az-container" group list --query 'a b' ''
python3 - "$TEST_ARGS" "$TEST_STDIN" <<'PY'
import sys
from pathlib import Path
a=Path(sys.argv[1]).read_bytes().split(b'\0')[:-1]
assert a[-5:]==[b'group',b'list',b'--query',b'a b',b'']
assert b'-t' not in a and b'-i' in a and b'--rm' in a
assert b'--privileged' not in a
assert a[a.index(b'--entrypoint')+1]==b'/usr/bin/az'
assert Path(sys.argv[2]).read_text()=='payload'
PY
export AZ_CONTAINER_ENGINE=podman
"$root/bin/az-shell" -c 'az version' < /dev/null
python3 - "$TEST_ARGS" <<'PY'
import sys
from pathlib import Path
a=Path(sys.argv[1]).read_bytes().split(b'\0')[:-1]
assert b'--userns=keep-id' in a
assert a[a.index(b'--entrypoint')+1]==b'/bin/bash'
assert a[-2:]==[b'-c',b'az version']
PY
export TEST_EXIT=37
set +e
"$root/bin/az-container" version < /dev/null
status=$?
set -e
[[ "$status" = 37 ]]
unset TEST_EXIT
export AZ_CONTAINER_CONFIG_DIR="$PWD/cache"
if "$root/bin/az-container" version 2>/dev/null; then exit 1; fi
export AZ_CONTAINER_BIN_DIR="$temporary/installed"
"$root/bin/install-alias.sh"
"$root/bin/install-alias.sh"
[[ -L "$AZ_CONTAINER_BIN_DIR/az" ]]
rm "$AZ_CONTAINER_BIN_DIR/az"
printf keep > "$AZ_CONTAINER_BIN_DIR/az"
if "$root/bin/install-alias.sh" 2>/dev/null; then exit 1; fi
[[ "$(cat "$AZ_CONTAINER_BIN_DIR/az")" = keep ]]
for script in "$root"/bin/* "$root"/examples/*.sh "$root"/tests/*.sh; do bash -n "$script"; done
printf 'PASS: syntax, arguments, stdin, exit status, Podman, shell, cache guard, install safety\n'
