import 'package:app/domain/domain.dart';
import 'package:app/presentation/shared/keys/app_keys.dart';
import 'package:flutter/widgets.dart';
import 'package:patrol/patrol.dart';

import 'support/flows.dart';
import 'support/kakin_app.dart';

void main() {
  patrolTest('deleting a performance confirms what goes with it', ($) async {
    await launchKakin($, onboarded: true);

    await $(AppKeys.addExpense).tap();
    await $(AppKeys.category(ExpenseCategory.drink)).tap();
    await createPerformanceFromPicker(
      $,
      opener: AppKeys.expensePerformance,
      title: '対バン',
    );
    await $(AppKeys.keypad('7')).tap();
    await $(AppKeys.keypad('00')).tap();
    await $(AppKeys.expenseSave).tap();

    await $(AppKeys.dayPerformance(1)).tap();
    await $(AppKeys.addApplicationForPerformance).tap();
    await $(AppKeys.applicationSave).tap();
    await $(AppKeys.deletePerformance).tap();
    await $(AppKeys.confirmBody)
        .which<Text>(
          (text) =>
              text.data!.contains('1件（¥700）') &&
              text.data!.contains('チケット申込 1件'),
        )
        .waitUntilVisible();
    await $(AppKeys.confirmOk).tap();
    await $(AppKeys.tabList).tap();

    await $(AppKeys.expenseListEmpty).waitUntilVisible();
  });
}
