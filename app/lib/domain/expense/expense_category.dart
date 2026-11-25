/// 支出のカテゴリ。固定の7種類で、ユーザーは追加できない。
enum ExpenseCategory {
  /// チケット代。公演が必須。
  ticket,

  /// ドリンク代。公演が必須。
  drink,

  /// チェキ代。公演とチェキ相手・撮影枚数が必須。
  cheki,

  /// グッズ代。
  goods,

  /// 交通費。
  transport,

  /// コインロッカー代。
  locker,

  /// その他。
  other;

  /// 公演の紐づけが必須か。
  bool get requiresPerformance =>
      this == ticket || this == drink || this == cheki;
}

/// 支出を「どの日のものとして見せるか」の基準。残高の計算には使わない。
enum AccountingBasis {
  /// 支出の支払日に置く。
  paidOn,

  /// 紐づく公演の開始日に置く。公演に紐づかない支出は支払日。
  performanceDate,
}
