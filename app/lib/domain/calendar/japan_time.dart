import 'package:app/domain/calendar/local_date.dart';

/// 日本時間（UTC+9、夏時間なし）と瞬間の変換。
///
/// 日本は夏時間を持たないため、固定の時差で暦日と時刻を求める。
abstract final class JapanTime {
  /// UTC からの時差。
  static const Duration offset = Duration(hours: 9);

  /// [instant] の日本時間の壁時計の値を、UTC の DateTime の各項目に入れて返す。
  static DateTime wallClockOf(DateTime instant) => instant.toUtc().add(offset);

  /// [instant] の日本時間の暦日。
  static LocalDate dateOf(DateTime instant) {
    final wall = wallClockOf(instant);
    return LocalDate(wall.year, wall.month, wall.day);
  }

  /// 日本時間の [date] の [hour]:[minute] にあたる瞬間（UTC）。
  static DateTime instantOf(LocalDate date, {int hour = 0, int minute = 0}) =>
      DateTime.utc(
        date.year,
        date.month,
        date.day,
        hour,
        minute,
      ).subtract(offset);
}
