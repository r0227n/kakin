import 'dart:async';

import 'package:app/app/kakin_app.dart';
import 'package:app/application/application.dart';
import 'package:app/application/errors/settings_error.dart';
import 'package:app/core/gen/slang.g.dart';
import 'package:app/presentation/dependencies/application_providers.dart';
import 'package:app/presentation/dependencies/observability_providers.dart';
import 'package:app/presentation/navigation/app_router.dart';
import 'package:app/presentation/shared/controllers/app_preferences_controller.dart';
import 'package:app/presentation/shared/keys/app_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fakes.dart';
import '../support/test_graph.dart';

void main() {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() async {
    binding.platformDispatcher.localesTestValue = [const Locale('ja')];
    await LocaleSettings.setLocale(AppLocale.ja);
  });
  tearDown(() async {
    binding.platformDispatcher.clearLocalesTestValue();
    await LocaleSettings.setLocale(AppLocale.ja);
  });

  Future<TestGraph> pumpApp(
    WidgetTester tester, {
    Map<String, Object> prefs = const {},
    String? initialLocation,
    Size size = const Size(390, 844),
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final test = await tester.runAsync(() => TestGraph.create(prefs: prefs));
    addTearDown(() => tester.runAsync(test!.close));
    final router = buildAppRouter(
      onboardingCompleted:
          test!.graph.initialAppPreferences.onboardingCompleted,
      initialLocation: initialLocation,
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(test.graph.attach(child: KakinApp(router: router)));
    await _settle(tester);
    return test;
  }

  testWidgets('restores settings before the first frame', (tester) async {
    await LocaleSettings.setLocale(AppLocale.en);
    await pumpApp(tester, prefs: {'app.theme': 'dark', 'app.language': 'en'});

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.themeMode, ThemeMode.dark);
    expect(materialApp.locale, const Locale('en'));
    expect(find.byKey(AppKeys.onboardingStart), findsOneWidget);
  });

  testWidgets('onboarding saves the budget and opens the calendar', (
    tester,
  ) async {
    final test = await pumpApp(tester);

    await _tapKey(tester, AppKeys.onboardingStart);
    await _settle(tester);
    await tester.enterText(find.byKey(AppKeys.budgetAmount), '20000');
    await _settle(tester);
    await _tapKey(tester, AppKeys.onboardingBudgetSave);
    await _settle(tester);
    await _tapKey(tester, AppKeys.onboardingGmailSkip);
    await _settle(tester);

    expect(find.byKey(AppKeys.monthCalendar), findsOneWidget);
    expect(test.preferences.getBool('onboarding.completed'), isTrue);
    expect(
      tester.widget<Text>(find.byKey(AppKeys.summaryBalance)).data,
      '¥20,000',
    );
  });

  testWidgets('settings save theme and language from the display section', (
    tester,
  ) async {
    final test = await pumpApp(
      tester,
      prefs: {'onboarding.completed': true},
      initialLocation: '/settings',
    );

    final theme = find.byKey(AppKeys.settingsTheme);
    await tester.ensureVisible(theme);
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(of: theme, matching: find.text('ダーク')),
    );
    await _settle(tester);
    expect(test.preferences.getString('app.theme'), 'dark');
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.dark,
    );

    await tester.tap(find.text('English'));
    await _settle(tester);
    expect(test.preferences.getString('app.language'), 'en');
    expect(find.text('Settings'), findsWidgets);
  });

  testWidgets('every tab survives large text on a narrow screen', (
    tester,
  ) async {
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await pumpApp(
      tester,
      prefs: {'onboarding.completed': true},
      size: const Size(320, 640),
    );

    for (final tab in [
      AppKeys.tabList,
      AppKeys.tabUpcoming,
      AppKeys.tabSettings,
    ]) {
      await _tapKey(tester, tab);
      await _settle(tester);
      expect(tester.takeException(), isNull, reason: '$tab');
    }
    await _tapKey(tester, AppKeys.tabCalendar);
    await _settle(tester);
    await _tapKey(tester, AppKeys.addExpense);
    await _settle(tester);
    expect(find.byKey(AppKeys.expenseSave), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a failed save keeps the previous value and reports once', (
    tester,
  ) async {
    final gate = Completer<void>();
    final repository = FakeAppPreferencesRepository(
      snapshot: const AppPreferencesSnapshot(
        theme: AppThemePreference.dark,
        locale: LocalePreference(languageCode: 'ja'),
        onboardingCompleted: true,
      ),
    )..beforeSave = () => gate.future;
    final reporter = RecordingErrorReporter();
    final test = await tester.runAsync(TestGraph.create);
    addTearDown(() => tester.runAsync(test!.close));
    final router = buildAppRouter(
      onboardingCompleted: true,
      initialLocation: '/settings',
    );
    addTearDown(router.dispose);
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      replaceOverrides(test!.graph.attach(child: KakinApp(router: router)), [
        appPreferencesUseCaseProvider.overrideWithValue(
          AppPreferencesUseCase(repository),
        ),
        initialAppPreferencesSnapshotProvider.overrideWithValue(
          repository.load(),
        ),
        errorReporterProvider.overrideWithValue(reporter),
      ]),
    );
    await _settle(tester);

    final theme = find.byKey(AppKeys.settingsTheme);
    await tester.ensureVisible(theme);
    await tester.pumpAndSettle();
    await tester.tap(find.descendant(of: theme, matching: find.text('ライト')));
    await tester.pump();
    final container = ProviderScope.containerOf(
      tester.element(find.byType(KakinApp)),
    );
    expect(container.read(appPreferencesControllerProvider).isSaving, isTrue);

    gate.completeError(const SettingsWriteException());
    await _settle(tester);
    expect(find.text('設定を保存できませんでした。もう一度お試しください。'), findsOneWidget);
    expect(reporter.errors, hasLength(1));
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.dark,
    );
    expect(container.read(appPreferencesControllerProvider).isSaving, isFalse);
  });
}

/// DB の読み書きは実時間で進むため、実時間と仮想時間を交互に進める。
Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 5; i++) {
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pump(const Duration(milliseconds: 100));
  }
  await tester.pumpAndSettle();
}

Future<void> _tapKey(WidgetTester tester, Key key) async {
  final finder = find.byKey(key);
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await _settle(tester);
}
