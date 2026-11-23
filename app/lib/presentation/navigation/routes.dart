import 'package:app/domain/domain.dart';
import 'package:app/presentation/features/calendar/screens/calendar_screen.dart';
import 'package:app/presentation/features/expense_editor/screens/expense_editor_screen.dart';
import 'package:app/presentation/features/expense_list/screens/expense_list_screen.dart';
import 'package:app/presentation/features/onboarding/screens/budget_setup_screen.dart';
import 'package:app/presentation/features/onboarding/screens/gmail_setup_screen.dart';
import 'package:app/presentation/features/onboarding/screens/welcome_screen.dart';
import 'package:app/presentation/features/partners/screens/partner_edit_screen.dart';
import 'package:app/presentation/features/partners/screens/partner_picker_screen.dart';
import 'package:app/presentation/features/performance_editor/screens/performance_editor_screen.dart';
import 'package:app/presentation/features/settings/screens/settings_screen.dart';
import 'package:app/presentation/features/ticket_application/screens/ticket_application_screen.dart';
import 'package:app/presentation/features/upcoming/screens/performance_detail_screen.dart';
import 'package:app/presentation/features/upcoming/screens/upcoming_screen.dart';
import 'package:app/presentation/navigation/app_shell.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'routes.g.dart';

Page<void> _modal(GoRouterState state, Widget child) => MaterialPage<void>(
  key: state.pageKey,
  fullscreenDialog: true,
  child: child,
);

/// 初回起動の案内: ようこそ。
@TypedGoRoute<WelcomeRoute>(
  path: '/welcome',
  routes: [
    TypedGoRoute<BudgetSetupRoute>(path: 'budget'),
    TypedGoRoute<GmailSetupRoute>(path: 'gmail'),
  ],
)
class WelcomeRoute extends GoRouteData with $WelcomeRoute {
  /// 案内の最初の画面。
  const WelcomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const WelcomeScreen();
}

/// 初回起動の案内: 推し活代の設定。
class BudgetSetupRoute extends GoRouteData with $BudgetSetupRoute {
  /// 案内の2番目の画面。
  const BudgetSetupRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const BudgetSetupScreen();
}

/// 初回起動の案内: Gmail 連携。
class GmailSetupRoute extends GoRouteData with $GmailSetupRoute {
  /// 案内の最後の画面。
  const GmailSetupRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const GmailSetupScreen();
}

/// 画面下部のタブで切り替える4画面。
@TypedStatefulShellRoute<MainShellRoute>(
  branches: [
    TypedStatefulShellBranch<CalendarBranch>(
      routes: [TypedGoRoute<CalendarRoute>(path: '/calendar')],
    ),
    TypedStatefulShellBranch<ExpenseListBranch>(
      routes: [TypedGoRoute<ExpenseListRoute>(path: '/list')],
    ),
    TypedStatefulShellBranch<UpcomingBranch>(
      routes: [TypedGoRoute<UpcomingRoute>(path: '/upcoming')],
    ),
    TypedStatefulShellBranch<SettingsBranch>(
      routes: [TypedGoRoute<SettingsRoute>(path: '/settings')],
    ),
  ],
)
class MainShellRoute extends StatefulShellRouteData {
  /// タブの状態を保ったまま切り替える。
  const MainShellRoute();

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) => AppShell(navigationShell: navigationShell);
}

/// カレンダーのタブ。
class CalendarBranch extends StatefulShellBranchData {
  /// タブの枝。
  const CalendarBranch();
}

/// リストのタブ。
class ExpenseListBranch extends StatefulShellBranchData {
  /// タブの枝。
  const ExpenseListBranch();
}

/// 今後の公演のタブ。
class UpcomingBranch extends StatefulShellBranchData {
  /// タブの枝。
  const UpcomingBranch();
}

/// 設定のタブ。
class SettingsBranch extends StatefulShellBranchData {
  /// タブの枝。
  const SettingsBranch();
}

/// カレンダー。
class CalendarRoute extends GoRouteData with $CalendarRoute {
  /// カレンダーへの遷移。
  const CalendarRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const CalendarScreen();
}

/// リスト。
class ExpenseListRoute extends GoRouteData with $ExpenseListRoute {
  /// リストへの遷移。
  const ExpenseListRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ExpenseListScreen();
}

/// 今後の公演。
class UpcomingRoute extends GoRouteData with $UpcomingRoute {
  /// 今後の公演への遷移。
  const UpcomingRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const UpcomingScreen();
}

/// 設定。
class SettingsRoute extends GoRouteData with $SettingsRoute {
  /// 設定への遷移。
  const SettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SettingsScreen();
}

/// 支出の追加。
@TypedGoRoute<NewExpenseRoute>(path: '/expenses/new')
class NewExpenseRoute extends GoRouteData with $NewExpenseRoute {
  /// [category]・[performanceId]・[date]（YYYY-MM-DD）を初期値にする。
  const NewExpenseRoute({this.category, this.performanceId, this.date});

  /// 最初に選ぶカテゴリ。
  final ExpenseCategory? category;

  /// 最初に選ぶ公演。
  final int? performanceId;

  /// 支払日の初期値。
  final String? date;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) => _modal(
    state,
    ExpenseEditorScreen(
      initialCategory: category,
      initialPerformanceId: performanceId,
      initialDate: date == null ? null : LocalDate.parse(date!),
    ),
  );
}

/// 支出の編集。
@TypedGoRoute<EditExpenseRoute>(path: '/expenses/:expenseId')
class EditExpenseRoute extends GoRouteData with $EditExpenseRoute {
  /// [expenseId] の支出を開く。
  const EditExpenseRoute({required this.expenseId});

  /// 編集する支出。
  final int expenseId;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      _modal(state, ExpenseEditorScreen(expenseId: expenseId));
}

/// 公演の登録。登録した公演の ID を返す。
@TypedGoRoute<NewPerformanceRoute>(path: '/performances/new')
class NewPerformanceRoute extends GoRouteData with $NewPerformanceRoute {
  /// 新しい公演を登録する。
  const NewPerformanceRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      _modal(state, const PerformanceEditorScreen());
}

/// 公演とそのチケット申込。
@TypedGoRoute<PerformanceDetailRoute>(
  path: '/performances/:performanceId',
  routes: [TypedGoRoute<EditPerformanceRoute>(path: 'edit')],
)
class PerformanceDetailRoute extends GoRouteData with $PerformanceDetailRoute {
  /// [performanceId] の公演を開く。
  const PerformanceDetailRoute({required this.performanceId});

  /// 表示する公演。
  final int performanceId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      PerformanceDetailScreen(performanceId: performanceId);
}

/// 公演の編集。
class EditPerformanceRoute extends GoRouteData with $EditPerformanceRoute {
  /// [performanceId] の公演を編集する。
  const EditPerformanceRoute({required this.performanceId});

  /// 編集する公演。
  final int performanceId;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      _modal(state, PerformanceEditorScreen(performanceId: performanceId));
}

/// チケット申込の追加。
@TypedGoRoute<NewTicketApplicationRoute>(path: '/applications/new')
class NewTicketApplicationRoute extends GoRouteData
    with $NewTicketApplicationRoute {
  /// [performanceId] を初期値にする。
  const NewTicketApplicationRoute({this.performanceId});

  /// 最初に選ぶ公演。
  final int? performanceId;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) => _modal(
    state,
    TicketApplicationScreen(initialPerformanceId: performanceId),
  );
}

/// チケット申込の編集。通知のタップでも開く。
@TypedGoRoute<EditTicketApplicationRoute>(path: '/applications/:applicationId')
class EditTicketApplicationRoute extends GoRouteData
    with $EditTicketApplicationRoute {
  /// [applicationId] のチケット申込を開く。
  const EditTicketApplicationRoute({required this.applicationId});

  /// 編集するチケット申込。
  final int applicationId;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      _modal(state, TicketApplicationScreen(applicationId: applicationId));
}

/// チェキ相手の選択。選んだ相手の ID を返す。
@TypedGoRoute<PartnerPickerRoute>(path: '/partners/pick')
class PartnerPickerRoute extends GoRouteData with $PartnerPickerRoute {
  /// [selected] を選んだ状態で開く。
  const PartnerPickerRoute({this.selected = const []});

  /// 選択済みの相手。
  final List<int> selected;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      _modal(state, PartnerPickerScreen(initialSelection: selected));
}

/// チェキ相手の登録。登録した相手の ID を返す。
@TypedGoRoute<NewPartnerRoute>(path: '/partners/new')
class NewPartnerRoute extends GoRouteData with $NewPartnerRoute {
  /// 新しいチェキ相手を登録する。
  const NewPartnerRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const PartnerEditScreen();
}

/// チェキ相手の編集。
@TypedGoRoute<EditPartnerRoute>(path: '/partners/:partnerId')
class EditPartnerRoute extends GoRouteData with $EditPartnerRoute {
  /// [partnerId] のチェキ相手を編集する。
  const EditPartnerRoute({required this.partnerId});

  /// 編集する相手。
  final int partnerId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      PartnerEditScreen(partnerId: partnerId);
}
