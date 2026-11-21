import 'package:ticket_platform_interface/src/ticket_info.dart';

/// チケットサービス企業のメールから公演情報を抽出する抽象インターフェース。
///
/// メールの取得元(Gmail など)は担わない。呼び出し側が件名と本文テキストを
/// 渡し、実装は対象メールの判定と公演情報の抽出だけを担う。
abstract interface class TicketService {
  /// 表示に使うサービス名。
  String get name;

  /// このサービスの対象メールの送信者アドレス。
  String get senderAddress;

  /// 対象メールを識別する件名キーワード。
  ///
  /// 件名にいずれかのキーワードを含むメールを対象とする。
  List<String> get subjectKeywords;

  /// [subject] と [bodyText] から公演情報を抽出する。
  ///
  /// 対象メールでない場合や、公演名・日時・場所・チケット料金のいずれかが
  /// 抽出できない場合は null を返す。
  TicketInfo? extract({required String subject, required String bodyText});
}
