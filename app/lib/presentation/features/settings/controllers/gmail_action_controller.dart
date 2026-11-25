import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gmail_action_controller.g.dart';

/// Gmail の連携・同期・解除が進行中か。
///
/// 設定画面の再連携の警告と Gmail 連携の節が同じ値を見て、操作の重なりを防ぐ。
@riverpod
class GmailActionController extends _$GmailActionController {
  @override
  bool build() => false;

  /// 進行中の操作がなければ [action] を実行する。あれば何もしない。
  Future<void> run(Future<void> Function() action) async {
    if (state) return;
    state = true;
    try {
      await action();
    } finally {
      if (ref.mounted) state = false;
    }
  }
}
