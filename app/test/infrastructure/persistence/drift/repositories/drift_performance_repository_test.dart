import 'package:app/application/application.dart';
import 'package:app/domain/domain.dart';
import 'package:app/infrastructure/infrastructure.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final day = LocalDate(2026, 11, 22);

  late AppDatabase db;
  late DriftPerformanceRepository performances;
  late DriftExpenseRepository expenses;
  late DriftTicketApplicationRepository applications;
  late int partnerId;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    performances = DriftPerformanceRepository(db);
    expenses = DriftExpenseRepository(db);
    applications = DriftTicketApplicationRepository(db);
    partnerId = await DriftPartnerRepository(
      db,
    ).create(const PartnerDraft(name: 'A'));
  });
  tearDown(() => db.close());

  Future<int> performance(String title, DateTime startsAt) =>
      performances.create(PerformanceDraft(title: title, startsAt: startsAt));

  ExpenseDraft expense(
    ExpenseCategory category,
    int performanceId, {
    int amount = 1000,
  }) => ExpenseDraft(
    category: category,
    amountYen: amount,
    paidOn: day,
    performanceId: performanceId,
    partnerId: category == ExpenseCategory.cheki ? partnerId : null,
    shotCount: category == ExpenseCategory.cheki ? 1 : null,
  );

  Future<int> application(
    int performanceId, {
    TicketApplicationStage stage = TicketApplicationStage.planned,
  }) => applications.create(
    TicketApplicationDraft(performanceId: performanceId, stage: stage),
  );

  group('delete', () {
    late int target;
    late int other;
    late List<int> expenseIds;

    setUp(() async {
      target = await performance('Target', DateTime.utc(2026, 12));
      other = await performance('Other', DateTime.utc(2026, 12, 2));
      expenseIds = await expenses.addAll([
        expense(ExpenseCategory.ticket, target),
        expense(ExpenseCategory.drink, target),
        expense(ExpenseCategory.cheki, target),
        expense(ExpenseCategory.goods, target),
        expense(ExpenseCategory.transport, target),
        expense(ExpenseCategory.ticket, other),
      ]);
      await application(target);
      await application(other);
    });

    test('removes ticket, drink and cheki expenses', () async {
      await performances.delete(target);

      for (final id in expenseIds.take(3)) {
        expect(await expenses.find(id), isNull);
      }
    });

    test('keeps other categories but unlinks them', () async {
      await performances.delete(target);

      for (final id in expenseIds.sublist(3, 5)) {
        final kept = (await expenses.find(id))!;
        expect(kept.performance, isNull);
      }
    });

    test('removes the ticket applications by cascade', () async {
      await performances.delete(target);

      expect(await applications.listForPerformance(target), isEmpty);
      expect(await applications.listOpen(), hasLength(1));
    });

    test('leaves other performances and the partner untouched', () async {
      await performances.delete(target);

      expect(await performances.find(target), isNull);
      expect((await expenses.find(expenseIds.last))!.performance?.id, other);
      expect(await applications.listForPerformance(other), hasLength(1));
      expect(await DriftPartnerRepository(db).find(partnerId), isNotNull);
    });

    test('impact reflects what delete removes', () async {
      final impact = await performances.deletionImpact(target);

      expect(impact.expenseCount, 3);
      expect(impact.expenseTotalYen, 3000);
      expect(impact.applicationCount, 1);
    });
  });

  test('findByTitleAndStart returns the oldest exact match', () async {
    final startsAt = DateTime.utc(2026, 12);
    final first = await performance('Live', startsAt);
    await performance('Live', startsAt);
    await performance('Live', startsAt.add(const Duration(minutes: 1)));

    expect(
      (await performances.findByTitleAndStart('Live', startsAt))!.id,
      first,
    );
    expect(await performances.findByTitleAndStart('live', startsAt), isNull);
  });

  test('listStartingBetween uses JST day bounds', () async {
    // 2026-12-01 00:00 JST と 2026-12-01 23:59 JST。
    await performance('In', DateTime.utc(2026, 11, 30, 15));
    await performance('Also in', DateTime.utc(2026, 12, 1, 14, 59));
    await performance('Out', DateTime.utc(2026, 12, 1, 15));

    final found = await performances.listStartingBetween(
      LocalDate(2026, 12, 1),
      LocalDate(2026, 12, 2),
    );

    expect(found.map((p) => p.title), ['In', 'Also in']);
  });

  group('listUpcoming', () {
    final today = LocalDate(2026, 11, 22);

    test('includes performances with a ticket or a live application', () async {
      final withTicket = await performance('Ticket', DateTime.utc(2026, 12));
      await expenses.addAll([expense(ExpenseCategory.ticket, withTicket)]);
      final withApplication = await performance(
        'Applied',
        DateTime.utc(2026, 12, 2),
      );
      await application(withApplication);

      final upcoming = await performances.listUpcoming(today);

      expect(upcoming.map((p) => p.title), ['Ticket', 'Applied']);
    });

    test('excludes lost-only, drink-only and past performances', () async {
      final lost = await performance('Lost', DateTime.utc(2026, 12));
      await application(lost, stage: TicketApplicationStage.lost);
      final drink = await performance('Drink', DateTime.utc(2026, 12));
      await expenses.addAll([expense(ExpenseCategory.drink, drink)]);
      // 2026-11-21 23:00 JST。
      final past = await performance('Past', DateTime.utc(2026, 11, 21, 14));
      await application(past);

      expect(await performances.listUpcoming(today), isEmpty);
    });

    test('includes a performance earlier today in JST', () async {
      // 2026-11-22 00:30 JST は UTC では前日。
      final id = await performance(
        'Tonight',
        DateTime.utc(2026, 11, 21, 15, 30),
      );
      await application(id);

      expect(
        (await performances.listUpcoming(today)).map((p) => p.title),
        ['Tonight'],
      );
    });
  });
}
