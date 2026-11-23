import 'package:app/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  /// 2026-11-22 12:00 JST.
  final now = DateTime.utc(2026, 11, 22, 3);

  /// 2026-11-25 23:59 JST.
  final applyDeadline = DateTime.utc(2026, 11, 25, 14, 59);

  /// 2026-11-27 12:00 JST.
  final resultAt = DateTime.utc(2026, 11, 27, 3);

  /// 2026-11-30 23:59 JST.
  final paymentDeadline = DateTime.utc(2026, 11, 30, 14, 59);

  const allKinds = {...TicketDeadlineKind.values};

  ReminderFacts facts(
    TicketApplicationStage stage, {
    int id = 1,
    DateTime? apply,
    DateTime? result,
    DateTime? payment,
  }) => ReminderFacts(
    applicationId: id,
    stage: stage,
    applyDeadlineAt: apply ?? applyDeadline,
    resultAt: result ?? resultAt,
    paymentDeadlineAt: payment ?? paymentDeadline,
  );

  List<PlannedReminder> plan(
    Iterable<ReminderFacts> applications, {
    DateTime? at,
    Set<TicketDeadlineKind> kinds = allKinds,
    int limit = maxScheduledReminders,
  }) => planReminders(
    applications: applications,
    now: at ?? now,
    enabledKinds: kinds,
    limit: limit,
  );

  test('planned schedules the apply eve at 20:00 JST and 3 hours before', () {
    final planned = plan([facts(TicketApplicationStage.planned)]);

    expect(planned.map((p) => p.slot), [
      ReminderSlot.applyEve,
      ReminderSlot.applySoon,
    ]);
    expect(planned[0].fireAt, DateTime.utc(2026, 11, 24, 11));
    expect(planned[1].fireAt, DateTime.utc(2026, 11, 25, 11, 59));
    expect(planned.every((p) => p.deadlineAt == applyDeadline), isTrue);
  });

  test('awaitingResult fires exactly at the result time', () {
    final planned = plan([facts(TicketApplicationStage.awaitingResult)]);

    expect(planned, hasLength(1));
    expect(planned.single.slot, ReminderSlot.resultAt);
    expect(planned.single.fireAt, resultAt);
  });

  test('awaitingPayment reminds only the payment deadline', () {
    final planned = plan([facts(TicketApplicationStage.awaitingPayment)]);

    expect(planned.map((p) => p.slot), [
      ReminderSlot.paymentEve,
      ReminderSlot.paymentSoon,
    ]);
    expect(planned.every((p) => p.deadlineAt == paymentDeadline), isTrue);
  });

  test('final stages are never reminded', () {
    expect(
      plan([
        facts(TicketApplicationStage.secured),
        facts(TicketApplicationStage.lost, id: 2),
      ]),
      isEmpty,
    );
  });

  test('a missing deadline for the stage schedules nothing', () {
    final planned = plan([
      const ReminderFacts(
        applicationId: 1,
        stage: TicketApplicationStage.planned,
      ),
    ]);

    expect(planned, isEmpty);
  });

  test('disabled kinds are skipped', () {
    final planned = plan(
      [
        facts(TicketApplicationStage.planned),
        facts(TicketApplicationStage.awaitingResult, id: 2),
      ],
      kinds: {TicketDeadlineKind.result},
    );

    expect(planned.map((p) => p.applicationId), [2]);
  });

  test('fire times at or before now are dropped', () {
    final afterEve = plan([
      facts(TicketApplicationStage.planned),
    ], at: DateTime.utc(2026, 11, 24, 11));

    expect(afterEve.map((p) => p.slot), [ReminderSlot.applySoon]);
    expect(
      plan([
        facts(TicketApplicationStage.planned),
      ], at: DateTime.utc(2026, 11, 25, 11, 59)),
      isEmpty,
    );
  });

  test('the eve uses the JST previous day, not the UTC one', () {
    // 2026-11-26 00:30 JST は UTC では 11-25 なので、UTC 基準だと前日を誤る。
    final planned = plan([
      facts(
        TicketApplicationStage.planned,
        apply: DateTime.utc(2026, 11, 25, 15, 30),
      ),
    ]);

    expect(planned.first.slot, ReminderSlot.applyEve);
    expect(planned.first.fireAt, DateTime.utc(2026, 11, 25, 11));
  });

  test('sorts across applications by fire time', () {
    final planned = plan([
      facts(TicketApplicationStage.awaitingPayment),
      facts(TicketApplicationStage.awaitingResult, id: 2),
      facts(TicketApplicationStage.planned, id: 3),
    ]);

    expect(
      planned.map((p) => (p.applicationId, p.slot)),
      [
        (3, ReminderSlot.applyEve),
        (3, ReminderSlot.applySoon),
        (2, ReminderSlot.resultAt),
        (1, ReminderSlot.paymentEve),
        (1, ReminderSlot.paymentSoon),
      ],
    );
  });

  test('keeps only the earliest reminders up to the limit', () {
    final planned = plan(
      [
        facts(TicketApplicationStage.awaitingPayment),
        facts(TicketApplicationStage.planned, id: 2),
      ],
      limit: 3,
    );

    expect(planned.map((p) => (p.applicationId, p.slot)), [
      (2, ReminderSlot.applyEve),
      (2, ReminderSlot.applySoon),
      (1, ReminderSlot.paymentEve),
    ]);
  });

  test('the default limit stays under the iOS cap of 64', () {
    final planned = planReminders(
      applications: [
        for (var id = 1; id <= 40; id++)
          facts(TicketApplicationStage.planned, id: id),
      ],
      now: now,
      enabledKinds: allKinds,
    );

    expect(planned, hasLength(maxScheduledReminders));
    expect(maxScheduledReminders, lessThan(64));
  });

  test('notificationId is stable per application and slot', () {
    final planned = plan([
      facts(TicketApplicationStage.awaitingPayment, id: 5),
    ]);

    expect(planned.map((p) => p.notificationId), [5 * 8 + 3, 5 * 8 + 4]);
    expect(
      {
        for (final slot in ReminderSlot.values)
          PlannedReminder(
            applicationId: 5,
            slot: slot,
            fireAt: now,
            deadlineAt: now,
          ).notificationId,
      },
      hasLength(ReminderSlot.values.length),
    );
  });

  test('normalizes non-UTC deadlines to UTC', () {
    final planned = plan([
      facts(TicketApplicationStage.awaitingResult, result: resultAt.toLocal()),
    ]);

    expect(planned.single.deadlineAt.isUtc, isTrue);
    expect(planned.single.fireAt, resultAt);
  });
}
