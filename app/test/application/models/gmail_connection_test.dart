import 'package:app/application/application.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  GmailConnection connectedAt(DateTime at, {DateTime? watermark}) =>
      GmailConnection(
        accountEmail: 'fan@example.com',
        connectedAt: at,
        lastMessageReceivedAt: watermark,
      );

  group('GmailConnection.fetchAfter', () {
    test('the first sync goes back three months from the connection', () {
      expect(
        connectedAt(DateTime.utc(2026, 11, 22, 3, 15)).fetchAfter,
        DateTime.utc(2026, 8, 22, 3, 15),
      );
    });

    test('crosses the year boundary', () {
      expect(
        connectedAt(DateTime.utc(2027, 2, 10)).fetchAfter,
        DateTime.utc(2026, 11, 10),
      );
    });

    test('clamps to the last day when the month is shorter', () {
      expect(
        connectedAt(DateTime.utc(2026, 5, 31, 12)).fetchAfter,
        DateTime.utc(2026, 2, 28, 12),
      );
      expect(
        connectedAt(DateTime.utc(2028, 5, 30)).fetchAfter,
        DateTime.utc(2028, 2, 29),
      );
    });

    test('later syncs overlap the newest imported mail by three days', () {
      expect(
        connectedAt(
          DateTime.utc(2026, 5, 31),
          watermark: DateTime.utc(2026, 11, 20, 12),
        ).fetchAfter,
        DateTime.utc(2026, 11, 17, 12),
      );
    });
  });
}
