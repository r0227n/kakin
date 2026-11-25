import 'package:app/domain/budget/budget_plan.dart';
import 'package:app/domain/calendar/local_date.dart';

/// ある月の推し活代・繰越・支出・残高。
final class LedgerMonth {
  /// 計算済みの値を保持する。
  const LedgerMonth({
    required this.month,
    required this.carryoverYen,
    required this.budgetYen,
    required this.spendYen,
  });

  /// 対象の月。
  final YearMonth month;

  /// 前月の残高。開始月は 0。
  final int carryoverYen;

  /// その月の推し活代。
  final int budgetYen;

  /// 支払日で計上したその月の支出合計。
  final int spendYen;

  /// 残高 = 繰越 + 推し活代 − 支出。
  int get balanceYen => carryoverYen + budgetYen - spendYen;
}

/// [plan] と支払日の月ごとの支出合計から、[month] の残高を求める。
///
/// 推し活代が未設定、または [month] が開始月より前なら null。
/// 開始月より前の支出は [spendByMonth] にあっても含めない。
LedgerMonth? ledgerFor({
  required BudgetPlan plan,
  required Map<YearMonth, int> spendByMonth,
  required YearMonth month,
}) {
  final start = plan.startMonth;
  if (start == null || month.isBefore(start)) return null;
  var carryover = 0;
  for (var current = start; ; current = current.next) {
    final entry = LedgerMonth(
      month: current,
      carryoverYen: carryover,
      budgetYen: plan.budgetFor(current)!,
      spendYen: spendByMonth[current] ?? 0,
    );
    if (current == month) return entry;
    carryover = entry.balanceYen;
  }
}
