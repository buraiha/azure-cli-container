# セットアップ

WindowsはWSL2のBashで使用します。Docker DesktopのWSL IntegrationまたはWSL内のDocker/Podmanが必要です。可能ならLinux側のファイルシステムに配置してください。LinuxではDocker EngineまたはPodman、macOSではDocker Desktopまたは起動済みのPodman machineを使用します。

`docker info`または`podman info`が成功する状態にしてください。スクリプトはmacOS標準Bash 3.2に対応しています。macOSのzshからも実行できます。PATHの永続設定先はBashなら`~/.bashrc`、zshなら`~/.zshrc`等です。

READMEの手順でcloneし、`./bin/install.sh`を実行してPATHを設定します。スクリプトの実体は`~/.local/bin`にコピーされるため、インストール後のclone先は削除できます。`az`は同じbin内の`az-container`への相対リンクです。

更新時は再度clone（手元に残っていれば`git pull --ff-only`）し、`./bin/install.sh`を再実行します。管理対象の旧版は`.azure-cli-container-backup.*`へ退避します。旧リンク方式から同じclone先で再実行すれば移行できます。別のclone先を参照する既存リンクは自動置換しないため、リンク先を確認して旧リンクだけを外してから実行してください。

アンインストールはインストール先にある管理対象の`az`、`az-container`、`az-shell`を確認して取り除きます。バックアップの削除は任意です。認証キャッシュは自動削除しません。

標準イメージは`mcr.microsoft.com/azure-cli:azurelinux3.0`です。移動タグなので、再現性が必要な環境では検証済みバージョンタグまたはdigestを`AZ_CONTAINER_IMAGE`へ指定してください。更新時は選択したエンジンでpullし、`az version`を確認します。旧Alpineイメージは使用しません。

公式資料: https://learn.microsoft.com/cli/azure/run-azure-cli-docker
