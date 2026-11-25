import 'dart:async';

import 'package:app/application/application.dart';
import 'package:app/core/formatting/kakin_formats.dart';
import 'package:app/core/gen/slang.g.dart';
import 'package:app/domain/domain.dart';
import 'package:app/presentation/dependencies/application_providers.dart';
import 'package:app/presentation/features/expense_editor/widgets/amount_field.dart';
import 'package:app/presentation/features/expense_editor/widgets/amount_keypad.dart';
import 'package:app/presentation/features/expense_editor/widgets/category_grid.dart';
import 'package:app/presentation/features/expense_editor/widgets/cheki_partner_rows.dart';
import 'package:app/presentation/features/expense_editor/widgets/editor_header.dart';
import 'package:app/presentation/features/expense_editor/widgets/performance_picker_sheet.dart';
import 'package:app/presentation/navigation/routes.dart';
import 'package:app/presentation/shared/controllers/local_data.dart';
import 'package:app/presentation/shared/feedback/action_feedback.dart';
import 'package:app/presentation/shared/keys/app_keys.dart';
import 'package:app/presentation/shared/widgets/visuals.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 支出の追加と編集。チェキ代は相手ごとに1件ずつ記録する。
class ExpenseEditorScreen extends ConsumerStatefulWidget {
  /// [expenseId] があれば編集、なければ追加。
  const ExpenseEditorScreen({
    this.expenseId,
    this.initialCategory,
    this.initialPerformanceId,
    this.initialDate,
    super.key,
  });

  /// 編集する支出。
  final int? expenseId;

  /// 追加のときに最初に選ぶカテゴリ。
  final ExpenseCategory? initialCategory;

  /// 追加のときに最初に選ぶ公演。
  final int? initialPerformanceId;

  /// 追加のときの支払日。
  final LocalDate? initialDate;

  @override
  ConsumerState<ExpenseEditorScreen> createState() =>
      _ExpenseEditorScreenState();
}

/// 支出ごとのよく使う金額。
const Map<ExpenseCategory, List<int>> _quickAmounts = {
  ExpenseCategory.drink: [500, 600, 700, 1000],
  ExpenseCategory.cheki: [1000, 1500, 2000, 3000],
  ExpenseCategory.goods: [1000, 3000, 5000],
  ExpenseCategory.locker: [300, 400, 500, 700],
};

class _ExpenseEditorScreenState extends ConsumerState<ExpenseEditorScreen> {
  static const _maxDigits = 7;

  late ExpenseCategory _category =
      widget.initialCategory ?? ExpenseCategory.drink;
  late LocalDate _paidOn =
      widget.initialDate ?? JapanTime.dateOf(ref.read(clockProvider).now());
  int? _performanceId;
  bool _performanceTouched = false;
  String _digits = '';
  bool _drinkPrefilled = false;
  final _chekiCounts = <int, int>{};
  final _note = TextEditingController();
  final _amountFocus = FocusNode(debugLabel: 'amount');
  Expense? _editing;
  bool _loading = false;
  bool _saving = false;

  bool get _isEditing => widget.expenseId != null;

  int? get _amount => _digits.isEmpty ? null : int.parse(_digits);

  /// チェキ代の追加では入力欄が単価になる。編集では支出の金額そのものを直す。
  bool get _entersUnitPrice =>
      _category == ExpenseCategory.cheki && !_isEditing;

  /// 選んでいる公演。自分で選ぶまでは、支払日に公演があればその公演にする。
  int? get _selectedPerformanceId {
    if (_performanceTouched || _isEditing) return _performanceId;
    final performances = ref.read(performancesProvider).value ?? const [];
    return performances.where((p) => p.startsOn == _paidOn).firstOrNull?.id;
  }

  /// 選んだチェキ相手のうち、登録が残っている相手と枚数。
  List<ChekiEntry> get _chekiEntries {
    final partners = ref.read(partnersProvider).value ?? const [];
    final partnerUseCase = ref.read(partnerUseCaseProvider);
    return [
      for (final MapEntry(key: id, value: count) in _chekiCounts.entries)
        if (partners.where((p) => p.id == id).firstOrNull case final partner?)
          (
            partner: partner,
            iconPath: partnerUseCase.iconPathOf(partner),
            count: count,
          ),
    ];
  }

  @override
  void initState() {
    super.initState();
    _performanceId = widget.initialPerformanceId;
    _performanceTouched = widget.initialPerformanceId != null;
    if (_isEditing) {
      _loading = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadExpense());
    } else if (_category == ExpenseCategory.drink) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _prefillDrink());
    }
  }

  @override
  void dispose() {
    _note.dispose();
    _amountFocus.dispose();
    super.dispose();
  }

  Future<void> _loadExpense() async {
    final expense = await runWithFeedback(
      context,
      ref,
      () => ref.read(expenseUseCaseProvider).find(widget.expenseId!),
      failureLog: 'Loading an expense failed',
    );
    if (!mounted) return;
    if (expense == null) {
      context.pop();
      return;
    }
    setState(() {
      _editing = expense;
      _loading = false;
      _category = expense.category;
      _paidOn = expense.paidOn;
      _performanceId = expense.performance?.id;
      _performanceTouched = true;
      _digits = '${expense.amountYen}';
      if (expense.partner case final partner?) {
        _chekiCounts[partner.id] = expense.shotCount ?? 1;
      }
      _note.text = expense.note ?? '';
    });
  }

  Future<void> _prefillDrink() async {
    if (_digits.isNotEmpty) return;
    final latest = await runWithFeedback(
      context,
      ref,
      () => ref.read(expenseUseCaseProvider).latestDrinkAmount(),
      failureLog: 'Loading the latest drink amount failed',
    );
    if (!mounted || latest == null || _digits.isNotEmpty) return;
    if (_category != ExpenseCategory.drink) return;
    setState(() {
      _digits = '$latest';
      _drinkPrefilled = true;
    });
  }

  void _selectCategory(ExpenseCategory category) {
    if (category == _category) return;
    setState(() {
      _category = category;
      _drinkPrefilled = false;
      if (!_isEditing) _digits = '';
    });
    if (category == ExpenseCategory.drink && !_isEditing) {
      unawaited(_prefillDrink());
    }
  }

  void _appendDigits(String digits) {
    _amountFocus.requestFocus();
    // 0円も記録できるよう、先頭の 0 は後ろに数字が続くときだけ除く。
    final next = (_digits + digits).replaceFirst(RegExp(r'^0+(?=\d)'), '');
    if (next.length > _maxDigits) return;
    setState(() {
      _digits = next;
      _drinkPrefilled = false;
    });
  }

  void _backspace() {
    _amountFocus.requestFocus();
    if (_digits.isEmpty) return;
    setState(() {
      _digits = _digits.substring(0, _digits.length - 1);
      _drinkPrefilled = false;
    });
  }

  Future<void> _pickPerformance() async {
    final choice = await PerformancePickerSheet.show(
      context,
      selectedId: _selectedPerformanceId,
      allowNone: !_category.requiresPerformance,
    );
    if (choice == null || !mounted) return;
    setState(() {
      _performanceId = choice.performanceId;
      _performanceTouched = true;
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _paidOn.asDateTime,
      firstDate: DateTime.utc(2000),
      lastDate: DateTime.utc(2100),
    );
    if (picked == null || !mounted) return;
    setState(() => _paidOn = LocalDate(picked.year, picked.month, picked.day));
  }

  Future<void> _pickPartners() async {
    final selected = await PartnerPickerRoute(
      selected: _chekiCounts.keys.toList(),
    ).push<List<int>>(context);
    if (selected == null || !mounted) return;
    setState(() {
      // 編集する支出の相手は1人。最後に選んだ相手に置き換える。
      final ids = _isEditing && selected.isNotEmpty
          ? [selected.last]
          : selected;
      _chekiCounts.removeWhere((id, _) => !ids.contains(id));
      for (final id in ids) {
        _chekiCounts.putIfAbsent(id, () => 1);
      }
    });
  }

  void _setCount(int partnerId, int count) => setState(() {
    if (count <= 0) {
      _chekiCounts.remove(partnerId);
    } else {
      _chekiCounts[partnerId] = count;
    }
  });

  List<ExpenseDraft> _drafts() {
    final amount = _amount!;
    final note = _note.text.trim();
    if (_category == ExpenseCategory.cheki) {
      return [
        for (final entry in _chekiEntries)
          ExpenseDraft(
            category: _category,
            amountYen: _entersUnitPrice ? amount * entry.count : amount,
            paidOn: _paidOn,
            performanceId: _selectedPerformanceId,
            partnerId: entry.partner.id,
            shotCount: entry.count,
            note: note,
          ),
      ];
    }
    return [
      ExpenseDraft(
        category: _category,
        amountYen: amount,
        paidOn: _paidOn,
        performanceId: _selectedPerformanceId,
        note: note,
      ),
    ];
  }

  Future<void> _save({required bool continueAfter}) async {
    if (_saving) return;
    setState(() => _saving = true);
    final t = Translations.of(context);
    final useCase = ref.read(expenseUseCaseProvider);
    final drafts = _drafts();
    final saved = await runWithFeedback(
      context,
      ref,
      () async {
        if (_isEditing) {
          await useCase.update(widget.expenseId!, drafts.single);
        } else {
          await useCase.record(drafts);
        }
        return true;
      },
      failureLog: 'Saving an expense failed',
      successMessage: t.expense.recorded,
    );
    if (!mounted) return;
    setState(() => _saving = false);
    if (!(saved ?? false)) return;
    if (!continueAfter) {
      context.pop();
      return;
    }
    setState(() {
      _digits = '';
      _chekiCounts.clear();
      _note.clear();
      _drinkPrefilled = false;
    });
    if (_category == ExpenseCategory.drink) unawaited(_prefillDrink());
  }

  Future<void> _delete() async {
    final t = Translations.of(context);
    final confirmed = await confirmDestructive(
      context,
      title: t.common.deleteConfirmTitle,
      body: t.common.deleteConfirmBody,
    );
    if (!confirmed || !mounted || _saving) return;
    setState(() => _saving = true);
    final deleted = await runWithFeedback(
      context,
      ref,
      () async {
        await ref.read(expenseUseCaseProvider).delete(widget.expenseId!);
        return true;
      },
      failureLog: 'Deleting an expense failed',
    );
    if (!mounted) return;
    setState(() => _saving = false);
    if (deleted ?? false) context.pop();
  }

  /// 保存できないときの CTA の文言。保存できるなら null。
  String? _blocker(Translations t) {
    if (_category.requiresPerformance && _selectedPerformanceId == null) {
      return t.expense.selectPerformanceCta;
    }
    if (_category == ExpenseCategory.cheki && _chekiEntries.isEmpty) {
      return t.expense.selectPartnerCta;
    }
    if (_amount == null) return t.expense.enterAmount;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final palette = context.palette;
    final performances = ref.watch(performancesProvider).value ?? const [];
    final selectedPerformanceId = _selectedPerformanceId;
    final performance = performances
        .where((p) => p.id == selectedPerformanceId)
        .firstOrNull;
    ref.watch(partnersProvider);
    final entries = _chekiEntries;
    final isCheki = _category == ExpenseCategory.cheki;
    final entersUnitPrice = _entersUnitPrice;
    final amount = _amount ?? 0;
    final shots = entries.fold(0, (total, entry) => total + entry.count);
    final blocker = _blocker(t);
    final cta =
        blocker ??
        (_isEditing
            ? t.common.save
            : isCheki
            ? t.expense.recordCheki(
                count: entries.length,
                amount: KakinFormats.yen(amount * shots),
              )
            : t.expense.recordAmount(amount: KakinFormats.yen(amount)));
    final hint = entersUnitPrice
        ? t.expense.chekiTotal(amount: KakinFormats.yen(amount * shots))
        : (_drinkPrefilled ? t.expense.drinkPrefilled : null);
    final amountLabel = entersUnitPrice
        ? t.expense.unitPrice
        : t.expense.amount;
    final canSave = blocker == null && !_saving && !_loading;

    final header = EditorHeader(
      performanceLabel: _category.requiresPerformance
          ? t.expense.performance
          : t.performance.pickOptional,
      performanceName:
          performance?.title ??
          (_category.requiresPerformance
              ? t.performance.pick
              : t.performance.none),
      performanceMissing: _category.requiresPerformance && performance == null,
      dateText: _paidOn == JapanTime.dateOf(ref.read(clockProvider).now())
          ? t.expense.today(date: KakinFormats.monthDay(_paidOn.asDateTime))
          : KakinFormats.monthDay(_paidOn.asDateTime),
      onPickPerformance: _pickPerformance,
      onPickDate: _pickDate,
    );
    final section = DecoratedBox(
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.m,
          AppSpacing.sm + 2,
          AppSpacing.m,
          AppSpacing.sm + 2,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.s + 2,
          children: [
            if (isCheki)
              ChekiPartnerRows(
                entries: entries,
                amountFor: (count) => entersUnitPrice ? amount * count : amount,
                onPick: _pickPartners,
                onCountChanged: _setCount,
              ),
            Text(
              amountLabel,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: palette.textSecondary,
              ),
            ),
            AmountField(
              text: KakinFormats.yen(amount),
              isEmpty: _amount == null,
              fontSize: isCheki ? 30 : 44,
              label: amountLabel,
              focusNode: _amountFocus,
              onDigits: _appendDigits,
              onBackspace: _backspace,
            ),
            if (hint != null)
              Text(
                hint,
                style: TextStyle(fontSize: 12, color: palette.textSecondary),
              ),
            if (_quickAmounts[_category] case final presets?)
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final preset in presets)
                    ActionChip(
                      key: AppKeys.quickAmount(preset),
                      label: Text(KakinFormats.yen(preset)),
                      labelStyle: AppTypography.numeric(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                      onPressed: () {
                        _amountFocus.requestFocus();
                        setState(() {
                          _digits = '$preset';
                          _drinkPrefilled = false;
                        });
                      },
                    ),
                ],
              ),
            TextField(
              key: AppKeys.expenseNote,
              controller: _note,
              maxLength: 200,
              decoration: InputDecoration(
                labelText: t.expense.noteOptional,
                counterText: '',
                isDense: true,
              ),
            ),
            if (_editing?.isImported ?? false)
              Text(
                t.expense.importedNote,
                style: TextStyle(fontSize: 12, color: palette.accentStrong),
              ),
          ],
        ),
      ),
    );
    final keypad = AmountKeypad(
      onDigits: _appendDigits,
      onBackspace: _backspace,
    );
    final continueButton = OutlinedButton(
      key: AppKeys.expenseSaveContinue,
      onPressed: canSave ? () => _save(continueAfter: true) : null,
      child: Text(t.expense.recordAndContinue),
    );
    final saveButton = FilledButton(
      key: AppKeys.expenseSave,
      onPressed: canSave ? () => _save(continueAfter: false) : null,
      child: FittedBox(fit: BoxFit.scaleDown, child: Text(cta)),
    );
    final actions = LayoutBuilder(
      builder: (context, constraints) {
        final narrow =
            constraints.maxWidth / MediaQuery.textScalerOf(context).scale(1) <
            320;
        if (_isEditing) return saveButton;
        if (narrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.s,
            children: [saveButton, continueButton],
          );
        }
        return Row(
          spacing: AppSpacing.s,
          children: [
            continueButton,
            Expanded(child: saveButton),
          ],
        );
      },
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? t.expense.editTitle : t.expense.addTitle),
        actions: [
          if (_isEditing)
            IconButton(
              key: AppKeys.expenseDelete,
              tooltip: t.expense.delete,
              onPressed: _saving ? null : _delete,
              icon: const Icon(Icons.delete_outline),
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              top: false,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  const gutter = EdgeInsets.symmetric(horizontal: AppSpacing.m);
                  final top = [
                    Padding(padding: gutter, child: header),
                    const SizedBox(height: AppSpacing.s + 2),
                    Padding(
                      padding: gutter,
                      child: CategoryGrid(
                        selected: _category,
                        onSelected: _selectCategory,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                  ];
                  final bottom = [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.m,
                        AppSpacing.s + 2,
                        AppSpacing.m,
                        AppSpacing.s,
                      ),
                      child: keypad,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.m,
                        AppSpacing.xs,
                        AppSpacing.m,
                        AppSpacing.m,
                      ),
                      child: actions,
                    ),
                  ];
                  // 狭い画面や文字の拡大では、記録のボタンだけを残して
                  // ほかをまとめてスクロールする。
                  final compact =
                      constraints.maxHeight < 640 ||
                      MediaQuery.textScalerOf(context).scale(1) > 1.3;
                  if (compact) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ListView(
                            key: AppKeys.expenseEditorScroll,
                            children: [
                              ...top,
                              Padding(padding: gutter, child: section),
                              bottom.first,
                            ],
                          ),
                        ),
                        bottom.last,
                      ],
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ...top,
                      Expanded(
                        child: Padding(
                          padding: gutter,
                          child: SingleChildScrollView(
                            key: AppKeys.expenseEditorScroll,
                            child: section,
                          ),
                        ),
                      ),
                      ...bottom,
                    ],
                  );
                },
              ),
            ),
    );
  }
}
