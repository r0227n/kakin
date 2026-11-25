import 'package:app/application/application.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'application_providers.g.dart';

/// アプリ設定の入力境界。具象値は composition root が注入する。
@Riverpod(keepAlive: true)
AppPreferencesUseCase appPreferencesUseCase(Ref ref) =>
    throw UnimplementedError('AppPreferencesUseCase must be injected.');

/// 起動時に一度だけ取得した設定。必ず root scope へ注入する。
@Riverpod(keepAlive: true)
AppPreferencesSnapshot initialAppPreferencesSnapshot(Ref ref) =>
    throw UnimplementedError('AppPreferencesSnapshot must be injected.');

/// 推し活代の入力境界。
@Riverpod(keepAlive: true)
BudgetUseCase budgetUseCase(Ref ref) =>
    throw UnimplementedError('BudgetUseCase must be injected.');

/// 月の概要の入力境界。
@Riverpod(keepAlive: true)
LedgerUseCase ledgerUseCase(Ref ref) =>
    throw UnimplementedError('LedgerUseCase must be injected.');

/// 支出の入力境界。
@Riverpod(keepAlive: true)
ExpenseUseCase expenseUseCase(Ref ref) =>
    throw UnimplementedError('ExpenseUseCase must be injected.');

/// 公演の入力境界。
@Riverpod(keepAlive: true)
PerformanceUseCase performanceUseCase(Ref ref) =>
    throw UnimplementedError('PerformanceUseCase must be injected.');

/// チェキ相手の入力境界。
@Riverpod(keepAlive: true)
PartnerUseCase partnerUseCase(Ref ref) =>
    throw UnimplementedError('PartnerUseCase must be injected.');

/// Gmail 連携の入力境界。
@Riverpod(keepAlive: true)
GmailUseCase gmailUseCase(Ref ref) =>
    throw UnimplementedError('GmailUseCase must be injected.');

/// 端末内のデータの変更の通知。
@Riverpod(keepAlive: true)
LocalDataChanges localDataChanges(Ref ref) =>
    throw UnimplementedError('LocalDataChanges must be injected.');

/// 現在時刻。
@Riverpod(keepAlive: true)
Clock clock(Ref ref) => throw UnimplementedError('Clock must be injected.');
