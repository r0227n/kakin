import 'package:app/domain/domain.dart';
import 'package:app/presentation/shared/keys/app_keys.dart';
import 'package:flutter/widgets.dart';
import 'package:patrol/patrol.dart';

import 'support/flows.dart';
import 'support/kakin_app.dart';

void main() {
  patrolTest('cheki for two partners created on the spot', ($) async {
    await launchKakin($, onboarded: true);

    await $(AppKeys.addExpense).tap();
    await $(AppKeys.category(ExpenseCategory.cheki)).tap();
    await createPerformanceFromPicker(
      $,
      opener: AppKeys.expensePerformance,
      title: '生誕祭',
    );

    await $(AppKeys.pickPartnersEmpty).tap();
    await $(AppKeys.partnerCreate).tap();
    await $(AppKeys.partnerNameField).enterText('ひかり');
    await $(AppKeys.partnerSave).tap();
    await $(AppKeys.partnerCreate).tap();
    await $(AppKeys.partnerNameField).enterText('みお');
    await $(AppKeys.partnerSave).tap();
    await $(AppKeys.partnerPickerConfirm).tap();

    await $(AppKeys.chekiIncrease(2)).tap();
    await $(AppKeys.keypad('2')).tap();
    await $(AppKeys.keypad('00')).tap();
    await $(AppKeys.keypad('0')).tap();
    await $(AppKeys.expenseSave).tap();

    await $(
      AppKeys.summarySpendTotal,
    ).which<Text>((text) => text.data == '¥6,000').waitUntilVisible();
    await $(AppKeys.tabList).tap();
    await $(AppKeys.expenseRow(1)).waitUntilVisible();
    await $(AppKeys.expenseRow(2)).waitUntilVisible();
  });
}
