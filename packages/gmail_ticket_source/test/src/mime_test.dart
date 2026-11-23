import 'dart:convert';

import 'package:gmail_ticket_source/gmail_ticket_source.dart';
import 'package:googleapis/gmail/v1.dart' as gmail;
import 'package:test/test.dart';

gmail.MessagePart _part(
  String mimeType, {
  String? data,
  List<gmail.MessagePart>? parts,
}) {
  return gmail.MessagePart(
    mimeType: mimeType,
    body: data == null ? null : gmail.MessagePartBody(data: data),
    parts: parts,
  );
}

void main() {
  test('decodeBodyData はパディングの無い base64url をデコードする', () {
    final encoded = base64Url.encode(utf8.encode('こんにちは')).replaceAll('=', '');

    expect(decodeBodyData(encoded), 'こんにちは');
  });

  test('findPlainText は text/plain 部分を再帰的に連結する', () {
    final part = _part(
      'multipart/alternative',
      parts: [
        _part('text/plain', data: base64Url.encode(utf8.encode('本文です'))),
        _part('text/html', data: base64Url.encode(utf8.encode('<b>本文です</b>'))),
      ],
    );

    expect(findPlainText(part), '本文です');
  });

  test('findPlainText は text/plain が無いと null を返す', () {
    final part = _part(
      'text/html',
      data: base64Url.encode(utf8.encode('<b>x</b>')),
    );

    expect(findPlainText(part), isNull);
    expect(findHtml(part), '<b>x</b>');
  });

  test('htmlToText は script と style を除去しタグをほどく', () {
    final text = htmlToText(
      '<html><style>p { color: red; }</style> '
      '<script>alert("x")</script><p>Hello &amp; <br>World</p></html>',
    );

    expect(text, 'Hello &\nWorld');
  });

  test('htmlToText は数値文字参照をデコードする', () {
    expect(htmlToText('&#65;&#x42;&nbsp;C'), 'AB C');
  });

  test('decodeSubject は B エンコーディングの encoded-word をデコードする', () {
    final encoded = '=?UTF-8?B?${base64.encode(utf8.encode('公演'))}?=';

    expect(decodeSubject(encoded), '公演');
  });

  test('decodeSubject は Q エンコーディングの encoded-word をデコードする', () {
    expect(decodeSubject('=?utf-8?q?a_b=c3=a4?='), 'a bä');
  });

  test('decodeSubject は未対応の文字セットをそのまま返す', () {
    const encoded = '=?ISO-2022-JP?B?AAAA?=';

    expect(decodeSubject(encoded), encoded);
  });

  test('parseRfc2822Date はオフセット付きヘッダを現地時刻に変換する', () {
    final parsed = parseRfc2822Date('Fri, 20 Nov 2026 19:00:00 +0900');

    // 19:00+0900 は 10:00 UTC と等しい。現地タイムゾーンに依存しない期待値にする。
    expect(parsed, DateTime.utc(2026, 11, 20, 10).toLocal());
  });

  test('parseRfc2822Date は末尾のタイムゾーンコメントを許容する', () {
    final parsed = parseRfc2822Date('Fri, 16 Oct 2026 19:11:27 +0900 (JST)');

    expect(parsed, DateTime.utc(2026, 10, 16, 10, 11, 27).toLocal());
  });

  test('parseRfc2822Date は解析できない値を null にする', () {
    expect(parseRfc2822Date('明日の 19 時'), isNull);
  });
}
