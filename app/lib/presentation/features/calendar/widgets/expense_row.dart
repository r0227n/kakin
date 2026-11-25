import 'package:app/application/application.dart';
import 'package:app/core/formatting/kakin_formats.dart';
import 'package:app/core/gen/slang.g.dart';
import 'package:app/presentation/navigation/routes.dart';
import 'package:app/presentation/shared/keys/app_keys.dart';
import 'package:app/presentation/shared/widgets/common_widgets.dart';
import 'package:app/presentation/shared/widgets/visuals.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// 支出の1行。タップで編集を開く。
class ExpenseRow extends StatelessWidget {
  /// [subtitle] は公演名や支払日などの補足。
  const ExpenseRow({
    required this.expense,
    required this.subtitle,
    required this.isDuplicate,
    required this.hidden,
    this.showDivider = true,
    super.key,
  });

  /// 表示する支出。
  final Expense expense;

  /// 補足の行。
  final String subtitle;

  /// 二重計上の可能性があるか。
  final bool isDuplicate;

  /// 金額を隠すか。
  final bool hidden;

  /// 下に区切り線を引くか。
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final palette = context.palette;
    final tone = expense.category.tone(palette);
    final amount = KakinFormats.yen(expense.amountYen, hidden: hidden);
    return Semantics(
      button: true,
      label: [
        expense.category.label(t),
        if (expense.isImported) t.calendar.gmailBadge,
        if (isDuplicate) t.calendar.duplicateBadge,
        subtitle,
        amount,
      ].join(' '),
      excludeSemantics: true,
      child: InkWell(
        key: AppKeys.expenseRow(expense.id),
        onTap: () =>
            EditExpenseRoute(expenseId: expense.id).push<void>(context),
        child: Container(
          constraints: const BoxConstraints(minHeight: 52),
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            border: showDivider
                ? Border(bottom: BorderSide(color: palette.divider))
                : null,
          ),
          child: Row(
            spacing: AppSpacing.s + 2,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: tone.chart,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSpacing.xxs,
                  children: [
                    Wrap(
                      spacing: 6,
                      runSpacing: 2,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          expense.category.label(t),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (expense.isImported)
                          TagChip(
                            label: t.calendar.gmailBadge,
                            foreground: palette.accentStrong,
                            background: palette.accentSoft,
                          ),
                        if (isDuplicate)
                          TagChip(
                            key: AppKeys.duplicateBadge(expense.id),
                            label: t.calendar.duplicateBadge,
                            foreground: palette.warningInk,
                            background: palette.warningSoft,
                          ),
                      ],
                    ),
                    if (subtitle.isNotEmpty)
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          color: palette.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
              Text(
                amount,
                style: AppTypography.numeric(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 支出の補足の行。チェキ相手と枚数、公演名、メモを順に並べる。
String expenseSubtitle(Translations t, Expense expense, {String? extra}) {
  final partner = expense.partner;
  return [
    if (partner != null)
      '${partner.name} · ${t.format.shots(count: expense.shotCount ?? 1)}',
    ?expense.performance?.title,
    ?extra,
    if (expense.note case final note? when note.isNotEmpty) note,
  ].join(' · ');
}

/// 公演の開始時刻と会場。
String performanceMeta(Translations t, Performance performance) {
  final time = KakinFormats.time(performance.startsAt);
  final venue = performance.venue;
  return venue == null || venue.isEmpty
      ? t.calendar.performanceMeta(time: time)
      : t.calendar.performanceMetaVenue(time: time, venue: venue);
}
