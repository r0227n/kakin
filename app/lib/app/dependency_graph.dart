import 'package:app/application/application.dart';
import 'package:app/core/logger/error_reporter.dart';
import 'package:app/core/logger/talker_integration.dart';
import 'package:app/infrastructure/infrastructure.dart';
import 'package:app/presentation/dependencies/application_providers.dart';
import 'package:app/presentation/dependencies/observability_providers.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker/talker.dart';

/// 外部 instance、adapter、use case を結線する唯一の場所。
final class AppDependencyGraph {
  /// 初期化済みの外部 instance から依存と起動時設定を組み立てる。
  ///
  /// [mailbox] を省略すると、OAuth クライアントが `--dart-define` で
  /// 渡されていれば Google の、なければデモの Gmail を使う。
  factory AppDependencyGraph({
    required SharedPreferences sharedPreferences,
    required Talker talker,
    required AppDatabase database,
    required PartnerIconStore iconStore,
    PartnerIconPicker? iconPicker,
    GmailMailbox? mailbox,
    Clock clock = const SystemClock(),
  }) {
    final preferencesRepository = LocalAppPreferencesRepository(
      sharedPreferences,
    );
    final appPreferences = AppPreferencesUseCase(preferencesRepository);
    final budgets = DriftBudgetRepository(database);
    final expenses = DriftExpenseRepository(database);
    final performances = DriftPerformanceRepository(database);
    final partners = DriftPartnerRepository(database);
    const oauth = GoogleOAuthConfig.fromEnvironment();
    return AppDependencyGraph._(
      database: database,
      appPreferences: appPreferences,
      initialAppPreferences: appPreferences.load(),
      errorReporter: TalkerErrorReporter(talker),
      budget: BudgetUseCase(budgets, clock),
      ledger: LedgerUseCase(budgets, expenses, performances),
      expense: ExpenseUseCase(expenses),
      performance: PerformanceUseCase(performances, clock),
      partner: PartnerUseCase(
        partners,
        iconStore,
        iconPicker ?? PluginPartnerIconPicker(),
      ),
      gmail: GmailUseCase(
        mailbox:
            mailbox ??
            (oauth.isConfigured
                ? GoogleGmailMailbox(oauth)
                : DemoGmailMailbox(clock)),
        imports: DriftGmailImportRepository(database),
        unitOfWork: DriftUnitOfWork(database),
        performances: performances,
        expenses: expenses,
        clock: clock,
      ),
      localDataChanges: DriftLocalDataChanges(database),
      clock: clock,
    );
  }

  const AppDependencyGraph._({
    required this._database,
    required this.appPreferences,
    required this.initialAppPreferences,
    required this.errorReporter,
    required this.budget,
    required this.ledger,
    required this.expense,
    required this.performance,
    required this.partner,
    required this.gmail,
    required this.localDataChanges,
    required this.clock,
  });

  /// 端末の DB・設定・画像の保存先を開いて組み立てる。
  static Future<AppDependencyGraph> open({required Talker talker}) async {
    final database = AppDatabase.defaults();
    try {
      return AppDependencyGraph(
        sharedPreferences: await SharedPreferences.getInstance(),
        talker: talker,
        database: database,
        iconStore: await FilePartnerIconStore.open(),
      );
    } on Object {
      await database.close();
      rethrow;
    }
  }

  final AppDatabase _database;

  /// 表示設定の入力境界。
  final AppPreferencesUseCase appPreferences;

  /// 最初のフレームと controller で共有する起動時設定。
  final AppPreferencesSnapshot initialAppPreferences;

  /// ロギングの具象実装を隠す報告契約。
  final ErrorReporter errorReporter;

  /// 推し活代。
  final BudgetUseCase budget;

  /// 月の概要。
  final LedgerUseCase ledger;

  /// 支出。
  final ExpenseUseCase expense;

  /// 公演。
  final PerformanceUseCase performance;

  /// チェキ相手。
  final PartnerUseCase partner;

  /// Gmail 同期。
  final GmailUseCase gmail;

  /// 端末内のデータの変更通知。
  final LocalDataChanges localDataChanges;

  /// 時計。
  final Clock clock;

  /// DB を閉じる。
  Future<void> close() => _database.close();

  /// 必須 token を root scope へ一度だけ注入する。
  ProviderScope attach({
    required Widget child,
    List<ProviderObserver> observers = const [],
  }) => ProviderScope(
    observers: observers,
    overrides: [
      appPreferencesUseCaseProvider.overrideWithValue(appPreferences),
      initialAppPreferencesSnapshotProvider.overrideWithValue(
        initialAppPreferences,
      ),
      errorReporterProvider.overrideWithValue(errorReporter),
      budgetUseCaseProvider.overrideWithValue(budget),
      ledgerUseCaseProvider.overrideWithValue(ledger),
      expenseUseCaseProvider.overrideWithValue(expense),
      performanceUseCaseProvider.overrideWithValue(performance),
      partnerUseCaseProvider.overrideWithValue(partner),
      gmailUseCaseProvider.overrideWithValue(gmail),
      localDataChangesProvider.overrideWithValue(localDataChanges),
      clockProvider.overrideWithValue(clock),
    ],
    child: child,
  );
}
