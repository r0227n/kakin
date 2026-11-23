import 'package:app/domain/domain.dart';

/// 公演。開始日時は1つで、複数日の公演は初日で登録する。
final class Performance {
  /// 保存済みの公演。
  const Performance({
    required this.id,
    required this.title,
    required this.startsAt,
    this.venue,
  });

  /// 主キー。
  final int id;

  /// 公演名。空にはできない。
  final String title;

  /// 開始日時（UTC）。
  final DateTime startsAt;

  /// 会場名。
  final String? venue;

  /// 日本時間の開始日。
  LocalDate get startsOn => JapanTime.dateOf(startsAt);
}

/// 公演の入力値。
final class PerformanceDraft {
  /// [title] の前後の空白は保存前に除く。
  const PerformanceDraft({
    required this.title,
    required this.startsAt,
    this.venue,
  });

  /// 公演名。
  final String title;

  /// 開始日時。
  final DateTime startsAt;

  /// 会場名。空なら未入力として扱う。
  final String? venue;
}

/// 公演を削除すると一緒に消えるもの。
final class PerformanceDeletionImpact {
  /// 削除前に集計した件数と金額。
  const PerformanceDeletionImpact({
    required this.expenseCount,
    required this.expenseTotalYen,
    required this.applicationCount,
  });

  /// 消える支出（チケット代・ドリンク代・チェキ代）の件数。
  final int expenseCount;

  /// 消える支出の合計額。
  final int expenseTotalYen;

  /// 消えるチケット申込の件数。
  final int applicationCount;
}

/// チェキ相手。同じ名前の相手を複数登録でき、所属で見分ける。
final class Partner {
  /// 保存済みのチェキ相手。
  const Partner({
    required this.id,
    required this.name,
    this.groupName,
    this.iconFile,
    this.firstShotOn,
    this.lastShotOn,
    this.chekiCount = 0,
    this.shotTotal = 0,
  });

  /// 主キー。
  final int id;

  /// 名前。
  final String name;

  /// 所属（グループ名など）。
  final String? groupName;

  /// アイコン画像のファイル名。
  final String? iconFile;

  /// 最初にチェキ代を記録した支払日。
  final LocalDate? firstShotOn;

  /// 最後にチェキ代を記録した支払日。
  final LocalDate? lastShotOn;

  /// 撮影枚数の合計。
  final int shotTotal;

  /// チェキ代の記録数。0 の相手だけ削除できる。
  final int chekiCount;
}

/// チェキ相手の入力値。
final class PartnerDraft {
  /// [name] の前後の空白は保存前に除く。
  const PartnerDraft({required this.name, this.groupName});

  /// 名前。
  final String name;

  /// 所属。空なら未入力として扱う。
  final String? groupName;
}

/// 支出。
final class Expense {
  /// 保存済みの支出。
  const Expense({
    required this.id,
    required this.category,
    required this.amountYen,
    required this.paidOn,
    required this.isImported,
    this.performance,
    this.partner,
    this.shotCount,
    this.note,
  });

  /// 主キー。
  final int id;

  /// カテゴリ。
  final ExpenseCategory category;

  /// 金額（円）。手数料を含め実際に払った額。
  final int amountYen;

  /// 支払日。
  final LocalDate paidOn;

  /// Gmail から取り込んだか。編集しても変わらない。
  final bool isImported;

  /// 紐づく公演。
  final Performance? performance;

  /// チェキ相手。チェキ代だけが持つ。
  final Partner? partner;

  /// 撮影枚数。チェキ代だけが持つ。
  final int? shotCount;

  /// メモ。
  final String? note;

  /// [basis] で支出を置く日。
  LocalDate placedOn(AccountingBasis basis) =>
      basis == AccountingBasis.performanceDate && performance != null
      ? performance!.startsOn
      : paidOn;

  /// 二重計上の判定に使う事実。
  ExpenseFacts get facts => ExpenseFacts(
    id: id,
    category: category,
    paidOn: paidOn,
    performanceId: performance?.id,
  );
}

/// 支出の入力値。
final class ExpenseDraft {
  /// カテゴリごとの必須項目は use case が検証する。
  const ExpenseDraft({
    required this.category,
    required this.amountYen,
    required this.paidOn,
    this.performanceId,
    this.partnerId,
    this.shotCount,
    this.note,
  });

  /// カテゴリ。
  final ExpenseCategory category;

  /// 金額（円）。
  final int amountYen;

  /// 支払日。
  final LocalDate paidOn;

  /// 紐づく公演。
  final int? performanceId;

  /// チェキ相手。
  final int? partnerId;

  /// 撮影枚数。
  final int? shotCount;

  /// メモ。空なら未入力として扱う。
  final String? note;
}

/// チケット申込。金額は持たない。
final class TicketApplication {
  /// 保存済みのチケット申込。
  const TicketApplication({
    required this.id,
    required this.performance,
    required this.stage,
    required this.createdAt,
    required this.isImported,
    this.service,
    this.referenceNo,
    this.applyDeadlineAt,
    this.resultAt,
    this.paymentDeadlineAt,
    this.note,
  });

  /// 主キー。
  final int id;

  /// 申し込む公演。
  final Performance performance;

  /// 申込段階。
  final TicketApplicationStage stage;

  /// 登録日時（UTC）。
  final DateTime createdAt;

  /// Gmail から作られた、または Gmail で段階が進んだか。
  final bool isImported;

  /// チケットサービス。
  final TicketServiceKind? service;

  /// 受付番号。
  final String? referenceNo;

  /// 申込締切（UTC）。
  final DateTime? applyDeadlineAt;

  /// 当落発表日時（UTC）。
  final DateTime? resultAt;

  /// 入金期限（UTC）。
  final DateTime? paymentDeadlineAt;

  /// メモ。
  final String? note;

  /// [kind] の期限。
  DateTime? deadlineOf(TicketDeadlineKind kind) => switch (kind) {
    TicketDeadlineKind.apply => applyDeadlineAt,
    TicketDeadlineKind.result => resultAt,
    TicketDeadlineKind.payment => paymentDeadlineAt,
  };

  /// リマインドの予約に使う事実。
  ReminderFacts get reminderFacts => ReminderFacts(
    applicationId: id,
    stage: stage,
    applyDeadlineAt: applyDeadlineAt,
    resultAt: resultAt,
    paymentDeadlineAt: paymentDeadlineAt,
  );
}

/// チケット申込の入力値。
final class TicketApplicationDraft {
  /// 期限は瞬間（UTC）で渡す。
  const TicketApplicationDraft({
    required this.performanceId,
    required this.stage,
    this.service,
    this.referenceNo,
    this.applyDeadlineAt,
    this.resultAt,
    this.paymentDeadlineAt,
    this.note,
  });

  /// 申し込む公演。
  final int performanceId;

  /// 申込段階。
  final TicketApplicationStage stage;

  /// チケットサービス。
  final TicketServiceKind? service;

  /// 受付番号。空なら未入力として扱う。
  final String? referenceNo;

  /// 申込締切。
  final DateTime? applyDeadlineAt;

  /// 当落発表日時。
  final DateTime? resultAt;

  /// 入金期限。
  final DateTime? paymentDeadlineAt;

  /// メモ。空なら未入力として扱う。
  final String? note;

  /// 期限を1つ以上持つか。
  bool get hasDeadline =>
      applyDeadlineAt != null || resultAt != null || paymentDeadlineAt != null;
}
