import 'package:app/application/application.dart';
import 'package:app/core/formatting/kakin_formats.dart';
import 'package:app/core/gen/slang.g.dart';
import 'package:app/domain/domain.dart';
import 'package:app/presentation/features/expense_list/widgets/category_filter_bar.dart';
import 'package:app/presentation/features/expense_list/widgets/compact_summary.dart';
import 'package:app/presentation/features/expense_list/widgets/list_expense_row.dart';
import 'package:app/presentation/navigation/routes.dart';
import 'package:app/presentation/shared/controllers/app_preferences_controller.dart';
import 'package:app/presentation/shared/controllers/ledger_view_controller.dart';
import 'package:app/presentation/shared/controllers/local_data.dart';
import 'package:app/presentation/shared/keys/app_keys.dart';
import 'package:app/presentation/shared/widgets/common_widgets.dart';
import 'package:app/presentation/shared/widgets/month_summary.dart';
import 'package:app/presentation/shared/widgets/visuals.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 月の支出を日付ごとに並べ、カテゴリで絞り込むリスト。
class ExpenseListScreen extends ConsumerStatefulWidget {
  /// 絞り込みは画面が持ち、月と計上基準はカレンダーと共有する。
  const ExpenseListScreen({super.key});

  @override
  ConsumerState<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends ConsumerState<ExpenseListScreen> {
  ExpenseCategory? _filter;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final palette = context.palette;
    final view = ref.watch(ledgerViewControllerProvider);
    final overview = ref.watch(monthOverviewProvider(view.month, view.basis));
    final hidden = !ref.watch(
      appPreferencesControllerProvider.select((p) => p.amountsVisible),
    );
    final value = overview.value;
    final groups = value == null ? const <_DayGroup>[] : _group(value);
    return Scaffold(
      appBar: const MonthAppBar(),
      floatingActionButton: FloatingActionButton(
        key: AppKeys.addExpense,
        // タブを切り替えても残る2つの画面の FAB が Hero で衝突しないようにする。
        heroTag: null,
        tooltip: t.calendar.addExpense,
        onPressed: () => NewExpenseRoute(category: _filter).push<void>(context),
        child: const Icon(Icons.add, size: 28),
      ),
      body: CustomScrollView(
        key: AppKeys.expenseListScroll,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.m,
              AppSpacing.s,
              AppSpacing.m,
              0,
            ),
            sliver: SliverList.list(
              children: [
                const BasisToggle(),
                const SizedBox(height: AppSpacing.s + 2),
                if (value != null)
                  CompactSummary(overview: value, hidden: hidden),
                const SizedBox(height: AppSpacing.s + 2),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: CategoryFilterBar(
              selected: _filter,
              totals: value?.spendByCategory ?? const {},
              hidden: hidden,
              onSelected: (category) => setState(() => _filter = category),
            ),
          ),
          if (overview.hasError && value == null)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: Text(t.errors.recordStorage)),
            )
          else if (value == null)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: CircularProgressIndicator()),
            )
          else if (groups.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.only(top: AppSpacing.l),
                child: Text(
                  _filter == null ? t.list.emptyMonth : t.list.emptyCategory,
                  key: AppKeys.expenseListEmpty,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: palette.textSecondary,
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.m,
                AppSpacing.s,
                AppSpacing.m,
                96,
              ),
              sliver: SliverList.separated(
                itemCount: groups.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppSpacing.sm + 2),
                itemBuilder: (context, index) => _DaySection(
                  group: groups[index],
                  overview: value,
                  hidden: hidden,
                ),
              ),
            ),
        ],
      ),
    );
  }

  List<_DayGroup> _group(MonthOverview overview) {
    final byDay = <LocalDate, List<Expense>>{};
    for (final expense in overview.expenses) {
      if (_filter != null && expense.category != _filter) continue;
      byDay
          .putIfAbsent(expense.placedOn(overview.basis), () => [])
          .add(expense);
    }
    final days = byDay.keys.toList()..sort((a, b) => b.compareTo(a));
    return [for (final day in days) _DayGroup(day, byDay[day]!)];
  }
}

class _DayGroup {
  const _DayGroup(this.day, this.expenses);

  final LocalDate day;
  final List<Expense> expenses;
}

class _DaySection extends StatelessWidget {
  const _DaySection({
    required this.group,
    required this.overview,
    required this.hidden,
  });

  final _DayGroup group;
  final MonthOverview overview;
  final bool hidden;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final total = group.expenses.fold(0, (sum, e) => sum + e.amountYen);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 6,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(
                child: Semantics(
                  header: true,
                  child: Text(
                    KakinFormats.monthDay(group.day.asDateTime),
                    style: AppTypography.numeric(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: palette.textTertiary,
                    ),
                  ),
                ),
              ),
              Text(
                KakinFormats.yen(total, hidden: hidden),
                style: AppTypography.numeric(
                  fontSize: 12,
                  color: palette.textSecondary,
                ),
              ),
            ],
          ),
        ),
        SurfaceCard(
          padding: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm + 2),
            child: Column(
              children: [
                for (final (index, expense) in group.expenses.indexed)
                  ListExpenseRow(
                    expense: expense,
                    basis: overview.basis,
                    isDuplicate: overview.duplicateExpenseIds.contains(
                      expense.id,
                    ),
                    hidden: hidden,
                    showDivider: index < group.expenses.length - 1,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
