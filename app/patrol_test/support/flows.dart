import 'package:app/presentation/shared/keys/app_keys.dart';
import 'package:flutter/widgets.dart';
import 'package:patrol/patrol.dart';

/// 初回起動の案内で月の推し活代を [budget] に決め、Gmail 連携を飛ばす。
Future<void> completeOnboarding(
  PatrolIntegrationTester $, {
  required String budget,
}) async {
  await $(AppKeys.onboardingStart).tap();
  await $(AppKeys.budgetAmount).enterText(budget);
  await $(AppKeys.onboardingBudgetSave).tap();
  await $(AppKeys.onboardingGmailSkip).tap();
}

/// 公演の選択シートから、今日の公演 [title] を登録して選ぶ。
///
/// [opener] はシートを開くボタン。
Future<void> createPerformanceFromPicker(
  PatrolIntegrationTester $, {
  required Key opener,
  required String title,
}) async {
  await $(opener).tap();
  await $(AppKeys.performanceCreate).tap();
  await $(AppKeys.performanceTitleField).enterText(title);
  await $(AppKeys.performanceSave).tap();
}
