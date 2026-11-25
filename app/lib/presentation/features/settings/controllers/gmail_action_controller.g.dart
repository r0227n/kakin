// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gmail_action_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Gmail の連携・同期・解除が進行中か。
///
/// 設定画面の再連携の警告と Gmail 連携の節が同じ値を見て、操作の重なりを防ぐ。

@ProviderFor(GmailActionController)
final gmailActionControllerProvider = GmailActionControllerProvider._();

/// Gmail の連携・同期・解除が進行中か。
///
/// 設定画面の再連携の警告と Gmail 連携の節が同じ値を見て、操作の重なりを防ぐ。
final class GmailActionControllerProvider
    extends $NotifierProvider<GmailActionController, bool> {
  /// Gmail の連携・同期・解除が進行中か。
  ///
  /// 設定画面の再連携の警告と Gmail 連携の節が同じ値を見て、操作の重なりを防ぐ。
  GmailActionControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gmailActionControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gmailActionControllerHash();

  @$internal
  @override
  GmailActionController create() => GmailActionController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$gmailActionControllerHash() =>
    r'94f7301048cc84e6509521f151d0f41ca1bc07a2';

/// Gmail の連携・同期・解除が進行中か。
///
/// 設定画面の再連携の警告と Gmail 連携の節が同じ値を見て、操作の重なりを防ぐ。

abstract class _$GmailActionController extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
