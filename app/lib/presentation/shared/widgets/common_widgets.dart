import 'dart:io';

import 'package:app/presentation/shared/keys/app_keys.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// 角丸の面。画面の区切りに使う。
class SurfaceCard extends StatelessWidget {
  /// [padding] の内側に [child] を置く。
  const SurfaceCard({
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.m),
    this.radius = AppRadius.l,
    this.color,
    this.border,
    super.key,
  });

  /// 中身。
  final Widget child;

  /// 内側の余白。
  final EdgeInsetsGeometry padding;

  /// 角丸。
  final double radius;

  /// 面の色。省略時は surface。
  final Color? color;

  /// 枠線。四辺を同じ線で引く [Border.all] だけに対応する。
  final Border? border;

  @override
  Widget build(BuildContext context) {
    final side = switch (border) {
      final Border border => border.top,
      _ => BorderSide.none,
    };
    // Material にすることで、中の InkWell の波紋が面の上に描かれる。
    return Material(
      color: color ?? context.palette.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side: side,
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}

/// 小さなラベル（Gmail・二重計上・段階）。
class TagChip extends StatelessWidget {
  /// [background] の上に [label] を置く。
  const TagChip({
    required this.label,
    required this.foreground,
    required this.background,
    super.key,
  });

  /// 表示する文字。
  final String label;

  /// 文字の色。
  final Color foreground;

  /// 背景の色。
  final Color background;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(AppRadius.xs + 2),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: foreground,
        ),
      ),
    ),
  );
}

/// セクションの見出し。
class SectionHeader extends StatelessWidget {
  /// [title] と、右端の補足 [trailing]。
  const SectionHeader({required this.title, this.trailing, super.key});

  /// 見出し。
  final String title;

  /// 右端の補足。
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Semantics(
            header: true,
            child: Text(
              title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        ?trailing,
      ],
    ),
  );
}

/// チェキ相手のアイコン。画像がなければ名前の頭文字を出す。
class PartnerAvatar extends StatelessWidget {
  /// [imagePath] があれば丸く切り抜いて表示する。
  const PartnerAvatar({
    required this.name,
    this.imagePath,
    this.size = 36,
    this.toneIndex = 0,
    super.key,
  });

  /// 名前。
  final String name;

  /// 画像の絶対パス。
  final String? imagePath;

  /// 直径。
  final double size;

  /// 頭文字の背景色を選ぶ番号。
  final int toneIndex;

  @override
  Widget build(BuildContext context) {
    final path = imagePath;
    if (path != null) {
      return ClipOval(
        child: Image.file(
          File(path),
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, _, _) => _initial(context),
        ),
      );
    }
    return _initial(context);
  }

  Widget _initial(BuildContext context) {
    final palette = context.palette;
    final tones = [palette.cheki, palette.ticket, palette.drink];
    final tone = tones[toneIndex % tones.length];
    return ExcludeSemantics(
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: tone.soft, shape: BoxShape.circle),
        child: Text(
          name.isEmpty ? '?' : name.characters.first,
          style: TextStyle(
            fontSize: size * 0.4,
            fontWeight: FontWeight.w700,
            color: tone.ink,
          ),
        ),
      ),
    );
  }
}

/// 2つ以上の選択肢を切り替えるセグメント。
class SegmentToggle<T> extends StatelessWidget {
  /// [options] の中から [value] を選んでいる状態を表示する。
  const SegmentToggle({
    required this.value,
    required this.options,
    required this.onChanged,
    this.semanticLabel,
    super.key,
  });

  /// 選択中の値。
  final T value;

  /// 値と表示名。
  final Map<T, String> options;

  /// 選択を変える。
  final ValueChanged<T> onChanged;

  /// 読み上げのラベル。
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Semantics(
      label: semanticLabel,
      container: true,
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: palette.segmentTrack,
          borderRadius: BorderRadius.circular(AppRadius.m),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final option in options.entries)
              _Segment(
                key: AppKeys.segment(option.key),
                label: option.value,
                selected: option.key == value,
                onTap: () => onChanged(option.key),
              ),
          ],
        ),
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: selected ? palette.surface : Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.s + 1),
        elevation: selected ? 1 : 0,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.s + 1),
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 38),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              child: Center(
                widthFactor: 1,
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: selected
                        ? palette.textPrimary
                        : palette.textSecondary,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 全幅のボタンの下に安全領域の余白を取った操作帯。
class BottomActionBar extends StatelessWidget {
  /// [child] を画面下に置く。
  const BottomActionBar({required this.child, super.key});

  /// ボタン。
  final Widget child;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: context.palette.surface,
      border: Border(top: BorderSide(color: context.palette.divider)),
    ),
    child: SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(
        AppSpacing.m,
        AppSpacing.sm,
        AppSpacing.m,
        AppSpacing.m,
      ),
      child: child,
    ),
  );
}
