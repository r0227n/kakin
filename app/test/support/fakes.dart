import 'dart:async';

import 'package:app/application/application.dart';
import 'package:app/core/logger/error_reporter.dart';
import 'package:app/domain/domain.dart';

/// 保存順序と失敗を制御できる、端末 API を使わない repository。
class FakeAppPreferencesRepository implements AppPreferencesRepository {
  /// 初期の保存値を指定する。
  FakeAppPreferencesRepository({
    this.snapshot = const AppPreferencesSnapshot(),
  });

  /// 保存に成功した値だけを保持する。
  AppPreferencesSnapshot snapshot;

  /// 各書き込み前の待機または失敗を注入する。
  Future<void> Function()? beforeSave;

  /// 書き込み開始順の記録。
  final List<String> operations = [];

  @override
  AppPreferencesSnapshot load() => snapshot;

  Future<void> _save(
    String operation, {
    AppThemePreference? theme,
    LocalePreference? locale,
    AccountingBasis? basis,
    bool? amountsVisible,
    Set<TicketDeadlineKind>? reminders,
    bool? onboardingCompleted,
    bool? permissionRequested,
  }) async {
    operations.add(operation);
    await beforeSave?.call();
    final s = snapshot;
    snapshot = AppPreferencesSnapshot(
      theme: theme ?? s.theme,
      locale: locale ?? s.locale,
      defaultAccountingBasis: basis ?? s.defaultAccountingBasis,
      amountsVisible: amountsVisible ?? s.amountsVisible,
      enabledReminderKinds: reminders ?? s.enabledReminderKinds,
      onboardingCompleted: onboardingCompleted ?? s.onboardingCompleted,
      notificationPermissionRequested:
          permissionRequested ?? s.notificationPermissionRequested,
    );
  }

  @override
  Future<void> saveTheme(AppThemePreference theme) =>
      _save('theme:${theme.name}', theme: theme);

  @override
  Future<void> saveLocale(LocalePreference locale) =>
      _save('locale:${locale.languageCode}', locale: locale);

  @override
  Future<void> saveDefaultAccountingBasis(AccountingBasis basis) =>
      _save('basis:${basis.name}', basis: basis);

  @override
  Future<void> saveAmountsVisible({required bool visible}) =>
      _save('amounts:$visible', amountsVisible: visible);

  @override
  Future<void> saveReminderEnabled(
    TicketDeadlineKind kind, {
    required bool enabled,
  }) => _save(
    'reminder:${kind.name}:$enabled',
    reminders: {
      ...snapshot.enabledReminderKinds.where((k) => k != kind),
      if (enabled) kind,
    },
  );

  @override
  Future<void> saveOnboardingCompleted() =>
      _save('onboarding', onboardingCompleted: true);

  @override
  Future<void> saveNotificationPermissionRequested() =>
      _save('permission', permissionRequested: true);
}

/// 報告を記録し、外部への送信を行わない。
class RecordingErrorReporter implements ErrorReporter {
  /// 報告された原因。
  final List<Object> errors = [];

  @override
  void report(Object error, StackTrace? stackTrace, {required String message}) {
    errors.add(error);
  }
}

/// 予約した通知を記録する。
class FakeReminderScheduler implements ReminderScheduler {
  /// 現在の許可の状態。
  NotificationPermission permission = NotificationPermission.notDetermined;

  /// 許可を求めたときの結果。
  NotificationPermission requestResult = NotificationPermission.granted;

  /// 許可を求めた回数。
  int requestCount = 0;

  /// 最後に予約した通知。
  List<ReminderNotification> scheduled = const [];

  /// 予約の失敗を注入する。
  Exception? replaceError;

  @override
  Future<NotificationPermission> permissionStatus() async => permission;

  @override
  Future<NotificationPermission> requestPermission() async {
    requestCount++;
    return permission = requestResult;
  }

  @override
  Future<void> replaceAll(List<ReminderNotification> reminders) async {
    if (replaceError case final error?) throw error;
    scheduled = reminders;
  }
}

/// ファイルを書かずに名前だけを管理する。
class FakePartnerIconStore implements PartnerIconStore {
  /// 保存済みのファイル名。
  final Set<String> files = {};

  var _next = 0;

  @override
  Future<String> save(String sourcePath) async {
    final name = 'icon_${_next++}.png';
    files.add(name);
    return name;
  }

  @override
  String? pathOf(String fileName) =>
      files.contains(fileName) ? '/icons/$fileName' : null;

  @override
  Future<void> delete(String fileName) async => files.remove(fileName);

  @override
  Future<void> deleteUnreferenced(Set<String> referenced) async =>
      files.removeWhere((f) => !referenced.contains(f));
}

/// 決まったパスを返す画像の選択。
class FakePartnerIconPicker implements PartnerIconPicker {
  /// 選ばれる画像。null ならキャンセル。
  String? result = '/tmp/picked.png';

  @override
  Future<String?> pick(PartnerIconSource source) async => result;
}

/// 進めるまで止まっている時計。
class FixedClock implements Clock {
  /// [instant] から始める。
  FixedClock(this.instant);

  /// 現在の瞬間（UTC）。
  DateTime instant;

  @override
  DateTime now() => instant;
}

/// 変更を手動で流す。
class ManualLocalDataChanges implements LocalDataChanges {
  final _controller = StreamController<void>.broadcast();

  /// 変更を知らせる。
  void notify() => _controller.add(null);

  @override
  Stream<void> watch() async* {
    yield null;
    yield* _controller.stream;
  }
}
