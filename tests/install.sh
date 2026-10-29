#!/usr/bin/env bash
set -euo pipefail
root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
export HOME="$tmp/home"
export XDG_DATA_HOME="$HOME/.local/share"
mkdir -p "$HOME" "$tmp/source" "$tmp/mock" "$tmp/project"
cp -R "$root/bin" "$tmp/source/bin"

export AZ_CONTAINER_BIN_DIR="$HOME/.local/bin"
export AZ_CONTAINER_ENGINE="$tmp/mock/runtime"
# Azure accepts engine names only; Terraform also accepts an executable path.
cat > "$tmp/mock/runtime" <<'MOCK'
#!/usr/bin/env bash
printf '%s\n' "$@" > "$TEST_ARGS"
cat > /dev/null
exit "${TEST_EXIT:-0}"
MOCK
chmod +x "$tmp/mock/runtime"
ln -s runtime "$tmp/mock/docker"
export PATH="$tmp/mock:$PATH"
export TEST_ARGS="$tmp/args"
export AZ_CONTAINER_ENGINE=docker
"$tmp/source/bin/install.sh"
"$tmp/source/bin/install.sh"
for name in az-container az-shell; do [[ -f "$HOME/.local/bin/$name" && ! -L "$HOME/.local/bin/$name" && -x "$HOME/.local/bin/$name" ]]; done
# Remove the entire source tree, then exercise installed commands.
rm -rf "$tmp/source"
cd "$tmp/project"
"$HOME/.local/bin/az" version < /dev/null
 grep -Fxq /usr/bin/az "$TEST_ARGS"
"$HOME/.local/bin/az-shell" -c 'az version' < /dev/null
grep -Fxq /bin/bash "$TEST_ARGS"
# Unrelated existing commands must be preserved before any replacements.
mkdir -p "$tmp/conflict"
printf keep > "$tmp/conflict/az"
if AZ_CONTAINER_BIN_DIR="$tmp/conflict" "$root/bin/install.sh" 2>/dev/null; then exit 1; fi
[[ "$(cat "$tmp/conflict/az")" = keep ]]
[[ ! -e "$tmp/conflict/az-container" ]]
for script in "$root"/bin/* "$root"/tests/*.sh; do bash -n "$script"; done
printf 'PASS: copy install, reinstall, source deletion, installed commands, conflict protection\n'
# Migrate the legacy installer links without touching unrelated files.
mkdir -p "$tmp/legacy"
for name in az az-container az-shell; do
    target="$root/bin/$name"
    [[ "$name" != az ]] || target="$root/bin/az-container"
    ln -s "$target" "$tmp/legacy/$name"
done
AZ_CONTAINER_BIN_DIR="$tmp/legacy" "$root/bin/install.sh"
[[ ! -L "$tmp/legacy/az-container" && "$(readlink "$tmp/legacy/az")" = az-container ]]
