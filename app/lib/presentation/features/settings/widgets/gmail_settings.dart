import 'package:app/application/application.dart';
import 'package:app/core/formatting/kakin_formats.dart';
import 'package:app/core/gen/slang.g.dart';
import 'package:app/presentation/dependencies/application_providers.dart';
import 'package:app/presentation/features/settings/controllers/gmail_action_controller.dart';
import 'package:app/presentation/shared/controllers/local_data.dart';
import 'package:app/presentation/shared/feedback/action_feedback.dart';
import 'package:app/presentation/shared/keys/app_keys.dart';
import 'package:app/presentation/shared/widgets/common_widgets.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 再連携が必要なときに設定の先頭に出す警告。
class GmailReauthBanner extends ConsumerWidget {
  /// 同期状態が再連携を求めていなければ何も出さない。
  const GmailReauthBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final palette = context.palette;
    final connection = ref.watch(gmailStatusProvider).value?.connection;
    if (connection?.lastFailureKind != GmailFailureKind.reauthRequired) {
      return const SizedBox.shrink();
    }
    final busy = ref.watch(gmailActionControllerProvider);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.l),
      child: SurfaceCard(
        key: AppKeys.gmailReauthBanner,
        color: palette.warningSoft,
        border: Border.all(color: palette.warningBorder),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.sm,
          children: [
            Semantics(
              liveRegion: true,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: t.settings.reauthTitle,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    TextSpan(text: t.settings.reauthBody),
                  ],
                ),
                style: TextStyle(
                  fontSize: 13,
                  height: 1.6,
                  color: palette.warningInk,
                ),
              ),
            ),
            FilledButton(
              onPressed: busy
                  ? null
                  : () => ref
                        .read(gmailActionControllerProvider.notifier)
                        .run(() => _connect(context, ref)),
              child: Text(t.settings.reconnect),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _connect(BuildContext context, WidgetRef ref) async {
  final gmail = ref.read(gmailUseCaseProvider);
  final connected = await runWithFeedback(
    context,
    ref,
    gmail.connect,
    failureLog: 'Connecting Gmail from settings failed',
  );
  if (!(connected ?? false) || !context.mounted) return;
  await _sync(context, ref);
}

Future<void> _sync(BuildContext context, WidgetRef ref) async {
  final t = Translations.of(context);
  final result = await runWithFeedback(
    context,
    ref,
    ref.read(gmailUseCaseProvider).sync,
    failureLog: 'Gmail sync from settings failed',
  );
  if (result == null || !context.mounted) return;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(t.settings.synced(count: result.importedMailCount)),
      ),
    );
}

/// Gmail 連携の状態と操作。
class GmailSettings extends ConsumerWidget {
  /// 連携・同期・解除の進行中は操作を止める。
  const GmailSettings({super.key});

  Future<void> _disconnect(BuildContext context, WidgetRef ref) async {
    final t = Translations.of(context);
    final confirmed = await confirmDestructive(
      context,
      title: t.settings.disconnectTitle,
      body: t.settings.disconnectNote,
      confirmLabel: t.settings.disconnect,
    );
    if (!confirmed || !context.mounted) return;
    await ref
        .read(gmailActionControllerProvider.notifier)
        .run(
          () => runWithFeedback(
            context,
            ref,
            ref.read(gmailUseCaseProvider).disconnect,
            failureLog: 'Disconnecting Gmail failed',
          ),
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final palette = context.palette;
    final busy = ref.watch(gmailActionControllerProvider);
    final actions = ref.read(gmailActionControllerProvider.notifier);
    final status = ref.watch(gmailStatusProvider).value;
    final connection = status?.connection;
    final children = <Widget>[
      Row(
        spacing: AppSpacing.sm,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: palette.accentSoft,
              borderRadius: BorderRadius.circular(AppRadius.m),
            ),
            child: Icon(Icons.mail_outline, color: palette.accentStrong),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.xxs,
              children: [
                Text(
                  connection?.accountEmail ?? t.settings.gmailNotConnected,
                  key: AppKeys.gmailAccount,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (status?.isDemo ?? false)
                  TagChip(
                    key: AppKeys.gmailDemoLabel,
                    label: t.settings.demo,
                    foreground: palette.warningInk,
                    background: palette.warningSoft,
                  ),
              ],
            ),
          ),
        ],
      ),
      if (status?.isDemo ?? false)
        Padding(
          padding: const EdgeInsets.only(top: AppSpacing.s),
          child: Text(
            t.settings.demoNote,
            style: TextStyle(fontSize: 12, color: palette.textSecondary),
          ),
        ),
    ];
    if (connection == null) {
      children.addAll([
        const SizedBox(height: AppSpacing.m),
        FilledButton.icon(
          key: AppKeys.gmailConnect,
          onPressed: busy
              ? null
              : () => actions.run(() => _connect(context, ref)),
          icon: const Icon(Icons.mail_outline),
          label: Text(t.settings.connect),
        ),
      ]);
    } else {
      final failedAt = connection.lastFailedAt;
      children.addAll([
        const SizedBox(height: AppSpacing.m),
        _Facts(
          entries: {
            t.settings.lastSync: connection.lastFetchedAt == null
                ? t.settings.neverSynced
                : KakinFormats.dateTime(connection.lastFetchedAt!),
            t.settings.services: t.settings.servicesValue,
            t.settings.autoSync: t.settings.autoSyncValue,
          },
        ),
        if (failedAt != null &&
            connection.lastFailureKind == GmailFailureKind.other)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.sm),
            child: Text(
              t.settings.syncFailed(date: KakinFormats.dateTime(failedAt)),
              key: AppKeys.gmailSyncFailed,
              style: TextStyle(fontSize: 12, color: palette.warningInk),
            ),
          ),
        const SizedBox(height: AppSpacing.m),
        FilledButton.icon(
          key: AppKeys.gmailSyncNow,
          onPressed: busy ? null : () => actions.run(() => _sync(context, ref)),
          icon: busy
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.sync),
          label: Text(busy ? t.settings.syncing : t.settings.syncNow),
        ),
        const SizedBox(height: AppSpacing.s),
        TextButton(
          key: AppKeys.gmailDisconnect,
          style: TextButton.styleFrom(foregroundColor: palette.negative),
          onPressed: busy ? null : () => _disconnect(context, ref),
          child: Text(t.settings.disconnect),
        ),
        Text(
          t.settings.disconnectNote,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 11, color: palette.textSecondary),
        ),
      ]);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.s,
      children: [
        SectionHeader(title: t.settings.gmail),
        SurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ),
      ],
    );
  }
}

class _Facts extends StatelessWidget {
  const _Facts({required this.entries});

  final Map<String, String> entries;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Column(
      spacing: AppSpacing.s,
      children: [
        for (final entry in entries.entries)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.sm,
            children: [
              SizedBox(
                width: 96,
                child: Text(
                  entry.key,
                  style: TextStyle(fontSize: 12, color: palette.textSecondary),
                ),
              ),
              Expanded(
                child: Text(
                  entry.value,
                  style: AppTypography.numeric(fontSize: 13),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
