import 'package:app/app/dependency_graph.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// アプリを開かずに押された通知のボタンを受け取る、plugin の入口。
@pragma('vm:entry-point')
Future<void> handleBackgroundNotificationResponse(
  NotificationResponse response,
) => AppDependencyGraph.applyBackgroundResponse(response);
