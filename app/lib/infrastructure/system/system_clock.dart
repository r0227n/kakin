import 'package:app/application/application.dart';

/// 端末の時計。
final class SystemClock implements Clock {
  /// 端末の現在時刻を UTC で返す。
  const SystemClock();

  @override
  DateTime now() => DateTime.now().toUtc();
}
