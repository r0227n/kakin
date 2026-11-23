import 'package:app/presentation/shared/keys/app_keys.dart';
import 'package:flutter/widgets.dart';
import 'package:patrol/patrol.dart';

import 'support/flows.dart';
import 'support/kakin_app.dart';

void main() {
  patrolTest('onboarding sets the budget and skips Gmail', ($) async {
    await launchKakin($);

    await completeOnboarding($, budget: '20000');

    await $(AppKeys.monthCalendar).waitUntilVisible();
    await $(
      AppKeys.summaryBalance,
    ).which<Text>((text) => text.data == '¥20,000').waitUntilVisible();
  });
}
