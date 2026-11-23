import 'package:app/application/application.dart';
import 'package:app/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/test_graph.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final applyDeadline = DateTime.utc(2026, 11, 25, 14, 59);

  late TestGraph t;
  late TicketApplicationUseCase tickets;
  late int performanceId;

  setUp(() async {
    t = await TestGraph.create();
    tickets = t.graph.ticketApplication;
    performanceId = await t.graph.performance.create(
      PerformanceDraft(title: 'Live', startsAt: DateTime.utc(2026, 12, 1, 9)),
    );
  });
  tearDown(() => t.close());

  TicketApplicationDraft draft({
    TicketApplicationStage stage = TicketApplicationStage.planned,
    DateTime? apply,
    String? reference,
    String? note,
  }) => TicketApplicationDraft(
    performanceId: performanceId,
    stage: stage,
    service: TicketServiceKind.eplus,
    referenceNo: reference,
    applyDeadlineAt: apply,
    note: note,
  );

  group('save', () {
    test(
      'asks for notification permission once across saves with deadlines',
      () async {
        await tickets.save(draft(apply: applyDeadline));
        await tickets.save(draft(apply: applyDeadline));

        expect(t.scheduler.requestCount, 1);
      },
    );

    test('does not ask for permission without a deadline', () async {
      await tickets.save(draft());

      expect(t.scheduler.requestCount, 0);
      expect(
        t.graph.appPreferences.load().notificationPermissionRequested,
        isFalse,
      );
    });

    test('schedules reminders for the saved deadline', () async {
      final id = await tickets.save(draft(apply: applyDeadline));

      expect(
        t.scheduler.scheduled.map((r) => (r.plan.applicationId, r.plan.slot)),
        [(id, ReminderSlot.applyEve), (id, ReminderSlot.applySoon)],
      );
    });

    test('trims reference and note and stores blanks as none', () async {
      final id = await tickets.save(draft(reference: '  A-1 ', note: '   '));

      final saved = (await tickets.find(id))!;
      expect(saved.referenceNo, 'A-1');
      expect(saved.note, isNull);
    });

    test('stores deadlines as UTC', () async {
      final id = await tickets.save(draft(apply: applyDeadline.toLocal()));

      final saved = (await tickets.find(id))!;
      expect(saved.applyDeadlineAt, applyDeadline);
      expect(saved.applyDeadlineAt!.isUtc, isTrue);
    });

    test(
      'with an id updates the existing application and reschedules',
      () async {
        final id = await tickets.save(draft(apply: applyDeadline));

        final savedId = await tickets.save(
          draft(stage: TicketApplicationStage.secured, apply: applyDeadline),
          id: id,
        );

        expect(savedId, id);
        expect(await tickets.listForPerformance(performanceId), hasLength(1));
        expect((await tickets.find(id))!.stage, TicketApplicationStage.secured);
        expect(t.scheduler.scheduled, isEmpty);
      },
    );

    test(
      'a scheduling failure propagates after the record is stored',
      () async {
        t.scheduler.replaceError = Exception('plugin');

        await expectLater(
          tickets.save(draft(apply: applyDeadline)),
          throwsException,
        );
        expect(await tickets.listForPerformance(performanceId), hasLength(1));
      },
    );
  });

  group('advance', () {
    test('moves from the action stage and reschedules', () async {
      final id = await tickets.save(draft(apply: applyDeadline));

      final change = await tickets.advance(id, QuickStageAction.applied);

      expect(change!.applicationId, id);
      expect(change.performanceTitle, 'Live');
      expect(change.from, TicketApplicationStage.planned);
      expect(change.to, TicketApplicationStage.awaitingResult);
      expect(
        (await tickets.find(id))!.stage,
        TicketApplicationStage.awaitingResult,
      );
      // 結果待ちには当落発表日時がないので予約は空になる。
      expect(t.scheduler.scheduled, isEmpty);
    });

    test('returns null when the stage does not match', () async {
      final id = await tickets.save(draft());

      expect(await tickets.advance(id, QuickStageAction.paid), isNull);
      expect((await tickets.find(id))!.stage, TicketApplicationStage.planned);
    });

    test('returns null for a missing application', () async {
      expect(await tickets.advance(999, QuickStageAction.applied), isNull);
    });

    test('undo restores the previous stage and its reminders', () async {
      final id = await tickets.save(draft(apply: applyDeadline));
      final change = await tickets.advance(id, QuickStageAction.applied);

      await tickets.undo(change!);

      expect((await tickets.find(id))!.stage, TicketApplicationStage.planned);
      expect(t.scheduler.scheduled, hasLength(2));
    });
  });

  test('delete removes the application and its reminders', () async {
    final id = await tickets.save(draft(apply: applyDeadline));

    await tickets.delete(id);

    expect(await tickets.find(id), isNull);
    expect(t.scheduler.scheduled, isEmpty);
  });

  test('loadUpcoming lists open deadlines as todos, earliest first', () async {
    final later = await tickets.save(
      draft(apply: applyDeadline.add(const Duration(days: 1))),
    );
    final early = await tickets.save(draft(apply: applyDeadline));
    final overdue = await tickets.save(
      draft(apply: DateTime.utc(2026, 11, 20)),
    );
    await tickets.save(draft(stage: TicketApplicationStage.secured));

    final overview = await tickets.loadUpcoming();

    expect(overview.todos.map((todo) => todo.application.id), [
      overdue,
      early,
      later,
    ]);
    expect(overview.todos.map((todo) => todo.isOverdue), [true, false, false]);
    expect(overview.performances.single.daysUntil, 9);
  });
}
