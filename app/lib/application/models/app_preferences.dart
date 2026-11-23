import 'package:app/domain/domain.dart';

/// Flutter の ThemeMode から独立したテーマ設定。
enum AppThemePreference { system, light, dark }

/// 保存する言語。端末の Locale 型は presentation で変換する。
final class LocalePreference {
  /// 言語コードを指定して保存用の値を作る。
  const LocalePreference({required this.languageCode});

  /// ISO 639 の言語コード。
  final String languageCode;
}

/// 永続化境界で受け渡すアプリ設定。
final class AppPreferencesSnapshot {
  /// 未設定の言語は起動時に端末の優先言語から解決する。
  const AppPreferencesSnapshot({
    this.theme = AppThemePreference.system,
    this.locale,
    this.defaultAccountingBasis = AccountingBasis.paidOn,
    this.amountsVisible = true,
    this.onboardingCompleted = false,
  });

  /// 保存済みのテーマ。未設定の場合は端末の明暗設定に従う。
  final AppThemePreference theme;

  /// 明示的な言語選択。null は端末の言語を使用する。
  final LocalePreference? locale;

  /// カレンダーとリストを開いたときの計上基準。
  final AccountingBasis defaultAccountingBasis;

  /// カレンダーとリストに金額を表示するか。
  final bool amountsVisible;

  /// 初回起動の案内を最後まで進めたか。
  final bool onboardingCompleted;
}
