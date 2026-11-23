import 'package:app/application/models/app_preferences.dart';
import 'package:app/domain/domain.dart';

/// アプリ設定の永続化契約。保存失敗は呼び出し元へ伝える。
abstract interface class AppPreferencesRepository {
  /// 初期化済みの保存先から設定を読み込む。
  AppPreferencesSnapshot load();

  /// 他の設定を変更せずテーマを保存する。
  Future<void> saveTheme(AppThemePreference theme);

  /// 他の設定を変更せず言語を保存する。
  Future<void> saveLocale(LocalePreference locale);

  /// 計上基準の初期値を保存する。
  Future<void> saveDefaultAccountingBasis(AccountingBasis basis);

  /// 金額を表示するかを保存する。
  Future<void> saveAmountsVisible({required bool visible});

  /// 期限の種類ごとのリマインドのオンとオフを保存する。
  Future<void> saveReminderEnabled(
    TicketDeadlineKind kind, {
    required bool enabled,
  });

  /// 初回起動の案内を最後まで進めたことを保存する。
  Future<void> saveOnboardingCompleted();

  /// OS に通知の許可を求めたことを保存する。
  Future<void> saveNotificationPermissionRequested();
}
