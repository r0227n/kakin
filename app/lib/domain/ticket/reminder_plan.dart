import 'package:app/domain/calendar/japan_time.dart';
import 'package:app/domain/ticket/ticket_application_stage.dart';

/// 1つのチケット申込に予約できる通知の枠。
enum ReminderSlot {
  /// 申込締切の前日 20:00。
  applyEve(0, TicketDeadlineKind.apply),

  /// 申込締切の3時間前。
  applySoon(1, TicketDeadlineKind.apply),

  /// 当落発表日時ちょうど。
  resultAt(2, TicketDeadlineKind.result),

  /// 入金期限の前日 20:00。
  paymentEve(3, TicketDeadlineKind.payment),

  /// 入金期限の3時間前。
  paymentSoon(4, TicketDeadlineKind.payment);

  const ReminderSlot(this.slotNumber, this.kind);

  /// 通知 ID に使う枠番号。
  final int slotNumber;

  /// 対象の期限。
  final TicketDeadlineKind kind;
}

/// 予約する1件の通知。
final class PlannedReminder {
  /// 予約の内容を保持する。
  const PlannedReminder({
    required this.applicationId,
    required this.slot,
    required this.fireAt,
    required this.deadlineAt,
  });

  /// 対象のチケット申込。
  final int applicationId;

  /// 通知の枠。
  final ReminderSlot slot;

  /// 通知する瞬間（UTC）。
  final DateTime fireAt;

  /// 対象の期限の瞬間（UTC）。
  final DateTime deadlineAt;

  /// 同じ申込・同じ枠で常に同じになる通知 ID。
  int get notificationId => applicationId * 8 + slot.slotNumber;
}

/// リマインドの予約を組み立てるための、チケット申込の事実。
final class ReminderFacts {
  /// 予約に必要な項目だけを持つ。
  const ReminderFacts({
    required this.applicationId,
    required this.stage,
    this.applyDeadlineAt,
    this.resultAt,
    this.paymentDeadlineAt,
  });

  /// チケット申込の ID。
  final int applicationId;

  /// 申込段階。
  final TicketApplicationStage stage;

  /// 申込締切。
  final DateTime? applyDeadlineAt;

  /// 当落発表日時。
  final DateTime? resultAt;

  /// 入金期限。
  final DateTime? paymentDeadlineAt;

  /// [kind] の期限。
  DateTime? deadlineOf(TicketDeadlineKind kind) => switch (kind) {
    TicketDeadlineKind.apply => applyDeadlineAt,
    TicketDeadlineKind.result => resultAt,
    TicketDeadlineKind.payment => paymentDeadlineAt,
  };
}

/// iOS のローカル通知の上限（64件）に余裕を持たせた予約数の上限。
const int maxScheduledReminders = 60;

/// [applications] から予約する通知を、通知の早い順に最大 [limit] 件返す。
///
/// 段階に関係する期限だけを対象にし、[now] 以前のタイミングは除く。
/// [enabledKinds] に含まれない期限はリマインドしない。
List<PlannedReminder> planReminders({
  required Iterable<ReminderFacts> applications,
  required DateTime now,
  required Set<TicketDeadlineKind> enabledKinds,
  int limit = maxScheduledReminders,
}) {
  final planned = <PlannedReminder>[];
  for (final application in applications) {
    final kind = application.stage.remindedDeadline;
    if (kind == null || !enabledKinds.contains(kind)) continue;
    final deadline = application.deadlineOf(kind);
    if (deadline == null) continue;
    for (final slot in ReminderSlot.values.where((s) => s.kind == kind)) {
      final fireAt = _fireAt(slot, deadline.toUtc());
      if (!fireAt.isAfter(now)) continue;
      planned.add(
        PlannedReminder(
          applicationId: application.applicationId,
          slot: slot,
          fireAt: fireAt,
          deadlineAt: deadline.toUtc(),
        ),
      );
    }
  }
  planned.sort((a, b) => a.fireAt.compareTo(b.fireAt));
  return planned.length > limit ? planned.sublist(0, limit) : planned;
}

DateTime _fireAt(ReminderSlot slot, DateTime deadline) => switch (slot) {
  ReminderSlot.applyEve || ReminderSlot.paymentEve => JapanTime.instantOf(
    JapanTime.dateOf(deadline).addDays(-1),
    hour: 20,
  ),
  ReminderSlot.applySoon ||
  ReminderSlot.paymentSoon => deadline.subtract(const Duration(hours: 3)),
  ReminderSlot.resultAt => deadline,
};
