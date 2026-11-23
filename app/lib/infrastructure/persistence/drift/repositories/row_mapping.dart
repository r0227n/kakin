import 'package:app/application/application.dart';
import 'package:app/application/errors/app_exception.dart';
import 'package:app/application/errors/record_error.dart';
import 'package:app/domain/domain.dart';
import 'package:app/infrastructure/persistence/drift/app_database.dart';

/// DB の行を application の model に変換する。
extension PerformanceRowMapping on PerformanceRow {
  /// 公演の model。
  Performance toModel() => Performance(
    id: id,
    title: title,
    startsAt: startsAt.toUtc(),
    venue: venue,
  );
}

/// DB の行を application の model に変換する。
extension PartnerRowMapping on PartnerRow {
  /// チェキ相手の model。
  Partner toModel({
    LocalDate? firstShotOn,
    LocalDate? lastShotOn,
    int chekiCount = 0,
    int shotTotal = 0,
  }) => Partner(
    id: id,
    name: name,
    groupName: groupName,
    iconFile: iconFile,
    firstShotOn: firstShotOn,
    lastShotOn: lastShotOn,
    chekiCount: chekiCount,
    shotTotal: shotTotal,
  );
}

/// DB の失敗を application の公開例外に変換する。
Future<T> guardStorage<T>(Future<T> Function() action) async {
  try {
    return await action();
  } on AppException {
    rethrow;
  } on Object catch (error, stackTrace) {
    throw RecordStorageException(cause: error, causeStackTrace: stackTrace);
  }
}
