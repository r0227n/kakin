/// チケット申込の段階。
enum TicketApplicationStage {
  /// 申込予定。受付中で、まだ申し込んでいない。
  planned,

  /// 結果待ち。抽選に申し込み、当落の発表を待っている。
  awaitingResult,

  /// 入金待ち。当選し、支払いを待っている。
  awaitingPayment,

  /// 確保済み。支払いが済み、チケットを確保した。
  secured,

  /// 落選。
  lost;

  /// Gmail が段階を進めるときの順位。大きいほど先の段階。
  int get gmailRank => switch (this) {
    planned => 0,
    awaitingResult => 1,
    awaitingPayment || lost => 2,
    secured => 3,
  };

  /// この段階でリマインドする期限。リマインドしない段階は null。
  TicketDeadlineKind? get remindedDeadline => switch (this) {
    planned => TicketDeadlineKind.apply,
    awaitingResult => TicketDeadlineKind.result,
    awaitingPayment => TicketDeadlineKind.payment,
    secured || lost => null,
  };

  /// これ以上 Gmail で変えない段階か。
  bool get isFinal => this == secured || this == lost;

  /// Gmail のメールで [target] へ進めたときの段階。進めないなら null。
  ///
  /// Gmail は段階を先へ進めるだけで、前の段階には戻さない。
  TicketApplicationStage? advancedByMailTo(TicketApplicationStage target) {
    if (isFinal || target.gmailRank <= gmailRank) return null;
    return target;
  }
}

/// チケット申込の期限の種類。
enum TicketDeadlineKind {
  /// 申込締切。
  apply,

  /// 当落発表日時。
  result,

  /// 入金期限。
  payment;

  /// 時刻を入れなかったときの日本時間の時。
  int get defaultHour => this == result ? 12 : 23;

  /// 時刻を入れなかったときの日本時間の分。
  int get defaultMinute => this == result ? 0 : 59;

  /// 期限ごとのワンタップの段階更新。
  List<QuickStageAction> get quickActions => switch (this) {
    apply => const [QuickStageAction.applied],
    result => const [QuickStageAction.won, QuickStageAction.lost],
    payment => const [QuickStageAction.paid],
  };
}

/// 通知とやることから、次の段階へワンタップで進める操作。
enum QuickStageAction {
  /// 申し込んだ。申込予定 → 結果待ち。
  applied(
    TicketApplicationStage.planned,
    TicketApplicationStage.awaitingResult,
  ),

  /// 当選。結果待ち → 入金待ち。
  won(
    TicketApplicationStage.awaitingResult,
    TicketApplicationStage.awaitingPayment,
  ),

  /// 落選。結果待ち → 落選。
  lost(TicketApplicationStage.awaitingResult, TicketApplicationStage.lost),

  /// 支払った。入金待ち → 確保済み。
  paid(TicketApplicationStage.awaitingPayment, TicketApplicationStage.secured);

  const QuickStageAction(this.from, this.to);

  /// この操作が対象とする段階。
  final TicketApplicationStage from;

  /// 進む先の段階。
  final TicketApplicationStage to;
}

/// チケットサービス。
enum TicketServiceKind {
  /// eplus。
  eplus,

  /// ライブポケット。
  livepocket,

  /// その他。
  other,
}
