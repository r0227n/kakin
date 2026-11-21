import 'dart:convert';
import 'dart:io';

import 'package:gmail_ticket_cli/src/credentials.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as auth;

/// キャッシュから読み込んだ認証情報とクライアント設定。
class StoredAuth {
  const StoredAuth({required this.clientId, required this.credentials});

  /// 保存済みの OAuth クライアント設定。
  ///
  /// クライアント設定を保存しない旧形式のキャッシュの場合は null。
  final auth.ClientId? clientId;

  /// キャッシュした認証情報。
  final auth.AccessCredentials credentials;
}

/// OAuth 認証情報をローカルファイルにキャッシュする。
class TokenStore {
  TokenStore({required this._file});

  /// 既定の場所(~/.config/gmail_ticket_cli/credentials.json)の
  /// [TokenStore] を返す。
  factory TokenStore.defaultStore() {
    final home = Platform.environment['HOME'];
    if (home == null || home.isEmpty) {
      throw const ConfigException('HOME 環境変数が設定されていません。');
    }
    final directory = Directory('$home/.config/gmail_ticket_cli');
    return TokenStore(file: File('${directory.path}/credentials.json'));
  }

  final File _file;

  /// キャッシュファイルのパス。
  String get path => _file.path;

  /// キャッシュした認証情報とクライアント設定を読み込む。
  ///
  /// キャッシュが無ければ null を返す。内容が壊れている場合は
  /// [ConfigException] を投げる。
  StoredAuth? load() {
    if (!_file.existsSync()) {
      return null;
    }
    final Object? json;
    try {
      json = jsonDecode(_file.readAsStringSync());
    } on FormatException {
      throw _corruptedCache();
    }
    if (json is! Map<String, dynamic>) {
      throw _corruptedCache();
    }
    // 旧形式のキャッシュは認証情報が直接格納され、クライアント設定は無い。
    final Object? credentialsJson = json['credentials'] ?? json;
    if (credentialsJson is! Map<String, dynamic>) {
      throw _corruptedCache();
    }
    final auth.AccessCredentials credentials;
    try {
      credentials = auth.AccessCredentials.fromJson(credentialsJson);
    } on Object {
      throw _unreadableCache();
    }
    return StoredAuth(
      clientId: _cachedClientId(json),
      credentials: credentials,
    );
  }

  /// クライアント設定と認証情報をキャッシュに保存する。
  void save(auth.ClientId clientId, auth.AccessCredentials credentials) {
    final directory = _file.parent;
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    _file.writeAsStringSync(
      const JsonEncoder.withIndent('  ').convert(<String, Object?>{
        'clientId': clientId.identifier,
        'clientSecret': clientId.secret,
        'credentials': credentials.toJson(),
      }),
    );
  }

  /// キャッシュを削除する。存在しない場合は何もしない。
  void clear() {
    if (_file.existsSync()) {
      _file.deleteSync();
    }
  }

  auth.ClientId? _cachedClientId(Map<String, dynamic> json) {
    final identifier = json['clientId'];
    final secret = json['clientSecret'];
    if (identifier is String &&
        identifier.isNotEmpty &&
        secret is String &&
        secret.isNotEmpty) {
      return auth.ClientId(identifier, secret);
    }
    return null;
  }

  ConfigException _corruptedCache() => ConfigException(
    '認証情報のキャッシュが壊れています。'
    '--reset-auth で再認証してください。(${_file.path})',
  );

  ConfigException _unreadableCache() => ConfigException(
    '認証情報のキャッシュを読み取れません。'
    '--reset-auth で再認証してください。(${_file.path})',
  );
}
