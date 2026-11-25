import 'package:app/application/application.dart';
import 'package:app/core/formatting/kakin_formats.dart';
import 'package:app/core/gen/slang.g.dart';
import 'package:app/presentation/dependencies/application_providers.dart';
import 'package:app/presentation/navigation/routes.dart';
import 'package:app/presentation/shared/controllers/local_data.dart';
import 'package:app/presentation/shared/feedback/action_feedback.dart';
import 'package:app/presentation/shared/keys/app_keys.dart';
import 'package:app/presentation/shared/widgets/common_widgets.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 公演の内容。公演の編集と削除もここから行う。
class PerformanceDetailScreen extends ConsumerStatefulWidget {
  /// [performanceId] の公演を表示する。
  const PerformanceDetailScreen({required this.performanceId, super.key});

  /// 表示する公演。
  final int performanceId;

  @override
  ConsumerState<PerformanceDetailScreen> createState() =>
      _PerformanceDetailScreenState();
}

class _PerformanceDetailScreenState
    extends ConsumerState<PerformanceDetailScreen> {
  bool _deleting = false;

  int get performanceId => widget.performanceId;

  /// 確認と削除が終わるまで、削除のボタンを止める。
  Future<void> _delete() async {
    if (_deleting) return;
    setState(() => _deleting = true);
    try {
      await _confirmAndDelete();
    } finally {
      if (mounted) setState(() => _deleting = false);
    }
  }

  Future<void> _confirmAndDelete() async {
    final t = Translations.of(context);
    final useCase = ref.read(performanceUseCaseProvider);
    final impact = await runWithFeedback(
      context,
      ref,
      () => useCase.deletionImpact(performanceId),
      failureLog: 'Loading the performance deletion impact failed',
    );
    if (impact == null || !mounted) return;
    final confirmed = await confirmDestructive(
      context,
      title: t.performance.deleteTitle,
      body: t.performance.deleteBody(
        count: impact.expenseCount,
        amount: KakinFormats.yen(impact.expenseTotalYen),
      ),
    );
    if (!confirmed || !mounted) return;
    final deleted = await runWithFeedback(
      context,
      ref,
      () async {
        await useCase.delete(performanceId);
        return true;
      },
      failureLog: 'Deleting a performance failed',
    );
    if (!(deleted ?? false) || !mounted) return;
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final palette = context.palette;
    final performance = ref.watch(performanceProvider(performanceId));
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
      // 読み直しの間は前の内容を出し続ける。削除した後は閉じるまで何も出さない。
      body: switch (performance) {
        AsyncValue(value: final Performance p) => ListView(
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
            const SizedBox(height: AppSpacing.xl),
            OutlinedButton.icon(
              key: AppKeys.deletePerformance,
              style: OutlinedButton.styleFrom(
                foregroundColor: palette.negative,
                side: BorderSide(color: palette.border),
              ),
              onPressed: _deleting ? null : _delete,
              icon: const Icon(Icons.delete_outline),
              label: Text(t.performance.delete),
            ),
          ],
        ),
        AsyncError() => Center(child: Text(t.errors.recordStorage)),
        AsyncData() => const SizedBox.shrink(),
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
