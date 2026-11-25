import 'package:app/application/application.dart';
import 'package:app/infrastructure/gmail/ticket_mail_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const parser = TicketMailParser();
  final receivedAt = DateTime.utc(2026, 11, 20, 12);

  const eplusSubject = '【e+より】申込み完了・決済に関するご案内';
  const eplusBody = r'''
公演名　　　：　定期公演
会場名　　　：　新宿 ステージ7
公演日時　　：　2026/12/1(火)  17：30開場 18：30開演
　　　チケット料金　：　\4,980
''';

  TicketMail? parse({
    String from = 'e+ <info@eplus.co.jp>',
    String subject = eplusSubject,
    String body = eplusBody,
  }) => parser.parse(
    messageId: 'm1',
    receivedAt: receivedAt,
    from: from,
    subject: subject,
    bodyText: body,
  );

  test('maps an eplus payment mail to a TicketMail', () {
    final mail = parse()!;

    expect(mail.messageId, 'm1');
    expect(mail.receivedAt, receivedAt);
    expect(mail.subject, eplusSubject);
    expect(mail.service, TicketMailService.eplus);
    expect(mail.title, '定期公演');
    expect(mail.venue, '新宿 ステージ7');
    expect(mail.priceYen, 4980);
  });

  test('converts the JST wall clock start to a UTC instant', () {
    expect(parse()!.startsAt, DateTime.utc(2026, 12, 1, 9, 30));
  });

  test('maps a LivePocket purchase mail', () {
    final mail = parse(
      from: 'LivePocket <noreply@livepocket.jp>',
      subject: '[LivePocket]購入完了のお知らせ',
      body: '''
イベント名：ナイト
会場：渋谷 ホールB
イベント開催日：2026年12月5日(土)
　[開場時間]16:00  [開演時間]17:00
　チケット料金：¥4,000 × 2枚 = ¥8,000
''',
    )!;

    expect(mail.service, TicketMailService.livepocket);
    expect(mail.priceYen, 8000);
    expect(mail.startsAt, DateTime.utc(2026, 12, 5, 8));
  });

  test('ignores unknown senders', () {
    expect(parse(from: 'someone@example.com'), isNull);
  });

  test('ignores supported senders with an unrelated subject', () {
    expect(parse(subject: '【e+より】お知らせ'), isNull);
  });

  test('returns null when required fields are missing', () {
    expect(parse(body: '公演名　　　：　定期公演\n'), isNull);
  });
}
