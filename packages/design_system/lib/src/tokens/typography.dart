import 'package:flutter/painting.dart';

/// 文字のトークン。日本語は端末の標準フォント、数字は Space Grotesk。
abstract final class AppTypography {
  /// 同梱する数字用フォントの family。
  static const String numericFamily = 'SpaceGrotesk';

  /// 金額や日付に使う等幅数字のスタイル。
  ///
  /// 可変フォントのため、太さは [FontVariation] でも指定する。
  static TextStyle numeric({
    double? fontSize,
    FontWeight fontWeight = FontWeight.w500,
    Color? color,
    double? height,
  }) => TextStyle(
    fontFamily: numericFamily,
    package: 'design_system',
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    height: height,
    fontFeatures: const [FontFeature.tabularFigures()],
    fontVariations: [FontVariation.weight(fontWeight.value.toDouble())],
  );
}
