import 'package:app/domain/domain.dart';
import 'package:app/presentation/dependencies/application_providers.dart';
import 'package:app/presentation/shared/controllers/app_preferences_controller.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ledger_view_controller.freezed.dart';
part 'ledger_view_controller.g.dart';

/// カレンダーとリストで共有する、表示中の月と計上基準。
@freezed
abstract class LedgerView with _$LedgerView {
  /// 表示中の月と計上基準。
  const factory LedgerView({
    required YearMonth month,
    required AccountingBasis basis,
  }) = _LedgerView;
}

/// カレンダーとリストの表示中の月と計上基準を所有する。
///
/// 計上基準は設定の初期値から始め、画面での切り替えは保存しない。
@Riverpod(keepAlive: true)
class LedgerViewController extends _$LedgerViewController {
  @override
  LedgerView build() => LedgerView(
    month: JapanTime.dateOf(ref.read(clockProvider).now()).yearMonth,
    basis: ref.read(appPreferencesControllerProvider).defaultAccountingBasis,
  );

  /// 前の月へ移る。
  void showPreviousMonth() =>
      state = state.copyWith(month: state.month.previous);

  /// 次の月へ移る。
  void showNextMonth() => state = state.copyWith(month: state.month.next);

  /// [month] を表示する。
  void showMonth(YearMonth month) => state = state.copyWith(month: month);

  /// 計上基準を切り替える。
  void setBasis(AccountingBasis basis) => state = state.copyWith(basis: basis);
}
