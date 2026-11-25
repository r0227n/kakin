import 'package:app/core/gen/slang.g.dart';
import 'package:app/domain/domain.dart';
import 'package:app/presentation/shared/keys/app_keys.dart';
import 'package:app/presentation/shared/widgets/visuals.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// 7つのカテゴリを1行に並べた選択。
class CategoryGrid extends StatelessWidget {
  /// [selected] を塗って示す。
  const CategoryGrid({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  /// 選んでいるカテゴリ。
  final ExpenseCategory selected;

  /// カテゴリを選ぶ。
  final ValueChanged<ExpenseCategory> onSelected;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final palette = context.palette;
    return Semantics(
      label: t.expense.categoryGroup,
      container: true,
      child: Row(
        spacing: AppSpacing.xs,
        children: [
          for (final category in ExpenseCategory.values)
            Expanded(
              child: Semantics(
                button: true,
                selected: category == selected,
                label: category.label(t),
                excludeSemantics: true,
                child: Material(
                  key: AppKeys.category(category),
                  color: category == selected
                      ? category.tone(palette).ink
                      : palette.surface,
                  borderRadius: BorderRadius.circular(AppRadius.m),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppRadius.m),
                    onTap: () => onSelected(category),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 60),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 2,
                          vertical: AppSpacing.s,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: AppSpacing.xs,
                          children: [
                            Icon(
                              category.icon,
                              size: 22,
                              color: category == selected
                                  ? palette.onAccent
                                  : category.tone(palette).ink,
                            ),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                category.shortLabel(t),
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: category == selected
                                      ? palette.onAccent
                                      : palette.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
