# 使用方法

```bash
az version
az group list -o json > groups.json
az deployment group validate --resource-group '<名前>' --template-file template.json
az-shell
printf '%s' '{}' | az rest --method post --url '<対象URL>' --body @-
```

通常の引数をそのまま転送し、終了コードと標準入力を維持します。端末入出力の場合だけTTYを付けます。作業フォルダを`/workspace`へ読み書きマウントするため、入力ファイルはその配下の相対パスを使ってください。コンテナ内で見えないホストの絶対パスは使用できません。出力ファイルはホストUID/GIDで作成します。ホスト側の設定ディレクトリ作成時のumaskは077です。コンテナが作成する出力ファイルの権限はコンテナ内の設定に依存します。

| 変数 | 用途 |
| --- | --- |
| AZ_CONTAINER_ENGINE | docker / podman。未指定はPodman優先 |
| AZ_CONTAINER_IMAGE | 公式Azure Linuxイメージを標準とし、バージョン/digest指定も可能 |
| AZ_CONTAINER_CONFIG_DIR | 認証・設定用の専用絶対パス |
| AZ_CONTAINER_BIN_DIR | インストール先。標準は~/.local/bin |

`az-shell`は同じマウント・ユーザーでBashを起動します。`az-shell -c 'az version'`も利用できます。Podmanは`--userns=keep-id`を使用します。追加の秘密・プロキシ変数やマウントは自動転送しません。信頼できるイメージだけを指定してください。

`examples/resource-group.sh`は読み取り専用の例です。Azureリソースの作成・削除はしません。
