import 'package:app/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('the JST date changes at 15:00 UTC', () {
    expect(
      JapanTime.dateOf(DateTime.utc(2026, 11, 22, 14, 59)),
      LocalDate(2026, 11, 22),
    );
    expect(
      JapanTime.dateOf(DateTime.utc(2026, 11, 22, 15)),
      LocalDate(2026, 11, 23),
    );
  });

  test('the JST date crosses month and year boundaries', () {
    expect(
      JapanTime.dateOf(DateTime.utc(2026, 12, 31, 15)),
      LocalDate(2027, 1, 1),
    );
  });

  test('instantOf returns the UTC instant of a JST wall clock time', () {
    expect(
      JapanTime.instantOf(LocalDate(2026, 11, 23)),
      DateTime.utc(2026, 11, 22, 15),
    );
    expect(
      JapanTime.instantOf(LocalDate(2026, 11, 23), hour: 20, minute: 30),
      DateTime.utc(2026, 11, 23, 11, 30),
    );
  });

  test('wallClockOf shifts the instant by nine hours', () {
    final wall = JapanTime.wallClockOf(DateTime.utc(2026, 11, 22, 18, 5));

    expect((wall.day, wall.hour, wall.minute), (23, 3, 5));
  });

  test('dateOf and instantOf round-trip', () {
    final date = LocalDate(2026, 3, 1);

    expect(JapanTime.dateOf(JapanTime.instantOf(date, hour: 23)), date);
  });

  test('dateOf accepts local DateTime values by their instant', () {
    final instant = DateTime.utc(2026, 11, 22, 15);

    expect(JapanTime.dateOf(instant.toLocal()), LocalDate(2026, 11, 23));
  });
}
