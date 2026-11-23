import 'package:app/application/application.dart';
import 'package:app/application/errors/gmail_error.dart';
import 'package:app/domain/domain.dart';
import 'package:app/infrastructure/infrastructure.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/test_graph.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late TestGraph t;

  setUp(() async {
    // 2026-11-22 12:00 JST。OAuth の設定がないのでデモの Gmail を使う。
    t = await TestGraph.create();
  });
  tearDown(() => t.close());

  Future<GmailConnection?> connection() =>
      DriftGmailImportRepository(t.database).loadConnection();

  GmailUseCase withMailbox(GmailMailbox mailbox) {
    final db = t.database;
    return GmailUseCase(
      mailbox: mailbox,
      imports: DriftGmailImportRepository(db),
      unitOfWork: DriftUnitOfWork(db),
      performances: DriftPerformanceRepository(db),
      expenses: DriftExpenseRepository(db),
      applications: DriftTicketApplicationRepository(db),
      reminders: t.graph.reminders,
      clock: t.clock,
    );
  }

  group('with the demo mailbox', () {
    test('reports demo mode and no connection before connecting', () async {
      final status = await t.graph.gmail.loadStatus();

      expect(status.isDemo, isTrue);
      expect(status.connection, isNull);
      expect(await t.graph.gmail.sync(), isNull);
    });

    test('connect stores the demo account with the current time', () async {
      expect(await t.graph.gmail.connect(), isTrue);

      final saved = (await connection())!;
      expect(saved.accountEmail, DemoGmailMailbox.accountEmail);
      expect(saved.connectedAt, t.clock.instant);
    });

    test('sync imports readable payment mails as ticket expenses', () async {
      await t.graph.gmail.connect();

      final result = (await t.graph.gmail.sync())!;

      expect(result.importedMailCount, 4);
      expect(result.createdExpenseCount, 4);
      expect(
        await DriftExpenseRepository(t.database).monthlySpendByPaidOn(),
        {YearMonth(2026, 10): 3500, YearMonth(2026, 11): 4000 + 6800 + 12000},
      );
    });

    test(
      'sync creates performances and secured, imported applications',
      () async {
        await t.graph.gmail.connect();
        await t.graph.gmail.sync();

        final performances = await t.graph.performance.listAll();
        final applications = await DriftTicketApplicationRepository(
          t.database,
        ).listForPerformances(performances.map((p) => p.id));

        expect(performances.map((p) => p.title).toSet(), {
          '定期公演 vol.11',
          'ナイトサーキット 2026',
          'クリスマス公演',
          '春ツアー2027 東京公演',
        });
        expect(applications, hasLength(4));
        expect(
          applications.every(
            (a) => a.stage == TicketApplicationStage.secured && a.isImported,
          ),
          isTrue,
        );
      },
    );

    test('sync records the newest received time and clears failures', () async {
      await t.graph.gmail.connect();
      await t.graph.gmail.sync();

      final saved = (await connection())!;
      // 2日前（11-20）21:04 JST に受信した最新のメール。
      expect(saved.lastMessageReceivedAt, DateTime.utc(2026, 11, 20, 12, 4));
      expect(saved.lastFetchedAt, t.clock.instant);
      expect(saved.lastFailedAt, isNull);
    });

    test('a second sync imports nothing twice', () async {
      await t.graph.gmail.connect();
      await t.graph.gmail.sync();

      final second = (await t.graph.gmail.sync())!;

      expect(second.importedMailCount, 0);
      expect(second.createdExpenseCount, 0);
      expect(await t.graph.performance.listAll(), hasLength(4));
    });

    test(
      'advances an existing open application instead of adding one',
      () async {
        final performanceId = await t.graph.performance.create(
          // クリスマス公演: 31日後の 18:30 JST。
          PerformanceDraft(
            title: 'クリスマス公演',
            startsAt: DateTime.utc(2026, 12, 23, 9, 30),
          ),
        );
        final applications = DriftTicketApplicationRepository(t.database);
        final id = await applications.create(
          TicketApplicationDraft(
            performanceId: performanceId,
            stage: TicketApplicationStage.awaitingPayment,
            service: TicketServiceKind.eplus,
          ),
        );
        await t.graph.gmail.connect();

        await t.graph.gmail.sync();

        final forPerformance = await applications.listForPerformance(
          performanceId,
        );
        expect(forPerformance.map((a) => a.id), [id]);
        expect(forPerformance.single.stage, TicketApplicationStage.secured);
        expect(await t.graph.performance.listAll(), hasLength(4));
      },
    );

    test('reconnecting the same account keeps the sync state', () async {
      await t.graph.gmail.connect();
      await t.graph.gmail.sync();
      final before = (await connection())!;

      await t.graph.gmail.connect();

      final after = (await connection())!;
      expect(after.connectedAt, before.connectedAt);
      expect(after.lastMessageReceivedAt, before.lastMessageReceivedAt);
    });

    test(
      'disconnect forgets the connection but keeps imported records',
      () async {
        await t.graph.gmail.connect();
        await t.graph.gmail.sync();

        await t.graph.gmail.disconnect();

        expect(await connection(), isNull);
        expect(await t.graph.performance.listAll(), hasLength(4));
      },
    );

    test(
      'a reminder scheduling failure keeps the import and is not a sync '
      'failure',
      () async {
        await t.graph.gmail.connect();
        final failure = Exception('plugin');
        t.scheduler.replaceError = failure;

        await expectLater(t.graph.gmail.sync(), throwsA(same(failure)));

        final saved = (await connection())!;
        expect(saved.lastFetchedAt, isNotNull);
        expect(saved.lastFailedAt, isNull);
        expect(await t.graph.performance.listAll(), hasLength(4));
      },
    );
  });

  group('failures', () {
    test('a cancelled connect stores nothing', () async {
      final gmail = withMailbox(_FakeMailbox(account: null));

      expect(await gmail.connect(), isFalse);
      expect(await connection(), isNull);
    });

    test('connect wraps unexpected errors as GmailSyncException', () async {
      final gmail = withMailbox(_FakeMailbox(connectError: StateError('x')));

      await expectLater(gmail.connect(), throwsA(isA<GmailSyncException>()));
    });

    test('connecting another account replaces the previous one', () async {
      await t.graph.gmail.connect();
      await t.graph.gmail.sync();

      await withMailbox(_FakeMailbox(account: 'other@example.com')).connect();

      final saved = (await connection())!;
      expect(saved.accountEmail, 'other@example.com');
      expect(saved.lastMessageReceivedAt, isNull);
    });

    test('a fetch failure is recorded as other and rethrown wrapped', () async {
      final gmail = withMailbox(_FakeMailbox(fetchError: StateError('x')));
      await gmail.connect();

      await expectLater(gmail.sync(), throwsA(isA<GmailSyncException>()));

      final saved = (await connection())!;
      expect(saved.lastFailureKind, GmailFailureKind.other);
      expect(saved.lastFailedAt, t.clock.instant);
      expect(saved.lastFetchedAt, isNull);
    });

    test(
      'a restore of a different account requires reauthentication',
      () async {
        final mailbox = _FakeMailbox();
        final gmail = withMailbox(mailbox);
        await gmail.connect();
        mailbox.restored = null;

        await expectLater(
          gmail.sync(),
          throwsA(isA<GmailReauthRequiredException>()),
        );
        expect(
          (await connection())!.lastFailureKind,
          GmailFailureKind.reauthRequired,
        );
      },
    );

    test('the next successful sync clears the recorded failure', () async {
      final mailbox = _FakeMailbox(fetchError: StateError('x'));
      final gmail = withMailbox(mailbox);
      await gmail.connect();
      await expectLater(gmail.sync(), throwsA(isA<GmailSyncException>()));

      mailbox.fetchError = null;
      await gmail.sync();

      final saved = (await connection())!;
      expect(saved.lastFailedAt, isNull);
      expect(saved.lastFailureKind, isNull);
      expect(saved.lastFetchedAt, t.clock.instant);
    });
  });
}

class _FakeMailbox implements GmailMailbox {
  _FakeMailbox({
    this.account = 'me@example.com',
    this.connectError,
    this.fetchError,
  }) : restored = account;

  final String? account;
  final Error? connectError;
  Error? fetchError;
  String? restored;

  @override
  bool get isDemo => false;

  @override
  Future<String?> connect() async {
    if (connectError case final error?) throw error;
    return account;
  }

  @override
  Future<String?> restore() async => restored;

  @override
  Future<List<TicketMail>> fetchTicketMails({required DateTime after}) async {
    if (fetchError case final error?) throw error;
    return const [];
  }

  @override
  Future<void> disconnect() async {}
}
