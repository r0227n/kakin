import 'dart:async';

import 'package:app/domain/domain.dart';

/// 通知のタップ。`action` はボタンで、通知そのものなら null。
typedef ReminderTap = ({int applicationId, QuickStageAction? action});

/// アプリが動いている間に届いた通知の応答を root widget へ渡す。
final class NotificationResponses {
  final _controller = StreamController<ReminderTap>.broadcast();
  final _pending = <ReminderTap>[];

  /// 応答を渡す。購読前の応答は [drainPending] で取り出す。
  void add(ReminderTap tap) {
    if (_controller.hasListener) {
      _controller.add(tap);
    } else {
      _pending.add(tap);
    }
  }

  /// 応答の購読。
  Stream<ReminderTap> get stream => _controller.stream;

  /// 購読前に届いた応答を取り出す。
  List<ReminderTap> drainPending() {
    final pending = [..._pending];
    _pending.clear();
    return pending;
  }
}
