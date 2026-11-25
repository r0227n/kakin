import 'package:app/application/application.dart';
import 'package:app/application/errors/record_error.dart';
import 'package:app/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/test_graph.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final sep = YearMonth(2026, 9);
  final oct = YearMonth(2026, 10);
  final nov = YearMonth(2026, 11);

  late TestGraph t;
  late BudgetUseCase budget;

  setUp(() async {
    // 2026-11-22 12:00 JST。
    t = await TestGraph.create();
    budget = t.graph.budget;
  });
  tearDown(() => t.close());

  test('currentMonth follows the JST calendar', () async {
    await t.close();
    t = await TestGraph.create(now: DateTime.utc(2026, 11, 30, 15));

    expect(t.graph.budget.currentMonth, YearMonth(2026, 12));
  });

  test('first configure stores the rate at the start month', () async {
    await budget.configure(startMonth: sep, monthlyYen: 30000);

    final plan = await budget.loadPlan();
    expect(plan.startMonth, sep);
    expect(plan.rates, {sep: 30000});
  });

  test('changing the amount applies from the current month only', () async {
    await budget.configure(startMonth: sep, monthlyYen: 30000);
    await budget.configure(startMonth: sep, monthlyYen: 40000);

    final plan = await budget.loadPlan();
    expect(plan.rates, {sep: 30000, nov: 40000});
    expect(plan.budgetFor(oct), 30000);
    expect(plan.budgetFor(nov), 40000);
  });

  test('configuring the same amount writes no new rate', () async {
    await budget.configure(startMonth: sep, monthlyYen: 30000);
    await budget.configure(startMonth: sep, monthlyYen: 30000);

    expect((await budget.loadPlan()).rates, {sep: 30000});
  });

  test('moving the start later drops earlier rates and overrides', () async {
    await budget.configure(startMonth: sep, monthlyYen: 30000);
    await budget.setOverride(sep, 1000);

    await budget.configure(startMonth: oct, monthlyYen: 30000);

    final plan = await budget.loadPlan();
    expect(plan.startMonth, oct);
    expect(plan.rates, {oct: 30000});
    expect(plan.overrides, isEmpty);
  });

  test('moving the start earlier keeps the earliest rate', () async {
    await budget.configure(startMonth: oct, monthlyYen: 30000);

    await budget.configure(startMonth: sep, monthlyYen: 30000);

    expect((await budget.loadPlan()).rates, {sep: 30000});
  });

  test('a future start month uses the amount from that month', () async {
    final jan = YearMonth(2027, 1);
    await budget.configure(startMonth: sep, monthlyYen: 30000);

    await budget.configure(startMonth: jan, monthlyYen: 50000);

    final plan = await budget.loadPlan();
    expect(plan.startMonth, jan);
    expect(plan.budgetFor(jan), 50000);
  });

  test('rejects a negative monthly amount before writing', () async {
    await expectLater(
      budget.configure(startMonth: sep, monthlyYen: -1),
      throwsA(
        isA<InvalidInputException>().having(
          (e) => e.field,
          'field',
          InputField.amount,
        ),
      ),
    );
    expect((await budget.loadPlan()).isConfigured, isFalse);
  });

  test('override replaces one month and can be cleared', () async {
    await budget.configure(startMonth: sep, monthlyYen: 30000);

    await budget.setOverride(oct, 5000);
    expect((await budget.loadPlan()).budgetFor(oct), 5000);
    expect((await budget.loadPlan()).budgetFor(nov), 30000);

    await budget.clearOverride(oct);
    expect((await budget.loadPlan()).budgetFor(oct), 30000);
  });

  test('override is rejected before the start month or when unset', () async {
    await expectLater(
      budget.setOverride(oct, 1000),
      throwsA(isA<InvalidInputException>()),
    );
    await budget.configure(startMonth: oct, monthlyYen: 30000);
    await expectLater(
      budget.setOverride(sep, 1000),
      throwsA(isA<InvalidInputException>()),
    );
    await expectLater(
      budget.setOverride(oct, -1),
      throwsA(isA<InvalidInputException>()),
    );
    expect((await budget.loadPlan()).overrides, isEmpty);
  });
}
