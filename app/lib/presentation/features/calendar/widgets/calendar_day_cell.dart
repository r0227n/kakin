import 'package:app/core/formatting/kakin_formats.dart';
import 'package:app/core/gen/slang.g.dart';
import 'package:app/domain/domain.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// カレンダーの1日。支出合計と公演の印を出す。
class CalendarDayCell extends StatelessWidget {
  /// 選んだ日は塗り、今日は枠で示す。
  const CalendarDayCell({
    required this.date,
    required this.spendYen,
    required this.hasPerformance,
    required this.isSelected,
    required this.isToday,
    required this.hidden,
    required this.onTap,
    super.key,
  });

  /// 日付。
  final LocalDate date;

  /// この日に置いた支出の合計。
  final int spendYen;

  /// この日に開始する公演があるか。
  final bool hasPerformance;

  /// 選んでいる日か。
  final bool isSelected;

  /// 今日か。
  final bool isToday;

  /// 金額を隠すか。
  final bool hidden;

  /// 日を選ぶ。
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final palette = context.palette;
    final foreground = isSelected ? palette.onAccent : palette.textPrimary;
    final sub = isSelected
        ? palette.onAccent.withValues(alpha: 0.88)
        : palette.textSecondary;
    final background = isSelected
        ? palette.accent
        : (spendYen > 0 ? palette.surface : Colors.transparent);
    return Semantics(
      button: true,
      selected: isSelected,
      label: calendarDayLabel(
        t,
        date,
        spendYen: spendYen,
        hasPerformance: hasPerformance,
        hidden: hidden,
      ),
      excludeSemantics: true,
      child: Material(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.s + 2),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.s + 2),
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 44),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.s + 2),
              border: Border.all(
                color: isToday && !isSelected
                    ? palette.accent
                    : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 4,
                    children: [
                      Text(
                        '${date.day}',
                        textAlign: TextAlign.center,
                        style: AppTypography.numeric(
                          fontSize: 13,
                          color: foreground,
                          height: 1,
                        ),
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          spendYen == 0
                              ? ' '
                              : (hidden
                                    ? Translations.of(
                                        context,
                                      ).format.hiddenNumber
                                    : KakinFormats.number(spendYen)),
                          style: AppTypography.numeric(
                            fontSize: 9.5,
                            color: sub,
                            height: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (hasPerformance)
                  Positioned(
                    top: 5,
                    right: 6,
                    child: Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? palette.onAccent
                            : palette.cheki.chart,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// カレンダーのセルの読み上げ。
String calendarDayLabel(
  Translations t,
  LocalDate date, {
  required int spendYen,
  required bool hasPerformance,
  required bool hidden,
}) => [
  KakinFormats.dayTitle(DateTime.utc(date.year, date.month, date.day)),
  if (spendYen > 0)
    hidden
        ? t.calendar.daySpendHidden
        : t.calendar.daySpend(amount: KakinFormats.yen(spendYen)),
  if (hasPerformance) t.calendar.dayHasPerformance,
].join(' ');
