/// 決済完了メールを取り込めるチケットサービス。
enum TicketMailService {
  /// eplus。
  eplus,

  /// ライブポケット。
  livepocket,
}

/// 公演情報を読み取れたチケットサービスの決済完了メール。本文は持たない。
final class TicketMail {
  /// 読み取った値を保持する。
  const TicketMail({
    required this.messageId,
    required this.receivedAt,
    required this.subject,
    required this.service,
    required this.title,
    required this.startsAt,
    required this.priceYen,
    this.venue,
  });

  /// Gmail のメッセージ ID。
  final String messageId;

  /// Gmail の受信日時（UTC）。
  final DateTime receivedAt;

  /// 件名。
  final String subject;

  /// チケットサービス。
  final TicketMailService service;

  /// 公演名。
  final String title;

  /// 公演の開始日時（UTC）。
  final DateTime startsAt;

  /// 会場名。
  final String? venue;

  /// 支払った金額（円）。
  final int priceYen;
}

/// 同期の失敗の種類。
enum GmailFailureKind {
  /// 認証の期限切れなどで再連携が必要。
  reauthRequired,

  /// それ以外の失敗。
  other,
}

/// Gmail 連携の状態。
final class GmailConnection {
  /// 保存済みの同期状態。
  const GmailConnection({
    required this.accountEmail,
    required this.connectedAt,
    this.lastFetchedAt,
    this.lastMessageReceivedAt,
    this.lastFailedAt,
    this.lastFailureKind,
  });

  /// 連携したアカウント。
  final String accountEmail;

  /// 連携した日時。初回同期の取得範囲の基準。
  final DateTime connectedAt;

  /// 最後に同期が成功した日時。
  final DateTime? lastFetchedAt;

  /// 取り込んだメールの受信日時の最大値。
  final DateTime? lastMessageReceivedAt;

  /// 最後に同期が失敗した日時。成功すると null に戻る。
  final DateTime? lastFailedAt;

  /// 最後の失敗の種類。
  final GmailFailureKind? lastFailureKind;

  /// 次の同期で取得するメールの受信日時の下限。
  DateTime get fetchAfter {
    final watermark = lastMessageReceivedAt;
    if (watermark != null) return watermark.subtract(const Duration(days: 3));
    final c = connectedAt.toUtc();
    return DateTime.utc(c.year, c.month - 3, c.day, c.hour, c.minute);
  }
}

/// Gmail 連携の表示用の状態。
final class GmailStatus {
  /// 連携先の種類と連携の状態を持つ。
  const GmailStatus({required this.isDemo, this.connection});

  /// モックデータで動いているか。
  final bool isDemo;

  /// 連携の状態。未連携なら null。
  final GmailConnection? connection;
}

/// 1回の同期の結果。
final class GmailSyncResult {
  /// 取り込んだ件数を持つ。
  const GmailSyncResult({required this.importedMailCount});

  /// 取り込んだメールの数。メール1通につきチケット代を1件登録する。
  final int importedMailCount;
}
