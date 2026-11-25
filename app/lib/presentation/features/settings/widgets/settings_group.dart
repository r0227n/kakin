import 'package:app/presentation/shared/widgets/common_widgets.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// 設定の見出しと、その下の白い面。
class SettingsGroup extends StatelessWidget {
  /// [children] を区切り線なしで縦に並べる。
  const SettingsGroup({
    required this.title,
    required this.children,
    this.padding = const EdgeInsets.symmetric(horizontal: AppSpacing.m),
    super.key,
  });

  /// 見出し。
  final String title;

  /// 中身。
  final List<Widget> children;

  /// 面の内側の余白。
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: AppSpacing.s,
    children: [
      SectionHeader(title: title),
      SurfaceCard(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
    ],
  );
}

/// 値を表示してタップで編集する行。
class SettingsTile extends StatelessWidget {
  /// [subtitle] は値の補足。
  const SettingsTile({
    required this.label,
    required this.onTap,
    this.value,
    this.subtitle,
    this.showDivider = true,
    super.key,
  });

  /// 項目名。
  final String label;

  /// 現在の値。
  final String? value;

  /// 補足。
  final String? subtitle;

  /// 編集を開く。
  final VoidCallback onTap;

  /// 下に区切り線を引くか。
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return InkWell(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 52),
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          border: showDivider
              ? Border(bottom: BorderSide(color: palette.divider))
              : null,
        ),
        child: Row(
          spacing: AppSpacing.s,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSpacing.xxs,
                children: [
                  Text(label, style: const TextStyle(fontSize: 14)),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: AppTypography.numeric(
                        fontSize: 12,
                        color: palette.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
            if (value != null)
              Text(
                value!,
                style: AppTypography.numeric(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            Icon(Icons.chevron_right, size: 20, color: palette.textSecondary),
          ],
        ),
      ),
    );
  }
}

/// スイッチの行。
class SettingsSwitchTile extends StatelessWidget {
  /// [subtitle] は補足。
  const SettingsSwitchTile({
    required this.label,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.showDivider = true,
    super.key,
  });

  /// 項目名。
  final String label;

  /// 補足。
  final String? subtitle;

  /// オンか。
  final bool value;

  /// 切り替える。null なら操作できない。
  final ValueChanged<bool>? onChanged;

  /// 下に区切り線を引くか。
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: showDivider
            ? Border(bottom: BorderSide(color: palette.divider))
            : null,
      ),
      child: MergeSemantics(
        child: SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: Text(label, style: const TextStyle(fontSize: 14)),
          subtitle: subtitle == null
              ? null
              : Text(
                  subtitle!,
                  style: TextStyle(fontSize: 12, color: palette.textSecondary),
                ),
          value: value,
          onChanged: onChanged,
        ),
      ),
    );
  }
}

/// 項目の下の注記。
class SettingsNote extends StatelessWidget {
  /// 小さな補足の文。
  const SettingsNote(this.text, {super.key});

  /// 文言。
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 12,
        height: 1.6,
        color: context.palette.textSecondary,
      ),
    ),
  );
}
