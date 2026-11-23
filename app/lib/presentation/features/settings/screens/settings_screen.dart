import 'package:app/core/gen/slang.g.dart';
import 'package:app/presentation/features/settings/widgets/budget_settings.dart';
import 'package:app/presentation/features/settings/widgets/display_settings.dart';
import 'package:app/presentation/features/settings/widgets/gmail_settings.dart';
import 'package:app/presentation/features/settings/widgets/reminder_settings.dart';
import 'package:app/presentation/shared/controllers/local_data.dart';
import 'package:app/presentation/shared/keys/app_keys.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 推し活代・Gmail 連携・リマインド・表示の設定。
class SettingsScreen extends ConsumerStatefulWidget {
  /// 端末の設定から戻ったら通知の許可を読み直す。
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.invalidate(notificationPermissionProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          key: AppKeys.settingsScroll,
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.m,
            AppSpacing.ml,
            AppSpacing.m,
            AppSpacing.xl,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: AppSpacing.xs,
                bottom: AppSpacing.ml - 2,
              ),
              child: Semantics(
                header: true,
                child: Text(
                  t.tabs.settings,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const GmailReauthBanner(),
            const BudgetSettings(),
            const SizedBox(height: AppSpacing.l),
            const GmailSettings(),
            const SizedBox(height: AppSpacing.l),
            const ReminderSettings(),
            const SizedBox(height: AppSpacing.l),
            const DisplaySettings(),
            const SizedBox(height: AppSpacing.l),
            const DefaultBasisSettings(),
          ],
        ),
      ),
    );
  }
}
