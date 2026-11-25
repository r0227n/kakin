import 'package:app/application/application.dart';
import 'package:app/application/errors/gmail_error.dart';
import 'package:app/infrastructure/gmail/ticket_mail_parser.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:gmail_ticket_source/gmail_ticket_source.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/gmail/v1.dart' as gmail;
import 'package:googleapis_auth/googleapis_auth.dart'
    show AccessDeniedException;

/// OAuth クライアントの設定。`--dart-define` で渡す。
final class GoogleOAuthConfig {
  /// iOS 用と、Android で必要な Web 用のクライアント ID。
  const GoogleOAuthConfig({this.iosClientId, this.serverClientId});

  /// `--dart-define` の値から作る。
  const GoogleOAuthConfig.fromEnvironment()
    : iosClientId = const bool.hasEnvironment('GOOGLE_IOS_CLIENT_ID')
          ? const String.fromEnvironment('GOOGLE_IOS_CLIENT_ID')
          : null,
      serverClientId = const bool.hasEnvironment('GOOGLE_SERVER_CLIENT_ID')
          ? const String.fromEnvironment('GOOGLE_SERVER_CLIENT_ID')
          : null;

  /// iOS 用の OAuth クライアント ID。
  final String? iosClientId;

  /// Android で ID トークンの発行先にする Web 用の OAuth クライアント ID。
  final String? serverClientId;

  /// 本物の Gmail に接続できる設定があるか。
  bool get isConfigured => iosClientId != null || serverClientId != null;
}

/// `google_sign_in` と Gmail API で、読み取り専用でメールを取得する。
final class GoogleGmailMailbox implements GmailMailbox {
  /// OAuth の設定で `GoogleSignIn` を初期化する。
  GoogleGmailMailbox(this._config, {GoogleSignIn? signIn})
    : _signIn = signIn ?? GoogleSignIn.instance;

  static const List<String> _scopes = [gmail.GmailApi.gmailReadonlyScope];
  static const _maxMessages = 500;

  final GoogleOAuthConfig _config;
  final GoogleSignIn _signIn;
  final TicketMailParser _parser = const TicketMailParser();
  Future<void>? _initialization;
  GoogleSignInAccount? _account;

  Future<void> _initialize() => _initialization ??= _signIn.initialize(
    clientId: _config.iosClientId,
    serverClientId: _config.serverClientId,
  );

  @override
  bool get isDemo => false;

  @override
  Future<String?> connect() async {
    await _initialize();
    try {
      final account = await _signIn.authenticate(scopeHint: _scopes);
      await account.authorizationClient.authorizeScopes(_scopes);
      _account = account;
      return account.email;
    } on GoogleSignInException catch (error) {
      if (error.code == GoogleSignInExceptionCode.canceled) return null;
      rethrow;
    }
  }

  @override
  Future<String?> restore() async {
    await _initialize();
    _account ??= await _signIn.attemptLightweightAuthentication();
    return _account?.email;
  }

  @override
  Future<List<TicketMail>> fetchTicketMails({required DateTime after}) async {
    final account = _account;
    if (account == null) throw const GmailReauthRequiredException();
    final authorization = await account.authorizationClient
        .authorizationForScopes(_scopes);
    if (authorization == null) throw const GmailReauthRequiredException();
    final client = authorization.authClient(scopes: _scopes);
    try {
      final fetcher = GmailFetcher(gmail.GmailApi(client));
      final emails = await fetcher.fetch(
        query: applySince(
          buildDefaultQuery(TicketMailParser.services),
          after.toUtc(),
        ),
        max: _maxMessages,
      );
      return [
        for (final email in emails)
          if (email.receivedAt case final receivedAt?)
            ?_parser.parse(
              messageId: email.id,
              receivedAt: receivedAt,
              from: email.from,
              subject: email.subject,
              bodyText: email.bodyText,
            ),
      ];
    } on AccessDeniedException catch (error, stackTrace) {
      throw GmailReauthRequiredException(
        cause: error,
        causeStackTrace: stackTrace,
      );
    } on gmail.DetailedApiRequestError catch (error, stackTrace) {
      if (error.status == 401 || error.status == 403) {
        throw GmailReauthRequiredException(
          cause: error,
          causeStackTrace: stackTrace,
        );
      }
      throw GmailSyncException(cause: error, causeStackTrace: stackTrace);
    } finally {
      client.close();
    }
  }

  @override
  Future<void> disconnect() async {
    await _initialize();
    await _signIn.disconnect();
    _account = null;
  }
}
