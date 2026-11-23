import 'package:app/domain/domain.dart';
import 'package:app/presentation/shared/keys/app_keys.dart';
import 'package:patrol/patrol.dart';

import 'support/flows.dart';
import 'support/kakin_app.dart';

void main() {
  patrolTest('paying from the to-do list can be undone', ($) async {
    await launchKakin($, onboarded: true);

    await $(AppKeys.tabUpcoming).tap();
    await $(AppKeys.addApplication).tap();
    await createPerformanceFromPicker(
      $,
      opener: AppKeys.applicationPerformance,
      title: 'ワンマンライブ',
    );
    await $(AppKeys.stage(TicketApplicationStage.awaitingPayment)).tap();
    await $(
      AppKeys.deadline(TicketDeadlineKind.payment),
    ).scrollTo(view: $(AppKeys.applicationScroll)).tap();
    // 日付と時刻のピッカーは Flutter 標準のダイアログで key を付けられない。
    await $('OK').tap();
    await $('OK').tap();
    await $(AppKeys.applicationSave).tap();
    await $.platform.mobile.grantPermissionWhenInUse();

    await $(AppKeys.todoAction(1, QuickStageAction.paid)).tap();
    await $(AppKeys.undoStageChange).tap();

    await $(AppKeys.todo(1, TicketDeadlineKind.payment)).waitUntilVisible();
  });
}
