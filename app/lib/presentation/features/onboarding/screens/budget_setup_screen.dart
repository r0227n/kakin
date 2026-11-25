import 'package:app/core/formatting/kakin_formats.dart';
import 'package:app/core/gen/slang.g.dart';
import 'package:app/domain/domain.dart';
import 'package:app/presentation/dependencies/application_providers.dart';
import 'package:app/presentation/features/onboarding/widgets/onboarding_scaffold.dart';
import 'package:app/presentation/navigation/routes.dart';
import 'package:app/presentation/shared/feedback/action_feedback.dart';
import 'package:app/presentation/shared/keys/app_keys.dart';
import 'package:app/presentation/shared/widgets/budget_form.dart';
import 'package:app/presentation/shared/widgets/common_widgets.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 初回起動の案内で推し活代を設定する。スキップできる。
class BudgetSetupScreen extends ConsumerStatefulWidget {
  /// 設定は保存に成功してから次へ進む。
  const BudgetSetupScreen({super.key});

  @override
  ConsumerState<BudgetSetupScreen> createState() => _BudgetSetupScreenState();
}

class _BudgetSetupScreenState extends ConsumerState<BudgetSetupScreen> {
  final _amount = TextEditingController(text: '30000');
  late YearMonth _startMonth = ref.read(budgetUseCaseProvider).currentMonth;
  bool _saving = false;

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final amount = int.tryParse(_amount.text);
    if (amount == null || _saving) return;
    setState(() => _saving = true);
    final saved = await runWithFeedback(
      context,
      ref,
      () async {
        await ref
            .read(budgetUseCaseProvider)
            .configure(startMonth: _startMonth, monthlyYen: amount);
        return true;
      },
      failureLog: 'Saving the budget during onboarding failed',
    );
    if (!mounted) return;
    setState(() => _saving = false);
    if (saved ?? false) await const GmailSetupRoute().push<void>(context);
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final amount = int.tryParse(_amount.text);
    final current = ref.read(budgetUseCaseProvider).currentMonth;
    return OnboardingScaffold(
      step: 0,
      onBack: context.pop,
      actions: [
        FilledButton(
          key: AppKeys.onboardingBudgetSave,
          onPressed: amount == null || _saving ? null : _save,
          child: Text(
            amount == null
                ? t.expense.enterAmount
                : t.onboarding.budgetCta(
                    month: KakinFormats.yearMonth(
                      _startMonth.year,
                      _startMonth.month,
                    ),
                    amount: KakinFormats.yen(amount),
                  ),
          ),
        ),
        TextButton(
          key: AppKeys.onboardingBudgetSkip,
          onPressed: _saving
              ? null
              : () => const GmailSetupRoute().push<void>(context),
          child: Text(t.common.skip),
        ),
        OnboardingNote(t.onboarding.budgetLater),
      ],
      children: [
        OnboardingHeading(
          eyebrow: t.onboarding.budgetStep,
          title: t.onboarding.budgetTitle,
          body: t.onboarding.budgetBody,
        ),
        SurfaceCard(
          radius: AppRadius.xl,
          padding: const EdgeInsets.all(AppSpacing.ml),
          child: BudgetForm(
            amountController: _amount,
            startMonth: _startMonth,
            monthOptions: startMonthOptions(current),
            onStartMonthChanged: (month) => setState(() => _startMonth = month),
            onAmountChanged: () => setState(() {}),
          ),
        ),
      ],
    );
  }
}
