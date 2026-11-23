// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $welcomeRoute,
  $mainShellRoute,
  $newExpenseRoute,
  $editExpenseRoute,
  $newPerformanceRoute,
  $performanceDetailRoute,
  $partnerPickerRoute,
  $newPartnerRoute,
  $editPartnerRoute,
];

RouteBase get $welcomeRoute => GoRouteData.$route(
  path: '/welcome',
  factory: $WelcomeRoute._fromState,
  routes: [
    GoRouteData.$route(path: 'budget', factory: $BudgetSetupRoute._fromState),
    GoRouteData.$route(path: 'gmail', factory: $GmailSetupRoute._fromState),
  ],
);

mixin $WelcomeRoute on GoRouteData {
  static WelcomeRoute _fromState(GoRouterState state) => const WelcomeRoute();

  @override
  String get location => GoRouteData.$location('/welcome');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $BudgetSetupRoute on GoRouteData {
  static BudgetSetupRoute _fromState(GoRouterState state) =>
      const BudgetSetupRoute();

  @override
  String get location => GoRouteData.$location('/welcome/budget');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $GmailSetupRoute on GoRouteData {
  static GmailSetupRoute _fromState(GoRouterState state) =>
      const GmailSetupRoute();

  @override
  String get location => GoRouteData.$location('/welcome/gmail');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $mainShellRoute => StatefulShellRouteData.$route(
  factory: $MainShellRouteExtension._fromState,
  branches: [
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/calendar',
          factory: $CalendarRoute._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/list',
          factory: $ExpenseListRoute._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/upcoming',
          factory: $UpcomingRoute._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/settings',
          factory: $SettingsRoute._fromState,
        ),
      ],
    ),
  ],
);

extension $MainShellRouteExtension on MainShellRoute {
  static MainShellRoute _fromState(GoRouterState state) =>
      const MainShellRoute();
}

mixin $CalendarRoute on GoRouteData {
  static CalendarRoute _fromState(GoRouterState state) => const CalendarRoute();

  @override
  String get location => GoRouteData.$location('/calendar');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ExpenseListRoute on GoRouteData {
  static ExpenseListRoute _fromState(GoRouterState state) =>
      const ExpenseListRoute();

  @override
  String get location => GoRouteData.$location('/list');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $UpcomingRoute on GoRouteData {
  static UpcomingRoute _fromState(GoRouterState state) => const UpcomingRoute();

  @override
  String get location => GoRouteData.$location('/upcoming');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $SettingsRoute on GoRouteData {
  static SettingsRoute _fromState(GoRouterState state) => const SettingsRoute();

  @override
  String get location => GoRouteData.$location('/settings');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $newExpenseRoute => GoRouteData.$route(
  path: '/expenses/new',
  factory: $NewExpenseRoute._fromState,
);

mixin $NewExpenseRoute on GoRouteData {
  static NewExpenseRoute _fromState(GoRouterState state) => NewExpenseRoute(
    category: _$convertMapValue(
      'category',
      state.uri.queryParameters,
      _$ExpenseCategoryEnumMap._$fromName,
    ),
    performanceId: _$convertMapValue(
      'performance-id',
      state.uri.queryParameters,
      int.tryParse,
    ),
    date: state.uri.queryParameters['date'],
  );

  NewExpenseRoute get _self => this as NewExpenseRoute;

  @override
  String get location => GoRouteData.$location(
    '/expenses/new',
    queryParams: {
      if (_self.category != null)
        'category': _$ExpenseCategoryEnumMap[_self.category!],
      if (_self.performanceId != null)
        'performance-id': _self.performanceId!.toString(),
      if (_self.date != null) 'date': _self.date,
    },
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

const _$ExpenseCategoryEnumMap = {
  ExpenseCategory.ticket: 'ticket',
  ExpenseCategory.drink: 'drink',
  ExpenseCategory.cheki: 'cheki',
  ExpenseCategory.goods: 'goods',
  ExpenseCategory.transport: 'transport',
  ExpenseCategory.locker: 'locker',
  ExpenseCategory.other: 'other',
};

T? _$convertMapValue<T>(
  String key,
  Map<String, String> map,
  T? Function(String) converter,
) {
  final value = map[key];
  return value == null ? null : converter(value);
}

extension<T extends Enum> on Map<T, String> {
  T? _$fromName(String? value) =>
      entries.where((element) => element.value == value).firstOrNull?.key;
}

RouteBase get $editExpenseRoute => GoRouteData.$route(
  path: '/expenses/:expenseId',
  factory: $EditExpenseRoute._fromState,
);

mixin $EditExpenseRoute on GoRouteData {
  static EditExpenseRoute _fromState(GoRouterState state) => EditExpenseRoute(
    expenseId: int.parse(state.pathParameters['expenseId']!),
  );

  EditExpenseRoute get _self => this as EditExpenseRoute;

  @override
  String get location => GoRouteData.$location(
    '/expenses/${Uri.encodeComponent(_self.expenseId.toString())}',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $newPerformanceRoute => GoRouteData.$route(
  path: '/performances/new',
  factory: $NewPerformanceRoute._fromState,
);

mixin $NewPerformanceRoute on GoRouteData {
  static NewPerformanceRoute _fromState(GoRouterState state) =>
      const NewPerformanceRoute();

  @override
  String get location => GoRouteData.$location('/performances/new');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $performanceDetailRoute => GoRouteData.$route(
  path: '/performances/:performanceId',
  factory: $PerformanceDetailRoute._fromState,
  routes: [
    GoRouteData.$route(path: 'edit', factory: $EditPerformanceRoute._fromState),
  ],
);

mixin $PerformanceDetailRoute on GoRouteData {
  static PerformanceDetailRoute _fromState(GoRouterState state) =>
      PerformanceDetailRoute(
        performanceId: int.parse(state.pathParameters['performanceId']!),
      );

  PerformanceDetailRoute get _self => this as PerformanceDetailRoute;

  @override
  String get location => GoRouteData.$location(
    '/performances/${Uri.encodeComponent(_self.performanceId.toString())}',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $EditPerformanceRoute on GoRouteData {
  static EditPerformanceRoute _fromState(GoRouterState state) =>
      EditPerformanceRoute(
        performanceId: int.parse(state.pathParameters['performanceId']!),
      );

  EditPerformanceRoute get _self => this as EditPerformanceRoute;

  @override
  String get location => GoRouteData.$location(
    '/performances/${Uri.encodeComponent(_self.performanceId.toString())}/edit',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $partnerPickerRoute => GoRouteData.$route(
  path: '/partners/pick',
  factory: $PartnerPickerRoute._fromState,
);

mixin $PartnerPickerRoute on GoRouteData {
  static PartnerPickerRoute _fromState(GoRouterState state) =>
      PartnerPickerRoute(
        selected:
            state.uri.queryParametersAll['selected']
                ?.map(int.parse)
                .cast<int>()
                .toList() ??
            const [],
      );

  PartnerPickerRoute get _self => this as PartnerPickerRoute;

  @override
  String get location => GoRouteData.$location(
    '/partners/pick',
    queryParams: {
      if (!_$iterablesEqual(_self.selected, const []))
        'selected': _self.selected.map((e) => e.toString()).toList(),
    },
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

bool _$iterablesEqual<T>(Iterable<T>? iterable1, Iterable<T>? iterable2) {
  if (identical(iterable1, iterable2)) return true;
  if (iterable1 == null || iterable2 == null) return false;
  final iterator1 = iterable1.iterator;
  final iterator2 = iterable2.iterator;
  while (true) {
    final hasNext1 = iterator1.moveNext();
    final hasNext2 = iterator2.moveNext();
    if (hasNext1 != hasNext2) return false;
    if (!hasNext1) return true;
    if (iterator1.current != iterator2.current) return false;
  }
}

RouteBase get $newPartnerRoute => GoRouteData.$route(
  path: '/partners/new',
  factory: $NewPartnerRoute._fromState,
);

mixin $NewPartnerRoute on GoRouteData {
  static NewPartnerRoute _fromState(GoRouterState state) =>
      const NewPartnerRoute();

  @override
  String get location => GoRouteData.$location('/partners/new');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $editPartnerRoute => GoRouteData.$route(
  path: '/partners/:partnerId',
  factory: $EditPartnerRoute._fromState,
);

mixin $EditPartnerRoute on GoRouteData {
  static EditPartnerRoute _fromState(GoRouterState state) => EditPartnerRoute(
    partnerId: int.parse(state.pathParameters['partnerId']!),
  );

  EditPartnerRoute get _self => this as EditPartnerRoute;

  @override
  String get location => GoRouteData.$location(
    '/partners/${Uri.encodeComponent(_self.partnerId.toString())}',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
