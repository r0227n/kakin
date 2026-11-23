import 'package:app/application/application.dart';
import 'package:app/application/errors/record_error.dart';
import 'package:app/domain/domain.dart';
import 'package:app/infrastructure/infrastructure.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/test_graph.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final startsAt = DateTime.utc(2026, 12, 1, 9);
  final day = LocalDate(2026, 11, 22);

  late TestGraph t;
  late PerformanceUseCase performances;

  setUp(() async {
    t = await TestGraph.create();
    performances = t.graph.performance;
  });
  tearDown(() => t.close());

  Future<int> addApplication(int performanceId) =>
      DriftTicketApplicationRepository(t.database).create(
        TicketApplicationDraft(
          performanceId: performanceId,
          stage: TicketApplicationStage.planned,
          applyDeadlineAt: DateTime.utc(2026, 11, 25, 14, 59),
        ),
      );

  test('create trims the title and stores a blank venue as none', () async {
    final id = await performances.create(
      PerformanceDraft(title: '  Live  ', startsAt: startsAt, venue: '  '),
    );

    final saved = (await performances.find(id))!;
    expect(saved.title, 'Live');
    expect(saved.venue, isNull);
    expect(saved.startsAt, startsAt);
  });

  test('create and update reject a blank title', () async {
    final id = await performances.create(
      PerformanceDraft(title: 'Live', startsAt: startsAt),
    );

    expect(
      () =>
          performances.create(PerformanceDraft(title: ' ', startsAt: startsAt)),
      throwsA(isA<InvalidInputException>()),
    );
    expect(
      () => performances.update(
        id,
        PerformanceDraft(title: '', startsAt: startsAt),
      ),
      throwsA(isA<InvalidInputException>()),
    );
  });

  test(
    'deletionImpact counts required-category expenses and applications',
    () async {
      final id = await performances.create(
        PerformanceDraft(title: 'Live', startsAt: startsAt),
      );
      final partnerId = await DriftPartnerRepository(
        t.database,
      ).create(const PartnerDraft(name: 'A'));
      await t.graph.expense.record([
        ExpenseDraft(
          category: ExpenseCategory.ticket,
          amountYen: 5000,
          paidOn: day,
          performanceId: id,
        ),
        ExpenseDraft(
          category: ExpenseCategory.cheki,
          amountYen: 1000,
          paidOn: day,
          performanceId: id,
          partnerId: partnerId,
          shotCount: 1,
        ),
        ExpenseDraft(
          category: ExpenseCategory.goods,
          amountYen: 3000,
          paidOn: day,
          performanceId: id,
        ),
      ]);
      await addApplication(id);

      final impact = await performances.deletionImpact(id);

      expect(impact.expenseCount, 2);
      expect(impact.expenseTotalYen, 6000);
      expect(impact.applicationCount, 1);
    },
  );

  test('deletionImpact of an empty performance is zero', () async {
    final id = await performances.create(
      PerformanceDraft(title: 'Live', startsAt: startsAt),
    );

    final impact = await performances.deletionImpact(id);

    expect(
      (impact.expenseCount, impact.expenseTotalYen, impact.applicationCount),
      (0, 0, 0),
    );
  });

  test('delete removes the performance and its scheduled reminders', () async {
    final id = await performances.create(
      PerformanceDraft(title: 'Live', startsAt: startsAt),
    );
    await addApplication(id);
    await t.graph.reminders.rebuild();
    expect(t.scheduler.scheduled, isNotEmpty);

    await performances.delete(id);

    expect(await performances.find(id), isNull);
    expect(t.scheduler.scheduled, isEmpty);
  });

  test('update reschedules reminders with the new title', () async {
    final id = await performances.create(
      PerformanceDraft(title: 'Live', startsAt: startsAt),
    );
    await addApplication(id);

    await performances.update(
      id,
      PerformanceDraft(title: 'Renamed', startsAt: startsAt),
    );

    expect(
      t.scheduler.scheduled.map((r) => r.performanceTitle).toSet(),
      {'Renamed'},
    );
  });

  test('listAll returns the newest start first', () async {
    await performances.create(PerformanceDraft(title: 'A', startsAt: startsAt));
    await performances.create(
      PerformanceDraft(
        title: 'B',
        startsAt: startsAt.add(const Duration(days: 1)),
      ),
    );

    expect((await performances.listAll()).map((p) => p.title), ['B', 'A']);
  });
}
