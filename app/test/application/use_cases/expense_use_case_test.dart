import 'package:app/application/application.dart';
import 'package:app/application/errors/record_error.dart';
import 'package:app/domain/domain.dart';
import 'package:app/infrastructure/infrastructure.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/test_graph.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final day = LocalDate(2026, 11, 22);

  late TestGraph t;
  late ExpenseUseCase expenses;
  late int performanceId;
  late int partnerId;

  setUp(() async {
    t = await TestGraph.create();
    expenses = t.graph.expense;
    performanceId = await t.graph.performance.create(
      PerformanceDraft(title: 'Live', startsAt: DateTime.utc(2026, 11, 22, 9)),
    );
    partnerId = await DriftPartnerRepository(
      t.database,
    ).create(const PartnerDraft(name: 'A'));
  });
  tearDown(() => t.close());

  ExpenseDraft draft(
    ExpenseCategory category, {
    int amount = 1000,
    bool withPerformance = true,
    bool withPartner = false,
    int? shots,
    String? note,
  }) => ExpenseDraft(
    category: category,
    amountYen: amount,
    paidOn: day,
    performanceId: withPerformance ? performanceId : null,
    partnerId: withPartner ? partnerId : null,
    shotCount: shots,
    note: note,
  );

  Matcher invalid(InputField field) => throwsA(
    isA<InvalidInputException>().having((e) => e.field, 'field', field),
  );

  test('records drafts in order and returns their ids', () async {
    final ids = await expenses.record([
      draft(ExpenseCategory.cheki, withPartner: true, shots: 2),
      draft(ExpenseCategory.cheki, withPartner: true, shots: 1, amount: 500),
    ]);

    expect(ids, hasLength(2));
    expect((await expenses.find(ids[0]))!.shotCount, 2);
    expect((await expenses.find(ids[1]))!.amountYen, 500);
  });

  test('rejects an empty batch', () {
    expect(() => expenses.record(const []), invalid(InputField.partner));
  });

  test('rejects a negative amount', () {
    expect(
      () => expenses.record([draft(ExpenseCategory.goods, amount: -1)]),
      invalid(InputField.amount),
    );
  });

  test('ticket, drink and cheki require a performance', () {
    for (final category in [
      ExpenseCategory.ticket,
      ExpenseCategory.drink,
      ExpenseCategory.cheki,
    ]) {
      expect(
        () => expenses.record([draft(category, withPerformance: false)]),
        invalid(InputField.performance),
        reason: category.name,
      );
    }
  });

  test('cheki requires a partner and at least one shot', () {
    expect(
      () => expenses.record([draft(ExpenseCategory.cheki, shots: 1)]),
      invalid(InputField.partner),
    );
    expect(
      () => expenses.record([
        draft(ExpenseCategory.cheki, withPartner: true, shots: 0),
      ]),
      invalid(InputField.shotCount),
    );
  });

  test('a rejected draft in a batch records nothing', () async {
    expect(
      () => expenses.record([
        draft(ExpenseCategory.goods),
        draft(ExpenseCategory.goods, amount: -1),
      ]),
      invalid(InputField.amount),
    );
    expect(
      await DriftExpenseRepository(t.database).monthlySpendByPaidOn(),
      isEmpty,
    );
  });

  test(
    'drops cheki-only fields from other categories and trims notes',
    () async {
      final [id] = await expenses.record([
        draft(
          ExpenseCategory.goods,
          withPartner: true,
          shots: 3,
          note: '  towel  ',
        ),
      ]);

      final saved = (await expenses.find(id))!;
      expect(saved.partner, isNull);
      expect(saved.shotCount, isNull);
      expect(saved.note, 'towel');
    },
  );

  test('a blank note is stored as no note', () async {
    final [id] = await expenses.record([
      draft(ExpenseCategory.transport, withPerformance: false, note: '   '),
    ]);

    expect((await expenses.find(id))!.note, isNull);
  });

  test('update validates and replaces the fields', () async {
    final [id] = await expenses.record([draft(ExpenseCategory.drink)]);

    expect(
      () => expenses.update(id, draft(ExpenseCategory.drink, amount: -5)),
      invalid(InputField.amount),
    );
    await expenses.update(id, draft(ExpenseCategory.drink, amount: 700));

    expect((await expenses.find(id))!.amountYen, 700);
  });

  test('latestDrinkAmount returns the most recently recorded drink', () async {
    expect(await expenses.latestDrinkAmount(), isNull);

    await expenses.record([draft(ExpenseCategory.drink, amount: 600)]);
    await expenses.record([draft(ExpenseCategory.goods, amount: 3000)]);
    await expenses.record([draft(ExpenseCategory.drink, amount: 700)]);

    expect(await expenses.latestDrinkAmount(), 700);
  });

  test('delete removes the expense', () async {
    final [id] = await expenses.record([draft(ExpenseCategory.goods)]);

    await expenses.delete(id);

    expect(await expenses.find(id), isNull);
  });
}
