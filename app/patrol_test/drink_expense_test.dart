import 'package:app/domain/domain.dart';
import 'package:app/presentation/shared/keys/app_keys.dart';
import 'package:flutter/widgets.dart';
import 'package:patrol/patrol.dart';

import 'support/flows.dart';
import 'support/kakin_app.dart';

void main() {
  patrolTest('a drink added from the calendar shows in the list and balance', (
    $,
  ) async {
    await launchKakin($);
    await completeOnboarding($, budget: '20000');

    await $(AppKeys.addExpense).tap();
    await $(AppKeys.category(ExpenseCategory.drink)).tap();
    await createPerformanceFromPicker(
      $,
      opener: AppKeys.expensePerformance,
      title: '定期公演',
    );
    await $(AppKeys.keypad('7')).tap();
    await $(AppKeys.keypad('00')).tap();
    await $(AppKeys.expenseSave).tap();

    await $(
      AppKeys.summaryBalance,
    ).which<Text>((text) => text.data == '¥19,300').waitUntilVisible();
    await $(AppKeys.tabList).tap();
    await $(AppKeys.expenseRow(1)).waitUntilVisible();
  });
}
