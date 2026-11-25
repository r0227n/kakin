import 'package:app/domain/calendar/local_date.dart';

/// 推し活代の設定。月額の履歴と月ごとの上書きを持つ。
final class BudgetPlan {
  /// [rates] は「この月からこの月額」、[overrides] は「この月だけこの額」。
  BudgetPlan({
    Map<YearMonth, int> rates = const {},
    Map<YearMonth, int> overrides = const {},
  }) : rates = Map.unmodifiable(rates),
       overrides = Map.unmodifiable(overrides),
       _sortedRateMonths = rates.keys.toList()..sort();

  /// 推し活代が未設定の状態。
  static final BudgetPlan unconfigured = BudgetPlan();

  /// 月額の履歴。キーは月額を使い始める月。
  final Map<YearMonth, int> rates;

  /// 月ごとの上書き。
  final Map<YearMonth, int> overrides;

  final List<YearMonth> _sortedRateMonths;

  /// 推し活代を設定済みか。
  bool get isConfigured => _sortedRateMonths.isNotEmpty;

  /// 開始月。未設定なら null。
  YearMonth? get startMonth =>
      _sortedRateMonths.isEmpty ? null : _sortedRateMonths.first;

  /// [month] に使う月額（上書きを除く）。開始月より前なら null。
  int? monthlyRateAt(YearMonth month) {
    int? amount;
    for (final rateMonth in _sortedRateMonths) {
      if (rateMonth.isAfter(month)) break;
      amount = rates[rateMonth];
    }
    return amount;
  }

  /// [month] の推し活代（上書きを含む）。開始月より前なら null。
  int? budgetFor(YearMonth month) {
    final start = startMonth;
    if (start == null || month.isBefore(start)) return null;
    return overrides[month] ?? monthlyRateAt(month);
  }
}
