import 'package:app/domain/calendar/local_date.dart';
import 'package:app/domain/expense/expense_category.dart';

/// 二重計上の判定に使う支出の事実。
final class ExpenseFacts {
  /// 判定に必要な項目だけを持つ。
  const ExpenseFacts({
    required this.id,
    required this.category,
    required this.paidOn,
    required this.performanceId,
  });

  /// 支出の ID。
  final int id;

  /// カテゴリ。
  final ExpenseCategory category;

  /// 支払日。
  final LocalDate paidOn;

  /// 紐づく公演。
  final int? performanceId;
}

/// 二重計上の可能性がある支出の ID。
///
/// 同じ公演・同じ支払日・同じカテゴリの支出が2件以上あるときに対象とする。
/// チェキ代は相手ごとに1件ずつ記録するため対象にしない。警告に使うだけで、
/// 記録は止めない。
Set<int> duplicateExpenseIds(Iterable<ExpenseFacts> expenses) {
  final groups = <(int, LocalDate, ExpenseCategory), List<int>>{};
  for (final expense in expenses) {
    final performanceId = expense.performanceId;
    if (performanceId == null || expense.category == ExpenseCategory.cheki) {
      continue;
    }
    groups
        .putIfAbsent(
          (performanceId, expense.paidOn, expense.category),
          () => [],
        )
        .add(expense.id);
  }
  return {
    for (final ids in groups.values)
      if (ids.length > 1) ...ids,
  };
}
