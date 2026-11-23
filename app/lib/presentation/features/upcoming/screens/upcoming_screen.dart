import 'package:app/application/application.dart';
import 'package:app/core/gen/slang.g.dart';
import 'package:app/domain/domain.dart';
import 'package:app/presentation/dependencies/application_providers.dart';
import 'package:app/presentation/features/upcoming/widgets/todo_card.dart';
import 'package:app/presentation/features/upcoming/widgets/upcoming_performance_list.dart';
import 'package:app/presentation/navigation/routes.dart';
import 'package:app/presentation/shared/controllers/local_data.dart';
import 'package:app/presentation/shared/feedback/action_feedback.dart';
import 'package:app/presentation/shared/keys/app_keys.dart';
import 'package:app/presentation/shared/widgets/common_widgets.dart';
import 'package:app/presentation/shared/widgets/visuals.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// やることと、これからの公演。金額は表示しない。
class UpcomingScreen extends ConsumerStatefulWidget {
  /// 直前のワンタップ操作は画面が持ち、元に戻せる。
  const UpcomingScreen({super.key});

  @override
  ConsumerState<UpcomingScreen> createState() => _UpcomingScreenState();
}

class _UpcomingScreenState extends ConsumerState<UpcomingScreen>
    with WidgetsBindingObserver {
  StageChange? _lastChange;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // 端末の設定で通知を許可して戻ってきたときに表示を更新する。
    if (state == AppLifecycleState.resumed) {
      ref.invalidate(notificationPermissionProvider);
    }
  }

  Future<void> _advance(TodoItem todo, QuickStageAction action) async {
    final change = await runWithFeedback(
      context,
      ref,
      () => ref
          .read(ticketApplicationUseCaseProvider)
          .advance(todo.application.id, action),
      failureLog: 'Advancing a ticket application failed',
    );
    if (!mounted || change == null) return;
    setState(() => _lastChange = change);
  }

  Future<void> _undo() async {
    final change = _lastChange;
    if (change == null) return;
    setState(() => _lastChange = null);
    await runWithFeedback(
      context,
      ref,
      () => ref.read(ticketApplicationUseCaseProvider).undo(change),
      failureLog: 'Undoing a stage change failed',
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final palette = context.palette;
    final overview = ref.watch(upcomingOverviewProvider);
    final permission = ref.watch(notificationPermissionProvider).value;
    final value = overview.value;
    final change = _lastChange;
    return Scaffold(
      appBar: AppBar(
        title: Text(t.tabs.upcoming),
        actions: [
          FilledButton.icon(
            key: AppKeys.addApplication,
            style: FilledButton.styleFrom(
              minimumSize: const Size(0, 40),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm + 2,
              ),
              shape: const StadiumBorder(),
              textStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            onPressed: () =>
                const NewTicketApplicationRoute().push<void>(context),
            icon: const Icon(Icons.add, size: 18),
            label: Text(t.upcoming.addApplication),
          ),
          const SizedBox(width: AppSpacing.s),
        ],
      ),
      body: ListView(
        key: AppKeys.upcomingScroll,
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.m,
          AppSpacing.s,
          AppSpacing.m,
          AppSpacing.l,
        ),
        children: [
          if (permission == NotificationPermission.denied) ...[
            SurfaceCard(
              key: AppKeys.notificationsDenied,
              color: palette.warningSoft,
              border: Border.all(color: palette.warningBorder),
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSpacing.s,
                children: [
                  Icon(
                    Icons.notifications_off_outlined,
                    size: 18,
                    color: palette.warningInk,
                  ),
                  Expanded(
                    child: Text(
                      t.upcoming.notificationsDenied,
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.5,
                        color: palette.warningInk,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.ml - 2),
          ],
          SectionHeader(
            title: t.upcoming.todo,
            trailing: Text(
              t.upcoming.todoOrder,
              style: TextStyle(fontSize: 12, color: palette.textSecondary),
            ),
          ),
          const SizedBox(height: AppSpacing.s),
          if (change != null) ...[
            _UndoBanner(
              text: t.upcoming.stageChanged(
                title: change.performanceTitle,
                stage: change.to.label(t),
              ),
              onUndo: _undo,
            ),
            const SizedBox(height: AppSpacing.s),
          ],
          if (value == null)
            const Padding(
              padding: EdgeInsets.all(AppSpacing.l),
              child: Center(child: CircularProgressIndicator()),
            )
          else ...[
            if (value.todos.isEmpty)
              SurfaceCard(
                padding: const EdgeInsets.all(AppSpacing.sm + 2),
                child: Text(
                  t.upcoming.noTodo,
                  key: AppKeys.noTodo,
                  style: TextStyle(
                    fontSize: 13,
                    color: palette.textSecondary,
                  ),
                ),
              ),
            for (final todo in value.todos) ...[
              TodoCard(
                todo: todo,
                now: ref.read(clockProvider).now(),
                onAction: (action) => _advance(todo, action),
              ),
              const SizedBox(height: AppSpacing.s),
            ],
            const SizedBox(height: AppSpacing.sm),
            SectionHeader(title: t.upcoming.performances),
            const SizedBox(height: AppSpacing.s + 2),
            UpcomingPerformanceList(performances: value.performances),
          ],
        ],
      ),
    );
  }
}

class _UndoBanner extends StatelessWidget {
  const _UndoBanner({required this.text, required this.onUndo});

  final String text;
  final VoidCallback onUndo;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final palette = context.palette;
    return Semantics(
      liveRegion: true,
      container: true,
      child: Container(
        key: AppKeys.undoBanner,
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.sm + 2,
          AppSpacing.s + 2,
          AppSpacing.sm,
          AppSpacing.s + 2,
        ),
        decoration: BoxDecoration(
          color: palette.inverseSurface,
          borderRadius: BorderRadius.circular(AppRadius.l - 2),
        ),
        child: Row(
          spacing: AppSpacing.s,
          children: [
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: palette.onInverseSurface,
                ),
              ),
            ),
            TextButton(
              key: AppKeys.undoStageChange,
              style: TextButton.styleFrom(
                foregroundColor: palette.inverseAccent,
                minimumSize: const Size(44, 36),
                textStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              onPressed: onUndo,
              child: Text(t.common.undo),
            ),
          ],
        ),
      ),
    );
  }
}
