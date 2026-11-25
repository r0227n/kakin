import 'package:app/core/gen/slang.g.dart';

/// 表示言語に合わせた金額と日本時間の日時の書式。
///
/// 日時は常に日本時間で表示する。暦日は UTC の DateTime の年月日で受け取る。
abstract final class KakinFormats {
  static const Duration _japanOffset = Duration(hours: 9);

  static Translations get _t => LocaleSettings.instance.currentTranslations;

  /// 3桁区切りの数字。マイナスは「−」。
  static String number(int value) {
    final digits = value.abs().toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
      buffer.write(digits[i]);
    }
    return value < 0 ? '−$buffer' : buffer.toString();
  }

  /// 円の金額。[hidden] なら伏せ字。
  static String yen(int value, {bool hidden = false}) {
    if (hidden) return _t.format.hiddenYen;
    final amount = number(value.abs());
    return value < 0
        ? _t.format.negativeYen(amount: amount)
        : _t.format.yen(amount: amount);
  }

  /// 曜日の短い名前。[weekday] は [DateTime.monday]〜[DateTime.sunday]。
  static String weekday(int weekday) => _t.format.weekdays[weekday - 1];

  /// 月の名前。
  static String monthName(int month) => _t.format.monthNames[month - 1];

  /// 「2026年11月」。
  static String yearMonth(int year, int month) =>
      _t.format.yearMonth(year: year, monthName: monthName(month));

  /// 「11/24（火）」。[date] の年月日を暦日として使う。
  static String monthDay(DateTime date) => _t.format.monthDay(
    month: date.month,
    day: date.day,
    weekday: weekday(date.weekday),
  );

  /// 「11月22日（日）」。[date] の年月日を暦日として使う。
  static String dayTitle(DateTime date) => _t.format.dayTitle(
    monthName: monthName(date.month),
    day: date.day,
    weekday: weekday(date.weekday),
  );

  /// 「2026/11/22（日）」。[date] の年月日を暦日として使う。
  static String fullDate(DateTime date) => _t.format.fullDate(
    year: date.year,
    month: date.month,
    day: date.day,
    weekday: weekday(date.weekday),
  );

  /// [instant] の日本時間の「23:00」。
  static String time(DateTime instant) {
    final wall = instant.toUtc().add(_japanOffset);
    return '${wall.hour.toString().padLeft(2, '0')}:'
        '${wall.minute.toString().padLeft(2, '0')}';
  }

  /// [instant] の日本時間の暦日。
  static DateTime japanDate(DateTime instant) {
    final wall = instant.toUtc().add(_japanOffset);
    return DateTime.utc(wall.year, wall.month, wall.day);
  }

  /// [instant] の日本時間の「11/24（火） 23:00」。
  static String dateTime(DateTime instant) => _t.format.dateTime(
    date: monthDay(japanDate(instant)),
    time: time(instant),
  );
}
