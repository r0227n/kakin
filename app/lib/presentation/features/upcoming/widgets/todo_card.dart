import 'package:app/application/application.dart';
import 'package:app/core/formatting/kakin_formats.dart';
import 'package:app/core/gen/slang.g.dart';
import 'package:app/domain/domain.dart';
import 'package:app/presentation/navigation/routes.dart';
import 'package:app/presentation/shared/keys/app_keys.dart';
import 'package:app/presentation/shared/widgets/common_widgets.dart';
import 'package:app/presentation/shared/widgets/visuals.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// やることの1件。期限と、段階をワンタップで進めるボタンを持つ。
class TodoCard extends StatelessWidget {
  /// [onAction] で段階を進める。
  const TodoCard({
    required this.todo,
    required this.now,
    required this.onAction,
    super.key,
  });

  /// 表示するやること。
  final TodoItem todo;

  /// 残り日数の基準。
  final DateTime now;

  /// ワンタップの操作。
  final ValueChanged<QuickStageAction> onAction;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final palette = context.palette;
    final tone = todo.kind.tone(palette);
    final application = todo.application;
    final service = application.service;
    final days = JapanTime.dateOf(now).daysUntil(JapanTime.dateOf(todo.dueAt));
    final kindLabel = todo.isOverdue
        ? t.upcoming.overdue(kind: todo.kind.shortLabel(t))
        : todo.kind.shortLabel(t);
    final due = [
      KakinFormats.dateTime(todo.dueAt),
      if (service != null) service.label(t),
    ].join(' · ');
    final left = todo.isOverdue
        ? t.upcoming.needsUpdate
        : (days <= 0 ? t.common.today : t.format.daysLeft(days: days));
    final urgent = todo.isOverdue || days <= 1;
    return SurfaceCard(
      key: AppKeys.todo(application.id, todo.kind),
      padding: const EdgeInsets.all(AppSpacing.sm),
      border: todo.isOverdue
          ? Border.all(color: palette.warningBorder, width: 1.5)
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.s + 2,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(AppRadius.m),
            onTap: () => EditTicketApplicationRoute(
              applicationId: application.id,
            ).push<void>(context),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 44),
              child: Row(
                spacing: AppSpacing.sm,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: tone.soft,
                      borderRadius: BorderRadius.circular(AppRadius.m),
                    ),
                    child: Icon(todo.kind.icon, size: 20, color: tone.ink),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: AppSpacing.xxs,
                      children: [
                        Text(
                          kindLabel,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: todo.isOverdue
                                ? palette.warningInk
                                : tone.ink,
                          ),
                        ),
                        Text(
                          application.performance.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          due,
                          style: AppTypography.numeric(
                            fontSize: 12,
                            color: palette.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: urgent
                          ? palette.roseTone.soft
                          : palette.surfaceMuted,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.s + 2,
                        vertical: AppSpacing.xs,
                      ),
                      child: Text(
                        left,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: urgent
                              ? palette.roseTone.ink
                              : palette.textTertiary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 52),
            child: Wrap(
              spacing: AppSpacing.s,
              runSpacing: AppSpacing.s,
              children: [
                for (final (index, action) in todo.actions.indexed)
                  _ActionButton(
                    key: AppKeys.todoAction(application.id, action),
                    label: action.label(t),
                    semanticLabel: t.upcoming.actionLabel(
                      title: application.performance.title,
                      stage: action.to.label(t),
                    ),
                    primary: index == 0,
                    onPressed: () => onAction(action),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.semanticLabel,
    required this.primary,
    required this.onPressed,
    super.key,
  });

  final String label;
  final String semanticLabel;
  final bool primary;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    const size = Size(76, 40);
    final style = ButtonStyle(
      minimumSize: const WidgetStatePropertyAll(size),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: AppSpacing.sm + 2),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.m),
        ),
      ),
      textStyle: const WidgetStatePropertyAll(
        TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
      ),
    );
    return Semantics(
      label: semanticLabel,
      button: true,
      excludeSemantics: true,
      child: primary
          ? FilledButton(onPressed: onPressed, style: style, child: Text(label))
          : OutlinedButton(
              onPressed: onPressed,
              style: style,
              child: Text(label),
            ),
    );
  }
}
