import 'package:app/application/models/records.dart';
import 'package:app/domain/domain.dart';

/// カレンダーとリストが表示する、1ヶ月分の支出と概要。
final class MonthOverview {
  /// 計上基準で置いた支出と、支払日で計算した残高を持つ。
  const MonthOverview({
    required this.month,
    required this.basis,
    required this.expenses,
    required this.performances,
    required this.duplicateExpenseIds,
    this.ledger,
  });

  /// 対象の月。
  final YearMonth month;

  /// 支出を置いた計上基準。
  final AccountingBasis basis;

  /// この月に置いた支出。日付の新しい順。
  final List<Expense> expenses;

  /// この月に開始する公演。開始日時の早い順。
  final List<Performance> performances;

  /// 二重計上の可能性がある支出。
  final Set<int> duplicateExpenseIds;

  /// 支払日で計算した推し活代・繰越・残高。推し活代が未設定なら null。
  final LedgerMonth? ledger;

  /// 計上基準で集計した支出合計。
  int get spendTotalYen => expenses.fold(0, (sum, e) => sum + e.amountYen);

  /// 計上基準で集計したカテゴリ別の支出。
  Map<ExpenseCategory, int> get spendByCategory {
    final totals = {for (final c in ExpenseCategory.values) c: 0};
    for (final expense in expenses) {
      totals[expense.category] = totals[expense.category]! + expense.amountYen;
    }
    return totals;
  }

  /// [day] に置いた支出。
  List<Expense> expensesOn(LocalDate day) =>
      expenses.where((e) => e.placedOn(basis) == day).toList();

  /// [day] に開始する公演。
  List<Performance> performancesOn(LocalDate day) =>
      performances.where((p) => p.startsOn == day).toList();
}

/// 今後の公演の1行。
final class UpcomingPerformance {
  /// 公演と、公演日までの日数を持つ。
  const UpcomingPerformance({
    required this.performance,
    required this.daysUntil,
  });

  /// 公演。
  final Performance performance;

  /// 今日から公演日までの日数。今日なら 0。
  final int daysUntil;
}
