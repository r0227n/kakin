import 'package:app/application/application.dart';
import 'package:app/core/formatting/kakin_formats.dart';
import 'package:app/core/gen/slang.g.dart';
import 'package:app/domain/domain.dart';
import 'package:app/presentation/shared/controllers/app_preferences_controller.dart';
import 'package:app/presentation/shared/controllers/ledger_view_controller.dart';
import 'package:app/presentation/shared/feedback/action_feedback.dart';
import 'package:app/presentation/shared/keys/app_keys.dart';
import 'package:app/presentation/shared/widgets/common_widgets.dart';
import 'package:app/presentation/shared/widgets/visuals.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 表示中の月と前後の月への移動。カレンダーとリストの [AppBar]。
class MonthAppBar extends ConsumerWidget implements PreferredSizeWidget {
  /// 表示中の月は [LedgerViewController] が所有する。
  const MonthAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final view = ref.watch(ledgerViewControllerProvider);
    final controller = ref.read(ledgerViewControllerProvider.notifier);
    final title = KakinFormats.yearMonth(view.month.year, view.month.month);
    return AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            key: AppKeys.monthPrevious,
            tooltip: t.calendar.previousMonth,
            onPressed: controller.showPreviousMonth,
            icon: const Icon(Icons.chevron_left),
          ),
          Flexible(
            child: Semantics(
              liveRegion: true,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  title,
                  key: AppKeys.monthTitle,
                  style: AppTypography.numeric(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            key: AppKeys.monthNext,
            tooltip: t.calendar.nextMonth,
            onPressed: controller.showNextMonth,
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}

/// 計上基準の切り替え。カレンダーとリストの本文の先頭に置く。
class BasisToggle extends ConsumerWidget {
  /// 計上基準は [LedgerViewController] が所有する。
  const BasisToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final basis = ref.watch(
      ledgerViewControllerProvider.select((view) => view.basis),
    );
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: SegmentToggle<AccountingBasis>(
        key: AppKeys.basisToggle,
        semanticLabel: t.basis.label,
        value: basis,
        options: {
          AccountingBasis.paidOn: t.basis.paidOn,
          AccountingBasis.performanceDate: t.basis.performanceDate,
        },
        onChanged: ref.read(ledgerViewControllerProvider.notifier).setBasis,
      ),
    );
  }
}

/// 金額を隠すかの切り替え。設定の「金額を表示する」と同じ値を変える。
class AmountVisibilityButton extends ConsumerWidget {
  /// 保存に失敗したら知らせる。
  const AmountVisibilityButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final visible = ref.watch(
      appPreferencesControllerProvider.select((p) => p.amountsVisible),
    );
    final palette = context.palette;
    return Semantics(
      toggled: !visible,
      child: TextButton.icon(
        key: AppKeys.amountVisibility,
        style: TextButton.styleFrom(
          backgroundColor: palette.surfaceMuted,
          foregroundColor: palette.textTertiary,
          minimumSize: const Size(44, 36),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s + 2),
          textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          shape: const StadiumBorder(),
        ),
        onPressed: () => runWithFeedback(
          context,
          ref,
          () => ref
              .read(appPreferencesControllerProvider.notifier)
              .setAmountsVisible(visible: !visible),
          failureLog: 'Saving amount visibility failed',
        ),
        icon: Icon(
          visible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          size: 16,
        ),
        label: Text(visible ? t.summary.hideAmounts : t.summary.showAmounts),
      ),
    );
  }
}

/// 推し活代・繰越・支出・残高とカテゴリ別の内訳。
class MonthSummaryCard extends ConsumerWidget {
  /// [overview] の値を表示する。
  const MonthSummaryCard({required this.overview, super.key});

  /// 表示する月の概要。
  final MonthOverview overview;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final palette = context.palette;
    final hidden = !ref.watch(
      appPreferencesControllerProvider.select((p) => p.amountsVisible),
    );
    final ledger = overview.ledger;
    final isPerformanceBasis =
        overview.basis == AccountingBasis.performanceDate;
    final spendLabel = isPerformanceBasis
        ? t.summary.spendByPerformanceDate
        : t.summary.spend;
    String yen(int value) => KakinFormats.yen(value, hidden: hidden);
    final byCategory = overview.spendByCategory;
    return Semantics(
      label: t.summary.label,
      container: true,
      child: SurfaceCard(
        key: AppKeys.monthSummary,
        radius: AppRadius.l + 2,
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.m,
          AppSpacing.sm,
          AppSpacing.s,
          AppSpacing.sm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.s + 2,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    ledger == null ? spendLabel : t.summary.balance,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: palette.textSecondary,
                    ),
                  ),
                ),
                const AmountVisibilityButton(),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.s),
              child: ledger == null
                  ? _UnconfiguredSummary(
                      spend: yen(overview.spendTotalYen),
                      note: overview.isBudgetConfigured
                          ? t.summary.beforeStart
                          : t.summary.unconfigured,
                    )
                  : _LedgerSummary(
                      ledger: ledger,
                      hidden: hidden,
                      spendLabel: spendLabel,
                      spend: yen(overview.spendTotalYen),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.s),
              child: _CategoryBar(totals: byCategory),
            ),
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.s),
              child: _CategoryLegend(totals: byCategory, hidden: hidden),
            ),
            if (isPerformanceBasis)
              Text(
                t.summary.performanceBasisNote,
                style: TextStyle(fontSize: 11, color: palette.textSecondary),
              ),
          ],
        ),
      ),
    );
  }
}

class _UnconfiguredSummary extends StatelessWidget {
  const _UnconfiguredSummary({required this.spend, required this.note});

  final String spend;
  final String note;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: AppSpacing.xxs,
    children: [
      Text(
        spend,
        key: AppKeys.summarySpendTotal,
        style: AppTypography.numeric(fontSize: 30, fontWeight: FontWeight.w700),
      ),
      Text(
        note,
        style: TextStyle(fontSize: 11, color: context.palette.textSecondary),
      ),
    ],
  );
}

class _LedgerSummary extends StatelessWidget {
  const _LedgerSummary({
    required this.ledger,
    required this.hidden,
    required this.spendLabel,
    required this.spend,
  });

  final LedgerMonth ledger;
  final bool hidden;
  final String spendLabel;
  final String spend;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final palette = context.palette;
    final negative = ledger.balanceYen < 0;
    final balanceText = hidden
        ? (negative ? t.summary.overBudget : t.summary.withinBudget)
        : KakinFormats.yen(ledger.balanceYen);
    final note = hidden
        ? t.summary.hiddenNote
        : (negative ? t.summary.negativeNote : null);
    final details = TextStyle(fontSize: 12, color: palette.textSecondary);
    final value = AppTypography.numeric(fontSize: 12);
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.end,
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.s,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: AppSpacing.xxs,
          children: [
            Text(
              balanceText,
              key: AppKeys.summaryBalance,
              style: AppTypography.numeric(
                fontSize: hidden ? 24 : 30,
                fontWeight: FontWeight.w700,
                color: negative ? palette.negative : palette.textPrimary,
                height: 1.1,
              ),
            ),
            if (note != null)
              Text(
                note,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: negative ? palette.negative : palette.textSecondary,
                ),
              ),
          ],
        ),
        Table(
          defaultColumnWidth: const IntrinsicColumnWidth(),
          defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            _row(
              t.summary.budget,
              KakinFormats.yen(ledger.budgetYen, hidden: hidden),
              details,
              value,
            ),
            _row(
              t.summary.carryover,
              KakinFormats.yen(ledger.carryoverYen, hidden: hidden),
              details,
              value,
            ),
            _row(
              spendLabel,
              spend,
              details,
              value.copyWith(fontWeight: FontWeight.w700),
              key: AppKeys.summarySpendTotal,
            ),
          ],
        ),
      ],
    );
  }

  TableRow _row(
    String label,
    String amount,
    TextStyle labelStyle,
    TextStyle valueStyle, {
    Key? key,
  }) => TableRow(
    children: [
      Padding(
        padding: const EdgeInsets.only(right: AppSpacing.s + 2, bottom: 3),
        child: Text(label, style: labelStyle, textAlign: TextAlign.right),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 3),
        child: Text(
          amount,
          key: key,
          style: valueStyle,
          textAlign: TextAlign.right,
        ),
      ),
    ],
  );
}

class _CategoryBar extends StatelessWidget {
  const _CategoryBar({required this.totals});

  final Map<ExpenseCategory, int> totals;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final sum = totals.values.fold(0, (a, b) => a + b);
    return ExcludeSemantics(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.xs),
        child: SizedBox(
          height: 8,
          child: sum == 0
              ? ColoredBox(color: palette.surfaceMuted)
              : Row(
                  spacing: AppSpacing.xxs,
                  children: [
                    for (final entry in totals.entries)
                      if (entry.value > 0)
                        Expanded(
                          flex: (entry.value * 1000 / sum).ceil(),
                          child: ColoredBox(
                            color: entry.key.tone(palette).chart,
                          ),
                        ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _CategoryLegend extends StatelessWidget {
  const _CategoryLegend({required this.totals, required this.hidden});

  final Map<ExpenseCategory, int> totals;
  final bool hidden;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final palette = context.palette;
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth < 300 ? 2 : 3;
        final width =
            (constraints.maxWidth - AppSpacing.s * (columns - 1)) / columns;
        return Wrap(
          spacing: AppSpacing.s,
          runSpacing: AppSpacing.xs,
          children: [
            for (final entry in totals.entries)
              SizedBox(
                width: width,
                child: Semantics(
                  label:
                      '${entry.key.label(t)} '
                      '${KakinFormats.yen(entry.value, hidden: hidden)}',
                  excludeSemantics: true,
                  child: Row(
                    spacing: 5,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: entry.key.tone(palette).chart,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Text(
                        entry.key.shortLabel(t),
                        style: TextStyle(
                          fontSize: 11,
                          color: palette.textSecondary,
                        ),
                      ),
                      // 名前を優先して見せ、金額は幅が足りなければ縮める。
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: Text(
                            hidden
                                ? t.format.hiddenNumber
                                : KakinFormats.number(entry.value),
                            style: AppTypography.numeric(fontSize: 11),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
