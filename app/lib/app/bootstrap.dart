import 'dart:async';

import 'package:app/app/bootstrap_failure_app.dart';
import 'package:app/app/dependency_graph.dart';
import 'package:app/app/kakin_app.dart';
import 'package:app/app/notification_responses.dart';
import 'package:app/core/gen/slang.g.dart';
import 'package:app/core/localization/app_locale_resolver.dart';
import 'package:app/core/logger/talker_integration.dart';
import 'package:app/presentation/navigation/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:talker/talker.dart';
import 'package:talker_riverpod_logger/talker_riverpod_logger.dart';

/// 端末内の DB・通知・設定を初期化して起動する。
///
/// binding は呼び出し元で初期化済みでもよい。
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  final talker = createTalker();
  installErrorHandlers(talker);
  try {
    final launched = await openKakinApp(
      talker: talker,
      observers: [TalkerRiverpodObserver(talker: talker)],
    );
    runApp(launched.root);
    unawaited(_afterLaunch(launched.graph, talker));
  } on Object catch (error, stackTrace) {
    talker.handle(error, stackTrace, 'Bootstrap failed');
    runApp(const BootstrapFailureApp(onRetry: bootstrap));
  }
}

/// [openKakinApp] が組み立てた root widget と、その依存の所有者。
typedef LaunchedKakinApp = ({Widget root, AppDependencyGraph graph});

/// 依存を開き、言語を決めて root widget を組み立てる。
///
/// binding の初期化・`runApp`・エラーハンドラの設定は呼び出し元が行う。
/// 失敗したときは開いた依存を閉じてから再送出する。
/// 成功したときの [AppDependencyGraph.close] は呼び出し元の責務。
Future<LaunchedKakinApp> openKakinApp({
  required Talker talker,
  List<ProviderObserver> observers = const [],
}) async {
  final responses = NotificationResponses();
  final graph = await AppDependencyGraph.open(
    talker: talker,
    onNotification: responses.add,
  );
  try {
    await LocaleSettings.setLocale(
      resolveAppLocale(
        graph.initialAppPreferences.locale?.languageCode,
        WidgetsBinding.instance.platformDispatcher.locales,
      ),
    );
    final launch = await graph.launchTap();
    return (
      root: graph.attach(
        observers: observers,
        child: _AppRoot(
          onboardingCompleted: graph.initialAppPreferences.onboardingCompleted,
          responses: responses,
          launchResponse: launch,
        ),
      ),
      graph: graph,
    );
  } on Object {
    await graph.close();
    rethrow;
  }
}

/// 起動を待たせない後片付け。失敗は報告して続ける。
Future<void> _afterLaunch(AppDependencyGraph graph, Talker talker) async {
  try {
    await graph.reminders.rebuild();
  } on Object catch (error, stackTrace) {
    talker.handle(error, stackTrace, 'Rebuilding reminders on launch failed');
  }
  try {
    await graph.partner.cleanUpIcons();
  } on Object catch (error, stackTrace) {
    talker.handle(error, stackTrace, 'Cleaning up partner icons failed');
  }
}

class _AppRoot extends StatefulWidget {
  const _AppRoot({
    required this.onboardingCompleted,
    required this.responses,
    required this.launchResponse,
  });

  final bool onboardingCompleted;
  final NotificationResponses responses;
  final ReminderTap? launchResponse;

  @override
  State<_AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<_AppRoot> {
  late final GoRouter _router = buildAppRouter(
    onboardingCompleted: widget.onboardingCompleted,
  );
  late final List<ReminderTap> _pending = [
    ?widget.launchResponse,
    ...widget.responses.drainPending(),
  ];

  @override
  Widget build(BuildContext context) => KakinApp(
    router: _router,
    notificationResponses: widget.responses.stream,
    pendingResponses: _pending,
  );

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }
}
