import 'package:app/core/gen/slang.g.dart';
import 'package:app/domain/domain.dart';
import 'package:app/presentation/shared/keys/app_keys.dart';
import 'package:app/presentation/shared/widgets/visuals.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// 5つの申込段階の選択。
class StageSelector extends StatelessWidget {
  /// [value] を塗って示す。
  const StageSelector({
    required this.value,
    required this.onChanged,
    super.key,
  });

  /// 選んでいる段階。
  final TicketApplicationStage value;

  /// 段階を変える。
  final ValueChanged<TicketApplicationStage> onChanged;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final palette = context.palette;
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth < 340 ? 2 : 3;
        final width =
            (constraints.maxWidth - AppSpacing.s * (columns - 1)) / columns;
        return Wrap(
          spacing: AppSpacing.s,
          runSpacing: AppSpacing.s,
          children: [
            for (final (index, stage) in TicketApplicationStage.values.indexed)
              SizedBox(
                width: width,
                child: Semantics(
                  button: true,
                  selected: stage == value,
                  label: stage.label(t),
                  excludeSemantics: true,
                  child: Material(
                    key: AppKeys.stage(stage),
                    color: stage == value
                        ? stage.tone(palette).soft
                        : palette.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.m),
                      side: BorderSide(
                        color: stage == value
                            ? stage.tone(palette).ink
                            : palette.border,
                        width: 1.5,
                      ),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(AppRadius.m),
                      onTap: () => onChanged(stage),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minHeight: 48),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.s + 2,
                            vertical: AppSpacing.s,
                          ),
                          child: Row(
                            spacing: 6,
                            children: [
                              Text(
                                '${index + 1}',
                                style: AppTypography.numeric(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: palette.textSecondary,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  stage.label(t),
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: stage == value
                                        ? stage.tone(palette).ink
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
        );
      },
    );
  }
}
