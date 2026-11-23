import 'package:app/application/application.dart';
import 'package:app/application/errors/record_error.dart';
import 'package:app/domain/domain.dart';
import 'package:app/infrastructure/persistence/drift/app_database.dart';
import 'package:app/infrastructure/persistence/drift/repositories/row_mapping.dart';
import 'package:drift/drift.dart';

/// チェキ相手を drift に保存する。
final class DriftPartnerRepository implements PartnerRepository {
  /// 開いた DB を注入する。
  const DriftPartnerRepository(this._db);

  final AppDatabase _db;

  Future<List<Partner>> _query({int? id}) async {
    final count = _db.expenses.id.count();
    final firstShot = _db.expenses.paidOn.min();
    final lastShot = _db.expenses.paidOn.max();
    final shots = _db.expenses.shotCount.sum();
    final query =
        _db.select(_db.partners).join([
            leftOuterJoin(
              _db.expenses,
              _db.expenses.partnerId.equalsExp(_db.partners.id),
            ),
          ])
          ..addColumns([count, firstShot, lastShot, shots])
          ..groupBy([_db.partners.id])
          ..orderBy([OrderingTerm.asc(_db.partners.name)]);
    if (id != null) query.where(_db.partners.id.equals(id));
    return [
      for (final row in await query.get())
        row
            .readTable(_db.partners)
            .toModel(
              chekiCount: row.read(count) ?? 0,
              shotTotal: row.read(shots) ?? 0,
              firstShotOn: switch (row.read(firstShot)) {
                final String day => LocalDate.parse(day),
                _ => null,
              },
              lastShotOn: switch (row.read(lastShot)) {
                final String day => LocalDate.parse(day),
                _ => null,
              },
            ),
    ];
  }

  @override
  Future<List<Partner>> listAll() => guardStorage(_query);

  @override
  Future<Partner?> find(int id) => guardStorage(() async {
    final rows = await _query(id: id);
    return rows.isEmpty ? null : rows.single;
  });

  @override
  Future<int> create(PartnerDraft draft, {String? iconFile}) => guardStorage(
    () => _db
        .into(_db.partners)
        .insert(
          PartnersCompanion.insert(
            name: draft.name,
            groupName: Value(draft.groupName),
            iconFile: Value(iconFile),
          ),
        ),
  );

  @override
  Future<void> update(int id, PartnerDraft draft) => guardStorage(
    () => (_db.update(_db.partners)..where((p) => p.id.equals(id))).write(
      PartnersCompanion(
        name: Value(draft.name),
        groupName: Value(draft.groupName),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    ),
  );

  @override
  Future<String?> replaceIcon(int id, String? iconFile) => guardStorage(
    () => _db.transaction(() async {
      final current = await (_db.select(
        _db.partners,
      )..where((p) => p.id.equals(id))).getSingle();
      await (_db.update(_db.partners)..where((p) => p.id.equals(id))).write(
        PartnersCompanion(
          iconFile: Value(iconFile),
          updatedAt: Value(DateTime.now().toUtc()),
        ),
      );
      return current.iconFile;
    }),
  );

  @override
  Future<String?> delete(int id) => guardStorage(
    () => _db.transaction(() async {
      final current = await (_db.select(
        _db.partners,
      )..where((p) => p.id.equals(id))).getSingleOrNull();
      if (current == null) return null;
      final used =
          await (_db.select(_db.expenses)
                ..where((e) => e.partnerId.equals(id))
                ..limit(1))
              .getSingleOrNull();
      if (used != null) throw const PartnerInUseException();
      await (_db.delete(_db.partners)..where((p) => p.id.equals(id))).go();
      return current.iconFile;
    }),
  );

  @override
  Future<Set<String>> referencedIconFiles() => guardStorage(() async {
    final query = _db.selectOnly(_db.partners)
      ..addColumns([_db.partners.iconFile])
      ..where(_db.partners.iconFile.isNotNull());
    return {
      for (final row in await query.get()) row.read(_db.partners.iconFile)!,
    };
  });
}
