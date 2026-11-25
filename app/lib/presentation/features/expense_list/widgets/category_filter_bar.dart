import 'package:app/core/formatting/kakin_formats.dart';
import 'package:app/core/gen/slang.g.dart';
import 'package:app/domain/domain.dart';
import 'package:app/presentation/shared/keys/app_keys.dart';
import 'package:app/presentation/shared/widgets/visuals.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// カテゴリの絞り込み。横にスクロールする。
class CategoryFilterBar extends StatelessWidget {
  /// [selected] が null なら「すべて」。
  const CategoryFilterBar({
    required this.selected,
    required this.totals,
    required this.hidden,
    required this.onSelected,
    super.key,
  });

  /// 選んでいるカテゴリ。
  final ExpenseCategory? selected;

  /// カテゴリ別の合計。
  final Map<ExpenseCategory, int> totals;

  /// 金額を隠すか。
  final bool hidden;

  /// 絞り込みを変える。
  final ValueChanged<ExpenseCategory?> onSelected;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    return Semantics(
      label: t.list.filterLabel,
      container: true,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
        child: Row(
          spacing: 6,
          children: [
            _FilterChip(
              key: AppKeys.filterAll,
              label: t.list.all,
              selected: selected == null,
              onTap: () => onSelected(null),
            ),
            for (final category in ExpenseCategory.values)
              _FilterChip(
                key: AppKeys.filter(category),
                label: category.label(t),
                icon: category.icon,
                tone: category.tone(context.palette).ink,
                amount: hidden
                    ? null
                    : KakinFormats.number(totals[category] ?? 0),
                selected: selected == category,
                onTap: () => onSelected(category),
              ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
    this.tone,
    this.amount,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;
  final Color? tone;
  final String? amount;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final foreground = selected
        ? palette.onInverseSurface
        : palette.textPrimary;
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: selected ? palette.inverseSurface : palette.surface,
        shape: StadiumBorder(
          side: BorderSide(
            color: selected ? palette.inverseSurface : palette.border,
            width: 1.5,
          ),
        ),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 40),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 6,
                children: [
                  if (icon != null)
                    Icon(icon, size: 16, color: selected ? foreground : tone),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      color: foreground,
                    ),
                  ),
                  if (amount != null)
                    Text(
                      amount!,
                      style: AppTypography.numeric(
                        fontSize: 12,
                        color: foreground.withValues(alpha: 0.8),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
