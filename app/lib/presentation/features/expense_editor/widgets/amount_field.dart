import 'package:app/presentation/shared/keys/app_keys.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 画面の数字キーで入れる金額の欄。
///
/// 画面を開いたときと、タップしたときにフォーカスを受け取り、
/// 入力中の欄として枠とカーソルを表示する。
/// メモなど他の欄から戻ると、端末のキーボードを閉じる。
/// フォーカス中は外付けキーボードの数字と Backspace も受け付ける。
class AmountField extends StatefulWidget {
  /// [text] を表示し、[focusNode] で入力中かを管理する。
  const AmountField({
    required this.text,
    required this.isEmpty,
    required this.fontSize,
    required this.label,
    required this.focusNode,
    required this.onDigits,
    required this.onBackspace,
    super.key,
  });

  /// 表示する金額。
  final String text;

  /// 未入力か。未入力のときは薄い色で表示する。
  final bool isEmpty;

  /// 金額の文字の大きさ。
  final double fontSize;

  /// 読み上げのラベル。
  final String label;

  /// この欄のフォーカス。所有と破棄は呼び出し元が行う。
  final FocusNode focusNode;

  /// 数字を足す。
  final ValueChanged<String> onDigits;

  /// 1文字消す。
  final VoidCallback onBackspace;

  @override
  State<AmountField> createState() => _AmountFieldState();
}

class _AmountFieldState extends State<AmountField> {
  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocusChanged);
  }

  @override
  void didUpdateWidget(AmountField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      oldWidget.focusNode.removeListener(_onFocusChanged);
      widget.focusNode.addListener(_onFocusChanged);
      _onFocusChanged();
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChanged);
    super.dispose();
  }

  void _onFocusChanged() {
    if (mounted) setState(() {});
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is KeyUpEvent) return KeyEventResult.ignored;
    if (event.logicalKey == LogicalKeyboardKey.backspace) {
      widget.onBackspace();
      return KeyEventResult.handled;
    }
    final character = event.character;
    if (character != null && RegExp(r'^\d$').hasMatch(character)) {
      widget.onDigits(character);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final focused = widget.focusNode.hasFocus;
    final style = AppTypography.numeric(
      fontSize: widget.fontSize,
      fontWeight: FontWeight.w700,
      color: widget.isEmpty ? palette.textDisabled : null,
      height: 1.1,
    );
    return Semantics(
      textField: true,
      focused: focused,
      label: widget.label,
      value: widget.text,
      liveRegion: true,
      onTap: widget.focusNode.requestFocus,
      excludeSemantics: true,
      child: Focus(
        focusNode: widget.focusNode,
        autofocus: true,
        onKeyEvent: _onKey,
        child: GestureDetector(
          key: AppKeys.expenseAmountField,
          behavior: HitTestBehavior.opaque,
          onTap: widget.focusNode.requestFocus,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.s,
            ),
            decoration: BoxDecoration(
              color: focused ? palette.accentSoft : palette.surfaceMuted,
              borderRadius: BorderRadius.circular(AppRadius.m),
              border: Border.all(
                color: focused ? palette.accent : Colors.transparent,
                width: 2,
              ),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(widget.text, key: AppKeys.expenseAmount, style: style),
                  // 点滅させると画面が落ち着かず、テストの待機も終わらないため固定で出す。
                  Container(
                    width: 2,
                    height: widget.fontSize,
                    margin: const EdgeInsets.only(left: AppSpacing.xxs),
                    color: focused ? palette.accent : Colors.transparent,
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
