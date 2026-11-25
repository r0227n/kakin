import 'package:app/domain/domain.dart';
import 'package:app/presentation/shared/keys/app_keys.dart';
import 'package:flutter/widgets.dart';
import 'package:patrol/patrol.dart';

import 'support/flows.dart';
import 'support/kakin_app.dart';

void main() {
  patrolTest('a ticketed performance shows in the upcoming tab', ($) async {
    await launchKakin($, onboarded: true);

    await $(AppKeys.addExpense).tap();
    await $(AppKeys.category(ExpenseCategory.ticket)).tap();
    await createPerformanceFromPicker(
      $,
      opener: AppKeys.expensePerformance,
      title: 'ワンマンライブ',
    );
    await $(AppKeys.keypad('5')).tap();
    await $(AppKeys.keypad('00')).tap();
    await $(AppKeys.keypad('0')).tap();
    await $(AppKeys.expenseSave).tap();
    await $(AppKeys.tabUpcoming).tap();
    await $(AppKeys.upcomingPerformance(1)).tap();

    await $(
      AppKeys.performanceTitle,
    ).which<Text>((text) => text.data == 'ワンマンライブ').waitUntilVisible();
  });
}
