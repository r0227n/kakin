# app

Kakin の実行アプリです。初期化の入口は `lib/main.dart`、起動と依存注入は `lib/app/` にあります。

セットアップ、Gmail の OAuth、生成・検証、E2E は [ルート README](../README.md) を参照してください。
[アーキテクチャ](../docs/ARCHITECTURE.md) と [仕様](../docs/SPEC.md) に従って拡張します。

ルートで `mise run setup` を実行した後、このディレクトリで起動します。

```sh
flutter run --dart-define-from-file=.dart_define/sample.json
patrol test -d <シミュレーターの UDID>
```
