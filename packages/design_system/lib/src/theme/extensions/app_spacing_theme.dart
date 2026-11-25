import 'package:design_system/src/tokens/spacing.dart';
import 'package:flutter/material.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'app_spacing_theme.g.theme.dart';

/// Theme extension for spacing design tokens.
///
/// Provides spacing values through the Flutter theme system.
/// Default values are sourced from [AppSpacing] static constants.
@ThemeExtensions(contextAccessorName: 'appSpacing')
class AppSpacingTheme extends ThemeExtension<AppSpacingTheme>
    with _$AppSpacingTheme {
  /// Creates an [AppSpacingTheme] with the given spacing values.
  const AppSpacingTheme({
    this.xxs = AppSpacing.xxs,
    this.xs = AppSpacing.xs,
    this.s = AppSpacing.s,
    this.sm = AppSpacing.sm,
    this.m = AppSpacing.m,
    this.ml = AppSpacing.ml,
    this.l = AppSpacing.l,
    this.xl = AppSpacing.xl,
  });

  /// Hairline spacing.
  final double xxs;

  /// Extra small spacing.
  final double xs;

  /// Small spacing.
  final double s;

  /// Small-medium spacing.
  final double sm;

  /// Medium spacing.
  final double m;

  /// Medium-large spacing.
  final double ml;

  /// Large spacing.
  final double l;

  /// Extra large spacing.
  final double xl;
}
