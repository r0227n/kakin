import 'package:app/core/formatting/kakin_formats.dart';
import 'package:app/core/gen/slang.g.dart';
import 'package:app/domain/domain.dart';
import 'package:app/presentation/dependencies/application_providers.dart';
import 'package:app/presentation/features/settings/widgets/settings_group.dart';
import 'package:app/presentation/shared/controllers/local_data.dart';
import 'package:app/presentation/shared/feedback/action_feedback.dart';
import 'package:app/presentation/shared/keys/app_keys.dart';
import 'package:app/presentation/shared/widgets/budget_form.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 推し活代の月額・開始月・月ごとの上書き。
class BudgetSettings extends ConsumerWidget {
  /// 編集はボトムシートで行う。
  const BudgetSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final plan = ref.watch(budgetPlanProvider).value;
    final current = ref.read(budgetUseCaseProvider).currentMonth;
    final start = plan?.startMonth;
    final overrides = plan == null
        ? const <MapEntry<YearMonth, int>>[]
        : (plan.overrides.entries.toList()
            ..sort((a, b) => a.key.compareTo(b.key)));
    void edit() => showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _BudgetSheet(plan: plan, current: current),
    );
    return SettingsGroup(
      title: t.settings.budget,
      children: [
        if (plan == null || !plan.isConfigured)
          SettingsTile(
            key: AppKeys.settingsBudgetSet,
            label: t.settings.setBudget,
            value: t.settings.budgetUnset,
            onTap: edit,
            showDivider: false,
          )
        else ...[
          SettingsTile(
            key: AppKeys.settingsBudgetMonthly,
            label: t.settings.monthly,
            value: KakinFormats.yen(
              // 開始月が先の月なら、今月ではなく開始月の月額を出す。
              plan.monthlyRateAt(current.isBefore(start!) ? start : current)!,
            ),
            onTap: edit,
          ),
          SettingsTile(
            key: AppKeys.settingsBudgetStart,
            label: t.settings.startMonth,
            value: KakinFormats.yearMonth(start.year, start.month),
            onTap: edit,
          ),
          SettingsTile(
            key: AppKeys.settingsBudgetOverrides,
            label: t.settings.overrides,
            subtitle: overrides.isEmpty
                ? null
                : overrides
                      .map(
                        (e) => t.settings.overrideItem(
                          month: KakinFormats.monthName(e.key.month),
                          amount: KakinFormats.yen(e.value),
                        ),
                      )
                      .join(' · '),
            value: t.settings.overrideCount(count: overrides.length),
            onTap: () => showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              showDragHandle: true,
              builder: (_) => _OverridesSheet(start: start, current: current),
            ),
            showDivider: false,
          ),
        ],
      ],
    );
  }
}

class _SheetFrame extends StatelessWidget {
  const _SheetFrame({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(
      bottom: MediaQuery.viewInsetsOf(context).bottom,
    ),
    child: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.ml,
          0,
          AppSpacing.ml,
          AppSpacing.ml,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.m,
          children: [
            Semantics(
              header: true,
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            ...children,
          ],
        ),
      ),
    ),
  );
}

class _BudgetSheet extends ConsumerStatefulWidget {
  const _BudgetSheet({required this.plan, required this.current});

  final BudgetPlan? plan;
  final YearMonth current;

  @override
  ConsumerState<_BudgetSheet> createState() => _BudgetSheetState();
}

class _BudgetSheetState extends ConsumerState<_BudgetSheet> {
  late YearMonth _start = widget.plan?.startMonth ?? widget.current;
  late final _amount = TextEditingController(text: '${_initialAmount()}');
  bool _saving = false;

  /// 開始月が先の月なら、今月ではなく開始月の月額を初期値にする。
  int _initialAmount() {
    final current = widget.current;
    final month = current.isBefore(_start) ? _start : current;
    return widget.plan?.monthlyRateAt(month) ?? 30000;
  }

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final amount = int.tryParse(_amount.text);
    if (amount == null) return;
    setState(() => _saving = true);
    final t = Translations.of(context);
    final saved = await runWithFeedback(
      context,
      ref,
      () async {
        await ref
            .read(budgetUseCaseProvider)
            .configure(startMonth: _start, monthlyYen: amount);
        return true;
      },
      failureLog: 'Saving the budget failed',
      successMessage: t.settings.budgetSaved,
    );
    if (!mounted) return;
    setState(() => _saving = false);
    if (saved ?? false) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    return _SheetFrame(
      title: t.settings.budget,
      children: [
        BudgetForm(
          amountController: _amount,
          startMonth: _start,
          monthOptions: startMonthOptions(widget.current, include: _start),
          onStartMonthChanged: (month) => setState(() => _start = month),
          onAmountChanged: () => setState(() {}),
        ),
        FilledButton(
          key: AppKeys.budgetSheetSave,
          onPressed: int.tryParse(_amount.text) == null || _saving
              ? null
              : _save,
          child: Text(t.common.save),
        ),
      ],
    );
  }
}

class _OverridesSheet extends ConsumerStatefulWidget {
  const _OverridesSheet({required this.start, required this.current});

  final YearMonth start;
  final YearMonth current;

  @override
  ConsumerState<_OverridesSheet> createState() => _OverridesSheetState();
}

class _OverridesSheetState extends ConsumerState<_OverridesSheet> {
  final _amount = TextEditingController();
  late YearMonth _month = widget.current.isBefore(widget.start)
      ? widget.start
      : widget.current;
  bool _saving = false;

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    final amount = int.tryParse(_amount.text);
    if (amount == null) return;
    final t = Translations.of(context);
    final month = _month;
    final saved = await _guard(
      () => ref.read(budgetUseCaseProvider).setOverride(month, amount),
      failureLog: 'Saving a budget override failed',
      successMessage: t.settings.overrideSaved,
    );
    // 失敗したときは入力を残して、直してやり直せるようにする。
    if (mounted && saved) setState(_amount.clear);
  }

  /// 保存と解除の重なりを防ぐ。成功したら true。
  Future<bool> _guard(
    Future<void> Function() action, {
    required String failureLog,
    String? successMessage,
  }) async {
    if (_saving) return false;
    setState(() => _saving = true);
    final done = await runWithFeedback(
      context,
      ref,
      () async {
        await action();
        return true;
      },
      failureLog: failureLog,
      successMessage: successMessage,
    );
    if (mounted) setState(() => _saving = false);
    return done ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final palette = context.palette;
    final plan = ref.watch(budgetPlanProvider).value;
    final overrides = plan == null
        ? const <MapEntry<YearMonth, int>>[]
        : (plan.overrides.entries.toList()
            ..sort((a, b) => a.key.compareTo(b.key)));
    // 開始月から、今月（開始月が先なら開始月）の1年先までを選べる。
    final lastMonth = widget.current.isBefore(widget.start)
        ? widget.start
        : widget.current;
    final months = [
      for (
        var m = widget.start, i = 0;
        i < 12 || !m.isAfter(lastMonth);
        m = m.next, i++
      )
        m,
    ];
    return _SheetFrame(
      title: t.settings.overrides,
      children: [
        if (overrides.isEmpty)
          Text(
            t.settings.noOverrides,
            style: TextStyle(fontSize: 13, color: palette.textSecondary),
          ),
        for (final entry in overrides)
          Row(
            children: [
              Expanded(
                child: Text(
                  KakinFormats.yearMonth(entry.key.year, entry.key.month),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              Text(
                KakinFormats.yen(entry.value),
                style: AppTypography.numeric(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              IconButton(
                tooltip: t.settings.removeOverride,
                onPressed: _saving
                    ? null
                    : () => _guard(
                        () => ref
                            .read(budgetUseCaseProvider)
                            .clearOverride(entry.key),
                        failureLog: 'Removing a budget override failed',
                      ),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
        const Divider(),
        Text(
          t.settings.addOverride,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
        DropdownButtonFormField<YearMonth>(
          initialValue: _month,
          isExpanded: true,
          decoration: InputDecoration(labelText: t.settings.overrideMonth),
          items: [
            for (final month in months)
              DropdownMenuItem(
                value: month,
                child: Text(KakinFormats.yearMonth(month.year, month.month)),
              ),
          ],
          onChanged: (month) {
            if (month != null) setState(() => _month = month);
          },
        ),
        TextField(
          key: AppKeys.overrideAmount,
          controller: _amount,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(7),
          ],
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            labelText: t.settings.overrideAmount,
            prefixText: '¥ ',
          ),
        ),
        FilledButton(
          key: AppKeys.overrideSave,
          onPressed: int.tryParse(_amount.text) == null || _saving
              ? null
              : _add,
          child: Text(t.settings.addOverride),
        ),
      ],
    );
  }
}
