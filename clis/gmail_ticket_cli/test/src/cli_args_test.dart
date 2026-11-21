import 'package:args/args.dart';
import 'package:gmail_ticket_cli/src/cli_args.dart';
import 'package:test/test.dart';

void main() {
  ArgResults parse(List<String> arguments) => buildArgParser().parse(arguments);

  test('既定値は max 100 とポート 0', () {
    final options = CliOptions.from(parse(const <String>[]));

    expect(options.max, 100);
    expect(options.port, 0);
    expect(options.since, isNull);
    expect(options.query, isNull);
    expect(options.json, isFalse);
    expect(options.dump, isFalse);
    expect(options.resetAuth, isFalse);
  });

  test('フラグとオプションを解釈する', () {
    final options = CliOptions.from(
      parse(const <String>[
        '--max',
        '5',
        '--since',
        '2026-11-01',
        '--query',
        'from:info@eplus.co.jp',
        '--json',
        '--reset-auth',
        '--port',
        '8080',
      ]),
    );

    expect(options.max, 5);
    expect(options.since, DateTime(2026, 11));
    expect(options.query, 'from:info@eplus.co.jp');
    expect(options.json, isTrue);
    expect(options.dump, isFalse);
    expect(options.resetAuth, isTrue);
    expect(options.port, 8080);
  });

  test('since が YYYY-MM-DD で無ければ FormatException', () {
    expect(
      () => CliOptions.from(parse(const <String>['--since', '2026/11/01'])),
      throwsA(isA<FormatException>()),
    );
  });

  test('max が 1 未満なら FormatException', () {
    expect(
      () => CliOptions.from(parse(const <String>['--max', '0'])),
      throwsA(isA<FormatException>()),
    );
  });

  test('login サブコマンドのオプションと既定ポートを解釈する', () {
    final results = parse(const <String>[
      'login',
      '--client-id',
      'id-1',
      '--client-secret',
      'secret-1',
    ]);

    expect(results.command?.name, 'login');
    final options = LoginOptions.from(results.command!);
    expect(options.clientId, 'id-1');
    expect(options.clientSecret, 'secret-1');
    expect(options.port, 0);
  });

  test('login は --port も解釈する', () {
    final results = parse(const <String>[
      'login',
      '--port',
      '9000',
      '--client-id',
      'id-1',
      '--client-secret',
      'secret-1',
    ]);

    expect(LoginOptions.from(results.command!).port, 9000);
  });

  test('login の --client-id / --client-secret が無ければ FormatException', () {
    const argumentSets = <List<String>>[
      <String>['login'],
      <String>['login', '--client-id', 'id-1'],
      <String>['login', '--client-secret', 'secret-1'],
    ];

    for (final arguments in argumentSets) {
      final results = parse(arguments);
      expect(
        () => LoginOptions.from(results.command!),
        throwsA(isA<FormatException>()),
        reason: '$arguments',
      );
    }
  });

  test('login の --port が不正なら FormatException', () {
    final results = parse(const <String>[
      'login',
      '--port',
      'abc',
      '--client-id',
      'id-1',
      '--client-secret',
      'secret-1',
    ]);

    expect(
      () => LoginOptions.from(results.command!),
      throwsA(isA<FormatException>()),
    );
  });

  test('login に位置引数を渡すと使い方のエラーになる', () {
    final results = parse(const <String>['login', 'id-1', 'secret-1']);

    // 位置引数はパーサーでは rest に残るだけで無視され、
    // 必須オプションが無いとして使い方のエラーになる。
    expect(results.command?.name, 'login');
    expect(results.command!.rest, const <String>['id-1', 'secret-1']);
    expect(
      () => LoginOptions.from(results.command!),
      throwsA(isA<FormatException>()),
    );
  });
}
