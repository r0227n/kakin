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

/// 暦日を書式関数に渡す DateTime へ変換する。
extension LocalDateDisplay on LocalDate {
  /// 年月日だけを持つ UTC の DateTime。
  DateTime get asDateTime => DateTime.utc(year, month, day);
}
