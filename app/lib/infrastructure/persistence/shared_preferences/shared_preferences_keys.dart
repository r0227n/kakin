import 'package:app/domain/domain.dart';

/// 保存キーの型。文字列との相互変換は永続化 adapter 内に閉じ込める。
extension type const SharedPreferencesKey(String value) {
  /// テーマの固定保存キー。
  static const appTheme = SharedPreferencesKey('app.theme');

  /// 言語の固定保存キー。
  static const appLocale = SharedPreferencesKey('app.language');

  /// 計上基準の初期値の保存キー。
  static const defaultAccountingBasis = SharedPreferencesKey(
    'ledger.default_basis',
  );

  /// 金額を表示するかの保存キー。
  static const amountsVisible = SharedPreferencesKey('ledger.amounts_visible');

  /// 申込締切のリマインドの保存キー。
  static const reminderApply = SharedPreferencesKey('reminder.apply');

  /// 当落発表日時のリマインドの保存キー。
  static const reminderResult = SharedPreferencesKey('reminder.result');

  /// 入金期限のリマインドの保存キー。
  static const reminderPayment = SharedPreferencesKey('reminder.payment');

  /// 初回起動の案内を終えたかの保存キー。
  static const onboardingCompleted = SharedPreferencesKey(
    'onboarding.completed',
  );

  /// 通知の許可を求めたかの保存キー。
  static const notificationPermissionRequested = SharedPreferencesKey(
    'reminder.permission_requested',
  );

  /// [kind] のリマインドの保存キー。
  static SharedPreferencesKey reminder(TicketDeadlineKind kind) =>
      switch (kind) {
        TicketDeadlineKind.apply => reminderApply,
        TicketDeadlineKind.result => reminderResult,
        TicketDeadlineKind.payment => reminderPayment,
      };
}
