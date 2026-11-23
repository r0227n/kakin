import 'package:app/application/application.dart';
import 'package:app/domain/domain.dart';
import 'package:app/infrastructure/persistence/drift/app_database.dart';
import 'package:app/infrastructure/persistence/drift/repositories/row_mapping.dart';
import 'package:drift/drift.dart';

const List<TicketApplicationStage> _openStages = [
  TicketApplicationStage.planned,
  TicketApplicationStage.awaitingResult,
  TicketApplicationStage.awaitingPayment,
];

/// チケット申込を drift に保存する。
final class DriftTicketApplicationRepository
    implements TicketApplicationRepository {
  /// 開いた DB を注入する。
  const DriftTicketApplicationRepository(this._db);

  final AppDatabase _db;

  Future<List<TicketApplication>> _query(
    Expression<bool> Function() filter, {
    int? limit,
  }) async {
    final imported = existsQuery(
      _db.select(_db.emailImports)..where(
        (i) => i.ticketApplicationId.equalsExp(_db.ticketApplications.id),
      ),
    );
    final query =
        _db.select(_db.ticketApplications).join([
            innerJoin(
              _db.performances,
              _db.performances.id.equalsExp(
                _db.ticketApplications.performanceId,
              ),
            ),
          ])
          ..addColumns([imported])
          ..where(filter())
          ..orderBy([
            OrderingTerm.desc(_db.ticketApplications.createdAt),
            OrderingTerm.desc(_db.ticketApplications.id),
          ]);
    if (limit != null) query.limit(limit);
    return [
      for (final row in await query.get())
        _map(
          row.readTable(_db.ticketApplications),
          row.readTable(_db.performances),
          isImported: row.read(imported) ?? false,
        ),
    ];
  }

  TicketApplication _map(
    TicketApplicationRow row,
    PerformanceRow performance, {
    required bool isImported,
  }) => TicketApplication(
    id: row.id,
    performance: performance.toModel(),
    stage: row.stage,
    createdAt: row.createdAt.toUtc(),
    isImported: isImported,
    service: row.service,
    referenceNo: row.referenceNo,
    applyDeadlineAt: row.applyDeadlineAt?.toUtc(),
    resultAt: row.resultAt?.toUtc(),
    paymentDeadlineAt: row.paymentDeadlineAt?.toUtc(),
    note: row.note,
  );

  @override
  Future<List<TicketApplication>> listForPerformance(int performanceId) =>
      guardStorage(
        () => _query(
          () => _db.ticketApplications.performanceId.equals(performanceId),
        ),
      );

  @override
  Future<List<TicketApplication>> listForPerformances(
    Iterable<int> performanceIds,
  ) => guardStorage(
    () => _query(
      () => _db.ticketApplications.performanceId.isIn(performanceIds),
    ),
  );

  @override
  Future<List<TicketApplication>> listOpen() => guardStorage(
    () => _query(() => _db.ticketApplications.stage.isInValues(_openStages)),
  );

  @override
  Future<TicketApplication?> find(int id) => guardStorage(() async {
    final rows = await _query(() => _db.ticketApplications.id.equals(id));
    return rows.isEmpty ? null : rows.single;
  });

  @override
  Future<TicketApplication?> findByReference(
    TicketServiceKind service,
    String referenceNo,
  ) => guardStorage(() async {
    final rows = await _query(
      () =>
          _db.ticketApplications.service.equalsValue(service) &
          _db.ticketApplications.referenceNo.equals(referenceNo),
      limit: 1,
    );
    return rows.firstOrNull;
  });

  @override
  Future<TicketApplication?> findLatestOpen(
    int performanceId,
    TicketServiceKind service,
  ) => guardStorage(() async {
    final rows = await _query(
      () =>
          _db.ticketApplications.performanceId.equals(performanceId) &
          _db.ticketApplications.service.equalsValue(service) &
          _db.ticketApplications.stage.isInValues(const [
            TicketApplicationStage.secured,
            TicketApplicationStage.lost,
          ]).not(),
      limit: 1,
    );
    return rows.firstOrNull;
  });

  TicketApplicationsCompanion _companion(TicketApplicationDraft draft) =>
      TicketApplicationsCompanion(
        performanceId: Value(draft.performanceId),
        stage: Value(draft.stage),
        service: Value(draft.service),
        referenceNo: Value(draft.referenceNo),
        applyDeadlineAt: Value(draft.applyDeadlineAt?.toUtc()),
        resultAt: Value(draft.resultAt?.toUtc()),
        paymentDeadlineAt: Value(draft.paymentDeadlineAt?.toUtc()),
        note: Value(draft.note),
      );

  @override
  Future<int> create(TicketApplicationDraft draft) => guardStorage(
    () => _db.into(_db.ticketApplications).insert(_companion(draft)),
  );

  @override
  Future<void> update(int id, TicketApplicationDraft draft) => guardStorage(
    () => (_db.update(_db.ticketApplications)..where((a) => a.id.equals(id)))
        .write(
          _companion(
            draft,
          ).copyWith(updatedAt: Value(DateTime.now().toUtc())),
        ),
  );

  @override
  Future<void> updateStage(int id, TicketApplicationStage stage) =>
      guardStorage(
        () =>
            (_db.update(
              _db.ticketApplications,
            )..where((a) => a.id.equals(id))).write(
              TicketApplicationsCompanion(
                stage: Value(stage),
                updatedAt: Value(DateTime.now().toUtc()),
              ),
            ),
      );

  @override
  Future<void> delete(int id) => guardStorage(
    () => (_db.delete(
      _db.ticketApplications,
    )..where((a) => a.id.equals(id))).go(),
  );
}
