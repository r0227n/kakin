import 'package:test/test.dart';
import 'package:ticket_eplus/ticket_eplus.dart';
import 'package:ticket_platform_interface/ticket_platform_interface.dart';

/// 実メールの件名(本文の fixture と対で使う)。
const _subject = '【e+より】《必ずご確認ください》申込み完了・決済に関するご案内';

void main() {
  const service = EplusTicketService();

  test('対象送信者と件名キーワードを公開する', () {
    expect(service.name, 'eplus');
    expect(service.senderAddress, 'info@eplus.co.jp');
    expect(service.subjectKeywords, const <String>['決済に関するご案内']);
  });

  test('件名キーワードに一致しないメールは対象外', () {
    final result = service.extract(
      subject: 'チケット購入完了のお知らせ',
      bodyText: '本文',
    );

    expect(result, isNull);
  });

  test('基本の本文から公演情報を抽出する', () {
    final result = service.extract(
      subject: _subject,
      bodyText: r'''
一般発売
公演名　　　：　ＩＤＯ−ＬＩＶＥ！！
会場名　　　：　Ｏ−ＷＥＳＴ／ＤＵＯ　Ｍｕｓｉｃ　Ｅｘｃｈａｎｇｅ
公演日時　　：　2026/10/18(日)  12：30開場 13：00開演
席種・料金　：　前売り \4,980×1枚［チケット料金］
座席　　　　：　詳細はチケット券面でご確認ください。

料金
　　購入合計　：　\5,310（消費税込み）
　　内訳
　　　チケット料金　：　\4,980
　　　システム利用料　：　\330
''',
    );

    expect(
      result,
      TicketInfo(
        title: 'ＩＤＯ−ＬＩＶＥ！！',
        startsAt: DateTime(2026, 10, 18, 13),
        venue: 'Ｏ−ＷＥＳＴ／ＤＵＯ　Ｍｕｓｉｃ　Ｅｘｃｈａｎｇｅ',
        price: 4980,
      ),
    );
  });

  test('折り返された公演名を連結して抽出する', () {
    final result = service.extract(
      subject: _subject,
      bodyText: r'''
★一般発売
公演名　　　：　ＪＵＮＥ　ＲＯＣＫ　ＦＥＳＴＩＶＡＬ
　　　　　　　　２０２６
会場名　　　：　ＣＬＵＢ　ＣＩＴＴＡ’
公演日時　　：　2026/10/10(土)  13：00開場 14：00開演
席種・料金　：　第一部 一般：\7,800×1枚［チケット料金］
座席　　　　：　詳細はチケット券面でご確認ください。

料金
　　購入合計　：　\8,130（消費税込み）
　　内訳
　　　チケット料金　：　\7,800
　　　システム利用料　：　\330
''',
    );

    expect(
      result,
      TicketInfo(
        title: 'ＪＵＮＥ　ＲＯＣＫ　ＦＥＳＴＩＶＡＬ　２０２６',
        startsAt: DateTime(2026, 10, 10, 14),
        venue: 'ＣＬＵＢ　ＣＩＴＴＡ’',
        price: 7800,
      ),
    );
  });

  test('2 枚分の注文のチケット料金は合計を抽出する', () {
    final result = service.extract(
      subject: _subject,
      bodyText: r'''
★＜１日券＞スマチケ●一般発売
公演名　　　：　ＶＩＶＡ　ＬＡ　ＲＯＣＫ　２０２５
会場名　　　：　さいたまスーパーアリーナ
公演日時　　：　2025/05/05(月・祝)  08：30開場 10：00開演
席種・料金　：　５／５＿１日券 \13,000×2枚［チケット料金］
座席　　　　：　詳細はチケット券面でご確認ください。

料金
　　購入合計　：　\26,660（消費税込み）
　　内訳
　　　チケット料金　：　\26,000
　　　システム利用料　：　\660
''',
    );

    expect(
      result,
      TicketInfo(
        title: 'ＶＩＶＡ　ＬＡ　ＲＯＣＫ　２０２５',
        startsAt: DateTime(2025, 5, 5, 10),
        venue: 'さいたまスーパーアリーナ',
        price: 26000,
      ),
    );
  });

  test('サービス料が併記された本文からチケット料金を抽出する', () {
    final result = service.extract(
      subject: _subject,
      bodyText: r'''
一般発売
公演名　　　：　ｃｏｗｏｌｏ
会場名　　　：　新宿ＲｅＮＹ
公演日時　　：　2026/02/27(金)  18：30開場 19：00開演
席種・料金　：　一般チケット \3,000×1枚［チケット料金］＋\330×1枚［サービス料］
座席　　　　：　詳細はチケット券面でご確認ください。

料金
　　購入合計　：　\3,660（消費税込み）
　　内訳
　　　チケット料金　：　\3,000
　　　サービス料　：　\330
　　　システム利用料　：　\330
''',
    );

    expect(
      result,
      TicketInfo(
        title: 'ｃｏｗｏｌｏ',
        startsAt: DateTime(2026, 2, 27, 19),
        venue: '新宿ＲｅＮＹ',
        price: 3000,
      ),
    );
  });

  test('公演名の無い本文では件名を公演名にする', () {
    final result = service.extract(
      subject: _subject,
      bodyText: r'''
会場名　　　：　新宿ＲｅＮＹ
公演日時　　：　2026/02/27(金)  18：30開場 19：00開演
　　内訳
　　　チケット料金　：　\3,000
''',
    );

    expect(
      result,
      TicketInfo(
        title: _subject,
        startsAt: DateTime(2026, 2, 27, 19),
        venue: '新宿ＲｅＮＹ',
        price: 3000,
      ),
    );
  });

  test('会場名の無い本文は抽出できない', () {
    final result = service.extract(
      subject: _subject,
      bodyText: r'''
公演名　　　：　ｃｏｗｏｌｏ
公演日時　　：　2026/02/27(金)  18：30開場 19：00開演
　　内訳
　　　チケット料金　：　\3,000
''',
    );

    expect(result, isNull);
  });

  test('CRLF 改行の本文も抽出する', () {
    final result = service.extract(
      subject: _subject,
      bodyText: const [
        '公演名　　　：　ＩＤＯ−ＬＩＶＥ！！',
        '会場名　　　：　Ｏ−ＷＥＳＴ／ＤＵＯ　Ｍｕｓｉｃ　Ｅｘｃｈａｎｇｅ',
        '公演日時　　：　2026/10/18(日)  12：30開場 13：00開演',
        '　　内訳',
        r'　　　チケット料金　：　\4,980',
      ].join('\r\n'),
    );

    expect(
      result,
      TicketInfo(
        title: 'ＩＤＯ−ＬＩＶＥ！！',
        startsAt: DateTime(2026, 10, 18, 13),
        venue: 'Ｏ−ＷＥＳＴ／ＤＵＯ　Ｍｕｓｉｃ　Ｅｘｃｈａｎｇｅ',
        price: 4980,
      ),
    );
  });
}
