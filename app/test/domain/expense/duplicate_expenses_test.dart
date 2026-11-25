import 'package:app/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final day = LocalDate(2026, 11, 22);

  ExpenseFacts facts(
    int id, {
    ExpenseCategory category = ExpenseCategory.drink,
    LocalDate? paidOn,
    int? performanceId = 1,
  }) => ExpenseFacts(
    id: id,
    category: category,
    paidOn: paidOn ?? day,
    performanceId: performanceId,
  );

  test('flags every entry of a same performance, day and category group', () {
    expect(duplicateExpenseIds([facts(1), facts(2), facts(3)]), {1, 2, 3});
  });

  test('a single entry is not a duplicate', () {
    expect(duplicateExpenseIds([facts(1)]), isEmpty);
  });

  test('differing performance, paid date or category are not duplicates', () {
    expect(
      duplicateExpenseIds([
        facts(1),
        facts(2, performanceId: 2),
        facts(3, paidOn: day.addDays(1)),
        facts(4, category: ExpenseCategory.ticket),
      ]),
      isEmpty,
    );
  });

  test('cheki entries are never flagged', () {
    expect(
      duplicateExpenseIds([
        facts(1, category: ExpenseCategory.cheki),
        facts(2, category: ExpenseCategory.cheki),
      ]),
      isEmpty,
    );
  });

  test('entries without a performance are never flagged', () {
    expect(
      duplicateExpenseIds([
        facts(1, category: ExpenseCategory.goods, performanceId: null),
        facts(2, category: ExpenseCategory.goods, performanceId: null),
      ]),
      isEmpty,
    );
  });

  test('only the duplicated group is returned', () {
    expect(
      duplicateExpenseIds([
        facts(1, category: ExpenseCategory.ticket),
        facts(2),
        facts(3),
      ]),
      {2, 3},
    );
  });
}
