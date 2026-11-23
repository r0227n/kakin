import 'package:gmail_ticket_source/gmail_ticket_source.dart';
import 'package:test/test.dart';
import 'package:ticket_eplus/ticket_eplus.dart';
import 'package:ticket_livepocket/ticket_livepocket.dart';

void main() {
  test('既定クエリに両サービスの送信者とキーワードを含める', () {
    final query = buildDefaultQuery([
      const EplusTicketService(),
      const LivepocketTicketService(),
    ]);

    expect(
      query,
      'from:(info@eplus.co.jp OR noreply@livepocket.jp) '
      '(subject:"決済に関するご案内" OR subject:"購入完了のお知らせ")',
    );
  });

  test('重複するキーワードは 1 回だけ含める', () {
    final query = buildDefaultQuery([
      const EplusTicketService(),
      const EplusTicketService(),
    ]);

    expect(query, 'from:(info@eplus.co.jp) (subject:"決済に関するご案内")');
  });

  test('applySince は after 条件を追加する', () {
    expect(
      applySince('from:info@eplus.co.jp', DateTime(2026, 11)),
      'from:info@eplus.co.jp after:2026/11/1',
    );
  });
}
