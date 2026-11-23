import 'dart:ui';

import 'package:app/app/background_notifications.dart';
import 'package:app/app/notification_responses.dart';
import 'package:app/application/application.dart';
import 'package:app/core/gen/slang.g.dart';
import 'package:app/core/localization/app_locale_resolver.dart';
import 'package:app/core/logger/error_reporter.dart';
import 'package:app/core/logger/talker_integration.dart';
import 'package:app/infrastructure/infrastructure.dart';
import 'package:app/presentation/dependencies/application_providers.dart';
import 'package:app/presentation/dependencies/observability_providers.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
    required ReminderScheduler scheduler,
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
    final applications = DriftTicketApplicationRepository(database);
    final reminders = ReminderUseCase(
      applications,
      scheduler,
      preferencesRepository,
      clock,
    );
    const oauth = GoogleOAuthConfig.fromEnvironment();
    return AppDependencyGraph._(
      database: database,
      scheduler: scheduler is LocalReminderScheduler ? scheduler : null,
      appPreferences: appPreferences,
      initialAppPreferences: appPreferences.load(),
      errorReporter: TalkerErrorReporter(talker),
      budget: BudgetUseCase(budgets, clock),
      ledger: LedgerUseCase(budgets, expenses, performances),
      expense: ExpenseUseCase(expenses),
      performance: PerformanceUseCase(performances, reminders),
      ticketApplication: TicketApplicationUseCase(
        applications,
        performances,
        reminders,
        clock,
      ),
      partner: PartnerUseCase(
        partners,
        iconStore,
        iconPicker ?? PluginPartnerIconPicker(),
      ),
      reminders: reminders,
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
        applications: applications,
        reminders: reminders,
        clock: clock,
      ),
      localDataChanges: DriftLocalDataChanges(database),
      clock: clock,
    );
  }

  const AppDependencyGraph._({
    required this._database,
    required this._scheduler,
    required this.appPreferences,
    required this.initialAppPreferences,
    required this.errorReporter,
    required this.budget,
    required this.ledger,
    required this.expense,
    required this.performance,
    required this.ticketApplication,
    required this.partner,
    required this.reminders,
    required this.gmail,
    required this.localDataChanges,
    required this.clock,
  });

  /// 端末の DB・通知・画像の保存先を開いて組み立てる。
  ///
  /// アプリが動いている間の通知の応答は [onNotification] へ渡す。
  static Future<AppDependencyGraph> open({
    required Talker talker,
    required void Function(ReminderTap) onNotification,
  }) async {
    final scheduler = await LocalReminderScheduler.initialize(
      onForeground: (response) {
        if (_tapOf(response) case final tap?) onNotification(tap);
      },
      onBackground: handleBackgroundNotificationResponse,
    );
    final database = AppDatabase.defaults();
    try {
      return AppDependencyGraph(
        sharedPreferences: await SharedPreferences.getInstance(),
        talker: talker,
        database: database,
        scheduler: scheduler,
        iconStore: await FilePartnerIconStore.open(),
      );
    } on Object {
      await database.close();
      rethrow;
    }
  }

  final AppDatabase _database;
  final LocalReminderScheduler? _scheduler;

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

  /// チケット申込。
  final TicketApplicationUseCase ticketApplication;

  /// チェキ相手。
  final PartnerUseCase partner;

  /// リマインド。
  final ReminderUseCase reminders;

  /// Gmail 同期。
  final GmailUseCase gmail;

  /// 端末内のデータの変更通知。
  final LocalDataChanges localDataChanges;

  /// 時計。
  final Clock clock;

  /// アプリを開かずに押された通知のボタンで、チケット申込の段階を進める。
  ///
  /// 通知の plugin が別の isolate で呼ぶため、DB と設定をここで開いて閉じる。
  static Future<void> applyBackgroundResponse(
    NotificationResponse response,
  ) async {
    final tap = _tapOf(response);
    final action = tap?.action;
    if (tap == null || action == null) return;
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();
    final database = AppDatabase.defaults();
    try {
      final preferences = LocalAppPreferencesRepository(
        await SharedPreferences.getInstance(),
      );
      await LocaleSettings.setLocale(
        resolveAppLocale(
          preferences.load().locale?.languageCode,
          PlatformDispatcher.instance.locales,
        ),
      );
      final scheduler = await LocalReminderScheduler.initialize(
        onForeground: (_) {},
      );
      await ReminderUseCase(
        DriftTicketApplicationRepository(database),
        scheduler,
        preferences,
        const SystemClock(),
      ).applyNotificationAction(tap.applicationId, action);
    } finally {
      await database.close();
    }
  }

  /// アプリが通知のタップで起動したときの応答。
  Future<ReminderTap?> launchTap() async {
    final response = await _scheduler?.launchResponse();
    return response == null
        ? null
        : (applicationId: response.applicationId, action: response.action);
  }

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
      ticketApplicationUseCaseProvider.overrideWithValue(ticketApplication),
      partnerUseCaseProvider.overrideWithValue(partner),
      reminderUseCaseProvider.overrideWithValue(reminders),
      gmailUseCaseProvider.overrideWithValue(gmail),
      localDataChangesProvider.overrideWithValue(localDataChanges),
      clockProvider.overrideWithValue(clock),
    ],
    child: child,
  );
}

ReminderTap? _tapOf(NotificationResponse response) {
  final parsed = ReminderResponse.from(response);
  return parsed == null
      ? null
      : (applicationId: parsed.applicationId, action: parsed.action);
}
