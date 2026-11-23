/// Gmail API からチケットサービスのメールを取得する共通処理。
///
/// 認証は担わない。呼び出し側が認証済みの `GmailApi` を渡す。
library;

export 'src/gmail_fetcher.dart';
export 'src/mime.dart';
export 'src/query_builder.dart';
