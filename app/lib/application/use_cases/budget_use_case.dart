import 'package:app/application/errors/record_error.dart';
import 'package:app/application/ports/device_ports.dart';
import 'package:app/application/ports/record_repositories.dart';
import 'package:app/domain/domain.dart';

/// 推し活代の設定の入力境界。
final class BudgetUseCase {
  /// 保存先と時計を注入する。
  const BudgetUseCase(this._repository, this._clock);

  final BudgetRepository _repository;
  final Clock _clock;

  /// 推し活代の設定を読み込む。
  Future<BudgetPlan> loadPlan() => _repository.loadPlan();

  /// 日本時間の今月。
  YearMonth get currentMonth => JapanTime.dateOf(_clock.now()).yearMonth;

  /// 月額と開始月を設定する。
  ///
  /// 未設定なら開始月の月額として登録する。設定済みなら開始月を動かしてから、
  /// 今月（開始月が先なら開始月）からの月額を変える。
  Future<void> configure({
    required YearMonth startMonth,
    required int monthlyYen,
  }) async {
    _validateAmount(monthlyYen);
    final plan = await _repository.loadPlan();
    if (!plan.isConfigured) {
      await _repository.saveRate(startMonth, monthlyYen);
      return;
    }
    if (plan.startMonth != startMonth) {
      await _repository.moveStartMonth(startMonth);
    }
    final from = currentMonth.isBefore(startMonth) ? startMonth : currentMonth;
    final updated = await _repository.loadPlan();
    if (updated.monthlyRateAt(from) != monthlyYen) {
      await _repository.saveRate(from, monthlyYen);
    }
  }

  /// [month] だけの推し活代を設定する。開始月より前の月は設定できない。
  Future<void> setOverride(YearMonth month, int amountYen) async {
    _validateAmount(amountYen);
    final start = (await _repository.loadPlan()).startMonth;
    if (start == null || month.isBefore(start)) {
      throw const InvalidInputException(InputField.amount);
    }
    await _repository.saveOverride(month, amountYen);
  }

  /// [month] の上書きを解除し、月額に戻す。
  Future<void> clearOverride(YearMonth month) =>
      _repository.deleteOverride(month);

  void _validateAmount(int amountYen) {
    if (amountYen < 0) throw const InvalidInputException(InputField.amount);
  }
}
