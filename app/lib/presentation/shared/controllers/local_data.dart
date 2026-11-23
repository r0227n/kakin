import 'package:app/application/application.dart';
import 'package:app/domain/domain.dart';
import 'package:app/presentation/dependencies/application_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'local_data.g.dart';

/// 端末内のデータが変わるたびに増える版数。読み取りの provider が購読する。
@Riverpod(keepAlive: true)
Stream<int> localDataRevision(Ref ref) async* {
  var revision = 0;
  await for (final _ in ref.watch(localDataChangesProvider).watch()) {
    yield revision++;
  }
}

/// 月の概要。データが変わると読み直す。
@riverpod
Future<MonthOverview> monthOverview(
  Ref ref,
  YearMonth month,
  AccountingBasis basis,
) async {
  await ref.watch(localDataRevisionProvider.future);
  return ref.read(ledgerUseCaseProvider).loadMonth(month, basis);
}

/// 推し活代の設定。
@riverpod
Future<BudgetPlan> budgetPlan(Ref ref) async {
  await ref.watch(localDataRevisionProvider.future);
  return ref.read(budgetUseCaseProvider).loadPlan();
}

/// すべての公演。
@riverpod
Future<List<Performance>> performances(Ref ref) async {
  await ref.watch(localDataRevisionProvider.future);
  return ref.read(performanceUseCaseProvider).listAll();
}

/// [id] の公演。
@riverpod
Future<Performance?> performance(Ref ref, int id) async {
  await ref.watch(localDataRevisionProvider.future);
  return ref.read(performanceUseCaseProvider).find(id);
}

/// すべてのチェキ相手。
@riverpod
Future<List<Partner>> partners(Ref ref) async {
  await ref.watch(localDataRevisionProvider.future);
  return ref.read(partnerUseCaseProvider).listAll();
}

/// やることと今後の公演。
@riverpod
Future<UpcomingOverview> upcomingOverview(Ref ref) async {
  await ref.watch(localDataRevisionProvider.future);
  return ref.read(ticketApplicationUseCaseProvider).loadUpcoming();
}

/// [performanceId] のチケット申込。
@riverpod
Future<List<TicketApplication>> performanceApplications(
  Ref ref,
  int performanceId,
) async {
  await ref.watch(localDataRevisionProvider.future);
  return ref
      .read(ticketApplicationUseCaseProvider)
      .listForPerformance(performanceId);
}

/// Gmail 連携の状態。
@riverpod
Future<GmailStatus> gmailStatus(Ref ref) async {
  await ref.watch(localDataRevisionProvider.future);
  return ref.read(gmailUseCaseProvider).loadStatus();
}

/// OS の通知の許可の状態。画面に戻ったときは呼び出し側が invalidate する。
@riverpod
Future<NotificationPermission> notificationPermission(Ref ref) =>
    ref.read(reminderUseCaseProvider).permissionStatus();
