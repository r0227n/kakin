import 'package:app/core/gen/slang.g.dart';
import 'package:app/presentation/features/upcoming/widgets/upcoming_performance_list.dart';
import 'package:app/presentation/shared/controllers/local_data.dart';
import 'package:app/presentation/shared/keys/app_keys.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// チケット代を記録した、これから行く公演の一覧。金額は表示しない。
class UpcomingScreen extends ConsumerWidget {
  /// 公演は [upcomingPerformancesProvider] が読み込む。
  const UpcomingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final performances = ref.watch(upcomingPerformancesProvider);
    return Scaffold(
      appBar: AppBar(title: Text(t.tabs.upcoming)),
      body: switch (performances) {
        // 読み直しの間は前の一覧を出し続ける。
        AsyncValue(:final value?) => ListView(
          key: AppKeys.upcomingScroll,
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.m,
            AppSpacing.s,
            AppSpacing.m,
            AppSpacing.l,
          ),
          children: [UpcomingPerformanceList(performances: value)],
        ),
        AsyncError() => Center(child: Text(t.errors.recordStorage)),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
