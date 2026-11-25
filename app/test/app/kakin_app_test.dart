import 'dart:async';

import 'package:app/app/kakin_app.dart';
import 'package:app/application/application.dart';
import 'package:app/application/errors/settings_error.dart';
import 'package:app/core/gen/slang.g.dart';
import 'package:app/domain/domain.dart';
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
    Future<void> Function(TestGraph test)? seed,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final test = await tester.runAsync(() => TestGraph.create(prefs: prefs));
    addTearDown(() => tester.runAsync(test!.close));
    if (seed != null) await tester.runAsync(() => seed(test!));
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
      find.descendant(
        of: theme,
        matching: find.byType(DropdownButton<ThemeMode>),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(AppKeys.dropdownOption(ThemeMode.dark)));
    await _settle(tester);
    expect(test.preferences.getString('app.theme'), 'dark');
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.dark,
    );

    final language = find.byKey(AppKeys.settingsLanguage);
    await tester.ensureVisible(language);
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(
        of: language,
        matching: find.byType(DropdownButton<AppLocale>),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(AppKeys.dropdownOption(AppLocale.en)));
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

  testWidgets('tapping the amount field takes focus back from the note', (
    tester,
  ) async {
    await pumpApp(tester, prefs: {'onboarding.completed': true});
    await _tapKey(tester, AppKeys.addExpense);
    await _settle(tester);
    String? focused() => FocusManager.instance.primaryFocus?.debugLabel;
    expect(focused(), 'amount', reason: 'focused when the editor opens');

    await _tapKey(tester, AppKeys.expenseNote);
    expect(focused(), isNot('amount'));
    expect(tester.testTextInput.isVisible, isTrue);

    await _tapKey(tester, AppKeys.expenseAmountField);
    expect(focused(), 'amount');
    expect(tester.testTextInput.isVisible, isFalse);

    await _tapKey(tester, AppKeys.expenseNote);
    await _tapKey(tester, AppKeys.keypad('5'));
    expect(focused(), 'amount', reason: 'the keypad moves focus back');
    expect(
      tester.widget<Text>(find.byKey(AppKeys.expenseAmount)).data,
      '¥5',
    );
  });

  testWidgets('a zero-yen expense can be recorded', (tester) async {
    final test = await pumpApp(
      tester,
      prefs: {'onboarding.completed': true},
      seed: (test) => test.graph.performance.create(
        PerformanceDraft(title: '無料ライブ', startsAt: test.clock.now()),
      ),
    );
    await _tapKey(tester, AppKeys.addExpense);
    await _settle(tester);
    expect(
      tester.widget<FilledButton>(find.byKey(AppKeys.expenseSave)).enabled,
      isFalse,
      reason: 'an empty amount is not zero',
    );

    await _tapKey(tester, AppKeys.keypad('0'));
    await _tapKey(tester, AppKeys.keypad('0'));
    expect(
      tester.widget<Text>(find.byKey(AppKeys.expenseAmount)).data,
      '¥0',
    );
    await _tapKey(tester, AppKeys.expenseSave);
    await _settle(tester);

    final month = await tester.runAsync(
      () => test.graph.ledger.loadMonth(
        YearMonth(2026, 11),
        AccountingBasis.paidOn,
      ),
    );
    expect(month!.expenses.single.amountYen, 0);
    expect(month.expenses.single.category, ExpenseCategory.drink);
  });

  testWidgets('editing a cheki rewrites its amount and keeps the shots', (
    tester,
  ) async {
    late int expenseId;
    final test = await pumpApp(
      tester,
      prefs: {'onboarding.completed': true},
      seed: (test) async {
        final graph = test.graph;
        final performanceId = await graph.performance.create(
          PerformanceDraft(title: '定期公演', startsAt: test.clock.now()),
        );
        final partnerId = await graph.partner.create(
          const PartnerDraft(name: 'あおい'),
        );
        final ids = await graph.expense.record([
          ExpenseDraft(
            category: ExpenseCategory.cheki,
            // 3枚セットの額は単価 × 枚数では表せない。
            amountYen: 2500,
            paidOn: LocalDate(2026, 11, 22),
            performanceId: performanceId,
            partnerId: partnerId,
            shotCount: 3,
          ),
        ]);
        expenseId = ids.single;
      },
    );
    await _tapKey(tester, AppKeys.tabList);
    await _tapKey(tester, AppKeys.expenseRow(expenseId));
    await _settle(tester);
    expect(
      tester.widget<Text>(find.byKey(AppKeys.expenseAmount)).data,
      '¥2,500',
    );

    await _tapKey(tester, AppKeys.keypadBackspace);
    await _tapKey(tester, AppKeys.expenseSave);
    await _settle(tester);

    final saved = await tester.runAsync(
      () => test.graph.expense.find(expenseId),
    );
    expect(saved!.amountYen, 250);
    expect(saved.shotCount, 3);
  });

  testWidgets('a budget that starts later is shown as such', (tester) async {
    await pumpApp(
      tester,
      prefs: {'onboarding.completed': true},
      seed: (test) => test.graph.budget.configure(
        startMonth: YearMonth(2026, 12),
        monthlyYen: 20000,
      ),
    );
    expect(find.text('開始月より前の月です。残高には含めません'), findsOneWidget);
    expect(find.byKey(AppKeys.summaryBalance), findsNothing);

    await _tapKey(tester, AppKeys.tabSettings);
    expect(
      find.descendant(
        of: find.byKey(AppKeys.settingsBudgetMonthly),
        matching: find.text('¥20,000'),
      ),
      findsOneWidget,
    );
    await _tapKey(tester, AppKeys.settingsBudgetMonthly);
    expect(
      tester
          .widget<TextField>(find.byKey(AppKeys.budgetAmount))
          .controller!
          .text,
      '20000',
    );
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
    await tester.tap(
      find.descendant(
        of: theme,
        matching: find.byType(DropdownButton<ThemeMode>),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(AppKeys.dropdownOption(ThemeMode.light)));
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
