// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// アプリ設定の入力境界。具象値は composition root が注入する。

@ProviderFor(appPreferencesUseCase)
final appPreferencesUseCaseProvider = AppPreferencesUseCaseProvider._();

/// アプリ設定の入力境界。具象値は composition root が注入する。

final class AppPreferencesUseCaseProvider
    extends
        $FunctionalProvider<
          AppPreferencesUseCase,
          AppPreferencesUseCase,
          AppPreferencesUseCase
        >
    with $Provider<AppPreferencesUseCase> {
  /// アプリ設定の入力境界。具象値は composition root が注入する。
  AppPreferencesUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appPreferencesUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appPreferencesUseCaseHash();

  @$internal
  @override
  $ProviderElement<AppPreferencesUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AppPreferencesUseCase create(Ref ref) {
    return appPreferencesUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppPreferencesUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppPreferencesUseCase>(value),
    );
  }
}

String _$appPreferencesUseCaseHash() =>
    r'328b60f14493bbadecd7912357f9f2e60c345aed';

/// 起動時に一度だけ取得した設定。必ず root scope へ注入する。

@ProviderFor(initialAppPreferencesSnapshot)
final initialAppPreferencesSnapshotProvider =
    InitialAppPreferencesSnapshotProvider._();

/// 起動時に一度だけ取得した設定。必ず root scope へ注入する。

final class InitialAppPreferencesSnapshotProvider
    extends
        $FunctionalProvider<
          AppPreferencesSnapshot,
          AppPreferencesSnapshot,
          AppPreferencesSnapshot
        >
    with $Provider<AppPreferencesSnapshot> {
  /// 起動時に一度だけ取得した設定。必ず root scope へ注入する。
  InitialAppPreferencesSnapshotProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'initialAppPreferencesSnapshotProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$initialAppPreferencesSnapshotHash();

  @$internal
  @override
  $ProviderElement<AppPreferencesSnapshot> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AppPreferencesSnapshot create(Ref ref) {
    return initialAppPreferencesSnapshot(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppPreferencesSnapshot value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppPreferencesSnapshot>(value),
    );
  }
}

String _$initialAppPreferencesSnapshotHash() =>
    r'd583be4cc40f66e6e73772888c4db4e3ad6d27a7';

/// 推し活代の入力境界。

@ProviderFor(budgetUseCase)
final budgetUseCaseProvider = BudgetUseCaseProvider._();

/// 推し活代の入力境界。

final class BudgetUseCaseProvider
    extends $FunctionalProvider<BudgetUseCase, BudgetUseCase, BudgetUseCase>
    with $Provider<BudgetUseCase> {
  /// 推し活代の入力境界。
  BudgetUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'budgetUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$budgetUseCaseHash();

  @$internal
  @override
  $ProviderElement<BudgetUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BudgetUseCase create(Ref ref) {
    return budgetUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BudgetUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BudgetUseCase>(value),
    );
  }
}

String _$budgetUseCaseHash() => r'cb75892ebcf00283d0bf24e9cad9fe50740d9eb6';

/// 月の概要の入力境界。

@ProviderFor(ledgerUseCase)
final ledgerUseCaseProvider = LedgerUseCaseProvider._();

/// 月の概要の入力境界。

final class LedgerUseCaseProvider
    extends $FunctionalProvider<LedgerUseCase, LedgerUseCase, LedgerUseCase>
    with $Provider<LedgerUseCase> {
  /// 月の概要の入力境界。
  LedgerUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ledgerUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ledgerUseCaseHash();

  @$internal
  @override
  $ProviderElement<LedgerUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LedgerUseCase create(Ref ref) {
    return ledgerUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LedgerUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LedgerUseCase>(value),
    );
  }
}

String _$ledgerUseCaseHash() => r'10cec73c33922fe14ecfe34cd106649ea970179d';

/// 支出の入力境界。

@ProviderFor(expenseUseCase)
final expenseUseCaseProvider = ExpenseUseCaseProvider._();

/// 支出の入力境界。

final class ExpenseUseCaseProvider
    extends $FunctionalProvider<ExpenseUseCase, ExpenseUseCase, ExpenseUseCase>
    with $Provider<ExpenseUseCase> {
  /// 支出の入力境界。
  ExpenseUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'expenseUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$expenseUseCaseHash();

  @$internal
  @override
  $ProviderElement<ExpenseUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ExpenseUseCase create(Ref ref) {
    return expenseUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExpenseUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExpenseUseCase>(value),
    );
  }
}

String _$expenseUseCaseHash() => r'4a99b61589f4da70ab85cdaf0341336eaa88fbf8';

/// 公演の入力境界。

@ProviderFor(performanceUseCase)
final performanceUseCaseProvider = PerformanceUseCaseProvider._();

/// 公演の入力境界。

final class PerformanceUseCaseProvider
    extends
        $FunctionalProvider<
          PerformanceUseCase,
          PerformanceUseCase,
          PerformanceUseCase
        >
    with $Provider<PerformanceUseCase> {
  /// 公演の入力境界。
  PerformanceUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'performanceUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$performanceUseCaseHash();

  @$internal
  @override
  $ProviderElement<PerformanceUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PerformanceUseCase create(Ref ref) {
    return performanceUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PerformanceUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PerformanceUseCase>(value),
    );
  }
}

String _$performanceUseCaseHash() =>
    r'd94e47b088397ca837691c973f1dc399b31c72c9';

/// チェキ相手の入力境界。

@ProviderFor(partnerUseCase)
final partnerUseCaseProvider = PartnerUseCaseProvider._();

/// チェキ相手の入力境界。

final class PartnerUseCaseProvider
    extends $FunctionalProvider<PartnerUseCase, PartnerUseCase, PartnerUseCase>
    with $Provider<PartnerUseCase> {
  /// チェキ相手の入力境界。
  PartnerUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'partnerUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$partnerUseCaseHash();

  @$internal
  @override
  $ProviderElement<PartnerUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PartnerUseCase create(Ref ref) {
    return partnerUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PartnerUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PartnerUseCase>(value),
    );
  }
}

String _$partnerUseCaseHash() => r'2b1406db6d28570481c7ff9cbb4d82660dd1edb5';

/// Gmail 連携の入力境界。

@ProviderFor(gmailUseCase)
final gmailUseCaseProvider = GmailUseCaseProvider._();

/// Gmail 連携の入力境界。

final class GmailUseCaseProvider
    extends $FunctionalProvider<GmailUseCase, GmailUseCase, GmailUseCase>
    with $Provider<GmailUseCase> {
  /// Gmail 連携の入力境界。
  GmailUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gmailUseCaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gmailUseCaseHash();

  @$internal
  @override
  $ProviderElement<GmailUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GmailUseCase create(Ref ref) {
    return gmailUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GmailUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GmailUseCase>(value),
    );
  }
}

String _$gmailUseCaseHash() => r'7945c7b27170724f48f4faca33e51ea9fb66839a';

/// 端末内のデータの変更の通知。

@ProviderFor(localDataChanges)
final localDataChangesProvider = LocalDataChangesProvider._();

/// 端末内のデータの変更の通知。

final class LocalDataChangesProvider
    extends
        $FunctionalProvider<
          LocalDataChanges,
          LocalDataChanges,
          LocalDataChanges
        >
    with $Provider<LocalDataChanges> {
  /// 端末内のデータの変更の通知。
  LocalDataChangesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localDataChangesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localDataChangesHash();

  @$internal
  @override
  $ProviderElement<LocalDataChanges> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LocalDataChanges create(Ref ref) {
    return localDataChanges(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocalDataChanges value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocalDataChanges>(value),
    );
  }
}

String _$localDataChangesHash() => r'df167dca7adea2b4f64f4033e9945b78ace23530';

/// 現在時刻。

@ProviderFor(clock)
final clockProvider = ClockProvider._();

/// 現在時刻。

final class ClockProvider extends $FunctionalProvider<Clock, Clock, Clock>
    with $Provider<Clock> {
  /// 現在時刻。
  ClockProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clockProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clockHash();

  @$internal
  @override
  $ProviderElement<Clock> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Clock create(Ref ref) {
    return clock(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Clock value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Clock>(value),
    );
  }
}

String _$clockHash() => r'47916627fa0f4eb16d37936acef6acaddcdc317a';
