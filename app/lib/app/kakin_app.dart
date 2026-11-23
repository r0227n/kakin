import 'dart:async';

import 'package:app/app/notification_responses.dart';
import 'package:app/core/gen/slang.g.dart';
import 'package:app/presentation/dependencies/application_providers.dart';
import 'package:app/presentation/dependencies/observability_providers.dart';
import 'package:app/presentation/shared/controllers/app_preferences_controller.dart';
import 'package:app/presentation/shared/controllers/local_data.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 翻訳・テーマ・ルーティングと、通知の応答を接続する root widget。
class KakinApp extends ConsumerStatefulWidget {
  /// Router の生存期間は呼び出し元が管理する。
  const KakinApp({
    required this.router,
    this.notificationResponses = const Stream.empty(),
    this.pendingResponses = const [],
    super.key,
  });

  /// 起動時に一度だけ生成する router。
  final GoRouter router;

  /// アプリが動いている間に届いた通知の応答。
  final Stream<ReminderTap> notificationResponses;

  /// 起動前に届いた通知の応答。最初のフレームの後に処理する。
  final List<ReminderTap> pendingResponses;

  @override
  ConsumerState<KakinApp> createState() => _KakinAppState();
}

class _KakinAppState extends ConsumerState<KakinApp>
    with WidgetsBindingObserver {
  StreamSubscription<ReminderTap>? _subscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _subscription = widget.notificationResponses.listen(_handle);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.pendingResponses.forEach(_handle);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_subscription?.cancel());
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // 通知のボタンは別の isolate で DB を更新するため、戻ったら読み直す。
    if (state == AppLifecycleState.resumed) {
      ref
        ..invalidate(localDataRevisionProvider)
        ..invalidate(notificationPermissionProvider);
    }
  }

  Future<void> _handle(ReminderTap tap) async {
    final action = tap.action;
    if (action == null) {
      await widget.router.push<void>('/applications/${tap.applicationId}');
      return;
    }
    try {
      await ref
          .read(reminderUseCaseProvider)
          .applyNotificationAction(tap.applicationId, action);
    } on Object catch (error, stackTrace) {
      ref
          .read(errorReporterProvider)
          .report(
            error,
            stackTrace,
            message: 'Applying a notification action failed',
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(
      appPreferencesControllerProvider.select((value) => value.locale),
    );
    final themeMode = ref.watch(
      appPreferencesControllerProvider.select((value) => value.themeMode),
    );
    return TranslationProvider(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        onGenerateTitle: (context) => Translations.of(context).appName,
        locale: locale,
        supportedLocales: AppLocaleUtils.supportedLocales,
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeMode,
        routerConfig: widget.router,
      ),
    );
  }
}
