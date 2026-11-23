import 'package:app/application/errors/app_error_code.dart';
import 'package:app/application/errors/app_exception.dart';

/// 端末内の記録を読み書きできなかったことを表す。
final class RecordStorageException extends AppException {
  /// DB の失敗を保持する。
  const RecordStorageException({super.cause, super.causeStackTrace});

  @override
  AppErrorCode get code => AppErrorCode.recordStorage;
}

/// 入力の欄。表示する案内を選ぶために使う。
enum InputField {
  /// 金額。
  amount,

  /// 公演。
  performance,

  /// 公演名。
  title,

  /// チェキ相手。
  partner,

  /// 撮影枚数。
  shotCount,

  /// 名前。
  name,
}

/// 入力値が規則に合わないことを表す。
final class InvalidInputException extends AppException {
  /// 問題のある欄を保持する。
  const InvalidInputException(this.field);

  /// 問題のある欄。
  final InputField field;

  @override
  AppErrorCode get code => AppErrorCode.invalidInput;

  @override
  String toString() => 'InvalidInputException(${field.name})';
}

/// チェキ代の記録があるチェキ相手を削除しようとしたことを表す。
final class PartnerInUseException extends AppException {
  /// 対象の相手を削除しない。
  const PartnerInUseException();

  @override
  AppErrorCode get code => AppErrorCode.partnerInUse;
}

/// アイコン画像を選択・保存できなかったことを表す。
final class PartnerIconException extends AppException {
  /// plugin やファイルの失敗を保持する。
  const PartnerIconException({super.cause, super.causeStackTrace});

  @override
  AppErrorCode get code => AppErrorCode.partnerIcon;
}

/// 通知を予約できなかったことを表す。
final class ReminderScheduleException extends AppException {
  /// plugin の失敗を保持する。
  const ReminderScheduleException({super.cause, super.causeStackTrace});

  @override
  AppErrorCode get code => AppErrorCode.reminderSchedule;
}
