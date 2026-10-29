#!/usr/bin/env bash
set -euo pipefail
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)
destination=${AZ_CONTAINER_BIN_DIR:-$HOME/.local/bin}
[[ "$destination" = /* ]] || { echo 'インストール先には絶対パスを指定してください。' >&2; exit 1; }
mkdir -p "$destination"
destination=$(cd "$destination" && pwd -P)
source_root=$(cd "$script_dir/.." && pwd -P)
case "$destination/" in "$source_root/"*) echo 'インストール先はclone先の外を指定してください。' >&2; exit 1;; esac
# Preflight every destination before replacing anything.
for name in az az-container az-shell; do
    path="$destination/$name"
    if [[ -e "$path" || -L "$path" ]]; then
        owned=0
        if [[ -L "$path" ]]; then
            target=$(readlink "$path")
            case "$name:$target" in
                az:az-container|az:"$destination/az-container"|az:"$script_dir/az-container"|az-container:"$script_dir/az-container"|az-shell:"$script_dir/az-shell") owned=1 ;;
            esac
        elif [[ -f "$path" ]] && head -n 2 "$path" | grep -Fxq '# Managed by azure-cli-container installer'; then
            owned=1
        fi
        [[ "$owned" = 1 ]] || { printf '既存ファイルを保護して中止: %s\n' "$path" >&2; exit 1; }
    fi
done

stage=$(mktemp -d "$destination/.azure-cli-container-install.XXXXXX")
trap 'rm -rf "$stage"' EXIT
for name in az-container az-shell; do
    cp "$script_dir/$name" "$stage/$name"
    chmod 755 "$stage/$name"
done
ln -s az-container "$stage/az"

backup=''
for name in az az-container az-shell; do
    path="$destination/$name"
    if [[ -e "$path" || -L "$path" ]]; then
        if [[ -z "$backup" ]]; then backup=$(mktemp -d "$destination/.azure-cli-container-backup.XXXXXX"); fi
        cp -Pp "$path" "$backup/$name"
    fi
done

for name in az az-container az-shell; do mv -f "$stage/$name" "$destination/$name"; done
printf 'インストール完了: %s（clone先は削除できます）\n' "$destination"
[[ -z "$backup" ]] || printf '変更前のバックアップ: %s\n' "$backup"
