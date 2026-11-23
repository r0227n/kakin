import 'package:app/domain/domain.dart';
import 'package:app/infrastructure/persistence/drift/tables/tables.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

export 'package:app/infrastructure/persistence/drift/tables/tables.dart';

part 'app_database.g.dart';

/// 端末内の SQLite DB。スキーマの正は docs/DB.md。
@DriftDatabase(
  tables: [
    BudgetRates,
    BudgetOverrides,
    Performances,
    Expenses,
    Partners,
    EmailImports,
    GmailSyncStates,
    TicketApplications,
  ],
)
final class AppDatabase extends _$AppDatabase {
  /// [executor] を使う。テストでは `NativeDatabase.memory()` を渡す。
  AppDatabase(super.e);

  /// アプリ Documents 配下の `kakin.sqlite` を開く。
  AppDatabase.defaults() : super(driftDatabase(name: 'kakin'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
