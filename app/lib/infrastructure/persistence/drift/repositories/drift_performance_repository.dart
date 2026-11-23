import 'package:app/application/application.dart';
import 'package:app/domain/domain.dart';
import 'package:app/infrastructure/persistence/drift/app_database.dart';
import 'package:app/infrastructure/persistence/drift/repositories/row_mapping.dart';
import 'package:drift/drift.dart';

const List<ExpenseCategory> _requiredCategories = [
  ExpenseCategory.ticket,
  ExpenseCategory.drink,
  ExpenseCategory.cheki,
];

/// 公演を drift に保存する。
final class DriftPerformanceRepository implements PerformanceRepository {
  /// 開いた DB を注入する。
  const DriftPerformanceRepository(this._db);

  final AppDatabase _db;

  @override
  Future<List<Performance>> listAll() => guardStorage(() async {
    final query = _db.select(_db.performances)
      ..orderBy([(p) => OrderingTerm.desc(p.startsAt)]);
    return [for (final row in await query.get()) row.toModel()];
  });

  @override
  Future<List<Performance>> listStartingBetween(
    LocalDate from,
    LocalDate until,
  ) => guardStorage(() async {
    final query = _db.select(_db.performances)
      ..where(
        (p) =>
            p.startsAt.isBiggerOrEqualValue(JapanTime.instantOf(from)) &
            p.startsAt.isSmallerThanValue(JapanTime.instantOf(until)),
      )
      ..orderBy([(p) => OrderingTerm.asc(p.startsAt)]);
    return [for (final row in await query.get()) row.toModel()];
  });

  @override
  Future<List<Performance>> listUpcoming(LocalDate today) =>
      guardStorage(() async {
        final hasTicket = existsQuery(
          _db.select(_db.expenses)..where(
            (e) =>
                e.performanceId.equalsExp(_db.performances.id) &
                e.category.equalsValue(ExpenseCategory.ticket),
          ),
        );
        final hasApplication = existsQuery(
          _db.select(_db.ticketApplications)..where(
            (a) =>
                a.performanceId.equalsExp(_db.performances.id) &
                a.stage.equalsValue(TicketApplicationStage.lost).not(),
          ),
        );
        final query = _db.select(_db.performances)
          ..where(
            (p) =>
                p.startsAt.isBiggerOrEqualValue(JapanTime.instantOf(today)) &
                (hasTicket | hasApplication),
          )
          ..orderBy([(p) => OrderingTerm.asc(p.startsAt)]);
        return [for (final row in await query.get()) row.toModel()];
      });

  @override
  Future<Performance?> find(int id) => guardStorage(() async {
    final query = _db.select(_db.performances)..where((p) => p.id.equals(id));
    return (await query.getSingleOrNull())?.toModel();
  });

  @override
  Future<Performance?> findByTitleAndStart(String title, DateTime startsAt) =>
      guardStorage(() async {
        final query = _db.select(_db.performances)
          ..where(
            (p) => p.title.equals(title) & p.startsAt.equals(startsAt.toUtc()),
          )
          ..orderBy([(p) => OrderingTerm.asc(p.id)])
          ..limit(1);
        return (await query.getSingleOrNull())?.toModel();
      });

  @override
  Future<int> create(PerformanceDraft draft) => guardStorage(
    () => _db
        .into(_db.performances)
        .insert(
          PerformancesCompanion.insert(
            title: draft.title,
            startsAt: draft.startsAt.toUtc(),
            venue: Value(draft.venue),
          ),
        ),
  );

  @override
  Future<void> update(int id, PerformanceDraft draft) => guardStorage(
    () => (_db.update(_db.performances)..where((p) => p.id.equals(id))).write(
      PerformancesCompanion(
        title: Value(draft.title),
        startsAt: Value(draft.startsAt.toUtc()),
        venue: Value(draft.venue),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    ),
  );

  @override
  Future<PerformanceDeletionImpact> deletionImpact(int id) =>
      guardStorage(() async {
        final count = _db.expenses.id.count();
        final total = _db.expenses.amountYen.sum();
        final expenses = _db.selectOnly(_db.expenses)
          ..addColumns([count, total])
          ..where(
            _db.expenses.performanceId.equals(id) &
                _db.expenses.category.isInValues(_requiredCategories),
          );
        final expenseRow = await expenses.getSingle();
        final applicationCount = _db.ticketApplications.id.count();
        final applications = _db.selectOnly(_db.ticketApplications)
          ..addColumns([applicationCount])
          ..where(_db.ticketApplications.performanceId.equals(id));
        return PerformanceDeletionImpact(
          expenseCount: expenseRow.read(count) ?? 0,
          expenseTotalYen: expenseRow.read(total) ?? 0,
          applicationCount:
              (await applications.getSingle()).read(applicationCount) ?? 0,
        );
      });

  @override
  Future<void> delete(int id) => guardStorage(
    () => _db.transaction(() async {
      await (_db.delete(_db.expenses)..where(
            (e) =>
                e.performanceId.equals(id) &
                e.category.isInValues(_requiredCategories),
          ))
          .go();
      await (_db.delete(_db.performances)..where((p) => p.id.equals(id))).go();
    }),
  );
}
