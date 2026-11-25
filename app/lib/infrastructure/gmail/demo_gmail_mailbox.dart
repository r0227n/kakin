import 'package:app/application/application.dart';
import 'package:app/domain/domain.dart';
import 'package:app/infrastructure/gmail/ticket_mail_parser.dart';

/// OAuth クライアントがないときに使う、モックデータの Gmail。
///
/// 決済完了メールの件名と本文を本物の抽出処理に通して返す。
/// 1通は公演情報を読み取れないメールで、取り込まれない。
final class DemoGmailMailbox implements GmailMailbox {
  /// 時計の今日からメールの受信日時と公演日を決める。
  DemoGmailMailbox(this._clock);

  /// デモで連携するアカウント。
  static const accountEmail = 'demo@kakin.example';

  final Clock _clock;
  final TicketMailParser _parser = const TicketMailParser();

  @override
  bool get isDemo => true;

  @override
  Future<String?> connect() async => accountEmail;

  @override
  Future<String?> restore() async => accountEmail;

  @override
  Future<void> disconnect() async {}

  @override
  Future<List<TicketMail>> fetchTicketMails({required DateTime after}) async {
    final today = JapanTime.dateOf(_clock.now());
    return [
      for (final message in _messages(today))
        if (!message.receivedAt.isBefore(after))
          ?_parser.parse(
            messageId: message.id,
            receivedAt: message.receivedAt,
            from: message.from,
            subject: message.subject,
            bodyText: message.body,
          ),
    ];
  }

  List<_DemoMessage> _messages(LocalDate today) {
    DateTime received(int daysAgo) =>
        JapanTime.instantOf(today.addDays(-daysAgo), hour: 21, minute: 4);
    return [
      _eplus(
        'demo-eplus-1',
        received(40),
        today.addDays(-12),
        '定期公演 vol.11',
        '新宿 ステージ7',
        3500,
      ),
      _livepocket(
        'demo-lp-1',
        received(18),
        today.addDays(9),
        'ナイトサーキット 2026',
        '渋谷 ホールB',
        4000,
      ),
      _eplus(
        'demo-eplus-2',
        received(6),
        today.addDays(31),
        'クリスマス公演',
        '池袋 ホールC',
        6800,
      ),
      _livepocket(
        'demo-lp-2',
        received(2),
        today.addDays(52),
        '春ツアー2027 東京公演',
        '有明 アリーナD',
        12000,
      ),
      _DemoMessage(
        id: 'demo-eplus-unreadable',
        receivedAt: received(1),
        from: 'info@eplus.co.jp',
        subject: '【e+より】申込み完了・決済に関するご案内',
        body: 'お申込みありがとうございます。詳細はマイページでご確認ください。',
      ),
    ];
  }

  _DemoMessage _eplus(
    String id,
    DateTime receivedAt,
    LocalDate showOn,
    String title,
    String venue,
    int price,
  ) => _DemoMessage(
    id: id,
    receivedAt: receivedAt,
    from: 'e+ <info@eplus.co.jp>',
    subject: '【e+より】《必ずご確認ください》申込み完了・決済に関するご案内',
    body:
        '''
一般発売
公演名　　　：　$title
会場名　　　：　$venue
公演日時　　：　${showOn.year}/${showOn.month}/${showOn.day}(日)  17：30開場 18：30開演
席種・料金　：　前売り \\$price×1枚［チケット料金］

料金
　　購入合計　：　\\${price + 330}（消費税込み）
　　内訳
　　　チケット料金　：　\\$price
　　　システム利用料　：　\\330
''',
  );

  _DemoMessage _livepocket(
    String id,
    DateTime receivedAt,
    LocalDate showOn,
    String title,
    String venue,
    int price,
  ) => _DemoMessage(
    id: id,
    receivedAt: receivedAt,
    from: 'LivePocket <noreply@livepocket.jp>',
    subject: '[LivePocket]購入完了のお知らせ（$id）',
    body:
        '''
下記のチケットの購入が完了しました。
イベント名：$title
会場：$venue
イベント開催日：${showOn.year}年${showOn.month}月${showOn.day}日(土)
　[開場時間]16:00  [開演時間]17:00

一般：¥$price
　チケット料金：¥$price × 1枚 = ¥$price

合計金額：¥${price + 195} (税込)
''',
  );
}

final class _DemoMessage {
  const _DemoMessage({
    required this.id,
    required this.receivedAt,
    required this.from,
    required this.subject,
    required this.body,
  });

  final String id;
  final DateTime receivedAt;
  final String from;
  final String subject;
  final String body;
}
