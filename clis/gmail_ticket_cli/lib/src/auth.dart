import 'dart:io';

import 'package:gmail_ticket_cli/src/token_store.dart';
import 'package:googleapis_auth/auth_io.dart' as auth_io;
import 'package:googleapis_auth/googleapis_auth.dart' as auth;
import 'package:http/http.dart' as http;

/// ブラウザの同意フローで認証クライアントを取得する。
///
/// 取得した認証情報と [clientId] を [tokenStore] に保存する。
/// `login` サブコマンドと、キャッシュが使えない場合のフォールバックで使う。
Future<auth.AutoRefreshingAuthClient> consentAuthClient({
  required auth.ClientId clientId,
  required TokenStore tokenStore,
  required List<String> scopes,
  required int listenPort,
}) async {
  final client = await auth_io.clientViaUserConsent(
    clientId,
    scopes,
    (url) {
      stdout
        ..writeln('ブラウザで次の URL を開いて Google アカウントで同意してください:')
        ..writeln(url);
    },
    listenPort: listenPort,
  );
  tokenStore.save(clientId, client.credentials);
  return client;
}

/// OAuth 認証クライアントを取得する。
///
/// キャッシュ済みの認証情報があればそれを使い、期限切れなら更新する。
/// どちらも使えない場合は [consentAuthClient] の同意フローを行う。
Future<auth.AutoRefreshingAuthClient> obtainAuthClient({
  required auth.ClientId clientId,
  required TokenStore tokenStore,
  required List<String> scopes,
  required int listenPort,
}) async {
  final cachedCredentials = tokenStore.load()?.credentials;
  if (cachedCredentials != null && cachedCredentials.refreshToken != null) {
    if (!cachedCredentials.accessToken.hasExpired) {
      return auth_io.autoRefreshingClient(
        clientId,
        cachedCredentials,
        http.Client(),
      );
    }
    try {
      final refreshed = await auth_io.refreshCredentials(
        clientId,
        cachedCredentials,
        http.Client(),
      );
      tokenStore.save(clientId, refreshed);
      return auth_io.autoRefreshingClient(clientId, refreshed, http.Client());
    } on Exception catch (error) {
      // 更新に失敗した(refresh token が失効した等)場合は
      // 同意フローで取り直すため握りつぶさず理由を出力する。
      stdout
        ..writeln('キャッシュしたトークンの更新に失敗したため再認証します。')
        ..writeln('理由: $error');
      tokenStore.clear();
    }
  }
  return consentAuthClient(
    clientId: clientId,
    tokenStore: tokenStore,
    scopes: scopes,
    listenPort: listenPort,
  );
}
