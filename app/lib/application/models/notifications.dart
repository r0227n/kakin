import 'package:app/domain/domain.dart';

/// OS の通知の許可の状態。
enum NotificationPermission {
  /// 許可されている。
  granted,

  /// 拒否されている。
  denied,

  /// まだ求めていない。
  notDetermined,
}

/// 予約する通知の内容。金額は持たない。
final class ReminderNotification {
  /// 予約の内容と表示に使う値を持つ。
  const ReminderNotification({
    required this.plan,
    required this.performanceTitle,
  });

  /// 予約のタイミングと ID。
  final PlannedReminder plan;

  /// 通知に出す公演名。
  final String performanceTitle;

  /// 通知に付ける段階を進めるボタン。
  List<QuickStageAction> get actions => plan.slot.kind.quickActions;
}

/// アイコン画像の取得元。
enum PartnerIconSource {
  /// その場で写真を撮る。
  camera,

  /// 写真ライブラリから選ぶ。
  gallery,
}
