import 'package:app/application/application.dart';
import 'package:app/domain/domain.dart';
import 'package:app/infrastructure/persistence/drift/app_database.dart';
import 'package:app/infrastructure/persistence/drift/repositories/row_mapping.dart';
import 'package:drift/drift.dart';

/// 支出を drift に保存する。
final class DriftExpenseRepository implements ExpenseRepository {
  /// 開いた DB を注入する。
  const DriftExpenseRepository(this._db);

  final AppDatabase _db;

  JoinedSelectStatement<HasResultSet, dynamic> _joined() =>
      _db.select(_db.expenses).join([
        leftOuterJoin(
          _db.performances,
          _db.performances.id.equalsExp(_db.expenses.performanceId),
        ),
        leftOuterJoin(
          _db.partners,
          _db.partners.id.equalsExp(_db.expenses.partnerId),
        ),
      ]);

  Expense _map(TypedResult row) {
    final expense = row.readTable(_db.expenses);
    return Expense(
      id: expense.id,
      category: expense.category,
      amountYen: expense.amountYen,
      paidOn: LocalDate.parse(expense.paidOn),
      isImported: expense.emailImportId != null,
      performance: row.readTableOrNull(_db.performances)?.toModel(),
      partner: row.readTableOrNull(_db.partners)?.toModel(),
      shotCount: expense.shotCount,
      note: expense.note,
    );
  }

  @override
  Future<List<Expense>> listTouching(LocalDate from, LocalDate until) =>
      guardStorage(() async {
        final query = _joined()
          ..where(
            _db.expenses.paidOn.isBetweenValues(
                  from.toIso(),
                  until.addDays(-1).toIso(),
                ) |
                (_db.performances.startsAt.isBiggerOrEqualValue(
                      JapanTime.instantOf(from),
                    ) &
                    _db.performances.startsAt.isSmallerThanValue(
                      JapanTime.instantOf(until),
                    )),
          );
        return (await query.get()).map(_map).toList();
      });

  @override
  Future<Map<YearMonth, int>> monthlySpendByPaidOn() => guardStorage(() async {
    final month = _db.expenses.paidOn.substr(1, 7);
    final total = _db.expenses.amountYen.sum();
    final query = _db.selectOnly(_db.expenses)
      ..addColumns([month, total])
      ..groupBy([month]);
    return {
      for (final row in await query.get())
        YearMonth.parse(row.read(month)!): row.read(total) ?? 0,
    };
  });

  @override
  Future<Expense?> find(int id) => guardStorage(() async {
    final query = _joined()..where(_db.expenses.id.equals(id));
    final row = await query.getSingleOrNull();
    return row == null ? null : _map(row);
  });

  @override
  Future<int?> latestDrinkAmount() => guardStorage(() async {
    final query = _db.select(_db.expenses)
      ..where((e) => e.category.equalsValue(ExpenseCategory.drink))
      ..orderBy([
        (e) => OrderingTerm.desc(e.createdAt),
        (e) => OrderingTerm.desc(e.id),
      ])
      ..limit(1);
    return (await query.getSingleOrNull())?.amountYen;
  });

  ExpensesCompanion _companion(ExpenseDraft draft, {int? emailImportId}) =>
      ExpensesCompanion.insert(
        category: draft.category,
        amountYen: draft.amountYen,
        paidOn: draft.paidOn.toIso(),
        performanceId: Value(draft.performanceId),
        partnerId: Value(draft.partnerId),
        shotCount: Value(draft.shotCount),
        note: Value(draft.note),
        emailImportId: Value(emailImportId),
      );

  @override
  Future<List<int>> addAll(List<ExpenseDraft> drafts) => guardStorage(
    () => _db.transaction(() async {
      return [
        for (final draft in drafts)
          await _db.into(_db.expenses).insert(_companion(draft)),
      ];
    }),
  );

  @override
  Future<int> addImported(ExpenseDraft draft, {required int emailImportId}) =>
      guardStorage(
        () => _db
            .into(_db.expenses)
            .insert(_companion(draft, emailImportId: emailImportId)),
      );

  @override
  Future<void> update(int id, ExpenseDraft draft) => guardStorage(
    () => (_db.update(_db.expenses)..where((e) => e.id.equals(id))).write(
      ExpensesCompanion(
        category: Value(draft.category),
        amountYen: Value(draft.amountYen),
        paidOn: Value(draft.paidOn.toIso()),
        performanceId: Value(draft.performanceId),
        partnerId: Value(draft.partnerId),
        shotCount: Value(draft.shotCount),
        note: Value(draft.note),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    ),
  );

  @override
  Future<void> delete(int id) => guardStorage(
    () => (_db.delete(_db.expenses)..where((e) => e.id.equals(id))).go(),
  );
}
