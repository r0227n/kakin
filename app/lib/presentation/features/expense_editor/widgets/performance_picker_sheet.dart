import 'package:app/application/application.dart';
import 'package:app/core/formatting/kakin_formats.dart';
import 'package:app/core/gen/slang.g.dart';
import 'package:app/presentation/navigation/routes.dart';
import 'package:app/presentation/shared/controllers/local_data.dart';
import 'package:app/presentation/shared/keys/app_keys.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 公演の選択の結果。`performanceId` が null なら紐づけない。
typedef PerformanceChoice = ({int? performanceId});

/// 公演を選ぶボトムシート。新しい公演の登録もここから行う。
class PerformancePickerSheet extends ConsumerWidget {
  /// [allowNone] なら「紐づけない」を出す。
  const PerformancePickerSheet({
    required this.selectedId,
    required this.allowNone,
    super.key,
  });

  /// 選んでいる公演。
  final int? selectedId;

  /// 紐づけないを選べるか。
  final bool allowNone;

  /// シートを開き、選んだ結果を返す。閉じただけなら null。
  ///
  /// 新しい公演の登録を選んだら、シートを閉じてから登録画面を開き、
  /// 登録した公演を結果にする。登録をやめたら null。
  static Future<PerformanceChoice?> show(
    BuildContext context, {
    required int? selectedId,
    required bool allowNone,
  }) async {
    final result = await _open(
      context,
      selectedId: selectedId,
      allowNone: allowNone,
    );
    if (result is PerformanceChoice) return result;
    if (result != _createRequest || !context.mounted) return null;
    // シートの pop と画面の push の結果が混ざらないよう、シートを閉じてから開く。
    final id = await const NewPerformanceRoute().push<int>(context);
    return id == null ? null : (performanceId: id);
  }

  static const Object _createRequest = #createPerformance;

  static Future<Object?> _open(
    BuildContext context, {
    required int? selectedId,
    required bool allowNone,
  }) => showModalBottomSheet<Object>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      maxChildSize: 0.95,
      builder: (context, controller) => PrimaryScrollController(
        controller: controller,
        child: PerformancePickerSheet(
          selectedId: selectedId,
          allowNone: allowNone,
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final palette = context.palette;
    final performances = ref.watch(performancesProvider).value ?? const [];
    return ListView(
      primary: true,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.m,
        0,
        AppSpacing.m,
        AppSpacing.l,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.s),
          child: Semantics(
            header: true,
            child: Text(
              t.performance.pick,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        ListTile(
          key: AppKeys.performanceCreate,
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.add_circle_outline, color: palette.accent),
          title: Text(
            t.performance.createNew,
            style: TextStyle(
              color: palette.accentStrong,
              fontWeight: FontWeight.w700,
            ),
          ),
          onTap: () => Navigator.pop<Object>(context, _createRequest),
        ),
        if (allowNone)
          _Option(
            key: AppKeys.performanceNone,
            title: t.performance.none,
            selected: selectedId == null,
            onTap: () => Navigator.pop<PerformanceChoice>(context, (
              performanceId: null,
            )),
          ),
        if (performances.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.m),
            child: Text(
              t.performance.noPerformances,
              style: TextStyle(color: palette.textSecondary),
            ),
          ),
        for (final performance in performances)
          _Option(
            key: AppKeys.performanceOption(performance.id),
            title: performance.title,
            subtitle: _meta(performance),
            selected: selectedId == performance.id,
            onTap: () => Navigator.pop<PerformanceChoice>(context, (
              performanceId: performance.id,
            )),
          ),
      ],
    );
  }

  String _meta(Performance performance) => [
    KakinFormats.dateTime(performance.startsAt),
    if (performance.venue case final venue? when venue.isNotEmpty) venue,
  ].join(' · ');
}

class _Option extends StatelessWidget {
  const _Option({
    required this.title,
    required this.selected,
    required this.onTap,
    this.subtitle,
    super.key,
  });

  final String title;
  final String? subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    selected: selected,
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
    subtitle: subtitle == null ? null : Text(subtitle!),
    trailing: selected ? const Icon(Icons.check) : null,
    onTap: onTap,
  );
}
