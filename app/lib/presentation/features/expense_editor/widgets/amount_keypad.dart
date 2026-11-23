import 'package:app/core/gen/slang.g.dart';
import 'package:app/presentation/shared/keys/app_keys.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// 金額を入れる 3×4 の数字キー。
class AmountKeypad extends StatelessWidget {
  /// [onDigits] に押したキーの数字を、[onBackspace] に1文字消す操作を渡す。
  const AmountKeypad({
    required this.onDigits,
    required this.onBackspace,
    super.key,
  });

  /// 数字を足す。
  final ValueChanged<String> onDigits;

  /// 1文字消す。
  final VoidCallback onBackspace;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    const keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '00', '0'];
    final rows = <List<Widget>>[];
    final buttons = [
      for (final key in keys)
        _Key(
          key: AppKeys.keypad(key),
          onPressed: () => onDigits(key),
          child: Text(key),
        ),
      _Key(
        key: AppKeys.keypadBackspace,
        semanticLabel: t.expense.deleteKey,
        onPressed: onBackspace,
        child: const Icon(Icons.backspace_outlined, size: 22),
      ),
    ];
    for (var i = 0; i < buttons.length; i += 3) {
      rows.add(buttons.sublist(i, i + 3));
    }
    return Semantics(
      label: t.expense.keypad,
      container: true,
      child: Column(
        spacing: 6,
        children: [
          for (final row in rows)
            Row(
              spacing: 6,
              children: [for (final button in row) Expanded(child: button)],
            ),
        ],
      ),
    );
  }
}

class _Key extends StatelessWidget {
  const _Key({
    required this.onPressed,
    required this.child,
    this.semanticLabel,
    super.key,
  });

  final VoidCallback onPressed;
  final Widget child;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Semantics(
      label: semanticLabel,
      button: true,
      child: Material(
        color: palette.surface,
        borderRadius: BorderRadius.circular(AppRadius.m),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.m),
          onTap: onPressed,
          child: SizedBox(
            height: 48,
            child: Center(
              child: DefaultTextStyle.merge(
                style: AppTypography.numeric(
                  fontSize: 20,
                  color: palette.textPrimary,
                ),
                child: IconTheme.merge(
                  data: IconThemeData(color: palette.textPrimary),
                  child: FittedBox(fit: BoxFit.scaleDown, child: child),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
