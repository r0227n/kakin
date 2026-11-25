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

  /// 初回起動の案内を終えたかの保存キー。
  static const onboardingCompleted = SharedPreferencesKey(
    'onboarding.completed',
  );
}
