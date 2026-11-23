import 'package:app/application/application.dart';
import 'package:app/domain/domain.dart';
import 'package:app/infrastructure/persistence/drift/app_database.dart';
import 'package:app/infrastructure/persistence/drift/repositories/row_mapping.dart';
import 'package:drift/drift.dart';

/// Gmail の同期状態と取り込み履歴を drift に保存する。
final class DriftGmailImportRepository implements GmailImportRepository {
  /// 開いた DB を注入する。
  const DriftGmailImportRepository(this._db);

  final AppDatabase _db;

  @override
  Future<GmailConnection?> loadConnection() => guardStorage(() async {
    final row = await (_db.select(
      _db.gmailSyncStates,
    )..limit(1)).getSingleOrNull();
    if (row == null) return null;
    return GmailConnection(
      accountEmail: row.accountEmail,
      connectedAt: row.connectedAt.toUtc(),
      lastFetchedAt: row.lastFetchedAt?.toUtc(),
      lastMessageReceivedAt: row.lastMessageReceivedAt?.toUtc(),
      lastFailedAt: row.lastFailedAt?.toUtc(),
      lastFailureKind: switch (row.lastFailureKind) {
        StoredFailureKind.reauthRequired => GmailFailureKind.reauthRequired,
        StoredFailureKind.other => GmailFailureKind.other,
        null => null,
      },
    );
  });

  @override
  Future<void> saveConnection(String accountEmail, DateTime connectedAt) =>
      guardStorage(
        () => _db
            .into(_db.gmailSyncStates)
            .insertOnConflictUpdate(
              GmailSyncStatesCompanion.insert(
                accountEmail: accountEmail,
                connectedAt: connectedAt.toUtc(),
              ),
            ),
      );

  @override
  Future<void> deleteConnection(String accountEmail) => guardStorage(
    () => (_db.delete(
      _db.gmailSyncStates,
    )..where((s) => s.accountEmail.equals(accountEmail))).go(),
  );

  @override
  Future<Set<String>> importedMessageIds(
    String accountEmail,
    Iterable<String> messageIds,
  ) => guardStorage(() async {
    final query = _db.selectOnly(_db.emailImports)
      ..addColumns([_db.emailImports.gmailMessageId])
      ..where(
        _db.emailImports.accountEmail.equals(accountEmail) &
            _db.emailImports.gmailMessageId.isIn(messageIds),
      );
    return {
      for (final row in await query.get())
        row.read(_db.emailImports.gmailMessageId)!,
    };
  });

  @override
  Future<int> recordImport(String accountEmail, TicketMail mail) =>
      guardStorage(
        () => _db
            .into(_db.emailImports)
            .insert(
              EmailImportsCompanion.insert(
                accountEmail: accountEmail,
                gmailMessageId: mail.messageId,
                service: mail.service == TicketServiceKind.livepocket
                    ? StoredMailService.livepocket
                    : StoredMailService.eplus,
                mailKind: StoredMailKind.values.byName(mail.kind.name),
                subject: mail.subject,
                receivedAt: mail.receivedAt.toUtc(),
                importedAt: DateTime.now().toUtc(),
              ),
            ),
      );

  @override
  Future<void> linkApplication(int importId, int applicationId) => guardStorage(
    () =>
        (_db.update(
          _db.emailImports,
        )..where((i) => i.id.equals(importId))).write(
          EmailImportsCompanion(ticketApplicationId: Value(applicationId)),
        ),
  );

  @override
  Future<void> recordSuccess(
    String accountEmail, {
    required DateTime fetchedAt,
    DateTime? lastMessageReceivedAt,
  }) => guardStorage(
    () =>
        (_db.update(
          _db.gmailSyncStates,
        )..where((s) => s.accountEmail.equals(accountEmail))).write(
          GmailSyncStatesCompanion(
            lastFetchedAt: Value(fetchedAt.toUtc()),
            lastMessageReceivedAt: lastMessageReceivedAt == null
                ? const Value.absent()
                : Value(lastMessageReceivedAt.toUtc()),
            lastFailedAt: const Value(null),
            lastFailureKind: const Value(null),
            updatedAt: Value(DateTime.now().toUtc()),
          ),
        ),
  );

  @override
  Future<void> recordFailure(
    String accountEmail, {
    required DateTime failedAt,
    required GmailFailureKind kind,
  }) => guardStorage(
    () =>
        (_db.update(
          _db.gmailSyncStates,
        )..where((s) => s.accountEmail.equals(accountEmail))).write(
          GmailSyncStatesCompanion(
            lastFailedAt: Value(failedAt.toUtc()),
            lastFailureKind: Value(
              kind == GmailFailureKind.reauthRequired
                  ? StoredFailureKind.reauthRequired
                  : StoredFailureKind.other,
            ),
            updatedAt: Value(DateTime.now().toUtc()),
          ),
        ),
  );
}

/// drift のトランザクションで書き込みをまとめる。
final class DriftUnitOfWork implements UnitOfWork {
  /// 開いた DB を注入する。
  const DriftUnitOfWork(this._db);

  final AppDatabase _db;

  @override
  Future<T> run<T>(Future<T> Function() action) =>
      guardStorage(() => _db.transaction(action));
}

/// drift の表の更新を変更の通知として流す。
final class DriftLocalDataChanges implements LocalDataChanges {
  /// 開いた DB を注入する。
  const DriftLocalDataChanges(this._db);

  final AppDatabase _db;

  @override
  Stream<void> watch() async* {
    yield null;
    yield* _db.tableUpdates();
  }
}
