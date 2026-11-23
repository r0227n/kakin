import 'package:app/core/gen/slang.g.dart';
import 'package:app/domain/domain.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// カテゴリの表示名・色・アイコン。
extension CategoryVisuals on ExpenseCategory {
  /// 正式な表示名。
  String label(Translations t) => switch (this) {
    ExpenseCategory.ticket => t.category.ticket,
    ExpenseCategory.drink => t.category.drink,
    ExpenseCategory.cheki => t.category.cheki,
    ExpenseCategory.goods => t.category.goods,
    ExpenseCategory.transport => t.category.transport,
    ExpenseCategory.locker => t.category.locker,
    ExpenseCategory.other => t.category.other,
  };

  /// 狭い場所の表示名。
  String shortLabel(Translations t) => switch (this) {
    ExpenseCategory.ticket => t.categoryShort.ticket,
    ExpenseCategory.drink => t.categoryShort.drink,
    ExpenseCategory.cheki => t.categoryShort.cheki,
    ExpenseCategory.goods => t.categoryShort.goods,
    ExpenseCategory.transport => t.categoryShort.transport,
    ExpenseCategory.locker => t.categoryShort.locker,
    ExpenseCategory.other => t.categoryShort.other,
  };

  /// 配色。
  AppTone tone(AppPaletteTokens palette) => switch (this) {
    ExpenseCategory.ticket => palette.ticket,
    ExpenseCategory.drink => palette.drink,
    ExpenseCategory.cheki => palette.cheki,
    ExpenseCategory.goods => palette.goods,
    ExpenseCategory.transport => palette.transport,
    ExpenseCategory.locker => palette.locker,
    ExpenseCategory.other => palette.other,
  };

  /// アイコン。
  IconData get icon => switch (this) {
    ExpenseCategory.ticket => Icons.confirmation_number_outlined,
    ExpenseCategory.drink => Icons.local_drink_outlined,
    ExpenseCategory.cheki => Icons.photo_outlined,
    ExpenseCategory.goods => Icons.shopping_bag_outlined,
    ExpenseCategory.transport => Icons.train_outlined,
    ExpenseCategory.locker => Icons.lock_outline,
    ExpenseCategory.other => Icons.more_horiz,
  };
}

/// 申込段階の表示名と色。
extension StageVisuals on TicketApplicationStage {
  /// 表示名。
  String label(Translations t) => switch (this) {
    TicketApplicationStage.planned => t.stage.planned,
    TicketApplicationStage.awaitingResult => t.stage.awaitingResult,
    TicketApplicationStage.awaitingPayment => t.stage.awaitingPayment,
    TicketApplicationStage.secured => t.stage.secured,
    TicketApplicationStage.lost => t.stage.lost,
  };

  /// 配色。
  AppTone tone(AppPaletteTokens palette) => switch (this) {
    TicketApplicationStage.planned ||
    TicketApplicationStage.lost => palette.neutralTone,
    TicketApplicationStage.awaitingResult => palette.amberTone,
    TicketApplicationStage.awaitingPayment => palette.roseTone,
    TicketApplicationStage.secured => palette.tealTone,
  };
}

/// 期限の種類の表示名・色・アイコン。
extension DeadlineVisuals on TicketDeadlineKind {
  /// 表示名。
  String label(Translations t) => switch (this) {
    TicketDeadlineKind.apply => t.deadline.apply,
    TicketDeadlineKind.result => t.deadline.result,
    TicketDeadlineKind.payment => t.deadline.payment,
  };

  /// やることの短い表示名。
  String shortLabel(Translations t) => switch (this) {
    TicketDeadlineKind.apply => t.deadline.apply,
    TicketDeadlineKind.result => t.deadline.resultShort,
    TicketDeadlineKind.payment => t.deadline.payment,
  };

  /// 配色。
  AppTone tone(AppPaletteTokens palette) => switch (this) {
    TicketDeadlineKind.apply => palette.neutralTone,
    TicketDeadlineKind.result => palette.amberTone,
    TicketDeadlineKind.payment => palette.roseTone,
  };

  /// アイコン。
  IconData get icon => switch (this) {
    TicketDeadlineKind.apply => Icons.description_outlined,
    TicketDeadlineKind.result => Icons.star_outline,
    TicketDeadlineKind.payment => Icons.credit_card_outlined,
  };
}

/// ワンタップの段階更新の表示名。
extension QuickActionVisuals on QuickStageAction {
  /// ボタンの表示名。
  String label(Translations t) => switch (this) {
    QuickStageAction.applied => t.quickAction.applied,
    QuickStageAction.won => t.quickAction.won,
    QuickStageAction.lost => t.quickAction.lost,
    QuickStageAction.paid => t.quickAction.paid,
  };
}

/// チケットサービスの表示名。
extension ServiceVisuals on TicketServiceKind {
  /// 表示名。
  String label(Translations t) => switch (this) {
    TicketServiceKind.eplus => t.service.eplus,
    TicketServiceKind.livepocket => t.service.livepocket,
    TicketServiceKind.other => t.service.other,
  };
}

/// 暦日を書式関数に渡す DateTime へ変換する。
extension LocalDateDisplay on LocalDate {
  /// 年月日だけを持つ UTC の DateTime。
  DateTime get asDateTime => DateTime.utc(year, month, day);
}
