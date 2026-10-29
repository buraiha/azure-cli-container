# 検証記録

2026-10-29、macOS arm64で実施。

- macOS標準Bashによる全スクリプトの構文チェック: 成功。
- `bash tests/wrapper.sh`: 引数・空引数・空白パス・標準入力・終了コード37の保持、非TTY、Podman keep-id、Bash起動、認証保存先制約、インストール再実行・既存ファイル保護: 成功。
- 起動済みPodmanと既存の公式Azure Linux 3.0イメージ（Azure CLI 2.90.0）で`az version`: 成功。
- `az-shell`から作業ディレクトリへのファイル作成とホスト所有者を確認。
- 一時的な専用キャッシュへCLI設定を書き込み、別コンテナで設定の永続化を確認。
- 公開対象の秘密情報パターン検査、Git差分チェック: 成功。

Docker daemonは停止中のためDocker実機試験は未実施。Docker経路は偽エンジンによる引数テストのみ。WSL2/Linux、SELinux、実端末TTY操作は実機未検証。Azureへのログイン・API操作・リソース作成は行っていません。

## コピー式インストールへの変更

`bash tests/install.sh`で実体コピー、再インストール、既存リンクからの移行、無関係なコマンドの保護を確認。テスト用clone先を削除した後も、インストールした`az`と`az-shell`が動くことを偽エンジンで検証します。

macOS + Podmanでは隔離したインストール先にコピーし、配布元を削除した後の`az version`と`az-shell -c 'az version'`も実行して成功（Azure CLI 2.90.0）。
