import 'package:app/application/application.dart';
import 'package:app/core/formatting/kakin_formats.dart';
import 'package:app/core/gen/slang.g.dart';
import 'package:app/domain/domain.dart';
import 'package:app/presentation/navigation/routes.dart';
import 'package:app/presentation/shared/keys/app_keys.dart';
import 'package:app/presentation/shared/widgets/expense_row.dart';
import 'package:app/presentation/shared/widgets/visuals.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// 選んだ日の公演と支出。
class DayRecords extends StatelessWidget {
  /// [overview] が読み込み中なら見出しだけを出す。
  const DayRecords({
    required this.date,
    required this.overview,
    required this.hidden,
    super.key,
  });

  /// 選んだ日。
  final LocalDate date;

  /// 月の概要。
  final MonthOverview? overview;

  /// 金額を隠すか。
  final bool hidden;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final palette = context.palette;
    final expenses = overview?.expensesOn(date) ?? const <Expense>[];
    final performances =
        overview?.performancesOn(date) ?? const <Performance>[];
    final total = expenses.fold(0, (sum, e) => sum + e.amountYen);
    final basis = overview?.basis ?? AccountingBasis.paidOn;
    return Material(
      key: AppKeys.dayRecords,
      color: palette.surface,
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppRadius.l + 2),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.m,
          AppSpacing.sm + 2,
          AppSpacing.m,
          96,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.s + 2,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Expanded(
                  child: Semantics(
                    header: true,
                    child: Text(
                      KakinFormats.dayTitle(date.asDateTime),
                      key: AppKeys.dayRecordsTitle,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                if (expenses.isNotEmpty)
                  Text(
                    KakinFormats.yen(total, hidden: hidden),
                    key: AppKeys.dayRecordsTotal,
                    style: AppTypography.numeric(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
              ],
            ),
            for (final performance in performances)
              _PerformanceTile(performance: performance),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final (index, expense) in expenses.indexed)
                  ExpenseRow(
                    expense: expense,
                    subtitle: expenseSubtitle(
                      t,
                      expense,
                      extra:
                          basis == AccountingBasis.performanceDate &&
                              expense.paidOn != date
                          ? _paidOnNote(t, expense)
                          : null,
                    ),
                    isDuplicate: overview!.duplicateExpenseIds.contains(
                      expense.id,
                    ),
                    hidden: hidden,
                    showDivider: index < expenses.length - 1,
                  ),
              ],
            ),
            if (expenses.isEmpty && performances.isEmpty && overview != null)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.s),
                child: Text(
                  t.calendar.noRecords,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: palette.textSecondary),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PerformanceTile extends StatelessWidget {
  const _PerformanceTile({required this.performance});

  final Performance performance;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final palette = context.palette;
    return Material(
      color: palette.accentSoft,
      borderRadius: BorderRadius.circular(AppRadius.m),
      child: InkWell(
        key: AppKeys.dayPerformance(performance.id),
        borderRadius: BorderRadius.circular(AppRadius.m),
        onTap: () => PerformanceDetailRoute(
          performanceId: performance.id,
        ).push<void>(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.s + 2,
          ),
          child: Row(
            spacing: AppSpacing.s + 2,
            children: [
              Icon(
                Icons.confirmation_number_outlined,
                color: palette.accent,
                size: 22,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 1,
                  children: [
                    Text(
                      performance.title,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: palette.accentInk,
                      ),
                    ),
                    Text(
                      performanceMeta(t, performance),
                      style: TextStyle(
                        fontSize: 11,
                        color: palette.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, size: 18, color: palette.accentInk),
            ],
          ),
        ),
      ),
    );
  }
}

String _paidOnNote(Translations t, Expense expense) =>
    '${KakinFormats.monthDay(expense.paidOn.asDateTime)} ${t.basis.paidOn}';
