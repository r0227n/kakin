// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_data.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 端末内のデータが変わるたびに増える版数。読み取りの provider が購読する。

@ProviderFor(localDataRevision)
final localDataRevisionProvider = LocalDataRevisionProvider._();

/// 端末内のデータが変わるたびに増える版数。読み取りの provider が購読する。

final class LocalDataRevisionProvider
    extends $FunctionalProvider<AsyncValue<int>, int, Stream<int>>
    with $FutureModifier<int>, $StreamProvider<int> {
  /// 端末内のデータが変わるたびに増える版数。読み取りの provider が購読する。
  LocalDataRevisionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localDataRevisionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localDataRevisionHash();

  @$internal
  @override
  $StreamProviderElement<int> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<int> create(Ref ref) {
    return localDataRevision(ref);
  }
}

String _$localDataRevisionHash() => r'8a4602b5eade98c0eabe1e6b0ad174f39ed5b88f';

/// 月の概要。データが変わると読み直す。

@ProviderFor(monthOverview)
final monthOverviewProvider = MonthOverviewFamily._();

/// 月の概要。データが変わると読み直す。

final class MonthOverviewProvider
    extends
        $FunctionalProvider<
          AsyncValue<MonthOverview>,
          MonthOverview,
          FutureOr<MonthOverview>
        >
    with $FutureModifier<MonthOverview>, $FutureProvider<MonthOverview> {
  /// 月の概要。データが変わると読み直す。
  MonthOverviewProvider._({
    required MonthOverviewFamily super.from,
    required (YearMonth, AccountingBasis) super.argument,
  }) : super(
         retry: null,
         name: r'monthOverviewProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$monthOverviewHash();

  @override
  String toString() {
    return r'monthOverviewProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<MonthOverview> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<MonthOverview> create(Ref ref) {
    final argument = this.argument as (YearMonth, AccountingBasis);
    return monthOverview(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is MonthOverviewProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$monthOverviewHash() => r'151c925a998da21d64cf86f024726dfcb4bbfeed';

/// 月の概要。データが変わると読み直す。

final class MonthOverviewFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<MonthOverview>,
          (YearMonth, AccountingBasis)
        > {
  MonthOverviewFamily._()
    : super(
        retry: null,
        name: r'monthOverviewProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 月の概要。データが変わると読み直す。

  MonthOverviewProvider call(YearMonth month, AccountingBasis basis) =>
      MonthOverviewProvider._(argument: (month, basis), from: this);

  @override
  String toString() => r'monthOverviewProvider';
}

/// 推し活代の設定。

@ProviderFor(budgetPlan)
final budgetPlanProvider = BudgetPlanProvider._();

/// 推し活代の設定。

final class BudgetPlanProvider
    extends
        $FunctionalProvider<
          AsyncValue<BudgetPlan>,
          BudgetPlan,
          FutureOr<BudgetPlan>
        >
    with $FutureModifier<BudgetPlan>, $FutureProvider<BudgetPlan> {
  /// 推し活代の設定。
  BudgetPlanProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'budgetPlanProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$budgetPlanHash();

  @$internal
  @override
  $FutureProviderElement<BudgetPlan> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<BudgetPlan> create(Ref ref) {
    return budgetPlan(ref);
  }
}

String _$budgetPlanHash() => r'e1da3bd7b06cc5b4588c6eb2afebc98fdac4dcc0';

/// すべての公演。

@ProviderFor(performances)
final performancesProvider = PerformancesProvider._();

/// すべての公演。

final class PerformancesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Performance>>,
          List<Performance>,
          FutureOr<List<Performance>>
        >
    with
        $FutureModifier<List<Performance>>,
        $FutureProvider<List<Performance>> {
  /// すべての公演。
  PerformancesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'performancesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$performancesHash();

  @$internal
  @override
  $FutureProviderElement<List<Performance>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Performance>> create(Ref ref) {
    return performances(ref);
  }
}

String _$performancesHash() => r'f26330c1eaeed87e59b4a118666ae431f7c7fe9f';

/// [id] の公演。

@ProviderFor(performance)
final performanceProvider = PerformanceFamily._();

/// [id] の公演。

final class PerformanceProvider
    extends
        $FunctionalProvider<
          AsyncValue<Performance?>,
          Performance?,
          FutureOr<Performance?>
        >
    with $FutureModifier<Performance?>, $FutureProvider<Performance?> {
  /// [id] の公演。
  PerformanceProvider._({
    required PerformanceFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'performanceProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$performanceHash();

  @override
  String toString() {
    return r'performanceProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Performance?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Performance?> create(Ref ref) {
    final argument = this.argument as int;
    return performance(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PerformanceProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$performanceHash() => r'00f1df61e78cce85a225e854b3cd4631f7bcf1e0';

/// [id] の公演。

final class PerformanceFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Performance?>, int> {
  PerformanceFamily._()
    : super(
        retry: null,
        name: r'performanceProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// [id] の公演。

  PerformanceProvider call(int id) =>
      PerformanceProvider._(argument: id, from: this);

  @override
  String toString() => r'performanceProvider';
}

/// すべてのチェキ相手。

@ProviderFor(partners)
final partnersProvider = PartnersProvider._();

/// すべてのチェキ相手。

final class PartnersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Partner>>,
          List<Partner>,
          FutureOr<List<Partner>>
        >
    with $FutureModifier<List<Partner>>, $FutureProvider<List<Partner>> {
  /// すべてのチェキ相手。
  PartnersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'partnersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$partnersHash();

  @$internal
  @override
  $FutureProviderElement<List<Partner>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Partner>> create(Ref ref) {
    return partners(ref);
  }
}

String _$partnersHash() => r'ab8e777486d24facb1fb39d86de76da44616e687';

/// 今後の公演。開始日時の早い順。

@ProviderFor(upcomingPerformances)
final upcomingPerformancesProvider = UpcomingPerformancesProvider._();

/// 今後の公演。開始日時の早い順。

final class UpcomingPerformancesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<UpcomingPerformance>>,
          List<UpcomingPerformance>,
          FutureOr<List<UpcomingPerformance>>
        >
    with
        $FutureModifier<List<UpcomingPerformance>>,
        $FutureProvider<List<UpcomingPerformance>> {
  /// 今後の公演。開始日時の早い順。
  UpcomingPerformancesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'upcomingPerformancesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$upcomingPerformancesHash();

  @$internal
  @override
  $FutureProviderElement<List<UpcomingPerformance>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<UpcomingPerformance>> create(Ref ref) {
    return upcomingPerformances(ref);
  }
}

String _$upcomingPerformancesHash() =>
    r'7e2896dff7e516a5f6bc1e4e99ff3549aab1633d';

/// Gmail 連携の状態。

@ProviderFor(gmailStatus)
final gmailStatusProvider = GmailStatusProvider._();

/// Gmail 連携の状態。

final class GmailStatusProvider
    extends
        $FunctionalProvider<
          AsyncValue<GmailStatus>,
          GmailStatus,
          FutureOr<GmailStatus>
        >
    with $FutureModifier<GmailStatus>, $FutureProvider<GmailStatus> {
  /// Gmail 連携の状態。
  GmailStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gmailStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gmailStatusHash();

  @$internal
  @override
  $FutureProviderElement<GmailStatus> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<GmailStatus> create(Ref ref) {
    return gmailStatus(ref);
  }
}

String _$gmailStatusHash() => r'bd00c05fb83e17c1413a05848bb7df1ca26e0401';
