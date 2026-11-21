import 'package:gmail_ticket_cli/src/mime.dart';
import 'package:googleapis/gmail/v1.dart' as gmail;

/// 取得したメールの内容。
class FetchedEmail {
  const FetchedEmail({
    required this.from,
    required this.subject,
    required this.date,
    required this.dateRaw,
    required this.bodyText,
  });

  /// From ヘッダの値。
  final String from;

  /// Subject ヘッダの値(可能なら encoded-word をデコードする)。
  final String subject;

  /// Date ヘッダの値。解析できない場合は null。
  final DateTime? date;

  /// Date ヘッダの生の値。
  final String dateRaw;

  /// 本文のテキスト。text/plain を優先し、無ければ HTML から変換する。
  final String bodyText;
}

/// Gmail API からメールを検索して本文テキスト付きで取得する。
class GmailFetcher {
  GmailFetcher(this._gmail);

  final gmail.GmailApi _gmail;

  /// [query] で検索し、最大 [max] 件のメールを返す。
  ///
  /// 1 件取得するごとに取得済み件数を [onProgress] に通知する。
  Future<List<FetchedEmail>> fetch({
    required String query,
    required int max,
    void Function(int fetched)? onProgress,
  }) async {
    final messageIds = <String>[];
    String? pageToken;
    do {
      final response = await _gmail.users.messages.list(
        'me',
        q: query,
        maxResults: (max - messageIds.length).clamp(1, 500),
        pageToken: pageToken,
      );
      messageIds.addAll(
        (response.messages ?? const <gmail.Message>[])
            .map((message) => message.id)
            .whereType<String>(),
      );
      pageToken = response.nextPageToken;
    } while (pageToken != null && messageIds.length < max);
    if (messageIds.length > max) {
      messageIds.removeRange(max, messageIds.length);
    }

    final emails = <FetchedEmail>[];
    for (final id in messageIds) {
      final message = await _gmail.users.messages.get(
        'me',
        id,
        format: 'full',
      );
      emails.add(parseMessage(message));
      onProgress?.call(emails.length);
    }
    return emails;
  }

  /// Gmail API の [message] を [FetchedEmail] に変換する。
  FetchedEmail parseMessage(gmail.Message message) {
    final payload = message.payload;
    final headers = payload?.headers ?? const <gmail.MessagePartHeader>[];
    String header(String name) {
      for (final partHeader in headers) {
        if ((partHeader.name ?? '').toLowerCase() == name.toLowerCase()) {
          return partHeader.value ?? '';
        }
      }
      return '';
    }

    final rawDate = header('date');
    final html = findHtml(payload);
    return FetchedEmail(
      from: header('from'),
      subject: decodeSubject(header('subject')),
      date: rawDate.isEmpty ? null : parseRfc2822Date(rawDate),
      dateRaw: rawDate,
      bodyText:
          findPlainText(payload) ?? (html == null ? '' : htmlToText(html)),
    );
  }
}
