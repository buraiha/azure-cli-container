#!/usr/bin/env bash
set -euo pipefail
# Installs links only; never edits shell startup files or replaces existing files.
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)
destination=${AZ_CONTAINER_BIN_DIR:-$HOME/.local/bin}
mkdir -p "$destination"
for name in az az-container az-shell; do
    target="$script_dir/$name"
    [[ "$name" != az ]] || target="$script_dir/az-container"
    link="$destination/$name"
    if [[ -e "$link" || -L "$link" ]]; then
        if [[ -L "$link" && "$(readlink "$link")" = "$target" ]]; then continue; fi
        printf '既存ファイルを変更せず終了します: %s\n' "$link" >&2
        exit 1
    fi
done
for name in az az-container az-shell; do
    target="$script_dir/$name"
    [[ "$name" != az ]] || target="$script_dir/az-container"
    [[ -L "$destination/$name" ]] || ln -s "$target" "$destination/$name"
done
printf '設定完了。シェルのPATHに次を追加してください: %s\n' "$destination"
