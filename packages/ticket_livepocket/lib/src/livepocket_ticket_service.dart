import 'package:ticket_platform_interface/ticket_platform_interface.dart';

/// ライブポケット(noreply@livepocket.jp)からのメールから公演情報を抽出する
/// [TicketService] の実装。
///
/// 対象メールの本文は `イベント名：値` 形式のラベル行で構成され、
/// 公演の開始時刻は `[開場時間]` / `[開演時間]` の行に記載される。
/// 料金の内訳を含む新形式と、`日程` / `支払金額` を使う旧形式の
/// どちらも対象とする。
class LivepocketTicketService implements TicketService {
  const LivepocketTicketService();

  @override
  String get name => 'livepocket';

  @override
  String get senderAddress => 'noreply@livepocket.jp';

  @override
  List<String> get subjectKeywords => const <String>['購入完了のお知らせ'];

  @override
  TicketInfo? extract({required String subject, required String bodyText}) {
    if (!subjectKeywords.any(subject.contains)) {
      return null;
    }
    final lines = bodyText.replaceAll('\r\n', '\n').split('\n');
    final title = _labeledValue(lines, 'イベント名');
    final titleText = (title == null || title.isEmpty) ? subject.trim() : title;
    final venue = _labeledValue(lines, '会場');
    final startsAt = _parseStartsAt(
      dateValue: _labeledValue(lines, 'イベント開催日') ?? _labeledValue(lines, '日程'),
      timeSource: bodyText,
    );
    final priceValue =
        _labeledValue(lines, 'チケット料金') ?? _labeledValue(lines, '支払金額');
    final price = _parsePrice(priceValue);
    if (venue == null ||
        venue.isEmpty ||
        startsAt == null ||
        price == null ||
        titleText.isEmpty) {
      return null;
    }
    return TicketInfo(
      title: titleText,
      startsAt: startsAt,
      venue: venue,
      price: price,
    );
  }

  /// `ラベル：値` 形式の行を解析する正規表現。
  ///
  /// ラベルと区切りの「：」(半角コロンも可)の間に空白以外の文字が
  /// 入るとマッチしない。
  static final RegExp _labeledLine = RegExp(r'^\s*([^\s：:]+)\s*[：:](.*)$');

  /// 開催日(例: `2026年11月3日`)を解析する正規表現。
  static final RegExp _datePattern = RegExp(r'(\d{4})年(\d{1,2})月(\d{1,2})日');

  /// `[開場時間]16:00` / `[開場日時]10:30` の時刻を解析する正規表現。
  static final RegExp _doorTimePattern = RegExp(
    r'\[開場(?:時間|日時)\](\d{1,2})[：:](\d{2})',
  );

  /// `[開演時間]16:30` / `[開演日時]11:00` の時刻を解析する正規表現。
  static final RegExp _startTimePattern = RegExp(
    r'\[開演(?:時間|日時)\](\d{1,2})[：:](\d{2})',
  );

  /// 金額の記載(例: `¥1,200`)を数値に解析する正規表現。
  static final RegExp _amountPattern = RegExp(r'\d+(?:,\d+)*');

  /// [lines] から [label] に完全一致するラベル行の値を返す。
  ///
  /// 見つからない場合は null を返す。
  String? _labeledValue(List<String> lines, String label) {
    for (final line in lines) {
      final match = _labeledLine.firstMatch(line);
      if (match != null && match.group(1) == label) {
        return match.group(2)!.trim();
      }
    }
    return null;
  }

  /// 開催日行の値と本文全体の時刻から公演開始日時(JST)を組み立てる。
  ///
  /// 開演時刻を優先し、無ければ開場時刻、どちらも無ければ 0 時とする。
  DateTime? _parseStartsAt({
    required String? dateValue,
    required String timeSource,
  }) {
    if (dateValue == null) {
      return null;
    }
    final dateMatch = _datePattern.firstMatch(dateValue);
    if (dateMatch == null) {
      return null;
    }
    final timeMatch =
        _startTimePattern.firstMatch(timeSource) ??
        _doorTimePattern.firstMatch(timeSource);
    return DateTime(
      int.parse(dateMatch.group(1)!),
      int.parse(dateMatch.group(2)!),
      int.parse(dateMatch.group(3)!),
      timeMatch == null ? 0 : int.parse(timeMatch.group(1)!),
      timeMatch == null ? 0 : int.parse(timeMatch.group(2)!),
    );
  }

  /// `チケット料金：¥600 × 1枚 = ¥600` 行の値から
  /// 注文のチケット料金合計を返す。
  ///
  /// `=` の右側の金額を優先し、無ければ最初に現れる金額とする。
  /// チケット料金行が無い旧形式のメールでは `支払金額` 行の値を
  /// 代わりに受け取る。
  int? _parsePrice(String? value) {
    if (value == null) {
      return null;
    }
    final match = _amountPattern.firstMatch(value.split('=').last);
    if (match == null) {
      return null;
    }
    return int.parse(match.group(0)!.replaceAll(',', ''));
  }
}
