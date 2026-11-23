import 'package:app/application/errors/record_error.dart';
import 'package:app/application/models/records.dart';
import 'package:app/application/ports/record_repositories.dart';
import 'package:app/application/use_cases/reminder_use_case.dart';

/// 公演の登録・編集・削除の入力境界。
final class PerformanceUseCase {
  /// 保存先とリマインドを注入する。
  const PerformanceUseCase(this._performances, this._reminders);

  final PerformanceRepository _performances;
  final ReminderUseCase _reminders;

  /// すべての公演。開始日時の新しい順。
  Future<List<Performance>> listAll() => _performances.listAll();

  /// [id] の公演。
  Future<Performance?> find(int id) => _performances.find(id);

  /// 公演を登録して ID を返す。
  Future<int> create(PerformanceDraft draft) =>
      _performances.create(_validated(draft));

  /// 公演を編集する。開始日時が変わっても期限は変わらないが、表示のため予約し直す。
  Future<void> update(int id, PerformanceDraft draft) async {
    await _performances.update(id, _validated(draft));
    await _reminders.rebuild();
  }

  /// 削除すると一緒に消える支出とチケット申込。
  Future<PerformanceDeletionImpact> deletionImpact(int id) =>
      _performances.deletionImpact(id);

  /// 公演を削除し、予約済みの通知を組み立て直す。
  Future<void> delete(int id) async {
    await _performances.delete(id);
    await _reminders.rebuild();
  }

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
