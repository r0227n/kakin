import 'package:app/application/application.dart';
import 'package:app/domain/domain.dart';
import 'package:app/infrastructure/persistence/drift/app_database.dart';
import 'package:app/infrastructure/persistence/drift/repositories/row_mapping.dart';
import 'package:drift/drift.dart';

/// 推し活代を drift に保存する。
final class DriftBudgetRepository implements BudgetRepository {
  /// 開いた DB を注入する。
  const DriftBudgetRepository(this._db);

  final AppDatabase _db;

  @override
  Future<BudgetPlan> loadPlan() => guardStorage(() async {
    final rates = await _db.select(_db.budgetRates).get();
    final overrides = await _db.select(_db.budgetOverrides).get();
    return BudgetPlan(
      rates: {
        for (final r in rates) YearMonth.parse(r.effectiveMonth): r.amountYen,
      },
      overrides: {
        for (final o in overrides) YearMonth.parse(o.month): o.amountYen,
      },
    );
  });

  @override
  Future<void> saveRate(YearMonth month, int amountYen) => guardStorage(
    () => _db
        .into(_db.budgetRates)
        .insert(
          BudgetRatesCompanion.insert(
            effectiveMonth: month.toIso(),
            amountYen: amountYen,
          ),
          onConflict: DoUpdate(
            (_) => BudgetRatesCompanion(
              amountYen: Value(amountYen),
              updatedAt: Value(DateTime.now().toUtc()),
            ),
          ),
        ),
  );

  @override
  Future<void> moveStartMonth(YearMonth month) => guardStorage(
    () => _db.transaction(() async {
      final plan = await loadPlan();
      final start = plan.startMonth;
      if (start == null || start == month) return;
      final iso = month.toIso();
      if (month.isBefore(start)) {
        await (_db.update(
          _db.budgetRates,
        )..where((r) => r.effectiveMonth.equals(start.toIso()))).write(
          BudgetRatesCompanion(
            effectiveMonth: Value(iso),
            updatedAt: Value(DateTime.now().toUtc()),
          ),
        );
        return;
      }
      await saveRate(month, plan.monthlyRateAt(month)!);
      await (_db.delete(
        _db.budgetRates,
      )..where((r) => r.effectiveMonth.isSmallerThanValue(iso))).go();
      await (_db.delete(
        _db.budgetOverrides,
      )..where((o) => o.month.isSmallerThanValue(iso))).go();
    }),
  );

  @override
  Future<void> saveOverride(YearMonth month, int amountYen) => guardStorage(
    () => _db
        .into(_db.budgetOverrides)
        .insert(
          BudgetOverridesCompanion.insert(
            month: month.toIso(),
            amountYen: amountYen,
          ),
          onConflict: DoUpdate(
            (_) => BudgetOverridesCompanion(
              amountYen: Value(amountYen),
              updatedAt: Value(DateTime.now().toUtc()),
            ),
          ),
        ),
  );

  @override
  Future<void> deleteOverride(YearMonth month) => guardStorage(
    () => (_db.delete(
      _db.budgetOverrides,
    )..where((o) => o.month.equals(month.toIso()))).go(),
  );
}
