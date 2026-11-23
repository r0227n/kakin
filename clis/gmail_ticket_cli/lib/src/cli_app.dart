import 'dart:io';

import 'package:args/args.dart';
import 'package:gmail_ticket_cli/src/auth.dart';
import 'package:gmail_ticket_cli/src/cli_args.dart';
import 'package:gmail_ticket_cli/src/credentials.dart';
import 'package:gmail_ticket_cli/src/report.dart';
import 'package:gmail_ticket_cli/src/token_store.dart';
import 'package:gmail_ticket_source/gmail_ticket_source.dart';
import 'package:googleapis/gmail/v1.dart' as gmail;
import 'package:googleapis_auth/googleapis_auth.dart' as auth;
import 'package:ticket_eplus/ticket_eplus.dart';
import 'package:ticket_livepocket/ticket_livepocket.dart';
import 'package:ticket_platform_interface/ticket_platform_interface.dart';

/// 既定で要求する OAuth スコープ。
const List<String> _gmailScopes = <String>[gmail.GmailApi.gmailReadonlyScope];

/// Gmail からチケットサービスのメールを取得して公演情報の抽出を確認する。
Future<void> runCli(List<String> arguments) async {
  final parser = buildArgParser();
  final ArgResults argResults;
  try {
    argResults = parser.parse(arguments);
  } on ArgParserException catch (error) {
    stderr
      ..writeln(error.message)
      ..writeln()
      ..writeln(parser.usage);
    exitCode = 64;
    return;
  }

  if (argResults.command?.name == 'login') {
    await _runLogin(argResults.command!);
    return;
  }

  if (argResults['help'] as bool) {
    stdout
      ..writeln('Gmail からチケットサービスのメールを取得して公演情報を抽出する CLI。')
      ..writeln()
      ..writeln('使い方: dart run bin/gmail_ticket_cli.dart [オプション]')
      ..writeln(
        '        dart run bin/gmail_ticket_cli.dart '
        'login --client-id <クライアントID> '
        '--client-secret <クライアントシークレット>',
      )
      ..writeln()
      ..writeln(parser.usage);
    return;
  }

  final CliOptions options;
  try {
    options = CliOptions.from(argResults);
  } on FormatException catch (error) {
    stderr
      ..writeln(error.message)
      ..writeln()
      ..writeln(parser.usage);
    exitCode = 64;
    return;
  }

  final services = <TicketService>[
    const EplusTicketService(),
    const LivepocketTicketService(),
  ];

  final TokenStore tokenStore;
  final auth.ClientId clientId;
  try {
    tokenStore = TokenStore.defaultStore();
    clientId = _resolveClientId(tokenStore);
  } on ConfigException catch (error) {
    stderr.writeln(error);
    exitCode = 64;
    return;
  }
  if (options.resetAuth) {
    tokenStore.clear();
  }

  final auth.AutoRefreshingAuthClient authClient;
  try {
    authClient = await obtainAuthClient(
      clientId: clientId,
      tokenStore: tokenStore,
      scopes: _gmailScopes,
      listenPort: options.port,
    );
  } on Exception catch (error) {
    stderr
      ..writeln('Gmail API の認証に失敗しました。')
      ..writeln(error);
    exitCode = 70;
    return;
  }

  try {
    await _fetchAndReport(authClient, services, options);
  } on Exception catch (error) {
    stderr
      ..writeln('Gmail API の呼び出しに失敗しました。')
      ..writeln(error);
    exitCode = 70;
  } finally {
    authClient.close();
  }
}

/// `login` サブコマンド: クライアント設定を引数で受け取り同意フローを行う。
Future<void> _runLogin(ArgResults commandResults) async {
  final loginParser = buildLoginParser();
  if (commandResults['help'] as bool) {
    stdout
      ..writeln('OAuth クライアントの設定を受け取り、同意フローで認証します。')
      ..writeln()
      ..writeln(
        '使い方: login --client-id <クライアントID> --client-secret <クライアントシークレット>',
      )
      ..writeln()
      ..writeln(loginParser.usage);
    return;
  }

  final LoginOptions options;
  try {
    options = LoginOptions.from(commandResults);
  } on FormatException catch (error) {
    stderr
      ..writeln(error.message)
      ..writeln()
      ..writeln(loginParser.usage);
    exitCode = 64;
    return;
  }

  final TokenStore tokenStore;
  try {
    tokenStore = TokenStore.defaultStore();
    final client = await consentAuthClient(
      clientId: auth.ClientId(options.clientId, options.clientSecret),
      tokenStore: tokenStore,
      scopes: _gmailScopes,
      listenPort: options.port,
    );
    client.close();
    stdout
      ..writeln('ログインしました。')
      ..writeln('認証情報は ${tokenStore.path} に保存されました。');
  } on ConfigException catch (error) {
    stderr.writeln(error);
    exitCode = 64;
  } on Exception catch (error) {
    stderr
      ..writeln('Gmail API の認証に失敗しました。')
      ..writeln(error);
    exitCode = 70;
  }
}

/// 環境変数とキャッシュから OAuth クライアント設定を解決する。
///
/// 環境変数を優先し、キャッシュに保存済みの設定を代わりに使う。
/// どちらも無い場合は [ConfigException] を投げる。
auth.ClientId _resolveClientId(TokenStore tokenStore) {
  final fromEnv = loadClientIdFromEnv();
  if (fromEnv != null) {
    return fromEnv;
  }
  final cached = tokenStore.load()?.clientId;
  if (cached != null) {
    return cached;
  }
  throw const ConfigException(
    'OAuth クライアントの設定がありません。login '
    'サブコマンドでログインするか、環境変数 '
    'GMAIL_TICKET_CLI_CLIENT_ID と '
    'GMAIL_TICKET_CLI_CLIENT_SECRET を設定してください。',
  );
}

Future<void> _fetchAndReport(
  auth.AutoRefreshingAuthClient authClient,
  List<TicketService> services,
  CliOptions options,
) async {
  var query = options.query ?? buildDefaultQuery(services);
  final since = options.since;
  if (since != null) {
    query = applySince(query, since);
  }
  stderr.writeln('Gmail 検索クエリ: $query');

  final fetcher = GmailFetcher(gmail.GmailApi(authClient));
  final emails = await fetcher.fetch(query: query, max: options.max);
  stderr.writeln('${emails.length} 件のメールを取得しました。');

  if (options.dump) {
    final reporter = Reporter();
    stdout.writeln(
      reporter.buildDump(<DumpEmail>[
        for (final email in emails)
          DumpEmail(
            from: email.from,
            subject: email.subject,
            dateText: reporter.formatDumpDate(email.dateRaw, email.date),
            bodyText: email.bodyText,
          ),
      ]),
    );
    return;
  }

  final results = _extractAll(emails, services);
  final reporter = Reporter();
  if (options.json) {
    stdout.writeln(reporter.buildJsonReport(results));
    return;
  }
  stdout.writeln(
    reporter.buildHumanReport(
      fetchedCount: emails.length,
      results: results,
    ),
  );
  if (results.isEmpty) {
    stderr.writeln('公演情報を抽出できたメールはありませんでした。');
  }
}

List<ExtractionResult> _extractAll(
  List<FetchedEmail> emails,
  List<TicketService> services,
) {
  final results = <ExtractionResult>[];
  for (final email in emails) {
    final sender = email.from.toLowerCase();
    for (final service in services) {
      if (!sender.contains(service.senderAddress.toLowerCase())) {
        continue;
      }
      final info = service.extract(
        subject: email.subject,
        bodyText: email.bodyText,
      );
      if (info != null) {
        results.add(
          ExtractionResult(
            serviceName: service.name,
            info: ExtractionInfo(
              title: info.title,
              startsAt: info.startsAt,
              venue: info.venue,
              price: info.price,
            ),
          ),
        );
      }
      // 送信者に一致するサービスは 1 つだけとみなす。
      break;
    }
  }
  return results;
}
