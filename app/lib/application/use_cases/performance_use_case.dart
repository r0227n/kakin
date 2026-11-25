import 'package:app/application/errors/record_error.dart';
import 'package:app/application/models/records.dart';
import 'package:app/application/models/views.dart';
import 'package:app/application/ports/device_ports.dart';
import 'package:app/application/ports/record_repositories.dart';
import 'package:app/domain/domain.dart';

/// 公演の登録・編集・削除と、今後の公演の入力境界。
final class PerformanceUseCase {
  /// 保存先と時計を注入する。
  const PerformanceUseCase(this._performances, this._clock);

  final PerformanceRepository _performances;
  final Clock _clock;

  /// すべての公演。開始日時の新しい順。
  Future<List<Performance>> listAll() => _performances.listAll();

  /// 今日以降に開始する、チケット代を記録した公演。開始日時の早い順。
  Future<List<UpcomingPerformance>> listUpcoming() async {
    final today = JapanTime.dateOf(_clock.now());
    final performances = await _performances.listUpcoming(today);
    return [
      for (final performance in performances)
        UpcomingPerformance(
          performance: performance,
          daysUntil: today.daysUntil(performance.startsOn),
        ),
    ];
  }

  /// [id] の公演。
  Future<Performance?> find(int id) => _performances.find(id);

  /// 公演を登録して ID を返す。
  Future<int> create(PerformanceDraft draft) =>
      _performances.create(_validated(draft));

  /// 公演を編集する。
  Future<void> update(int id, PerformanceDraft draft) =>
      _performances.update(id, _validated(draft));

  /// 削除すると一緒に消える支出。
  Future<PerformanceDeletionImpact> deletionImpact(int id) =>
      _performances.deletionImpact(id);

  /// 公演を、その公演が必須の支出と一緒に削除する。
  Future<void> delete(int id) => _performances.delete(id);

  PerformanceDraft _validated(PerformanceDraft draft) {
    final title = draft.title.trim();
    if (title.isEmpty) throw const InvalidInputException(InputField.title);
    final venue = draft.venue?.trim();
    return PerformanceDraft(
      title: title,
      startsAt: draft.startsAt.toUtc(),
      venue: venue == null || venue.isEmpty ? null : venue,
    );
  }
}
