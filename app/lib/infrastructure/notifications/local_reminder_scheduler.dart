import 'dart:async';

import 'package:app/application/application.dart';
import 'package:app/application/errors/record_error.dart';
import 'package:app/core/formatting/kakin_formats.dart';
import 'package:app/core/gen/slang.g.dart';
import 'package:app/domain/domain.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// 通知の応答。タップか、段階を進めるボタン。
final class ReminderResponse {
  /// 通知の payload とボタンの ID から作る。
  const ReminderResponse({required this.applicationId, this.action});

  /// 対象のチケット申込。
  final int applicationId;

  /// 押されたボタン。通知そのものをタップしたなら null。
  final QuickStageAction? action;

  /// plugin の応答を解釈する。対象外の通知なら null。
  static ReminderResponse? from(NotificationResponse response) {
    final id = int.tryParse(response.payload ?? '');
    if (id == null) return null;
    final actionId = response.actionId;
    return ReminderResponse(
      applicationId: id,
      action: QuickStageAction.values
          .where((a) => a.name == actionId)
          .firstOrNull,
    );
  }
}

/// `flutter_local_notifications` で端末内にリマインドを予約する。
final class LocalReminderScheduler implements ReminderScheduler {
  LocalReminderScheduler._(this._plugin);

  static const _channelId = 'ticket_reminders';

  /// plugin を初期化する。[onForeground] はアプリが動いている間の応答、
  /// [onBackground] はアプリを開かずに押されたボタンを受け取る。
  ///
  /// [onBackground] は `@pragma('vm:entry-point')` の top-level 関数にする。
  static Future<LocalReminderScheduler> initialize({
    required void Function(NotificationResponse) onForeground,
    DidReceiveBackgroundNotificationResponseCallback? onBackground,
    FlutterLocalNotificationsPlugin? plugin,
  }) async {
    tz_data.initializeTimeZones();
    final notifications = plugin ?? FlutterLocalNotificationsPlugin();
    await notifications.initialize(
      settings: InitializationSettings(
        android: const AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
          notificationCategories: [
            for (final kind in TicketDeadlineKind.values)
              DarwinNotificationCategory(
                kind.name,
                actions: [
                  for (final action in kind.quickActions)
                    DarwinNotificationAction.plain(
                      action.name,
                      _actionLabel(action),
                    ),
                ],
              ),
          ],
        ),
      ),
      onDidReceiveNotificationResponse: onForeground,
      onDidReceiveBackgroundNotificationResponse: onBackground,
    );
    return LocalReminderScheduler._(notifications);
  }

  final FlutterLocalNotificationsPlugin _plugin;

  /// アプリが通知のタップで起動したときの応答。
  Future<ReminderResponse?> launchResponse() async {
    final details = await _plugin.getNotificationAppLaunchDetails();
    if (details == null || !details.didNotificationLaunchApp) return null;
    final response = details.notificationResponse;
    return response == null ? null : ReminderResponse.from(response);
  }

  @override
  Future<NotificationPermission> permissionStatus() => _guard(() async {
    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    if (ios != null) {
      final options = await ios.checkPermissions();
      if (options == null) return NotificationPermission.notDetermined;
      return options.isEnabled
          ? NotificationPermission.granted
          : NotificationPermission.denied;
    }
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    final enabled = await android?.areNotificationsEnabled();
    return enabled ?? false
        ? NotificationPermission.granted
        : NotificationPermission.denied;
  });

  @override
  Future<NotificationPermission> requestPermission() => _guard(() async {
    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    final granted =
        await ios?.requestPermissions(alert: true, badge: true, sound: true) ??
        await android?.requestNotificationsPermission() ??
        false;
    return granted
        ? NotificationPermission.granted
        : NotificationPermission.denied;
  });

  @override
  Future<void> replaceAll(List<ReminderNotification> reminders) => _guard(
    () async {
      await _plugin.cancelAllPendingNotifications();
      final tokyo = tz.getLocation('Asia/Tokyo');
      for (final reminder in reminders) {
        final kind = reminder.plan.slot.kind;
        await _plugin.zonedSchedule(
          id: reminder.plan.notificationId,
          scheduledDate: tz.TZDateTime.from(reminder.plan.fireAt, tokyo),
          title: reminder.performanceTitle,
          body: _body(reminder.plan),
          payload: '${reminder.plan.applicationId}',
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          notificationDetails: NotificationDetails(
            android: AndroidNotificationDetails(
              _channelId,
              t.reminder.channelName,
              channelDescription: t.reminder.channelDescription,
              importance: Importance.high,
              priority: Priority.high,
              actions: [
                for (final action in reminder.actions)
                  AndroidNotificationAction(action.name, _actionLabel(action)),
              ],
            ),
            iOS: DarwinNotificationDetails(categoryIdentifier: kind.name),
          ),
        );
      }
    },
  );

  static String _actionLabel(QuickStageAction action) => switch (action) {
    QuickStageAction.applied => t.quickAction.applied,
    QuickStageAction.won => t.quickAction.won,
    QuickStageAction.lost => t.quickAction.lost,
    QuickStageAction.paid => t.quickAction.paid,
  };

  static String _body(PlannedReminder plan) {
    final time = KakinFormats.time(plan.deadlineAt);
    final dateTime = KakinFormats.dateTime(plan.deadlineAt);
    return switch (plan.slot) {
      ReminderSlot.applyEve => t.reminder.applyEve(time: time),
      ReminderSlot.applySoon => t.reminder.applySoon(time: time),
      ReminderSlot.resultAt => t.reminder.resultAt(dateTime: dateTime),
      ReminderSlot.paymentEve => t.reminder.paymentEve(time: time),
      ReminderSlot.paymentSoon => t.reminder.paymentSoon(time: time),
    };
  }

  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on PlatformException catch (error, stackTrace) {
      throw ReminderScheduleException(
        cause: error,
        causeStackTrace: stackTrace,
      );
    }
  }
}
