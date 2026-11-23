import 'package:app/application/models/gmail.dart';

/// Gmail からチケットサービスのメールを読む契約。
abstract interface class GmailMailbox {
  /// モックデータを返す実装か。
  bool get isDemo;

  /// 利用者の操作で連携し、アカウントのアドレスを返す。
  ///
  /// 利用者が取り消したときは null。
  Future<String?> connect();

  /// 前回の連携を操作なしで復元する。復元できなければ null。
  Future<String?> restore();

  /// [after] 以降に受信した対象メールのうち、公演情報を読み取れたもの。
  ///
  /// 再連携が必要な失敗は GmailReauthRequiredException、
  /// それ以外は GmailSyncException を投げる。
  Future<List<TicketMail>> fetchTicketMails({required DateTime after});

  /// 連携を解除する。
  Future<void> disconnect();
}

/// Gmail の同期状態と取り込み履歴の永続化契約。
abstract interface class GmailImportRepository {
  /// 連携中のアカウントの同期状態。未連携なら null。
  Future<GmailConnection?> loadConnection();

  /// 連携した状態を保存する。
  Future<void> saveConnection(String accountEmail, DateTime connectedAt);

  /// 同期状態を消す。取り込み履歴は残す。
  Future<void> deleteConnection(String accountEmail);

  /// [messageIds] のうち取り込み済みのもの。
  Future<Set<String>> importedMessageIds(
    String accountEmail,
    Iterable<String> messageIds,
  );

  /// 取り込んだメールを記録して ID を返す。
  Future<int> recordImport(String accountEmail, TicketMail mail);

  /// 取り込み履歴にチケット申込を結びつける。
  Future<void> linkApplication(int importId, int applicationId);

  /// 同期の成功を記録する。
  Future<void> recordSuccess(
    String accountEmail, {
    required DateTime fetchedAt,
    DateTime? lastMessageReceivedAt,
  });

  /// 同期の失敗を記録する。最終同期日時は変えない。
  Future<void> recordFailure(
    String accountEmail, {
    required DateTime failedAt,
    required GmailFailureKind kind,
  });
}

/// 複数の書き込みを1つのトランザクションで行う契約。
// A single-purpose interface keeps use cases independent of the database.
// ignore: one_member_abstracts
abstract interface class UnitOfWork {
  /// [action] の中の書き込みをまとめて確定する。失敗したらすべて戻す。
  Future<T> run<T>(Future<T> Function() action);
}
