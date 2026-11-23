import 'package:app/application/application.dart';
import 'package:app/domain/domain.dart';
import 'package:ticket_eplus/ticket_eplus.dart';
import 'package:ticket_livepocket/ticket_livepocket.dart';
import 'package:ticket_platform_interface/ticket_platform_interface.dart';

/// eplus とライブポケットのメールから公演情報を読み取る。
final class TicketMailParser {
  /// 対応するチケットサービスの抽出処理を使う。
  const TicketMailParser();

  /// 対応するチケットサービス。
  static const List<TicketService> services = [
    EplusTicketService(),
    LivepocketTicketService(),
  ];

  /// 公演情報を読み取れたら [TicketMail] を返す。対象外や読み取れなければ null。
  ///
  /// 現行の抽出処理は決済完了メールだけを扱う。
  TicketMail? parse({
    required String messageId,
    required DateTime receivedAt,
    required String from,
    required String subject,
    required String bodyText,
  }) {
    for (final service in services) {
      if (!from.contains(service.senderAddress)) continue;
      final info = service.extract(subject: subject, bodyText: bodyText);
      if (info == null) return null;
      final wall = info.startsAt;
      return TicketMail(
        messageId: messageId,
        receivedAt: receivedAt.toUtc(),
        subject: subject,
        service: service is LivepocketTicketService
            ? TicketServiceKind.livepocket
            : TicketServiceKind.eplus,
        kind: TicketMailKind.payment,
        title: info.title,
        // 抽出処理は日本時間の壁時計の値を返すため瞬間へ変換する。
        startsAt: JapanTime.instantOf(
          LocalDate(wall.year, wall.month, wall.day),
          hour: wall.hour,
          minute: wall.minute,
        ),
        venue: info.venue.isEmpty ? null : info.venue,
        priceYen: info.price,
      );
    }
    return null;
  }
}
