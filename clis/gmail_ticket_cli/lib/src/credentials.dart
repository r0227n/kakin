import 'dart:io';

import 'package:googleapis_auth/googleapis_auth.dart' as auth;

/// CLI の設定不備を表す例外。
class ConfigException implements Exception {
  const ConfigException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// 環境変数から OAuth クライアントの設定を読み取る。
///
/// 両方の環境変数が設定されていない場合は null を返す。
auth.ClientId? loadClientIdFromEnv() {
  final id = Platform.environment['GMAIL_TICKET_CLI_CLIENT_ID'];
  final secret = Platform.environment['GMAIL_TICKET_CLI_CLIENT_SECRET'];
  if (id == null || id.isEmpty || secret == null || secret.isEmpty) {
    return null;
  }
  return auth.ClientId(id, secret);
}
