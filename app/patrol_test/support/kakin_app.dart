import 'dart:io';

import 'package:app/app/bootstrap.dart';
import 'package:flutter_test/flutter_test.dart' show addTearDown;
import 'package:path_provider/path_provider.dart';
import 'package:patrol/patrol.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker/talker.dart';

/// 端末内のデータを消してから、日本語で Kakin を起動する。
///
/// [onboarded] が true なら初回起動の案内を終えた状態から始める。
/// 起動した依存はテストの終わりに閉じる。
Future<void> launchKakin(
  PatrolIntegrationTester $, {
  bool onboarded = false,
}) async {
  await _resetLocalData(onboarded: onboarded);
  final launched = await openKakinApp(talker: Talker());
  addTearDown(launched.graph.close);
  await $.pumpWidgetAndSettle(launched.root);
}

Future<void> _resetLocalData({required bool onboarded}) async {
  final documents = await getApplicationDocumentsDirectory();
  for (final suffix in ['', '-wal', '-shm', '-journal']) {
    final file = File('${documents.path}/kakin.sqlite$suffix');
    if (file.existsSync()) await file.delete();
  }
  final preferences = await SharedPreferences.getInstance();
  await preferences.clear();
  await preferences.setString('app.language', 'ja');
  if (onboarded) await preferences.setBool('onboarding.completed', true);
}
