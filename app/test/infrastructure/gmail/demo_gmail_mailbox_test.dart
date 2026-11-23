import 'package:app/application/application.dart';
import 'package:app/domain/domain.dart';
import 'package:app/infrastructure/infrastructure.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fakes.dart';

void main() {
  // 2026-11-22 12:00 JST。
  final clock = FixedClock(DateTime.utc(2026, 11, 22, 3));
  final mailbox = DemoGmailMailbox(clock);

  Future<List<TicketMail>> fetchAll() =>
      mailbox.fetchTicketMails(after: DateTime.utc(2000));

  test('is a demo mailbox that always connects the demo account', () async {
    expect(mailbox.isDemo, isTrue);
    expect(await mailbox.connect(), DemoGmailMailbox.accountEmail);
    expect(await mailbox.restore(), DemoGmailMailbox.accountEmail);
  });

  test('returns only the readable mails', () async {
    final mails = await fetchAll();

    expect(mails.map((m) => m.messageId), [
      'demo-eplus-1',
      'demo-lp-1',
      'demo-eplus-2',
      'demo-lp-2',
    ]);
  });

  test('parses eplus mails with the ticket price and the 開演 time', () async {
    final mail = (await fetchAll()).firstWhere(
      (m) => m.messageId == 'demo-eplus-2',
    );

    expect(mail.service, TicketMailService.eplus);
    expect(mail.title, 'クリスマス公演');
    expect(mail.venue, '池袋 ホールC');
    // システム利用料を含まないチケット料金。
    expect(mail.priceYen, 6800);
    // 31日後の 18:30 JST。
    expect(mail.startsAt, DateTime.utc(2026, 12, 23, 9, 30));
  });

  test(
    'parses LivePocket mails with the ticket price and start time',
    () async {
      final mail = (await fetchAll()).firstWhere(
        (m) => m.messageId == 'demo-lp-2',
      );

      expect(mail.service, TicketMailService.livepocket);
      expect(mail.title, '春ツアー2027 東京公演');
      expect(mail.venue, '有明 アリーナD');
      expect(mail.priceYen, 12000);
      // 52日後の 17:00 JST。
      expect(mail.startsAt, DateTime.utc(2027, 1, 13, 8));
    },
  );

  test('received times are UTC instants at 21:04 JST', () async {
    final mails = await fetchAll();

    expect(mails.every((m) => m.receivedAt.isUtc), isTrue);
    expect(
      mails.map((m) => JapanTime.dateOf(m.receivedAt)),
      [
        LocalDate(2026, 10, 13),
        LocalDate(2026, 11, 4),
        LocalDate(2026, 11, 16),
        LocalDate(2026, 11, 20),
      ],
    );
    expect(
      mails.map((m) => JapanTime.wallClockOf(m.receivedAt).hour).toSet(),
      {21},
    );
  });

  test('skips mails received before after', () async {
    final mails = await mailbox.fetchTicketMails(
      // 6日前（11-16）21:04 JST ちょうど。
      after: DateTime.utc(2026, 11, 16, 12, 4),
    );

    expect(mails.map((m) => m.messageId), ['demo-eplus-2', 'demo-lp-2']);
  });
}
