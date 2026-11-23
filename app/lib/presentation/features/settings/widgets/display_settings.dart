import 'package:app/core/gen/slang.g.dart';
import 'package:app/domain/domain.dart';
import 'package:app/presentation/features/settings/widgets/settings_group.dart';
import 'package:app/presentation/shared/controllers/app_preferences_controller.dart';
import 'package:app/presentation/shared/feedback/action_feedback.dart';
import 'package:app/presentation/shared/keys/app_keys.dart';
import 'package:app/presentation/shared/widgets/common_widgets.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 金額の表示・テーマ・言語。
class DisplaySettings extends ConsumerWidget {
  /// 保存に成功してから表示を変える。
  const DisplaySettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final preferences = ref.watch(appPreferencesControllerProvider);
    final controller = ref.read(appPreferencesControllerProvider.notifier);
    final currentLocale = AppLocale.values.firstWhere(
      (locale) => locale.languageCode == preferences.locale.languageCode,
      orElse: () => AppLocale.ja,
    );
    return SettingsGroup(
      title: t.settings.display,
      children: [
        SettingsSwitchTile(
          key: AppKeys.settingsShowAmounts,
          label: t.settings.showAmounts,
          value: preferences.amountsVisible,
          onChanged: (value) => runWithFeedback(
            context,
            ref,
            () => controller.setAmountsVisible(visible: value),
            failureLog: 'Saving amount visibility failed',
          ),
        ),
        SettingsNote(t.settings.showAmountsNote),
        Divider(height: 1, color: context.palette.divider),
        _ChoiceRow<ThemeMode>(
          key: AppKeys.settingsTheme,
          label: t.settings.theme,
          value: preferences.themeMode,
          options: {
            ThemeMode.system: t.settings.themeSystem,
            ThemeMode.light: t.settings.themeLight,
            ThemeMode.dark: t.settings.themeDark,
          },
          onChanged: (mode) => runWithFeedback(
            context,
            ref,
            () => controller.setThemeMode(mode),
            failureLog: 'Saving the theme failed',
          ),
        ),
        Divider(height: 1, color: context.palette.divider),
        _ChoiceRow<AppLocale>(
          key: AppKeys.settingsLanguage,
          label: t.settings.language,
          value: currentLocale,
          options: {
            AppLocale.ja: t.settings.languageJapanese,
            AppLocale.en: t.settings.languageEnglish,
          },
          onChanged: (locale) => runWithFeedback(
            context,
            ref,
            () => controller.setLocale(locale),
            failureLog: 'Saving the language failed',
          ),
        ),
      ],
    );
  }
}

/// 計上基準の初期値。
class DefaultBasisSettings extends ConsumerWidget {
  /// 画面での切り替えとは別に保存する。
  const DefaultBasisSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final basis = ref.watch(
      appPreferencesControllerProvider.select((p) => p.defaultAccountingBasis),
    );
    return SettingsGroup(
      title: t.settings.defaultBasis,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.m,
        AppSpacing.m,
        AppSpacing.m,
        0,
      ),
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: SegmentToggle<AccountingBasis>(
            key: AppKeys.settingsDefaultBasis,
            semanticLabel: t.settings.defaultBasis,
            value: basis,
            options: {
              AccountingBasis.paidOn: t.basis.paidOn,
              AccountingBasis.performanceDate: t.basis.performanceDate,
            },
            onChanged: (value) => runWithFeedback(
              context,
              ref,
              () => ref
                  .read(appPreferencesControllerProvider.notifier)
                  .setDefaultAccountingBasis(value),
              failureLog: 'Saving the default accounting basis failed',
            ),
          ),
        ),
        SettingsNote(t.settings.defaultBasisNote),
      ],
    );
  }
}

/// ラベルと、選択肢をドロップダウンで選ぶボタンの行。
class _ChoiceRow<T> extends StatelessWidget {
  const _ChoiceRow({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
    super.key,
  });

  final String label;
  final T value;
  final Map<T, String> options;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final entries = options.entries.toList();
    const textStyle = TextStyle(fontSize: 14);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: AppSpacing.s,
        runSpacing: AppSpacing.s,
        children: [
          Text(label, style: textStyle),
          Semantics(
            label: label,
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: palette.border),
                borderRadius: BorderRadius.circular(AppRadius.m),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: AppSpacing.sm,
                  right: AppSpacing.xs,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<T>(
                    value: value,
                    isDense: true,
                    borderRadius: BorderRadius.circular(AppRadius.m),
                    dropdownColor: palette.surface,
                    style: textStyle.copyWith(color: palette.textPrimary),
                    icon: Icon(
                      Icons.expand_more,
                      color: palette.textSecondary,
                    ),
                    onChanged: (selected) {
                      if (selected != null && selected != value) {
                        onChanged(selected);
                      }
                    },
                    // ボタン側は key なしで描き、選択肢の key をメニューだけに置く。
                    selectedItemBuilder: (context) => [
                      for (final entry in entries) Text(entry.value),
                    ],
                    items: [
                      for (final entry in entries)
                        DropdownMenuItem<T>(
                          key: AppKeys.dropdownOption(entry.key),
                          value: entry.key,
                          child: Text(entry.value),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
