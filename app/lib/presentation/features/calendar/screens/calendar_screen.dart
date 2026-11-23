import 'package:app/application/application.dart';
import 'package:app/core/gen/slang.g.dart';
import 'package:app/domain/domain.dart';
import 'package:app/presentation/dependencies/application_providers.dart';
import 'package:app/presentation/features/calendar/widgets/calendar_day_cell.dart';
import 'package:app/presentation/features/calendar/widgets/day_records.dart';
import 'package:app/presentation/navigation/routes.dart';
import 'package:app/presentation/shared/controllers/app_preferences_controller.dart';
import 'package:app/presentation/shared/controllers/gmail_refresh.dart';
import 'package:app/presentation/shared/controllers/ledger_view_controller.dart';
import 'package:app/presentation/shared/controllers/local_data.dart';
import 'package:app/presentation/shared/keys/app_keys.dart';
import 'package:app/presentation/shared/widgets/month_summary.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:month_calendar/month_calendar.dart';

/// 月の残高と、日ごとの支出・公演を表示するカレンダー。
class CalendarScreen extends ConsumerStatefulWidget {
  /// 選んだ日は画面が持ち、月と計上基準はリストと共有する。
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  LocalDate? _picked;

  LocalDate _selectedIn(YearMonth month, LocalDate today) {
    final picked = _picked;
    if (picked != null && month.contains(picked)) return picked;
    return month.contains(today) ? today : month.firstDay;
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final palette = context.palette;
    final view = ref.watch(ledgerViewControllerProvider);
    final controller = ref.read(ledgerViewControllerProvider.notifier);
    final overview = ref.watch(monthOverviewProvider(view.month, view.basis));
    final hidden = !ref.watch(
      appPreferencesControllerProvider.select((p) => p.amountsVisible),
    );
    final today = JapanTime.dateOf(ref.read(clockProvider).now());
    final selected = _selectedIn(view.month, today);
    final weekdays = t.format.weekdays;
    return Scaffold(
      appBar: const MonthAppBar(),
      floatingActionButton: FloatingActionButton(
        key: AppKeys.addExpense,
        // タブを切り替えても残る2つの画面の FAB が Hero で衝突しないようにする。
        heroTag: null,
        tooltip: t.calendar.addExpense,
        onPressed: () =>
            NewExpenseRoute(date: selected.toIso()).push<void>(context),
        child: const Icon(Icons.add, size: 28),
      ),
      body: RefreshIndicator(
        onRefresh: () => refreshFromGmail(context, ref),
        child: CustomScrollView(
          key: AppKeys.calendarScroll,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.m,
                AppSpacing.s,
                AppSpacing.m,
                AppSpacing.s + 2,
              ),
              sliver: SliverList.list(
                children: [
                  const BasisToggle(),
                  const SizedBox(height: AppSpacing.s + 2),
                  switch (overview) {
                    AsyncData(:final value) => MonthSummaryCard(
                      overview: value,
                    ),
                    AsyncError() => const _LoadFailed(),
                    _ => const SizedBox(
                      height: 160,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  },
                  const SizedBox(height: AppSpacing.s + 2),
                  Semantics(
                    label: t.tabs.calendar,
                    container: true,
                    child: MonthCalendarGrid(
                      key: AppKeys.monthCalendar,
                      month: CalendarMonth(view.month.year, view.month.month),
                      weekdayLabels: [weekdays[6], ...weekdays.take(6)],
                      weekdayStyle: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: palette.textSecondary,
                      ),
                      onSwipePrevious: controller.showPreviousMonth,
                      onSwipeNext: controller.showNextMonth,
                      dayBuilder: (context, day) {
                        final date = LocalDate(
                          view.month.year,
                          view.month.month,
                          day,
                        );
                        final value = overview.value;
                        return CalendarDayCell(
                          key: AppKeys.calendarDay(date),
                          date: date,
                          spendYen: value == null
                              ? 0
                              : _sum(value.expensesOn(date)),
                          hasPerformance:
                              value?.performancesOn(date).isNotEmpty ?? false,
                          isSelected: date == selected,
                          isToday: date == today,
                          hidden: hidden,
                          onTap: () => setState(() => _picked = date),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: DayRecords(
                date: selected,
                overview: overview.value,
                hidden: hidden,
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _sum(List<Expense> expenses) =>
      expenses.fold(0, (total, e) => total + e.amountYen);
}

class _LoadFailed extends StatelessWidget {
  const _LoadFailed();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(AppSpacing.m),
    child: Text(
      Translations.of(context).errors.recordStorage,
      textAlign: TextAlign.center,
    ),
  );
}
