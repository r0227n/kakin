// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ledger_view_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// カレンダーとリストの表示中の月と計上基準を所有する。
///
/// 計上基準は設定の初期値から始め、画面での切り替えは保存しない。

@ProviderFor(LedgerViewController)
final ledgerViewControllerProvider = LedgerViewControllerProvider._();

/// カレンダーとリストの表示中の月と計上基準を所有する。
///
/// 計上基準は設定の初期値から始め、画面での切り替えは保存しない。
final class LedgerViewControllerProvider
    extends $NotifierProvider<LedgerViewController, LedgerView> {
  /// カレンダーとリストの表示中の月と計上基準を所有する。
  ///
  /// 計上基準は設定の初期値から始め、画面での切り替えは保存しない。
  LedgerViewControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ledgerViewControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ledgerViewControllerHash();

  @$internal
  @override
  LedgerViewController create() => LedgerViewController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LedgerView value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LedgerView>(value),
    );
  }
}

String _$ledgerViewControllerHash() =>
    r'00798cd2e293aeca4526a29d67654c5535e2d1d1';

/// カレンダーとリストの表示中の月と計上基準を所有する。
///
/// 計上基準は設定の初期値から始め、画面での切り替えは保存しない。

abstract class _$LedgerViewController extends $Notifier<LedgerView> {
  LedgerView build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<LedgerView, LedgerView>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LedgerView, LedgerView>,
              LedgerView,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
