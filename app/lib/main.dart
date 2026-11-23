import 'package:app/app/bootstrap.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:marionette_flutter/marionette_flutter.dart';

/// 開発中は Marionette で操作できる binding を使い、初期化を委譲する。
Future<void> main() async {
  if (kDebugMode) {
    MarionetteBinding.ensureInitialized();
  } else {
    WidgetsFlutterBinding.ensureInitialized();
  }
  await bootstrap();
}
