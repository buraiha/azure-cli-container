# トラブル対応

- エンジン接続失敗: Docker DesktopやPodman machineの起動と`info`を確認。両方インストール済みなら`AZ_CONTAINER_ENGINE`を明示。
- azが見つからない: PATHと`command -v az`、リンク先を確認。
- Permission denied: キャッシュ所有者、ホストUID/GID、Docker user namespace設定、Podman keep-idを確認。SELinux環境ではbind mountのラベル設定が別途必要な場合があります。このツールは自動relabelしません。
- 入力ファイルが見えない: 現在の作業ディレクトリ内に置き相対パスを使用。カンマや改行を含むマウント元パスは拒否します。
- サブスクリプションが見えない: テナントと`az account list`、対象のRBAC権限を確認。
- イメージ取得失敗: MCRへのネットワーク接続、プロキシ、タグ/CPUアーキテクチャを確認。必要なら互換イメージを明示。自動エミュレーションは設定しません。
- 拡張やバージョンの差: イメージを固定し、永続キャッシュに残る拡張も別途管理。
