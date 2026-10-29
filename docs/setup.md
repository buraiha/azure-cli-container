# セットアップ

WindowsはWSL2のBashで使用します。Docker DesktopのWSL IntegrationまたはWSL内のDocker/Podmanが必要です。可能ならLinux側のファイルシステムに配置してください。LinuxではDocker EngineまたはPodman、macOSではDocker Desktopまたは起動済みのPodman machineを使用します。

`docker info`または`podman info`が成功する状態にしてください。スクリプトはmacOS標準Bash 3.2に対応しています。macOSのzshからも実行できます。PATHの永続設定先はBashなら`~/.bashrc`、zshなら`~/.zshrc`等です。

READMEの手順でクローン・リンク作成後、PATHを設定します。アンインストールはリンク先を確認して、このツールを指す3つのリンクだけを手動で取り除いてください。認証キャッシュは自動削除しません。

標準イメージは`mcr.microsoft.com/azure-cli:azurelinux3.0`です。移動タグなので、再現性が必要な環境では検証済みバージョンタグまたはdigestを`AZ_CONTAINER_IMAGE`へ指定してください。更新時は選択したエンジンでpullし、`az version`を確認します。旧Alpineイメージは使用しません。

公式資料: https://learn.microsoft.com/cli/azure/run-azure-cli-docker
