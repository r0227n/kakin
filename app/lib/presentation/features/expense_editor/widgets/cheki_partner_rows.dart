import 'package:app/application/application.dart';
import 'package:app/core/formatting/kakin_formats.dart';
import 'package:app/core/gen/slang.g.dart';
import 'package:app/presentation/shared/keys/app_keys.dart';
import 'package:app/presentation/shared/widgets/common_widgets.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// チェキ代の相手1人分の入力。
typedef ChekiEntry = ({Partner partner, String? iconPath, int count});

/// チェキ相手ごとの撮影枚数。0枚にすると外す。
class ChekiPartnerRows extends StatelessWidget {
  /// [unitPriceYen] は1枚あたりの金額。
  const ChekiPartnerRows({
    required this.entries,
    required this.unitPriceYen,
    required this.onPick,
    required this.onCountChanged,
    super.key,
  });

  /// 選んだ相手と枚数。
  final List<ChekiEntry> entries;

  /// 1枚あたりの金額。
  final int unitPriceYen;

  /// 相手を選び直す。
  final VoidCallback onPick;

  /// 枚数を変える。
  final void Function(int partnerId, int count) onCountChanged;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final palette = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.s,
      children: [
        Row(
          children: [
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: '${t.expense.partners} '),
                    TextSpan(
                      text: t.format.people(count: entries.length),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: palette.textSecondary,
                      ),
                    ),
                  ],
                ),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            TextButton.icon(
              key: AppKeys.pickPartners,
              style: TextButton.styleFrom(
                backgroundColor: palette.cheki.soft,
                foregroundColor: palette.cheki.ink,
                minimumSize: const Size(0, 36),
                shape: const StadiumBorder(),
                textStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              onPressed: onPick,
              icon: const Icon(Icons.person_add_alt, size: 16),
              label: Text(t.expense.pickPartners),
            ),
          ],
        ),
        if (entries.isEmpty)
          Material(
            color: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.l - 2),
              side: BorderSide(color: palette.cheki.chart, width: 1.5),
            ),
            child: InkWell(
              key: AppKeys.pickPartnersEmpty,
              borderRadius: BorderRadius.circular(AppRadius.l - 2),
              onTap: onPick,
              child: SizedBox(
                height: 56,
                child: Center(
                  child: Text(
                    t.expense.noPartners,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: palette.cheki.ink,
                    ),
                  ),
                ),
              ),
            ),
          ),
        for (final (index, entry) in entries.indexed)
          _PartnerRow(
            entry: entry,
            toneIndex: index,
            amount: KakinFormats.yen(unitPriceYen * entry.count),
            onChanged: (count) => onCountChanged(entry.partner.id, count),
          ),
      ],
    );
  }
}

class _PartnerRow extends StatelessWidget {
  const _PartnerRow({
    required this.entry,
    required this.toneIndex,
    required this.amount,
    required this.onChanged,
  });

  final ChekiEntry entry;
  final int toneIndex;
  final String amount;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final palette = context.palette;
    final partner = entry.partner;
    final group = partner.groupName;
    return Container(
      key: AppKeys.chekiRow(partner.id),
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: palette.divider)),
      ),
      child: Row(
        spacing: AppSpacing.s + 2,
        children: [
          PartnerAvatar(
            name: partner.name,
            imagePath: entry.iconPath,
            toneIndex: toneIndex,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  partner.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  group == null || group.isEmpty
                      ? amount
                      : t.expense.partnerSub(group: group, amount: amount),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.numeric(
                    fontSize: 11,
                    color: palette.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              color: palette.surfaceMuted,
              borderRadius: BorderRadius.circular(AppRadius.m),
            ),
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _StepButton(
                    key: AppKeys.chekiDecrease(partner.id),
                    label: '−',
                    semanticLabel: t.expense.decrease(name: partner.name),
                    onPressed: () => onChanged(entry.count - 1),
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 34),
                    child: Semantics(
                      liveRegion: true,
                      child: Text(
                        t.format.shots(count: entry.count),
                        key: AppKeys.chekiCount(partner.id),
                        textAlign: TextAlign.center,
                        style: AppTypography.numeric(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  _StepButton(
                    key: AppKeys.chekiIncrease(partner.id),
                    label: '＋',
                    semanticLabel: t.expense.increase(name: partner.name),
                    onPressed: entry.count >= 99
                        ? null
                        : () => onChanged(entry.count + 1),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.label,
    required this.semanticLabel,
    required this.onPressed,
    super.key,
  });

  final String label;
  final String semanticLabel;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => Semantics(
    label: semanticLabel,
    button: true,
    excludeSemantics: true,
    child: InkWell(
      borderRadius: BorderRadius.circular(AppRadius.s + 2),
      onTap: onPressed,
      child: SizedBox(
        width: 40,
        height: 44,
        child: Center(
          child: Text(label, style: const TextStyle(fontSize: 18)),
        ),
      ),
    ),
  );
}
