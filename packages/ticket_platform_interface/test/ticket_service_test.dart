import 'package:test/test.dart';
import 'package:ticket_platform_interface/ticket_platform_interface.dart';

class _FakeTicketService implements TicketService {
  @override
  String get name => 'fake';

  @override
  String get senderAddress => 'noreply@example.com';

  @override
  List<String> get subjectKeywords => const <String>['チケット購入'];

  @override
  TicketInfo? extract({required String subject, required String bodyText}) {
    if (!subjectKeywords.any(subject.contains)) {
      return null;
    }
    return TicketInfo(
      title: bodyText,
      startsAt: fixedStartsAt,
      venue: '会場',
      price: 8000,
    );
  }

  static final DateTime fixedStartsAt = DateTime(2026, 11, 20, 19);
}

void main() {
  final service = _FakeTicketService();

  test('TicketInfo の同値性は全フィールドで判定する', () {
    final base = TicketInfo(
      title: '公演名',
      startsAt: DateTime(2026, 11, 20, 19),
      venue: '会場',
      price: 8000,
    );
    final same = TicketInfo(
      title: '公演名',
      startsAt: DateTime(2026, 11, 20, 19),
      venue: '会場',
      price: 8000,
    );
    final different = TicketInfo(
      title: '別公演',
      startsAt: DateTime(2026, 11, 20, 19),
      venue: '会場',
      price: 8000,
    );

    expect(base, same);
    expect(base.hashCode, same.hashCode);
    expect(base, isNot(different));
  });

  test('TicketInfo の toString に全フィールドを含める', () {
    final info = TicketInfo(
      title: '公演名',
      startsAt: DateTime(2026, 11, 20, 19),
      venue: '会場',
      price: 8000,
    );

    expect(
      info.toString(),
      'TicketInfo(title: 公演名, startsAt: 2026-11-20 19:00:00.000, '
      'venue: 会場, price: 8000)',
    );
  });

  test('実装は件名キーワードに一致しないメールを対象外にできる', () {
    final result = service.extract(
      subject: 'お知らせ',
      bodyText: '本文',
    );

    expect(result, isNull);
  });

  test('実装は件名キーワードに一致するメールから公演情報を返せる', () {
    final result = service.extract(
      subject: '【サービス名】チケット購入完了',
      bodyText: '公演名',
    );

    expect(
      result,
      TicketInfo(
        title: '公演名',
        startsAt: _FakeTicketService.fixedStartsAt,
        venue: '会場',
        price: 8000,
      ),
    );
  });
}
