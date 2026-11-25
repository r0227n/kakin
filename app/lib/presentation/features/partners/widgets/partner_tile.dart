import 'package:app/application/application.dart';
import 'package:app/core/gen/slang.g.dart';
import 'package:app/presentation/shared/widgets/common_widgets.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// 選択できるチェキ相手の1行。
class PartnerTile extends StatelessWidget {
  /// [selected] ならチェックを付ける。
  const PartnerTile({
    required this.partner,
    required this.iconPath,
    required this.selected,
    required this.subtitle,
    required this.onTap,
    required this.onEdit,
    super.key,
  });

  /// 相手。
  final Partner partner;

  /// アイコン画像のパス。
  final String? iconPath;

  /// 選んでいるか。
  final bool selected;

  /// 前回の撮影などの補足。
  final String subtitle;

  /// 選択を切り替える。
  final VoidCallback onTap;

  /// 編集を開く。
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final palette = context.palette;
    final group = partner.groupName;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: selected ? palette.cheki.soft : palette.surface,
        borderRadius: BorderRadius.circular(AppRadius.m),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.m),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.sm,
              AppSpacing.s,
              AppSpacing.xs,
              AppSpacing.s,
            ),
            child: Row(
              spacing: AppSpacing.sm,
              children: [
                PartnerAvatar(
                  name: partner.name,
                  imagePath: iconPath,
                  size: 40,
                  toneIndex: partner.id,
                ),
                Expanded(
                  child: Semantics(
                    selected: selected,
                    button: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: AppSpacing.xxs,
                      children: [
                        Text(
                          group == null || group.isEmpty
                              ? partner.name
                              : '${partner.name} · $group',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          subtitle,
                          style: AppTypography.numeric(
                            fontSize: 12,
                            color: palette.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Icon(
                  selected ? Icons.check_circle : Icons.circle_outlined,
                  color: selected ? palette.cheki.ink : palette.border,
                ),
                IconButton(
                  tooltip: t.partner.edit(name: partner.name),
                  onPressed: onEdit,
                  icon: Icon(
                    Icons.edit_outlined,
                    size: 20,
                    color: palette.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
