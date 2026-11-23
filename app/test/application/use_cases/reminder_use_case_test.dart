import 'package:app/application/application.dart';
import 'package:app/domain/domain.dart';
import 'package:app/infrastructure/infrastructure.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fakes.dart';
import '../../support/test_graph.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late TestGraph t;
  late ReminderUseCase reminders;
  late DriftTicketApplicationRepository applications;
  late int performanceId;

  setUp(() async {
    t = await TestGraph.create();
    reminders = t.graph.reminders;
    applications = DriftTicketApplicationRepository(t.database);
    performanceId = await t.graph.performance.create(
      PerformanceDraft(title: 'Live', startsAt: DateTime.utc(2026, 12, 1, 9)),
    );
  });
  tearDown(() => t.close());

  Future<int> addApplication(TicketApplicationStage stage) =>
      applications.create(
        TicketApplicationDraft(
          performanceId: performanceId,
          stage: stage,
          applyDeadlineAt: DateTime.utc(2026, 11, 25, 14, 59),
          resultAt: DateTime.utc(2026, 11, 27, 3),
          paymentDeadlineAt: DateTime.utc(2026, 11, 30, 14, 59),
        ),
      );

  group('permissionStatus', () {
    test('treats denied as not determined until the app has asked', () async {
      t.scheduler.permission = NotificationPermission.denied;

      expect(
        await reminders.permissionStatus(),
        NotificationPermission.notDetermined,
      );
    });

    test('reports denied once the app has asked', () async {
      t.scheduler
        ..permission = NotificationPermission.denied
        ..requestResult = NotificationPermission.denied;
      await reminders.requestPermissionOnce();

      expect(await reminders.permissionStatus(), NotificationPermission.denied);
    });

    test('passes granted and not determined through', () async {
      for (final status in [
        NotificationPermission.granted,
        NotificationPermission.notDetermined,
      ]) {
        t.scheduler.permission = status;
        expect(await reminders.permissionStatus(), status);
      }
    });
  });

  group('requestPermissionOnce', () {
    test('asks the OS only the first time and remembers it', () async {
      await reminders.requestPermissionOnce();
      await reminders.requestPermissionOnce();

      expect(t.scheduler.requestCount, 1);
      expect(
        t.graph.appPreferences.load().notificationPermissionRequested,
        isTrue,
      );
    });

    test('records the request before asking the OS', () async {
      final preferences = FakeAppPreferencesRepository();
      final scheduler = _OrderRecordingScheduler(preferences);
      final useCase = ReminderUseCase(
        applications,
        scheduler,
        preferences,
        t.clock,
      );

      await useCase.requestPermissionOnce();

      expect(scheduler.requestedAfterSave, isTrue);
    });
  });

  group('rebuild', () {
    test('schedules the reminders of open applications', () async {
      final id = await addApplication(TicketApplicationStage.awaitingResult);
      await addApplication(TicketApplicationStage.secured);

      await reminders.rebuild();

      final [reminder] = t.scheduler.scheduled;
      expect(reminder.plan.applicationId, id);
      expect(reminder.plan.slot, ReminderSlot.resultAt);
      expect(reminder.performanceTitle, 'Live');
      expect(reminder.actions, [QuickStageAction.won, QuickStageAction.lost]);
    });

    test('drops reminders whose time has passed', () async {
      await addApplication(TicketApplicationStage.planned);
      t.clock.instant = DateTime.utc(2026, 11, 24, 12);

      await reminders.rebuild();

      expect(t.scheduler.scheduled.map((r) => r.plan.slot), [
        ReminderSlot.applySoon,
      ]);
    });

    test('propagates scheduling failures', () async {
      await addApplication(TicketApplicationStage.planned);
      t.scheduler.replaceError = Exception('plugin');

      await expectLater(reminders.rebuild(), throwsException);
    });
  });

  test(
    'setEnabled saves the switch and reschedules without that kind',
    () async {
      await addApplication(TicketApplicationStage.planned);
      await reminders.rebuild();
      expect(t.scheduler.scheduled, isNotEmpty);

      await reminders.setEnabled(TicketDeadlineKind.apply, enabled: false);

      expect(t.scheduler.scheduled, isEmpty);
      expect(
        t.graph.appPreferences.load().enabledReminderKinds,
        isNot(contains(TicketDeadlineKind.apply)),
      );
    },
  );

  group('applyNotificationAction', () {
    test('advances the matching stage and reschedules', () async {
      final id = await addApplication(TicketApplicationStage.awaitingResult);

      final applied = await reminders.applyNotificationAction(
        id,
        QuickStageAction.won,
      );

      expect(applied, isTrue);
      expect(
        (await applications.find(id))!.stage,
        TicketApplicationStage.awaitingPayment,
      );
      expect(t.scheduler.scheduled.map((r) => r.plan.slot), [
        ReminderSlot.paymentEve,
        ReminderSlot.paymentSoon,
      ]);
    });

    test('ignores an action for a different stage', () async {
      final id = await addApplication(TicketApplicationStage.awaitingPayment);

      final applied = await reminders.applyNotificationAction(
        id,
        QuickStageAction.won,
      );

      expect(applied, isFalse);
      expect(
        (await applications.find(id))!.stage,
        TicketApplicationStage.awaitingPayment,
      );
    });

    test('ignores a deleted application', () async {
      expect(
        await reminders.applyNotificationAction(999, QuickStageAction.paid),
        isFalse,
      );
    });
  });
}

/// 許可を求めた時点で、求めた記録が保存済みだったかを記録する。
class _OrderRecordingScheduler extends FakeReminderScheduler {
  _OrderRecordingScheduler(this._preferences);

  final FakeAppPreferencesRepository _preferences;

  bool? requestedAfterSave;

  @override
  Future<NotificationPermission> requestPermission() {
    requestedAfterSave = _preferences.snapshot.notificationPermissionRequested;
    return super.requestPermission();
  }
}
