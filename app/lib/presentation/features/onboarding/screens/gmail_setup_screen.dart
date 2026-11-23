import 'dart:async';

import 'package:app/core/gen/slang.g.dart';
import 'package:app/presentation/dependencies/application_providers.dart';
import 'package:app/presentation/dependencies/observability_providers.dart';
import 'package:app/presentation/features/onboarding/widgets/onboarding_scaffold.dart';
import 'package:app/presentation/navigation/routes.dart';
import 'package:app/presentation/shared/controllers/app_preferences_controller.dart';
import 'package:app/presentation/shared/feedback/action_feedback.dart';
import 'package:app/presentation/shared/keys/app_keys.dart';
import 'package:app/presentation/shared/widgets/common_widgets.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 初回起動の案内で Gmail と連携する。スキップできる。
class GmailSetupScreen extends ConsumerStatefulWidget {
  /// 連携した場合は取り込みを待たずに案内を終える。
  const GmailSetupScreen({super.key});

  @override
  ConsumerState<GmailSetupScreen> createState() => _GmailSetupScreenState();
}

class _GmailSetupScreenState extends ConsumerState<GmailSetupScreen> {
  bool _busy = false;

  Future<void> _finish() async {
    final completed = await runWithFeedback(
      context,
      ref,
      () async {
        await ref
            .read(appPreferencesControllerProvider.notifier)
            .completeOnboarding();
        return true;
      },
      failureLog: 'Completing onboarding failed',
    );
    if (!mounted || !(completed ?? false)) return;
    const CalendarRoute().go(context);
  }

  Future<void> _connect() async {
    if (_busy) return;
    setState(() => _busy = true);
    final gmail = ref.read(gmailUseCaseProvider);
    final reporter = ref.read(errorReporterProvider);
    final connected = await runWithFeedback(
      context,
      ref,
      gmail.connect,
      failureLog: 'Connecting Gmail during onboarding failed',
    );
    if (!mounted) return;
    setState(() => _busy = false);
    if (!(connected ?? false)) return;
    final status = await gmail.loadStatus();
    // 初回の取り込みは待たずに先へ進め、失敗は同期状態と報告に残す。
    unawaited(
      gmail.sync().catchError((Object error, StackTrace stackTrace) {
        reporter.report(
          error,
          stackTrace,
          message: 'Initial Gmail sync failed',
        );
        return null;
      }),
    );
    if (!mounted) return;
    final email = status.connection?.accountEmail ?? '';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          Translations.of(context).onboarding.gmailConnected(email: email),
        ),
      ),
    );
    await _finish();
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final palette = context.palette;
    return OnboardingScaffold(
      step: 1,
      onBack: context.pop,
      actions: [
        FilledButton.icon(
          key: AppKeys.onboardingGmailConnect,
          onPressed: _busy ? null : _connect,
          icon: const Icon(Icons.mail_outline),
          label: Text(t.settings.connect),
        ),
        TextButton(
          key: AppKeys.onboardingGmailSkip,
          onPressed: _busy ? null : _finish,
          child: Text(t.onboarding.gmailLater),
        ),
        OnboardingNote(t.onboarding.gmailLaterNote),
      ],
      children: [
        OnboardingHeading(
          eyebrow: t.onboarding.gmailStep,
          title: t.onboarding.gmailTitle,
          body: t.onboarding.gmailBody,
        ),
        SurfaceCard(
          radius: AppRadius.xl,
          child: Column(
            spacing: AppSpacing.sm,
            children: [
              _Point(
                icon: Icons.mail_outline,
                text: t.onboarding.gmailScope,
                tone: palette.ticket,
              ),
              _Point(
                icon: Icons.lock_outline,
                text: t.onboarding.gmailPrivacy,
                tone: palette.tealTone,
              ),
              _Point(
                icon: Icons.history,
                text: t.onboarding.gmailBackfill,
                tone: palette.amberTone,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Point extends StatelessWidget {
  const _Point({required this.icon, required this.text, required this.tone});

  final IconData icon;
  final String text;
  final AppTone tone;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: AppSpacing.sm,
    children: [
      Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: tone.soft,
          borderRadius: BorderRadius.circular(AppRadius.s + 2),
        ),
        child: Icon(icon, size: 18, color: tone.ink),
      ),
      Expanded(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 13,
            height: 1.6,
            color: context.palette.textTertiary,
          ),
        ),
      ),
    ],
  );
}
