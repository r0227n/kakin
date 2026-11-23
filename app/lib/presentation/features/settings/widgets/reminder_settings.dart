import 'package:app/application/application.dart';
import 'package:app/core/gen/slang.g.dart';
import 'package:app/domain/domain.dart';
import 'package:app/presentation/features/settings/widgets/settings_group.dart';
import 'package:app/presentation/shared/controllers/app_preferences_controller.dart';
import 'package:app/presentation/shared/controllers/local_data.dart';
import 'package:app/presentation/shared/feedback/action_feedback.dart';
import 'package:app/presentation/shared/keys/app_keys.dart';
import 'package:app/presentation/shared/widgets/visuals.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 期限の種類ごとのリマインドと、通知の許可の状態。
class ReminderSettings extends ConsumerWidget {
  /// 切り替えると通知を予約し直す。
  const ReminderSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final palette = context.palette;
    final enabled = ref.watch(
      appPreferencesControllerProvider.select((p) => p.enabledReminderKinds),
    );
    final permission = ref.watch(notificationPermissionProvider).value;
    String when(TicketDeadlineKind kind) => switch (kind) {
      TicketDeadlineKind.apply => t.settings.reminderApplyWhen,
      TicketDeadlineKind.result => t.settings.reminderResultWhen,
      TicketDeadlineKind.payment => t.settings.reminderPaymentWhen,
    };
    final (icon, message, color) = switch (permission) {
      NotificationPermission.granted => (
        Icons.check_circle_outline,
        t.settings.permissionGranted,
        palette.tealTone.ink,
      ),
      NotificationPermission.denied => (
        Icons.notifications_off_outlined,
        t.settings.permissionDenied,
        palette.warningInk,
      ),
      _ => (
        Icons.notifications_none,
        t.settings.permissionUnknown,
        palette.textSecondary,
      ),
    };
    return SettingsGroup(
      title: t.settings.reminders,
      children: [
        for (final kind in TicketDeadlineKind.values)
          SettingsSwitchTile(
            key: AppKeys.reminder(kind),
            label: kind.label(t),
            subtitle: when(kind),
            value: enabled.contains(kind),
            onChanged: (value) => runWithFeedback(
              context,
              ref,
              () => ref
                  .read(appPreferencesControllerProvider.notifier)
                  .setReminderEnabled(kind, enabled: value),
              failureLog: 'Saving a reminder preference failed',
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.s,
            children: [
              Icon(icon, size: 18, color: color),
              Expanded(
                child: Text(
                  message,
                  key: AppKeys.notificationPermissionStatus,
                  style: TextStyle(fontSize: 12, height: 1.5, color: color),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
