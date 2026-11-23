import 'package:app/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TicketApplicationStage', () {
    test('gmailRank orders the stages, with lost beside awaitingPayment', () {
      expect(
        {for (final s in TicketApplicationStage.values) s: s.gmailRank},
        {
          TicketApplicationStage.planned: 0,
          TicketApplicationStage.awaitingResult: 1,
          TicketApplicationStage.awaitingPayment: 2,
          TicketApplicationStage.lost: 2,
          TicketApplicationStage.secured: 3,
        },
      );
    });

    test('each open stage reminds its own deadline; final stages none', () {
      expect(
        {for (final s in TicketApplicationStage.values) s: s.remindedDeadline},
        {
          TicketApplicationStage.planned: TicketDeadlineKind.apply,
          TicketApplicationStage.awaitingResult: TicketDeadlineKind.result,
          TicketApplicationStage.awaitingPayment: TicketDeadlineKind.payment,
          TicketApplicationStage.secured: null,
          TicketApplicationStage.lost: null,
        },
      );
    });

    test('only secured and lost are final', () {
      expect(
        TicketApplicationStage.values.where((s) => s.isFinal),
        [TicketApplicationStage.secured, TicketApplicationStage.lost],
      );
    });

    test('mail advances to a later stage, skipping intermediate ones', () {
      expect(
        TicketApplicationStage.planned.advancedByMailTo(
          TicketApplicationStage.secured,
        ),
        TicketApplicationStage.secured,
      );
      expect(
        TicketApplicationStage.awaitingResult.advancedByMailTo(
          TicketApplicationStage.lost,
        ),
        TicketApplicationStage.lost,
      );
    });

    test('mail never moves back or sideways', () {
      expect(
        TicketApplicationStage.awaitingPayment.advancedByMailTo(
          TicketApplicationStage.awaitingResult,
        ),
        isNull,
      );
      expect(
        TicketApplicationStage.awaitingPayment.advancedByMailTo(
          TicketApplicationStage.lost,
        ),
        isNull,
      );
      expect(
        TicketApplicationStage.awaitingResult.advancedByMailTo(
          TicketApplicationStage.awaitingResult,
        ),
        isNull,
      );
    });

    test('mail never changes a final stage', () {
      for (final target in TicketApplicationStage.values) {
        expect(TicketApplicationStage.lost.advancedByMailTo(target), isNull);
        expect(
          TicketApplicationStage.secured.advancedByMailTo(target),
          isNull,
        );
      }
    });
  });

  group('TicketDeadlineKind', () {
    test('quick actions per deadline', () {
      expect(TicketDeadlineKind.apply.quickActions, [QuickStageAction.applied]);
      expect(TicketDeadlineKind.result.quickActions, [
        QuickStageAction.won,
        QuickStageAction.lost,
      ]);
      expect(TicketDeadlineKind.payment.quickActions, [QuickStageAction.paid]);
    });

    test('quick actions start from the stage that reminds that deadline', () {
      for (final kind in TicketDeadlineKind.values) {
        for (final action in kind.quickActions) {
          expect(action.from.remindedDeadline, kind, reason: action.name);
        }
      }
    });

    test('result defaults to noon, other deadlines to 23:59', () {
      expect(
        (
          TicketDeadlineKind.result.defaultHour,
          TicketDeadlineKind.result.defaultMinute,
        ),
        (12, 0),
      );
      for (final kind in [
        TicketDeadlineKind.apply,
        TicketDeadlineKind.payment,
      ]) {
        expect((kind.defaultHour, kind.defaultMinute), (23, 59));
      }
    });
  });

  group('QuickStageAction', () {
    test('moves along the application flow', () {
      expect(
        {for (final a in QuickStageAction.values) a: (a.from, a.to)},
        {
          QuickStageAction.applied: (
            TicketApplicationStage.planned,
            TicketApplicationStage.awaitingResult,
          ),
          QuickStageAction.won: (
            TicketApplicationStage.awaitingResult,
            TicketApplicationStage.awaitingPayment,
          ),
          QuickStageAction.lost: (
            TicketApplicationStage.awaitingResult,
            TicketApplicationStage.lost,
          ),
          QuickStageAction.paid: (
            TicketApplicationStage.awaitingPayment,
            TicketApplicationStage.secured,
          ),
        },
      );
    });
  });
}
