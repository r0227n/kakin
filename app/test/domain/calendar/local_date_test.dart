import 'package:app/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LocalDate', () {
    test('parses and formats YYYY-MM-DD', () {
      final date = LocalDate.parse('2026-02-09');

      expect(date, LocalDate(2026, 2, 9));
      expect(date.toIso(), '2026-02-09');
    });

    test('parse rejects wrong formats and nonexistent days', () {
      for (final value in [
        '2026-2-09',
        '2026/02/09',
        '2026-02-09T00:00',
        '',
        '2026-02-30',
        '2026-13-01',
        '2025-02-29',
      ]) {
        expect(
          () => LocalDate.parse(value),
          throwsFormatException,
          reason: value,
        );
      }
    });

    test('parse accepts a leap day', () {
      expect(LocalDate.parse('2024-02-29').day, 29);
    });

    test('constructor rejects nonexistent days', () {
      expect(() => LocalDate(2026, 2, 29), throwsArgumentError);
      expect(() => LocalDate(2026, 4, 31), throwsArgumentError);
      expect(() => LocalDate(2026, 0, 1), throwsArgumentError);
    });

    test('addDays crosses month and year boundaries', () {
      expect(LocalDate(2026, 12, 31).addDays(1), LocalDate(2027, 1, 1));
      expect(LocalDate(2026, 3, 1).addDays(-1), LocalDate(2026, 2, 28));
    });

    test('daysUntil counts calendar days in both directions', () {
      final start = LocalDate(2026, 11, 22);

      expect(start.daysUntil(LocalDate(2026, 12, 1)), 9);
      expect(start.daysUntil(LocalDate(2026, 11, 20)), -2);
      expect(start.daysUntil(start), 0);
    });

    test('orders by year, month and day', () {
      final a = LocalDate(2026, 11, 30);
      final b = LocalDate(2026, 12, 1);

      expect(a.isBefore(b), isTrue);
      expect(b.isAfter(a), isTrue);
      expect([b, a]..sort(), [a, b]);
    });

    test('weekday follows the calendar', () {
      expect(LocalDate(2026, 11, 22).weekday, DateTime.sunday);
    });
  });

  group('YearMonth', () {
    test('first and last day cover the month, including February', () {
      expect(YearMonth(2026, 2).firstDay, LocalDate(2026, 2, 1));
      expect(YearMonth(2026, 2).lastDay, LocalDate(2026, 2, 28));
      expect(YearMonth(2024, 2).lastDay, LocalDate(2024, 2, 29));
      expect(YearMonth(2026, 12).lastDay, LocalDate(2026, 12, 31));
    });

    test('next and previous wrap around the year', () {
      expect(YearMonth(2026, 12).next, YearMonth(2027, 1));
      expect(YearMonth(2027, 1).previous, YearMonth(2026, 12));
    });

    test('contains only dates of the same year and month', () {
      final month = YearMonth(2026, 11);

      expect(month.contains(LocalDate(2026, 11, 30)), isTrue);
      expect(month.contains(LocalDate(2026, 12, 1)), isFalse);
      expect(month.contains(LocalDate(2025, 11, 1)), isFalse);
    });

    test('parses and formats YYYY-MM', () {
      expect(YearMonth.parse('2026-03'), YearMonth(2026, 3));
      expect(YearMonth(2026, 3).toIso(), '2026-03');
      expect(LocalDate(2026, 3, 9).yearMonth, YearMonth(2026, 3));
    });

    test('parse rejects wrong formats and months', () {
      for (final value in ['2026-3', '2026-00', '2026-13', '2026-03-01']) {
        expect(
          () => YearMonth.parse(value),
          throwsFormatException,
          reason: value,
        );
      }
    });

    test('constructor rejects months outside 1..12', () {
      expect(() => YearMonth(2026, 0), throwsArgumentError);
      expect(() => YearMonth(2026, 13), throwsArgumentError);
    });
  });
}
