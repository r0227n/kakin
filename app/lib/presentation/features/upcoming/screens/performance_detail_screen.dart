import 'package:app/application/application.dart';
import 'package:app/core/formatting/kakin_formats.dart';
import 'package:app/core/gen/slang.g.dart';
import 'package:app/domain/domain.dart';
import 'package:app/presentation/dependencies/application_providers.dart';
import 'package:app/presentation/navigation/routes.dart';
import 'package:app/presentation/shared/controllers/local_data.dart';
import 'package:app/presentation/shared/feedback/action_feedback.dart';
import 'package:app/presentation/shared/keys/app_keys.dart';
import 'package:app/presentation/shared/widgets/common_widgets.dart';
import 'package:app/presentation/shared/widgets/visuals.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 公演の内容と、そのチケット申込。公演の削除もここから行う。
class PerformanceDetailScreen extends ConsumerWidget {
  /// [performanceId] の公演を表示する。
  const PerformanceDetailScreen({required this.performanceId, super.key});

  /// 表示する公演。
  final int performanceId;

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final t = Translations.of(context);
    final useCase = ref.read(performanceUseCaseProvider);
    final impact = await runWithFeedback(
      context,
      ref,
      () => useCase.deletionImpact(performanceId),
      failureLog: 'Loading the performance deletion impact failed',
    );
    if (impact == null || !context.mounted) return;
    final confirmed = await confirmDestructive(
      context,
      title: t.performance.deleteTitle,
      body: t.performance.deleteBody(
        count: impact.expenseCount,
        amount: KakinFormats.yen(impact.expenseTotalYen),
        applications: impact.applicationCount,
      ),
    );
    if (!confirmed || !context.mounted) return;
    final deleted = await runWithFeedback(
      context,
      ref,
      () async {
        await useCase.delete(performanceId);
        return true;
      },
      failureLog: 'Deleting a performance failed',
    );
    if (!(deleted ?? false) || !context.mounted) return;
    context.pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final palette = context.palette;
    final performance = ref.watch(performanceProvider(performanceId));
    final applications = ref.watch(
      performanceApplicationsProvider(performanceId),
    );
    final value = performance.value;
    return Scaffold(
      appBar: AppBar(
        title: Text(t.performance.title),
        actions: [
          if (value != null)
            IconButton(
              key: AppKeys.editPerformance,
              tooltip: t.performance.editTitle,
              onPressed: () => EditPerformanceRoute(
                performanceId: performanceId,
              ).push<void>(context),
              icon: const Icon(Icons.edit_outlined),
            ),
        ],
      ),
      body: switch (performance) {
        AsyncData(value: null) => Center(child: Text(t.errors.recordStorage)),
        AsyncData(value: final Performance p) => ListView(
          padding: const EdgeInsets.all(AppSpacing.m),
          children: [
            SurfaceCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSpacing.s,
                children: [
                  Semantics(
                    header: true,
                    child: Text(
                      p.title,
                      key: AppKeys.performanceTitle,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  _Meta(
                    icon: Icons.event_outlined,
                    text: KakinFormats.dateTime(p.startsAt),
                  ),
                  if (p.venue case final venue? when venue.isNotEmpty)
                    _Meta(icon: Icons.place_outlined, text: venue),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.l),
            SectionHeader(
              title: t.performance.applications,
              trailing: TextButton.icon(
                key: AppKeys.addApplicationForPerformance,
                onPressed: () => NewTicketApplicationRoute(
                  performanceId: performanceId,
                ).push<void>(context),
                icon: const Icon(Icons.add, size: 18),
                label: Text(t.application.add),
              ),
            ),
            const SizedBox(height: AppSpacing.s),
            switch (applications) {
              AsyncData(value: final list) when list.isEmpty => SurfaceCard(
                child: Text(
                  t.performance.noApplications,
                  style: TextStyle(fontSize: 13, color: palette.textSecondary),
                ),
              ),
              AsyncData(value: final list) => Column(
                spacing: AppSpacing.s,
                children: [
                  for (final application in list)
                    _ApplicationTile(application: application),
                ],
              ),
              _ => const Center(child: CircularProgressIndicator()),
            },
            const SizedBox(height: AppSpacing.xl),
            OutlinedButton.icon(
              key: AppKeys.deletePerformance,
              style: OutlinedButton.styleFrom(
                foregroundColor: palette.negative,
                side: BorderSide(color: palette.border),
              ),
              onPressed: () => _delete(context, ref),
              icon: const Icon(Icons.delete_outline),
              label: Text(t.performance.delete),
            ),
          ],
        ),
        AsyncError() => Center(child: Text(t.errors.recordStorage)),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Row(
    spacing: AppSpacing.s,
    children: [
      Icon(icon, size: 18, color: context.palette.textSecondary),
      Expanded(
        child: Text(
          text,
          style: AppTypography.numeric(
            fontSize: 14,
            color: context.palette.textTertiary,
          ),
        ),
      ),
    ],
  );
}

class _ApplicationTile extends StatelessWidget {
  const _ApplicationTile({required this.application});

  final TicketApplication application;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final palette = context.palette;
    final tone = application.stage.tone(palette);
    final service = application.service;
    final deadlines = [
      for (final kind in TicketDeadlineKind.values)
        if (application.deadlineOf(kind) case final at?)
          '${kind.shortLabel(t)} ${KakinFormats.dateTime(at)}',
    ];
    return Material(
      color: palette.surface,
      borderRadius: BorderRadius.circular(AppRadius.l),
      child: InkWell(
        key: AppKeys.application(application.id),
        borderRadius: BorderRadius.circular(AppRadius.l),
        onTap: () => EditTicketApplicationRoute(
          applicationId: application.id,
        ).push<void>(context),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm + 2),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSpacing.xs,
                  children: [
                    Wrap(
                      spacing: 6,
                      runSpacing: AppSpacing.xs,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        TagChip(
                          label: application.stage.label(t),
                          foreground: tone.ink,
                          background: tone.soft,
                        ),
                        if (service != null)
                          Text(
                            service.label(t),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        if (application.isImported)
                          TagChip(
                            label: t.calendar.gmailBadge,
                            foreground: palette.accentStrong,
                            background: palette.accentSoft,
                          ),
                      ],
                    ),
                    if (application.referenceNo case final no?
                        when no.isNotEmpty)
                      Text(
                        '${t.application.referenceNo} $no',
                        style: AppTypography.numeric(
                          fontSize: 12,
                          color: palette.textSecondary,
                        ),
                      ),
                    for (final line in deadlines)
                      Text(
                        line,
                        style: AppTypography.numeric(
                          fontSize: 12,
                          color: palette.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: palette.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
