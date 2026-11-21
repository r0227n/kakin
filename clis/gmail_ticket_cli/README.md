# gmail_ticket_cli

Gmail からチケットサービス(eplus・ライブポケット)のメールを取得し、
`ticket_eplus` / `ticket_livepocket` の公演情報の抽出処理の動作を確認する CLI。

## 必要なもの

- Google Cloud プロジェクトで Gmail API を有効化済み
- 「デスクトップ アプリ」タイプの OAuth クライアント
- OAuth 同意画面にテストユーザーとして自分のアカウントを登録済み

## 認証(login サブコマンド)

`login` サブコマンドに `--client-id` と `--client-secret` で
OAuth クライアントの設定を渡すと、ブラウザの同意フローを実行して
認証情報をキャッシュする。

```sh
dart run bin/gmail_ticket_cli.dart login \
  --client-id <クライアントID> --client-secret <クライアントシークレット>
```

ログイン済みなら、以後は引数・環境変数なしで実行できる。

```sh
dart run bin/gmail_ticket_cli.dart
```

環境変数 `GMAIL_TICKET_CLI_CLIENT_ID` と `GMAIL_TICKET_CLI_CLIENT_SECRET`
を設定した場合はそちらが優先される(login をしないで最初の実行から
同意フローに進む、環境変数での従来の使い方も可能)。

トークンは `~/.config/gmail_ticket_cli/credentials.json` にクライアント
設定と合わせて保存される。トークンが失効したら `--reset-auth` で
キャッシュを削除して再認証する。`login` は実行のたびに同意フローを
やり直し、キャッシュを上書きする。

※ クライアント シークレットはコマンドライン引数として渡るため、
シェルの履歴に残る点に注意。

## 使い方

```sh
cd clis/gmail_ticket_cli
dart run bin/gmail_ticket_cli.dart login \
  --client-id <クライアントID> --client-secret <クライアントシークレット>
dart run bin/gmail_ticket_cli.dart
```

melos スクリプト経由:

```sh
dart run melos run cli:gmail_ticket
```

`--` 以降の引数は CLI に渡る。

```sh
dart run melos run cli:gmail_ticket -- --max 1 --json
```

melos の制約で `--help`(と `-h`)は渡せない
(melos 自体が `--help` を解釈してエラーになる)。ヘルプを見るには
直接実行する:

```sh
cd clis/gmail_ticket_cli && dart run bin/gmail_ticket_cli.dart --help
```

主なオプション:

| オプション           | 内容                                   |
| -------------------- | -------------------------------------- |
| `--max`              | 取得する最大件数(既定 100)             |
| `--since YYYY-MM-DD` | この日以降のメールのみ取得             |
| `--query "..."`      | Gmail 検索クエリの完全な上書き         |
| `--json`             | 抽出結果を JSON で出力                 |
| `--dump`             | 件名と本文を出力(fixture 収集用)       |
| `--reset-auth`       | キャッシュした認証情報を削除して再認証 |
