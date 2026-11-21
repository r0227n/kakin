import 'package:test/test.dart';
import 'package:ticket_livepocket/ticket_livepocket.dart';
import 'package:ticket_platform_interface/ticket_platform_interface.dart';

/// 実メールの件名(本文の fixture と対で使う)。
const _subject = '[LivePocket]購入完了のお知らせ（1064315071）';

void main() {
  const service = LivepocketTicketService();

  test('対象送信者と件名キーワードを公開する', () {
    expect(service.name, 'livepocket');
    expect(service.senderAddress, 'noreply@livepocket.jp');
    expect(service.subjectKeywords, const <String>['購入完了のお知らせ']);
  });

  test('件名キーワードに一致しないメールは対象外', () {
    final result = service.extract(
      subject: '決済に関するご案内',
      bodyText: '本文',
    );

    expect(result, isNull);
  });

  test('購入完了メールの本文から公演情報を抽出する', () {
    final result = service.extract(
      subject: _subject,
      bodyText: '''
Ryo Nishimura 様

下記のチケットの購入が完了しました。
チケットは「マイチケット」にてご確認ください。

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
イベント名：AKANECLUB.単独公演 ライブハウスでフリーライブ!!!
会場：代官山UNIT（東京都）
イベント開催日：2026年11月3日(火)
　[開場時間]16:00  [開演時間]16:30
イベントページURL：https://livepocket.jp/e/lhflunit

一般：¥600
　チケット料金：¥600 × 1枚 = ¥600

購入手数料：¥30
システム利用料：¥165

合計金額：¥795 (税込)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
''',
    );

    expect(
      result,
      TicketInfo(
        title: 'AKANECLUB.単独公演 ライブハウスでフリーライブ!!!',
        startsAt: DateTime(2026, 11, 3, 16, 30),
        venue: '代官山UNIT（東京都）',
        price: 600,
      ),
    );
  });

  test('2 枚の注文では等号の右側の合計をチケット料金とする', () {
    final result = service.extract(
      subject: _subject,
      bodyText: const [
        'イベント名：AKANECLUB.単独公演 ライブハウスでフリーライブ!!!',
        '会場：代官山UNIT（東京都）',
        'イベント開催日：2026年11月3日(火)',
        '　[開場時間]16:00  [開演時間]16:30',
        '　チケット料金：¥600 × 2枚 = ¥1,200',
      ].join('\n'),
    );

    expect(result?.price, 1200);
  });

  test('開演時間の無い本文は開場時間を公演開始日時とする', () {
    final result = service.extract(
      subject: _subject,
      bodyText: const [
        'イベント名：AKANECLUB.単独公演 ライブハウスでフリーライブ!!!',
        '会場：代官山UNIT（東京都）',
        'イベント開催日：2026年11月3日(火)',
        '　[開場時間]16:00',
        '　チケット料金：¥600 × 1枚 = ¥600',
      ].join('\n'),
    );

    expect(result?.startsAt, DateTime(2026, 11, 3, 16));
  });

  test('イベント名の無い本文では件名を公演名にする', () {
    final result = service.extract(
      subject: _subject,
      bodyText: const [
        '会場：代官山UNIT（東京都）',
        'イベント開催日：2026年11月3日(火)',
        '　[開演時間]16:30',
        '　チケット料金：¥600 × 1枚 = ¥600',
      ].join('\n'),
    );

    expect(result?.title, _subject);
  });

  test('会場の無い本文は抽出できない', () {
    final result = service.extract(
      subject: _subject,
      bodyText: const [
        'イベント名：AKANECLUB.単独公演 ライブハウスでフリーライブ!!!',
        'イベント開催日：2026年11月3日(火)',
        '　[開演時間]16:30',
        '　チケット料金：¥600 × 1枚 = ¥600',
      ].join('\n'),
    );

    expect(result, isNull);
  });

  test('旧形式の本文から公演情報を抽出する', () {
    final result = service.extract(
      subject: '[LivePocket-Ticket-]購入完了のお知らせ（95886987）',
      bodyText: '''
LivePocket-Ticket-をご利用いただき、誠にありがとうございます。
ご購入されたチケットは以下の通りです。

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
このメールだけではご入場いただけません。

下記URLからチケットの受け取りを行ってください。
https://t.livepocket.jp/myticket/detail?id=517442

イベント名：SHINJUKUMARZ 24th Anniversary  UNIVERSE企画『Dance party #年末SP』
会場：新宿MARZ
日程：2025年12月27日
[開場日時]10:30  [開演日時]11:00

受付名：先着販売受付
2部一般B整理番号券
1枚

支払金額：￥2100(税込)
支払方法：クレジットカード
申込番号：95886987
''',
    );

    expect(
      result,
      TicketInfo(
        title: 'SHINJUKUMARZ 24th Anniversary  UNIVERSE企画『Dance party #年末SP』',
        startsAt: DateTime(2025, 12, 27, 11),
        venue: '新宿MARZ',
        price: 2100,
      ),
    );
  });

  test('CRLF 改行の本文も抽出する', () {
    final result = service.extract(
      subject: _subject,
      bodyText: const [
        'イベント名：AKANECLUB.単独公演 ライブハウスでフリーライブ!!!',
        '会場：代官山UNIT（東京都）',
        'イベント開催日：2026年11月3日(火)',
        '　[開場時間]16:00  [開演時間]16:30',
        '　チケット料金：¥600 × 1枚 = ¥600',
      ].join('\r\n'),
    );

    expect(
      result,
      TicketInfo(
        title: 'AKANECLUB.単独公演 ライブハウスでフリーライブ!!!',
        startsAt: DateTime(2026, 11, 3, 16, 30),
        venue: '代官山UNIT（東京都）',
        price: 600,
      ),
    );
  });
}
