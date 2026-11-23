import 'package:app/application/errors/gmail_error.dart';
import 'package:app/application/models/gmail.dart';
import 'package:app/application/models/records.dart';
import 'package:app/application/ports/device_ports.dart';
import 'package:app/application/ports/gmail_ports.dart';
import 'package:app/application/ports/record_repositories.dart';
import 'package:app/domain/domain.dart';

/// Gmail 連携と自動転記の入力境界。
final class GmailUseCase {
  /// メールの取得元・保存先・時計を注入する。
  const GmailUseCase({
    required this._mailbox,
    required this._imports,
    required this._unitOfWork,
    required this._performances,
    required this._expenses,
    required this._clock,
  });

  final GmailMailbox _mailbox;
  final GmailImportRepository _imports;
  final UnitOfWork _unitOfWork;
  final PerformanceRepository _performances;
  final ExpenseRepository _expenses;
  final Clock _clock;

  /// 連携の状態。
  Future<GmailStatus> loadStatus() async => GmailStatus(
    isDemo: _mailbox.isDemo,
    connection: await _imports.loadConnection(),
  );

  /// 利用者の操作で連携する。取り消したら false。
  ///
  /// 再連携では同期状態を残し、前回の同期以降のメールから取り込みを再開する。
  Future<bool> connect() async {
    final String? account;
    try {
      account = await _mailbox.connect();
    } on GmailReauthRequiredException {
      rethrow;
    } on Object catch (error, stackTrace) {
      throw GmailSyncException(cause: error, causeStackTrace: stackTrace);
    }
    if (account == null) return false;
    final current = await _imports.loadConnection();
    if (current != null && current.accountEmail != account) {
      await _imports.deleteConnection(current.accountEmail);
    }
    if (current?.accountEmail != account) {
      await _imports.saveConnection(account, _clock.now());
    }
    return true;
  }

  /// 連携を解除する。取り込み済みの公演と支出は残す。
  Future<void> disconnect() async {
    final current = await _imports.loadConnection();
    await _mailbox.disconnect();
    if (current != null) await _imports.deleteConnection(current.accountEmail);
  }

  /// 前回の同期以降のメールを取り込む。未連携なら null。
  ///
  /// 失敗したら最終同期日時は変えず、失敗の種類を記録して例外を返す。
  Future<GmailSyncResult?> sync() async {
    final connection = await _imports.loadConnection();
    if (connection == null) return null;
    final account = connection.accountEmail;
    try {
      final restored = await _mailbox.restore();
      if (restored != account) throw const GmailReauthRequiredException();
      final mails = await _mailbox.fetchTicketMails(
        after: connection.fetchAfter,
      );
      return await _unitOfWork.run(() => _import(connection, mails));
    } on Object catch (error, stackTrace) {
      final kind = error is GmailReauthRequiredException
          ? GmailFailureKind.reauthRequired
          : GmailFailureKind.other;
      await _imports.recordFailure(
        account,
        failedAt: _clock.now(),
        kind: kind,
      );
      if (error is GmailReauthRequiredException) rethrow;
      if (error is GmailSyncException) rethrow;
      throw GmailSyncException(cause: error, causeStackTrace: stackTrace);
    }
  }

  Future<GmailSyncResult> _import(
    GmailConnection connection,
    List<TicketMail> mails,
  ) async {
    final account = connection.accountEmail;
    final imported = await _imports.importedMessageIds(
      account,
      mails.map((m) => m.messageId),
    );
    final pending = mails.where((m) => !imported.contains(m.messageId)).toList()
      ..sort((a, b) => a.receivedAt.compareTo(b.receivedAt));
    var watermark = connection.lastMessageReceivedAt;
    for (final mail in pending) {
      final importId = await _imports.recordImport(account, mail);
      await _expenses.addImported(
        ExpenseDraft(
          category: ExpenseCategory.ticket,
          amountYen: mail.priceYen,
          paidOn: JapanTime.dateOf(mail.receivedAt),
          performanceId: await _performanceFor(mail),
        ),
        emailImportId: importId,
      );
      if (watermark == null || mail.receivedAt.isAfter(watermark)) {
        watermark = mail.receivedAt;
      }
    }
    await _imports.recordSuccess(
      account,
      fetchedAt: _clock.now(),
      lastMessageReceivedAt: watermark,
    );
    return GmailSyncResult(importedMailCount: pending.length);
  }

  Future<int> _performanceFor(TicketMail mail) async {
    final existing = await _performances.findByTitleAndStart(
      mail.title,
      mail.startsAt,
    );
    if (existing != null) return existing.id;
    return _performances.create(
      PerformanceDraft(
        title: mail.title,
        startsAt: mail.startsAt.toUtc(),
        venue: mail.venue,
      ),
    );
  }
}
