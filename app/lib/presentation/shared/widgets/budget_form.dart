import 'package:app/core/formatting/kakin_formats.dart';
import 'package:app/core/gen/slang.g.dart';
import 'package:app/domain/domain.dart';
import 'package:app/presentation/shared/keys/app_keys.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 推し活代の月額と開始月の入力。初回案内と設定で使う。
class BudgetForm extends StatelessWidget {
  /// 値は呼び出し元が持つ。
  const BudgetForm({
    required this.amountController,
    required this.startMonth,
    required this.monthOptions,
    required this.onStartMonthChanged,
    required this.onAmountChanged,
    super.key,
  });

  /// よく使う月額。
  static const presets = [10000, 20000, 30000, 50000];

  /// 月額の入力欄。
  final TextEditingController amountController;

  /// 選んでいる開始月。
  final YearMonth startMonth;

  /// 開始月の選択肢。
  final List<YearMonth> monthOptions;

  /// 開始月を変える。
  final ValueChanged<YearMonth> onStartMonthChanged;

  /// 月額が変わったことを知らせる。
  final VoidCallback onAmountChanged;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final palette = context.palette;
    final current = int.tryParse(amountController.text);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.s,
      children: [
        Text(
          t.settings.monthly,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
        ),
        TextField(
          key: AppKeys.budgetAmount,
          controller: amountController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(7),
          ],
          onChanged: (_) => onAmountChanged(),
          style: AppTypography.numeric(
            fontSize: 26,
            fontWeight: FontWeight.w700,
          ),
          decoration: InputDecoration(
            labelText: t.settings.monthly,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            prefixText: '¥ ',
            prefixStyle: AppTypography.numeric(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: palette.textSecondary,
            ),
          ),
        ),
        Wrap(
          spacing: AppSpacing.xs + 2,
          runSpacing: AppSpacing.xs + 2,
          children: [
            for (final preset in presets)
              ChoiceChip(
                key: AppKeys.budgetPreset(preset),
                label: Text(KakinFormats.yen(preset)),
                selected: current == preset,
                showCheckmark: false,
                onSelected: (_) {
                  amountController.text = '$preset';
                  onAmountChanged();
                },
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.s),
        Text(
          t.settings.startMonth,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
        ),
        DropdownButtonFormField<YearMonth>(
          key: AppKeys.budgetStartMonth,
          initialValue: startMonth,
          isExpanded: true,
          items: [
            for (final month in monthOptions)
              DropdownMenuItem(
                value: month,
                child: Text(KakinFormats.yearMonth(month.year, month.month)),
              ),
          ],
          onChanged: (month) {
            if (month != null) onStartMonthChanged(month);
          },
        ),
        Text(
          t.onboarding.budgetStartNote,
          style: TextStyle(fontSize: 12, color: palette.textSecondary),
        ),
      ],
    );
  }
}

/// [current] の前後の開始月の選択肢。
List<YearMonth> startMonthOptions(YearMonth current, {YearMonth? include}) {
  final options = <YearMonth>[];
  var month = current;
  for (var i = 0; i < 12; i++) {
    month = month.previous;
  }
  for (var i = 0; i < 15; i++) {
    options.add(month);
    month = month.next;
  }
  if (include != null && !options.contains(include)) {
    options
      ..add(include)
      ..sort();
  }
  return options;
}
