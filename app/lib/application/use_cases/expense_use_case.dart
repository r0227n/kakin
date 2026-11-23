import 'package:app/application/errors/record_error.dart';
import 'package:app/application/models/records.dart';
import 'package:app/application/ports/record_repositories.dart';
import 'package:app/domain/domain.dart';

/// 支出の記録・編集・削除の入力境界。
final class ExpenseUseCase {
  /// 保存先を注入する。
  const ExpenseUseCase(this._expenses);

  final ExpenseRepository _expenses;

  /// [id] の支出。
  Future<Expense?> find(int id) => _expenses.find(id);

  /// ドリンク代の初期値。前回登録したドリンク代の金額。
  Future<int?> latestDrinkAmount() => _expenses.latestDrinkAmount();

  /// 支出をまとめて記録する。チェキ代は相手ごとに1件ずつ渡す。
  Future<List<int>> record(List<ExpenseDraft> drafts) {
    if (drafts.isEmpty) throw const InvalidInputException(InputField.partner);
    return _expenses.addAll([for (final d in drafts) _validated(d)]);
  }

  /// 支出を編集する。
  Future<void> update(int id, ExpenseDraft draft) =>
      _expenses.update(id, _validated(draft));

  /// 支出を削除する。
  Future<void> delete(int id) => _expenses.delete(id);

  ExpenseDraft _validated(ExpenseDraft draft) {
    if (draft.amountYen < 0) {
      throw const InvalidInputException(InputField.amount);
    }
    if (draft.category.requiresPerformance && draft.performanceId == null) {
      throw const InvalidInputException(InputField.performance);
    }
    final isCheki = draft.category == ExpenseCategory.cheki;
    if (isCheki && draft.partnerId == null) {
      throw const InvalidInputException(InputField.partner);
    }
    if (isCheki && (draft.shotCount ?? 0) < 1) {
      throw const InvalidInputException(InputField.shotCount);
    }
    final note = draft.note?.trim();
    return ExpenseDraft(
      category: draft.category,
      amountYen: draft.amountYen,
      paidOn: draft.paidOn,
      performanceId: draft.performanceId,
      partnerId: isCheki ? draft.partnerId : null,
      shotCount: isCheki ? draft.shotCount : null,
      note: note == null || note.isEmpty ? null : note,
    );
  }
}
