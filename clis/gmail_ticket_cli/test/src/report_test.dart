import 'dart:convert';

import 'package:gmail_ticket_cli/src/report.dart';
import 'package:test/test.dart';

ExtractionResult result({String service = 'eplus', int price = 8000}) =>
    ExtractionResult(
      serviceName: service,
      info: ExtractionInfo(
        title: '公演名',
        startsAt: DateTime(2026, 11, 20, 19),
        venue: '東京ドーム',
        price: price,
      ),
    );

void main() {
  test('buildDump はヘッダと本文を区切り付きで組み立てる', () {
    final dump = Reporter().buildDump(const <DumpEmail>[
      DumpEmail(
        from: 'eplus <info@eplus.co.jp>',
        subject: '決済に関するご案内',
        dateText: '2026-11-20 19:00:00.000',
        bodyText: '本文テキスト',
      ),
    ]);

    expect(
      dump,
      'From: eplus <info@eplus.co.jp>\n'
      'Subject: 決済に関するご案内\n'
      'Date: 2026-11-20 19:00:00.000\n'
      '----\n'
      '本文テキスト\n'
      '=====\n',
    );
  });

  test('buildHumanReport は公演情報と件数を組み立てる', () {
    final report = Reporter().buildHumanReport(
      fetchedCount: 12,
      results: <ExtractionResult>[
        result(),
        result(service: 'livepocket'),
      ],
    );

    expect(
      report,
      'eplus | 公演名\n'
      '  日時: 2026-11-20 19:00\n'
      '  場所: 東京ドーム\n'
      '  チケット料金: 8000円\n'
      'livepocket | 公演名\n'
      '  日時: 2026-11-20 19:00\n'
      '  場所: 東京ドーム\n'
      '  チケット料金: 8000円\n'
      '\n'
      '取得 12 件 / 抽出 2 件\n',
    );
  });

  test('buildJsonReport は抽出結果の JSON を組み立てる', () {
    final decoded =
        jsonDecode(
              Reporter().buildJsonReport(<ExtractionResult>[
                result(price: 6500),
              ]),
            )
            as List<Object?>;

    expect(decoded, hasLength(1));
    expect(
      decoded.first,
      <String, Object?>{
        'service': 'eplus',
        'title': '公演名',
        'startsAt': '2026-11-20T19:00:00.000',
        'venue': '東京ドーム',
        'price': 6500,
      },
    );
  });
}
