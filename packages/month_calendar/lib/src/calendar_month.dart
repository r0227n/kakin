import 'package:flutter/foundation.dart';

/// 暦の上の1ヶ月。タイムゾーンを持たない。
@immutable
final class CalendarMonth implements Comparable<CalendarMonth> {
  /// [month] は 1〜12。範囲外は ArgumentError。
  CalendarMonth(this.year, this.month) {
    if (month < 1 || month > 12) {
      throw ArgumentError.value(month, 'month', 'must be 1..12');
    }
  }

  /// [date] の年月。時刻とタイムゾーンは無視する。
  factory CalendarMonth.of(DateTime date) =>
      CalendarMonth(date.year, date.month);

  /// 西暦の年。
  final int year;

  /// 1〜12 の月。
  final int month;

  /// その月の日数。
  int get dayCount => DateTime.utc(year, month + 1, 0).day;

  /// 1日の曜日。[DateTime.monday]〜[DateTime.sunday]。
  int get firstWeekday => DateTime.utc(year, month).weekday;

  /// 翌月。
  CalendarMonth get next =>
      month == 12 ? CalendarMonth(year + 1, 1) : CalendarMonth(year, month + 1);

  /// 前月。
  CalendarMonth get previous =>
      month == 1 ? CalendarMonth(year - 1, 12) : CalendarMonth(year, month - 1);

  /// 週の始まりを [firstDayOfWeek] としたときの、1日より前の空きセルの数。
  int leadingBlankCount(int firstDayOfWeek) =>
      (firstWeekday - firstDayOfWeek) % 7;

  @override
  int compareTo(CalendarMonth other) =>
      year != other.year ? year - other.year : month - other.month;

  @override
  bool operator ==(Object other) =>
      other is CalendarMonth && other.year == year && other.month == month;

  @override
  int get hashCode => Object.hash(year, month);

  @override
  String toString() => '$year-${month.toString().padLeft(2, '0')}';
}
