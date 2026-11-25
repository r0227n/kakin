import 'package:design_system/src/tokens/colors.dart';
import 'package:flutter/material.dart';

/// 配色のトークンを Theme から参照する extension。
///
/// 明暗の切り替えは段階的な補間をせず、途中で入れ替える。
class AppPaletteTheme extends ThemeExtension<AppPaletteTheme> {
  /// [tokens] の配色を公開する。
  const AppPaletteTheme(this.tokens);

  /// 配色。
  final AppPaletteTokens tokens;

  @override
  AppPaletteTheme copyWith({AppPaletteTokens? tokens}) =>
      AppPaletteTheme(tokens ?? this.tokens);

  @override
  AppPaletteTheme lerp(ThemeExtension<AppPaletteTheme>? other, double t) =>
      other is AppPaletteTheme && t >= 0.5 ? other : this;
}

/// [BuildContext] から配色を参照する。
extension AppPaletteBuildContext on BuildContext {
  /// 現在のテーマの配色。
  AppPaletteTokens get palette =>
      Theme.of(this).extension<AppPaletteTheme>()!.tokens;
}
