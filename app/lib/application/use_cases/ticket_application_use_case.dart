import 'package:app/application/models/records.dart';
import 'package:app/application/models/views.dart';
import 'package:app/application/ports/device_ports.dart';
import 'package:app/application/ports/record_repositories.dart';
import 'package:app/application/use_cases/reminder_use_case.dart';
import 'package:app/domain/domain.dart';

/// チケット申込と今後の公演の入力境界。
final class TicketApplicationUseCase {
  /// 保存先・リマインド・時計を注入する。
  const TicketApplicationUseCase(
    this._applications,
    this._performances,
    this._reminders,
    this._clock,
  );

  final TicketApplicationRepository _applications;
  final PerformanceRepository _performances;
  final ReminderUseCase _reminders;
  final Clock _clock;

  /// やることと今後の公演。
  Future<UpcomingOverview> loadUpcoming() async {
    final now = _clock.now();
    final today = JapanTime.dateOf(now);
    final (open, performances) = await (
      _applications.listOpen(),
      _performances.listUpcoming(today),
    ).wait;
    final todos = <TodoItem>[];
    for (final application in open) {
      final kind = application.stage.remindedDeadline;
      final dueAt = kind == null ? null : application.deadlineOf(kind);
      if (kind == null || dueAt == null) continue;
      todos.add(
        TodoItem(
          application: application,
          kind: kind,
          dueAt: dueAt,
          isOverdue: dueAt.isBefore(now),
        ),
      );
    }
    todos.sort((a, b) => a.dueAt.compareTo(b.dueAt));
    final applications = await _applications.listForPerformances(
      performances.map((p) => p.id),
    );
    return UpcomingOverview(
      todos: todos,
      performances: [
        for (final performance in performances)
          UpcomingPerformance(
            performance: performance,
            stages: [
              for (final a in applications)
                if (a.performance.id == performance.id) a.stage,
            ],
            daysUntil: today.daysUntil(performance.startsOn),
          ),
      ],
    );
  }

  /// [performanceId] のチケット申込。
  Future<List<TicketApplication>> listForPerformance(int performanceId) =>
      _applications.listForPerformance(performanceId);

  /// [id] のチケット申込。
  Future<TicketApplication?> find(int id) => _applications.find(id);

  /// 登録または編集し、予約し直す。初めて期限を登録したときは通知の許可を求める。
  Future<int> save(TicketApplicationDraft draft, {int? id}) async {
    final normalized = _normalized(draft);
    final savedId = id ?? await _applications.create(normalized);
    if (id != null) await _applications.update(id, normalized);
    await _reminders.rebuild();
    if (normalized.hasDeadline) await _reminders.requestPermissionOnce();
    return savedId;
  }

  /// 削除し、予約し直す。
  Future<void> delete(int id) async {
    await _applications.delete(id);
    await _reminders.rebuild();
  }

  /// ワンタップで段階を進める。対象の段階でなければ null。
  Future<StageChange?> advance(int id, QuickStageAction action) async {
    final application = await _applications.find(id);
    if (application == null || application.stage != action.from) return null;
    await _applications.updateStage(id, action.to);
    await _reminders.rebuild();
    return StageChange(
      applicationId: id,
      performanceTitle: application.performance.title,
      from: action.from,
      to: action.to,
    );
  }

  /// [change] の前の段階に戻す。
  Future<void> undo(StageChange change) async {
    await _applications.updateStage(change.applicationId, change.from);
    await _reminders.rebuild();
  }

  TicketApplicationDraft _normalized(TicketApplicationDraft draft) {
    final reference = draft.referenceNo?.trim();
    final note = draft.note?.trim();
    return TicketApplicationDraft(
      performanceId: draft.performanceId,
      stage: draft.stage,
      service: draft.service,
      referenceNo: reference == null || reference.isEmpty ? null : reference,
      applyDeadlineAt: draft.applyDeadlineAt?.toUtc(),
      resultAt: draft.resultAt?.toUtc(),
      paymentDeadlineAt: draft.paymentDeadlineAt?.toUtc(),
      note: note == null || note.isEmpty ? null : note,
    );
  }
}
