import 'dart:convert';

import 'package:googleapis/gmail/v1.dart' as gmail;

/// base64url で符号化された MIME 本文データをテキストにデコードする。
String decodeBodyData(String data) {
  final normalized = base64Url.normalize(data);
  return utf8.decode(base64Url.decode(normalized), allowMalformed: true);
}

/// MIME 構造を再帰的に辿り、text/plain 部分を改行で連結して返す。
///
/// 見つからない場合は null を返す。
String? findPlainText(gmail.MessagePart? part) {
  return _findParts(part, 'text/plain');
}

/// MIME 構造を再帰的に辿り、text/html 部分を改行で連結して返す。
///
/// 見つからない場合は null を返す。
String? findHtml(gmail.MessagePart? part) {
  return _findParts(part, 'text/html');
}

String? _findParts(gmail.MessagePart? part, String mimeType) {
  if (part == null) {
    return null;
  }
  final collected = <String>[];
  final data = part.body?.data;
  if (part.mimeType == mimeType && data != null && data.isNotEmpty) {
    collected.add(decodeBodyData(data));
  }
  for (final child in part.parts ?? const <gmail.MessagePart>[]) {
    final text = _findParts(child, mimeType);
    if (text != null) {
      collected.add(text);
    }
  }
  return collected.isEmpty ? null : collected.join('\n');
}

/// 簡易に HTML をテキストへ変換する。
///
/// script と style を除去し、改行系タグを改行に置き換え、残りのタグと
/// HTML 実体参照を処理してから余白を整える。
String htmlToText(String html) {
  var text = html
      .replaceAll(
        RegExp(
          r'<(script|style)\b[^>]*>.*?</\1>',
          dotAll: true,
          caseSensitive: false,
        ),
        '',
      )
      .replaceAll(
        RegExp(r'<br\s*/?>', caseSensitive: false),
        '\n',
      )
      .replaceAll(
        RegExp('</(p|div|tr|h[1-6]|li)>', caseSensitive: false),
        '\n',
      )
      .replaceAll(
        RegExp('<[^>]+>'),
        '',
      );
  text = _decodeHtmlEntities(text);
  final lines = text
      .split('\n')
      .map((line) => line.replaceAll(RegExp(r'[ \t]+'), ' ').trim())
      .where((line) => line.isNotEmpty)
      .toList();
  return lines.join('\n');
}

/// よく使われる HTML 実体参照と数値文字参照をデコードする。
String _decodeHtmlEntities(String text) {
  var decoded = text
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&quot;', '"')
      .replaceAll('&apos;', "'")
      .replaceAll('&#39;', "'")
      .replaceAll('&amp;', '&');
  decoded = decoded.replaceAllMapped(
    RegExp('&#x([0-9a-fA-F]+);'),
    (match) => String.fromCharCode(
      int.parse(match.group(1)!, radix: 16),
    ),
  );
  decoded = decoded.replaceAllMapped(
    RegExp(r'&#(\d+);'),
    (match) => String.fromCharCode(int.parse(match.group(1)!)),
  );
  return decoded;
}

/// RFC 2047 の encoded-word をデコードする。
///
/// UTF-8 / US-ASCII 以外の文字セットは対応せず、そのまま返す。
String decodeSubject(String raw) {
  final pattern = RegExp(r'=\?([^?]+)\?([bBqQ])\?([^?]*)\?=');
  return raw.replaceAllMapped(pattern, (match) {
    final charset = match.group(1)!.toLowerCase();
    final encoding = match.group(2)!.toLowerCase();
    final data = match.group(3)!;
    if (charset != 'utf-8' && charset != 'us-ascii') {
      return match.group(0)!;
    }
    final bytes = switch (encoding) {
      'b' => base64.decode(data),
      _ => _decodeQEncoding(data),
    };
    return utf8.decode(bytes, allowMalformed: true);
  });
}

/// RFC 2047 の Q エンコーディングをデコードする。
List<int> _decodeQEncoding(String data) {
  final bytes = <int>[];
  final codes = data.codeUnits;
  for (var i = 0; i < codes.length; i++) {
    final code = codes[i];
    if (code == 0x5F) {
      // '_'
      bytes.add(0x20);
      continue;
    }
    if (code == 0x3D && i + 2 < codes.length) {
      // '='
      final hex = String.fromCharCodes(codes.sublist(i + 1, i + 3));
      final value = int.tryParse(hex, radix: 16);
      if (value != null) {
        bytes.add(value);
        i += 2;
        continue;
      }
    }
    bytes.add(code);
  }
  return bytes;
}

/// RFC 2822 形式の Date ヘッダを現地時刻の [DateTime] に変換する。
///
/// 解析できない場合は null を返す。
DateTime? parseRfc2822Date(String value) {
  final match = RegExp(
    r'^\s*(?:\w{3},\s*)?(\d{1,2})\s+(\w{3})\s+(\d{4})\s+'
    r'(\d{1,2}):(\d{2})(?::(\d{2}))?\s*([+-]\d{4}|[A-Z]{1,5})?'
    r'\s*(?:\([^)]*\))?\s*$',
  ).firstMatch(value);
  if (match == null) {
    return null;
  }
  final months = <String, int>{
    'jan': 1,
    'feb': 2,
    'mar': 3,
    'apr': 4,
    'may': 5,
    'jun': 6,
    'jul': 7,
    'aug': 8,
    'sep': 9,
    'oct': 10,
    'nov': 11,
    'dec': 12,
  };
  final month = months[match.group(2)!.toLowerCase()];
  if (month == null) {
    return null;
  }
  final utc = DateTime.utc(
    int.parse(match.group(3)!),
    month,
    int.parse(match.group(1)!),
    int.parse(match.group(4)!),
    int.parse(match.group(5)!),
    int.tryParse(match.group(6) ?? '0') ?? 0,
  );
  final zone = match.group(7);
  final offset = zone == null ? 0 : _parseZoneOffset(zone);
  return utc.subtract(Duration(minutes: offset)).toLocal();
}

/// タイムゾーン表記を UTC からのオフセット(分)に変換する。
int _parseZoneOffset(String zone) {
  final match = RegExp(r'^([+-])(\d{2})(\d{2})$').firstMatch(zone);
  if (match == null) {
    // 名前付きタイムゾーン(JST など)はオフセット不明のため UTC とみなす。
    return 0;
  }
  final sign = match.group(1) == '-' ? -1 : 1;
  return sign * (int.parse(match.group(2)!) * 60 + int.parse(match.group(3)!));
}
