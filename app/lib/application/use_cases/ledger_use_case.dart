import 'package:app/application/models/views.dart';
import 'package:app/application/ports/record_repositories.dart';
import 'package:app/domain/domain.dart';

/// カレンダーとリストが表示する月の概要の入力境界。
final class LedgerUseCase {
  /// 推し活代・支出・公演の保存先を注入する。
  const LedgerUseCase(this._budgets, this._expenses, this._performances);

  final BudgetRepository _budgets;
  final ExpenseRepository _expenses;
  final PerformanceRepository _performances;

  /// [month] の支出を [basis] で置き、残高は支払日で計算する。
  Future<MonthOverview> loadMonth(
    YearMonth month,
    AccountingBasis basis,
  ) async {
    final from = month.firstDay;
    final until = month.next.firstDay;
    final (plan, spend, touching, performances) = await (
      _budgets.loadPlan(),
      _expenses.monthlySpendByPaidOn(),
      _expenses.listTouching(from, until),
      _performances.listStartingBetween(from, until),
    ).wait;
    final placed =
        touching.where((e) => month.contains(e.placedOn(basis))).toList()
          ..sort((a, b) {
            final byDay = b.placedOn(basis).compareTo(a.placedOn(basis));
            return byDay != 0 ? byDay : b.id.compareTo(a.id);
          });
    return MonthOverview(
      month: month,
      basis: basis,
      expenses: placed,
      performances: performances,
      duplicateExpenseIds: duplicateExpenseIds(touching.map((e) => e.facts)),
      isBudgetConfigured: plan.isConfigured,
      ledger: ledgerFor(plan: plan, spendByMonth: spend, month: month),
    );
  }
}
