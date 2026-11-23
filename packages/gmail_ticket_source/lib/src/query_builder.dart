import 'package:ticket_platform_interface/ticket_platform_interface.dart';

/// 各サービスの送信者と件名キーワードから既定の Gmail 検索クエリを組み立てる。
String buildDefaultQuery(List<TicketService> services) {
  final senders = <String>{
    for (final service in services) service.senderAddress,
  };
  final keywords = <String>{
    for (final service in services) ...service.subjectKeywords,
  };
  final fromClause = 'from:(${senders.join(' OR ')})';
  final subjectClause = keywords
      .map((keyword) => 'subject:"$keyword"')
      .join(' OR ');
  return '$fromClause ($subjectClause)';
}

/// [query] に以降日付の条件(after:)を追加する。
String applySince(String query, DateTime since) =>
    '$query after:${since.year}/${since.month}/${since.day}';
