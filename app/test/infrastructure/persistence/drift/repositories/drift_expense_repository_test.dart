import 'package:app/application/application.dart';
import 'package:app/application/errors/record_error.dart';
import 'package:app/domain/domain.dart';
import 'package:app/infrastructure/infrastructure.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late DriftExpenseRepository expenses;
  late DriftPerformanceRepository performances;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    expenses = DriftExpenseRepository(db);
    performances = DriftPerformanceRepository(db);
  });
  tearDown(() => db.close());

  ExpenseDraft goods(String paidOn, {int amount = 1000, int? performanceId}) =>
      ExpenseDraft(
        category: ExpenseCategory.goods,
        amountYen: amount,
        paidOn: LocalDate.parse(paidOn),
        performanceId: performanceId,
      );

  test('monthlySpendByPaidOn sums by the paid month', () async {
    await expenses.addAll([
      goods('2026-10-31', amount: 100),
      goods('2026-11-01', amount: 200),
      goods('2026-11-30', amount: 300),
      goods('2027-01-05', amount: 400),
    ]);

    expect(await expenses.monthlySpendByPaidOn(), {
      YearMonth(2026, 10): 100,
      YearMonth(2026, 11): 500,
      YearMonth(2027, 1): 400,
    });
  });

  test('monthlySpendByPaidOn ignores the performance month', () async {
    final performanceId = await performances.create(
      PerformanceDraft(title: 'Live', startsAt: DateTime.utc(2026, 12, 5)),
    );
    await expenses.addAll([
      goods('2026-11-15', amount: 700, performanceId: performanceId),
    ]);

    expect(await expenses.monthlySpendByPaidOn(), {YearMonth(2026, 11): 700});
  });

  test('listTouching includes paid dates in the half-open range', () async {
    await expenses.addAll([
      goods('2026-10-31'),
      goods('2026-11-01'),
      goods('2026-11-30'),
      goods('2026-12-01'),
    ]);

    final touching = await expenses.listTouching(
      LocalDate(2026, 11, 1),
      LocalDate(2026, 12, 1),
    );

    expect(touching.map((e) => e.paidOn.toIso()).toList()..sort(), [
      '2026-11-01',
      '2026-11-30',
    ]);
  });

  test(
    'listTouching includes expenses whose performance is in range',
    () async {
      // 2026-11-01 00:00 JST。UTC では 10-31。
      final inRange = await performances.create(
        PerformanceDraft(title: 'In', startsAt: DateTime.utc(2026, 10, 31, 15)),
      );
      // 2026-12-01 00:00 JST。
      final outOfRange = await performances.create(
        PerformanceDraft(
          title: 'Out',
          startsAt: DateTime.utc(2026, 11, 30, 15),
        ),
      );
      final [paidEarlier, paidLater] = await expenses.addAll([
        goods('2026-09-10', performanceId: inRange),
        goods('2026-09-11', performanceId: outOfRange),
      ]);

      final touching = await expenses.listTouching(
        LocalDate(2026, 11, 1),
        LocalDate(2026, 12, 1),
      );

      expect(touching.map((e) => e.id), [paidEarlier]);
      expect(touching.single.performance?.title, 'In');
      expect(touching.map((e) => e.id), isNot(contains(paidLater)));
    },
  );

  test('addAll writes nothing when one row violates a constraint', () async {
    // チケット代は公演が必須で、DB の CHECK 制約で拒否される。
    final invalid = ExpenseDraft(
      category: ExpenseCategory.ticket,
      amountYen: 1000,
      paidOn: LocalDate(2026, 11, 1),
    );

    await expectLater(
      expenses.addAll([goods('2026-11-01'), invalid]),
      throwsA(isA<RecordStorageException>()),
    );
    expect(await expenses.monthlySpendByPaidOn(), isEmpty);
  });

  test('update replaces fields and keeps the imported flag', () async {
    final [id] = await expenses.addAll([goods('2026-11-01')]);

    await expenses.update(id, goods('2026-11-02', amount: 5));

    final updated = (await expenses.find(id))!;
    expect(updated.amountYen, 5);
    expect(updated.paidOn, LocalDate(2026, 11, 2));
    expect(updated.isImported, isFalse);
  });

  test('delete removes the row', () async {
    final [id] = await expenses.addAll([goods('2026-11-01')]);

    await expenses.delete(id);

    expect(await expenses.find(id), isNull);
  });
}
