import 'package:app/application/models/notifications.dart';

/// 端末内でリマインドの通知を予約する契約。
abstract interface class ReminderScheduler {
  /// OS の通知の許可の状態。
  Future<NotificationPermission> permissionStatus();

  /// OS に通知の許可を求める。
  Future<NotificationPermission> requestPermission();

  /// 予約済みのリマインドをすべて取り消し、[reminders] を予約し直す。
  Future<void> replaceAll(List<ReminderNotification> reminders);
}

/// チェキ相手のアイコン画像を端末内に保存する契約。
abstract interface class PartnerIconStore {
  /// 正方形に切り抜いた [sourcePath] の画像を保存し、ファイル名を返す。
  Future<String> save(String sourcePath);

  /// [fileName] の画像の絶対パス。ファイルがなければ null。
  String? pathOf(String fileName);

  /// [fileName] の画像を消す。なければ何もしない。
  Future<void> delete(String fileName);

  /// [referenced] 以外の画像を消す。
  Future<void> deleteUnreferenced(Set<String> referenced);
}

/// 写真を撮るか選び、正方形に切り抜く契約。
// A single-purpose interface keeps presentation independent of plugins.
// ignore: one_member_abstracts
abstract interface class PartnerIconPicker {
  /// 切り抜いた画像の一時ファイルのパス。取り消したら null。
  Future<String?> pick(PartnerIconSource source);
}

/// 現在時刻の契約。テストで時刻を固定するために使う。
// A single-purpose interface keeps time deterministic in tests.
// ignore: one_member_abstracts
abstract interface class Clock {
  /// 現在の瞬間。
  DateTime now();
}

/// 端末内のデータの変更を知らせる契約。
// A single-purpose interface hides the database change feed.
// ignore: one_member_abstracts
abstract interface class LocalDataChanges {
  /// データが変わるたびに値を流す。購読の開始時にも1回流す。
  Stream<void> watch();
}
