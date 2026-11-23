import 'package:app/app/dependency_graph.dart';
import 'package:app/infrastructure/infrastructure.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart'
    show $ProviderOverride;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker/talker.dart';

import 'fakes.dart';

/// 端末 API の代わりに fake とメモリ上の DB で組み立てた本番の依存。
final class TestGraph {
  TestGraph._(
    this.graph,
    this.database,
    this.preferences,
    this.scheduler,
    this.clock,
  );

  /// [prefs] を保存済みの設定として、[now] の時計で組み立てる。
  static Future<TestGraph> create({
    Map<String, Object> prefs = const {},
    DateTime? now,
  }) async {
    SharedPreferences.setMockInitialValues(prefs);
    final preferences = await SharedPreferences.getInstance();
    final database = AppDatabase(NativeDatabase.memory());
    final scheduler = FakeReminderScheduler();
    final clock = FixedClock(now ?? DateTime.utc(2026, 11, 22, 3));
    final graph = AppDependencyGraph(
      sharedPreferences: preferences,
      talker: Talker(settings: TalkerSettings(enabled: false)),
      database: database,
      scheduler: scheduler,
      iconStore: FakePartnerIconStore(),
      iconPicker: FakePartnerIconPicker(),
      clock: clock,
    );
    return TestGraph._(graph, database, preferences, scheduler, clock);
  }

  /// 結線済みの依存。
  final AppDependencyGraph graph;

  /// メモリ上の DB。
  final AppDatabase database;

  /// 保存済みの設定。
  final SharedPreferences preferences;

  /// 予約した通知。
  final FakeReminderScheduler scheduler;

  /// 時計。
  final FixedClock clock;

  /// DB を閉じる。
  Future<void> close() => database.close();
}

/// [scope] の依存のうち [replacements] と同じ provider を差し替える。
ProviderScope replaceOverrides(
  ProviderScope scope,
  List<Override> replacements,
) {
  Object? originOf(Override override) =>
      override is $ProviderOverride ? override.origin : null;
  final replaced = {for (final o in replacements) originOf(o)};
  return ProviderScope(
    observers: scope.observers,
    overrides: [
      for (final o in scope.overrides)
        if (!replaced.contains(originOf(o))) o,
      ...replacements,
    ],
    child: scope.child,
  );
}
