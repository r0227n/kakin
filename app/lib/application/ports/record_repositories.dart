import 'package:app/application/models/records.dart';
import 'package:app/domain/domain.dart';

/// 推し活代の永続化契約。
abstract interface class BudgetRepository {
  /// 月額の履歴と上書きを読み込む。
  Future<BudgetPlan> loadPlan();

  /// [month] から [amountYen] を月額にする。その月の行がなければ作る。
  Future<void> saveRate(YearMonth month, int amountYen);

  /// 開始月を [month] に変える。
  ///
  /// 早めるときは最も古い月額をその月から使う。遅らせるときは、その月に
  /// 適用される月額を新しい開始月の行にし、それより前の月額と上書きを消す。
  Future<void> moveStartMonth(YearMonth month);

  /// [month] だけの推し活代を保存する。
  Future<void> saveOverride(YearMonth month, int amountYen);

  /// [month] の上書きを解除する。
  Future<void> deleteOverride(YearMonth month);
}

/// 支出の永続化契約。
abstract interface class ExpenseRepository {
  /// 支払日か紐づく公演の開始日が [from] 以上 [until] 未満の支出。
  Future<List<Expense>> listTouching(LocalDate from, LocalDate until);

  /// 支払日の月ごとの支出合計。
  Future<Map<YearMonth, int>> monthlySpendByPaidOn();

  /// [id] の支出。なければ null。
  Future<Expense?> find(int id);

  /// 最も新しく登録したドリンク代の金額。なければ null。
  Future<int?> latestDrinkAmount();

  /// まとめて登録する。1件でも失敗したら何も登録しない。
  Future<List<int>> addAll(List<ExpenseDraft> drafts);

  /// Gmail から取り込んだチケット代を登録する。
  Future<int> addImported(ExpenseDraft draft, {required int emailImportId});

  /// 項目を置き換える。取り込みの印は変えない。
  Future<void> update(int id, ExpenseDraft draft);

  /// 削除する。
  Future<void> delete(int id);
}

/// 公演の永続化契約。
abstract interface class PerformanceRepository {
  /// すべての公演。開始日時の新しい順。
  Future<List<Performance>> listAll();

  /// 開始日（日本時間）が [from] 以上 [until] 未満の公演。
  Future<List<Performance>> listStartingBetween(
    LocalDate from,
    LocalDate until,
  );

  /// 開始日が [today] 以降で、チケット代か落選以外のチケット申込がある公演。
  Future<List<Performance>> listUpcoming(LocalDate today);

  /// [id] の公演。
  Future<Performance?> find(int id);

  /// 公演名と開始日時が一致する公演のうち、最も古く登録したもの。
  Future<Performance?> findByTitleAndStart(String title, DateTime startsAt);

  /// 登録して ID を返す。
  Future<int> create(PerformanceDraft draft);

  /// 項目を置き換える。
  Future<void> update(int id, PerformanceDraft draft);

  /// 削除すると一緒に消えるもの。
  Future<PerformanceDeletionImpact> deletionImpact(int id);

  /// 必須カテゴリの支出とチケット申込を含めて削除する。
  Future<void> delete(int id);
}

/// チェキ相手の永続化契約。
abstract interface class PartnerRepository {
  /// すべてのチェキ相手と、チェキ代の記録数・最後に撮った日。
  Future<List<Partner>> listAll();

  /// [id] のチェキ相手。
  Future<Partner?> find(int id);

  /// 登録して ID を返す。
  Future<int> create(PartnerDraft draft, {String? iconFile});

  /// 名前と所属を置き換える。
  Future<void> update(int id, PartnerDraft draft);

  /// アイコン画像のファイル名を置き換え、前のファイル名を返す。
  Future<String?> replaceIcon(int id, String? iconFile);

  /// 削除し、アイコン画像のファイル名を返す。チェキ代があれば失敗する。
  Future<String?> delete(int id);

  /// 参照されているアイコン画像のファイル名。
  Future<Set<String>> referencedIconFiles();
}

/// チケット申込の永続化契約。
abstract interface class TicketApplicationRepository {
  /// [performanceId] のチケット申込。登録の新しい順。
  Future<List<TicketApplication>> listForPerformance(int performanceId);

  /// [performanceIds] のチケット申込。登録の新しい順。
  Future<List<TicketApplication>> listForPerformances(
    Iterable<int> performanceIds,
  );

  /// 申込予定・結果待ち・入金待ちのチケット申込。
  Future<List<TicketApplication>> listOpen();

  /// [id] のチケット申込。
  Future<TicketApplication?> find(int id);

  /// [service] と [referenceNo] が一致するチケット申込。
  Future<TicketApplication?> findByReference(
    TicketServiceKind service,
    String referenceNo,
  );

  /// 同じ公演・同じサービスで、落選・確保済みでない最も新しいチケット申込。
  Future<TicketApplication?> findLatestOpen(
    int performanceId,
    TicketServiceKind service,
  );

  /// 登録して ID を返す。
  Future<int> create(TicketApplicationDraft draft);

  /// 項目を置き換える。
  Future<void> update(int id, TicketApplicationDraft draft);

  /// 段階だけを変える。
  Future<void> updateStage(int id, TicketApplicationStage stage);

  /// 削除する。
  Future<void> delete(int id);
}
