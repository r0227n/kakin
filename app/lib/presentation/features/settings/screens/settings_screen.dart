import 'package:app/core/gen/slang.g.dart';
import 'package:app/presentation/features/settings/widgets/budget_settings.dart';
import 'package:app/presentation/features/settings/widgets/display_settings.dart';
import 'package:app/presentation/features/settings/widgets/gmail_settings.dart';
import 'package:app/presentation/shared/keys/app_keys.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// 推し活代・Gmail 連携・表示の設定。
class SettingsScreen extends StatelessWidget {
  /// 各設定は節ごとの Widget が保存する。
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(t.tabs.settings)),
      body: ListView(
        key: AppKeys.settingsScroll,
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.m,
          AppSpacing.s,
          AppSpacing.m,
          AppSpacing.xl,
        ),
        children: const [
          GmailReauthBanner(),
          BudgetSettings(),
          SizedBox(height: AppSpacing.l),
          GmailSettings(),
          SizedBox(height: AppSpacing.l),
          DisplaySettings(),
          SizedBox(height: AppSpacing.l),
          DefaultBasisSettings(),
        ],
      ),
    );
  }
}
