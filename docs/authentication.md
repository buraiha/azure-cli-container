# 認証と安全性

```bash
az login --use-device-code
az account list -o table
az account set --subscription '<対象IDまたは名前>'
az account show -o table
```

表示されたURLとコードでホストのブラウザから認証します。組織の条件付きアクセスで禁止されている場合は管理者指定の認証方式を使用してください。

キャッシュの標準保存先は`${XDG_CONFIG_HOME:-$HOME/.config}/azure-cli-container`です。専用ディレクトリの権限を700にし、コンテナでは`/tmp/az-home/.azure`へマウントします。ホストの`~/.azure`やSSH鍵、Dockerソケットはマウントしません。作業フォルダ内に認証保存先を設定すると拒否します。ホーム全体など広い範囲からの実行は避けてください。

トークン、認証JSON、環境ファイル、debugログを公開しないでください。`.gitignore`は漏えいの完全な防止策ではありません。引数に秘密を渡すとプロセス一覧やシェル履歴に残り得ます。ホストの環境変数は自動転送しません。

`az logout`でログアウト、`az account clear`でアカウント一覧を消去できます。キャッシュの削除は設定や拡張も失うため自動化していません。同じキャッシュへの並行書き込みは避けてください。

TerraformにはCLIの存在と認証設定が別途必要です。ホストのTerraformへコンテナのログイン状態が自動継承されるとは想定しないでください。
