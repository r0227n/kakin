import 'dart:convert';
import 'dart:io';

import 'package:gmail_ticket_cli/src/credentials.dart';
import 'package:gmail_ticket_cli/src/token_store.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as auth;
import 'package:test/test.dart';

void main() {
  late Directory directory;
  late File file;
  late TokenStore store;

  setUp(() {
    directory = Directory.systemTemp.createTempSync('gmail_ticket_cli_test');
    file = File('${directory.path}/credentials.json');
    store = TokenStore(file: file);
  });

  tearDown(() {
    if (directory.existsSync()) {
      directory.deleteSync(recursive: true);
    }
  });

  auth.AccessCredentials credentials() => auth.AccessCredentials(
    auth.AccessToken(
      'Bearer',
      'access-token',
      DateTime.now().toUtc().add(const Duration(hours: 1)),
    ),
    'refresh-token',
    const <String>['https://www.googleapis.com/auth/gmail.readonly'],
  );

  test('キャッシュが無い場合は null を返す', () {
    expect(store.load(), isNull);
  });

  test('save した認証情報とクライアント設定を load で読み戻せる', () {
    store.save(auth.ClientId('id-1', 'secret-1'), credentials());

    final loaded = store.load();
    expect(loaded, isNotNull);
    expect(loaded!.clientId!.identifier, 'id-1');
    expect(loaded.clientId!.secret, 'secret-1');
    expect(loaded.credentials.accessToken.data, 'access-token');
    expect(loaded.credentials.refreshToken, 'refresh-token');
    expect(
      loaded.credentials.scopes,
      const <String>['https://www.googleapis.com/auth/gmail.readonly'],
    );
  });

  test('クライアント設定の無い旧形式のキャッシュも読み取れる', () {
    file.writeAsStringSync(jsonEncode(credentials().toJson()));

    final loaded = store.load();
    expect(loaded!.clientId, isNull);
    expect(loaded.credentials.accessToken.data, 'access-token');
    expect(loaded.credentials.refreshToken, 'refresh-token');
  });

  test('save は必要なディレクトリを作成する', () {
    final nested = File('${directory.path}/nested/credentials.json');
    TokenStore(
      file: nested,
    ).save(auth.ClientId('id-1', 'secret-1'), credentials());

    expect(nested.existsSync(), isTrue);
  });

  test('壊れたキャッシュは ConfigException を投げる', () {
    file.writeAsStringSync('not-json');

    expect(store.load, throwsA(isA<ConfigException>()));
  });

  test('JSON がオブジェクトで無いキャッシュも ConfigException を投げる', () {
    file.writeAsStringSync('["a"]');

    expect(store.load, throwsA(isA<ConfigException>()));
  });

  test('clear はキャッシュを削除する', () {
    store
      ..save(auth.ClientId('id-1', 'secret-1'), credentials())
      ..clear();

    expect(file.existsSync(), isFalse);
    expect(store.load(), isNull);
  });
}
