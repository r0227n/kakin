/// タイムゾーンを持たない暦日。支払日など「日本時間の何日か」を表す。
final class LocalDate implements Comparable<LocalDate> {
  /// 存在しない日付は ArgumentError。
  LocalDate(this.year, this.month, this.day) {
    if (!_exists(year, month, day)) {
      throw ArgumentError('Invalid date: $year-$month-$day');
    }
  }

  /// `YYYY-MM-DD` を解釈する。形式が違う・存在しない日付は FormatException。
  factory LocalDate.parse(String value) {
    final match = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$').firstMatch(value);
    if (match == null) throw FormatException('Invalid date', value);
    final year = int.parse(match.group(1)!);
    final month = int.parse(match.group(2)!);
    final day = int.parse(match.group(3)!);
    if (!_exists(year, month, day)) {
      throw FormatException('Invalid date', value);
    }
    return LocalDate(year, month, day);
  }

  static bool _exists(int year, int month, int day) {
    final normalized = DateTime.utc(year, month, day);
    return normalized.year == year &&
        normalized.month == month &&
        normalized.day == day;
  }

  /// 西暦の年。
  final int year;

  /// 1〜12 の月。
  final int month;

  /// 1 始まりの日。
  final int day;

  /// この日を含む月。
  YearMonth get yearMonth => YearMonth(year, month);

  /// 曜日。[DateTime.monday]〜[DateTime.sunday]。
  int get weekday => DateTime.utc(year, month, day).weekday;

  /// [days] 日後（負なら前）の暦日。
  LocalDate addDays(int days) {
    final moved = DateTime.utc(year, month, day + days);
    return LocalDate(moved.year, moved.month, moved.day);
  }

  /// `YYYY-MM-DD`。
  String toIso() =>
      '${year.toString().padLeft(4, '0')}-${_two(month)}-${_two(day)}';

  /// 2つの暦日の差（日数）。
  int daysUntil(LocalDate other) => DateTime.utc(
    other.year,
    other.month,
    other.day,
  ).difference(DateTime.utc(year, month, day)).inDays;

  /// [other] より後か。
  bool isAfter(LocalDate other) => compareTo(other) > 0;

  /// [other] より前か。
  bool isBefore(LocalDate other) => compareTo(other) < 0;

  @override
  int compareTo(LocalDate other) {
    if (year != other.year) return year - other.year;
    if (month != other.month) return month - other.month;
    return day - other.day;
  }

  @override
  // domain は meta に依存しないため @immutable を付けず、全フィールドを final にする。
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) =>
      other is LocalDate &&
      other.year == year &&
      other.month == month &&
      other.day == day;

  @override
  // domain は meta に依存しないため @immutable を付けず、全フィールドを final にする。
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => Object.hash(year, month, day);

  @override
  String toString() => toIso();
}

/// タイムゾーンを持たない暦月。推し活代や月の集計の単位。
final class YearMonth implements Comparable<YearMonth> {
  /// [month] は 1〜12。範囲外は ArgumentError。
  YearMonth(this.year, this.month) {
    if (month < 1 || month > 12) {
      throw ArgumentError.value(month, 'month', 'must be 1..12');
    }
  }

  /// `YYYY-MM` を解釈する。
  factory YearMonth.parse(String value) {
    final match = RegExp(r'^(\d{4})-(\d{2})$').firstMatch(value);
    if (match == null) throw FormatException('Invalid month', value);
    final month = int.parse(match.group(2)!);
    if (month < 1 || month > 12) throw FormatException('Invalid month', value);
    return YearMonth(int.parse(match.group(1)!), month);
  }

  /// 西暦の年。
  final int year;

  /// 1〜12 の月。
  final int month;

  /// 月初の暦日。
  LocalDate get firstDay => LocalDate(year, month, 1);

  /// 月末の暦日。
  LocalDate get lastDay => next.firstDay.addDays(-1);

  /// 翌月。
  YearMonth get next =>
      month == 12 ? YearMonth(year + 1, 1) : YearMonth(year, month + 1);

  /// 前月。
  YearMonth get previous =>
      month == 1 ? YearMonth(year - 1, 12) : YearMonth(year, month - 1);

  /// [date] がこの月に含まれるか。
  bool contains(LocalDate date) => date.year == year && date.month == month;

  /// `YYYY-MM`。
  String toIso() => '${year.toString().padLeft(4, '0')}-${_two(month)}';

  /// [other] より後か。
  bool isAfter(YearMonth other) => compareTo(other) > 0;

  /// [other] より前か。
  bool isBefore(YearMonth other) => compareTo(other) < 0;

  @override
  int compareTo(YearMonth other) =>
      year != other.year ? year - other.year : month - other.month;

  @override
  // domain は meta に依存しないため @immutable を付けず、全フィールドを final にする。
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) =>
      other is YearMonth && other.year == year && other.month == month;

  @override
  // domain は meta に依存しないため @immutable を付けず、全フィールドを final にする。
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => Object.hash(year, month);

  @override
  String toString() => toIso();
}

String _two(int value) => value.toString().padLeft(2, '0');
