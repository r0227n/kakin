import 'dart:convert';

/// 抽出結果の 1 件。
class ExtractionResult {
  const ExtractionResult({required this.serviceName, required this.info});

  /// チケットサービスの表示名。
  final String serviceName;

  /// 抽出した公演情報。
  final ExtractionInfo info;
}

/// 出力用の公演情報。
///
/// TicketInfo をそのまま出力に使うと datetime の整形を挟みにくいので
/// CLI 独自の単純な構造にする。
class ExtractionInfo {
  const ExtractionInfo({
    required this.title,
    required this.startsAt,
    required this.venue,
    required this.price,
  });

  final String title;
  final DateTime startsAt;
  final String venue;
  final int price;
}

/// 取得したメールの内容を出力用に組み立てる。
class Reporter {
  /// メールの内容を fixture 確認用に組み立てる。
  String buildDump(Iterable<DumpEmail> emails) {
    final buffer = StringBuffer();
    for (final email in emails) {
      buffer
        ..writeln('From: ${email.from}')
        ..writeln('Subject: ${email.subject}')
        ..writeln('Date: ${email.dateText}')
        ..writeln('----')
        ..writeln(email.bodyText)
        ..writeln('=====');
    }
    return buffer.toString();
  }

  /// ダンプの Date 行を組み立てる。生の値と解析結果を併記する。
  String formatDumpDate(String raw, DateTime? parsed) {
    if (raw.isEmpty) {
      return '(Date ヘッダ無し)';
    }
    if (parsed == null) {
      return '$raw(解析不可)';
    }
    return '$raw → $parsed';
  }

  /// 抽出結果を人間が読める形式に組み立てる。
  String buildHumanReport({
    required int fetchedCount,
    required List<ExtractionResult> results,
  }) {
    final buffer = StringBuffer();
    for (final result in results) {
      buffer
        ..writeln(
          '${result.serviceName} | ${result.info.title}',
        )
        ..writeln('  日時: ${_formatDateTime(result.info.startsAt)}')
        ..writeln('  場所: ${result.info.venue}')
        ..writeln('  チケット料金: ${result.info.price}円');
    }
    buffer
      ..writeln()
      ..writeln('取得 $fetchedCount 件 / 抽出 ${results.length} 件');
    return buffer.toString();
  }

  /// 抽出結果を JSON に組み立てる。
  String buildJsonReport(List<ExtractionResult> results) =>
      const JsonEncoder.withIndent('  ').convert(<Map<String, Object?>>[
        for (final result in results)
          <String, Object?>{
            'service': result.serviceName,
            'title': result.info.title,
            'startsAt': result.info.startsAt.toIso8601String(),
            'venue': result.info.venue,
            'price': result.info.price,
          },
      ]);

  String _formatDateTime(DateTime dateTime) {
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '${dateTime.year}-$month-$day $hour:$minute';
  }
}

/// ダンプ出力に使うメールの内容。
class DumpEmail {
  const DumpEmail({
    required this.from,
    required this.subject,
    required this.dateText,
    required this.bodyText,
  });

  final String from;
  final String subject;
  final String dateText;
  final String bodyText;
}
