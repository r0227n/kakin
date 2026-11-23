import 'package:app/application/models/notifications.dart';
import 'package:app/application/ports/app_preferences_repository.dart';
import 'package:app/application/ports/device_ports.dart';
import 'package:app/application/ports/record_repositories.dart';
import 'package:app/domain/domain.dart';

/// チケット申込のリマインドの予約と、通知からの段階の更新の入力境界。
final class ReminderUseCase {
  /// 申込・通知・設定・時計を注入する。
  const ReminderUseCase(
    this._applications,
    this._scheduler,
    this._preferences,
    this._clock,
  );

  final TicketApplicationRepository _applications;
  final ReminderScheduler _scheduler;
  final AppPreferencesRepository _preferences;
  final Clock _clock;

  /// 予約済みの通知をすべて取り消し、チケット申込から組み立て直す。
  Future<void> rebuild() async {
    final open = await _applications.listOpen();
    final titles = {for (final a in open) a.id: a.performance.title};
    final plans = planReminders(
      applications: open.map((a) => a.reminderFacts),
      now: _clock.now(),
      enabledKinds: _preferences.load().enabledReminderKinds,
    );
    await _scheduler.replaceAll([
      for (final plan in plans)
        ReminderNotification(
          plan: plan,
          performanceTitle: titles[plan.applicationId]!,
        ),
    ]);
  }

  /// 期限の種類ごとのリマインドのオンとオフを保存し、予約し直す。
  Future<void> setEnabled(
    TicketDeadlineKind kind, {
    required bool enabled,
  }) async {
    await _preferences.saveReminderEnabled(kind, enabled: enabled);
    await rebuild();
  }

  /// OS の通知の許可の状態。
  ///
  /// iOS はまだ求めていない状態も拒否と同じに返すため、
  /// このアプリが一度も求めていなければ未決定として扱う。
  Future<NotificationPermission> permissionStatus() async {
    final status = await _scheduler.permissionStatus();
    if (status == NotificationPermission.denied &&
        !_preferences.load().notificationPermissionRequested) {
      return NotificationPermission.notDetermined;
    }
    return status;
  }

  /// 初めて期限を登録したときに、一度だけ OS に通知の許可を求める。
  Future<void> requestPermissionOnce() async {
    if (_preferences.load().notificationPermissionRequested) return;
    await _preferences.saveNotificationPermissionRequested();
    await _scheduler.requestPermission();
  }

  /// 通知のボタンで段階を進める。対象の段階でなければ何もしない。
  Future<bool> applyNotificationAction(
    int applicationId,
    QuickStageAction action,
  ) async {
    final application = await _applications.find(applicationId);
    if (application == null || application.stage != action.from) return false;
    await _applications.updateStage(applicationId, action.to);
    await rebuild();
    return true;
  }
}
