import 'package:app/application/application.dart';
import 'package:app/core/formatting/kakin_formats.dart';
import 'package:app/core/gen/slang.g.dart';
import 'package:app/domain/domain.dart';
import 'package:app/presentation/navigation/routes.dart';
import 'package:app/presentation/shared/keys/app_keys.dart';
import 'package:app/presentation/shared/widgets/common_widgets.dart';
import 'package:app/presentation/shared/widgets/visuals.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// リストの支出の1行。公演名を主に、カテゴリと補足を下に出す。
class ListExpenseRow extends StatelessWidget {
  /// タップで編集を開く。
  const ListExpenseRow({
    required this.expense,
    required this.basis,
    required this.isDuplicate,
    required this.hidden,
    this.showDivider = true,
    super.key,
  });

  /// 表示する支出。
  final Expense expense;

  /// 支出を置いている計上基準。
  final AccountingBasis basis;

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
    final performance = expense.performance;
    final title = performance?.title ?? expense.category.label(t);
    final partner = expense.partner;
    final detail = [
      if (performance != null) expense.category.label(t),
      if (partner != null)
        '${partner.name} · ${t.format.shots(count: expense.shotCount ?? 1)}',
      if (basis == AccountingBasis.paidOn && performance != null)
        t.list.performanceOn(
          date: KakinFormats.monthDay(performance.startsOn.asDateTime),
        ),
      if (basis == AccountingBasis.performanceDate && performance != null)
        '${t.basis.paidOn} ${KakinFormats.monthDay(expense.paidOn.asDateTime)}',
      if (expense.note case final note? when note.isNotEmpty) note,
    ].join(' · ');
    final amount = KakinFormats.yen(expense.amountYen, hidden: hidden);
    return Semantics(
      button: true,
      label: [
        title,
        detail,
        if (expense.isImported) t.calendar.gmailBadge,
        if (isDuplicate) t.calendar.duplicateBadge,
        amount,
      ].join(' '),
      excludeSemantics: true,
      child: InkWell(
        key: AppKeys.expenseRow(expense.id),
        onTap: () =>
            EditExpenseRoute(expenseId: expense.id).push<void>(context),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          decoration: BoxDecoration(
            border: showDivider
                ? Border(bottom: BorderSide(color: palette.divider))
                : null,
          ),
          child: Row(
            spacing: AppSpacing.sm,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: tone.soft,
                  borderRadius: BorderRadius.circular(AppRadius.m),
                ),
                child: Icon(expense.category.icon, color: tone.ink, size: 22),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 3,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Wrap(
                      spacing: 6,
                      runSpacing: 2,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        if (detail.isNotEmpty)
                          Text(
                            detail,
                            style: TextStyle(
                              fontSize: 12,
                              color: palette.textSecondary,
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
                  ],
                ),
              ),
              Text(
                amount,
                style: AppTypography.numeric(
                  fontSize: 15,
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
