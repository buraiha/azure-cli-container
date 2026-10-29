# Azure CLI Container

WSL2 / Linux / macOSのBashからMicrosoft公式Azure CLIコンテナを実行するラッパーです。ホストにAzure CLIは不要です。Docker / PodmanとBash 3.2以降が必要です。WindowsではWSL2内で実行してください。

## 最短手順

```bash
git clone https://github.com/buraiha/azure-cli-container.git
cd azure-cli-container
./bin/install-alias.sh
export PATH="$HOME/.local/bin:$PATH"
export AZ_CONTAINER_ENGINE=docker  # Podmanの場合はpodman

docker pull mcr.microsoft.com/azure-cli:azurelinux3.0
az version
az login --use-device-code
az account show -o table
az group list -o table
```

Podmanを使う場合は`podman pull`で取得します。エンジン未指定時はPodman、Dockerの順でコマンドの存在を確認します。起動状況による自動切替はしません。

- [セットアップ](docs/setup.md)
- [認証と安全性](docs/authentication.md)
- [使用方法・設定](docs/usage.md)
- [トラブル対応](docs/troubleshooting.md)

`bin/install-alias.sh`は`~/.local/bin`に`az`、`az-container`、`az-shell`のリンクを作ります。既存の別ファイルは上書きしません。シェル設定は変更しません。リポジトリを移動するとリンクの再設定が必要です。

認証キャッシュは作業フォルダ外の専用ディレクトリに保存します。現在の作業フォルダはコンテナから読み書きできます。Azureの操作前には対象サブスクリプションを確認してください。

## 検証

```bash
bash tests/wrapper.sh
```

引数、空白を含むパス、標準入力、終了コード、インストールの衝突防止を偽のエンジンで検証します。Azureへのログインやリソース操作は行いません。実機検証結果は[検証記録](docs/validation.md)参照。

MIT License。Microsoftの公式プロジェクトではありません。
