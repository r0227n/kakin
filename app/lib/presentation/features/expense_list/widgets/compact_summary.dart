import 'package:app/application/application.dart';
import 'package:app/core/formatting/kakin_formats.dart';
import 'package:app/core/gen/slang.g.dart';
import 'package:app/domain/domain.dart';
import 'package:app/presentation/shared/keys/app_keys.dart';
import 'package:app/presentation/shared/widgets/common_widgets.dart';
import 'package:app/presentation/shared/widgets/month_summary.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// リストの上部の、推し活代・繰越・支出・残高の1行の概要。
class CompactSummary extends StatelessWidget {
  /// 推し活代が未設定なら支出だけを出す。
  const CompactSummary({
    required this.overview,
    required this.hidden,
    super.key,
  });

  /// 月の概要。
  final MonthOverview overview;

  /// 金額を隠すか。
  final bool hidden;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final palette = context.palette;
    final ledger = overview.ledger;
    final spendLabel = overview.basis == AccountingBasis.performanceDate
        ? t.summary.spendByPerformanceDate
        : t.summary.spend;
    final negative = (ledger?.balanceYen ?? 0) < 0;
    String yen(int value) => KakinFormats.yen(value, hidden: hidden);
    return SurfaceCard(
      key: AppKeys.monthSummary,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.m,
        AppSpacing.sm,
        AppSpacing.s,
        AppSpacing.sm,
      ),
      child: Row(
        children: [
          Expanded(
            child: Wrap(
              spacing: AppSpacing.m,
              runSpacing: AppSpacing.s,
              children: [
                if (ledger != null) ...[
                  _Figure(
                    label: t.summary.budget,
                    value: yen(ledger.budgetYen),
                  ),
                  _Figure(
                    label: t.summary.carryover,
                    value: yen(ledger.carryoverYen),
                  ),
                ],
                _Figure(
                  label: spendLabel,
                  value: yen(overview.spendTotalYen),
                  valueKey: AppKeys.summarySpendTotal,
                  bold: true,
                ),
                if (ledger != null)
                  _Figure(
                    label: t.summary.balance,
                    value: hidden
                        ? (negative
                              ? t.summary.overBudget
                              : t.summary.withinBudget)
                        : yen(ledger.balanceYen),
                    valueKey: AppKeys.summaryBalance,
                    bold: true,
                    color: negative ? palette.negative : null,
                  ),
              ],
            ),
          ),
          const AmountVisibilityButton(),
        ],
      ),
    );
  }
}

class _Figure extends StatelessWidget {
  const _Figure({
    required this.label,
    required this.value,
    this.valueKey,
    this.bold = false,
    this.color,
  });

  final String label;
  final String value;
  final Key? valueKey;
  final bool bold;
  final Color? color;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    spacing: AppSpacing.xxs,
    children: [
      Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: color == null ? FontWeight.w400 : FontWeight.w700,
          color: color ?? context.palette.textSecondary,
        ),
      ),
      Text(
        value,
        key: valueKey,
        style: AppTypography.numeric(
          fontSize: 14,
          fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
          color: color,
        ),
      ),
    ],
  );
}
