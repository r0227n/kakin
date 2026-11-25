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
    'deletionImpact counts only required-category expenses',
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

      final impact = await performances.deletionImpact(id);

      expect(impact.expenseCount, 2);
      expect(impact.expenseTotalYen, 6000);
    },
  );

  test('deletionImpact of an empty performance is zero', () async {
    final id = await performances.create(
      PerformanceDraft(title: 'Live', startsAt: startsAt),
    );

    final impact = await performances.deletionImpact(id);

    expect((impact.expenseCount, impact.expenseTotalYen), (0, 0));
  });

  test('delete removes the performance', () async {
    final id = await performances.create(
      PerformanceDraft(title: 'Live', startsAt: startsAt),
    );

    await performances.delete(id);

    expect(await performances.find(id), isNull);
  });

  test(
    'listUpcoming returns ticketed performances from today, soonest first',
    () async {
      Future<int> add(String title, DateTime at, {bool ticket = true}) async {
        final id = await performances.create(
          PerformanceDraft(title: title, startsAt: at),
        );
        await t.graph.expense.record([
          ExpenseDraft(
            category: ticket ? ExpenseCategory.ticket : ExpenseCategory.goods,
            amountYen: 5000,
            paidOn: day,
            performanceId: id,
          ),
        ]);
        return id;
      }

      // 時計は日本時間の 2026-11-22 12:00。
      await add('Later', DateTime.utc(2026, 12, 1, 9));
      await add('Tonight', DateTime.utc(2026, 11, 22, 10));
      await add('Yesterday', DateTime.utc(2026, 11, 21, 10));
      await add('Goods only', DateTime.utc(2026, 11, 30, 10), ticket: false);

      final upcoming = await performances.listUpcoming();

      expect(
        [for (final u in upcoming) (u.performance.title, u.daysUntil)],
        [('Tonight', 0), ('Later', 9)],
      );
    },
  );

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
