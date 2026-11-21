import 'package:ticket_platform_interface/ticket_platform_interface.dart';

/// eplus(info@eplus.co.jp)からのメールから公演情報を抽出する
/// [TicketService] の実装。
///
/// 対象メールの本文は `公演名　　　：　値` 形式のラベル行で構成され、
/// 公演名が長いときは全角空白で始まる行に折り返される。
class EplusTicketService implements TicketService {
  const EplusTicketService();

  @override
  String get name => 'eplus';

  @override
  String get senderAddress => 'info@eplus.co.jp';

  @override
  List<String> get subjectKeywords => const <String>['決済に関するご案内'];

  @override
  TicketInfo? extract({required String subject, required String bodyText}) {
    if (!subjectKeywords.any(subject.contains)) {
      return null;
    }
    final lines = bodyText.replaceAll('\r\n', '\n').split('\n');
    final title = _parseTitle(lines);
    final titleText = (title == null || title.isEmpty) ? subject.trim() : title;
    final venue = _labeledValue(lines, '会場名');
    final startsAt = _parseStartsAt(_labeledValue(lines, '公演日時'));
    final price = _parsePrice(_labeledValue(lines, 'チケット料金'));
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

  /// `ラベル　　　：　値` 形式の行を解析する正規表現。
  ///
  /// ラベルと区切りの「：」(半角コロンも可)の間に空白以外の文字が
  /// 入るとマッチしない。
  static final RegExp _labeledLine = RegExp(r'^\s*([^\s：:]+)\s*[：:](.*)$');

  /// 金額の記載(例: `\4,980`)を数値に解析する正規表現。
  static final RegExp _amountPattern = RegExp(r'\d+(?:,\d+)*');

  /// 公演日付を解析する正規表現。
  static final RegExp _datePattern = RegExp(r'(\d{4})/(\d{1,2})/(\d{1,2})');

  /// 開演時刻を解析する正規表現。
  static final RegExp _startPattern = RegExp(r'(\d{1,2})[：:](\d{2})開演');

  /// 開場時刻を解析する正規表現。
  static final RegExp _doorPattern = RegExp(r'(\d{1,2})[：:](\d{2})開場');

  /// [lines] から [label] に完全一致するラベル行の値と行位置を返す。
  ///
  /// 見つからない場合は null を返す。
  ({String value, int lineIndex})? _labeledValueAt(
    List<String> lines,
    String label,
  ) {
    for (var i = 0; i < lines.length; i++) {
      final match = _labeledLine.firstMatch(lines[i]);
      if (match != null && match.group(1) == label) {
        return (value: match.group(2)!.trim(), lineIndex: i);
      }
    }
    return null;
  }

  /// [lines] から [label] に完全一致するラベル行の値を返す。
  ///
  /// 見つからない場合は null を返す。
  String? _labeledValue(List<String> lines, String label) =>
      _labeledValueAt(lines, label)?.value;

  /// 公演名ラベル行の値に、全角空白で始まる折り返し行を連結して返す。
  String? _parseTitle(List<String> lines) {
    final found = _labeledValueAt(lines, '公演名');
    if (found == null) {
      return null;
    }
    final title = StringBuffer(found.value);
    for (var i = found.lineIndex + 1; i < lines.length; i++) {
      final line = lines[i];
      if (!line.startsWith('　') || line.contains('：')) {
        break;
      }
      final continuation = line.trim();
      if (continuation.isEmpty) {
        break;
      }
      title
        ..write('　')
        ..write(continuation);
    }
    return title.toString().trim();
  }

  /// `公演日時` 行の値から公演開始日時(JST)を組み立てる。
  ///
  /// 開演時刻を優先し、無ければ開場時刻、どちらも無ければ 0 時とする。
  DateTime? _parseStartsAt(String? value) {
    if (value == null) {
      return null;
    }
    final dateMatch = _datePattern.firstMatch(value);
    if (dateMatch == null) {
      return null;
    }
    final timeMatch =
        _startPattern.firstMatch(value) ?? _doorPattern.firstMatch(value);
    return DateTime(
      int.parse(dateMatch.group(1)!),
      int.parse(dateMatch.group(2)!),
      int.parse(dateMatch.group(3)!),
      timeMatch == null ? 0 : int.parse(timeMatch.group(1)!),
      timeMatch == null ? 0 : int.parse(timeMatch.group(2)!),
    );
  }

  /// 金額テキスト(例: `\4,980`)から円の数値を返す。
  int? _parsePrice(String? value) {
    if (value == null) {
      return null;
    }
    final match = _amountPattern.firstMatch(value);
    if (match == null) {
      return null;
    }
    return int.parse(match.group(0)!.replaceAll(',', ''));
  }
}
