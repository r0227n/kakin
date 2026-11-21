import 'package:meta/meta.dart';

/// メールから抽出した公演情報。
///
/// チケットサービスが対象メールから抽出し、正規化した不変の値オブジェクト。
@immutable
final class TicketInfo {
  const TicketInfo({
    required this.title,
    required this.startsAt,
    required this.venue,
    required this.price,
  });

  /// 公演名。本文から抽出し、本文に無い場合は件名から補う。
  final String title;

  /// 公演の日時。
  final DateTime startsAt;

  /// 公演の場所(会場名)。
  final String venue;

  /// 注文のチケット料金の合計(円)。手数料やシステム利用料は含まない。
  ///
  /// 料金の内訳が記載されないメール(一部の旧形式)では、
  /// 手数料を含む支払総額になる。
  final int price;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TicketInfo &&
          other.title == title &&
          other.startsAt == startsAt &&
          other.venue == venue &&
          other.price == price;

  @override
  int get hashCode => Object.hash(title, startsAt, venue, price);

  @override
  String toString() =>
      'TicketInfo(title: $title, startsAt: $startsAt, venue: $venue, '
      'price: $price)';
}
