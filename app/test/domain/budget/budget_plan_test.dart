import 'package:app/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final sep = YearMonth(2026, 9);
  final oct = YearMonth(2026, 10);
  final nov = YearMonth(2026, 11);
  final dec = YearMonth(2026, 12);

  test('unconfigured plan has no start month and no budget', () {
    final plan = BudgetPlan.unconfigured;

    expect(plan.isConfigured, isFalse);
    expect(plan.startMonth, isNull);
    expect(plan.budgetFor(nov), isNull);
  });

  test('start month is the earliest rate month regardless of map order', () {
    final plan = BudgetPlan(rates: {nov: 40000, sep: 30000});

    expect(plan.startMonth, sep);
  });

  test('a rate applies from its month until the next rate', () {
    final plan = BudgetPlan(rates: {sep: 30000, nov: 40000});

    expect(plan.monthlyRateAt(YearMonth(2026, 8)), isNull);
    expect(plan.monthlyRateAt(sep), 30000);
    expect(plan.monthlyRateAt(oct), 30000);
    expect(plan.monthlyRateAt(nov), 40000);
    expect(plan.monthlyRateAt(YearMonth(2027, 5)), 40000);
  });

  test('an override replaces only its own month', () {
    final plan = BudgetPlan(rates: {sep: 30000}, overrides: {oct: 50000});

    expect(plan.budgetFor(sep), 30000);
    expect(plan.budgetFor(oct), 50000);
    expect(plan.budgetFor(nov), 30000);
    expect(plan.monthlyRateAt(oct), 30000);
  });

  test('months before the start have no budget even with an override', () {
    final plan = BudgetPlan(
      rates: {nov: 30000},
      overrides: {oct: 50000},
    );

    expect(plan.budgetFor(oct), isNull);
    expect(plan.budgetFor(dec), 30000);
  });

  test('rates and overrides cannot be mutated', () {
    final plan = BudgetPlan(rates: {sep: 30000});

    expect(() => plan.rates[oct] = 1, throwsUnsupportedError);
    expect(() => plan.overrides[oct] = 1, throwsUnsupportedError);
  });
}
