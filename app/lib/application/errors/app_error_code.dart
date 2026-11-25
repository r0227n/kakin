/// UI とログで共有する安定した失敗分類。
enum AppErrorCode {
  /// 設定の永続化に失敗した。
  settingsWrite('settings.write'),

  /// 記録の読み書きに失敗した。
  recordStorage('record.storage'),

  /// 入力値が規則に合わない。
  invalidInput('input.invalid'),

  /// チェキ代の記録があるチェキ相手は削除できない。
  partnerInUse('partner.in_use'),

  /// アイコン画像を保存・選択できなかった。
  partnerIcon('partner.icon'),

  /// Gmail の再連携が必要。
  gmailReauthRequired('gmail.reauth_required'),

  /// Gmail の連携や同期に失敗した。
  gmailSync('gmail.sync'),

  /// 分類されていない不具合。
  unexpected('unexpected');

  const AppErrorCode(this.value);

  /// enum の名前や順序に依存しない公開コード。
  final String value;
}
