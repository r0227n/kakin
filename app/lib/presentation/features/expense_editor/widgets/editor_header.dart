import 'package:app/core/gen/slang.g.dart';
import 'package:app/presentation/shared/keys/app_keys.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// 支出の公演と支払日を選ぶボタンの行。
class EditorHeader extends StatelessWidget {
  /// [performanceMissing] なら公演のボタンを強調する。
  const EditorHeader({
    required this.performanceLabel,
    required this.performanceName,
    required this.performanceMissing,
    required this.dateText,
    required this.onPickPerformance,
    required this.onPickDate,
    super.key,
  });

  /// 公演の見出し。
  final String performanceLabel;

  /// 選んでいる公演名。
  final String performanceName;

  /// 公演が必要なのに選んでいないか。
  final bool performanceMissing;

  /// 支払日の表示。
  final String dateText;

  /// 公演を選ぶ。
  final VoidCallback onPickPerformance;

  /// 支払日を選ぶ。
  final VoidCallback onPickDate;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final palette = context.palette;
    final performanceButton = _HeaderButton(
      key: AppKeys.expensePerformance,
      icon: Icons.confirmation_number_outlined,
      label: performanceLabel,
      value: performanceName,
      border: performanceMissing
          ? BorderSide(color: palette.accent, width: 1.5)
          : BorderSide.none,
      onTap: onPickPerformance,
    );
    final dateButton = _HeaderButton(
      key: AppKeys.expensePaidOn,
      icon: Icons.event_outlined,
      label: t.expense.paidOn,
      value: dateText,
      numeric: true,
      onTap: onPickDate,
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        // 文字を拡大したときは2つのボタンを縦に並べる。
        final stacked =
            constraints.maxWidth / MediaQuery.textScalerOf(context).scale(1) <
            320;
        if (stacked) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.s,
            children: [performanceButton, dateButton],
          );
        }
        return Row(
          spacing: AppSpacing.s,
          children: [
            Expanded(child: performanceButton),
            dateButton,
          ],
        );
      },
    );
  }
}

class _HeaderButton extends StatelessWidget {
  const _HeaderButton({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
    this.numeric = false,
    this.border = BorderSide.none,
    super.key,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;
  final bool numeric;
  final BorderSide border;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    const valueStyle = TextStyle(fontSize: 13, fontWeight: FontWeight.w700);
    return Semantics(
      button: true,
      label: '$label $value',
      excludeSemantics: true,
      child: Material(
        color: palette.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.m),
          side: border,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.m),
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 48),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: AppSpacing.s,
                children: [
                  Icon(icon, size: 18, color: palette.textTertiary),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          label,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: palette.textSecondary,
                          ),
                        ),
                        Text(
                          value,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: numeric
                              ? AppTypography.numeric(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                )
                              : valueStyle,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
