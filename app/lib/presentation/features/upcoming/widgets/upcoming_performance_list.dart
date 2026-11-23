import 'package:app/application/application.dart';
import 'package:app/core/formatting/kakin_formats.dart';
import 'package:app/core/gen/slang.g.dart';
import 'package:app/domain/domain.dart';
import 'package:app/presentation/navigation/routes.dart';
import 'package:app/presentation/shared/keys/app_keys.dart';
import 'package:app/presentation/shared/widgets/common_widgets.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// 今後の公演を月ごとにまとめた一覧。
class UpcomingPerformanceList extends StatelessWidget {
  /// [performances] は開始日時の早い順。
  const UpcomingPerformanceList({required this.performances, super.key});

  /// 表示する公演。
  final List<UpcomingPerformance> performances;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final palette = context.palette;
    if (performances.isEmpty) {
      return SurfaceCard(
        padding: const EdgeInsets.all(AppSpacing.sm + 2),
        child: Text(
          t.upcoming.noPerformances,
          key: AppKeys.noUpcomingPerformances,
          style: TextStyle(fontSize: 13, color: palette.textSecondary),
        ),
      );
    }
    final groups = <YearMonth, List<UpcomingPerformance>>{};
    for (final item in performances) {
      groups
          .putIfAbsent(item.performance.startsOn.yearMonth, () => [])
          .add(item);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.s + 2,
      children: [
        for (final entry in groups.entries)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 6,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                child: Text(
                  KakinFormats.yearMonth(entry.key.year, entry.key.month),
                  style: AppTypography.numeric(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: palette.textTertiary,
                  ),
                ),
              ),
              SurfaceCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm + 2,
                ),
                child: Column(
                  children: [
                    for (final (index, item) in entry.value.indexed)
                      _PerformanceRow(
                        item: item,
                        showDivider: index < entry.value.length - 1,
                      ),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class _PerformanceRow extends StatelessWidget {
  const _PerformanceRow({required this.item, required this.showDivider});

  final UpcomingPerformance item;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final palette = context.palette;
    final performance = item.performance;
    final date = performance.startsOn;
    final time = KakinFormats.time(performance.startsAt);
    final venue = performance.venue;
    final meta = venue == null || venue.isEmpty
        ? t.upcoming.startsAt(time: time)
        : t.upcoming.startsAtVenue(time: time, venue: venue);
    final soon = item.daysUntil <= 7;
    return InkWell(
      key: AppKeys.upcomingPerformance(performance.id),
      onTap: () => PerformanceDetailRoute(
        performanceId: performance.id,
      ).push<void>(context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          border: showDivider
              ? Border(bottom: BorderSide(color: palette.divider))
              : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.sm,
          children: [
            Container(
              width: 46,
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.s),
              decoration: BoxDecoration(
                color: soon ? palette.accentSoft : palette.surfaceMuted,
                borderRadius: BorderRadius.circular(AppRadius.m),
              ),
              child: Column(
                spacing: 3,
                children: [
                  Text(
                    '${date.day}',
                    style: AppTypography.numeric(
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      height: 1,
                      color: soon ? palette.accentInk : null,
                    ),
                  ),
                  Text(
                    KakinFormats.weekday(date.weekday),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: soon ? palette.accentInk : palette.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 3,
                children: [
                  Text(
                    performance.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    meta,
                    style: AppTypography.numeric(
                      fontSize: 12,
                      color: palette.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              item.daysUntil == 0
                  ? t.common.today
                  : t.format.daysLeft(days: item.daysUntil),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: soon ? palette.accentStrong : palette.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
