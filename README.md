# Kakin

推し活のお金を、月の「推し活代」から残高で管理する Flutter アプリです。
カレンダー・リスト・今後の公演・設定の4タブで、支出・公演・チケット申込・チェキ相手を記録します。
データは端末内の SQLite（drift）だけに保存し、登録やログインは不要です。
振る舞いの正は [SPEC](docs/SPEC.md)、用語の正は [GLOSSARY](GLOSSARY.md)、スキーマの正は [DB](docs/DB.md) です。

## セットアップ

SDK とツールの版数は `.mise.toml`、依存とコマンドはルート `pubspec.yaml` を正とします。
Flutter 3.44.6 / Dart 3.12 系の Pub workspace に、`app`・`packages/*`・`clis/*` を配置しています。

```sh
mise install
mise run setup
cp app/.dart_define/sample.json app/.dart_define/development.json
cd app
flutter run --dart-define-from-file=.dart_define/development.json
```

Melos はルート `pubspec.yaml` の版数に固定し、常に `dart run melos` で実行します。
`.dart_define/*.json` の `APP_ID`・`APP_ID_SUFFIX`・`APP_NAME` は Android の application ID とランチャー名、
iOS の bundle ID と表示名に反映されます。実プロジェクト用 JSON は Git 管理から除外し、`sample.json` だけを管理します。

### Android

`flutter_local_notifications` 23 のため compileSdk 37 以上・AGP 9.1.1 以上・core library desugaring を有効にしています。

### Gmail 連携（OAuth）

Google の OAuth クライアント ID を `--dart-define` で渡すと、実際の Gmail を読み取ります（`gmail.readonly`）。
渡さないときは端末内のデモデータ（`demo@kakin.example`）で連携の流れを確認でき、設定画面に「デモデータ」と表示します。

1. Google Cloud Console でプロジェクトを作り、Gmail API を有効にします。
2. OAuth 同意画面を設定し、スコープ `https://www.googleapis.com/auth/gmail.readonly` とテストユーザーを追加します。
3. 認証情報で次の OAuth クライアント ID を作ります。
   - iOS: bundle ID は `APP_ID`（既定 `com.example.app`）
   - Android: package 名は `APP_ID`、SHA-1 は署名鍵のもの
   - ウェブアプリケーション: Android がサーバー用クライアント ID として使います
4. iOS は `app/ios/Runner/Info.plist` に `GIDClientID` と、逆順クライアント ID の URL スキーム（`CFBundleURLTypes`）を追加します。
5. 次の値を `.dart_define/development.json` に追加して起動します。

```json
{
  "GOOGLE_IOS_CLIENT_ID": "<iOS クライアント ID>",
  "GOOGLE_SERVER_CLIENT_ID": "<ウェブアプリケーションのクライアント ID>"
}
```

クライアント ID の選択は `app/lib/app/dependency_graph.dart` が行い、どちらも未設定ならデモに切り替えます。
定期バックグラウンドの同期は未実装で、手動同期と初回連携の取り込みだけが動きます。

## 構成

```text
app/lib/
├── app/                 # bootstrap、依存の結線、通知の応答、root widget
├── domain/              # 推し活代・残高、暦日と日本時間、二重計上、リマインド計画
├── application/         # models・ports・use_cases・errors
├── infrastructure/      # drift・SharedPreferences・通知・Gmail・画像の adapter
├── presentation/
│   ├── dependencies/    # 必ず注入する use case / ErrorReporter の token
│   ├── features/        # calendar・expense_list・upcoming・settings・onboarding などの画面
│   ├── navigation/      # typed route と router の組み立て
│   └── shared/          # 共有の controller・Widget・AppKeys
└── core/                # 翻訳生成物、locale 解決、金額と日付の書式、logger
app/patrol_test/         # Patrol の E2E
packages/design_system/  # テーマ・ライトとダークのパレット・トークン・数字用フォント
packages/month_calendar/ # 月のカレンダーの格子
packages/gmail_ticket_source/ # Gmail の検索クエリと MIME の本文抽出
packages/ticket_*/       # チケットサービスごとのメール解析
clis/gmail_ticket_cli/   # 実メールで解析を確かめる CLI
```

詳細は [アーキテクチャ](docs/ARCHITECTURE.md) を参照してください。

## 検証

ルートから実行します。生成物は入力から更新し、手編集しません。

```sh
dart run melos run gen
dart run melos run gen:slang
mise run quality
git diff --check
```

`quality` は全 workspace の format check・静的解析・翻訳解析・テスト・dprint を実行します。
テストは `app/test/` に実装と同じレイヤー構成で配置します。

### E2E（Patrol）

`patrol_cli` 4.9.0 を使います。iOS Simulator を起動してから `app` で実行します。

```sh
dart pub global activate patrol_cli 4.9.0
cd app
patrol test -d <シミュレーターの UDID>
```

テストは端末内の DB と設定を消してから日本語で起動します。
Widget の key は `app/lib/presentation/shared/keys/app_keys.dart` をアプリとテストで共有します。
iOS は `RunnerUITests` ターゲット、Android は `MainActivityTest` と Test Orchestrator で動きます。

### 動作確認（Marionette）

debug ビルドは `MarionetteBinding` で起動し、`marionette-agent` から VM Service 経由で操作できます。
手順は `.claude/skills/marionette-agent/SKILL.md` を参照してください。

## Agent 向けの作業手順

`.agents/skills/` に project skill を配置しています。
Melos 同梱の公式 skill は Dart skills CLI で取得し、`.config/dart_skills/skills_config.json` で管理します。
用途と管理方針は [Agent skills](docs/agent-skills.md)、共通規約は [AGENTS.md](AGENTS.md) を参照してください。
