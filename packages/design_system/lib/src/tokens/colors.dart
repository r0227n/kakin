import 'package:flutter/material.dart';

/// 1つの色相の濃淡。文字・グラフ・背景で使い分ける。
@immutable
final class AppTone {
  /// [ink] は [soft] の上の文字、[chart] はグラフや印の色。
  const AppTone({required this.ink, required this.chart, required this.soft});

  /// [soft] の上に置く文字やアイコンの色。
  final Color ink;

  /// グラフや小さな印の色。
  final Color chart;

  /// 選択中のチップなどの背景の色。
  final Color soft;

  @override
  bool operator ==(Object other) =>
      other is AppTone &&
      other.ink == ink &&
      other.chart == chart &&
      other.soft == soft;

  @override
  int get hashCode => Object.hash(ink, chart, soft);
}

/// 配色のトークン。明暗それぞれの値を持つ。
@immutable
final class AppPaletteTokens {
  /// すべての色を指定する。
  const AppPaletteTokens({
    required this.background,
    required this.surface,
    required this.surfaceMuted,
    required this.segmentTrack,
    required this.border,
    required this.divider,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textDisabled,
    required this.accent,
    required this.accentStrong,
    required this.accentSoft,
    required this.accentInk,
    required this.onAccent,
    required this.inverseSurface,
    required this.onInverseSurface,
    required this.inverseAccent,
    required this.negative,
    required this.warning,
    required this.warningSoft,
    required this.warningBorder,
    required this.warningInk,
    required this.ticket,
    required this.drink,
    required this.cheki,
    required this.goods,
    required this.transport,
    required this.locker,
    required this.other,
    required this.neutralTone,
    required this.amberTone,
    required this.roseTone,
    required this.tealTone,
  });

  /// 画面の背景。
  final Color background;

  /// カードやシートの面。
  final Color surface;

  /// 面の上の控えめな背景（チップ・ステッパー）。
  final Color surfaceMuted;

  /// セグメント切り替えの溝。
  final Color segmentTrack;

  /// 入力欄やボタンの枠線。
  final Color border;

  /// 行の区切り線。
  final Color divider;

  /// 本文の文字。
  final Color textPrimary;

  /// 補足の文字。
  final Color textSecondary;

  /// 見出しなどの控えめな文字。
  final Color textTertiary;

  /// 未入力の金額などの文字。
  final Color textDisabled;

  /// 主要な操作の色。
  final Color accent;

  /// 面の上に置くアクセントの文字。
  final Color accentStrong;

  /// アクセントの淡い背景。
  final Color accentSoft;

  /// [accentSoft] の上の文字。
  final Color accentInk;

  /// [accent] の上の文字。
  final Color onAccent;

  /// 元に戻すなどの反転した帯。
  final Color inverseSurface;

  /// [inverseSurface] の上の文字。
  final Color onInverseSurface;

  /// [inverseSurface] の上の操作の文字。
  final Color inverseAccent;

  /// マイナスの残高。
  final Color negative;

  /// 期限切れなどの警告の文字。
  final Color warning;

  /// 警告の淡い背景。
  final Color warningSoft;

  /// 警告の枠線。
  final Color warningBorder;

  /// [warningSoft] の上の文字。
  final Color warningInk;

  /// チケット代。
  final AppTone ticket;

  /// ドリンク代。
  final AppTone drink;

  /// チェキ代。
  final AppTone cheki;

  /// グッズ代。
  final AppTone goods;

  /// 交通費。
  final AppTone transport;

  /// コインロッカー代。
  final AppTone locker;

  /// その他。
  final AppTone other;

  /// 中立の状態（申込予定・落選）。
  final AppTone neutralTone;

  /// 待ちの状態（結果待ち）。
  final AppTone amberTone;

  /// 急ぎの状態（入金待ち）。
  final AppTone roseTone;

  /// 完了の状態（確保済み）。
  final AppTone tealTone;

  /// ライトの配色。
  static const light = AppPaletteTokens(
    background: Color(0xFFF6F5F1),
    surface: Color(0xFFFFFFFF),
    surfaceMuted: Color(0xFFF3F1EC),
    segmentTrack: Color(0xFFE9E7E1),
    border: Color(0xFFDAD8D1),
    divider: Color(0xFFEFEDE8),
    textPrimary: Color(0xFF1C1B1F),
    textSecondary: Color(0xFF5E5D66),
    textTertiary: Color(0xFF4D4C55),
    textDisabled: Color(0xFFB5B3AC),
    accent: Color(0xFF5B4BDB),
    accentStrong: Color(0xFF4335B8),
    accentSoft: Color(0xFFEFEDFC),
    accentInk: Color(0xFF2E2491),
    onAccent: Color(0xFFFFFFFF),
    inverseSurface: Color(0xFF1C1B1F),
    onInverseSurface: Color(0xFFFFFFFF),
    inverseAccent: Color(0xFFC9C2FF),
    negative: Color(0xFFC2410C),
    warning: Color(0xFF9A3412),
    warningSoft: Color(0xFFFDEBDD),
    warningBorder: Color(0xFFF3B68C),
    warningInk: Color(0xFF7C2D12),
    ticket: AppTone(
      ink: Color(0xFF5B4BDB),
      chart: Color(0xFF5B4BDB),
      soft: Color(0xFFEFEDFC),
    ),
    drink: AppTone(
      ink: Color(0xFF0A7470),
      chart: Color(0xFF0E9F9A),
      soft: Color(0xFFE1F4F3),
    ),
    cheki: AppTone(
      ink: Color(0xFFB83372),
      chart: Color(0xFFD9468A),
      soft: Color(0xFFFBE6F0),
    ),
    goods: AppTone(
      ink: Color(0xFF96570B),
      chart: Color(0xFFE8962E),
      soft: Color(0xFFFCEFDC),
    ),
    transport: AppTone(
      ink: Color(0xFF46627F),
      chart: Color(0xFF5F7FA0),
      soft: Color(0xFFE6ECF2),
    ),
    locker: AppTone(
      ink: Color(0xFF397034),
      chart: Color(0xFF4F9A49),
      soft: Color(0xFFE4F1E1),
    ),
    other: AppTone(
      ink: Color(0xFF5E5B53),
      chart: Color(0xFFA9A59C),
      soft: Color(0xFFEFEEEA),
    ),
    neutralTone: AppTone(
      ink: Color(0xFF4D4C55),
      chart: Color(0xFF8E8C95),
      soft: Color(0xFFF0EFEB),
    ),
    amberTone: AppTone(
      ink: Color(0xFF8A4B00),
      chart: Color(0xFFE8962E),
      soft: Color(0xFFFCEFDC),
    ),
    roseTone: AppTone(
      ink: Color(0xFF8F2459),
      chart: Color(0xFFD9468A),
      soft: Color(0xFFFBE6F0),
    ),
    tealTone: AppTone(
      ink: Color(0xFF0B6E6A),
      chart: Color(0xFF0E9F9A),
      soft: Color(0xFFE1F4F3),
    ),
  );

  /// ダークの配色。ライトの色相を保ち、明度を調整する。
  static const dark = AppPaletteTokens(
    background: Color(0xFF121116),
    surface: Color(0xFF1C1B21),
    surfaceMuted: Color(0xFF26252C),
    segmentTrack: Color(0xFF2C2B32),
    border: Color(0xFF3A3941),
    divider: Color(0xFF2A2930),
    textPrimary: Color(0xFFEDECF2),
    textSecondary: Color(0xFFA9A7B3),
    textTertiary: Color(0xFFC4C2CC),
    textDisabled: Color(0xFF6B6973),
    accent: Color(0xFF6A5AE0),
    accentStrong: Color(0xFFB3AAFF),
    accentSoft: Color(0xFF2A2550),
    accentInk: Color(0xFFCFC8FF),
    onAccent: Color(0xFFFFFFFF),
    inverseSurface: Color(0xFFEDECF2),
    onInverseSurface: Color(0xFF1C1B1F),
    inverseAccent: Color(0xFF4335B8),
    negative: Color(0xFFFF8A5C),
    warning: Color(0xFFFF9E70),
    warningSoft: Color(0xFF3A2218),
    warningBorder: Color(0xFF7A3B1E),
    warningInk: Color(0xFFFFC7A8),
    ticket: AppTone(
      ink: Color(0xFFB3AAFF),
      chart: Color(0xFF8C7FF0),
      soft: Color(0xFF2A2550),
    ),
    drink: AppTone(
      ink: Color(0xFF6FD6D1),
      chart: Color(0xFF2BB8B2),
      soft: Color(0xFF12302F),
    ),
    cheki: AppTone(
      ink: Color(0xFFF59AC4),
      chart: Color(0xFFE05C9C),
      soft: Color(0xFF3A1A2A),
    ),
    goods: AppTone(
      ink: Color(0xFFF2B66B),
      chart: Color(0xFFE8962E),
      soft: Color(0xFF3A2A14),
    ),
    transport: AppTone(
      ink: Color(0xFFA9C1DA),
      chart: Color(0xFF7E9CBC),
      soft: Color(0xFF1F2A36),
    ),
    locker: AppTone(
      ink: Color(0xFF8FD08A),
      chart: Color(0xFF5FB259),
      soft: Color(0xFF1B2E1A),
    ),
    other: AppTone(
      ink: Color(0xFFC9C5BC),
      chart: Color(0xFF8F8B83),
      soft: Color(0xFF2B2A27),
    ),
    neutralTone: AppTone(
      ink: Color(0xFFC4C2CC),
      chart: Color(0xFF8E8C95),
      soft: Color(0xFF26252C),
    ),
    amberTone: AppTone(
      ink: Color(0xFFF2B66B),
      chart: Color(0xFFE8962E),
      soft: Color(0xFF3A2A14),
    ),
    roseTone: AppTone(
      ink: Color(0xFFF59AC4),
      chart: Color(0xFFE05C9C),
      soft: Color(0xFF3A1A2A),
    ),
    tealTone: AppTone(
      ink: Color(0xFF6FD6D1),
      chart: Color(0xFF2BB8B2),
      soft: Color(0xFF12302F),
    ),
  );
}
