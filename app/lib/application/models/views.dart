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
  /// 公演と、そのチケット申込の段階を持つ。
  const UpcomingPerformance({
    required this.performance,
    required this.stages,
    required this.daysUntil,
  });

  /// 公演。
  final Performance performance;

  /// チケット申込の段階。登録の新しい順。
  final List<TicketApplicationStage> stages;

  /// 今日から公演日までの日数。今日なら 0。
  final int daysUntil;
}

/// やることの1件。リマインドの対象になる期限。
final class TodoItem {
  /// 期限とワンタップの操作を持つ。
  const TodoItem({
    required this.application,
    required this.kind,
    required this.dueAt,
    required this.isOverdue,
  });

  /// 対象のチケット申込。
  final TicketApplication application;

  /// 期限の種類。
  final TicketDeadlineKind kind;

  /// 期限（UTC）。
  final DateTime dueAt;

  /// 期限を過ぎても段階が変わっていないか。
  final bool isOverdue;

  /// ワンタップで進める操作。
  List<QuickStageAction> get actions => kind.quickActions;
}

/// 今後の公演の画面に表示するもの。金額は持たない。
final class UpcomingOverview {
  /// やることと公演の一覧。
  const UpcomingOverview({required this.todos, required this.performances});

  /// 期限の近い順のやること。
  final List<TodoItem> todos;

  /// 開始日時の早い順の公演。
  final List<UpcomingPerformance> performances;
}

/// ワンタップで段階を進めた結果。元に戻すときに使う。
final class StageChange {
  /// 変更前後の段階を持つ。
  const StageChange({
    required this.applicationId,
    required this.performanceTitle,
    required this.from,
    required this.to,
  });

  /// 対象のチケット申込。
  final int applicationId;

  /// 公演名。
  final String performanceTitle;

  /// 変更前の段階。
  final TicketApplicationStage from;

  /// 変更後の段階。
  final TicketApplicationStage to;
}
