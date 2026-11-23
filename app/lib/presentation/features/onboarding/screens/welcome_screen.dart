import 'package:app/core/gen/slang.g.dart';
import 'package:app/presentation/features/onboarding/widgets/onboarding_scaffold.dart';
import 'package:app/presentation/navigation/routes.dart';
import 'package:app/presentation/shared/keys/app_keys.dart';
import 'package:app/presentation/shared/widgets/common_widgets.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// 初回起動の案内の最初の画面。できることとデータの扱いを示す。
class WelcomeScreen extends StatelessWidget {
  /// 案内を始める。
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final palette = context.palette;
    return OnboardingScaffold(
      actions: [
        FilledButton(
          key: AppKeys.onboardingStart,
          onPressed: () => const BudgetSetupRoute().push<void>(context),
          child: Text(t.onboarding.start),
        ),
      ],
      children: [
        const SizedBox(height: AppSpacing.l),
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: palette.accent,
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
          child: Icon(
            Icons.savings_outlined,
            color: palette.onAccent,
            size: 34,
          ),
        ),
        OnboardingHeading(
          title: t.onboarding.welcomeTitle,
          body: t.onboarding.welcomeBody,
        ),
        SurfaceCard(
          radius: AppRadius.xl,
          child: Column(
            spacing: AppSpacing.m,
            children: [
              _Feature(
                icon: Icons.account_balance_wallet_outlined,
                tone: palette.ticket,
                title: t.onboarding.featureBudgetTitle,
                body: t.onboarding.featureBudgetBody,
              ),
              _Feature(
                icon: Icons.photo_outlined,
                tone: palette.cheki,
                title: t.onboarding.featureRecordTitle,
                body: t.onboarding.featureRecordBody,
              ),
              _Feature(
                icon: Icons.notifications_none,
                tone: palette.amberTone,
                title: t.onboarding.featureReminderTitle,
                body: t.onboarding.featureReminderBody,
              ),
            ],
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.s,
          children: [
            Icon(Icons.lock_outline, size: 18, color: palette.tealTone.ink),
            Expanded(
              child: Text(
                t.onboarding.privacy,
                style: TextStyle(fontSize: 13, color: palette.textTertiary),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Feature extends StatelessWidget {
  const _Feature({
    required this.icon,
    required this.tone,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final AppTone tone;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: AppSpacing.sm,
    children: [
      Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: tone.soft,
          borderRadius: BorderRadius.circular(AppRadius.m),
        ),
        child: Icon(icon, color: tone.ink, size: 20),
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.xxs,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            Text(
              body,
              style: TextStyle(
                fontSize: 12,
                height: 1.6,
                color: context.palette.textSecondary,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
