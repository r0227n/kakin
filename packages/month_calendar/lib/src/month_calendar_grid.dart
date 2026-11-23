import 'package:flutter/widgets.dart';
import 'package:month_calendar/src/calendar_month.dart';

/// 1日分のセルを描く。[day] は 1 始まりの日付。
typedef MonthCalendarDayBuilder =
    Widget Function(BuildContext context, int day);

/// 曜日の見出しと日付のセルを並べる月のグリッド。
///
/// 月の移動やセルの見た目は持たず、横スワイプを [onSwipePrevious] /
/// [onSwipeNext] で知らせるだけにする。
class MonthCalendarGrid extends StatelessWidget {
  /// [weekdayLabels] は [firstDayOfWeek] から始まる7つの見出し。
  const MonthCalendarGrid({
    required this.month,
    required this.weekdayLabels,
    required this.dayBuilder,
    this.firstDayOfWeek = DateTime.sunday,
    this.cellHeight = 44,
    this.spacing = 2,
    this.headerSpacing = 4,
    this.weekdayStyle,
    this.onSwipePrevious,
    this.onSwipeNext,
    super.key,
  }) : assert(weekdayLabels.length == 7, 'weekdayLabels needs 7 entries');

  /// 表示する月。
  final CalendarMonth month;

  /// 曜日の見出し。
  final List<String> weekdayLabels;

  /// 各日のセル。
  final MonthCalendarDayBuilder dayBuilder;

  /// 週の最初の曜日。[DateTime.monday]〜[DateTime.sunday]。
  final int firstDayOfWeek;

  /// セルの最小の高さ。文字が拡大されると高くなる。
  final double cellHeight;

  /// セルどうしの間隔。
  final double spacing;

  /// 見出しとグリッドの間隔。
  final double headerSpacing;

  /// 曜日の見出しの文字スタイル。
  final TextStyle? weekdayStyle;

  /// 右へのスワイプ（前の月へ）。
  final VoidCallback? onSwipePrevious;

  /// 左へのスワイプ（次の月へ）。
  final VoidCallback? onSwipeNext;

  @override
  Widget build(BuildContext context) {
    final blanks = month.leadingBlankCount(firstDayOfWeek);
    final cellCount = blanks + month.dayCount;
    final rowCount = (cellCount / 7).ceil();
    final rows = <Widget>[
      ExcludeSemantics(
        child: Row(
          children: [
            for (final label in weekdayLabels)
              Expanded(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: weekdayStyle,
                ),
              ),
          ],
        ),
      ),
      SizedBox(height: headerSpacing),
    ];
    for (var row = 0; row < rowCount; row++) {
      if (row > 0) rows.add(SizedBox(height: spacing));
      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var column = 0; column < 7; column++) ...[
                if (column > 0) SizedBox(width: spacing),
                Expanded(child: _cell(context, row * 7 + column - blanks + 1)),
              ],
            ],
          ),
        ),
      );
    }
    final grid = Column(mainAxisSize: MainAxisSize.min, children: rows);
    if (onSwipePrevious == null && onSwipeNext == null) return grid;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onHorizontalDragEnd: (details) {
        final velocity = details.primaryVelocity ?? 0;
        if (velocity > 200) onSwipePrevious?.call();
        if (velocity < -200) onSwipeNext?.call();
      },
      child: grid,
    );
  }

  Widget _cell(BuildContext context, int day) {
    if (day < 1 || day > month.dayCount) {
      return ConstrainedBox(
        constraints: BoxConstraints(minHeight: cellHeight),
      );
    }
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: cellHeight),
      child: dayBuilder(context, day),
    );
  }
}
