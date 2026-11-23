import 'package:app/application/application.dart';
import 'package:app/application/errors/record_error.dart';
import 'package:app/domain/domain.dart';
import 'package:app/infrastructure/infrastructure.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late DriftPartnerRepository partners;
  late DriftExpenseRepository expenses;
  late int performanceId;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    partners = DriftPartnerRepository(db);
    expenses = DriftExpenseRepository(db);
    performanceId = await DriftPerformanceRepository(db).create(
      PerformanceDraft(title: 'Live', startsAt: DateTime.utc(2026, 11)),
    );
  });
  tearDown(() => db.close());

  Future<void> cheki(int partnerId, String paidOn, int shots) =>
      expenses.addAll([
        ExpenseDraft(
          category: ExpenseCategory.cheki,
          amountYen: 1000 * shots,
          paidOn: LocalDate.parse(paidOn),
          performanceId: performanceId,
          partnerId: partnerId,
          shotCount: shots,
        ),
      ]);

  test('aggregates cheki count, shots and first/last shot days', () async {
    final id = await partners.create(const PartnerDraft(name: 'A'));
    await cheki(id, '2026-11-10', 2);
    await cheki(id, '2026-09-01', 1);
    await cheki(id, '2026-11-20', 3);

    final partner = (await partners.find(id))!;

    expect(partner.chekiCount, 3);
    expect(partner.shotTotal, 6);
    expect(partner.firstShotOn, LocalDate(2026, 9, 1));
    expect(partner.lastShotOn, LocalDate(2026, 11, 20));
  });

  test('a partner without cheki has empty stats', () async {
    final id = await partners.create(const PartnerDraft(name: 'A'));

    final partner = (await partners.find(id))!;

    expect((partner.chekiCount, partner.shotTotal), (0, 0));
    expect(partner.firstShotOn, isNull);
    expect(partner.lastShotOn, isNull);
  });

  test('stats are per partner and the list is sorted by name', () async {
    final b = await partners.create(const PartnerDraft(name: 'B'));
    final a = await partners.create(
      const PartnerDraft(name: 'A', groupName: 'G'),
    );
    await cheki(b, '2026-11-01', 1);
    await cheki(a, '2026-11-02', 4);

    final list = await partners.listAll();

    expect(list.map((p) => (p.name, p.chekiCount, p.shotTotal)), [
      ('A', 1, 4),
      ('B', 1, 1),
    ]);
    expect(list.first.groupName, 'G');
  });

  test('find returns null for an unknown partner', () async {
    expect(await partners.find(999), isNull);
  });

  test('delete refuses a partner with cheki records', () async {
    final id = await partners.create(const PartnerDraft(name: 'A'));
    await cheki(id, '2026-11-01', 1);

    await expectLater(
      partners.delete(id),
      throwsA(isA<PartnerInUseException>()),
    );
    expect(await partners.find(id), isNotNull);
  });

  test('delete removes an unused partner and returns its icon', () async {
    final id = await partners.create(
      const PartnerDraft(name: 'A'),
      iconFile: 'a.png',
    );

    expect(await partners.delete(id), 'a.png');
    expect(await partners.find(id), isNull);
    expect(await partners.delete(id), isNull);
  });

  test('replaceIcon returns the previous file and icons are tracked', () async {
    final id = await partners.create(
      const PartnerDraft(name: 'A'),
      iconFile: 'old.png',
    );
    await partners.create(const PartnerDraft(name: 'B'));

    expect(await partners.replaceIcon(id, 'new.png'), 'old.png');
    expect(await partners.referencedIconFiles(), {'new.png'});
  });
}
