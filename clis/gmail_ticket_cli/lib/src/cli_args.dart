import 'package:args/args.dart';

/// CLI の起動オプション。
class CliOptions {
  const CliOptions({
    required this.max,
    required this.json,
    required this.dump,
    required this.resetAuth,
    required this.port,
    this.since,
    this.query,
  });

  /// [results] から [CliOptions] を組み立てる。
  ///
  /// 数値や日付の形式が不正な場合は [FormatException] を投げる。
  factory CliOptions.from(ArgResults results) {
    final max = int.parse(results['max'] as String);
    final port = int.parse(results['port'] as String);
    final sinceText = results['since'] as String?;
    DateTime? since;
    if (sinceText != null) {
      final match = RegExp(
        r'^(\d{4})-(\d{1,2})-(\d{1,2})$',
      ).firstMatch(sinceText);
      if (match == null) {
        throw const FormatException('--since は YYYY-MM-DD 形式で指定してください。');
      }
      since = DateTime(
        int.parse(match.group(1)!),
        int.parse(match.group(2)!),
        int.parse(match.group(3)!),
      );
    }
    if (max < 1) {
      throw const FormatException('--max は 1 以上で指定してください。');
    }

    return CliOptions(
      max: max,
      since: since,
      query: results['query'] as String?,
      json: results['json'] as bool,
      dump: results['dump'] as bool,
      resetAuth: results['reset-auth'] as bool,
      port: port,
    );
  }

  static const int defaultMax = 100;
  static const int defaultPort = 0;

  /// 取得するメールの最大件数。
  final int max;

  /// この日以降のメールのみを取得する場合の日付。
  final DateTime? since;

  /// Gmail 検索クエリの完全な上書き。
  final String? query;

  /// 抽出結果を JSON で出力するか。
  final bool json;

  /// 取得したメールの件名と本文を出力するか。
  final bool dump;

  /// キャッシュした認証情報を削除して再認証するか。
  final bool resetAuth;

  /// OAuth のリダイレクト待ち受けポート。
  final int port;
}

/// コマンドラインオプションの定義を組み立てる。
ArgParser buildArgParser() => ArgParser()
  ..addOption(
    'max',
    defaultsTo: '${CliOptions.defaultMax}',
    help: '取得するメールの最大件数',
  )
  ..addOption(
    'since',
    help: 'この日以降のメールのみ取得(YYYY-MM-DD)',
  )
  ..addOption(
    'query',
    help: 'Gmail 検索クエリの完全な上書き',
  )
  ..addFlag(
    'json',
    negatable: false,
    help: '抽出結果を JSON で出力する',
  )
  ..addFlag(
    'dump',
    negatable: false,
    help: '取得したメールの件名と本文を出力する',
  )
  ..addFlag(
    'reset-auth',
    negatable: false,
    help: 'キャッシュした認証情報を削除して再認証する',
  )
  ..addOption(
    'port',
    defaultsTo: '${CliOptions.defaultPort}',
    help: 'OAuth のリダイレクト待ち受けポート(0 で自動割り当て)',
  )
  ..addFlag(
    'help',
    abbr: 'h',
    negatable: false,
    help: '使い方を表示する',
  )
  ..addCommand('login', buildLoginParser());

/// `login` サブコマンドのオプション定義を組み立てる。
ArgParser buildLoginParser() => ArgParser()
  ..addOption(
    'client-id',
    help: 'OAuth クライアント ID',
  )
  ..addOption(
    'client-secret',
    help: 'OAuth クライアント シークレット',
  )
  ..addOption(
    'port',
    defaultsTo: '${CliOptions.defaultPort}',
    help: 'OAuth のリダイレクト待ち受けポート(0 で自動割り当て)',
  )
  ..addFlag(
    'help',
    abbr: 'h',
    negatable: false,
    help: '使い方を表示する',
  );

/// `login` サブコマンドの起動オプション。
class LoginOptions {
  const LoginOptions({
    required this.clientId,
    required this.clientSecret,
    required this.port,
  });

  /// [results] から [LoginOptions] を組み立てる。
  ///
  /// `--client-id` と `--client-secret` が指定されていない場合や
  /// ポートの形式が不正な場合は [FormatException] を投げる。
  factory LoginOptions.from(ArgResults results) {
    final clientId = results['client-id'] as String?;
    final clientSecret = results['client-secret'] as String?;
    if (clientId == null ||
        clientId.isEmpty ||
        clientSecret == null ||
        clientSecret.isEmpty) {
      throw const FormatException(
        '使い方: login --client-id <クライアントID> '
        '--client-secret <クライアントシークレット>',
      );
    }
    final port = int.tryParse(results['port'] as String);
    if (port == null || port < 0) {
      throw const FormatException('--port は 0 以上の整数で指定してください。');
    }
    return LoginOptions(
      clientId: clientId,
      clientSecret: clientSecret,
      port: port,
    );
  }

  /// OAuth クライアント ID。
  final String clientId;

  /// OAuth クライアント シークレット。
  final String clientSecret;

  /// OAuth のリダイレクト待ち受けポート。
  final int port;
}
