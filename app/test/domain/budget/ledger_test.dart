import 'package:app/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final aug = YearMonth(2026, 8);
  final sep = YearMonth(2026, 9);
  final oct = YearMonth(2026, 10);
  final nov = YearMonth(2026, 11);

  test('returns null when the budget is not configured', () {
    expect(
      ledgerFor(
        plan: BudgetPlan.unconfigured,
        spendByMonth: {sep: 1000},
        month: sep,
      ),
      isNull,
    );
  });

  test('returns null for a month before the start month', () {
    expect(
      ledgerFor(
        plan: BudgetPlan(rates: {sep: 30000}),
        spendByMonth: const {},
        month: aug,
      ),
      isNull,
    );
  });

  test('the start month has no carryover', () {
    final month = ledgerFor(
      plan: BudgetPlan(rates: {sep: 30000}),
      spendByMonth: {sep: 12000},
      month: sep,
    )!;

    expect(month.carryoverYen, 0);
    expect(month.budgetYen, 30000);
    expect(month.spendYen, 12000);
    expect(month.balanceYen, 18000);
  });

  test('carries each balance into the next month, including deficits', () {
    final plan = BudgetPlan(rates: {sep: 30000}, overrides: {oct: 10000});
    final spend = {sep: 25000, oct: 20000, nov: 1000};

    final october = ledgerFor(plan: plan, spendByMonth: spend, month: oct)!;
    final november = ledgerFor(plan: plan, spendByMonth: spend, month: nov)!;

    expect(october.carryoverYen, 5000);
    expect(october.budgetYen, 10000);
    expect(october.balanceYen, -5000);
    expect(november.carryoverYen, -5000);
    expect(november.budgetYen, 30000);
    expect(november.balanceYen, 24000);
  });

  test('ignores spend recorded before the start month', () {
    final month = ledgerFor(
      plan: BudgetPlan(rates: {sep: 30000}),
      spendByMonth: {aug: 99999, sep: 1000},
      month: oct,
    )!;

    expect(month.carryoverYen, 29000);
    expect(month.spendYen, 0);
    expect(month.balanceYen, 59000);
  });

  test('crosses the year boundary', () {
    final dec = YearMonth(2026, 12);
    final jan = YearMonth(2027, 1);
    final month = ledgerFor(
      plan: BudgetPlan(rates: {dec: 10000}),
      spendByMonth: {dec: 4000},
      month: jan,
    )!;

    expect(month.month, jan);
    expect(month.carryoverYen, 6000);
  });
}
